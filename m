Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC847B75D
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhLUB7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:59:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbhLUB7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:59:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DEEFB81100;
        Tue, 21 Dec 2021 01:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1343C36AE9;
        Tue, 21 Dec 2021 01:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051940;
        bh=0GufEJv9qksg2WH4eWqdNCSXMqqHuUecF60Y8d57qx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5G21W3yGYezWSdbctQpmog+mUisFiZ8Cce44LgCquCiEHzIF+iv5DPNAvBigdYwG
         2iywGOsjTaiTsFMAF353SuYWA3G2ZGj6O+JTvtehQrk8bl4Rinqv4HbVbhTjNFbsHp
         lPG2vSYTDrEMR7ByUjFHzWGiDqMGzHbT2/7otR/qijqSVayBdua99EBSWcg2y9YWYM
         txys2Kw8Zk1Go6wVBXCvHRF/VI+qBnhFJFTuw/e51CtArCYOO8DV1PW/LyitcMs/On
         19W61CraL2BPDnAAzClG6/pWh8/0y7kN28VUeSDEK+QIuhjsgrURriGVgbWCyM2PCv
         zsuyRTnpoLlpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Pelletier <plr.vincent@gmail.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, qiuwenbo@kylinos.com.cn,
        yash.shah@sifive.com, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 26/29] riscv: dts: sifive unmatched: Expose the PMIC sub-functions
Date:   Mon, 20 Dec 2021 20:57:47 -0500
Message-Id: <20211221015751.116328-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Pelletier <plr.vincent@gmail.com>

[ Upstream commit cd29cc8ad2540a4f9a0a3e174394d39e648ef941 ]

These sub-functions are available in the chip revision on this board, so
expose them.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
index 7ea1c8da5fb2e..dd110ba00e871 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -80,6 +80,18 @@ pmic@58 {
 		interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-controller;
 
+		onkey {
+			compatible = "dlg,da9063-onkey";
+		};
+
+		rtc {
+			compatible = "dlg,da9063-rtc";
+		};
+
+		wdt {
+			compatible = "dlg,da9063-watchdog";
+		};
+
 		regulators {
 			vdd_bcore1: bcore1 {
 				regulator-min-microvolt = <900000>;
-- 
2.34.1

