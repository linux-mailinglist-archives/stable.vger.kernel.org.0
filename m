Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FCCEA10B
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfJ3P5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbfJ3P5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:57:14 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F8721882;
        Wed, 30 Oct 2019 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451033;
        bh=eh+r0jQVLaPFfkmVGlO/vREfE61KcjAS/0XfFkgqjE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOxzAMAEVROia8DrxO91W2/TSr0VXhy+RzWyQDlDIxaHUWrJu+lXEhsPOhMgIRm3p
         vxsIHfi0H7dEadnjRSpcR+BXlZLU0IeyyiIet0uXKWDL7SNzHbZ8uDsR+Z5c+aF/U8
         XyrHE0dFBZx8yVSJt4pU5cBE2xOv+k45wDt3Sta0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/18] ARM: dts: logicpd-torpedo-som: Remove twl_keypad
Date:   Wed, 30 Oct 2019 11:56:47 -0400
Message-Id: <20191030155700.10748-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155700.10748-1-sashal@kernel.org>
References: <20191030155700.10748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ceb49d15d243c..20ee7ca8c6534 100644
--- a/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
+++ b/arch/arm/boot/dts/logicpd-torpedo-som.dtsi
@@ -266,3 +266,7 @@
 &twl_gpio {
 	ti,use-leds;
 };
+
+&twl_keypad {
+	status = "disabled";
+};
-- 
2.20.1

