Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A101380C26
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhENOqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 10:46:51 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:33180 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhENOqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 10:46:51 -0400
Received: from vokac-latitude.ysoft.local (unknown [10.0.28.99])
        by uho.ysoft.cz (Postfix) with ESMTP id BA8F8A2BEA;
        Fri, 14 May 2021 16:45:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1621003537;
        bh=PoSH2N3Ldv+ChzNMytR7iI7bQZ2FK3UT4uRQllupPAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/F8wUDUFoabtRaKyCwfxGFDK0mMwMJ/9zCIhLBj3oDhSyXSxIhOkT7dzvXHAsSOp
         Yeraxck8Xjn7a+wpxfLDsGYVLvWM48i4/QAw5Rv6NjX84Pvw1rttuw4IQbYu6ZAEj2
         B7+8+0zGk7seq7ZcXsakbllhvtLXe1L35DHezMH0=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        stable@vger.kernel.org
Subject: [RFC 1/2] dt-bindings: leds: Add color as a required property for lp55xx controller
Date:   Fri, 14 May 2021 16:44:36 +0200
Message-Id: <1621003477-11250-2-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
References: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since addition of the multicolor LED framework in commit 92a81562e695
("leds: lp55xx: Add multicolor framework support to lp55xx") the color
property becomes required even if the multicolor framework is not enabled
and used.

Fix the binding documentation to reflect the real state.

Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Cc: <stable@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: linux-leds@vger.kernel.org
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 Documentation/devicetree/bindings/leds/leds-lp55xx.yaml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
index f552cd143d5b..e6bdd1cb615a 100644
--- a/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml
@@ -101,6 +101,7 @@ patternProperties:
         description: name of channel
 
 required:
+  - color
   - compatible
   - reg
 
@@ -127,6 +128,7 @@ examples:
                chan-name = "d1";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_RED>;
            };
 
            led@1 {
@@ -134,6 +136,7 @@ examples:
                chan-name = "d2";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_BLUE>;
            };
 
            led@2 {
@@ -141,6 +144,7 @@ examples:
                chan-name = "d3";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_GREEN>;
            };
 
            led@3 {
@@ -148,6 +152,7 @@ examples:
                chan-name = "d4";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_RED>;
            };
 
            led@4 {
@@ -155,6 +160,7 @@ examples:
                chan-name = "d5";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_BLUE>;
            };
 
            led@5 {
@@ -162,6 +168,7 @@ examples:
                chan-name = "d6";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_GREEN>;
            };
 
            led@6 {
@@ -169,6 +176,7 @@ examples:
                chan-name = "d7";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_RED>;
            };
 
            led@7 {
@@ -176,6 +184,7 @@ examples:
                chan-name = "d8";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_BLUE>;
            };
 
            led@8 {
@@ -183,6 +192,7 @@ examples:
                chan-name = "d9";
                led-cur = /bits/ 8 <0x14>;
                max-cur = /bits/ 8 <0x20>;
+               color = <LED_COLOR_ID_GREEN>;
            };
         };
 
-- 
2.7.4

