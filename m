Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E99148025
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbgAXLID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389277AbgAXLID (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:03 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B20BB2071A;
        Fri, 24 Jan 2020 11:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864082;
        bh=2K617BrCLgkoMyWj/9LkdwkJFsI9C8CInVWoTIwR+qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBZXWTCqLPmqqG/WwKwRW+BFMji5gqiUk5elDsmewUfGR+8Tx6PZLSJwAh2j9XMYA
         XK0DJRVUxVCWf3W8EL095e2g4DWlDIHX3harBF5gFhVZW7XsfnGURca5bIvTykhj9L
         Qylw+IGjWhd+JwVN/8B6m3fsAwySCUvR5MLnEmsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/639] ARM: dts: lpc32xx: phy3250: fix SD card regulator voltage
Date:   Fri, 24 Jan 2020 10:25:37 +0100
Message-Id: <20200124093108.087739823@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit dc141b99fc36cf910a1d8d5ee30f43f2442fd1bd ]

The fixed voltage regulator on Phytec phyCORE-LPC3250 board, which
supplies SD/MMC card's power, has a constant output voltage level
of either 3.15V or 3.3V, the actual value depends on JP4 position,
the power rail is referenced as VCC_SDIO in the board hardware manual.

Fixes: d06670e96267 ("arm: dts: phy3250: add SD fixed regulator")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc3250-phy3250.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/lpc3250-phy3250.dts b/arch/arm/boot/dts/lpc3250-phy3250.dts
index 1e1c2f517a82b..ffcf78631b226 100644
--- a/arch/arm/boot/dts/lpc3250-phy3250.dts
+++ b/arch/arm/boot/dts/lpc3250-phy3250.dts
@@ -49,8 +49,8 @@
 		sd_reg: regulator@2 {
 			compatible = "regulator-fixed";
 			regulator-name = "sd_reg";
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
 			gpio = <&gpio 5 5 0>;
 			enable-active-high;
 		};
-- 
2.20.1



