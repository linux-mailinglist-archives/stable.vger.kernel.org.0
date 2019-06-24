Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658125082C
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfFXKDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbfFXKDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:03:52 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D847C208E4;
        Mon, 24 Jun 2019 10:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370631;
        bh=YRlpx/QN9AvG+vGwEI7FnNCcZuH5b1fOwowrRhX8TQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeOiOrv07FB6Wllr1C3qydjItsE7PksYuJllLEeFz2GP9WlhGxqb/q6CiUSY/czv7
         hRD/8c6GN8pUvbV9ndcdNlf/Myo5hR/TTLb1VGrmem2u4xxDZRxUXvw6ov3Ifod/S7
         Qix8kM2kS1M0NXctLsbryfGBJbzoF2IFpEluLTHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joao Pinto <jpinto@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/90] ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC node
Date:   Mon, 24 Jun 2019 17:56:23 +0800
Message-Id: <20190624092316.489746293@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



