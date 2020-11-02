Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244FA2A2EB1
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgKBPyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:54:23 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:55443 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbgKBPyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 10:54:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E309C1217;
        Mon,  2 Nov 2020 10:54:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 02 Nov 2020 10:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ercQ6oulhE2KFsoIbsDKhB12x5a
        1icMLDX8DuJj9S4Y=; b=DLbMUidSskKFlejliN220VJVFFPj577aQNY3TolkUiA
        ZBA5pnPwhv9+rxxDkxVimfyp5751nrtOZLLrYFKOEhmkKEzpE17uSqb67dhQW5Hn
        Qt+m7qAlbsaGsNv1QTBkpbeNK2ROxBHmNDYK7BqnrW7AjYH1eJuHwhNvsJg0YwvR
        ZgjA2uhvhFIVCpJcLTttigrTTB03XseXd8UrdDPDIJWT5nwriiMqBZ3uG6EvhgCt
        hyBfAzNF7m50pW3duYH0vWmQOtjOsFrQynA2GrbxXZLCpi7AoKUtRrXyxniwk3C6
        ZqlIa/+7fN3RYHH1fo1jpRvdHcwReoYgVsWqf1tPolA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ercQ6o
        ulhE2KFsoIbsDKhB12x5a1icMLDX8DuJj9S4Y=; b=GOLWEM/pExp0JPJ7rgAu/A
        mb/kB/0626I5WOeXBrTURjpkWPQz5chypRNKKL7dHipPpE+mZvi8646225aa82My
        /HyfyZHiKVrXMVQYBVM9eizf0b5A/E9KUBT+mWgLAFZAMmlV/B3UkWPovODN4PqU
        HHsBRhju07z8Vp7zRTwNWIBGraRYhIItaBowYj4zNbySlLx3KPxvbvJtzPC5mDwh
        baWOgiI5f6J0geMaTm3Y63Mn6xjRPq4HS9UFj4gF3miLC3+qnL/lasXqZZMoLJWm
        o6ImvAHRDsXI3rGJzah9VXLBG2oEhrgawkPlbVv/yPAST7bJj87HaebtRZHHKkqA
        ==
X-ME-Sender: <xms:riugX2TU4qtLWbSKYzwhG7TR0rXy9LO2jD96ZqBYWOLjXYyhf4G1EQ>
    <xme:riugX7xijMZrykPeu0SWucTAeQjnNFfQiKBn5beLM4m5TFKg3cBsdNLz-ImXKrnor
    OfS6o3-pt1T4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:riugXz1KK6_ZsdCZ1YSB29ox2Y_5L2d5nHcg7X4xR4K-8aRsmHQCRw>
    <xmx:riugXyDWQBV3TZCGQZDh0VyeB460iHFH1wWRjc4mQ3BW3_099VvgHQ>
    <xmx:riugX_ivv66difJzaWrohmba8rm4ZKPl1zx3AudUvvb67PuDGi06VA>
    <xmx:riugXxexW0JLNMy4DrT8DKqpoix27T3pSxn_0Ve2XqaTGfo3gGUGKg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F62B3280069;
        Mon,  2 Nov 2020 10:54:21 -0500 (EST)
Date:   Mon, 2 Nov 2020 16:55:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/14] Backport of patch series for stable 4.19 branch
Message-ID: <20201102155510.GA1564746@kroah.com>
References: <20201102121722.10940-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102121722.10940-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 01:17:08PM +0100, Juergen Gross wrote:
> Juergen Gross (14):
>   xen/events: don't use chip_data for legacy IRQs
>   xen/events: avoid removing an event channel while  handling it
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
> 
>  .../admin-guide/kernel-parameters.txt         |   8 +
>  drivers/block/xen-blkback/blkback.c           |  22 +-
>  drivers/block/xen-blkback/xenbus.c            |   5 +-
>  drivers/net/xen-netback/common.h              |  15 +
>  drivers/net/xen-netback/interface.c           |  61 ++-
>  drivers/net/xen-netback/netback.c             |  11 +-
>  drivers/net/xen-netback/rx.c                  |  13 +-
>  drivers/xen/events/events_2l.c                |   9 +-
>  drivers/xen/events/events_base.c              | 451 ++++++++++++++++--
>  drivers/xen/events/events_fifo.c              |  83 ++--
>  drivers/xen/events/events_internal.h          |  20 +-
>  drivers/xen/evtchn.c                          |   7 +-
>  drivers/xen/pvcalls-back.c                    |  76 +--
>  drivers/xen/xen-pciback/pci_stub.c            |  14 +-
>  drivers/xen/xen-pciback/pciback.h             |  12 +-
>  drivers/xen/xen-pciback/pciback_ops.c         |  48 +-
>  drivers/xen/xen-pciback/xenbus.c              |   2 +-
>  drivers/xen/xen-scsiback.c                    |  23 +-
>  include/xen/events.h                          |  29 +-
>  19 files changed, 731 insertions(+), 178 deletions(-)

All now queued up, thanks.

greg k-h
