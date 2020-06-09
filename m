Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02371F3410
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 08:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgFIGYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 02:24:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51199 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726887AbgFIGYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 02:24:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 223395C013C;
        Tue,  9 Jun 2020 02:24:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 09 Jun 2020 02:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=6YshrS/Ih7VzQTq3SoeR2hI2K7U
        dtFUaZNkccRAOyik=; b=HAxQ7xxzVnl452GN35ykH3L0lO4MFEByG5N0iPsdmaN
        V99duU+pL9O4I0d0PkvZGwE2sZvvUHJKHcimyAwhsvZwFLXJRsnOOLoFXJgvnA5Y
        ++7v8YLPAd659aAZqCYPuRMd+QxVl7t6JozulfPfJDYS7JGw2R5mXkPGqUyTnPkx
        3fe652XLUgCpp68y+3LcbHMtBhIdOjpvUdlm77yDQiSMvCBQA56miyLMLpeASXtw
        5qsWk9tAYiHEZTPAUmhFgB3JUtqgI/MGoE+ZTD//Gix6IbKB2VxDtSiWnF/2KfV1
        PItUffPheutTcOgoJQfOWHq+l3ifOC/AmBStawJXuEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6YshrS
        /Ih7VzQTq3SoeR2hI2K7UdtFUaZNkccRAOyik=; b=WBNBm5s3ZuHPN0DVe1ydIF
        xgfS93U1yrq2RkGopZOP60ZZMjvKJ8CPoEs/N42zuVlI24/frbxWR95YpSXkdO0V
        lIyv0EocdQh0dvyRheB4d9A+MEVG5zuU5ON6OQuz8rd5AP+UgTLPFqI+3udmxvAB
        sJcYuVUvlLcUmCdPXF4jnvju6QZuxT4HgMDWXmm8W73XulR7jQhTIzoQoUf3ch5X
        kKS4vq8+LqZuLV61NzUi9FNgo4V9jtDii04TUf9AERnOmk5DIr54dblAhtlOUmw2
        AUtZ0mjk81yRffvb3DpHa7ueEAPkMhnkerh17rhMXL0A9Hw+RP0n98+Qq6Ewp1EQ
        ==
X-ME-Sender: <xms:LivfXhAErgIQ3-OU-qhuAq_AWfxbRqhkRZOlH6zVV9eJmj4sPQCm1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehfedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejie
    eugeegveeuuddukedvteenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:LivfXvg2dGIC2-KgRDPgusnB64MvUGxiQKxmEV9OIkvazJb_LppZtQ>
    <xmx:LivfXsmP3gjpb5JtZKLoSlkeEUTh8vj3EYAY8f1StqdbC7_TcPF3Gw>
    <xmx:LivfXrw6IdzviIAb31NUTS22jx67oBNBWEattebkbmfGGIqE02eDNQ>
    <xmx:LyvfXtfglH9wH46k0_n4a0J5jWeeuXiTO4KNy88Cyd7_zUj3e9iGkQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 839153280065;
        Tue,  9 Jun 2020 02:24:46 -0400 (EDT)
Date:   Tue, 9 Jun 2020 08:24:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org
Subject: Re: [tip-bot2 for Jay Lang] [tip: x86/urgent] x86/ioperm: Prevent a
 memory leak when fork fails
Message-ID: <20200609062445.GB500177@kroah.com>
References: <878sgxa31c.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sgxa31c.fsf@nanos.tec.linutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 07:19:27PM +0200, Thomas Gleixner wrote:
> Dear stable team!
> 
> I fatfingered the CC: stable in
> 
>    4bfe6cce133c ("x86/ioperm: Prevent a memory leak when fork fails")
> 
> so neither the tip bot mail reached nor your checks for Cc: stable in
> Linus tree will find that.
> 
> Can you please pick that up?

It's already been picked up, and is in the 5.6.16 release as I happened
to notice the "fun" use of cc: stable just by chance:
	    Cc: stable#@vger.kernel.org
:)

thanks,

greg k-h
