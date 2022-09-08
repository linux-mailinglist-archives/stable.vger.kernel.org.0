Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6435B2434
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiIHRGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiIHRGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:06:21 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9614EB855;
        Thu,  8 Sep 2022 10:06:20 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 48A7332001FF;
        Thu,  8 Sep 2022 13:06:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 08 Sep 2022 13:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1662656775; x=
        1662743175; bh=FXL3pPyjuWI1jDNyeLfUhP7R3Uv2eUsXrNGlSxUOfEg=; b=f
        +DrZheqsx4aGENRJNHVffoTTBX1YCoh7ayZB1OhXDzlJc3MVqnbO3lbU5r1qjTsr
        W2r+5FNb2woedZnpXlp9pmlj29RxJoWsZ+tbBjCEFifw5MUo7SUzgjqHYyBYktY+
        ULft9Ph4CLexPW5lhFDO4K2V0oLDFQk8AO1ZjGniUQjqxINviF0o3LO2+1lFW9dK
        omIOTVHFL2+MnjdKJ+PXh67Pzyy/eD3V6/IOE3kxiCwnweI5Cl9ZJf0jQEG7jmrF
        quXOzscwoEzQeKNiyEE1CmlkmjtQscVWSjBcoUp8b2RdF5eGPvhTnyj0mIHpBY1J
        86yhvHPuKj5KtZHxAw4fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1662656775; x=
        1662743175; bh=FXL3pPyjuWI1jDNyeLfUhP7R3Uv2eUsXrNGlSxUOfEg=; b=m
        EN28rDXL4pwoJPe94OUjke2E42tHKWN5+j639VBlQ4oFDwvFa1ztDu3OJ9NMS6Lr
        EuazSLBUoes4llUQf/XfOQtMZx39xTZ/gJ/5LNZOSrPrjPXqesOhc4ro02MymffP
        2tsUPvwGT0R4po0BxfL7PKbB063/cyjYXErkC8pHb59Di4LrsLmqbqtXVjsV4N8z
        aFj7pOsMDieczYNZideeGfGH/cQaF6B2Gi2D7erhz0i9bf2c1C6rhf6RW9eFRN4b
        7ygnI7NqOvDOj7VG2/vIKUidcDXsHF4xhegd2fSX98b9drxsUGef9po/grUf/Qf8
        Qwn1QuAtBTtdLpWB4hjXA==
X-ME-Sender: <xms:ByEaY7FzMubpfojgQTqMsy7c0NG-N4mWVjSA1Hs-XyVlcjeFfKv1ZQ>
    <xme:ByEaY4VkjsQTMHPX_LKWlZwQkimoFIYr5lNCyx-wdLgY_q4jdmsrCGIhIFWnp_E9g
    x8GlMeKD6OB0w>
X-ME-Received: <xmr:ByEaY9Ki7Jaki5IBy1lMXNUQVyjzx1_aZoAHnv-Nbc1uQo4OL6qBNdRn3yQj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedtfedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgke
    ffieefieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:ByEaY5FrhVe6DDr9ovMVmXkHVhm3aiwJ9-G7Ut870moqkTe0cjvPtQ>
    <xmx:ByEaYxXXYka9kpKWASVHUojdUxxKppV_HV40wnlNQJ_zko_WNphiFw>
    <xmx:ByEaY0MOlcOmbwpL7tYu5bxN-HXq-jG4DyVUiPwNWxdrw6qM5VfCmQ>
    <xmx:ByEaY4ObPXSe5sPP2O8TRhrkN0EOjG8yYJQIrf8ZHMX-YT5xHLogFg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Sep 2022 13:06:14 -0400 (EDT)
Date:   Thu, 8 Sep 2022 19:06:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Yee Lee =?utf-8?B?KOadjuW7uuiqvCk=?= <Yee.Lee@mediatek.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patrick.wang.shcn@gmail.com" <patrick.wang.shcn@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 5.15.y] Revert "mm: kmemleak: take a full lowmem check in
 kmemleak_*_phys()"
Message-ID: <YxohHANX6omfC27d@kroah.com>
References: <20220906070309.18809-1-yee.lee@mediatek.com>
 <Yxc4U/8zzfkHHv+W@kroah.com>
 <SI2PR03MB57538512401A213D21B7882C90419@SI2PR03MB5753.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SI2PR03MB57538512401A213D21B7882C90419@SI2PR03MB5753.apcprd03.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 08:37:56AM +0000, Yee Lee (李建誼) wrote:
> The commit ids are listed.
> 
> Linus tree:    23c2d497de21f25898fbea70aeb292ab8acc8c94
> Linux-5.19.y:  23c2d497de21f25898fbea70aeb292ab8acc8c94
> Linux-5.18.y:  23c2d497de21f25898fbea70aeb292ab8acc8c94
> 
> (backported)
> Linux-5.17.y:  0d2e07c04c7f7d83c75c56da3e2f970c5653ade0
> Linux-5.15.y:  70ea5e7b38c30b60821e432abde6f3c359224139
> Linux-5.10.y:  06c348fde545ec90e25de3e5bc4b814bff70ae9f
> Linux-5.4.y:   534d0aebe164fe9afff2a58fb1d5fb458d8a036b
> Linux-4.19.y:  7f4f020286e0bd4aaf40512c80c63a5e5bd629bc
> Linux-4.14.y:  07f108f15fd75a9bff704eed718cc12f91b080dc
> Linux-4.9.y:   96eb48099a7e740768d215a989b26e0af7381371

Thanks, now queued up everywhere.

greg k-h
