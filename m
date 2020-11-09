Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8879E2ABD47
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbgKINor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgKIM6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:58:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A479D207BC;
        Mon,  9 Nov 2020 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926734;
        bh=3HCqwV0v5Z9fU/pJA5G5eNy4Y8/ioYdgYMEM3GG9b5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBXaLA8UyX4qYOfOC3No6D0O6JvN2TEg8r8JEji9mvMhhW1G3C4rPGqge0yzhIELY
         XZVIW16QRG6pYB0YnW2VApHylEKhaV9zI2MD3KvfJ79a/RSk6cFPP+lQdsJyxWfS7/
         6vTFpt4M13IyidDzNMYRecgeBVnH7a4Z6W2H8xok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 72/86] ARM: dts: sun4i-a10: fix cpu_alert temperature
Date:   Mon,  9 Nov 2020 13:55:19 +0100
Message-Id: <20201109125024.243967904@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit dea252fa41cd8ce332d148444e4799235a8a03ec ]

When running dtbs_check thermal_zone warn about the
temperature declared.

thermal-zones: cpu-thermal:trips:cpu-alert0:temperature:0:0: 850000 is greater than the maximum of 200000

It's indeed wrong the real value is 85°C and not 850°C.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201003100332.431178-1-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index aa90f319309ba..b8bbc8c187994 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -137,7 +137,7 @@
 			trips {
 				cpu_alert0: cpu_alert0 {
 					/* milliCelsius */
-					temperature = <850000>;
+					temperature = <85000>;
 					hysteresis = <2000>;
 					type = "passive";
 				};
-- 
2.27.0



