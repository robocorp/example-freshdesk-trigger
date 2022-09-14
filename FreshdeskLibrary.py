from freshdesk.api import API

class FreshdeskLibrary:

    def __init__(self):
        return

    def auth_with_apikey(self, domain, apikey):
        self.a = API(domain, apikey)

    def get_ticket(self, ticket_id):
        return self.a.tickets.get_ticket(int(ticket_id))

    def list_tickets(self):
        return self.a.tickets.list_tickets()

    def update_ticket(self, ticket_id, **kwargs):
        return self.a.tickets.update_ticket(int(ticket_id), **kwargs)

    def create_note(self, ticket_id, text, private):
        return self.a.comments.create_note(int(ticket_id), text, private=private)