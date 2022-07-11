Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A9D56FB26
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiGKJ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiGKJYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507153336F;
        Mon, 11 Jul 2022 02:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F58DB80833;
        Mon, 11 Jul 2022 09:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DE8C34115;
        Mon, 11 Jul 2022 09:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530911;
        bh=Y2vZqC06i8AzUbZvUFSXTCsRIMDbkbovhT/11q7TMbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJlyVSlsBAveI+tePYbG46gPTcN9/TFGz+Gfe0QukvX0Uu6XSARPZuNFMwGdPbM3Q
         NKyei7gE9uQKXdVx4Bye4DQv7M5TBUYtLBFE8sjyIlhnasA1y0edOwaHrZgJUj7Pgb
         nXT3tE1cNVyqaQSHjdRyJ6VZuxKbz3LW1F9Xpcvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.18 028/112] MAINTAINERS: Remove iommu@lists.linux-foundation.org
Date:   Mon, 11 Jul 2022 11:06:28 +0200
Message-Id: <20220711090550.365306950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit c51b8f85c4157eb91c2f4ab34b0c52fea642e77c upstream.

The IOMMU mailing list has moved to iommu@lists.linux.dev
and the old list should bounce by now. Remove it from the
MAINTAINERS file.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20220706103331.10215-1-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |   11 -----------
 1 file changed, 11 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -426,7 +426,6 @@ F:	drivers/acpi/*thermal*
 ACPI VIOT DRIVER
 M:	Jean-Philippe Brucker <jean-philippe@linaro.org>
 L:	linux-acpi@vger.kernel.org
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/acpi/viot.c
@@ -960,7 +959,6 @@ F:	drivers/video/fbdev/geode/
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 R:	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
@@ -5899,7 +5897,6 @@ DMA MAPPING HELPERS
 M:	Christoph Hellwig <hch@lst.de>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 R:	Robin Murphy <robin.murphy@arm.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
@@ -5912,7 +5909,6 @@ F:	kernel/dma/
 
 DMA MAPPING BENCHMARK
 M:	Xiang Chen <chenxiang66@hisilicon.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 F:	kernel/dma/map_benchmark.c
 F:	tools/testing/selftests/dma/
@@ -7479,7 +7475,6 @@ F:	drivers/gpu/drm/exynos/exynos_dp*
 
 EXYNOS SYSMMU (IOMMU) driver
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Maintained
 F:	drivers/iommu/exynos-iommu.c
@@ -9879,7 +9874,6 @@ F:	drivers/hid/intel-ish-hid/
 INTEL IOMMU (VT-d)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Lu Baolu <baolu.lu@linux.intel.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
@@ -10258,7 +10252,6 @@ F:	include/linux/iomap.h
 IOMMU DRIVERS
 M:	Joerg Roedel <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
@@ -12375,7 +12368,6 @@ F:	drivers/i2c/busses/i2c-mt65xx.c
 
 MEDIATEK IOMMU DRIVER
 M:	Yong Wu <yong.wu@mediatek.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
@@ -16361,7 +16353,6 @@ F:	drivers/i2c/busses/i2c-qcom-cci.c
 
 QUALCOMM IOMMU
 M:	Rob Clark <robdclark@gmail.com>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
@@ -18947,7 +18938,6 @@ F:	arch/x86/boot/video*
 
 SWIOTLB SUBSYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Supported
 W:	http://git.infradead.org/users/hch/dma-mapping.git
@@ -21618,7 +21608,6 @@ XEN SWIOTLB SUBSYSTEM
 M:	Juergen Gross <jgross@suse.com>
 M:	Stefano Stabellini <sstabellini@kernel.org>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
-L:	iommu@lists.linux-foundation.org
 L:	iommu@lists.linux.dev
 S:	Supported
 F:	arch/x86/xen/*swiotlb*


