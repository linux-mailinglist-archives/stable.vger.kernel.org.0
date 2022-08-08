Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F358CC08
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 18:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243251AbiHHQV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 12:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHHQVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 12:21:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10DA865F9
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 09:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659975710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZIIp+4XezCD9XhW5KqD0Wp8O30CPtOvkN45ZhL43/sI=;
        b=awkPxjqUn0LbMxlakg6lPLn1bwVvPC5TN1zl8zfdTssmwHusg3zupNTHxRR1Rk1Mdlyfs/
        OMGkA7zEK7VcRhqRcdVFyarD82YfY2cuDaap72ys0nfWb2YdV/1OoRobjFA4wqz9yp0Lqt
        Cne5zvD1TVfEGYd6ycjAM0f9MpQOb1o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-WXAMzmaHOUe4K-zlxoNDnA-1; Mon, 08 Aug 2022 12:21:48 -0400
X-MC-Unique: WXAMzmaHOUe4K-zlxoNDnA-1
Received: by mail-qv1-f70.google.com with SMTP id nk7-20020a056214350700b0047688bd2105so4723920qvb.16
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 09:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ZIIp+4XezCD9XhW5KqD0Wp8O30CPtOvkN45ZhL43/sI=;
        b=XA8o0rSAXAFQ8GrRXAgfyQ+Zziyq9sa3ZdSjHo+ntjRKaXgKgwEhW6Sd0QbGYA0vGL
         lOhjtEPRU1POUkFSzqot6E1yVdYp/o3e5Ma0MBsSrZKKb1AyzjZ4B/9Va+BMBvr97k5/
         CKwcxa3Nat2K2rowYKPfXsFKjTEUegzgSnyUucrOYVpsCg2BlDzk/1U/RukwjsWxmRrI
         tRs/TpwL5DxStxa4cqq/czHG+2f9tI3hm5joXxSORmNMrCnY+ovYuEDOi3EdwA/AAMkh
         AfC6pcLzzDzWKkKpMPa7V7eVrHsgXNwkjWk5th5ISgQ1k/nRpdiBuZG4PhoWBEpTAN1x
         E5rg==
X-Gm-Message-State: ACgBeo2+QFndS605G52MRfc5vkSV1Rjt8yRZnm5QOnGGspfzaBB5oVl3
        Ollyqg/3VSGu1NJbLoMRM9Uc5LHdVQ4Sn7CpbD/aagT04JHsDXPKM5SGEqsjBphG4VSWT9j7egY
        LUmRxxy25Yuz9PiCL
X-Received: by 2002:a05:6214:1a07:b0:474:6e80:e1e5 with SMTP id fh7-20020a0562141a0700b004746e80e1e5mr16175794qvb.41.1659975708180;
        Mon, 08 Aug 2022 09:21:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR41H7/KMP6Xrg1+Qu9F5FmU0wuX9R7Ho2OYrizYTxWmBseWvAaRaDU+zCJVlnCznfO7XvDdLA==
X-Received: by 2002:a05:6214:1a07:b0:474:6e80:e1e5 with SMTP id fh7-20020a0562141a0700b004746e80e1e5mr16175773qvb.41.1659975707871;
        Mon, 08 Aug 2022 09:21:47 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id bk14-20020a05620a1a0e00b006b967397192sm1079804qkb.69.2022.08.08.09.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 09:21:47 -0700 (PDT)
Date:   Mon, 8 Aug 2022 09:21:46 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>, Wen Jin <wen.jin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix kdump kernels boot failure with
 scalable mode
Message-ID: <20220808162146.jrykclf5ez4o7j2t@cantor>
References: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 11:46:12AM +0800, Lu Baolu wrote:
> The translation table copying code for kdump kernels is currently based
> on the extended root/context entry formats of ECS mode defined in older
> VT-d v2.5, and doesn't handle the scalable mode formats. This causes
> the kexec capture kernel boot failure with DMAR faults if the IOMMU was
> enabled in scalable mode by the previous kernel.
> 
> The ECS mode has already been deprecated by the VT-d spec since v3.0 and
> Intel IOMMU driver doesn't support this mode as there's no real hardware
> implementation. Hence this converts ECS checking in copying table code
> into scalable mode.
> 
> The existing copying code consumes a bit in the context entry as a mark
> of copied entry. This marker needs to work for the old format as well as
> for extended context entries. It's hard to find such a bit for both
> legacy and scalable mode context entries. This replaces it with a per-
> IOMMU bitmap.
> 
> Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
> Cc: stable@vger.kernel.org
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Wen Jin <wen.jin@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---

