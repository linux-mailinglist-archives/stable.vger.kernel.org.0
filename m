Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46135B2933
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiIHWYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 18:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIHWYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 18:24:22 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F6F2D75;
        Thu,  8 Sep 2022 15:24:18 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B193C3200925;
        Thu,  8 Sep 2022 18:24:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 08 Sep 2022 18:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1662675855; x=1662762255; bh=Rf
        KgKsAWDv9z64NkeX5n18eQY3Xy8bpsCYz94ui+NtY=; b=Molw4rTtW99O7fWBBY
        JqfueoWOvGjszRqoyrOkT16LeTOzSFCRBM+Qyh7XibqVXSSKaalOZUZbceLG7NOa
        gltF7xkNlEyOngGni7QtN4tVS9KAkTQJAAGnL7S/hxDhTkSeXprbolZweDOhedAF
        arjiB5MCSAM2OC1CKo4KzOneAwMRH3/dh21l9gz8GOztqnfknk8l4K1o5e3KRdHH
        Xx1+Rb7SzJf720BXqLCMMMttdjHp8Hb5RUpGVzp8tGnHcht3Pw1Il++PUHp6C2uK
        ZNrhcbr3OSaQEiNN2XCns3+2pbfgmspo2yfllexRb/gJ79SHHjhVIZiPkD46Biz+
        VGPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1662675855; x=1662762255; bh=RfKgKsAWDv9z64NkeX5n18eQY3Xy
        8bpsCYz94ui+NtY=; b=Vh6h8h2z+MFzfzawgzNnZoo3DpQ3MEkwGc6lxdGzBosi
        aObzU4WkuR8LFsbxx0RMSQRBiLd9BRPot7vxjdlJ1Koipewjj82G2Q/8DYagzP8J
        Lfj0XegyxxmPdcNbaVsIyh+Ptp/ASMV5Q6obaRbQApr6BH/mbkjaN7VPGTOf9f3e
        f/JZPCu8NnlGiX3dNUDkj6ISblBfHzJ7MuvPlLcKbFlyERxl9eNWip1zkEbKOmni
        sPk7AkQOqDItDmTMwqds1VmeCWp4BFbG8pQC+stGmD2fT/DVwf3qBgIDuXYiiiq0
        IvvtTrZsjoDPCrGIm8JbM6vV7nxldRbekM4i5Cw2LA==
X-ME-Sender: <xms:jmsaY__e0Tg8hXrn7tTp4LH4yqYduKgzLRA29pKvXvdasztrAu9zDw>
    <xme:jmsaY7sov7wAwygEI7MDC7JsLApZQEWsV1smCVjdtWVqAmBHiE-_QWlSWQZ4EujZl
    iYhjE4m0HVFPKId-uM>
X-ME-Received: <xmr:jmsaY9CxwMmdYeOwBGXsCQL5VrYP_mATIVw-k6dzjVP9BCK-pXGMhw6fdL7FuaRLBnak8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedtgedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepfdfmihhr
    ihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlsehshhhuthgvmhhovhdrnh
    grmhgvqeenucggtffrrghtthgvrhhnpefhieeghfdtfeehtdeftdehgfehuddtvdeuheet
    tddtheejueekjeegueeivdektdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:jmsaY7cBcJc4KRtk_cLaCH37Hy8iH2K76Yi7TlbFrYAUQpl22e7Ckg>
    <xmx:jmsaY0PpMp_yY9QKFO2USeHzWMOaEXuIuM5tdu4EUXlrEpNUzmcM2A>
    <xmx:jmsaY9kf6iq7BCLmiAAjqkRjSteEJoTAPcJXJgk6VslZ7wVoCseSYw>
    <xmx:j2saY7dXAPKcjBuCckIgpsoTWRfEpGdonI44i0BmIhhYZKxoGjO1tQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Sep 2022 18:24:14 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 8A241104A93; Fri,  9 Sep 2022 01:24:10 +0300 (+03)
Date:   Fri, 9 Sep 2022 01:24:10 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm: bring back update_mmu_cache() to finish_fault()
Message-ID: <20220908222410.yg2sqqdezzwfi5mj@box.shutemov.name>
References: <20220908204809.2012451-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908204809.2012451-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 11:48:09PM +0300, Sergei Antonov wrote:
> Running this test program on ARMv4 a few times (sometimes just once)
> reproduces the bug.
> 
> int main()
> {
>         unsigned i;
>         char paragon[SIZE];
>         void* ptr;
> 
>         memset(paragon, 0xAA, SIZE);
>         ptr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
>                    MAP_ANON | MAP_SHARED, -1, 0);
>         if (ptr == MAP_FAILED) return 1;
>         printf("ptr = %p\n", ptr);
>         for (i=0;i<10000;i++){
>                 memset(ptr, 0xAA, SIZE);
>                 if (memcmp(ptr, paragon, SIZE)) {
>                         printf("Unexpected bytes on iteration %u!!!\n", i);
>                         break;
>                 }
>         }
>         munmap(ptr, SIZE);
> }
> 
> In the "ptr" buffer there appear runs of zero bytes which are aligned
> by 16 and their lengths are multiple of 16.
> 
> Linux v5.11 does not have the bug, "git bisect" finds the first bad commit:
> f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> 
> Before the commit update_mmu_cache() was called during a call to
> filemap_map_pages() as well as finish_fault(). After the commit
> finish_fault() lacks it.
> 
> Bring back update_mmu_cache() to finish_fault() to fix the bug.
> Also call update_mmu_tlb() only when returning VM_FAULT_NOPAGE to more
> closely reproduce the code of alloc_set_pte() function that existed before
> the commit.
> 
> On many platforms update_mmu_cache() is nop:
>  x86, see arch/x86/include/asm/pgtable
>  ARMv6+, see arch/arm/include/asm/tlbflush.h
> So, it seems, few users ran into this bug.
> 
> Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

+Will.

Seems I confused update_mmu_tlb() with update_mmu_cache() :/

Looks good to me:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> ---
>  mm/memory.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4ba73f5aa8bb..a78814413ac0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4386,14 +4386,20 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>  
>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
>  				      vmf->address, &vmf->ptl);
> -	ret = 0;
> +
>  	/* Re-check under ptl */
> -	if (likely(!vmf_pte_changed(vmf)))
> +	if (likely(!vmf_pte_changed(vmf))) {
>  		do_set_pte(vmf, page, vmf->address);
> -	else
> +
> +		/* no need to invalidate: a not-present page won't be cached */
> +		update_mmu_cache(vma, vmf->address, vmf->pte);
> +
> +		ret = 0;
> +	} else {
> +		update_mmu_tlb(vma, vmf->address, vmf->pte);
>  		ret = VM_FAULT_NOPAGE;
> +	}
>  
> -	update_mmu_tlb(vma, vmf->address, vmf->pte);
>  	pte_unmap_unlock(vmf->pte, vmf->ptl);
>  	return ret;
>  }
> -- 
> 2.34.1
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
