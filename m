Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906BD14080F
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 11:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgAQKgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 05:36:43 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33121 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726085AbgAQKgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 05:36:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6AAD421B2B;
        Fri, 17 Jan 2020 05:36:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 Jan 2020 05:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=zysE2vfsh8RYHDgl7OqOaN4tYLh
        R2XvhvACmMgZFGng=; b=GSzG5OiDDy1rYVC+OygEUkgG/hmot7g5uaukIiWA4EM
        8e5IyoxR/dMQWNPnAH3sxuB0XNhDdIGMzk7DqFELM3CMwydID6ZqjqbvmIaUnjG8
        iy1S4EX6aXvGqJdudz5KXw5aG0OLJDGjBvapdCuuhA2uCDOFa7tTQ/FWPVW3bxso
        ttDYtiKbh/MlNm+Q9T/eWawcyGwrr3ImaXfu8kBILWfd+DZGUOL8bht5A1T/WP+O
        LeZNDP5GilkOOhhkDd6t10S9+kPOh8GHkI4qJCz/NRMmeuqdSi50kxjZiJpol4fE
        i59Hs83AnYlsy4MdN+GnQwxPE5FJGzmWesWntRwhvJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zysE2v
        fsh8RYHDgl7OqOaN4tYLhR2XvhvACmMgZFGng=; b=XmrTQkrB2lhUW5SW/C0IXj
        TYjwfiUWVaYolcy1+Xl1ZuuJFQgGagnpYchGFHTyX1FEC2zzcgLPfy7BcoxvBuXY
        04AS61I0J4CzU7SeWEUnX/T7PITR/NiAcbsXGAnzDTXAO2ivDSu1l56F+fxdzOKS
        lC8JyUfBbK/DRN4cequ56EGx+nL14UR1oS/XQJR5Bl4pDVzagatsA4uXE7msYhBC
        jVEi0q4+I0++sp4zfwKARfeB43ZlycuGIJ+uX9ZD6A10E0o0c/jtTkmclYpEkuqj
        //z+rSQuN4lobtH9G1FxviP9otP9OoVuKiANofhwrrg/9dZ3J1UBSvZ5MOmRAvMA
        ==
X-ME-Sender: <xms:OY4hXudSsFir1jfFpDYyO0rTlWtubXRA2Zp78g4kFROce6ZcWlnDnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdejgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OY4hXqn89M-AH0dju1h0OdSWAakLDf3qCbnBp3PoqoAygOf_x6dQjg>
    <xmx:OY4hXoxrrhkw0fyDEs7ePDd71vLFN6wRexo7s9KcvV8X-xuc6eB6TA>
    <xmx:OY4hXvE9tLywBmuZnKuRp5EjTAVZiQiaWnzRGWm3sGLR-TqAS5TjsQ>
    <xmx:OY4hXscfvbQk5tF6JAcYAW8DS9zMPZzZQVp5j1H6Jh6_E9fkp11BYQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A87428005B;
        Fri, 17 Jan 2020 05:36:40 -0500 (EST)
Date:   Fri, 17 Jan 2020 11:36:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: serial: quatech2: handle unbound ports
Message-ID: <20200117103639.GA1835567@kroah.com>
References: <20200117095026.27655-1-johan@kernel.org>
 <20200117095026.27655-6-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117095026.27655-6-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 10:50:26AM +0100, Johan Hovold wrote:
> Check for NULL port data in the event handlers to avoid dereferencing a
> NULL pointer in the unlikely case where a port device isn't bound to a
> driver (e.g. after an allocation failure on port probe).
> 
> Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
> Cc: stable <stable@vger.kernel.org>     # 3.5
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/quatech2.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
> index a62981ca7a73..c76a2c0c32ff 100644
> --- a/drivers/usb/serial/quatech2.c
> +++ b/drivers/usb/serial/quatech2.c
> @@ -470,6 +470,13 @@ static int get_serial_info(struct tty_struct *tty,
>  
>  static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
>  {
> +	struct qt2_port_private *port_priv;
> +
> +	/* May be called from qt2_process_read_urb() for an unbound port. */
> +	port_priv = usb_get_serial_port_data(port);
> +	if (!port_priv)
> +		return;
> +

Where is the null dereference here?  Will port be NULL somehow?

>  	switch (*ch) {
>  	case QT2_LINE_STATUS:
>  		qt2_update_lsr(port, ch + 1);
> @@ -484,14 +491,27 @@ static void qt2_process_status(struct usb_serial_port *port, unsigned char *ch)
>  static void qt2_process_xmit_empty(struct usb_serial_port *port,
>  				   unsigned char *ch)
>  {
> +	struct qt2_port_private *port_priv;
>  	int bytes_written;
>  
> +	/* May be called from qt2_process_read_urb() for an unbound port. */
> +	port_priv = usb_get_serial_port_data(port);
> +	if (!port_priv)
> +		return;
> +
>  	bytes_written = (int)(*ch) + (int)(*(ch + 1) << 4);

What's the harm in doing a pointless calculation here?  Nothing seems to
happen in this function at all.

>  }
>  
>  /* not needed, kept to document functionality */
>  static void qt2_process_flush(struct usb_serial_port *port, unsigned char *ch)
>  {
> +	struct qt2_port_private *port_priv;
> +
> +	/* May be called from qt2_process_read_urb() for an unbound port. */
> +	port_priv = usb_get_serial_port_data(port);
> +	if (!port_priv)
> +		return;
> +
>  	return;
>  }

This whole function can just be removed, right?

thanks,

greg k-h
