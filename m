Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B92A4C0915
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbiBWChg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiBWChP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B5F5F4F0;
        Tue, 22 Feb 2022 18:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF95161526;
        Wed, 23 Feb 2022 02:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85CC340EB;
        Wed, 23 Feb 2022 02:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583507;
        bh=4Zek1ADwo7OcWm8ziM0C/gyY0rWG7TG2aclFo9XHMtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIY6Uo7Zb7OzI2GLCHNrpbS0k9ECFlheIVE0SsZmw7P+j5OX7YKRm+mpSZtml0xOA
         Hbzmtq0IPTuknZ9CL6YHnp2rr3rvHsuSdyZAOVpZ1amF1fQRsxxCUse/OQ8DGjPATa
         kGNCyNZDsVfw0gPqb8RsAiG98ZQjRzAR2dgHk6lzQiYuxvgbXSYG8neizkKNmhI0Pv
         ZaIoiQJvuSDxAeHAf6teZPPcIwbtluct2WBz9K4/4tCA6zSSJUHsCsgRDAt8sD8pYJ
         NecStpNZ+PR9qPdULNX2yvCTTztnn6N4alHI3kDUwaxkczNUcWMmhZGiCqtboW/r2o
         osJttES2oBCIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, yangyicong@hisilicon.com,
        semen.protsenko@linaro.org, robh@kernel.org, sven@svenpeter.dev,
        jie.deng@intel.com, bence98@sch.bme.hu, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/13] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:31:15 -0500
Message-Id: <20220223023118.241815-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023118.241815-1-sashal@kernel.org>
References: <20220223023118.241815-1-sashal@kernel.org>
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
index 2d08a8719506c..94c78329f841c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -483,7 +483,7 @@ config I2C_BRCMSTB
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
-- 
2.34.1

