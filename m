Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABAA200F12
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392328AbgFSPOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391938AbgFSPOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F1A20776;
        Fri, 19 Jun 2020 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579687;
        bh=F56PYJf7LzlvOVbm708My6zGxN14mmdq2iquiOLJAwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxtu8LP9/TrJvFYxtKqNjjBf47ncxj8rGvljZ33j+fxGcduwEytTRqklWdUoCzOQS
         CbsX1/0TAjDM3j8kt1iFct3qqVOoRA15y0NcS4iwNeS3PUOZje0ZzMxk6SLO+oEf3Q
         JHsQuipPSaEqD/sn+93QCrHMmSmgd66hwIYu04TQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.4 229/261] ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries
Date:   Fri, 19 Jun 2020 16:34:00 +0200
Message-Id: <20200619141700.851297729@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

commit 869d42e6eba821905e1a0950623aadafe1a6e6d3 upstream.

SDHCI1 is connected to a BCM4329 WiFi/BT chip which requires
power to be kept over suspend.  As the surrounding hardware supports
this, mark it as such.  This fixes WiFi after a suspend/resume cycle.

Fixes: 170642468a51 ("ARM: dts: s5pv210: Add initial DTS for Samsung Aries based phones")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/s5pv210-aries.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -454,6 +454,7 @@
 	pinctrl-names = "default";
 	cap-sd-highspeed;
 	cap-mmc-highspeed;
+	keep-power-in-suspend;
 
 	mmc-pwrseq = <&wifi_pwrseq>;
 	non-removable;


