Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F15468FE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfFNU3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbfFNU3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:50 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956FA2186A;
        Fri, 14 Jun 2019 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544189;
        bh=U3zeBSCt9G7KJXaLq9RIRDojSQHdJQ+ZshQMHmPNDw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meVGBuZFP3VZkBHOoNPHK0AtZ6j2Hu6PUHoGdWC310Gj18cv+11pPtYbPFCetC/Es
         K2JmjlmLsBGwzJmf4CWibdFoIAkiic7CEFHutlA5c3pFg4xXnHgVfysbbeEFdSEYz3
         V/V9aXbxmfOje9s01mkNxDN5LuVj/wnT18LguM98=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Joao Pinto <jpinto@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 05/39] ARC: [plat-hsdk]: Add missing FIFO size entry in GMAC node
Date:   Fri, 14 Jun 2019 16:29:10 -0400
Message-Id: <20190614202946.27385-5-sashal@kernel.org>
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

[ Upstream commit 4c70850aeb2e40016722cd1abd43c679666d3ca0 ]

Add the binding for RX/TX fifo size of GMAC node.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Tested-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Acked-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index f67f614ccb0e..d131c54acd3e 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -184,6 +184,9 @@
 			mac-address = [00 00 00 00 00 00]; /* Filled in by U-Boot */
 			dma-coherent;
 
+			tx-fifo-depth = <4096>;
+			rx-fifo-depth = <4096>;
+
 			mdio {
 				#address-cells = <1>;
 				#size-cells = <0>;
-- 
2.20.1

