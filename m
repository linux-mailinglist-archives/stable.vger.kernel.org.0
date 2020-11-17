Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5ED2B5E45
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgKQLap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:30:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40499 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKQLap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 06:30:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FE7E5C0228;
        Tue, 17 Nov 2020 06:30:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 06:30:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=OWU1bvSXWWryRBPM9rm7Sv/8uPT
        9HbFEZJPAmrcCbws=; b=cWtPxTRH+YkDLtiQ+kD0W7+kDPcaxzbQs2MziAxysob
        W0ebLs9MeFl57ZNYbfA/aC6aSy2qj5GU5iZpamcYfX+U2nKHe9JmsHsO12opoSHu
        0/vtRcYl2CpZH0INMkZd4i4Epw5xYNlTUqcO//4zD/Gvz5EaJeH9U1oOKpqc1Peg
        /lH3zTo05ZgPldVQmqHcmN0b7O5f76TIIdnEnu0BKAIHv5NQ4UCHOfBATcFiXq8A
        VVDjBioCdW6J0JDK0g5tuChpHyLkhiYksHwULZ7rYHo10/q4k+Ex70vE4uHOefrq
        eeiVpQGUwc1G9pV/6k8M/XLB1YE+PE9nHgbzW0ZqrcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OWU1bv
        SXWWryRBPM9rm7Sv/8uPT9HbFEZJPAmrcCbws=; b=ChEdggSEBGZzHw26u4fs1m
        OG5tlcEAJTw+QAbjLOBjZFwhrXSRrNCUkN/BGA6uNjEnydHjfJJMaMuxfHq5XnPw
        dF/pjslNPiphJCkqxKWnYckaHK/PfJ/5hSPAg2au6kn6jeztfFz585M7i+bJUC7I
        Tv+6V5Dfin3OxCSJA224wF3Y7H2d4WdOFnuubPXi08zZKioiHeZfZSY3F18o++og
        pUwZel94tabeTH3XIEpfC03BxFX/hiXwJo81GJyln73rGYmiTW7kxoXxNi08Joxq
        7thvrF4Lc4/NlUQFLwipqE/oCL1KiYfab9fApAVUd0L3xRaBKpDcGYMrHF7RM6gQ
        ==
X-ME-Sender: <xms:Y7SzX1RnQarZqh9l5XRj82oxxpKz5G6GLZJa7JDN0lA_GTjZ9plDeg>
    <xme:Y7SzX-ySFKLm42Ver_BMLsb24U5-DHeuvA3nAS_X4Qrd9Cd8gY_sBdjCGzioTjPAg
    qMops-ZjZuWXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Y7SzX63uso8esLxOjLXWX2o9_u_-omt4lkgzI-uR5GObE3YHsxV_Hg>
    <xmx:Y7SzX9B5_kOmAnaBPg2kbdBNHUgIJ9sGSMGnn6u5l7qWwZ2tRjmkdw>
    <xmx:Y7SzX-iBznzxOgoHIgLibb-rMRAmMznKTmxtGtfw_dmWnFnMrnEL9g>
    <xmx:Y7SzX0e3x-t95wQ0hFQC_P87mTdLduTxcVwey2qBgkYzCXeEPLxSFw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 137D63064AB6;
        Tue, 17 Nov 2020 06:30:42 -0500 (EST)
Date:   Tue, 17 Nov 2020 12:31:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/13] Backport of patch series for stable 4.4 branch
Message-ID: <X7O0k7s63x7m26AV@kroah.com>
References: <20201103162238.30264-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103162238.30264-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 05:22:25PM +0100, Juergen Gross wrote:
> Juergen Gross (13):
>   xen/events: don't use chip_data for legacy IRQs
>   xen/events: avoid removing an event channel while handling it
>   xen/events: add a proper barrier to 2-level uevent unmasking
>   xen/events: fix race in evtchn_fifo_unmask()
>   xen/events: add a new "late EOI" evtchn framework
>   xen/blkback: use lateeoi irq binding
>   xen/netback: use lateeoi irq binding
>   xen/scsiback: use lateeoi irq binding
>   xen/pciback: use lateeoi irq binding
>   xen/events: switch user event channels to lateeoi model
>   xen/events: use a common cpu hotplug hook for event channels
>   xen/events: defer eoi in case of excessive number of events
>   xen/events: block rogue events for some time

All now queued up, thanks.

greg k-h
