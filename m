Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68B11C2B7
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 02:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLLBuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 20:50:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41786 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727544AbfLLBuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 20:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576115416;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=zOCpd5dg0eh5r36GlPBDFDvAydvpE/EG+PVXZHD/BXE=;
        b=WkUvs4Q8Z5uwHpH72zvl+7KL8jkNIb92R6SaiPRBBTuolA4/89+DFOmu1Xhtz8IcgzQxRq
        F2qfVpQJh/YzlGIV7OKy4UgK0YlauANVMvb+qMY3bxTJbNNw/EPGkq9N1/GrYw4cooj6l6
        6+crzHRYNbfhQAO/yKq6cGZ9B2fkUvw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-0b0h5Yo9PzapzYiaOduY7A-1; Wed, 11 Dec 2019 20:50:11 -0500
X-MC-Unique: 0b0h5Yo9PzapzYiaOduY7A-1
Received: by mail-qk1-f200.google.com with SMTP id x71so422343qka.11
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 17:50:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=zOCpd5dg0eh5r36GlPBDFDvAydvpE/EG+PVXZHD/BXE=;
        b=juT+KVYtD4jhNkokwNmzWWvHot+9HdZSUiryn1XMzrkNiNxFFOMWsQ4ghAmcgiWlcY
         t0FL2fL7UoUQzTR9g+tQidv32A4jdHzI2Udy0nj0Jsxmy3ycuQoSy/yM/u6n562WSr+x
         E8J+FXtNVOXOvSOm6K7vU9ou6/4spL+WlI6MtBfpikus1nvZOUqJhQ3vLl095/1E9TU7
         S6PL2nP2XgpFe+weT9+o0J8gONhAxXLTA9A4dQC5pNpxAi8+3aM5dIjJIPjbYhz15GRW
         hTjhGQG/g5SBGf3uDpQTC8I/psbFonK09U/Xe3O7Rb+gFLK6jFkhUlqIEl6I5OIghFbG
         UiIA==
X-Gm-Message-State: APjAAAXKl20IUKIuE5zXcgtqzHI75NmEesxUqS3H9CV+xYwIYNRYRtIp
        syf9CurXl1GXJxQFtbGCByUHNURkcz9gG3yGuqPYUiOzUx0w2BowTAxHAfa9gOgX+LMoqNVK90i
        mu6P953G8a56PZypf
X-Received: by 2002:a37:92c5:: with SMTP id u188mr5637351qkd.200.1576115411215;
        Wed, 11 Dec 2019 17:50:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfbRkU1ye8MmdMrabMR9H2moF0xl9FH3NmkfIwiVFtmXM1Vy3Vd2+hTWAPFImOsUzGrtoiAg==
X-Received: by 2002:a37:92c5:: with SMTP id u188mr5637331qkd.200.1576115410806;
        Wed, 11 Dec 2019 17:50:10 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id x16sm1263627qki.110.2019.12.11.17.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 17:50:09 -0800 (PST)
Date:   Wed, 11 Dec 2019 18:49:52 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
Message-ID: <20191212014952.vlrmxrk2cebwxjnp@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, ashok.raj@intel.com,
        jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191211014015.7898-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20191211014015.7898-1-baolu.lu@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed Dec 11 19, Lu Baolu wrote:
>If the default DMA domain of a group doesn't fit a device, it
>will still sit in the group but use a private identity domain.
>When map/unmap/iova_to_phys come through iommu API, the driver
>should still serve them, otherwise, other devices in the same
>group will be impacted. Since identity domain has been mapped
>with the whole available memory space and RMRRs, we don't need
>to worry about the impact on it.
>
>Link: https://www.spinics.net/lists/iommu/msg40416.html
>Cc: Jerry Snitselaar <jsnitsel@redhat.com>
>Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
>Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced with private")
>Cc: stable@vger.kernel.org # v5.3+
>Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

>---
> drivers/iommu/intel-iommu.c | 8 --------
> 1 file changed, 8 deletions(-)
>
>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>index 0c8d81f56a30..b73bebea9148 100644
>--- a/drivers/iommu/intel-iommu.c
>+++ b/drivers/iommu/intel-iommu.c
>@@ -5478,9 +5478,6 @@ static int intel_iommu_map(struct iommu_domain *domain,
> 	int prot = 0;
> 	int ret;
>
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return -EINVAL;
>-
> 	if (iommu_prot & IOMMU_READ)
> 		prot |= DMA_PTE_READ;
> 	if (iommu_prot & IOMMU_WRITE)
>@@ -5523,8 +5520,6 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
> 	/* Cope with horrid API which requires us to unmap more than the
> 	   size argument if it happens to be a large-page mapping. */
> 	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return 0;
>
> 	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
> 		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
>@@ -5556,9 +5551,6 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
> 	int level = 0;
> 	u64 phys = 0;
>
>-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
>-		return 0;
>-
> 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
> 	if (pte)
> 		phys = dma_pte_addr(pte);
>-- 
>2.17.1
>

