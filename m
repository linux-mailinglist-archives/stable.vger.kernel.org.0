Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884A04C082A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiBWCaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiBWCaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C21446B2C;
        Tue, 22 Feb 2022 18:29:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A38D1B81CA7;
        Wed, 23 Feb 2022 02:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E38C36AE2;
        Wed, 23 Feb 2022 02:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583357;
        bh=+0EpU+HNeg1odvwyzGPv0Wt95moAaPvI9wujS/xY2j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOo7FL1uNh39UMTH28ryMNiiYQ0zOMr5Ub9l/YXUphHfpAycGvpePHgJrSAxV6KhZ
         O1dHv5oqKVKH0IS4zvI8hBzlb5Ra4XYcHIR8g48yIwOLOPzfCriQX3xPRHhdlI3UTn
         C5wVkISXml6Al8sxXO7C+Qsd1ELMQUutWtJTBSa66qgzVUlG4bCTAl9E4aLTSv5NMv
         fANmrhk5sxYMy2u97gbAM5fNNY79TLEQW9OwmghjiTOy8J2SpsaDqlLttjjzVNCWSp
         uNbf/BDjdATmUV4c1DIjFrz0Tq40T8EixJ6hMlaAyxV4hR5b2+6RnnyUZ0CGynPbva
         9xGJevbPDQawA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        robh@kernel.org, yangyicong@hisilicon.com,
        christophe.leroy@csgroup.eu, sven@svenpeter.dev,
        jie.deng@intel.com, bence98@sch.bme.hu, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 25/30] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:28:14 -0500
Message-Id: <20220223022820.240649-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@kernel.org>

[ Upstream commit 0b0dcb3882c8f08bdeafa03adb4487e104d26050 ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index dce3928390176..b1c20859fe8c9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -488,7 +488,7 @@ config I2C_BRCMSTB
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
-- 
2.34.1

