Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E57F6281
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfKJCne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfKJCnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0A121924;
        Sun, 10 Nov 2019 02:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353811;
        bh=VnAEBOD27XWMulR9/EeVPCt6n+USTqJyjGRRcoqKhTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWqIi6lgT/206GyfOSwSI29dJIwMbnohOShfnwsrQF4ApdXVQxEv+R/NeZf2E/JnZ
         tJXJVFWY6aZ7dqtT28iyrC2K2f1ZSYljB3YUBqMAFO/pzX71R7PFsGv7aNeVlAVVJH
         pzmji7kW4mNHlF0oAR32nzqtx14gjBNTGxRiqeQo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 107/191] ARM: dts: imx6ull: update vdd_soc voltage for 900MHz operating point
Date:   Sat,  9 Nov 2019 21:38:49 -0500
Message-Id: <20191110024013.29782-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 245f880c25dbd8927af0f33aa5d1404370013957 ]

Update VDD_SOC voltage to 1.25V for 900MHz operating point
according to datasheet Rev. 1.3, 08/2018, 25mV is added to
the minimum allowed values to cover power supply ripple.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ull.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
index cd1776a7015ac..796ed35d4ac9a 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -22,7 +22,7 @@
 	>;
 	fsl,soc-operating-points = <
 		/* KHz	uV */
-		900000	1175000
+		900000	1250000
 		792000	1175000
 		528000	1175000
 		396000	1175000
-- 
2.20.1

