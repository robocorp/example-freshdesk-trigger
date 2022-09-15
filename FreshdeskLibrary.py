from freshdesk.api import API

class FreshdeskLibrary:

    def __init__(self):
        self.api = None
        return

    def auth_with_apikey(self, domain, apikey):
        self.api = API(domain, apikey)

    def get_ticket(self, ticket_id:int):
        return self.api.tickets.get_ticket(ticket_id)

    def list_tickets(self):
        return self.api.tickets.list_tickets()

    def update_ticket(self, ticket_id:int, **kwargs):
        return self.api.tickets.update_ticket(ticket_id, **kwargs)

    def create_note(self, ticket_id:int, text:str, private:bool):
        return self.api.comments.create_note(ticket_id, text, private=private)