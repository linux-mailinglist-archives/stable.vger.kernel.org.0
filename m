Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCE353320
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbhDCIuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 04:50:07 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:33483 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232157AbhDCIuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 04:50:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 41956F61;
        Sat,  3 Apr 2021 04:50:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 03 Apr 2021 04:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=z4KlZGvNGB+Isw2TMIh4m8aWcWA
        nmLIXVAjtAXc/Ezw=; b=hqPWX4EmXC3B7hHI55hBRsyWVQQjXRNlmR+INvdqNFe
        DUbe2iIpuqvBO+KEeu9Fu/hNTnf+vr8QDtmARIv0nNMKZYENeFsCPeSLAH08pbEE
        o7XZ07BvIbq+IXqKQ1AOa9OGBlHWtAWYqJxNGL6AfcwtdbhSsVAKJYmZfbl5XN8x
        xRRG0sjEBcXz7wRiy2eexuTQ9lloootwf82qEF3Xjdxkrrn6V2oXZR9/yPjYAiM0
        SvaItwIyVdT4i1IpsetC/Xg6p1Fc+ou1AjOTOkajVGfqXuqCgI1JOeCuVoJ3jc2J
        UvQ7FgBIQZkLtgNcQ0klcrAXxF6Yeqjb06tb1onnIxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z4KlZG
        vNGB+Isw2TMIh4m8aWcWAnmLIXVAjtAXc/Ezw=; b=sbMtPgNmxBKQVxT96MDepC
        LdI9lGyVvnQnoRKj1dgQ6/K7xNlYNvL3xu4ORdiYIwFYAsYlHKnjTRh5LOGUIG7Q
        sHk7RlT55sNJq/2mE4kAjh6UR1VaTuQwdfEA2HWY+tE0A+IsSzfd79FCRLGpESUF
        YQXhY7FFO/2sNr/KnNEnKOP4h6eyBkrxFBviHwcBTeTXGdW7W9aCilUa8hdDPwZ0
        rqQ1K8rgr+weDdFAqHSLLgczIRZn9dU6UFLeJcVjGcUtSyCg0CsvNrq07EUKA0qf
        J4ALwmz2g/fIgzB9lhnj70myM41ARetZRBU3NzxsbkDzgogDd7gSkWDWLQW7q5zQ
        ==
X-ME-Sender: <xms:OyxoYNjNe-EyvjkSZAit0A6VzJNrwVXIQkbSlJAO_bmKAp9zga2G6w>
    <xme:OyxoYCDRvJe46NcozSiD6pm6ClNANd3yjTx2xymm-okjfZYxzUfieIZ1EFc0sZYD7
    91qqLxL7W7Scg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeikedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OyxoYNEiKMDCSfW-XKq48yWa4tfegcV1WM2GvG8KpwunpfU0OjN3Zw>
    <xmx:OyxoYCQF7ntQlTkhO6f4fdNKS_4h_SWTsf4_HLTEpibTrkimZNfS-A>
    <xmx:OyxoYKxMas72-sD4BM9HLvSDzGHkNW4saHa_WA9M9xPU0_XswWzQYg>
    <xmx:OyxoYPsHnl7L1IN03-_d8mDl7RA_StN_pKweO89T4FTN7C6kkZKqJQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6888024005A;
        Sat,  3 Apr 2021 04:50:02 -0400 (EDT)
Date:   Sat, 3 Apr 2021 10:50:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 2/5] mm: memcg: make sure memory.events is uptodate
 when waking pollers
Message-ID: <YGgsOHbKcHucnAlG@kroah.com>
References: <20210330181910.15378-1-fllinden@amazon.com>
 <20210330181910.15378-3-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330181910.15378-3-fllinden@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 30, 2021 at 06:19:07PM +0000, Frank van der Linden wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> commit 2d978806d863e926345185d084a90a4c35846e37 upstream.

This is not a valid git id in Linus's tree, or anywhere else that I can
find :(

Is it really e27be240df53 ("mm: memcg: make sure memory.events is
uptodate when waking pollers")?

thanks,

greg k-h
