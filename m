Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D403EB2C3
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbhHMInL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:43:11 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:46349 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238688AbhHMInL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 04:43:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id C85662B0139F;
        Fri, 13 Aug 2021 04:42:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 13 Aug 2021 04:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=F5YQ1dW0u1fv61CywT9l9tWUbLb
        4qN/ZrIhJXoxfc3Q=; b=qUUXISbhfXhrxQWDbPH1v6+iKaZ66ZskWiz9tXmrb06
        wjHIsS4qwjWQBuiO8MruDdaKj89oJZmQcZ7ieEBxgsGe7P8SLB8imIq0XK5giZ37
        /XIO37WRPaAKTMRU29qriFpbnmoMJ6nzKln1Man0srtXtNa3MRBgNAXMflEilSuk
        mEyzI6PdbCMs4VTkoVkAyOM6IGGFaI4yV6Gjwx23i+O52WJ9rQHM6FQbuDx76x8f
        GCbKx19yGAt3EX2DF6/4aFLLlslq/vV3CUMC5SY3X+QLC4nd2kmmlIM8ZXNzUQ35
        zFEb5JTnASY62cHfQQDWcBLEZ/BPyzTNFvI7EPZVxgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=F5YQ1d
        W0u1fv61CywT9l9tWUbLb4qN/ZrIhJXoxfc3Q=; b=MzEiDiO1PAd0lpRxUUyiN9
        XqlurIyI/YB9ZsMUcBN2UxI/VRlqwsRr56usKEwFoD+lVCUIx54bmNDMhk18E5jn
        XZDzYHm1tFHHV6LAaHlfpfI1UjvcVdrs1UORNdQlaF46LVD2KaUeqlb1pI/kONPe
        cMYBQ862cdw5BRMpQwgav1MwR1OgXGRqdfg6pR/5eiy3P7zZPPejGcUtgbat51dB
        ZYbTaoGe3yj/YL7wrZZESav3ElaG7XRQYX+mtp9nqria0fVTzqKyLRiTyvVXSePy
        2qbXZ+6MGB4iyclHpGD0z03toSx1sMIga3PYCpFMeunDI8kcgw9p1egV/w9ucxKg
        ==
X-ME-Sender: <xms:gjAWYRllwHMT9z3QQMnRDHJ-EtL699iOJjIa65QRVltJQt9L2UqzkA>
    <xme:gjAWYc2dwUxHrgmrI_9TVzvPxzyWxf9uM7Wwa8WDt-ljbRWib6OZLux9M2ht8QX64
    el2TlU6e75q3g>
X-ME-Received: <xmr:gjAWYXq2ktjSvziSFex-xTabwivUGiQtJQU1bvUBv1Nu0Nn7Tz1atRV5Hi604995rydPJeGPZ7Yi_7V7-cZkHrrefU374b9p>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gjAWYRm6xE8yG-DymG8IcRlXtG-tMgQ5i55Oayq-rbirchMiup92jw>
    <xmx:gjAWYf12RS8h-Hr2P3wFelW2h-o9vLqUZ3e7iZvIknxu48zbpNY0KA>
    <xmx:gjAWYQuUnSHYcBBGHIEoX3soLOiFZSwaZF9GYgc_FU6-GonMQin7DA>
    <xmx:gzAWYZMjoATgMr8s04Bi1WKb8pTOkE_ALLfcjCHdbRbaX420311fMC23Miw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 04:42:42 -0400 (EDT)
Date:   Fri, 13 Aug 2021 10:42:39 +0200
From:   Greg KH <greg@kroah.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH stable 5.10] mm: make zone_to_nid() and zone_set_nid()
 available for DISCONTIGMEM
Message-ID: <YRYwf3rAHfWUWfiL@kroah.com>
References: <20210811134139.5451-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811134139.5451-1-rppt@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 04:41:39PM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Since the commit ce6ee46e0f39 ("mm/page_alloc: fix memory map
> initialization for descending nodes") initialization of the memory map
> relies on availability of zone_to_nid() and zone_set_nid methods to link
> struct page to a node.
> 
> But in 5.10 zone_to_nid() is only defined for NUMA, but not for
> DISCONTIGMEM which causes crashes on m68k systems with two memory banks.
> 

Many thanks for the work done to figure this out and fix it.  Now queued
up.

greg k-h