I did a quick test last night, and it was able to harvest the vmcore,
and boot back up. Before you mentioned part of the issue being that it
couldn't get to the PGTT field in the pasid table entry. Was that not
the case, or is it looking at the old kernel pasid dir entries and
table entries through the pasid dir pointer in the copied context
entry?

Regards,
Jerry

>  drivers/iommu/intel/iommu.h   | 17 ++++++--
>  drivers/iommu/intel/debugfs.c |  3 +-
>  drivers/iommu/intel/iommu.c   | 76 +++++++++--------------------------
>  3 files changed, 35 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index fae45bbb0c7f..e9b851c42575 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -197,7 +197,6 @@
>  #define ecap_dis(e)		(((e) >> 27) & 0x1)
>  #define ecap_nest(e)		(((e) >> 26) & 0x1)
>  #define ecap_mts(e)		(((e) >> 25) & 0x1)
> -#define ecap_ecs(e)		(((e) >> 24) & 0x1)
>  #define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
>  #define ecap_max_iotlb_offset(e) (ecap_iotlb_offset(e) + 16)
>  #define ecap_coherent(e)	((e) & 0x1)
> @@ -265,7 +264,6 @@
>  #define DMA_GSTS_CFIS (((u32)1) << 23)
>  
>  /* DMA_RTADDR_REG */
> -#define DMA_RTADDR_RTT (((u64)1) << 11)
>  #define DMA_RTADDR_SMT (((u64)1) << 10)
>  
>  /* CCMD_REG */
> @@ -579,6 +577,7 @@ struct intel_iommu {
>  
>  #ifdef CONFIG_INTEL_IOMMU
>  	unsigned long 	*domain_ids; /* bitmap of domains */
> +	unsigned long	*copied_tables; /* bitmap of copied tables */
>  	spinlock_t	lock; /* protect context, domain ids */
>  	struct root_entry *root_entry; /* virtual address */
>  
> @@ -701,6 +700,19 @@ static inline int nr_pte_to_next_page(struct dma_pte *pte)
>  		(struct dma_pte *)ALIGN((unsigned long)pte, VTD_PAGE_SIZE) - pte;
>  }
>  
> +static inline bool context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
> +{
> +	if (!iommu->copied_tables)
> +		return false;
> +
> +	return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
> +}
> +
> +static inline bool context_present(struct context_entry *context)
> +{
> +	return (context->lo & 1);
> +}
> +
>  extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
>  
>  extern int dmar_enable_qi(struct intel_iommu *iommu);
> @@ -784,7 +796,6 @@ static inline void intel_iommu_debugfs_init(void) {}
>  #endif /* CONFIG_INTEL_IOMMU_DEBUGFS */
>  
>  extern const struct attribute_group *intel_iommu_groups[];
> -bool context_present(struct context_entry *context);
>  struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
>  					 u8 devfn, int alloc);
>  
> diff --git a/drivers/iommu/intel/debugfs.c b/drivers/iommu/intel/debugfs.c
> index 1f925285104e..f4fd249daad9 100644
> --- a/drivers/iommu/intel/debugfs.c
> +++ b/drivers/iommu/intel/debugfs.c
> @@ -241,7 +241,8 @@ static void ctx_tbl_walk(struct seq_file *m, struct intel_iommu *iommu, u16 bus)
>  		if (!context)
>  			return;
>  
> -		if (!context_present(context))
> +		if (!context_present(context) ||
> +		    context_copied(iommu, bus, devfn))
>  			continue;
>  
>  		tbl_wlk.bus = bus;
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7cca030a508e..889ad2c9a7b9 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -163,38 +163,6 @@ static phys_addr_t root_entry_uctp(struct root_entry *re)
>  	return re->hi & VTD_PAGE_MASK;
>  }
>  
> -static inline void context_clear_pasid_enable(struct context_entry *context)
> -{
> -	context->lo &= ~(1ULL << 11);
> -}
> -
> -static inline bool context_pasid_enabled(struct context_entry *context)
> -{
> -	return !!(context->lo & (1ULL << 11));
> -}
> -
> -static inline void context_set_copied(struct context_entry *context)
> -{
> -	context->hi |= (1ull << 3);
> -}
> -
> -static inline bool context_copied(struct context_entry *context)
> -{
> -	return !!(context->hi & (1ULL << 3));
> -}
> -
> -static inline bool __context_present(struct context_entry *context)
> -{
> -	return (context->lo & 1);
> -}
> -
> -bool context_present(struct context_entry *context)
> -{
> -	return context_pasid_enabled(context) ?
> -	     __context_present(context) :
> -	     __context_present(context) && !context_copied(context);
> -}
> -
>  static inline void context_set_present(struct context_entry *context)
>  {
>  	context->lo |= 1;
> @@ -764,7 +732,8 @@ static int device_context_mapped(struct intel_iommu *iommu, u8 bus, u8 devfn)
>  	spin_lock(&iommu->lock);
>  	context = iommu_context_addr(iommu, bus, devfn, 0);
>  	if (context)
> -		ret = context_present(context);
> +		ret = context_present(context) &&
> +				!context_copied(iommu, bus, devfn);
>  	spin_unlock(&iommu->lock);
>  	return ret;
>  }
> @@ -1688,6 +1657,11 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
>  		iommu->domain_ids = NULL;
>  	}
>  
> +	if (iommu->copied_tables) {
> +		bitmap_free(iommu->copied_tables);
> +		iommu->copied_tables = NULL;
> +	}
> +
>  	/* free context mapping */
>  	free_context_table(iommu);
>  
> @@ -1913,7 +1887,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  		goto out_unlock;
>  
>  	ret = 0;
> -	if (context_present(context))
> +	if (context_present(context) && !context_copied(iommu, bus, devfn))
>  		goto out_unlock;
>  
>  	/*
> @@ -1925,7 +1899,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  	 * in-flight DMA will exist, and we don't need to worry anymore
>  	 * hereafter.
>  	 */
> -	if (context_copied(context)) {
> +	if (context_copied(iommu, bus, devfn)) {
>  		u16 did_old = context_domain_id(context);
>  
>  		if (did_old < cap_ndoms(iommu->cap)) {
> @@ -1936,6 +1910,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
>  			iommu->flush.flush_iotlb(iommu, did_old, 0, 0,
>  						 DMA_TLB_DSI_FLUSH);
>  		}
> +
> +		clear_bit(((long)bus << 8) | devfn, iommu->copied_tables);
>  	}
>  
>  	context_clear_entry(context);
> @@ -2684,32 +2660,14 @@ static int copy_context_table(struct intel_iommu *iommu,
>  		/* Now copy the context entry */
>  		memcpy(&ce, old_ce + idx, sizeof(ce));
>  
> -		if (!__context_present(&ce))
> +		if (!context_present(&ce))
>  			continue;
>  
>  		did = context_domain_id(&ce);
>  		if (did >= 0 && did < cap_ndoms(iommu->cap))
>  			set_bit(did, iommu->domain_ids);
>  
> -		/*
> -		 * We need a marker for copied context entries. This
> -		 * marker needs to work for the old format as well as
> -		 * for extended context entries.
> -		 *
> -		 * Bit 67 of the context entry is used. In the old
> -		 * format this bit is available to software, in the
> -		 * extended format it is the PGE bit, but PGE is ignored
> -		 * by HW if PASIDs are disabled (and thus still
> -		 * available).
> -		 *
> -		 * So disable PASIDs first and then mark the entry
> -		 * copied. This means that we don't copy PASID
> -		 * translations from the old kernel, but this is fine as
> -		 * faults there are not fatal.
> -		 */
> -		context_clear_pasid_enable(&ce);
> -		context_set_copied(&ce);
> -
> +		set_bit(((long)bus << 8) | devfn, iommu->copied_tables);
>  		new_ce[idx] = ce;
>  	}
>  
> @@ -2735,8 +2693,8 @@ static int copy_translation_tables(struct intel_iommu *iommu)
>  	bool new_ext, ext;
>  
>  	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
> -	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
> -	new_ext    = !!ecap_ecs(iommu->ecap);
> +	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
> +	new_ext    = !!ecap_smts(iommu->ecap);
>  
>  	/*
>  	 * The RTT bit can only be changed when translation is disabled,
> @@ -2747,6 +2705,10 @@ static int copy_translation_tables(struct intel_iommu *iommu)
>  	if (new_ext != ext)
>  		return -EINVAL;
>  
> +	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
> +	if (!iommu->copied_tables)
> +		return -ENOMEM;
> +
>  	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
>  	if (!old_rt_phys)
>  		return -EINVAL;
> -- 
> 2.25.1
> 

