Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BEDB20F5
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390637AbfIMNag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388466AbfIMNQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:25 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD1E20CC7;
        Fri, 13 Sep 2019 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380584;
        bh=OIl8hDJHmPG/euD1Pv+vrHgA9uVk7K8XCYaL8CAUYHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJZiefrclkb63AV+R5ZxWHaMluiQEQtyhkd71m/96Q/+A/1oRnAhcr/pbXWEok2Xa
         NlAa+o24V+i+Ytt7asEw/VvXtrJenRj3o8k7m59wiO/5IOEqXNuKDaxzFeQO9MqVii
         d4kdjH70XUfF6gDVcDmNhKZYa1eWR/nj0eaTVbDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ley Foon Tan <ley.foon.tan@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/190] arm64: dts: stratix10: add the sysmgr-syscon property from the gmacs
Date:   Fri, 13 Sep 2019 14:06:06 +0100
Message-Id: <20190913130608.616982475@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



