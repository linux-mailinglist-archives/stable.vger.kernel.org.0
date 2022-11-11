Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FB6255A4
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 09:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiKKIpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 03:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiKKIpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 03:45:31 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AA382C5F;
        Fri, 11 Nov 2022 00:45:19 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D8965C026A;
        Fri, 11 Nov 2022 03:45:16 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 11 Nov 2022 03:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668156316; x=1668242716; bh=lImIfGrlwD
        JCi6Gs7wYZwHzBayogHUUB/nuYnjmfvnc=; b=HSWytxZdec4Cg3qZTidPfFN7h4
        dKWUFG6IQTt67q0WxeegvQqdFmEkyq+ZOWMs1EbcZD1SKI59RfmXhOKAU0SfSJ2X
        vZz3bijWI1rKSEI68YPE9tX03R9A1msYYBRZekrTSrmJ4ezWM4GMJHlfbQgkZFnp
        NgNN6rxzbCv069qVV1knx1s+mSktv5WpNZJ3r9HTNLliIaXwRG1MwnT3GUvgC8Cb
        RgDCTfM05EIyspHj0dOf+m3HARlkTvuO1+g4wqviGbH9RZMdtePAReqXkcfQuT8y
        4G2uh6rD36wghcRkXkitB0TF1ksN21tdFQ968FmMHDmhwACrl9re5U6YhugQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668156316; x=1668242716; bh=lImIfGrlwDJCi6Gs7wYZwHzBayog
        HUUB/nuYnjmfvnc=; b=kXjrFlM85DqYuO+vn6R/8oP6WYWqd8Py/ODBLPOYnwMb
        2WKRwkFnWW9GeVBYhMLA36TvLGktCUbVTcokrrDBSrSvu5PUUK39H9JMt3XS/1Xg
        tVCtugOUpi2eipXDTAzBUJXtEVUIbDT9QHlzQLTK/ScjO0lK4J/0+0Iyx9IIjjtO
        caIVC+gfZywncr+CdxT4vTO2U+kIb5usQOdxeou0ecGX6APDFwUaALsKgO48ilev
        Ym73gRUoMTignVDEmHdDdyBQ5WDEbKuQvtsxVjLfSBoDMAkvyIJEN3LbIP8N5ihZ
        dAX5Ayvg9CqX7kA+uBhNHiy4P85iEZbKazh6/Nt1Pg==
X-ME-Sender: <xms:nAtuY4sxLQx9AsrPB1euFZIJYiThxVoq3sSLch9FdVeQqOi358355g>
    <xme:nAtuY1cW20cdjdmycMMuFOVgIlI41gkY9sjOvOUixqK_a8qkXJT4P3m1XWahnwHxa
    0cU7L0iH6oxf6Xa8hc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeehgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhephfdtlefhtedttedvtedvueeugedvueelueduvefhuefhuefgvddtveevvdff
    hfdunecuffhomhgrihhnpehlihhnrghrohdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:nAtuYzwF72-3eKjOGhTHUs6mLJj9Z7Pa3c1wt4bECC3z_7Wo5qVz8g>
    <xmx:nAtuY7OOrIf6iIHR9mN5UBh7Q_i-wxhpSQLRSgV_P4k9KUDFct39lw>
    <xmx:nAtuY49Y9c-yaRDBoefjZNFD0mqULAm8cCmf--pm4I4RFqxyb1KZVg>
    <xmx:nAtuY8S0mWDVP4O7xlvQ_VZRlSfGGJbl7Vw3JpOiYcuuaYImhSbXWA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 22B53B60086; Fri, 11 Nov 2022 03:45:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <89a8e93c-f667-4de1-972f-3d2d051bd789@app.fastmail.com>
In-Reply-To: <CA+G9fYs_kWc1Zh=Zr4esnJYRvSMwv6k6m1eYW4PbHCYpvJPPOg@mail.gmail.com>
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com>
 <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
 <CA+G9fYs_kWc1Zh=Zr4esnJYRvSMwv6k6m1eYW4PbHCYpvJPPOg@mail.gmail.com>
Date:   Fri, 11 Nov 2022 09:44:55 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        "Ard Biesheuvel" <ardb@kernel.org>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer dereference
 at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 11, 2022, at 07:28, Naresh Kamboju wrote:
> On Thu, 10 Nov 2022 at 03:33, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> One more idea I had is the unwinder: since this kernel is built
>> with the frame-pointer unwinder, I think the stack usage per
>> function is going to be slightly larger than with the arm unwinder.
>>
>> Naresh, how hard is it to reproduce this bug intentionally?
>> Can you try if it still happens if you change the .config to
>> use these:?
>>
>> # CONFIG_FUNCTION_GRAPH_TRACER is not set
>> # CONFIG_UNWINDER_FRAME_POINTER is not set
>> CONFIG_UNWINDER_ARM=y
>
> I have done this experiment and reported crash not reproduced
> after eight rounds of testing [1].
>
> https://lkft.validation.linaro.org/scheduler/job/5835922#L1993

Ok, good to hear. In this case, I see three possible ways forward
to prevent this from coming back on your system:

a) use asynchronous probing for one or more of the drivers as
   Dmitry suggested. This means fixing it upstream first and then
   backporting the fix to all stable kernels. We should probably
   do this anyway, but this will need more testing on your side.

b) Change your kernel config permanently with the options above,
   if LKFT does not actually rely on CONFIG_FUNCTION_GRAPH_TRACER.
   I don't know if it does.

c) backport commit 41918ec82eb6 ("ARM: ftrace: enable the graph
   tracer with the EABI unwinder") from 5.17. This was part of 
   a longer series from Ard, and while the patch itself looks
   simple enough to be backported, I suspect we'd have to
   backport the entire series, which is probably not going to
   be realistic. Ard, any comments on this?

       Arnd
