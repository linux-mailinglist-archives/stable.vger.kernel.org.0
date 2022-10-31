Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED7A6130D6
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJaHAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJaHAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:00:24 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE3BE25;
        Mon, 31 Oct 2022 00:00:23 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 05D015C0114;
        Mon, 31 Oct 2022 03:00:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 31 Oct 2022 03:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1667199621; x=1667286021; bh=FlOhn5ec4h
        6YpIkTt0wBHtNETYa00dxGlCrJmbxltqA=; b=Lfl52b5y8sc7Fx4sIAU7eWeC99
        QAfEnPteNR1NLONyRWLGEPvQwya4oJSXEkvK/E05C5nDsbNYtNKmGiKSSSSkJp2T
        COkicUBf/DpWe63euIbxxj9Z2FFRovwpdAUrVuouYSNmdFDIV254ImD3jEiDbF8i
        Pf3Wyk7QEcdAxJWDAYlYgSdURh6ZNYffsVq1yxLS36I3qToMMx1LhhUNWdM/uNDd
        TFJHbFtWIgkBNmL9RRYZ7ToYuc8pjEvKNevcna6KTG0bAySZ2Li7WG5INS6QLXCF
        XqcCbTQajGy5wcOrq4riT7gJI7cyERFlLmAA1WLB5uJ0weUlkibSsc5bUGhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667199621; x=1667286021; bh=FlOhn5ec4h6YpIkTt0wBHtNETYa0
        0dxGlCrJmbxltqA=; b=R9AlrA56WlFd0CkGrOhRn/zp8sowRd5frIRItLfMpFR7
        7o6YktRGX9IUVDtaKgwiDUtRLpSzFkeowUXwTqbi/S3NoVdA9AYQ8pmu+Wg9BwT8
        novNcM62J2iOYauh88W7m4FEOTdy512BdaGQ9XbxDZlpP/FEdlXA5EcTt4aRYv96
        M2s8VIxHf6EfELsd+g5yce1/uxsLGu0/OLWSZmD2+ggXbAiubfyK42/eoNBFTVFT
        0denmyoyelc7gfnxGr/LfSn0fGGhdnHbip9U55f8NCSxg04lg0ETgqSIyQWKEkN/
        GLyGD5M5R/FleP5YL22WqN2ps5LC7GtlLQuXoVVFdA==
X-ME-Sender: <xms:hHJfY7L2PLtorLlCayPsUDBtsWegcyI2ql6FSm2u4SsmwfODFu_ZGw>
    <xme:hHJfY_IRp44dehfDxD_FRQ3g3MFyRET-FF6WN-nczDCPto2yHpsxaqHCM-r-qLvuh
    Gy7A6_ybBK26g>
X-ME-Received: <xmr:hHJfYztoujUGCboyO32fAa1uPoqI94IVs3L7n1ABLojg4j_uIEUm8FEbVLPhykKZ6heJQ8ZFm8s8wLtLeuwjoWI2eAhy8SlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedruddugddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hHJfY0bPSt-OZZMAWoNUB6AVBc0zmT9sVkckQxnOcywTtLivhGqHiw>
    <xmx:hHJfYybp3k13o-1y1oX8rSVBHouunRtLHla-ECemircz3zclosLe7A>
    <xmx:hHJfY4AFUNG32XSrRGMtiW8_BLCujcRE9IrB4j2YOwT8APWdPE6n2Q>
    <xmx:hXJfYyJNvA0urQFKjcXLxp0cxS5DxtIWyNPbvdmJ4fdeMtn5QkiMJg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Oct 2022 03:00:19 -0400 (EDT)
Date:   Mon, 31 Oct 2022 08:00:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     stable@vger.kernel.org, sjitindarsingh@gmail.com,
        cascardo@canonical.com, kvm@vger.kernel.org, pbonzini@redhat.com,
        jpoimboe@kernel.org, peterz@infradead.org, x86@kernel.org
Subject: Re: [PATCH 4.14 00/34] Retbleed & PBRSB Mitigations
Message-ID: <Y19ymueuSZ1MRrmm@kroah.com>
References: <20221027204801.13146-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027204801.13146-1-surajjs@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 01:48:01PM -0700, Suraj Jitindar Singh wrote:
> This backport adds support for Retbleed and PBRSB mitigations for Intel parts.
> 
> Some AMD parts are added to simplify context however support for IBPB or UNRET
> is not included in this series. The reporting of whether a cpu is affected
> should be correct however.
> 
> Most patches applied cleanly or required only context changes, the major
> difference between this series and upstream is the fact that the kvm entry
> path is in inline asm in the 4.14 tree and so this had to be accommodated
> in patches:
>  - x86/speculation: Fill RSB on vmexit for IBRS
>  - x86/speculation: Add RSB VM Exit protections
> 
> This series is unsurprisingly very similar to that for the 5.4 backport [1].
> 
> Boot tested on a variety of Intel and AMD systems.
> 
> Tested correct reporting of vulnerabilities and mitigation selection on Skylake,
> Cascade Lake, Ice Lake and Zen3 parts.
> 
> [1] https://lore.kernel.org/stable/20221003131038.12645-1-cascardo@canonical.com/

Note, you forgot to sign off on a lot of these patches.  Whenever you
submit a patch, you need to also do that as the patch came through you.

I've queued these up now, and will go do a 4.14.y-rc release with just
these in it to get some testing separate from other changes.

thanks,

greg k-h
