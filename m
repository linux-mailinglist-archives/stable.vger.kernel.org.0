Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA3B328EB4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbhCATfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241890AbhCAT3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F81A650AE;
        Mon,  1 Mar 2021 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620485;
        bh=bhdfHS0IHfkfSb4GNG/JLrlDz5NatEXgHt5X353Lgqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtnUfp42ML2mOZXz4oqiVZLCkxfCvFI55hXbe9btARaRsA4CNbBF9ny2nE584ACkS
         mC7TXJ2fludXKS9DR0W9W2hPzLeVqV8OPZgNXeWotHjCY2B4EuGXTVqpBGD6xm3AeF
         v1XHPUP5wPbQC9k+5SvhxyPXI7CTQs9RwOy9brPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 141/775] arm64: dts: broadcom: bcm4908: use proper NAND binding
Date:   Mon,  1 Mar 2021 17:05:09 +0100
Message-Id: <20210301161208.622439830@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 56098be85d19cd56b59d7b3854ea035cc8cb9e95 ]

BCM4908 has controller that needs different IRQ handling just like the
BCM63138. Describe it properly.

On Linux this change fixes:
brcmstb_nand ff801800.nand: timeout waiting for command 0x9
brcmstb_nand ff801800.nand: intfc status d0000000

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index f873dc44ce9ca..55d9b56ac749d 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -164,7 +164,7 @@
 		nand@1800 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "brcm,brcmnand-v7.1", "brcm,brcmnand";
+			compatible = "brcm,nand-bcm63138", "brcm,brcmnand-v7.1", "brcm,brcmnand";
 			reg = <0x1800 0x600>, <0x2000 0x10>;
 			reg-names = "nand", "nand-int-base";
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.27.0



