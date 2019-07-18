Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5520E6C5C5
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391026AbfGRDJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390210AbfGRDJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:09:37 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8142173E;
        Thu, 18 Jul 2019 03:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419376;
        bh=KY1pTVSVOlB8zydh/WnqEu8LohWlLxvY35Ylhs8yDY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw36N548/BqRQ/psP2JKeYT4dGzNdre5UqRkCqnP0/pOv9YXNX+yt9TbA1nGOheag
         32g2SbwzXeistbMl0KgAhDGloFJhFVMWYrHudf2TcdEbTkJBUvFjsSelpxeAZX7DNA
         j72w0EPae7evjPmTTATBoQokX3LfCJ0f3ztd5g+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Teresa Remmet <t.remmet@phytec.de>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/80] ARM: dts: am335x phytec boards: Fix cd-gpios active level
Date:   Thu, 18 Jul 2019 12:01:13 +0900
Message-Id: <20190718030100.540918640@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
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



