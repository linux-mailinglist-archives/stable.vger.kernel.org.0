Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86D211DDE4
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 06:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfLMFmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 00:42:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725799AbfLMFmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 00:42:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576215761;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwi+j/3c3L6Rt5/e01jNkvMX57Zg4McK7tkL0V4Tb6w=;
        b=iJsvJabZs6HiKGTxiV2nEv3vOsz6tyJLi5zWJExbkSrVU8vh2Cc5maZN/JcOeZ7Pvmvzfj
        qgFAEfjTakW6WDtjgbdy1OkIeDmGGLiOw2UU50WU0q+sbDOpjKKRtxyNB/4bc3g5yHWASz
        aegzLnSV3BdCLIHrOKFIclQ9r6pseJo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-kUGaVbTPMjeulOiDePkDtQ-1; Fri, 13 Dec 2019 00:42:39 -0500
X-MC-Unique: kUGaVbTPMjeulOiDePkDtQ-1
Received: by mail-pf1-f198.google.com with SMTP id c72so843975pfc.0
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 21:42:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=cwi+j/3c3L6Rt5/e01jNkvMX57Zg4McK7tkL0V4Tb6w=;
        b=WnkHew6pcNphDYvBrhSvTsmatMHgUbhEnHxoBDWRmc6v7NZJFCVI+QcPiGQ4w7vmSH
         Cpe99m2jSxdE9+d8YzNa4Qe1HTUnZN16IF8byKFuZXfiPNBwnqw+WoAFhVcxCQyb2QfY
         kpNOKpMTRGR8H2IKiJLAlg7dxZurKg+AEDOOlmb1V4TE7jsJr9qI30EJoXg1NRAYWn1v
         qWOBv4LCkA88j0PJfsV9BFRMxGtinb0iAxHBNztNWD6wHrCPJ9t2/hByvNYA0IyibeIG
         53uBLEqkrQYi6deVfobsOteWfnRh63OK1SLhD4SCti3+oQHlMeHxeaiEwJz1JntFwIK2
         IILQ==
X-Gm-Message-State: APjAAAUaH0QZ1Mm0xSyno1FXWvZPOF0C30ca/aLMab3rUlCzyLKiTK9o
        ZpmNvYksDueXtORuen9NLhHZQKQnhqb8GFCAG/ffEC9hKMDg6r6QRPrrpjN7QDlyB5x35H8o/GU
        tP5MAgGwH/u2zZIhT
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr13902164plo.291.1576215758093;
        Thu, 12 Dec 2019 21:42:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwaZWfRZsAfWxIXK1Nhr+ThnebZtUh2mZS1cGIcgrxlVtTubvH0gXKnXGkrHtK9Ar79iHIXJA==
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr13902137plo.291.1576215757695;
        Thu, 12 Dec 2019 21:42:37 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id t5sm7910818pje.6.2019.12.12.21.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 21:42:36 -0800 (PST)
Date:   Thu, 12 Dec 2019 22:42:17 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
Message-ID: <20191213054217.sykaftujydkaa4r2@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
 <20191212014952.vlrmxrk2cebwxjnp@cantor>
 <6f3bcad9-b9b3-b349-fdad-ce53a79a665b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f3bcad9-b9b3-b349-fdad-ce53a79a665b@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu Dec 12 19, Lu Baolu wrote:
>Hi,
>
>On 12/12/19 9:49 AM, Jerry Snitselaar wrote:
>>On Wed Dec 11 19, Lu Baolu wrote:
>>>If the default DMA domain of a group doesn't fit a device, it
>>>will still sit in the group but use a private identity domain.
>>>When map/unmap/iova_to_phys come through iommu API, the driver
>>>should still serve them, otherwise, other devices in the same
>>>group will be impacted. Since identity domain has been mapped
>>>with the whole available memory space and RMRRs, we don't need
>>>to worry about the impact on it.
>>>
>>>Link: https://www.spinics.net/lists/iommu/msg40416.html
>>>Cc: Jerry Snitselaar <jsnitsel@redhat.com>
>>>Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>>>Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains 
>>>replaced with private")
>>>Cc: stable@vger.kernel.org # v5.3+
>>>Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>>
>>Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
>
>Can you please try this fix and check whether it can fix your problem?
>If it helps, do you mind adding a Tested-by?
>
>Best regards,
>baolu
>

Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>

>>
>>>---
>>>drivers/iommu/intel-iommu.c | 8 --------
>>>1 file changed, 8 deletions(-)
>>>
>>>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>>>index 0c8d81f56a30..b73bebea9148 100644
>>>--- a/drivers/iommu/intel-iommu.c
>>>+++ b/drivers/iommu/intel-iommu.c
>>>@@ -5478,9 +5478,6 @@ static int intel_iommu_map(struct 
>>>iommu_domain *domain,
>>>    int prot = 0;
>>>    int ret;
>>>
>>>-    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>>>-        return -EINVAL;
>>>-
>>>    if (iommu_prot & IOMMU_READ)
>>>        prot |= DMA_PTE_READ;
>>>    if (iommu_prot & IOMMU_WRITE)
>>>@@ -5523,8 +5520,6 @@ static size_t intel_iommu_unmap(struct 
>>>iommu_domain *domain,
>>>    /* Cope with horrid API which requires us to unmap more than the
>>>       size argument if it happens to be a large-page mapping. */
>>>    BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
>>>-    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>>>-        return 0;
>>>
>>>    if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
>>>        size = VTD_PAGE_SIZE << level_to_offset_bits(level);
>>>@@ -5556,9 +5551,6 @@ static phys_addr_t 
>>>intel_iommu_iova_to_phys(struct iommu_domain *domain,
>>>    int level = 0;
>>>    u64 phys = 0;
>>>
>>>-    if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>>>-        return 0;
>>>-
>>>    pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
>>>    if (pte)
>>>        phys = dma_pte_addr(pte);
>>>-- 
>>>2.17.1
>>>
>>
>_______________________________________________
>iommu mailing list
>iommu@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/iommu

