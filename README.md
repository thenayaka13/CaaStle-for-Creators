**Problem Statement** </br>
The communication of CaaStle, done through the Account Managers, with Creators (People behind Branded Affiliates) is inefficient and unorganized.
There are 3 main use-cases of communication between Account Managers and and Creators:
- Delivering the Payment Statement (FRP) to the Creator, along with any additional comments. Currently this is done via e-mail and one-on-one conversations between Creator and AM. This poses issues like:
a. Manual effort spent in sending the statements each month to each Creator
b. With tracking which statement was sent to which Creator
c. Both AM and Creator find it difficult to access past statements
- One-on-one conversations between Account Managers and Creators
These conversations take place on e-mails and in meetings. It is difficult to access conversations from the past since the conversations are not stored in a single place.
- Official communication from CaaStle to multiple Creators
The use-cases include communication about CaaStle initiatives like “Multi-Plan” and “Powered by Haverdash”. Other use cases might include urging Creators who have been inactive to post about the service or communication of Plan Upgrades/Downgrades to Creators.
All these communications, which need to be done at scale, are done one at a time by AMs and take considerable effort. Status updates about such initiatives also need to be communicated one at a time and take considerable manual effort from AMs.

**Need for Solution** </br>
The need centers on three core issues: operational efficiency, scalability, and Creator engagement. 
Currently, AMs are burdened by the manual process of delivering payment statements. As the number of Creators in our BA program increases, this one-to-one communication model becomes increasingly unsustainable. 
This inefficiency not only threatens to disengage Creators but also poses risks to revenue, customer satisfaction, and overall business growth. 
There's a clear opportunity to address these challenges by developing a centralized tool that not only reduces the AM team's effort but also keeps Creators more engaged with our service.

**Solution Goals** </br>
We want to create two products:
- A Creator side iOS mobile application
- A Account Manager side web portal

Here are the broad solution goals:

<table>
    <tr>
        <td>Feature</td>
        <td>User Story</td>
        <td>Details</td>
    </tr>
    <tr>
        <td>Creator App:<br>Payment Statement Page</td>
        <td>As a Creator,<br>I want to be able to view all my payment statements in one place, with ability to download them,<br>So that, I can access them easily at any time</td>
        <td>Creators will be able to view Payment Statements from latest to oldest.<br>They will be able to sort them and filter them by Month and Year.<br>Creators will only be able to see the latest version of the statement for each Month-Year combination.</td>
    </tr>
    <tr>
        <td>Payment Statement Page</td>
        <td>As a CS team member,<br>I need the the Payment Statements to be delivered to the Creators automatically<br>So that, I don’t have to send them out manually to all creators.</td>
        <td>The automated job which converts the Tableau panels into Google Sheets will get modified to store Statements in a DB. <br>Creator App and AM Web Portal will fetch statements from there.</td>
    </tr>
    <tr>
        <td>Web Portal:<br>Payment Statement Page</td>
        <td>As an Account Manager,<br>I want to be able to see every Payment Statement that has been sent to any Creator,<br>So that I can refer to them with ease when required.</td>
        <td>AM will be able to choose which Creator’s statement they want to see. They’ll be able to view every statement sent to the Creator in one place.<br>AM will also be able to toggle the automated delivery of the statement to any Creator. <br>This may be done because the statement might have inaccuracy, because we want to hold payment to a creator etc.</td>
    </tr>
    <tr>
        <td>Creator App:<br>Chat</td>
        <td>As a Creator,<br>I want to have a one-on-one chat with my assigned Account Manager,<br>So that, I can easily send messages to them and have all my conversation history in one place.</td>
        <td>The Creator will be able to open a chat with their AM from their app at any time. They will be able to send messages to the AM.<br>The chat will have the entire history of their conversation with the AM.<br>They’ll also get notified when they’ve received a new message from their AM.</td>
    </tr>
    <tr>
        <td>Web Portal:<br>Chat</td>
        <td>As an Account Manager,<br>I need, all the chats with the Creators I manage to be available in one place,<br>So that, I can answer all their queries with minimum effort.</td>
        <td>AM will be able to view the chats which have at least one message AND if the Creator is assigned to the AM.<br>They will also be able to search chats and initiate chats with Creators assigned to them.</td>
    </tr>
    <tr>
        <td>Creator App:<br>Feed</td>
        <td>As a Creator,<br>I want to view every piece of official communication about CaaStle’s initiatives in one place<br>So that, I don’t miss any updates from CaaStle and can access them easily.</td>
        <td>Creators will be able to view posts from CaaStle in a feed. <br>Only the recipient Creators of each post will be able to see them in their feed.</td>
    </tr>
    <tr>
        <td>Web Portal:<br>Feed</td>
        <td>As an Account Manager,<br>I need to broadcast communication to multiple Creators at the same time,<br>So that, I can save my manual effort.</td>
        <td>AMs will be able to write posts (image or text) and decide the recipients of the post.<br>They will also be able to view logs of each post that has been sent alongwith its recipient list.</td>
    </tr>
    <tr>
        <td>Creator App:<br>Profile Page</td>
        <td>As a Creator,<br>I want to be able to view all the information related to me at one place<br>So that, I can refer to it with ease.</td>
        <td>Creators will be able to view their added contact information, their Complimentary Subscription’s validity and plan size and their AM’s information.</td>
    </tr>
    <tr>
        <td>Web Portal:<br>Profile Page</td>
        <td>As an Account Manager,<br>I need to be able to view all my profile information, including a list of all Creators assigned to me,<br>So that, I can refer to it easily at any time for reference.</td>
        <td></td>
    </tr>
    <tr>
        <td>Web Portal: Onboarding</td>
        <td>As an Account Manager,<br>I need to be able to create new Creator Profiles,<br>So that, I can generate credentials for them to start using the Creator App and they can be assigned to an Account Manager.</td>
        <td>The Account Manager will enter all the details of the Creator and assign an AM to them.<br>Later on, this can become the source of information for the CMP or the CMP can become a source for this information.<br>A single use “CaaStle Creator Code” will be generated for each onboarded Creator so that they can sign up to the App. This ensures that only CaaStle Creators can use the app.</td>
    </tr>
    <tr>
        <td>Web Portal:<br>Creator Information Page</td>
        <td>As an Account Manager,<br>I need to be able to view and edit Creator information, including changing the Account Manager assigned to them,<br>So that, I can view Creator information with ease and keep the Creator profiles updated with the right information.</td>
        <td></td>
    </tr>
</table>
