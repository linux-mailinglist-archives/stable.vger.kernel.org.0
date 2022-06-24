Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00C55599E3
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 14:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiFXMvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 08:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiFXMvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 08:51:46 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2014ECE4;
        Fri, 24 Jun 2022 05:51:45 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006cf2.dip0.t-ipconnect.de [91.0.108.242])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id D6869450;
        Fri, 24 Jun 2022 14:51:42 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     linux-kernel@vger.kernel.org
Cc:     iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>,
        Christoph Hellwig <hch@infradead.org>, joro@8bytes.org,
        stable@vger.kernel.org
Subject: [PATCH v2] MAINTAINERS: Add new IOMMU development mailing list
Date:   Fri, 24 Jun 2022 14:51:39 +0200
Message-Id: <20220624125139.412-1-joro@8bytes.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
2.36.1

