Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693702B5E87
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgKQLlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:41:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58699 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728190AbgKQLll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 06:41:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ED14B5C01CA;
        Tue, 17 Nov 2020 06:41:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 06:41:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=a8X2bIci+VqMmb8gUrE97inq4kT
        rEUN7Mp+Z9hTwU9M=; b=Tmogw+weXeYvvc20+F6jy7w9/vXUqOmxScJSJX7uUp4
        njYRVrDgFlhcWUOQvq4RnhBT0WlMj9hgd8Kig6CgCgoEITd/pNYNMVcIWWpFXP88
        JJHcarDMzncfVgIJ7HNhd7+YBDSm9ZEPzg3H23gyN0DeQMqMYIo1+qO76jgtDV2X
        bRuA0WuC0PpWaimktkIWcFzje02ej9hwslqWY6tYDbjVVjZ5aYoahO858XYyQA07
        Yvf4wxYUuSJjkIkgT8wqLFroxydKwJbiFjPvG0wNQKzUioIErYe4ihWMBwChJ+Z9
        rv7PHts89t3gx2gTur+pQNrT0YqY03WF1JFNbyPI3mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=a8X2bI
        ci+VqMmb8gUrE97inq4kTrEUN7Mp+Z9hTwU9M=; b=MM0I6b79xer1KR8aY7pEzE
        6/LSjeJYgI1heps0e8u3t0EszPQXIqIW+iiJLxXFTPha0hPUX27WD0LQpeNSH5dA
        9tNj8iQRG49vU8V1kKqXZj5xkAVppyZaGPJPKR+10I4l3AX/4HvOcwgy9UFzr5Di
        epyfWIHHlZWMjFeY4TXdTEOs6hV369F08bJI0P1IMeM+eHPGFRnlInG1MM78HbuF
        uPEP4PBBs0AkfmuCkjFqTFUBpEanaaslAJ48YY3ZVeMfd/9raXps8Yv31tedQM+j
        0my45U83wvzoyKT8D777OFecSA9gKiKU6eh6aLCuorxrR9zQ7GLPiHL43jcFA5qQ
        ==
X-ME-Sender: <xms:9LazXw1zVaNf-enlFvgg8cSsh43xMncRuXyIJHdDAzixQspB78FK2g>
    <xme:9LazX7HGse4b_FO4KjxRnJ-XFXGgyvuVUTtiH6QuMwC2EgOZbSivk-xv6D4i7DavX
    4iePdaEfVoLmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9LazX473wPrL9VH-hXDIVW187ECnjXt9dypBytqlds1hiYusS1NaxA>
    <xmx:9LazX51nXsICeTGjbuWeFZrCor0B15MIcqmxdWsrcaE3_Yul2xwsTA>
    <xmx:9LazXzHwSHpExvUKG-uJfHWbDka20LNMxeTONVJ2z1XrbWftc2gh2g>
    <xmx:9LazX6y-q0Ucv1GWuz8JmnFkMBSq6rsrH0C95rh95GIsWPpLB1grgQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 798C7328006A;
        Tue, 17 Nov 2020 06:41:40 -0500 (EST)
Date:   Tue, 17 Nov 2020 12:42:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 00/14] Backport of patch series for stable 4.14 branch
Message-ID: <X7O3EtlRCIVAtzwK@kroah.com>
References: <20201103142911.21980-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103142911.21980-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:28:57PM +0100, Juergen Gross wrote:
> V2: correct patch 2
> 
> Juergen Gross (14):
>   xen/events: don't use chip_data for legacy IRQs
>   xen/events: avoid removing an event channel while handling it
>   xen/events: add a proper barrier to 2-level uevent unmasking
>   xen/events: fix race in evtchn_fifo_unmask()
>   xen/events: add a new "late EOI" evtchn framework
>   xen/blkback: use lateeoi irq binding
>   xen/netback: use lateeoi irq binding
>   xen/scsiback: use lateeoi irq binding
>   xen/pvcallsback: use lateeoi irq binding
>   xen/pciback: use lateeoi irq binding
>   xen/events: switch user event channels to lateeoi model
>   xen/events: use a common cpu hotplug hook for event channels
>   xen/events: defer eoi in case of excessive number of events
>   xen/events: block rogue events for some time

All now queued up, thanks!

greg k-h
