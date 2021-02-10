Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87BD316F4C
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhBJSyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbhBJSxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 13:53:12 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D424C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:52:25 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z32so2307768qtd.8
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SwU0ayPD0PtSCkVTXGkFA8DKhH7jfcjQKb0CMqGBDz0=;
        b=lDkUUi8AjKwiBggsItTz5fUfL6ihzyBnWNcdCGwwMOkgXaZHVsT/vKdFHSkGeioDd2
         uMudoAujVvf7ESxw9FMOvpYTBVd6NkEd9N+4xHqE7hgjsnVZZ4Z/j8Z9OQlLuBDI8DdH
         GrQvyZQjIuo7GBPJ5x0AVF0eiQNaDPM93mVmA8Iwmj7WW5TFmKeHdEzZH/JwzN4mcuMP
         T+HBCynnJOD3FjBBM9yYolT08s0x28FF4g2srNhXR0qEV3r5HLO3jqXdCo2+tYabTiqd
         eTVj/0//DQmc8rL+sftuFhlQIhVkhN7uagdSUiLAF3NZny/xQR+/h1nA4rXkn67ekQ4s
         BNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SwU0ayPD0PtSCkVTXGkFA8DKhH7jfcjQKb0CMqGBDz0=;
        b=bHNxGQDp76KQ0F9SVy6i2O5wjCdrwOUF+eZvdMguPnF9MkHFWSG8kj6QP4dBdidP7Z
         8laAVLzLgg0wbLF1ABQjxsDEl52W7/HESg1ul+Tj9tEvrZ7OzZfcEluvF8RJD/sQZiOB
         7joC66kTDvrzNq0ma1EvDr6Y98LIyz1ZYVVhsuKR0TDyA8+E/W3MyAdr/RnRHqE7agAb
         fuV2kzyWe/0yvU1xvgt1567vBwSsrG/XmUhfRX9/uSgSMOEfZsMB9m89KHbvKg4RebIU
         +NHq6Hwixvl2xQjmdLB7c/dlRLXrUKYxBB5jImoNLzFgO5WV9mpbdlA83WJCAzF1IV1T
         H1VQ==
X-Gm-Message-State: AOAM5338F7CbXs+pfFou5s4HLJmDYJJHBPqsrnAvOO+nmrxgkwRpGmoI
        HNhOxBq2GpPoB/PoloZq0DMUsQ==
X-Google-Smtp-Source: ABdhPJwZDpNnFBsjuGRuyx1pJMiCb5NXUC2u1+xE33psBZRBUsIN4ZHQZnTzhLFWLPkt2wCmz5qCbQ==
X-Received: by 2002:aed:2be3:: with SMTP id e90mr3962805qtd.367.1612983144130;
        Wed, 10 Feb 2021 10:52:24 -0800 (PST)
Received: from ?IPv6:2804:7f0:8284:af7a:15d8:1333:f294:716b? ([2804:7f0:8284:af7a:15d8:1333:f294:716b])
        by smtp.gmail.com with ESMTPSA id w143sm2029690qka.58.2021.02.10.10.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 10:52:23 -0800 (PST)
Subject: Re: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero
 page
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Kevin Brodsky <kevin.brodsky@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        David Spickett <david.spickett@linaro.org>
References: <20210210180316.23654-1-catalin.marinas@arm.com>
From:   Luis Machado <luis.machado@linaro.org>
Message-ID: <0916e89e-46b5-6002-7f9d-5d1df9e3e205@linaro.org>
Date:   Wed, 10 Feb 2021 15:52:18 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210210180316.23654-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/10/21 3:03 PM, Catalin Marinas wrote:
> The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
> page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
> page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
> -EIO.
> 
> A newly created (PROT_MTE) mapping points to the zero page which had its
> tags zeroed during cpu_enable_mte(). If there were no prior writes to
> this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
> page does not have the PG_mte_tagged flag set.
> 
> Set PG_mte_tagged on the zero page when its tags are cleared during
> boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
> !PROT_MTE mappings pointing to the zero page, change the
> __access_remote_tags() check to (vm_flags & VM_MTE) instead of
> PG_mte_tagged.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Will Deacon <will@kernel.org>
> Reported-by: Luis Machado <luis.machado@linaro.org>
> ---
> 
> The fix is actually checking VM_MTE instead of PG_mte_tagged in
> __access_remote_tags() but I added the WARN_ON(!PG_mte_tagged) and
> setting the flag on the zero page in case we break this assumption in
> the future.
> 
>   arch/arm64/kernel/cpufeature.c | 6 +-----
>   arch/arm64/kernel/mte.c        | 3 ++-
>   2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e99eddec0a46..3e6331b64932 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1701,16 +1701,12 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>   #ifdef CONFIG_ARM64_MTE
>   static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>   {
> -	static bool cleared_zero_page = false;
> -
>   	/*
>   	 * Clear the tags in the zero page. This needs to be done via the
>   	 * linear map which has the Tagged attribute.
>   	 */
> -	if (!cleared_zero_page) {
> -		cleared_zero_page = true;
> +	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
>   		mte_clear_page_tags(lm_alias(empty_zero_page));
> -	}
>   
>   	kasan_init_hw_tags_cpu();
>   }
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index dc9ada64feed..80b62fe49dcf 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -329,11 +329,12 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
>   		 * would cause the existing tags to be cleared if the page
>   		 * was never mapped with PROT_MTE.
>   		 */
> -		if (!test_bit(PG_mte_tagged, &page->flags)) {
> +		if (!(vma->vm_flags & VM_MTE)) {
>   			ret = -EOPNOTSUPP;
>   			put_page(page);
>   			break;
>   		}
> +		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
>   
>   		/* limit access to the end of the page */
>   		offset = offset_in_page(addr);
> 

Thanks. I gave this a try and it works as expected. So memory that is 
PROT_MTE but has not been accessed yet can be inspected with PEEKMTETAGS 
without getting an EIO back.
