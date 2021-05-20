Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D82E389FEF
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhETIhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:37:40 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:36967 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhETIhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 04:37:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id ABA4B1B83;
        Thu, 20 May 2021 04:36:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 20 May 2021 04:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=o1DjTJWgM6tI8DPk/ukCWHIxuL5
        WQ36Hmn4F+Omn2gE=; b=EfmBFZJuVqarI01IkARBLgCBP3+Qh/TFv6j63ajlXbQ
        bM6/QY6OvpXS1wk/45R5vqwuJBCAcFWNlIt1Nr30FLEjHOilrFzwY13HwZGe0re8
        jdPC4Wkx6lpVGBZmzPjLn+tP06g/FjqbGANErugpgGOQUyn9ynuyPAcM+hU5blDQ
        Ap6YdBE+voi5QIqjhDXNoxLsqgdSVOXuNx/HRv0wcQ3gAthr4EgHzkpxCpCVs5Mx
        V+rkxFZi5QceZxbE3+kWyznZXsrtj465Mu5Xv/lJ79qolQU0pQgCxcXZLMy9Nut9
        U/DoX/runOqbbPT3hGQJnUJ7Gw2SeIauakR9lvKuMKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=o1DjTJ
        WgM6tI8DPk/ukCWHIxuL5WQ36Hmn4F+Omn2gE=; b=g51lblhwEGgxy5aYP5QYY0
        RSY7SZy1C/Sv2PxCcqebXyt3w8rrP6CtRV328Dwu9c7jcF+OHN7aCN4/DWkhzSvO
        4SOz7EIOMwuorL3OeYjH4K10JeZvofs08OQ0VBVrISsldL/piujMRb8hnGW4roxh
        aPvI40KB0hKrjL5DBdCiY2cLyTM4vrD2ut4VXp8t9cu2I/M0hSEG5/wM9U7kopKv
        3YbhdLurZczgRLMN51x1/AUZujUK6UPn3WZyu8hNbuUgp/5wupm8+M1aJTz+1rzs
        caWNfo1ECEDcZ8hcPH78DVl7Ux+yKeevshuXADUsispV3cOtjtou2LubSQdJixDA
        ==
X-ME-Sender: <xms:gB-mYPcQkRjdUbyvMPsy7YOdj4Pv5szthHE4GZPjhKqPWVAfJ6ulkA>
    <xme:gB-mYFM_rOiqU-nnk9ycbZIYI2IHlUWleB0bIHDjVZbS6iipypv5hcUz8VS8V5Hoo
    jqCPP5NLNjz2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejuddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gB-mYIjgHySLxpmEurETaNCi0j2dXiH9GxTN0hoBwDfUycFTiWDC1A>
    <xmx:gB-mYA82kDcn_B8vQBc32vr3xgmz5LcEbYWVqc1Obz1oukep969u-w>
    <xmx:gB-mYLtCEE3sEJPQa8koj29LGYeMPpt6nbAyo8XGVMapRGaAzbw_2g>
    <xmx:gR-mYPH4xvPkwEnGHj7RFKIS3-Yi8DMRWd6Y1nKcOt-siNI35SO5RWxH5kY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 20 May 2021 04:36:16 -0400 (EDT)
Date:   Thu, 20 May 2021 10:36:13 +0200
From:   Greg KH <greg@kroah.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Jan Stancek <jstancek@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4.19] iomap: fix sub-page uptodate handling
Message-ID: <YKYffZMzHeuxCCiE@kroah.com>
References: <20210517165724.3150255-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517165724.3150255-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 05:57:24PM +0100, Matthew Wilcox (Oracle) wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 1cea335d1db1ce6ab71b3d2f94a807112b738a0f upstream
> 
> bio completions can race when a page spans more than one file system
> block.  Add a spinlock to synchronize marking the page uptodate.
> 
> Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/iomap.c            | 34 ++++++++++++++++++++++++----------
>  include/linux/iomap.h |  1 +
>  2 files changed, 25 insertions(+), 10 deletions(-)

Now queued up, thnaks.

greg k-h
