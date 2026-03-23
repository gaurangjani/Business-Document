namespace DefaultPublisher;

using System.AI;

codeunit 50301 "Copilot Install"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        BillingType: Enum "Copilot Billing Type";
        LearnMoreUrlTxt: Label 'https://example.com/CopilotToolkit', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Request Copilot") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Request Copilot", Enum::"Copilot Availability"::Preview, BillingType, LearnMoreUrlTxt);
    end;
}