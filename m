Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3785328A5B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhCASQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239373AbhCASIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D3E65142;
        Mon,  1 Mar 2021 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618271;
        bh=SnKcVzzMUHdwdtBhJqXtjLX3ha0ncU+pMmZzlXBggoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyHH4oWQRsVMMpZO2YJgEXdsl+XBsgADPSYjeRvp9qW6LpQcmP4nesVMH0V6SLyqb
         pu4hcRYaP0sgHqRbYnDfxAZhf2C4g008so2l4buf32/qYla4NYcPExENi+lHDW/NgB
         l/u5iRNXPmz8PyhGXYSKcSMComHOhvtW+5e8R5y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/663] arm64: dts: renesas: beacon: Fix audio-1.8V pin enable
Date:   Mon,  1 Mar 2021 17:04:34 +0100
Message-Id: <20210301161143.086341099@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 5a5da0b758b327b727c5392d7f11e046e113a195 ]

The fact the audio worked at all was a coincidence because the wrong
gpio enable was used.  Use the correct GPIO pin to ensure its operation.

Fixes: a1d8a344f1ca ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20201213183759.223246-6-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 66c9153b31015..597388f871272 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -150,7 +150,7 @@
 		regulator-name = "audio-1.8V";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
-		gpio = <&gpio_exp2 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio_exp4 1 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 
-- 
2.27.0



