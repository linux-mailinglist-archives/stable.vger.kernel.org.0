Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C48468FC
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfFNU3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfFNU3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:50 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 388A02184D;
        Fri, 14 Jun 2019 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544189;
        bh=g8sXfcSwx7ehG42UJHTMpklSEP166VCQ0PA4P0aCX1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTEjaAMKKugoXj85eW4/MWyzBvmS/hdJja39yBaXYUVQmsFPsvVQVdil8DfQS2FxN
         gcmr+eSpuLczlS97c907NmFg03sAfbWUiEVHZxZ65H7Y2gSN/zm41GIm4cwdBltnUZ
         9WiJgA93y2ko6WcHGV5AjobXt5om19kDxPX4M2zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Joao Pinto <jpinto@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/39] ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC node
Date:   Fri, 14 Jun 2019 16:29:09 -0400
Message-Id: <20190614202946.27385-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>

[ Upstream commit ecc906a11c2a0940e1a380debd8bd5bc09faf454 ]

GMAC controller on HSDK boards supports 256 Hash Table size so we need to
add the multicast filter bins property. This allows for the Hash filter
to work properly using stmmac driver.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Acked-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index ef149f59929a..f67f614ccb0e 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -175,6 +175,7 @@
 			interrupt-names = "macirq";
 			phy-mode = "rgmii";
 			snps,pbl = <32>;
+			snps,multicast-filter-bins = <256>;
 			clocks = <&gmacclk>;
 			clock-names = "stmmaceth";
 			phy-handle = <&phy0>;
-- 
2.20.1

