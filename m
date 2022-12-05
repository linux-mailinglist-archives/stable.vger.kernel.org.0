Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D5E6435CA
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 21:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiLEUg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 15:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiLEUgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 15:36:51 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F5813DEA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 12:36:50 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E8535C01D4;
        Mon,  5 Dec 2022 15:36:48 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 05 Dec 2022 15:36:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670272608; x=1670359008; bh=AR3KlDoBcI
        VyuBEUEFyxxsbbBAfGvBk7uczmbc+6RoU=; b=rNZFyehtlA9O7wED4hjwZ3yL8V
        yNLbEfvjiA7iC3UxaILI6EgB/fPl+edvdn+QYFc4NEdDkTdhO7SxwcCr2N6u9P2j
        kVUNggAyLavTQ0dhA1jdkfe2hLwQA1Rhnp4zTY0Kqd2CDuFDW7Ik3PgsvUboTuMa
        KAAgZODfg89j9IcyZgLpwDpauPockCj2le43+rpncsZkxNM8p7y7jczvjoHoPI9j
        XMf0lIYPc0uZeyoyjRM8BZstYvfh4E8sK6OptG6RKOFM5eKbv6NflkPmSW/3OD6l
        bv7AoJbNGUGYH1yGJeHNoSmOzRbRNgrnGP0WtfVESqkSclg8Av8S2Ap32zAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670272608; x=1670359008; bh=AR3KlDoBcIVyuBEUEFyxxsbbBAfG
        vBk7uczmbc+6RoU=; b=Q7tWuABfK0W347C3JeaYWRUEm0kz6f7g+9m1i9OH3RIZ
        cd+/nrCnZI532QtEMSXRoo1H09AV/yY2X9oNKblHX3fU4Y9/+MDrJ0L3Zdzkjvjn
        DL6ttO68ia3jHfvVGPWF2kh4jEzPVI++olCmIke3H2D+Mp27bb+oxvK+RrRPnlPU
        2fS/YSM30tvcamtyN1edSR89AXtNZ4qZEQtWvDhp6zaFJQF6jrek/My8DeS8/2Ku
        Byaxf0SoOn8AwKPdnwYTCgRIgqA1RP2kJZMdakReVedRSljQ6VPmADocmfhLQqVX
        mKp/OJFFC9hWTLMVT9P71eskEvn28w5C6HOavQ1rUw==
X-ME-Sender: <xms:X1aOY898LBU4HYijddReu34kEdUAn_gDL51upSN_76YJ-Rpx7TXdow>
    <xme:X1aOY0s63dRJkUubUktrVLIybhwmGHEJqjncY62MuLjy9j-sc50PQ9tAws7gLGevT
    uYEg4mmH3Ae8rL8MM4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeggddugedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:X1aOYyCMFSN2BS-11M_4rJPNO9_TNM4pQ6xp3Dsaq51hW5IvC1J1_Q>
    <xmx:X1aOY8fVdH787q8KB8nzV2SZxJCwhe7lx-foGPJBXt8t4I8nXG0yoA>
    <xmx:X1aOYxOUh7E42k66ZtC2F_StrBCfp24rwzASg6miQFJxseIl-9uIiw>
    <xmx:YFaOY00MLmdU1HOh_0C4GbLI0I5jnkJnfBj8FgvNuzCJ2qpKsFo08w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C2A9CB60086; Mon,  5 Dec 2022 15:36:47 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <c86881a8-61b4-46ad-a02a-5252a38a9ad5@app.fastmail.com>
In-Reply-To: <4676311f-1c08-a611-a3be-48e841093e45@gmx.de>
References: <20221205190803.124472741@linuxfoundation.org>
 <20221205190806.296201818@linuxfoundation.org>
 <dfa8305f-f52f-4322-a22e-9a1e90fcfad4@app.fastmail.com>
 <4676311f-1c08-a611-a3be-48e841093e45@gmx.de>
Date:   Mon, 05 Dec 2022 21:36:27 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Helge Deller" <deller@gmx.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev,
        "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Sasha Levin" <sashal@kernel.org>,
        "John David Anglin" <dave.anglin@bell.net>
Subject: Re: [PATCH 4.19 094/105] parisc: Increase size of gcc stack frame check
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

On Mon, Dec 5, 2022, at 20:58, Helge Deller wrote:
> On 12/5/22 20:27, Arnd Bergmann wrote:
>> On Mon, Dec 5, 2022, at 20:10, Greg Kroah-Hartman wrote:
>>> From: Helge Deller <deller@gmx.de>
>>>
>>> [ Upstream commit 55b70eed81cba1331773d4aaf5cba2bb07475cd8 ]
>>>
>>> parisc uses much bigger frames than other architectures, so increase the
>>> stack frame check value to avoid compiler warnings.
>>
>> I had not seen this one originally, commenting on it now:
>
> Hi Arnd,
> Thanks for commenting!
> By the way, those patches went in for 5.16 kernel, so I nearly forgot
> about them in the meantime and wonder why they pop up now... (they weren't
> tagged for stable, but I think it's ok to push them backwards).

Ok, got it, I misread this as being a result of the recent
patch that increased the limit for KASAN.

>> My understanding of the parisc overhead was that this
>> was just based on a few bytes per function call,
>
> What exactly do you mean by a few bytes?
> On parisc the frame size is a multiple of 64-bytes (on 32-bit)
> and 128 bytes (on 64bit).
> For function calls with more than 5 (need to check exact number)
> parameters those will be put on the stack as well.

If the frame size gets rounded up to a multiple of 64 bytes, that
would add 32 bytes (i.e. a few) on average, but it should not
double the stack usage. Similarly limit of five register arguments
is just one less than the typical six, so that only explains
a few bytes of extra stack usage, but not the huge increase you
see.

>> not something that makes everything bigger. We have a few functions
>> that get close to the normal 1024 byte limit, everything else should
>> be no more than a few hundred bytes on any architecture.
>
> Sadly not on parisc.
> Again, see commit message of 8d192bec534b, which mentions
> compile warnings from the kernel test robot for lib/xxhash.c.

lib/xxhash.c is similar to some other ones that we've seen
grow too much on some architecture/toolchain combinations,
as compilers tend to struggle with register allocation for
crypto code that looks like the compiler should be able
to unroll it all into a simpler operation, but then ends up
spilling registers to the stack, which is of course both
slow and wasteful to the stack size.

>> If this happens for normal parisc builds without any
>> special compilation options, that would indicate that the
>> compiler is very broken.
>
> No, it does a good job. It's the ABI which requires so big stacks.
> I see problems with some userspace apps as well which configure too
> small stacks.
>
> By the way, since those patches are in I don't see any stack
> overflows any longer. Those happened rarely in the past though.

It certainly helps that you also have twice the THREAD_SIZE of
most other architectures.

On a related note, we recently enabled CONFIG_VMAP_STACK on
32-bit arm, and this has already caught some stack overflows
that would have otherwise resulted in silent data corruption.

     Arnd
