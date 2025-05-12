"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = void 0;
exports.config = {
	url: "http://localhost:8004",
	port: "8004",
	appSecret: "öoisuhdhayuhgwyugus",
	db: {
		host: "demo-verifier-db",
		port: "3306",
		username: "verifier",
		password: "verifier",
		dbname: "verifier"
	},
	display: [],
	issuanceFlow: {
		skipConsent: false,
		defaultCredentialConfigurationIds: [],
	},
	appType: 'VERIFIER',
	wwwalletURL: "http://localhost:3000/cb",
	trustedRootCertificates: [],
	sessionIdCookieConfiguration: {
		maxAge: 900000,
		secure: false
	}
};