// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Decentralized Certificate Verification System (Project.sol)
 * @notice Minimal contract with 2-3 core functions: issue, verify, revoke
 * @dev Stores certificate metadata (hash and optional IPFS CID). Includes basic issuer management.
 */
contract Project {
    address public owner;

    struct Certificate {
        bytes32 certHash;    // keccak256 hash of the certificate content
        string ipfsCid;      // optional IPFS CID for the certificate file (kept off-chain)
        address issuedBy;    // issuer address
        uint256 issuedAt;    // timestamp
        bool revoked;        // revocation flag
    }

    // certificateId => Certificate
    mapping(string => Certificate) private certificates;

    // authorized issuer addresses
    mapping(address => bool) public issuers;

    // Events
    event IssuerAdded(address indexed issuer);
    event IssuerRemoved(address indexed issuer);
    event CertificateIssued(string indexed certId, bytes32 certHash, string ipfsCid, address indexed issuedBy);
    event CertificateRevoked(string indexed certId, address indexed revokedBy);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyIssuer() {
        require(issuers[msg.sender], "Not an authorized issuer");
        _;
    }

    constructor() {
        owner = msg.sender;
        issuers[msg.sender] = true; // deployer is initial issuer
        emit IssuerAdded(msg.sender);
    }

    /**
     * CORE FUNCTION - Issue a certificate
     * @dev Core function #1: issues a certificate by storing its hash and optional IPFS CID
     */
    function issueCertificate(string calldata certId, bytes32 certHash, string calldata ipfsCid) external onlyIssuer {
        require(bytes(certId).length > 0, "Invalid certId");
        require(certHash != bytes32(0), "Invalid certHash");
        Certificate storage existing = certificates[certId];
        require(existing.issuedAt == 0, "Certificate already exists");

        certificates[certId] = Certificate({
            certHash: certHash,
            ipfsCid: ipfsCid,
            issuedBy: msg.sender,
            issuedAt: block.timestamp,
            revoked: false
        });

        emit CertificateIssued(certId, certHash, ipfsCid, msg.sender);
    }

    /**
     * CORE FUNCTION - Verify a certificate
     * @dev Core function #2: returns true if certificate exists, not revoked, and hash matches
     */
    function verifyCertificate(string calldata certId, bytes32 certHash) external view returns (bool) {
        Certificate storage c = certificates[certId];
        if (c.issuedAt == 0) return false;
        if (c.revoked) return false;
        return (c.certHash == certHash);
    }

    /**
     * CORE FUNCTION - Revoke a certificate
     * @dev Core function #3: issuer who created the certificate or contract owner can revoke
     */
    function revokeCertificate(string calldata certId) external {
        Certificate storage c = certificates[certId];
        require(c.issuedAt != 0, "Certificate not found");
        require(!c.revoked, "Already revoked");
        require(msg.sender == c.issuedBy || msg.sender == owner, "Not authorized to revoke");

        c.revoked = true;
        emit CertificateRevoked(certId, msg.sender);
    }

    /**
     * Helper: add an issuer (owner only)
     */
    function addIssuer(address _issuer) external onlyOwner {
        require(_issuer != address(0), "Zero address");
        issuers[_issuer] = true;
        emit IssuerAdded(_issuer);
    }

    /**
     * Helper: remove an issuer (owner only)
     */
    function removeIssuer(address _issuer) external onlyOwner {
        issuers[_issuer] = false;
        emit IssuerRemoved(_issuer);
    }

    /**
     * Helper: read certificate metadata for frontends
     */
    function getCertificate(string calldata certId) external view returns (bytes32 certHash, string memory ipfsCid, address issuedBy, uint256 issuedAt, bool revoked) {
        Certificate storage c = certificates[certId];
        require(c.issuedAt != 0, "Certificate not found");
        return (c.certHash, c.ipfsCid, c.issuedBy, c.issuedAt, c.revoked);
    }
}

