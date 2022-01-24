Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696764996A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347644AbiAXVFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55262 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444468AbiAXVBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2342EB80FA1;
        Mon, 24 Jan 2022 21:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4650AC340E5;
        Mon, 24 Jan 2022 21:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058057;
        bh=zLZtC7ypmlhH1omlZOAIcSh+uqnfUwqd1cdnR2k5tXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vriyTdxdTJoEztgQ0Z0Gmpu+iBcH1Mad+/AeuKFPbVa4dbkuoBrLVdZrV+cEeq9nn
         68R2MNTEsXVXGyY/DfploQ8wVjBMEXuXUhJYYH573W7dFqozBytxlNlrnPo8xre6Ak
         EnBlUVeuhs1cwNcDVvdOXZw9f3tq/cjZkP0ERJ40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dillon Min <dillon.minfei@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0168/1039] ARM: dts: stm32: fix dtbs_check warning on ili9341 dts binding on stm32f429 disco
Date:   Mon, 24 Jan 2022 19:32:37 +0100
Message-Id: <20220124184130.866142103@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Min <dillon.minfei@gmail.com>

[ Upstream commit b046049e59dca5e5830dc75ed16acf7657a95161 ]

Since the compatible string defined from ilitek,ili9341.yaml is
"st,sf-tc240t-9370-t", "ilitek,ili9341"

so, append "ilitek,ili9341" to avoid the below dtbs_check warning.

arch/arm/boot/dts/stm32f429-disco.dt.yaml: display@1: compatible:
['st,sf-tc240t-9370-t'] is too short

Fixes: a726e2f000ec ("ARM: dts: stm32: enable ltdc binding with ili9341, gyro l3gd20 on stm32429-disco board")
Signed-off-by: Dillon Min <dillon.minfei@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f429-disco.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/dts/stm32f429-disco.dts
index 075ac57d0bf4a..6435e099c6326 100644
--- a/arch/arm/boot/dts/stm32f429-disco.dts
+++ b/arch/arm/boot/dts/stm32f429-disco.dts
@@ -192,7 +192,7 @@
 
 	display: display@1{
 		/* Connect panel-ilitek-9341 to ltdc */
-		compatible = "st,sf-tc240t-9370-t";
+		compatible = "st,sf-tc240t-9370-t", "ilitek,ili9341";
 		reg = <1>;
 		spi-3wire;
 		spi-max-frequency = <10000000>;
-- 
2.34.1



