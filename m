Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15694148996
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgAXOgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391505AbgAXOTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 392092087E;
        Fri, 24 Jan 2020 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875557;
        bh=A/OInvNUnYl3sVuGtrPH4+JUTp1LNDxhwo2rpTolErQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wlh2KL9MELg+xhQXq+MVKA7UjGoUkhuzsN7EmxbyKOFRKE0zQ5EmaYAFej4cvQ1EV
         9nb10uEUT9vhsjordZLylgp+Z22NZZomZB8uc66cSvMuJLuS6v/WHh/PFAHVUOq/7d
         iHBSg+6W+6CK5Ac453rkOJrVIITlOgAQC9miTbLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harry Pan <harry.pan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 052/107] platform/x86: intel_pmc_core: update Comet Lake platform driver
Date:   Fri, 24 Jan 2020 09:17:22 -0500
Message-Id: <20200124141817.28793-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Pan <harry.pan@intel.com>

[ Upstream commit 515ff674bb9bf06186052e352c4587dab8defaf0 ]

Adding new CML CPU model ID into platform driver support list.

Signed-off-by: Harry Pan <harry.pan@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core_pltdrv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel_pmc_core_pltdrv.c b/drivers/platform/x86/intel_pmc_core_pltdrv.c
index 6fe829f30997d..e1266f5c63593 100644
--- a/drivers/platform/x86/intel_pmc_core_pltdrv.c
+++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
@@ -44,6 +44,8 @@ static const struct x86_cpu_id intel_pmc_core_platform_ids[] = {
 	INTEL_CPU_FAM6(KABYLAKE, pmc_core_device),
 	INTEL_CPU_FAM6(CANNONLAKE_L, pmc_core_device),
 	INTEL_CPU_FAM6(ICELAKE_L, pmc_core_device),
+	INTEL_CPU_FAM6(COMETLAKE, pmc_core_device),
+	INTEL_CPU_FAM6(COMETLAKE_L, pmc_core_device),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pmc_core_platform_ids);
-- 
2.20.1

