Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1674C08A9
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbiBWCdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiBWCdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:33:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72737CF0;
        Tue, 22 Feb 2022 18:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481DC6152A;
        Wed, 23 Feb 2022 02:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697A4C340F0;
        Wed, 23 Feb 2022 02:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583470;
        bh=C61B4YqZLuPfUtAJA5XNOFg/InlbWVrwKeMTqahBgjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loscU46DXj5H2qNzjpa599QzYNMxlsYLfmYMvhMlPy/Fsv5cSZ7vJXnTs7BsER4Pq
         Xg5gciM6mUxQR1Oqw3Ka8U0vnkg7fvS3a1NWQaQ4CUHlpBSzQiDIsYQ8lHGNKEmbKe
         UAt2OYiDbnUroagS/MKZzok5WnhDlZL/dsVtpfPg4cDOTOe3Zo9fTzYRN9DKzJqhaz
         Mz7yYDRNEZoyBnElEJu/Kgg4rCwDKxdf/7Xiu/ZZMHLcuo2tNEviuIHyrGGESNZUzt
         y6WHF0BfhioDrsq1mnqEF/uCo/Uybj6VOlJsgkh9DxTmE1cicMUsChdnF9ttpt++DZ
         80L1OXFCBnMQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, yangyicong@hisilicon.com,
        semen.protsenko@linaro.org, robh@kernel.org, bence98@sch.bme.hu,
        sven@svenpeter.dev, jie.deng@intel.com, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/18] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:30:32 -0500
Message-Id: <20220223023035.241551-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
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
index 7e693dcbdd196..d5fc8ec025020 100644
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

