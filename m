Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27CAFA082
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKMBuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfKMBuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA942245B;
        Wed, 13 Nov 2019 01:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609835;
        bh=k/E09qlg5WbWzD5y3S56CsH3IsM+FqSjlRE1M9ZNK4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRYuJJvR0+8DjPjLlllxnVw1LDwPkenMoI+R9JYkEENuzUC4gb0XogZ4bYlvSAM+1
         smqjw9hxoTkr/EiaHVJJLcbtiaiHtxaaaApy++fxGm5Y8nAo7V7ZFsRGFJCqX2D3k4
         KAZNWv9xZMdJfOjms2If/205s/NeoyaFld/OtvJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Rossak <embed3d@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 008/209] ARM: dts: sun8i: h3-h5: ir register size should be the whole memory block
Date:   Tue, 12 Nov 2019 20:47:04 -0500
Message-Id: <20191113015025.9685-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rossak <embed3d@gmail.com>

[ Upstream commit 6c700289a3e84d5d3f2a95cf27732a7f7fce105b ]

The size of the register should be the size of the whole memory block,
not just the registers, that are needed.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sunxi-h3-h5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index fc6131315c47f..4b1530ebe4272 100644
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -816,7 +816,7 @@
 			clock-names = "apb", "ir";
 			resets = <&r_ccu RST_APB0_IR>;
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0x01f02000 0x40>;
+			reg = <0x01f02000 0x400>;
 			status = "disabled";
 		};
 
-- 
2.20.1

