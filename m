Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532491AA23C
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370492AbgDOMwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897492AbgDOLmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C9020936;
        Wed, 15 Apr 2020 11:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950960;
        bh=HA/6hgyu6HpfGD6DRIjXKBLT95W1xF9Q0/ETbreVlm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdSkvFOhu2KKBkv0QjeDPCROZ10eBuKJFu/TruasHkrh5GT8CMdBWEYQHnczJpaHL
         bf48YdSII4sNeNNceVBZzGLoIHOnVPEgBG08wPJnnOTVKIVkLmzT5glb/Ngh8G00pP
         3vJ7BbILFTAVg55XIfXY+4J6oC0bvmwLz2EjSHBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Angus Ainslie (Purism)" <angus@akkea.ca>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 011/106] arm64: dts: librem5-devkit: add a vbus supply to usb0
Date:   Wed, 15 Apr 2020 07:40:51 -0400
Message-Id: <20200415114226.13103-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Angus Ainslie (Purism)" <angus@akkea.ca>

[ Upstream commit dde061b865598ad91f50140760e1d224e5045db9 ]

Without a VBUS supply the dwc3 driver won't go into otg mode.

Fixes: eb4ea0857c83 ("arm64: dts: fsl: librem5: Add a device tree for the Librem5 devkit")
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts b/arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts
index 596bc65f475c2..b2cf6f1925257 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dts
@@ -743,6 +743,7 @@
 };
 
 &usb3_phy0 {
+	vbus-supply = <&reg_5v_p>;
 	status = "okay";
 };
 
-- 
2.20.1

