#Organization: {
	name: string
}

#Provider: {
	organization: #Organization
	testers: [...string]
}

#Recipient: {
	organization: #Organization
}

#Reproduction: {
	poc?: string
	steps?: [...string]
	description?: string
}

#Affected: {
	"file"?:   string
	"code"?:   string
	"system"?: string
}

#Finding: {
	id:          string
	title:       string
	severity?:   string
	description: string
	risk:        string
	affected?: [...#Affected]
	reproduction: #Reproduction
	mitigation:   string
}

#Document: {
	schemaVersion: string
	provider:      #Provider
	recipient:     #Recipient
	introduction:  string
	scope: [...string]
	findings: [...#Finding]
}

#Document
