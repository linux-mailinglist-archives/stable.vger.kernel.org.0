Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8305E7BAE
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 15:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiIWNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 09:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIWNVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 09:21:23 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BA71401BF
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 06:21:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 6B4B62B06461;
        Fri, 23 Sep 2022 09:21:17 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 23 Sep 2022 09:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1663939276; x=1663942876; bh=EbhR3EzHcu
        1lr0K7Sz5NCMfapj8o1v28ycsPPBQToi4=; b=iXpM3R1+gTVeEca3FKPAg8aeoL
        VAtWd5PlSLHfGwQDVhXt+xl9NPsoY8QCpDK2SBM8xlZHJVtkIfnvV25baB3LUnfR
        IXhOR/5HK2d5nDkASyYe8zmzdzawc6sKJs+2oKd3fxBu4a807pzyLy2kAdiNwc7M
        xlCvDtot9ltHFtJoPvuzVbYjzRm5BIFrliLPw0Ljvmi0FANfcKWfkP5d3VB7V5v/
        8Qbmdok2s+gUQm5Qph3kls2Z8ZkB3lHoR2FMYuCDTq15Sp40Snf/bnQz12w8/PRo
        Cu9vfNISCCo3Cmsqd2l8pETs01UR0pL8GuZkCNay3g3XmosYRd5gmsNVSgtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663939276; x=1663942876; bh=EbhR3EzHcu1lr0K7Sz5NCMfapj8o
        1v28ycsPPBQToi4=; b=mORojWFSmbbLIAOsQ31b6EtgOJRcuBc0YSwZE2gBBk3o
        2AgkNf/Nx3MI0gJPElgoKGZiT6+ysWNvKD3bqFaz/cBMVWCLnS9bhZrbul3lzOjA
        jv2IgOSDnh2T4LKqNXor8rffkMR1q5dfwJjS/uMLfwoJwKQNKesSYBNm48TaQXEt
        pxXpQ+5WjYPOUhgmcmauIGN6zYVofzo0He0ib/3N4JJxqBItVfJXZfvMaqn5fm9B
        Nd55N0WFp46uWFyVVqOB8AuosdLxez3ZBrxvaNDr7NdItoYOuoJCL5GxHnonJ9IG
        HIXHIYzCBcJGma8b3JEKG2z/0K9WaSphTjC/ASGUhA==
X-ME-Sender: <xms:zLItY14yNNih0MxQMDBYb4QF1bAnXGqEpGlCp5LpjB_0J7UpuiK-xw>
    <xme:zLItYy4CGC7EOYYuJrNPIMKeRy_3s-Gqo6whNwNN1BbgE0c1TEOGve0NGpyYLKJKI
    u-zQ9EQ4rSv53RIYYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefiedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:zLItY8eZ9g_i6lrL5UEtiTnKDQeQTtSLfTwxpmjI1JGJyv5Xc80c4A>
    <xmx:zLItY-Kvf_QCmc2Q2O1dVDKaxnBKigs2dycPJlSNfiG6W7G10_w6lg>
    <xmx:zLItY5Kz_i7s6QmGeWkd6eKMll4dJcGlwXDa2utQZT0S4Dt-YlIO4w>
    <xmx:zLItY51W0tR4OmXgkDLlZA_V5iy5wQ_kL9bYIu-Ofsy1Fw3Lc1wFRy5aiU4>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 64503B60086; Fri, 23 Sep 2022 09:21:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-935-ge4ccd4c47b-fm-20220914.001-ge4ccd4c4
Mime-Version: 1.0
Message-Id: <47db7fea-eed7-4fb6-9f74-0abe93be3f0d@www.fastmail.com>
In-Reply-To: <CACRpkdYvsktiM5Fzk4g673=r6gJ4WZArJh-HTERsbFBZ5LcJbg@mail.gmail.com>
References: <20220923113822.1445491-1-linus.walleij@linaro.org>
 <b80444c8-70fc-4aa2-9c71-e7e7e90a3696@www.fastmail.com>
 <CACRpkdYvsktiM5Fzk4g673=r6gJ4WZArJh-HTERsbFBZ5LcJbg@mail.gmail.com>
Date:   Fri, 23 Sep 2022 15:20:55 +0200
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

