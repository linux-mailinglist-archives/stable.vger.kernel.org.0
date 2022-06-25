Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A8B55A717
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 06:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiFYEup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 00:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiFYEuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 00:50:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AAE25C6B
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 21:50:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id r1so3706715plo.10
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 21:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=NJNMyoYfpsEtbCVIuK66uo7G6TFyUAwk6lOR65m9/u4=;
        b=iKj2Vzal9jz8thD3sNlQ6cTWg487KaSaNZAya8LyuHyoUoJWGNH1hNmRqQFBen4i9Y
         lfrQgMD7dY3iErDtUfDKrkUnyTW431VRsy7vRy0qva0OGUzZ5JnCv0/e4zZghTTdHq11
         rwqqkPapRKxdJuM1mqN16dHX2pvZlR2H+sBHKYjnCEemYv6aj8EgPOLFlLnqsOH48lXX
         aa4L9C06MlbMcARN7zcyc5EQm/1O6M0sgedhp/2QEZNewGv4k/apqXlLWcZ2WNzqw8O+
         tktqPLgzAKvZHnQ6TiOFuTEQL2Kvr+nua9JVSmkruDDBHW4Vg9/yplJFj2BfOTL8xmer
         Wanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=NJNMyoYfpsEtbCVIuK66uo7G6TFyUAwk6lOR65m9/u4=;
        b=V0h6xymTbyC2mjvoku5smOSTEKTSVKSc5TFID8/Y9DCM1eY3CJu7n2ziryHQMGcL0f
         BRe2KAb+8EQCLnQTtmShOmVGT2ZTWIZOaxlGKa5yBr2I8coKa/i79VDLTP9dNlb+iHcF
         QfM+l6duSCVBj81m4d9apSjPkVXmPQTafK69nK3x6dv0nsaZkdeQQowPfrUUPRaqbrKo
         we9GTCTCunokc5bnuqMOQeyHFfiEjogaNRb565JgWDKHdRKBFj1qJCn2ZVfqgwmkJaV7
         8vL4Gl/Ow9dH0k3U9mv7yA4t/sQQisNTakXe2Y0Ag5YJav4ksu+hEPldDDXC4VBNTgN9
         WNQA==
X-Gm-Message-State: AJIora9p4NzCGmKCx+JWeqg9Cf+dAV29GTYuI9HlSFMlMe+/EaLViFcF
        u3FFeauwQSmMZX5aAGVozRg9k5sGVv35gRj7KO9V0hI/VfbKxKPGVQu6So3Er957wG51AAY65tf
        jKh15r33sZQ==
X-Google-Smtp-Source: AGRyM1t3sEqK/nqtJrSPeTvM+Br8h8/e9SAKG+aNHPQZnj/3qrh7e6+j7oRMDB6RLGCVwS7vcE8zKA==
X-Received: by 2002:a17:90a:bc84:b0:1ec:81f4:f86f with SMTP id x4-20020a17090abc8400b001ec81f4f86fmr7949095pjr.29.1656132640383;
        Fri, 24 Jun 2022 21:50:40 -0700 (PDT)
Received: from C02GJ7QYMD6M.corp.robot.car (c-24-6-107-226.hsd1.ca.comcast.net. [24.6.107.226])
        by smtp.gmail.com with ESMTPSA id m6-20020a635806000000b0040c9213a414sm2519669pgb.46.2022.06.24.21.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 21:50:39 -0700 (PDT)
From:   Satish Nagireddy <satish.nagireddy@getcruise.com>
To:     satish.nagireddy1@gmail.com
Cc:     Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add new IOMMU development mailing list
Date:   Fri, 24 Jun 2022 21:50:24 -0700
Message-Id: <20220625045024.45186-1-satish.nagireddy@getcruise.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The IOMMU mailing list will move from lists.linux-foundation.org to
lists.linux.dev. The hard switch of the archive will happen on July
5th, but add the new list now already so that people start using the
list when sending patches. After July 5th the old list will disappear.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220624125139.412-1-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3cf9842d9233..36d1bc999815 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -427,6 +427,7 @@ ACPI VIOT DRIVER
 M:	Jean-Philippe Brucker <jean-philippe@linaro.org>
 L:	linux-acpi@vger.kernel.org
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/acpi/viot.c
 F:	include/linux/acpi_viot.h
@@ -960,6 +961,7 @@ AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 R:	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/amd/
@@ -5962,6 +5964,7 @@ M:	Christoph Hellwig <hch@lst.de>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 R:	Robin Murphy <robin.murphy@arm.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -5974,6 +5977,7 @@ F:	kernel/dma/
 DMA MAPPING BENCHMARK
 M:	Xiang Chen <chenxiang66@hisilicon.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 F:	kernel/dma/map_benchmark.c
 F:	tools/testing/selftests/dma/
 
@@ -7558,6 +7562,7 @@ F:	drivers/gpu/drm/exynos/exynos_dp*
 EXYNOS SYSMMU (IOMMU) driver
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/iommu/exynos-iommu.c
 
@@ -9977,6 +9982,7 @@ INTEL IOMMU (VT-d)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Lu Baolu <baolu.lu@linux.intel.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	drivers/iommu/intel/
@@ -10356,6 +10362,7 @@ IOMMU DRIVERS
 M:	Joerg Roedel <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 F:	Documentation/devicetree/bindings/iommu/
@@ -12504,6 +12511,7 @@ F:	drivers/i2c/busses/i2c-mt65xx.c
 MEDIATEK IOMMU DRIVER
 M:	Yong Wu <yong.wu@mediatek.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/iommu/mediatek*
@@ -16545,6 +16553,7 @@ F:	drivers/i2c/busses/i2c-qcom-cci.c
 QUALCOMM IOMMU
 M:	Rob Clark <robdclark@gmail.com>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -19170,6 +19179,7 @@ F:	arch/x86/boot/video*
 SWIOTLB SUBSYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
 T:	git git://git.infradead.org/users/hch/dma-mapping.git
@@ -21844,6 +21854,7 @@ M:	Juergen Gross <jgross@suse.com>
 M:	Stefano Stabellini <sstabellini@kernel.org>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	iommu@lists.linux-foundation.org
+L:	iommu@lists.linux.dev
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
-- 
2.32.1 (Apple Git-133)


-- 


*Confidentiality Note:* We care about protecting our proprietary 
information, confidential material, and trade secrets. This message may 
contain some or all of those things. Cruise will suffer material harm if 
anyone other than the intended recipient disseminates or takes any action 
based on this message. If you have received this message (including any 
attachments) in error, please delete it immediately and notify the sender 
promptly.
