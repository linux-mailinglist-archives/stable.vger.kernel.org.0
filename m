Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9737E633745
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiKVIiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVIiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:38:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025F031235
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 00:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669106222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QLruKr0Jr2eahRROoPUxGVXkoCQ/kZQ9K7AIqvtY87M=;
        b=TjsRt3I/j0P59n2suUmMgjor4CuRMZufl+HBEKU55kCee41Q2WKkVoSdOeyTAQpXsIrEdG
        knjvg42OahMI60ukHMdlyhi5UDTqUTK/eEdDfoS1yOgW6bB6oAlliG1JuIDPlB+BXappfu
        mil83SzOqMQLwBPSnws2vUOyJb2vAyw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-Gz8Cicg5OFyW7qUfFAzFnA-1; Tue, 22 Nov 2022 03:37:00 -0500
X-MC-Unique: Gz8Cicg5OFyW7qUfFAzFnA-1
Received: by mail-wr1-f70.google.com with SMTP id d11-20020adfa40b000000b00241db65ec27so1482419wra.10
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 00:37:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLruKr0Jr2eahRROoPUxGVXkoCQ/kZQ9K7AIqvtY87M=;
        b=q/PKLqPLLN37Zm47juepor8+dW1EbANbu/jQBjfcbySCPrL/kGAuu62fHX1tIsw9Ch
         uxFWw7FpTLOkStimHis/f9SH5SM7+RhkXQfLgyfnVOouXW0vtWXpsgTv9zlNTgf/On3h
         zFMyaI0l3/8+oiXPgUbu7oKr6N2E4hnJ51m5/Pbt5ST6NZc0YCdvECWYLjnNCPYteQkv
         brQpxVpRSui/6IFyAH4oNjIq64OeWdofDne8g470kzMT4czfdnNUcvR6M8qbkA6C5Pqu
         5rAUP5Y0ISlgtn2a9+PanQEEdPjzfXe1/7vfYdaT5gXqxWJgs43TviPxuQMWeFV5VEMe
         +LbQ==
X-Gm-Message-State: ANoB5pk+K1ukc91ZBVnZUMI90cPfZRC4aLOwrdf4sLV/jF2xVHqZHtlZ
        hZczVvO9ijnfXyULyjr3GrfhsXkqxBCCUEQgazuLbPkuDnVJ7hmcja1XE6p1dHf8cCx5PH3Tv+r
        v3KADO4w32HTV1AFw
X-Received: by 2002:adf:f38a:0:b0:236:5270:7347 with SMTP id m10-20020adff38a000000b0023652707347mr13776270wro.35.1669106219571;
        Tue, 22 Nov 2022 00:36:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Jpq8EHSKME9hAJw0iZDI3FnUcjkLgwyOZsbm/iLUpg4dCKbX5r0QXPyxe27p+C7Ps22imIA==
X-Received: by 2002:adf:f38a:0:b0:236:5270:7347 with SMTP id m10-20020adff38a000000b0023652707347mr13776245wro.35.1669106219206;
        Tue, 22 Nov 2022 00:36:59 -0800 (PST)
Received: from [192.168.3.108] (p5b0c65c4.dip0.t-ipconnect.de. [91.12.101.196])
        by smtp.gmail.com with ESMTPSA id a5-20020adfe5c5000000b00241bc209ae0sm12955717wrn.32.2022.11.22.00.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 00:36:58 -0800 (PST)
Message-ID: <b1bc82e2-a789-85f4-d428-c5f1b451f4b7@redhat.com>
Date:   Tue, 22 Nov 2022 09:36:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] mm: set the vma flags dirty before testing if it is
 mergeable
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, kernel@collabora.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20221122082442.1938606-1-usama.anjum@collabora.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20221122082442.1938606-1-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.11.22 09:24, Muhammad Usama Anjum wrote:
> The VM_SOFTDIRTY should be set in the vma flags to be tested if new
> allocation should be merged in previous vma or not. With this patch,
> the new allocations are merged in the previous VMAs.
> 
> I've tested it by reverting the commit 34228d473efe ("mm: ignore
> VM_SOFTDIRTY on VMA merging") and after adding this following patch,
> I'm seeing that all the new allocations done through mmap() are merged
> in the previous VMAs. The number of VMAs doesn't increase drastically
> which had contributed to the crash of gimp. If I run the same test after
> reverting and not including this patch, the number of VMAs keep on
> increasing with every mmap() syscall which proves this patch.
> 
> The commit 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
> seems like a workaround. But it lets the soft-dirty and non-soft-dirty
> VMA to get merged. It helps in avoiding the creation of too many VMAs.
> But it creates the problem while adding the feature of clearing the
> soft-dirty status of only a part of the memory region.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: d9104d1ca966 ("mm: track vma changes with VM_SOFTDIRTY bit")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> We need more testing of this patch.
> 
> While implementing clear soft-dirty bit for a range of address space, I'm
> facing an issue. The non-soft dirty VMA gets merged sometimes with the soft
> dirty VMA. Thus the non-soft dirty VMA become dirty which is undesirable.
> When discussed with the some other developers they consider it the
> regression. Why the non-soft dirty page should appear as soft dirty when it
> isn't soft dirty in reality? I agree with them. Should we revert
> 34228d473efe or find a workaround in the IOCTL?
> 
> * Revert may cause the VMAs to expand in uncontrollable situation where the
> soft dirty bit of a lot of memory regions or the whole address space is
> being cleared again and again. AFAIK normal process must either be only
> clearing a few memory regions. So the applications should be okay. There is
> still chance of regressions if some applications are already using the
> soft-dirty bit. I'm not sure how to test it.
> 
> * Add a flag in the IOCTL to ignore the dirtiness of VMA. The user will
> surely lose the functionality to detect reused memory regions. But the
> extraneous soft-dirty pages would not appear. I'm trying to do this in the
> patch series [1]. Some discussion is going on that this fails with some
> mprotect use case [2]. I still need to have a look at the mprotect selftest
> to see how and why this fails. I think this can be implemented after some
> more work probably in mprotect side.
> 
> [1] https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
> [2] https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/
> ---
>   mm/mmap.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index f9b96b387a6f..6934b8f61fdc 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1708,6 +1708,15 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>   		vm_flags |= VM_ACCOUNT;
>   	}
>   
> +	/*
> +	 * New (or expanded) vma always get soft dirty status.
> +	 * Otherwise user-space soft-dirty page tracker won't
> +	 * be able to distinguish situation when vma area unmapped,
> +	 * then new mapped in-place (which must be aimed as
> +	 * a completely new data area).
> +	 */
> +	vm_flags |= VM_SOFTDIRTY;
> +
>   	/*
>   	 * Can we just expand an old mapping?
>   	 */
> @@ -1823,15 +1832,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
>   	if (file)
>   		uprobe_mmap(vma);
>   
> -	/*
> -	 * New (or expanded) vma always get soft dirty status.
> -	 * Otherwise user-space soft-dirty page tracker won't
> -	 * be able to distinguish situation when vma area unmapped,
> -	 * then new mapped in-place (which must be aimed as
> -	 * a completely new data area).
> -	 */
> -	vma->vm_flags |= VM_SOFTDIRTY;
> -
>   	vma_set_page_prot(vma);

vma_set_page_prot(vma) has to be called after adjusting vma->vm_flags.

Did not look into the details here, but that jumped at me.

-- 
Thanks,

David / dhildenb