On Fri, Sep 23, 2022, at 2:56 PM, Linus Walleij wrote:
> On Fri, Sep 23, 2022 at 1:58 PM Arnd Bergmann <arnd@arndb.de> wrote:
>> On Fri, Sep 23, 2022, at 1:38 PM, Linus Walleij wrote:
>
>> > A recent change affecting the behaviour of phys_to_dma() to
>> > actually require the device tree ranges to work unmasked a
>> > bug in the Integrator DMA ranges.
>> >
>> > The PL110 uses the CMA allocator to obtain coherent allocations
>> > from a dedicated 1MB video memory, leading to the following
>> > call chain:
>> >
>> > drm_gem_cma_create()
>> >   dma_alloc_attrs()
>> >     dma_alloc_from_dev_coherent()
>> >       __dma_alloc_from_coherent()
>> >         dma_get_device_base()
>> >           phys_to_dma()
>> >             translate_phys_to_dma()
>> >
>> > phys_to_dma() by way of translate_phys_to_dma() will nowadays not
>> > provide 1:1 mappings unless the ranges are properly defined in
>> > the device tree and reflected into the dev->dma_range_map.
>>
>> I don't understand this yet, what did the kernel previously
>> do to that allowed the correct DMA mapping when a wrong
>> address was set in the DT?
>
> Ah this goes way back. I think I need a different fixes tag.
> I hadn't tested this platform in a while.
>
> What happens currently in translate_phys_to_dma() is that it returns
> DMA_MAPPING_ERROR (0xffffffff) because of the buggy device tree
> and that causes the problem.
>
> Before the dma direct rework we selected ARCH_HAS_PHYS_TO_DMA
> and arch/arm/include/asm/dma-direct.h did this:
>
> static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
> {
>         if (dev)
>                 pfn -= dev->dma_pfn_offset;
>         return (dma_addr_t)__pfn_to_bus(pfn);
> }
> (...)
> static inline dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
> {
>         unsigned int offset = paddr & ~PAGE_MASK;
>         return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
> }
>
> As dma_pfn_offset was 0 this resulted in a 1:1 map.

Ah, I see. So the offset was 0 because the dma-ranges
did not actually point to RAM then, right?

> Odd thing: this flag has no device tree bindings I could
> find. Maybe it's in the really old DT docs?

No idea. I do remember that in the old times, whether DMA was
coherent or not was just a compile-time option, so ppc was
usually assumed to be coherent while Arm was not, but then
we needed something to identify machines that were different.

> Here the special memory appears in the CPU address map.
>
>         bus@c0000000 {
>                 compatible = "arm,integrator-ap-lm";
>                 #address-cells = <1>;
>                 #size-cells = <1>;
>                 ranges = <0xc0000000 0xc0000000 0x40000000>;
>                 dma-ranges;
> (...)
>                 lm0: bus@c0000000 {
>                         compatible = "simple-bus";
>                         ranges = <0x00000000 0xc0000000 0x10000000>;
>                         dma-ranges = <0x00000000 0xc0000000 0x10000000>;
>                         reg = <0xc0000000 0x10000000>;
>                         #address-cells = <1>;
>                         #size-cells = <1>;
>
>                         display@1000000 {
>                                 compatible = "arm,pl110", "arm,primecell";
>                                 reg = <0x01000000 0x1000>;
> (...)
>                                 memory-region = <&impd1_ram>;
>                                 dma-ranges;
> (...)
>
> Here we find the reg properly at physical address 0xc1000000 thanks to
> the ranges: 0xc0000000 + 0x00000000 + 0x01000000 = 0xc1000000.
>
> But the special memory region is in the root of the device tree,
> outside of the translation.
>
> Now dma-ranges will assume that when we translate the memory region
> it is in the address space of the display controller, but it isn't,
> because the phandle goes to something in the root of the device tree.
>
> 0xc2000000 + 0x00000000 + 0x00000000 = 0xc2000000
>
> Whenever I do ranges my head start spinning :/
>
> If you have a better way to accomodate the DMA ranges I am happy to
> comply!

I'm still not sure I understand it. Is that reserved memory
area in RAM or on the logic bus? The 'ranges' property makes
it appear that all of 0xc0000000-0xcfffffff is the logic bus,
but then the vram itself is also in that address range, which
would indicate that it is behind that bus. However, using the
'reserved-memory' property indicates that this is actually
just normal RAM that is carved out from what the OS manages.

      Arnd
