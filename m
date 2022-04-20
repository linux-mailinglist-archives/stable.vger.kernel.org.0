Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C48508323
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376621AbiDTIJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 04:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376631AbiDTIJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 04:09:17 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD6CE35
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 01:06:31 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id c1so814378qvl.3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 01:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+eE3WMmFBHt9qFLIivrenNFjT6R/u5U6XLtVu6wSVa4=;
        b=Erq3+piETQp5RWzwuFjK9X3j+PcBZrBcFwHVVHWoNkc5BLWhm6a6xeNm8TCZz2SOL8
         f5Db0959Jq5aYJtp62b5f3klqBty+15MCTFgQzNSRZFsRH7sSum1c9xYV9cJkvWcQrXn
         lTLPc0WNET0R6aBwyHs/6kHn+AJ+AHByzu4tXlVvhInBxtkYVVb9QZcSiYlPCI7XLmFw
         6kkMedNi4WCOvlFG9LzxCwYng8kuqoTzqJj3JbT/EW7K5UXkuiXGhwwe8G7I3xgcZYLs
         XSnCh97TCEtwi+0c0rDQ3NM5FUGwg8QqMKG/QtBB8EosVzAot/QMT+/pVVNGavnZ0MmA
         sHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+eE3WMmFBHt9qFLIivrenNFjT6R/u5U6XLtVu6wSVa4=;
        b=GT0f/tn/MsoTix1ZDPk4/43Uu/2Yopzhxwi6UURnmaQFcK+80Nw3+n9+Ohw+wrE2b5
         IILLiW2gyWe+ZMF3C5wLPXsYsXeB3Nc3nNT/gJCmp3XXvmUsQ5cYzSOWr269TUaaDw4a
         HxUhuyYKm3USeVSTfNM3O1NtCpZD7epFQBjqLqMfu2waXCp+QqLp/xEjykYpTr26w7iq
         AoMD6Qvj/HjYlwXgLMOjhL68UO9rjYMpRCN++aveGqOsCm/Z3E035SUE7kA7QNuFDfsT
         MjIzBtNp9OwKOAtZUz0aIaiDHFEaSWLUroh86QGmLhgzVk8gGoenxbZ55+oPKZb4dJxY
         5DgA==
X-Gm-Message-State: AOAM532e6B//uQyihRuFu6sTPfLY00CQ88D9KoWngsvrwWgPyCh6qiDA
        omOp4nwVyR0VNqKauLBnx7/uVA==
X-Google-Smtp-Source: ABdhPJwAhnapy/3QfM8gMgmTzWAzita1u/CrFffinAcEwTa3eqdvUFvcrn3uzoKu1buIbLYYEdt1Vw==
X-Received: by 2002:ad4:5b8f:0:b0:446:646a:a508 with SMTP id 15-20020ad45b8f000000b00446646aa508mr8529527qvp.113.1650441990983;
        Wed, 20 Apr 2022 01:06:30 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id p3-20020a05620a15e300b0069e5b556f75sm1128265qkm.5.2022.04.20.01.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:06:30 -0700 (PDT)
Date:   Wed, 20 Apr 2022 09:06:02 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     jgg@ziepe.ca, will@kernel.org, robin.murphy@arm.com,
        joro@8bytes.org, jacob.jun.pan@linux.intel.com,
        baolu.lu@linux.intel.com, fenghua.yu@intel.com,
        rikard.falkeborn@gmail.com, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/arm-smmu-v3: Fix size calculation in
 arm_smmu_mm_invalidate_range()
Message-ID: <Yl++6nLMLuOFcFPM@myrica>
References: <20220419210158.21320-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419210158.21320-1-nicolinc@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:01:58PM -0700, Nicolin Chen wrote:
> The arm_smmu_mm_invalidate_range function is designed to be called
> by mm core for Shared Virtual Addressing purpose between IOMMU and
> CPU MMU. However, the ways of two subsystems defining their "end"
> addresses are slightly different. IOMMU defines its "end" address
> using the last address of an address range, while mm core defines
> that using the following address of an address range:
> 
> 	include/linux/mm_types.h:
> 		unsigned long vm_end;
> 		/* The first byte after our end address ...
> 
> This mismatch resulted in an incorrect calculation for size so it
> failed to be page-size aligned. Further, it caused a dead loop at
> "while (iova < end)" check in __arm_smmu_tlb_inv_range function.
> 
> This patch fixes the issue by doing the calculation correctly.
> 
> Fixes: 2f7e8c553e98d ("iommu/arm-smmu-v3: Hook up ATC invalidation to mm ops")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Thanks for the fix, I guess we didn't catch this earlier because our test
platforms didn't support range invalidation, so __arm_smmu_tlb_inv_range()
would always use PAGE_SIZE as increment.

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 22ddd05bbdcd..c623dae1e115 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -183,7 +183,14 @@ static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
>  {
>  	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
>  	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
> -	size_t size = end - start + 1;
> +	size_t size;
> +
> +	/*
> +	 * The mm_types defines vm_end as the first byte after the end address,
> +	 * different from IOMMU subsystem using the last address of an address
> +	 * range. So do a simple translation here by calculating size correctly.
> +	 */
> +	size = end - start;
>  
>  	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
>  		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,
> -- 
> 2.17.1
> 
