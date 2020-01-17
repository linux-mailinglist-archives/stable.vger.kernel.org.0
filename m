Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72969140A7A
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 14:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAQNOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 08:14:00 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50609 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgAQNOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 08:14:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E14921FE7;
        Fri, 17 Jan 2020 08:13:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 Jan 2020 08:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=OP6ZcN4DmTLINNDWSgGucEuwmSU
        yDJD9qfT3wiwoPVg=; b=o91y1J8uQHYW3ibQGJsFo6iYeCnNSH80M/QXfVIsbwW
        jpvMkbER60ajtUC4KL4aj5x/WtHDZlNbQBE+MsMC3c6poFsq1l/JkGhOI7zw9Jzq
        +ZsWtDRiSOSiVFIEL7JlB2lbQ/gSOmlBDeYzIZatb/ghBTsndKkMcHxFg4ILgvdX
        L6rmeSuHBLXCoP/qryK3U3teM8wa3HxU8LADYeWDdGZDp3hduOpvD0EA6SP8fixT
        b7V340s3FMAU0JjW9zngpwzID0ik1a+vMU62rANp11UmcvPqgbhU6x5dK4M8SqV2
        K6ktA/k4eTf113VaJufaW5n87mcWB9VNcmB0+twY/9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OP6ZcN
        4DmTLINNDWSgGucEuwmSUyDJD9qfT3wiwoPVg=; b=YNeYnZT1+Vq6Gfwvx1/oc6
        ijJ2ocHutvqIUP2Cbbclc/IjNCDfnsg1vkkZDUxKgqqi4cfoQnFtaojfahGX2pZY
        QLPoCWNhYw8M5rvUPVx6GcXnaYkbI8eehhszgvYoOgLmCeoBqH9W/CvWNAxWkr5a
        LI9mNcDmXnJ534Azb0cLv19rOPW+Zncg9CtEIVn16v0V+Dsh4B9BXStbwH6cbHbZ
        qggCpXeevGcfhgxohccbouRplU0Nq/Kr8wPhkqYlAkOdSQir4X55rHF11H8gW4+6
        +mImGs3odCDR3wmmefWIcz9R2kg3UDtSsaqwzgWWRX76tFjIHm0ZCNc3Tni2+lkQ
        ==
X-ME-Sender: <xms:FrMhXmu78WhEkNIYPWST0y1zbj0DEPA3H-0RVwEvogpNsX050OW_ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdejgdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:FrMhXievIdHW-SoRKKog664Jqfvg06oQPoy9UPDoYnZxh6EC00dL7A>
    <xmx:FrMhXmyrkgaVXQf59d-xiNsVqBDzcGwG4EJZrSbnDctbUCNKloH4zQ>
    <xmx:FrMhXgETJhsUL4f--_QCw9yaZpXDrzDuZdDq3BFA7FVMJV3aE1eGEQ>
    <xmx:F7MhXofBRGXcIfv6Vq1XHA_h3QR5WpEeQkGUHoY90MDzQDvZtFZb8w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 884C380064;
        Fri, 17 Jan 2020 08:13:58 -0500 (EST)
Date:   Fri, 17 Jan 2020 14:13:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: serial: quatech2: handle unbound ports
Message-ID: <20200117131356.GB1848214@kroah.com>
References: <20200117095026.27655-1-johan@kernel.org>
 <20200117095026.27655-6-johan@kernel.org>
 <20200117103639.GA1835567@kroah.com>
 <20200117105317.GU2301@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117105317.GU2301@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 11:53:17AM +0100, Johan Hovold wrote:
> On Fri, Jan 17, 2020 at 11:36:39AM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Jan 17, 2020 at 10:50:26AM +0100, Johan Hovold wrote:
> > > Check for NULL port data in the event handlers to avoid dereferencing a
> > > NULL pointer in the unlikely case where a port device isn't bound to a
> > > driver (e.g. after an allocation failure on port probe).
> > > 
> > > Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
> > > Cc: stable <stable@vger.kernel.org>     # 3.5
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  drivers/usb/serial/quatech2.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
> > > index a62981ca7a73..c76a2c0c32ff 100644
> > > --- a/drivers/usb/serial/quatech2.c
> > > +++ b/drivers/usb/serial/quatech2.c
> > > @@ -470,6 +470,13 @@ static int get_serial_info(struct tty_struct *tty,
> > >  
> > >  static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
> > >  {
> > > +	struct qt2_port_private *port_priv;
> > > +
> > > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > > +	port_priv = usb_get_serial_port_data(port);
> > > +	if (!port_priv)
> > > +		return;
> > > +
> > 
> > Where is the null dereference here?  Will port be NULL somehow?
> 
> The NULL-dereference happens in qt2_update_lsr() and qt2_update_msr()
> called below.

Ah, ok.

> > >  	switch (*ch) {
> > >  	case QT2_LINE_STATUS:
> > >  		qt2_update_lsr(port, ch + 1);
> > > @@ -484,14 +491,27 @@ static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
> > >  static void qt2_process_xmit_empty(struct usb_serial_port *port,
> > >  				   unsigned char *ch)
> > >  {
> > > +	struct qt2_port_private *port_priv;
> > >  	int bytes_written;
> > >  
> > > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > > +	port_priv = usb_get_serial_port_data(port);
> > > +	if (!port_priv)
> > > +		return;
> > > +
> > >  	bytes_written = (int)(*ch) + (int)(*(ch + 1) << 4);
> > 
> > What's the harm in doing a pointless calculation here?  Nothing seems to
> > happen in this function at all.
> 
> Right, none at all.
> 
> Both of these handler appear to be here for documentation purposes. In
> case any one ever adds code here, they need to be aware that the port
> data may be NULL.
> 
> I should have mentioned this in the commit message and perhaps split
> the last two checks in a separate patch as they do not need to be
> backported. 
> 
> The alternative would be a more intrusive change handling an unbound
> port entirely in qt2_process_read_urb().
> 
> > >  }
> > >  
> > >  /* not needed, kept to document functionality */
> > >  static void qt2_process_flush(struct usb_serial_port *port, unsigned char *ch)
> > >  {
> > > +	struct qt2_port_private *port_priv;
> > > +
> > > +	/* May be called from qt2_process_read_urb() for an unbound port. */
> > > +	port_priv = usb_get_serial_port_data(port);
> > > +	if (!port_priv)
> > > +		return;
> > > +
> > >  	return;
> > >  }
> > 
> > This whole function can just be removed, right?
> 
> Yep, just "kept to document functionality" the header says.
> 
> I'll respin this last one in some way, thanks.

Nah, that's fine, this is ok as-is, thanks.

greg k-h
