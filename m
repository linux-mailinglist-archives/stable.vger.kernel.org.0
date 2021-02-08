Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B2F313781
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhBHP0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:26:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhBHPUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89AD464EAC;
        Mon,  8 Feb 2021 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797194;
        bh=skOZTl6nLcjm1TYWcN3Z1w/d4l+Nm2S3Psvlf9ZHkqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOUGaSKuuwnR6GvjcIctEUbnr+pMmzIPzeqPO34i/XjREt8q/w2hd+tfHyBLO3nBc
         MKvAPD+bMAQS8tR4swFf1S0vUOHrSkyeCP6nJARjQ1TVesn0KiCb2HzQUjW8JgB8t8
         3AC8qHHFeQ99qOfxPkTeVxITl2KAOtDb6thjDQzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/120] ARM: dts: stm32: Fix GPIO hog flags on DHCOM DRC02
Date:   Mon,  8 Feb 2021 16:00:11 +0100
Message-Id: <20210208145819.364334269@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 83d411224025ac1baab981e3d2f5d29e7761541d ]

The GPIO hog flags are ignored by gpiolib-of.c now, set the flags to 0.
Since GPIO_ACTIVE_HIGH is defined as 0, this change only increases the
correctness of the DT.

Fixes: fde180f06d7b ("ARM: dts: stm32: Add DHSOM based DRC02 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
index 4cabdade6432b..e4d287d994214 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi
@@ -35,7 +35,7 @@
 	 */
 	rs485-rx-en {
 		gpio-hog;
-		gpios = <8 GPIO_ACTIVE_HIGH>;
+		gpios = <8 0>;
 		output-low;
 		line-name = "rs485-rx-en";
 	};
@@ -63,7 +63,7 @@
 	 */
 	usb-hub {
 		gpio-hog;
-		gpios = <2 GPIO_ACTIVE_HIGH>;
+		gpios = <2 0>;
 		output-high;
 		line-name = "usb-hub-reset";
 	};
-- 
2.27.0



