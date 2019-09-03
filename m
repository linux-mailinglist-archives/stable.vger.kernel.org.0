Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE6A6FC1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfICQeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730992AbfICQ16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B61772343A;
        Tue,  3 Sep 2019 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528077;
        bh=K2RqtYrOLPP/Zg4JwaI2CmIg9crPsLHGGZw/haRB/T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0REfY1DAK+mTQ0PjHwC6pfwBFflZCWUnQqlTFIDeZIfSj7ikWGDY6p8sK0to6UT2S
         mjh6RCJE7sTi6CqJmHMM6FDXACxxgj/gKRVF9nAYoE0o+TW+pe++OSpHjMmjqxtQVJ
         M9I5hoVbZd1Pa7KLzrYKocrb6Jdjjmcb74o0ZCNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <ley.foon.tan@intel.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 090/167] arm64: dts: stratix10: add the sysmgr-syscon property from the gmac's
Date:   Tue,  3 Sep 2019 12:24:02 -0400
Message-Id: <20190903162519.7136-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 8efd6365417a044db03009724ecc1a9521524913 ]

The gmac ethernet driver uses the "altr,sysmgr-syscon" property to
configure phy settings for the gmac controller.

Add the "altr,sysmgr-syscon" property to all gmac nodes.

This patch fixes:

[    0.917530] socfpga-dwmac ff800000.ethernet: No sysmgr-syscon node found
[    0.924209] socfpga-dwmac ff800000.ethernet: Unable to parse OF data

Cc: stable@vger.kernel.org
Reported-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
index 5089aa64088fc..9a1ea8a464057 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
@@ -140,6 +140,7 @@
 			tx-fifo-depth = <16384>;
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
+			altr,sysmgr-syscon = <&sysmgr 0x44 0>;
 			status = "disabled";
 		};
 
@@ -156,6 +157,7 @@
 			tx-fifo-depth = <16384>;
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
+			altr,sysmgr-syscon = <&sysmgr 0x48 0>;
 			status = "disabled";
 		};
 
@@ -172,6 +174,7 @@
 			tx-fifo-depth = <16384>;
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
+			altr,sysmgr-syscon = <&sysmgr 0x4c 0>;
 			status = "disabled";
 		};
 
-- 
2.20.1

