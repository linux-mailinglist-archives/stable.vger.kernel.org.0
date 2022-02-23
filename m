Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172EF4C096E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbiBWCjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbiBWCiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:38:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E3522BF6;
        Tue, 22 Feb 2022 18:33:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B20CB81E0D;
        Wed, 23 Feb 2022 02:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951FCC340E8;
        Wed, 23 Feb 2022 02:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583574;
        bh=94F1j0DiZ7qJpTyWsfI+MmjhV156Q0ciHj/koAEnTgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWLZ2d7oxK+MBn7U0dGpsBzbGxHBUPooNDBcU5CiE0doiwBOjBGYOg7w97/P1L4EE
         ZTpmXME1TmRTmeCBm7i92NvvdeQ6XG+LCRkSoWhC+AklU5aia0PrXCA0iVXox3vIQU
         OU/CTri8nABv02cjsJCKEy/Rln8v8EtoSW+Jiey8rIUwfFnICcE6kFArjhse7pWOeq
         /FSc4sRrZNf1IouKEQW9OJP3MOgfLABKGFHkI+JkF2m6qCdZjWq34bgRCdDYRGyoP3
         NHUNsZ1iWEQPdTFLTK52BXckprK093euqNGFIEuKr3zJcPOnwsXqD1E1gf3EYs9xgv
         Oc3hEICWoRngA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, robh@kernel.org,
        yangyicong@hisilicon.com, semen.protsenko@linaro.org,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/10] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:32:31 -0500
Message-Id: <20220223023233.242468-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023233.242468-1-sashal@kernel.org>
References: <20220223023233.242468-1-sashal@kernel.org>
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
index c457f65136f83..ab9c7f2f1f79b 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -459,7 +459,7 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
-- 
2.34.1

