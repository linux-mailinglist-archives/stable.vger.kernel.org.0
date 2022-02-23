Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8342A4C095E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiBWCj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbiBWCik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:38:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFCE65795;
        Tue, 22 Feb 2022 18:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6612B81E0D;
        Wed, 23 Feb 2022 02:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35473C340E8;
        Wed, 23 Feb 2022 02:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583601;
        bh=+HjWtkyg5blV/CSVSQ1sFF66D+smH/UPn9Xx4gaydoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1Fr9jr6StkJDozyri4ShusheSDPuN8IVWuPaXse2SYJNTjhN3HInFoJ1CWxpD1/d
         Jv5rEgMC6LOzkEp7QCTs6PpC4mcp1xYextOHlAMDCVtAQE7m8G4xNYAeBThIuDzQBx
         EWJBJoXLlHkcJqLDhhM4iWBxpm59zBs7jIItNNabIEZJMxtew9o3fkCJiUii/nFBcY
         93z5sLMJGSh9WlZSmLemsmQpfpV49osCveSM4PCCAKYoK5tINz9Ba/J25UM5UzDphs
         OUGDOQIbU6ikwviPOTZHkBaN18nRiA7m5ez9KsiW+tfwbCqvHHHvt1HMoaCsk4url1
         CwJN3lfOa3kfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, robh@kernel.org,
        semen.protsenko@linaro.org, yangyicong@hisilicon.com,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/9] i2c: qup: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:32:59 -0500
Message-Id: <20220223023300.242616-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023300.242616-1-sashal@kernel.org>
References: <20220223023300.242616-1-sashal@kernel.org>
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

[ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 759c621a860a9..be4b7b1ad39b6 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -783,7 +783,7 @@ config I2C_PXA_SLAVE
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
-- 
2.34.1

