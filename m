Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58BD5385A0
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbiE3P5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240072AbiE3P51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:57:27 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FA371DB9;
        Mon, 30 May 2022 08:47:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t5so14085870edc.2;
        Mon, 30 May 2022 08:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i89MiZL7FoctGZprJstd/24FsFM1pBOpq1jT2psM2/w=;
        b=Pmm6R7ODryNSQKhU+4ZGAn1mJ5EFoZcivG4zihjy/MrAg0/tKmpyJbEk9n5H+s3SHe
         rjZjan0NLlitgoPBP7DcHkuYLmJ5Fi7n6Ap9eFuJR/iSkn0nILK10DElcyrV3TwOA3oa
         16RTsZ3OjxQ79jnEjWo843Qr097RupRvU6dPxgefJzyfRCj9PXAg8REAY2vssjWtfDa4
         Oj9sjEsGWSsqGCk4cbO8wpgB24FANIFEiQDt4l6eubYueR+MeKadjwvSWoXVVETvqfRG
         +9+3XKYVka2VGAZS2K85AIb5XqWQWHZHKImY7HGuokWGpi3fS3ljK8IjAR0MoNlqQPi8
         acRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i89MiZL7FoctGZprJstd/24FsFM1pBOpq1jT2psM2/w=;
        b=F0IiiWYOjTw4KxnmJVSMFJobGI0t+e2O4z3ED9bGR+ImLEDzVYnXW65S7Eac7EMnae
         Ty+X5ib66ZnUFXaIWyRpqnWNMEyIONp2bc4BjlCb/zL2OQgGhzlD79AJ2Cl9rAAmBeIi
         IV7J2zSX5+11OAXn03uR0h3EMHucK1wepSraLsesgzmstaW9in6er6ZY6fs8T7LpFHjV
         5VDwjFd3eABOg8qhhxgf7D1hBxhaAKrNQlfvPj1p7RbKzVDApohZWCJuPnudJN7+wxRG
         1q+2Wzo0e2V8LOvnE18+vprRbn6dqcUBT9mwIngupofeCyUjRFbOYKrDNd+3Bfnbkiud
         hgLw==
X-Gm-Message-State: AOAM533KAsibzjMPU71si6UI/jBvuv22zh3HcUwSCgmblJCO5AInPL1r
        MGlC14HEovppcz/NKCTMeNLr4JVSGllGVw==
X-Google-Smtp-Source: ABdhPJxEXlNrQ7YReCEUVjXaOToLbotp+0keekiWM9uAtwUQmOqsR3pScuMyzv0b8iWjSwaCg2e2iw==
X-Received: by 2002:a05:6402:14c1:b0:42d:d6f1:ac3d with SMTP id f1-20020a05640214c100b0042dd6f1ac3dmr3289957edx.223.1653925634248;
        Mon, 30 May 2022 08:47:14 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id b89-20020a509f62000000b0042dd7e13391sm913080edf.45.2022.05.30.08.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 08:47:13 -0700 (PDT)
Message-ID: <12bb8139-be66-4e08-47be-909b0042926c@gmail.com>
Date:   Mon, 30 May 2022 17:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.18 074/159] scsi: target: tcmu: Fix possible
 data corruption
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-74-sashal@kernel.org>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220530132425.1929512-74-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,

the below patch introduces a new bug, which is fixed by commit
   325d5c5fb216 ("scsi: target: tcmu: Avoid holding XArray lock when calling lock_page")
Please consider adding this further fix.

For my understanding: commit 325d5c5fb216 contains a "Fixes:"
tag. So I'd expect it to be added automatically.
Is there still something missing in the commit?

Thank you,
Bodo


