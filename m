Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE05EB9E0
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 07:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiI0Fqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 01:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI0Fqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 01:46:49 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD0A8E4C8;
        Mon, 26 Sep 2022 22:46:48 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 11B5858075E;
        Tue, 27 Sep 2022 01:46:46 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Tue, 27 Sep 2022 01:46:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1664257606; x=1664261206; bh=3km8jFe+gf
        AWuGAdnBagBNyfmO/MJ6GgfHInk6jO0A8=; b=m99TkOoRJ6X1UrHZeCUnR3BBpw
        XhI0KoAuQAMi711PPBfLGI1GQ6AgoXyHZgt04aCAy6N3b7EA85uV/daPOg/F14cg
        3J2QMOJc5R4wAT9b1MIklNx51Ev4gTpooYqS69xoha08vESs1EhowfWGfdXVJ+n3
        tJulrzVCsrBLqV7Mq1c2VjdbrNa/ddOm9GvYNLZ+Ok9nbSvR1JGO5NAs7uN4OHXR
        TWQ4/dRu2AVz8Ol2KmlJ3HKXYZp5YAdYTGGiyUAT6zuudIdM/ucrYVfy1FQfxVEV
        PrHtQ4zVbEzE6KloZ/EWE2EJSnwuPIGBzU7HhzAl1CSceqH+WT9vSLuM1PMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664257606; x=1664261206; bh=3km8jFe+gfAWuGAdnBagBNyfmO/M
        J6GgfHInk6jO0A8=; b=ZX/I3EcLlt1bY+uTfEJL3Mz6aeJArn9/ZbXVBV7x41lW
        U+jJpApxyvXnpjmeLhtTjVPPBR6dUr4HTYexj8a15Mv6jMU2XzCC74wB05kbJ6aS
        sC0BDTiiaCSTLbYsfUiXhF+CvP+2sWfeJ6uwfCi+yfBJ3nXeft9SrlHDXogFY3Kg
        F5Do0ACvdkoIdYo7xZyxFUKE53DKMOeuNt1uIHN/NLa9XF6HJ5uaYFWeQaptqXif
        +0rtTVIxFlwiOgigmhJ7BjZxl/+37Z7wDyVyt+YHljlfTlezP0Y5FWVw1wSdyh0Z
        V08yR6STpuaX6WeEVwgLBYgPbqE3L7mkJskA1Rw4gQ==
X-ME-Sender: <xms:RY4yY4iAEsF7evoNeXnza8J0K6hQYknNAJY6y866RHCv8PazQII1RA>
    <xme:RY4yYxAGsYk2kgtlI6cPlBubZC03O6H9R7zbqy8yyR0BLY3jF9jUYRyl_zlzbw5ze
    HvxiCsSZZ_S6dFLiJk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:RY4yYwFN8hn9SQFWdNFMSbjhTYFtdjtr7DMnRwcqF1XF2GouP2prJw>
    <xmx:RY4yY5QbKd0G14P9n-3IJbgJXuK6MFVcoV0pddQyYSYZGJJ3NtU4EA>
    <xmx:RY4yY1x6-xnZPWfSGDiaSNYclceaP8-omluyXes9Ti0uUFhv-mprZg>
    <xmx:RY4yY8kXwROFmzW6TptuS-M6znNSntj8qFVGK2408j8vqmHqZzRN8g>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 35E7FB60086; Tue, 27 Sep 2022 01:46:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-968-g04df58079d-fm-20220921.001-g04df5807
Mime-Version: 1.0
Message-Id: <ddf89495-1423-4237-8657-76ea2dc8d564@www.fastmail.com>
In-Reply-To: <YzH7QfdLELstD3r7@sashalap>
References: <20220925020231.772438-1-sashal@kernel.org>
 <0901c6a4-9d5f-49d9-969f-45c1fe8dfe25@www.fastmail.com>
 <YzB/2bl4Qn+k1nlg@sashalap>
 <70cb5402-793c-41af-8618-b16f492e3ba4@www.fastmail.com>
 <YzETgqqlvlOY4lJ2@sashalap>
 <8b83cc68-3fe0-4d69-b3d9-f1713a7f3561@www.fastmail.com>
 <YzH7QfdLELstD3r7@sashalap>
Date:   Tue, 27 Sep 2022 07:46:24 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Sasha Levin" <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, stable@vger.kernel.org
Subject: Re: Patch "net: socket: remove register_gifconf" has been added to the
 5.10-stable tree
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022, at 9:19 PM, Sasha Levin wrote:
>>
>>Ah, so mean this just got incorrectly identified as a dependency
>>by a script, not that you were actually considering the backport
>>of the context changes, right?
>
> My workflow is to have the script attempt to identify and cherry-pick
> all dependencies, marking them as such, and then I manually go over the
> result and decide whether we really need the patches it picked or not.

Ok, got it.

> So in theory yes, at some point this was considered for backport, but
> should have been dropped during the review phase.

It looks like it's still in stable-rc/linux-5.10.y, can we drop it now?

    Arnd
