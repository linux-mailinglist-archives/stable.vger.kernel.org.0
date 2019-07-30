Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F57B43C
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 22:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfG3USi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 16:18:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40479 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfG3USi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 16:18:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so30637438pgj.7
        for <stable@vger.kernel.org>; Tue, 30 Jul 2019 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/+5B+ELOYytBEM9Ys8TxNC2Z+KZj299Wj628j1kQ+9E=;
        b=Z6ajn8Eq54FskwayR1CFlUeCZ+zyox1QAnvnvKbBtW+7XQZMl+Ej/0s2fk4zZ/3clB
         cBZHL36ZpxqH27f05GLaEmfZajFBhlh9MWAX/libJBV3juUFnYJ2MHOURsh0srkqzfRz
         TEeTtrS0gxiRMMrq5W7cszSpNymxUi/Qda1u4Gc51TQSHfm9mErsDhdSFQXvsLX7K7dh
         eE5Uv1wOnccqUnSYhHL7MzR8WrwKVl71KoMRvJxkSOR3ZYeVAs8uroWQIFTkSgLH8XxA
         oQiL3tIOzwR4WrI864uukImXQQz8xquNLoMDZ5Xah2p1BO6+Nnbcw9dQQYjI0sJJ8rsL
         TO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/+5B+ELOYytBEM9Ys8TxNC2Z+KZj299Wj628j1kQ+9E=;
        b=W7B4NTvDpDPC+Wks00vmmQABOCopvOxEcRnfjgYJADHy/Vp6e7SD3F2ty3ux8MbxGP
         CCFC2T7iLUImBunFcFv928GEPFOg3ItvVZkEV8KWj3LYGOCdeXMbM5z9ZCSzaPssdpjY
         yQe8vZNiJrNL0VWKCZtiGFI0Ezp7dg2F1iNNOQde1w/D5b874Iq9uA9ssUjS2ZOx6fML
         rwDv4lph9OrKxsNjtCi03iyEMpFt1la6q9PRAeiLgsBjEWV7+BG+tNrGBEC9OC0gp1r4
         qlp9oTtqCOd4qK3fsiVZazErZ9ZHUG98U3mQqaVZiKAqmuN5ZTFcLLcTns/MHeYr3Z1p
         bmBg==
X-Gm-Message-State: APjAAAXQk1S1Vsi/UCa+V4/nQkIcfu/LCESXc0t2IQ3eaGs7YKHVAoNc
        OpYgxKdGo+3FWySVVwI5TuxvGQ==
X-Google-Smtp-Source: APXvYqzLjLuVsAGZMIH6uqtGGexIE6ehSlxILndv8z1qJ1HoF3uipn6KpcqC6f8s2AIMTfCvkSaU5A==
X-Received: by 2002:a17:90a:cb18:: with SMTP id z24mr66567528pjt.108.1564517917670;
        Tue, 30 Jul 2019 13:18:37 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id r75sm88113177pfc.18.2019.07.30.13.18.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:18:36 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>, allen yan <yanwei@marvell.com>,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH for-4.14.y 1/3] arm64: dts: marvell: Fix A37xx UART0 register size
Date:   Wed, 31 Jul 2019 01:48:31 +0530
Message-Id: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: allen yan <yanwei@marvell.com>

commit c737abc193d16e62e23e2fb585b8b7398ab380d8 upstream.

Armada-37xx UART0 registers are 0x200 bytes wide. Right next to them are
the UART1 registers that should not be declared in this node.

Update the example in DT bindings document accordingly.

Signed-off-by: allen yan <yanwei@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@free-electrons.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cherry-picked from lede/openwrt tree
https://git.lede-project.org/?p=source.git.
Build tested for ARCH=arm64 + defconfig

Cleanly apply on 4.9.y as well but since
lede stopped supporting v4.9.y, I'm not
sure if this patch is tested on v4.9.y at all.

 Documentation/devicetree/bindings/serial/mvebu-uart.txt | 2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/mvebu-uart.txt b/Documentation/devicetree/bindings/serial/mvebu-uart.txt
index 6087defd9f93..d37fabe17bd1 100644
--- a/Documentation/devicetree/bindings/serial/mvebu-uart.txt
+++ b/Documentation/devicetree/bindings/serial/mvebu-uart.txt
@@ -8,6 +8,6 @@ Required properties:
 Example:
 	serial@12000 {
 		compatible = "marvell,armada-3700-uart";
-		reg = <0x12000 0x400>;
+		reg = <0x12000 0x200>;
 		interrupts = <43>;
 	};
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 8c0cf7efac65..b554cdaf5e53 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -134,7 +134,7 @@
 
 			uart0: serial@12000 {
 				compatible = "marvell,armada-3700-uart";
-				reg = <0x12000 0x400>;
+				reg = <0x12000 0x200>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
-- 
2.7.4

