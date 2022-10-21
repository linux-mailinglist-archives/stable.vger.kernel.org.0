Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533F6607016
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 08:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJUGaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 02:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJUG37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 02:29:59 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180780EB8;
        Thu, 20 Oct 2022 23:29:53 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 533275C010C;
        Fri, 21 Oct 2022 02:29:51 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 21 Oct 2022 02:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666333791; x=1666420191; bh=Rn1eX5IwwA
        BXIrU09kZH5BdxkV4UW1YOrtnq2G9DfbY=; b=mmSmV0DXVzk8OVu96d2xHTh8e0
        A6i+11BnCy2f+YotS5vGpH3/L/iDL4i89lA7f9Qe9/gJEWQ5mGacenpFxwQsaD9B
        L/2OwYEY+QnOvHrTxqZGfqKsNKNtzw2OXlfsfkhK+AItsHZLrzQYRSIzbmn7aoym
        NwMVZJMKrsZAz6sHvR4+ype6zoK5SVlHlyl5hOtTj8UXSpJLVxazHX/wcE84Frbt
        29xtruRTXgYKcnaTrHxRxj/lQfr2pvk5BuOMsM+rKmoFaqD6enZXCU7DmntIGzt7
        rNKHu2A+3w3Kot0R+I0pLBDSnTHHX4tA6MZN2BCyVrs4URI62VWB9eKf2rfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666333791; x=1666420191; bh=Rn1eX5IwwABXIrU09kZH5BdxkV4U
        W1YOrtnq2G9DfbY=; b=I6cwMgX9/lSFo0DLXdx8R8vZxDSWjEf3zsTwQHtE36K1
        hNX4Ic9yDGtwUly5ms9gCBKNq3YN3PrNXNVR++wC/0w02yExQbwhwb8CLW2NyUfq
        qZ49HFIHQNQYcsdH4HD+ooMbBWEVj1wj5D4IbH9IinkPCm+bxVsvbWUIujqUc1N4
        zIdMpo0Wh27C6RhG5LFthZ2rGUhywVfL7yW7TOmSVDla6tgN7LuDVhAwiH15AX5m
        JM/389fFWjWFF0dOI5Tru8WPVSXPRWdouymbULKH4H8LKDfQnSX2KgpruR0jkNHs
        p7zPN5ztp+EJBLHegcR/aj8mDJjcZWjz744OlzUvlg==
X-ME-Sender: <xms:XjxSY74h3Dn_BjLjPajCrmZJlf45cUbDWkNo9lUi8Kd35USdz_vj7A>
    <xme:XjxSYw4uKZCmh9pdiiA8DXkmg55SDejbMFJFC-RsqhYVCANrkU5w3nOmY7Z5XfN2y
    wwquLR4YwCH-hrJ1yU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeljedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:XjxSYyeIMfG0krjy3yUsR6tBqyEfuVOXaNrotPNjqnB3WP-G00DQdQ>
    <xmx:XjxSY8JuQc2kk98F1LTUkyplhAT0PkSQJAZk1piLjpbZAwxV0t310Q>
    <xmx:XjxSY_I4esGsW6w09xUZx95hFaRum_sFxDVWY6haYm0_-s3ky56L1g>
    <xmx:XzxSY1hEixc5i1jFRynHaw3fD9qSUQNzyFk-2nWBzPTlKRb2SAjB2Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A0365B60086; Fri, 21 Oct 2022 02:29:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1047-g9e4af4ada4-fm-20221005.001-g9e4af4ad
Mime-Version: 1.0
Message-Id: <cc2cef78-52e1-4da5-8739-375dd7bfe499@app.fastmail.com>
In-Reply-To: <20221017112315.GA23442@duo.ucw.cz>
References: <20221011145358.1624959-1-sashal@kernel.org>
 <20221011145358.1624959-10-sashal@kernel.org>
 <20221017112315.GA23442@duo.ucw.cz>
Date:   Fri, 21 Oct 2022 08:29:30 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Pavel Machek" <pavel@denx.de>, "Sasha Levin" <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Kunihiko Hayashi" <hayashi.kunihiko@socionext.com>,
        "Rob Herring" <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 10/11] arm64: dts: uniphier: Add USB-device support
 for PXs3 reference board
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022, at 13:23, Pavel Machek wrote:
> Hi!
>
>> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> 
>> [ Upstream commit 19fee1a1096d21ab1f1e712148b5417bda2939a2 ]
>> 
>> PXs3 reference board can change each USB port 0 and 1 to device mode
>> with jumpers. Prepare devicetree sources for USB port 0 and 1.
>> 
>> This specifies dr_mode, pinctrl, and some quirks and removes nodes for
>> unused phys and vbus-supply properties.
>
> Why was this autoselected? It is a new feature, not a bugfix.

It also caused a regression now according to the build bots. I 
have not checked, but I assume there are some other patches that
this depends on.

     Arnd
