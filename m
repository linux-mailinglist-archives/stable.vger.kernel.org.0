Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3115200E16
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389395AbgFSPEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391191AbgFSPEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:04:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B24421841;
        Fri, 19 Jun 2020 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579087;
        bh=fFGf0BX5UV6jrwH74nzNaDfF4N/fsX/1nVfVZ3eUof4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8oJcHZgRa3XULr7m4BMsiPFADoXpgKUev3KlDMAqq/vBeplNYWxRlPQ5isYdOiXV
         ni18u0Eigf3hAXlzhdsjmaKJUuHCQMQCZ75coNjqT16cM9+ArdxaQXCNo84SjiQQrl
         PrrskZWw/xUUGyYS4tq5pkqbzmfk6JoZhD4AM2xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 254/267] ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries
Date:   Fri, 19 Jun 2020 16:33:59 +0200
Message-Id: <20200619141700.847335784@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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
@@ -374,6 +374,7 @@
 	pinctrl-names = "default";
 	cap-sd-highspeed;
 	cap-mmc-highspeed;
+	keep-power-in-suspend;
 
 	mmc-pwrseq = <&wifi_pwrseq>;
 	non-removable;


