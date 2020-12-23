Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8AA2E16A7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgLWDAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgLWCTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0953422525;
        Wed, 23 Dec 2020 02:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689974;
        bh=qvoYcKSyaLKUL5m9oGZjCbFeWuM93rPYC9neOlZ2uM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQduLDk9I/1kX8n2Wi2A8ga0wZ17hJuHmbEAzrJ9nt1j5RzqBr/Tmpn7Q3kHFoTRs
         IZtp362E0eTeGNPc+ZNEaV6A1FhrLhsYWGFbxyENaUxx/iYMxOQrfrj4CDZw7U1QDv
         oeQ4hdad0ZgxQRcABQ8aEbJdQU7RbbXVGLxs5dvy13NRMsFj37r0NuHZNxtllBCv/H
         etDCY1V7EZe3F/EU+PWf2NBxt01GU8QQ3pilq6iZrY8PhiYbOU0DyYcpjmhllFEdTj
         zjhmllfS0Qm5D46WFgL1C7vC6US3KVAiQ7a3Bm92dkhcAlWRO5nb/TV6BDwxPTpFvC
         p2QPyxpx5/mTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 063/130] ARM: dts: hisilicon: fix errors detected by usb yaml
Date:   Tue, 22 Dec 2020 21:17:06 -0500
Message-Id: <20201223021813.2791612-63-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 64f5b52554a1de47a53972a47b9b58d8d66ee5aa ]

1. Change node name to match '^usb(@.*)?'

These errors are detected by generic-ehci.yaml and generic-ohci.yaml.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/hisi-x5hd2.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index d8800992b4d0c..da42b9400759b 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -452,14 +452,14 @@ gmac1: ethernet@1841000 {
 			status = "disabled";
 		};
 
-		usb0: ehci@1890000 {
+		usb0: usb@1890000 {
 			compatible = "generic-ehci";
 			reg = <0x1890000 0x1000>;
 			interrupts = <0 66 4>;
 			clocks = <&clock HIX5HD2_USB_CLK>;
 		};
 
-		usb1: ohci@1880000 {
+		usb1: usb@1880000 {
 			compatible = "generic-ohci";
 			reg = <0x1880000 0x1000>;
 			interrupts = <0 67 4>;
-- 
2.27.0

