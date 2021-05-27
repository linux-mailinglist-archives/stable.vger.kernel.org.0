Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB162392A64
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhE0JRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:17:07 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:33873 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235589AbhE0JRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 05:17:06 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 34010F5F;
        Thu, 27 May 2021 05:15:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 27 May 2021 05:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=jcYzwiykpy8reYauDRa+4H5WzJK
        C8nKM1Ty7GsBBKSw=; b=EY0Px+eKZeV6/mrD43SyzdTTQaRFbdsJOru9N/GtOdg
        lCETAQHLexUg7chWScZVp0f1xWehXBhjmIA0ogbSy9PBGBuhWwh2MiT2SNTASBPk
        u8H67zF9JBwTUNIYjMHa+PwFPVbSb1umVXdp/KoJQwk+kbrQ5akAd1t6SY36gsfw
        NH5UkPWZiENTMCcSifucLw1ov0i6F0a2Nj6bzlkOSf6YwX1fYXHFqMSVQYLPMmHf
        tumFU3vgF/JJ1rmrj3QTgorPLh9EqVdhbqfyaptt4qS6nsP3yR9zNNHgyWX8cl6H
        ZjkMcY3gTaVm3U1nzTOEWeXBAwX3n0xoD0y+5eBQFxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jcYzwi
        ykpy8reYauDRa+4H5WzJKC8nKM1Ty7GsBBKSw=; b=rHbftXmils8cgyVch3bxNp
        qjdPOrkjbEftBLlMMDPaY9pZgJkCM6rNkgoTqKu5okEjLC0/3YmSyB8fF41e+AOw
        Thj/ZcvuvS6+tF6SPWkb0Ko8WbpTheKlicoRlj/Q7ZEaDa7/DtnBfPuH55mrjBE4
        KBoIAhybn3m+MBGbq+hdb4IR5HnDFqfJBfZ7qGagr5NU366++5vTdxrcdnkQbwU8
        b2QYZNMJQUvIMSs86mJ3MHXiOF5TRZUxcsdPSCTnlMM1o7aaqo7pvpJp5KwiGDIO
        754Zolhp3S2oKboYvlcAw8P98i7IPAU8pKpbXor4pJuE8DH4RkJaoM2RCxjOA8tg
        ==
X-ME-Sender: <xms:L2OvYOmIn5meolWYHJOyMb-LqsQzhVTOyHtfhbQWKufo1mZd6wSE9g>
    <xme:L2OvYF29sEofJgNLDI47lg0BGwgqjy2DtJ4IZkUPNkmxos4kyx9_fm8pd1xAseM5F
    WR2OzAkPVXglw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekhedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:L2OvYMqGfsZdwDSIDa-FFQepV0oS3P2aDbLrH6dJ8w5oxGtGObv8pQ>
    <xmx:L2OvYClMFOTVtnf5wl9xPFzfsyzYrESPDH_QH2HCkS81DLJbYbrEIw>
    <xmx:L2OvYM0HIVlXOhAXgaFwQZZTSF8ZuadxNrYOduHzLMHejKsOxRsawg>
    <xmx:MWOvYE6e4tYe5n4exO_wSyA76obaLnl9sPcGGgkxqg1JSSOSnbADJAqe-3k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 27 May 2021 05:15:27 -0400 (EDT)
Date:   Thu, 27 May 2021 11:15:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Brennan <stephen.s.brennan@oracle.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>,
        Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH STABLE 4.4-5.3] mm, vmstat: drop zone->lock in
 /proc/pagetypeinfo
Message-ID: <YK9jLRGmaMKPI25z@kroah.com>
References: <20210526174613.339990-1-stephen.s.brennan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526174613.339990-1-stephen.s.brennan@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 10:46:13AM -0700, Stephen Brennan wrote:
> Commit 93b3a674485f6a4b8ffff85d1682d5e8b7c51560 upstream
> 
> Commit 93b3a674485f ("mm,vmstat: reduce zone->lock holding time by
> /proc/pagetypeinfo") upstream caps the number of iterations over each
> free_list at 100,000, and also drops the zone->lock in between each
> migrate type. Capping the iteration count alters the file contents in
> some cases, which means this approach may not be suitable for stable
> backports.
> 
> However, dropping zone->lock in between migrate types (and, as a result,
> page orders) will not change the /proc/pagetypeinfo file contents. It
> can significantly reduce the length of time spent with IRQs disabled,
> which can prevent missed interrupts or soft lockups which we have
> observed on systems with particularly large memory.
> 
> Thus, this commit is a modified version of the upstream one which only
> drops the lock in between migrate types.

Now queued up, thanks.

greg k-h
