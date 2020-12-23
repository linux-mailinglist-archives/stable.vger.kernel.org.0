Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4425E2E146E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgLWCj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgLWCXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531592312E;
        Wed, 23 Dec 2020 02:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690217;
        bh=9msMz2T3QO1daF+kVj3rs8g6GIza+thanEg9JmYpb8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5t2ELdDvYjK/K3Gm9XOdSGujXk6zZKK8BkL4HTBmQ/uMR3pbtkCA/JoFkUgwc5I9
         JguSD78M7dZhjPerzWtOpYelCWxB/U5EZFOrvxYsdA8SPtgJsVeJ3cGxyMaEs4cxzC
         wysiVyTOV6oKJmCRn7vH1G6Ut0oMJbeFgNHCly3hAXeRHfwdDJt8dBNjHOUslL0iQA
         2enzEZ+A77UVCgsY2Thl1m8smgR6kpQGxTlpJBPiZ7gvZTDIbdWx4tcC5TD5EKC3bZ
         nPCM63eIEpJeckrPimdKq19tfbeXeT+GeLwMvAykouudqkCzWCwCdoHtiXp7HkqwbM
         lcXDv6xaBpUCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 35/66] ARM: dts: hisilicon: fix errors detected by usb yaml
Date:   Tue, 22 Dec 2020 21:22:21 -0500
Message-Id: <20201223022253.2793452-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index 6c712a97e1fef..6bbe560742c6a 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -455,14 +455,14 @@ gmac1: ethernet@1841000 {
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

