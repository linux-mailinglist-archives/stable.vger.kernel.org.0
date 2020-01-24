Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01382148A12
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbgAXOiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgAXOSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20BBB2077C;
        Fri, 24 Jan 2020 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875514;
        bh=rFxetqqAGgGIApkXEQ4TCZBigV4FicIGqLM3MuDnDD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cui+bZaybZZ/vVA6Zh+rG1xTrH4n5B2E819CVv3nhtga/WN7MeUzMMl76iXo7IHBX
         tmjDQDVuYH2xkb+bquIhD5x057OmsktmK9m3Ib8yuMavvjFYuQXSUwIBvjs0qyCNfd
         gCPYWAlZ/vyo0RKT6P2lip1/xS9inK+aDsecaung=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yinbo Zhu <yinbo.zhu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 014/107] arm64: dts: ls1028a: fix endian setting for dcfg
Date:   Fri, 24 Jan 2020 09:16:44 -0500
Message-Id: <20200124141817.28793-14-sashal@kernel.org>
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

From: Yinbo Zhu <yinbo.zhu@nxp.com>

[ Upstream commit 33eae7fb2e593fdbaac15d843e2558379c6d1149 ]

DCFG block uses little endian.  Fix it so that register access becomes
correct.

Signed-off-by: Yinbo Zhu <yinbo.zhu@nxp.com>
Acked-by: Yangbo Lu <yangbo.lu@nxp.com>
Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index bb960fe2bb64c..9589b15693d6e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -158,7 +158,7 @@
 		dcfg: syscon@1e00000 {
 			compatible = "fsl,ls1028a-dcfg", "syscon";
 			reg = <0x0 0x1e00000 0x0 0x10000>;
-			big-endian;
+			little-endian;
 		};
 
 		rst: syscon@1e60000 {
-- 
2.20.1

