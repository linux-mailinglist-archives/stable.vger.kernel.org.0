Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9F466EFE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfGLMUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfGLMUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD181208E4;
        Fri, 12 Jul 2019 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934039;
        bh=KY1pTVSVOlB8zydh/WnqEu8LohWlLxvY35Ylhs8yDY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xuf6JsflccgjY9FeXizuWI4QZqJHpb4DFhe9KxUi2AQPlYQUgLo+JxAELHT/Xdupl
         0ZJtaAQaqtg2CIL6bohAZu7MTRim9tk/J+C5eY9PmB2js5RhvKON5G3nC6bqTMc/76
         p/0WVPBNFpQpchdWdlrlTZz+64/xqOcjKlXs6E5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Teresa Remmet <t.remmet@phytec.de>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/91] ARM: dts: am335x phytec boards: Fix cd-gpios active level
Date:   Fri, 12 Jul 2019 14:18:29 +0200
Message-Id: <20190712121622.803758252@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8a0098c05a272c9a68f6885e09755755b612459c ]

Active level of the mmc1 cd gpio needs to be low instead of high.
Fix PCM-953 and phyBOARD-WEGA.

Signed-off-by: Teresa Remmet <t.remmet@phytec.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am335x-pcm-953.dtsi | 2 +-
 arch/arm/boot/dts/am335x-wega.dtsi    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-pcm-953.dtsi b/arch/arm/boot/dts/am335x-pcm-953.dtsi
index 1ec8e0d80191..572fbd254690 100644
--- a/arch/arm/boot/dts/am335x-pcm-953.dtsi
+++ b/arch/arm/boot/dts/am335x-pcm-953.dtsi
@@ -197,7 +197,7 @@
 	bus-width = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
-	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/am335x-wega.dtsi b/arch/arm/boot/dts/am335x-wega.dtsi
index 8ce541739b24..83e4fe595e37 100644
--- a/arch/arm/boot/dts/am335x-wega.dtsi
+++ b/arch/arm/boot/dts/am335x-wega.dtsi
@@ -157,7 +157,7 @@
 	bus-width = <4>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
-	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
-- 
2.20.1



