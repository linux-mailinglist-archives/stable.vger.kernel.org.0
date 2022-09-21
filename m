Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351D05BFA39
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 11:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIUJIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 05:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiIUJIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 05:08:00 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82774DB1F
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 02:07:58 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B07A23200992;
        Wed, 21 Sep 2022 05:07:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 21 Sep 2022 05:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1663751274; x=1663837674; bh=OWYQB8dlis
        nciOnTm8pcsx623R2njTSVMgjP2sVIwDc=; b=ZEdwMm6TMyissd1ntWIe4HcqPL
        dtnKUiJwuP7Vqa22rhxzKu2G9SBd+sXFQ6k0b1mTFIePqs1Ayu74nZZYjpMMvPNO
        a5cFhZnQAT9bMq7Zt5n9rQCXRcvMiJ9cMcs8SfhoHTQ76JrKN9K6bdjHqtQi9L9h
        D9UWA6tK8SvmD38gdFKl8pug+gJ6qQNWGnmypK7otjKk1PRDb8Ro5okRuuUewyqx
        oqhokNeMcXsuIrjy0l9mo1lI1PiWsbfv+56Ghy7O0SxNUX4pezPqOez6uWPva+wF
        DhdykGkld3GJ0lE8NL1LGVb4QpdwNuw+0XqnHgGF89VUKpZmazmG93ll3TyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663751274; x=1663837674; bh=OWYQB8dlisnciOnTm8pcsx623R2n
        jTSVMgjP2sVIwDc=; b=SQ4SBOWnSycZi68Y2XqzJUTbVTvxU8/LUIbeK7TDCJPh
        KdF3Cq/Dp6MJaALxMqvkGGwlzOM9lnfLKlGCsLd+YE8UqZvbXZZvFh7Bw9T6ijsL
        NXcGi2bBgI+f1aqyekYmMz/8ZRhQtPEjwmEP2IoQ6K2U29PoMElsVBIYzTlfObb8
        RS5c6t7iAtMV7AOwe8EL0p/hkz9CRk1j94MqEa0JA4AqSBAJbe6TMYuYssQYVmxi
        E+eoWyDhgSw0yKzopRGCNmdpDz8lYxStGGCrepKXBRReTiaUeyeKmZ70NIMNnWnu
        2PVovcvIRTDWC4xT6oJAipJimBtfBIQzOfF2aZW3Ag==
X-ME-Sender: <xms:adQqY1o1coZHq5zMM2v8ks7VnWd1QPj5pjQWQn-MGnwO3e6eYFY9bA>
    <xme:adQqY3qvfV1yn2gzcOzoA-e4CBN__4WqcH6-m57pMoEIJeAF_t6-cWWPGbY1EC6mo
    8nsCNu1p_Q2ew>
X-ME-Received: <xmr:adQqYyOrA0KeNovMynojvWIIRjM-4K4qUs0IY-pfgebmTi_ZYjpwYbXjdzwqvfQweM4WXty05Ee_MR2XUN24QE6APlrp23zG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefuddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:adQqYw68eMpsfP2DYSahPB10Rc_Az_9w0g7HaKlLnliUfKnB61hWJw>
    <xmx:adQqY05qiGuKrnBzK0ZPA_91bayduZs6jSS8w3PUPP9MY1f9QYtIlw>
    <xmx:adQqY4jzZX2woukC8kGD9hjgRYQHdSKHUNBH0cw7x8h00Te9wHiw0w>
    <xmx:atQqY2uiz62alXPGNp1e2_W8WV0dCXvumSuuxhMVlcYWxAOgZPERFA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Sep 2022 05:07:53 -0400 (EDT)
Date:   Wed, 21 Sep 2022 11:07:50 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.15 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Message-ID: <YyrUZgOVjxoRW53K@kroah.com>
References: <20220921085851.2097270-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921085851.2097270-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 11:58:51AM +0300, Ovidiu Panait wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.
> 
> Flush the CPU caches when memory is reclaimed from an SEV guest (where
> reclaim also includes it being unmapped from KVM's memslots).  Due to lack
> of coherency for SEV encrypted memory, failure to flush results in silent
> data corruption if userspace is malicious/broken and doesn't ensure SEV
> guest memory is properly pinned and unpinned.
> 
> Cache coherency is not enforced across the VM boundary in SEV (AMD APM
> vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
> VM guests have to be explicitly flushed on the host side. If a memory page
> containing dirty confidential cachelines was released by VM and reallocated
> to another user, the cachelines may corrupt the new user at a later time.
> 
> KVM takes a shortcut by assuming all confidential memory remain pinned
> until the end of VM lifetime. Therefore, KVM does not flush cache at
> mmu_notifier invalidation events. Because of this incorrect assumption and
> the lack of cache flushing, malicous userspace can crash the host kernel:
> creating a malicious VM and continuously allocates/releases unpinned
> confidential memory pages when the VM is running.
> 
> Add cache flush operations to mmu_notifier operations to ensure that any
> physical memory leaving the guest VM get flushed. In particular, hook
> mmu_notifier_invalidate_range_start and mmu_notifier_release events and
> flush cache accordingly. The hook after releasing the mmu lock to avoid
> contention with other vCPUs.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Sean Christpherson <seanjc@google.com>
> Reported-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Message-Id: <20220421031407.2516575-4-mizhang@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: adjusted KVM_X86_OP_OPTIONAL() -> KVM_X86_OP_NULL, applied
> kvm_arch_guest_memory_reclaimed() call in kvm_set_memslot()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> This fixes CVE-2022-0171.

Now queued up, thanks.

greg k-h
