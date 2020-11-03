Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C93E2A473A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgKCOEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:04:55 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50313 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729471AbgKCOEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:04:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CA4E7D2E;
        Tue,  3 Nov 2020 09:04:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:04:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=D
        nQBt4pCh1bcS4mtZdGIE1rTosdgXp8FzAW3olvPJUs=; b=EIaDWQwmy6ow5GM+O
        yZ+k19As3az+tBkxWXdrn3T9gedgOPmfOferud13QSUwu9f3wZeaZIy4FazY8AJ+
        1bViokLHj2wfKEPLDYA3afYv8w2FRPiHHjUnPjADn/hMkRdlcFR4Y9YVR7Cl4iz4
        4kkk4Gwi8LRJuFi2ASZ44P8fWEj6MF7/2TdbnZHfD0Dd4MxL5m6lcqdfEsWG/esB
        r47KBb8SeXVfM/bJ9Y2OFbj74YaqpT6TpDRmJlmb6qdrv951PJVVJFVQ+geXzqrt
        nbIbq7k46OsI68BmrPAUc9DUG6My/BYhvBNnEZ6a1DilZwU4cdgPuGlNBIwP/Gqz
        4/Sjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=DnQBt4pCh1bcS4mtZdGIE1rTosdgXp8FzAW3olvPJ
        Us=; b=P5BNTBM95Q+StcvTrKJWI1umk0d+UVcEMPZksvreTCR/9ZerFU/7oyqaI
        P3Z3ylszqnEYpdsinyX/qdVlsflURQxHRw0T0SKWv3xXfohUMoRsjZwfGhVnC97a
        7UTF3/Vu/6lAavHbF6VtV/a5BSsx4nj64s4oyxnXzAJ1Xi1h8IHewIdMFbC8BBeh
        xhErEwWdj64JvFdse8teqgB8QfY4apc9amJKSTRUe97ooVaoABfCDwy/R9lURdcB
        ZQdS4T5lUbby13I97JE/Uob6ma1UntGA6hmH5WHk3xdYa4VpNP7R4IHnZDz6gDjt
        1dP98+Gi7fKj1ldRT+YnH1f1zVdzw==
X-ME-Sender: <xms:gWOhX6uCchPhMuKYshmOfiT_ALwZ8ZjlunS4kVkGhfSfivKW4zcElw>
    <xme:gWOhX_dgwTDqJTFx-4SJwGaU3yRdh14w8XMwCUeeoqY-w1L1qsmCGGwQJpllEXLlG
    S4FnVQWECOkcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gWOhX1yLiAycdbHx-xk4Vo5YNvtbWl8FrQG-ZDJY0S2LXatFs1JgZw>
    <xmx:gWOhX1NqC4nwfhlWoNGDpOybI32DJ4TQ6r76Yh7kwbGJmBk9t8NHpQ>
    <xmx:gWOhX6-bKtYncLV5fTZBUkYE05CHGHGtEN2yFx-D2MDAsiGgE69mmg>
    <xmx:gmOhX-bbf8uGDJPhqGMNG91ouLSP1BcXhJkVjZDAc-w7H5yGjt8TUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F354A3280059;
        Tue,  3 Nov 2020 09:04:48 -0500 (EST)
Date:   Tue, 3 Nov 2020 15:05:40 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     Pavel Machek <pavel@denx.de>, marmarek@invisiblethingslab.com,
        luke1337@theori.io, sstabellini@kernel.org, wl@xen.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/13] xen/events: avoid removing an event channel while
 handling it
Message-ID: <20201103140540.GA2569571@kroah.com>
References: <20201103084150.8625-1-jgross@suse.com>
 <20201103084150.8625-3-jgross@suse.com>
 <20201103131501.GA30723@duo.ucw.cz>
 <66f6fc98-6005-b70d-4036-32a3599ca6c9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66f6fc98-6005-b70d-4036-32a3599ca6c9@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 02:58:11PM +0100, Jürgen Groß wrote:
> On 03.11.20 14:15, Pavel Machek wrote:
> > Hi!
> > 
> > > Today it can happen that an event channel is being removed from the
> > > system while the event handling loop is active. This can lead to a
> > > race resulting in crashes or WARN() splats when trying to access the
> > > irq_info structure related to the event channel.
> > > 
> > > Fix this problem by using a rwlock taken as reader in the event
> > > handling loop and as writer when deallocating the irq_info structure.
> > > 
> > > As the observed problem was a NULL dereference in evtchn_from_irq()
> > > make this function more robust against races by testing the irq_info
> > > pointer to be not NULL before dereferencing it.
> > > 
> > > And finally make all accesses to evtchn_to_irq[row][col] atomic ones
> > > in order to avoid seeing partial updates of an array element in irq
> > > handling. Note that irq handling can be entered only for event channels
> > > which have been valid before, so any not populated row isn't a problem
> > > in this regard, as rows are only ever added and never removed.
> > > 
> > > This is XSA-331.
> > > 
> > > This is upstream commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2
> > 
> > This one is mismerged.
> 
> Thanks for noticing!
> 
> Greg, do you want me to send the series again or only this patch?

Please resend the whole series, that's much easier for me than to try to
pick one out and replace it with another.

thanks,

greg k-h
