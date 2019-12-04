Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7021133B7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbfLDSKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731217AbfLDSKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:10:12 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D46206DF;
        Wed,  4 Dec 2019 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483011;
        bh=TOV0UK0piw0Hanyoyx8YpCbQcv2tT6LiX7Adeaopczg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp3A5f9poFn2JXEuaRY+NriqnQrZkiyYCN9tunn21L4ugDbvxkY7PZcz6xXBzbSWx
         9a1HwvzSm9kZ2LtLkkkW3Cg1huKUEo+5kLmu3pnWAlrLWoZQyG0rWPDxS1AG4eRbOr
         tAk2Lg164MDauU4XAO2jONsA8bUBLsWT6HubQQiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Franchi <marco.franchi@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 016/125] ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication
Date:   Wed,  4 Dec 2019 18:55:21 +0100
Message-Id: <20191204175316.606197462@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 998a84c27a7f3f9133d32af64e19c05cec161a1a ]

imx53-voipac-dmm-668 has two memory nodes, but the correct representation
would be to use a single one with two reg entries - one for each RAM chip
select, so fix it accordingly.

Reported-by: Marco Franchi <marco.franchi@nxp.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marco Franchi <marco.franchi@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
index ba689fbd0e413..301cf8d45947f 100644
--- a/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
+++ b/arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi
@@ -17,12 +17,8 @@
 
 	memory@70000000 {
 		device_type = "memory";
-		reg = <0x70000000 0x20000000>;
-	};
-
-	memory@b0000000 {
-		device_type = "memory";
-		reg = <0xb0000000 0x20000000>;
+		reg = <0x70000000 0x20000000>,
+		      <0xb0000000 0x20000000>;
 	};
 
 	regulators {
-- 
2.20.1