On 30.05.22 15:22, Sasha Levin wrote:
> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> [ Upstream commit bb9b9eb0ae2e9d3f6036f0ad907c3a83dcd43485 ]
> 
> When tcmu_vma_fault() gets a page successfully, before the current context
> completes page fault procedure, find_free_blocks() may run and call
> unmap_mapping_range() to unmap the page. Assume that when
> find_free_blocks() initially completes and the previous page fault
> procedure starts to run again and completes, then one truncated page has
> been mapped to userspace. But note that tcmu_vma_fault() has gotten a
> refcount for the page so any other subsystem won't be able to use the page
> unless the userspace address is unmapped later.
> 
> If another command subsequently runs and needs to extend dbi_thresh it may
> reuse the corresponding slot for the previous page in data_bitmap. Then
> though we'll allocate new page for this slot in data_area, no page fault
> will happen because we have a valid map and the real request's data will be
> lost.
> 
> Filesystem implementations will also run into this issue but they usually
> lock the page when vm_operations_struct->fault gets a page and unlock the
> page after finish_fault() completes. For truncate filesystems lock pages in
> truncate_inode_pages() to protect against racing wrt. page faults.
> 
> To fix this possible data corruption scenario we can apply a method similar
> to the filesystems.  For pages that are to be freed, tcmu_blocks_release()
> locks and unlocks. Make tcmu_vma_fault() also lock found page under
> cmdr_lock. At the same time, since tcmu_vma_fault() gets an extra page
> refcount, tcmu_blocks_release() won't free pages if pages are in page fault
> procedure, which means it is safe to call tcmu_blocks_release() before
> unmap_mapping_range().
> 
> With these changes tcmu_blocks_release() will wait for all page faults to
> be completed before calling unmap_mapping_range(). And later, if
> unmap_mapping_range() is called, it will ensure stale mappings are removed.
> 
> Link: https://lore.kernel.org/r/20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com
> Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/target/target_core_user.c | 40 ++++++++++++++++++++++++++++---
>   1 file changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index fd7267baa707..b1fd06edea59 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -20,6 +20,7 @@
>   #include <linux/configfs.h>
>   #include <linux/mutex.h>
>   #include <linux/workqueue.h>
> +#include <linux/pagemap.h>
>   #include <net/genetlink.h>
>   #include <scsi/scsi_common.h>
>   #include <scsi/scsi_proto.h>
> @@ -1667,6 +1668,26 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>   	xas_lock(&xas);
>   	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>   		xas_store(&xas, NULL);
> +		/*
> +		 * While reaching here there may be page faults occurring on
> +		 * the to-be-released pages. A race condition may occur if
> +		 * unmap_mapping_range() is called before page faults on these
> +		 * pages have completed; a valid but stale map is created.
> +		 *
> +		 * If another command subsequently runs and needs to extend
> +		 * dbi_thresh, it may reuse the slot corresponding to the
> +		 * previous page in data_bitmap. Though we will allocate a new
> +		 * page for the slot in data_area, no page fault will happen
> +		 * because we have a valid map. Therefore the command's data
> +		 * will be lost.
> +		 *
> +		 * We lock and unlock pages that are to be released to ensure
> +		 * all page faults have completed. This way
> +		 * unmap_mapping_range() can ensure stale maps are cleanly
> +		 * removed.
> +		 */
> +		lock_page(page);
> +		unlock_page(page);
>   		__free_page(page);
>   		pages_freed++;
>   	}
> @@ -1822,6 +1843,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>   	page = xa_load(&udev->data_pages, dpi);
>   	if (likely(page)) {
>   		get_page(page);
> +		lock_page(page);
>   		mutex_unlock(&udev->cmdr_lock);
>   		return page;
>   	}
> @@ -1863,6 +1885,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   	struct page *page;
>   	unsigned long offset;
>   	void *addr;
> +	vm_fault_t ret = 0;
>   
>   	int mi = tcmu_find_mem_index(vmf->vma);
>   	if (mi < 0)
> @@ -1887,10 +1910,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   		page = tcmu_try_get_data_page(udev, dpi);
>   		if (!page)
>   			return VM_FAULT_SIGBUS;
> +		ret = VM_FAULT_LOCKED;
>   	}
>   
>   	vmf->page = page;
> -	return 0;
> +	return ret;
>   }
>   
>   static const struct vm_operations_struct tcmu_vm_ops = {
> @@ -3205,12 +3229,22 @@ static void find_free_blocks(void)
>   			udev->dbi_max = block;
>   		}
>   
> +		/*
> +		 * Release the block pages.
> +		 *
> +		 * Also note that since tcmu_vma_fault() gets an extra page
> +		 * refcount, tcmu_blocks_release() won't free pages if pages
> +		 * are mapped. This means it is safe to call
> +		 * tcmu_blocks_release() before unmap_mapping_range() which
> +		 * drops the refcount of any pages it unmaps and thus releases
> +		 * them.
> +		 */
> +		pages_freed = tcmu_blocks_release(udev, start, end - 1);
> +
>   		/* Here will truncate the data area from off */
>   		off = udev->data_off + (loff_t)start * udev->data_blk_size;
>   		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>   
> -		/* Release the block pages */
> -		pages_freed = tcmu_blocks_release(udev, start, end - 1);
>   		mutex_unlock(&udev->cmdr_lock);
>   
>   		total_pages_freed += pages_freed;
