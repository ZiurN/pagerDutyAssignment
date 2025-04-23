import { LightningElement, track } from "lwc";
import searchContactsByWebsite from "@salesforce/apex/ContactSearchController.searchContactsByWebsite";

const COLUMNS = [
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Email", fieldName: "Email", type: "email" },
  { label: "Title", fieldName: "Title", type: "text" },
  { label: "Created Date", fieldName: "CreatedDate", type: "date" },
];

export default class ContactSearch extends LightningElement {
  columns = COLUMNS;
  website = "";
  @track contacts;
  handleChange(event) {
    this.website = event.detail.value;
  }
  handleSearch() {
    searchContactsByWebsite({ websiteInput: this.website })
      .then((result) => {
        this.contacts = result;
      })
      .catch((error) => {
        console.error(error);
      });
  }
}
