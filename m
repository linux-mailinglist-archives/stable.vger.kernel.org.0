Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2319B44B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgDAQWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733043AbgDAQWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:22:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6757E20658;
        Wed,  1 Apr 2020 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758133;
        bh=2m4phitjhFbrsAJcF3uiJiiQDobncxewRiAT1Y8YfC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcutdLpxv+kIJcaJEpnhfUrJceuSobl4nNV9tzxFe/TgOPMMnNr8aP7wxHYdPLE0j
         m+pXtmqm3NyJ58MhE7AROjPwtTtE2BvGNNfNlYujk3lQmuzoG0Tubz4rss4c9zPgyb
         k7i4RGixgcQrUAey/OLHjUHMozvzLKSsXPydX7H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Hudson <skrll@netbsd.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 22/27] ARM: bcm2835-rpi-zero-w: Add missing pinctrl name
Date:   Wed,  1 Apr 2020 18:17:50 +0200
Message-Id: <20200401161432.262458405@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Hudson <skrll@netbsd.org>

commit 6687c201fdc3139315c2ea7ef96c157672805cdc upstream.

Define the sdhci pinctrl state as "default" so it gets applied
correctly and to match all other RPis.

Fixes: 2c7c040c73e9 ("ARM: dts: bcm2835: Add Raspberry Pi Zero W")
Signed-off-by: Nick Hudson <skrll@netbsd.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
@@ -112,6 +112,7 @@
 &sdhci {
 	#address-cells = <1>;
 	#size-cells = <0>;
+	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_gpio34 &gpclk2_gpio43>;
 	bus-width = <4>;
 	mmc-pwrseq = <&wifi_pwrseq>;


