Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2F2D6051
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391224AbgLJOje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391218AbgLJOjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:18 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.9 57/75] iommu/amd: Set DTE[IntTabLen] to represent 512 IRTEs
Date:   Thu, 10 Dec 2020 15:27:22 +0100
Message-Id: <20201210142608.862804618@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 4165bf015ba9454f45beaad621d16c516d5c5afe upstream.

According to the AMD IOMMU spec, the commit 73db2fc595f3
("iommu/amd: Increase interrupt remapping table limit to 512 entries")
also requires the interrupt table length (IntTabLen) to be set to 9
(power of 2) in the device table mapping entry (DTE).

Fixes: 73db2fc595f3 ("iommu/amd: Increase interrupt remapping table limit to 512 entries")
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20201207091920.3052-1-suravee.suthikulpanit@amd.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd/amd_iommu_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -254,7 +254,7 @@
 #define DTE_IRQ_REMAP_INTCTL_MASK	(0x3ULL << 60)
 #define DTE_IRQ_TABLE_LEN_MASK	(0xfULL << 1)
 #define DTE_IRQ_REMAP_INTCTL    (2ULL << 60)
-#define DTE_IRQ_TABLE_LEN       (8ULL << 1)
+#define DTE_IRQ_TABLE_LEN       (9ULL << 1)
 #define DTE_IRQ_REMAP_ENABLE    1ULL
 
 #define PAGE_MODE_NONE    0x00


