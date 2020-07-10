Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7A21B33B
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJKgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:36:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55087 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgGJKgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:36:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 50DA35C01ED;
        Fri, 10 Jul 2020 06:36:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 10 Jul 2020 06:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=g
        SSmBGAat7cyRrfCecEmKUbWAv2icxzDzFG/ZQyaM8w=; b=mDaj+yKS4j+FfMSHg
        SZ0BStHySaiJq3AuT+DjmADMnqM2VqRWu9G287R/601VNLantWljFU6jKM+b8Rqj
        P73Uou05pB0c73uB8m/I7frRaSq1TYY05DBefWMGXwqToHSs2fJafEeETRE50V7e
        EkhmkCeAmCZWB6kKqx/pJAeYXQA5ih7+dItPGBNKw3vlhW1SEDxzfDOqEyatXcXm
        kAlQPgSu/U9q/fBqxrNozEkgqVYnvhCiVmQz6yWstYplQa+B0FaLo48v4L4ltBrZ
        1SRs1n3Tob7vNaRETgcLAnaoi+KRmNxlUzVNTog0KfF4rt6wD1Sk839Snx+F3EMX
        dDn4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=gSSmBGAat7cyRrfCecEmKUbWAv2icxzDzFG/ZQyaM
        8w=; b=epyeURkReEl37bXH+CUzyhoESLAK+DVHhlT48TzW+6LC+ASxURPVQsiZd
        R3qpZ8dIaI4JUmYysXcWtWxksXU/pT8JQGnWIsxhQy3Czve66DhWdW8ZxVsd27eh
        4pWqgxggxrmea3Dt1c0jib80XWdwa40XnocjMzevwri0+rsWjCkm4HTO0RKehFlE
        m3yyrYhXWLrzpRe7g6/5ncXU1Y5zNZv18CEYnNfp5lVftJTwwugxEZSKhKHu8HnU
        D6d/4GWpwpUv6Jm1sq4QVR7QmJaXC0iLDScBC5h22Az8cL6bKfb81dPTuh6gvvW2
        KnftySRiAplSfye9q5yj6gTVshQiQ==
X-ME-Sender: <xms:nEQIX49qXOwbuCAD8b5GTZa3pch8EfoR2FcmxNJ1uI47fIq4NY0DEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:nEQIXwv13zBJFr1ch_qdYnPyqqqEA6cvJCn_cgT4r-7aUyGa1iiGsQ>
    <xmx:nEQIX-CPB21fPABGIINXufOxv0lUwjMZ57TOD5zZQYQlbw-CrEmkhw>
    <xmx:nEQIX4fu3l66bgLt6_X-laeM64clmbVLxJuG9McwPpNxm04Id7Y8Yw>
    <xmx:nEQIX_XIAtRb-8AkuzCijVi5-E6spCaatd1o_1mhjWUgEtTQaAgrEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABC10306005F;
        Fri, 10 Jul 2020 06:36:11 -0400 (EDT)
Date:   Fri, 10 Jul 2020 12:36:17 +0200
From:   Greg KH <greg@kroah.com>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "johan@kernel.org" <johan@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200710103617.GB1203263@kroah.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
 <20200710095445.GS3453@localhost>
 <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 10:16:33AM +0000, Joakim Tjernlund wrote:
> On Fri, 2020-07-10 at 11:54 +0200, Johan Hovold wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > On Fri, Jul 10, 2020 at 11:35:18AM +0200, Joakim Tjernlund wrote:
> > > BO will disable USB input until the device opens. This will
> > > avoid garbage chars waiting flood the TTY. This mimics a real UART
> > > device better.
> > > For initial termios to reach USB core, USB driver has to be
> > > registered before TTY driver.
> > > 
> > > Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > > 
> > >  I hope this change makes sense to you, if so I belive
> > >  ttyUSB could do the same.
> > 
> > No, this doesn't make sense. B0 is used to hang up an already open tty.
> 
> This is at module init so there is no tty yet.
> acm_probe() will later set:
>         acm->line.dwDTERate = cpu_to_le32(9600);
> 	acm->line.bDataBits = 8;
> 	acm_set_line(acm, &acm->line);
> 
> > 
> > Furthermore, this change only affects the initial terminal settings and
> > won't have any effect the next time you open the same port.
> 
> hmm, it is not ideal but acm_probe() will later set:
>         acm->line.dwDTERate = cpu_to_le32(9600);
> 	acm->line.bDataBits = 8;
> 	acm_set_line(acm, &acm->line);
> 
> But, would it not make sense to not accept input until TTY is opened ?
> That would be more inline with a real RS232, would it not?

You can't keep the chip in the usb-to-serial device from accepting data
before you do anything with it, that requires firmware to not do this.
Are you sure your firmware is correct?

> > Why not fix your firmware so that it doesn't transmit before DTR is
> > asserted during open()?
> 
> I would but it is not my firmware, it is a ready made USB to UART chip. will talk
> to the manufacturer though.

What chip is this?

thanks,

greg k-h
