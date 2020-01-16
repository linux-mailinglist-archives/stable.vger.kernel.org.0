Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0C13DFCA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPQSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:18:34 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38059 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgAPQSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 11:18:34 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E578F2227F;
        Thu, 16 Jan 2020 11:18:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 16 Jan 2020 11:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=07X6qRMK0Px/dKmBtZxcPHfBL1U
        lPR0tIauYEzAigpY=; b=ncSlWLgNcr3sNgec8rqVNm6lME7LtFrquOVwaOKoB7m
        Y8AHkVBB2ux32PYWdjV3nfy7F2pPIEfRF5KUUfcS5LBKNvm3njp6HR+89VR4FtU9
        yGtIg8agkoSnn2BikxaYcHyEY1Nz/yJj7JczlSUHaEtLW8ixGjTp5hANgLwMHscv
        TPSmXh/kZ1zUkwpe8BK1D/b+vuzyzyih+hnBAFWI2LEAuR9ihbF0/R9zfiTM3wOX
        bXEaczZVG+z4ExmR3pQEG13OEfadAsGTk/OG+3nD11n1ebUp8wR43YtvxMy1ShlP
        IpFEV3WfF9qx+RYVoXNOqII+tAQKWsrOk4pU7+M4rOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=07X6qR
        MK0Px/dKmBtZxcPHfBL1UlPR0tIauYEzAigpY=; b=n4IOWUjT+0uQLGEMzXEJ4D
        h0boZTnLXz/VOalQtszchgo1atM26P593hiPDmPvzF+z98BaYOHYqcgg1w95JzFN
        My2wNEgZKnVDiPChFtVCK1CjX2b3ABCRasks3jBjrTIKJYqsn1Tx1g7Mt4a5eJbA
        HGMGwzzK4IUCoJwBJP9p3Ieqs1w557nAnuQJeZOmwGJ3vLsx603pyJQ2RcMm4F88
        JprxgP85AMQiC8iUu2Qk3GzjqJ4XM/AqkU1OSDBXPly/4q78cx2EPsdOgUm47FSa
        v+fqLJZwjV1AUvyg0+FxLNFZW+GdNc6YbB++ArmpoF/kd698lQ/1fvfBdaafB9jA
        ==
X-ME-Sender: <xms:2IwgXr68oVCquLYNDDmr2ytGSngqvigt8e1WEY4ROsk1ucrM0UG1Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdehgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:2IwgXmWmMDhyS74_HloOmhCDL-AA10BQF_Ww-CPNRhaNOAf5UhpY3w>
    <xmx:2IwgXnO2WHASO-jfcCtcTQQym4yp82oiCG5qqpauHKT8HMqKClAOrw>
    <xmx:2IwgXtFpKLpOS_7_0HaDKnSDl62-hc03uKPxxf6zOxrgbrTJnjmr5g>
    <xmx:2IwgXvEIWoZ1DiNo311cVqqPlaKHf_6glbpYoivdKQBOZabiFHZTEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64CA68005B;
        Thu, 16 Jan 2020 11:18:32 -0500 (EST)
Date:   Thu, 16 Jan 2020 17:18:29 +0100
From:   Greg KH <greg@kroah.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: suppress driver bind attributes
Message-ID: <20200116161829.GA909791@kroah.com>
References: <20200116160705.5199-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116160705.5199-1-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 05:07:05PM +0100, Johan Hovold wrote:
> USB-serial drivers must not be unbound from their ports before the
> corresponding USB driver is unbound from the parent interface so
> suppress the bind and unbind attributes.
> 
> Unbinding a serial driver while it's port is open is a sure way to
> trigger a crash as any driver state is released on unbind while port
> hangup is handled on the parent USB interface level. Drivers for
> multiport devices where ports share a resource such as an interrupt
> endpoint also generally cannot handle individual ports going away.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/usb-serial.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index 8f066bb55d7d..dc7a65b9ec98 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
>  		return -EINVAL;
>  	}
>  
> +	/* Prevent individual ports from being unbound. */
> +	driver->driver.suppress_bind_attrs = true;

We can still unbind the usb driver though, right?  If so, this is fine
with me.

thanks,

greg k-h
