# Decentralized Certificate Verification System


## Project Title
Decentralized Certificate Verification System


## Project Description
A minimal Ethereum smart contract that enables authorized institutions to issue and manage certificate records on-chain by storing cryptographic hashes (and optional IPFS CIDs) of certificate files. Verifiers (employers, institutions) can confirm authenticity by recomputing the certificate hash off-chain and matching it with the on-chain record.


## Project Vision
Create a lightweight, tamper-resistant verification layer for digital certificates that reduces fraud, speeds up verification, and keeps actual certificate files off-chain for privacy and cost-efficiency.


## Key Features
- **Core functions (2–3):** `issueCertificate`, `verifyCertificate`, `revokeCertificate` — the essential workflow for issuing, validating, and revoking certificates.
- **Issuer management:** contract owner can add/remove authorized issuers.
- **IPFS integration (optional):** store certificate files in IPFS and save CID on-chain for retrieval.
- **Events for off-chain indexing:** events emitted during issue/revoke allow easy indexing by The Graph or other services.
- **Lightweight on-chain storage:** only hashes and small metadata are stored on-chain.


## Future Scope
- Integrate OpenZeppelin AccessControl for granular roles.
- Add batch issuance and off-chain signing to support large institutions.
- Build a React + ethers.js frontend with QR-code based verification and IPFS file viewer.
- Add cryptographic signatures (ECDSA) so issuers can sign certificates off-chain and submit proofs on-chain.
- Connect to The Graph for fast querying and history views.
- Add multi-sig for high-trust issuers and DAO governance for the issuer list.

  contract address : 0xa70adf68517b2e1b4673f8c73b375922ff3159ae

<img width="1347" height="594" alt="image" src="https://github.com/user-attachments/assets/ce6c4389-6bd7-40b5-b810-0422dee9ffe6" />

