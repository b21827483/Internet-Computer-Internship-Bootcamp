import Result "mo:base/Result";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Trie "mo:base/Trie";
import Text "mo:base/Text";

module {
    public type Result<T, E> = Result.Result<T, E>;
    public type Account = {owner : Principal; tokens : Tokens};   
    public type Proposal = {
        id: Nat;
        votes_no : Tokens;
        voters : List.List<Principal>;
        state : ProposalState;
        timestamp : Principal;
        votes_yes : Tokens;
        payload : ProposalPaylaod;
    };

    public type ProposalPaylaod = {
        method : Text;
        canister_id : Principal;
        message : Blob;
    };

    public type ProposalState = {
        #failed : Text;
        #open;
        #executing;
        #rejected;
        #succedded;
        #accepted;
    };

    public type Tokens = { amount_e8s : Nat };
    public type TransferArgs = { to : Principal; amount : Tokens};
    public type UpdateSystemParamsPayload = {
        transfer_fee : ?Tokens;
        proposal_vote_threshold : ?Tokens;
        proposal_submission_deposit : ?Tokens;
    };

    public type Vote = {#no; #yes};
    public type VoteArgs = {vote : Vote; proposal_id : Nat};
    
    public type SystemParams = {
        transfer_fee : Tokens;
        proposal_vote_threshold : Tokens;
        proposal_submission_deposit : ?Tokens;
    };

    public type BasicDaoStableStorage = {
        accounts: [Account];
        proposals: [Proposal];
        system_params : SystemParams;
    };

    public func proposal_key(t: Nat) : Trie.Key<Nat> = {key=t; hash=Int.hash t};
    public func account_key(t: Principal) : Trie.Key<Principal> = {key = t; hash=Principal.hash t};
    public func accounts_fromArray(arr : [Account]) : Trie.Trie<Principal, Tokens> {
        var s = Trie.empty<Principal, Tokens>();
        for (account in arr.vals()) {
            s := Trie.put(s, account_key(account.owner), Principal.equal, account.tokens).0;
        };
        s
    };

    public func proposals_fromArray(arr: [Proposal]) : Trie.Trie<Nat, Proposal> {
        var s = Trie.empty<Nat, Proposal>();
        for (proposal in arr.vals()) {
            s:= Trie.put(s, proposal_key(proposal.id), Nat.equal, proposal).0;
        };
        s
    };

    public let oneToken = {amount_e8s = 10_000_000};
    public let zeroToken = {amount_e8s = 0};



};