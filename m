Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A903D296F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhGVQED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233528AbhGVQDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC00D6144E;
        Thu, 22 Jul 2021 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972221;
        bh=rXSYCHIc/ZsAXNRb5GQvy+D9s0LkTQHh9b89LwGNBco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcVECerOzM/IXd8fKLzc8BHh0N4njP8GsT9LNiA9P/TBf3M+JO+aF/ancq0k6vOdl
         srMIETHu2zivsA6tiModvGDKOMHFyHZD8rY3XubKVvCd8PKFTflyme9feTSGXkHDXq
         huR8G9vF1KOLibe7VZbR7t+sZewzi+xAckaKz20w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 030/156] ARM: dts: ux500: Fix orientation of accelerometer
Date:   Thu, 22 Jul 2021 18:30:05 +0200
Message-Id: <20210722155629.386413742@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4beba4011995a2c44ee27e1d358dc32e6b9211b3 ]

This adds a mounting matrix to the accelerometer
on the TVK1281618 R3.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index 70f058352efc..511e097cc33e 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -89,6 +89,9 @@
 					     <19 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&accel_tvk_mode>;
+				mount-matrix = "0", "-1", "0",
+					       "-1", "0", "0",
+					       "0", "0", "-1";
 			};
 			magnetometer@1e {
 				compatible = "st,lsm303dlm-magn";
-- 
2.30.2



