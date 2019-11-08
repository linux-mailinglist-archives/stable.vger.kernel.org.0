Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331F4F552A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389874AbfKHTAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389859AbfKHTAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229212087E;
        Fri,  8 Nov 2019 19:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239641;
        bh=jIjy0pB0p7Mv25iAq0q5YJ2x7nS1PNOfOREH0GhCQdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4vnWZiy4l6QWVkw9m2bxqeFIQPQwBAHWzRrjCH5ye1/K7zpjJmrTML8Cv0yp3s/8
         W2Xmvwg73QeW1Fky7nQU0CGRMvFxHyXbo5voCUTMkDfwVYMn7oEmtm60Q8k3lafqgB
         cZPm1xnJVNSlvUnOSQIuQGMTCPuPSedwE1Vv4VjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/79] ARM: dts: logicpd-torpedo-som: Remove twl_keypad
Date:   Fri,  8 Nov 2019 19:49:52 +0100
Message-Id: <20191108174751.326199478@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 6b512b0ee091edcb8e46218894e4c917d919d3dc ]

The TWL4030 used on the Logit PD Torpedo SOM does not have the
keypad pins routed.  This patch disables the twl_keypad driver
to remove some splat during boot:

twl4030_keypad 48070000.i2c:twl@48:keypad: missing or malformed property linux,keymap: -22
twl4030_keypad 48070000.i2c:twl@48:keypad: Failed to build keymap
twl4030_keypad: probe of 48070000.i2c:twl@48:keypad failed with error -22

Signed-off-by: Adam Ford <aford173@gmail.com>
[tony@atomide.com: removed error time stamps]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/logicpd-torpedo-som.dtsi b/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
index 7d2302e8706c9..9354da4efe093 100644
--- a/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
+++ b/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
@@ -196,3 +196,7 @@
 &twl_gpio {
 	ti,use-leds;
 };
+
+&twl_keypad {
+	status = "disabled";
+};
-- 
2.20.1



