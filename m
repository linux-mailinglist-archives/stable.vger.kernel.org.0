Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028F35E81F1
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiIWSpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 14:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWSpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 14:45:31 -0400
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA7AE4D9B
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 11:45:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 607CE5800BE;
        Fri, 23 Sep 2022 14:45:30 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 23 Sep 2022 14:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663958730; x=1663962330; bh=MVqrv2RVWF
        ujJdsUKv3Ql1M6dtOrGDF2rVtyBCUsZBo=; b=K9EMBG3pUz+Z40oSL0MijgPjtS
        NsxPfDyIr9GY/rvg705tAD1uXCoeWODrTCwV3T4h6gj91oc84JfFeYUkgLRh0IDE
        oyyUjuMS3626NhbKX/EJ9xVMS8/FuuMXCMcnxvIYCzjEJIDG6sfSnMhAC9llz7cB
        MRYSyddTet2FRBgew32BDSDYLBr5jmZ93K4dxx1RzGst8NmWntjV0+87ItA0SE34
        HtoicTbxQ4ygxWKx+7kVJLvYSOkMuiszE+lUOsBcRVhBoK+LSind+auZ2H1yBsyO
        9iCvIoNyJnCB/ZFaL9vLB9kQCl2jpvgfWI1ajZzY3Dl8Ij/0QEVaiBujMI2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663958730; x=1663962330; bh=MVqrv2RVWFujJdsUKv3Ql1M6dtOr
        GDF2rVtyBCUsZBo=; b=IR6DAZ028+44CLwQ305f0eKQcmL9jB2us451/OsCaA6R
        g7Ss+r09m3fLYquTYdyHYWZz9Ftg8T68Juv/TAUhCgY2QvNM27HS+wo1jx8Hbff0
        fxuGW2jvP17tClBWZ8vjgLpJGMe7KahyYEcJ7whpht7U+gJpeLGeNwtuiMvPwvt1
        fU9MD5lHqbdMDm+W9fArd9I6olDPCHJ6PoRG+NwYMgovYPMc7ugPH90oe6Hmr7Vp
        7Szn0gy0tvVlnQZQ3HhMlx098vVZ6MhSXJWpbKD8lzl0+bEMxBV39JU/L46tJBNo
        1o2nJHo+pIyURa+rf3SJ7tN8kbapdrZH0WwEqnhfxA==
X-ME-Sender: <xms:yf4tY7yGhFBvKJhTGsw3yu53wQdDHhCq3PDcuqGnXPpnzHVg6ZtY-w>
    <xme:yf4tYzRiwN7Iqd5CHQOrdbZaq-IcPthRR-reKT9iXHRuh2J9CnXDcIu7v9_42AD2p
    M78Qr8N7ScM9txk-CI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefiedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:yf4tY1XgdEf-dgXL5PCnp5_ps8Cg7GSPC7Z-vieSARZCUoQNV5C-jw>
    <xmx:yf4tY1hOjzcBsufOJxKmJX7xG8pDd0tCu3by5smd5ilsoBLfAbRzLQ>
    <xmx:yf4tY9Avyy38ZQiAZuFLVJNJ17_xaczJz40mtWFvw18FRSVXEBli0w>
    <xmx:yv4tY8OXYcTpZdxSrOH0yg_IZvD6n9DZyNLkYEuJ26aAiJfm7HT4Jg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CA639B60086; Fri, 23 Sep 2022 14:45:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <bfe7b542-1fb3-4ab5-b097-00134a48d90e@www.fastmail.com>
In-Reply-To: <CACRpkdbnNbYcOGPyJMKe5yxKfzaBJ4dA4WvSZrNYYHieALQf6A@mail.gmail.com>
References: <20220923113822.1445491-1-linus.walleij@linaro.org>
 <b80444c8-70fc-4aa2-9c71-e7e7e90a3696@www.fastmail.com>
 <CACRpkdYvsktiM5Fzk4g673=r6gJ4WZArJh-HTERsbFBZ5LcJbg@mail.gmail.com>
 <47db7fea-eed7-4fb6-9f74-0abe93be3f0d@www.fastmail.com>
 <CACRpkdbnNbYcOGPyJMKe5yxKfzaBJ4dA4WvSZrNYYHieALQf6A@mail.gmail.com>
Date:   Fri, 23 Sep 2022 20:45:09 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Linus Walleij" <linus.walleij@linaro.org>
Cc:     arm@kernel.org, soc@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Christoph Hellwig" <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: integrator: Fix DMA ranges
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022, at 3:54 PM, Linus Walleij wrote:
> On Fri, Sep 23, 2022 at 3:21 PM Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Sep 23, 2022, at 2:56 PM, Linus Walleij wrote:
>
>> but then the vram itself is also in that address range, which
>> would indicate that it is behind that bus.
>
> Yep it is.

Ok.

>>  However, using the
>> 'reserved-memory' property indicates that this is actually
>> just normal RAM that is carved out from what the OS manages.
>
> The binding document
> Documentation/devicetree/bindings/reserved-memory/reserved-memory.yaml
> unfortunately does not mention anywhere that the reserved memory
> must be a subset of the system main RAM "carveout" or anything like that,
> it says that  the memory should be "designed for special usage by various
> device drivers", and "excluded from normal usage" which it is, hence the
> misunderstanding.
>
> We have used this for Vexpress like forever, but I did
> the change from some custom vexpress memory property
> to shared-dma-pool so I guess that's my fault.
> Incidentally this also works very well.
>
> Is there some other mechanism we should be using for dedicated
> framebuffer memory on some odd address?

I think the correct way to do this would have been to have
a 'reg' property in the device itself that points to the VRAM,
instead of describing it as memory.

This in turn would mean that the driver would use some
variant of ioremap_wc() to map the framebuffer into kernel
space, rather than using dma_alloc_coherent().

I guess the author of the driver copied the code from another
fbdev driver that was meant for an Arm SoC with a shared
memory framebuffer rather than a dedicated VRAM...

It's probably too late to change now, and the new dma-ranges
property is at least consistent with the usage.

Can you update the changelog text based on the above and
send the patch again with the dma-coherent property removed?

     Arnd
