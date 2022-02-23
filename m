Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410B84C087D
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiBWCdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiBWCcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:32:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E6C5AEDC;
        Tue, 22 Feb 2022 18:30:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFCDBB81E18;
        Wed, 23 Feb 2022 02:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE2C340F6;
        Wed, 23 Feb 2022 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583426;
        bh=iiiU8DN3ENwStLSi/sYPdqOZyIuha6jES6Cbw9b1hww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibsFWho/8JI5E2vtC2uDQqBl4xWg8w2hUgo/jlZnZR/oqb1sqMRaqKscfR9c/Cq1e
         a4f9JVR+XOEp0FUeZYTszTsXDeFj8QC9QPYBBBpB/X3AeURqjxW/z1z+LHBF20rWGH
         llxSQOnxRqaUu7QfBukPb8LRmItab3+uj85pZTsJ/P0NPcw+Ger9DVV+EPGCCqF7zt
         RzGl0bFrMAgGGxPMPq4/OsGVEWGzBhFsMcSUx5dz5DHt47nrPEnY1GMx0nxKHNFrZE
         59aAZ4QJe8y0iTle2DlnEaFwHQWlrd0BuQaRARLH8KSqsLRF8M5ElUKEh+G5Ju2nPE
         IH/62CmiGiX0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, yangyicong@hisilicon.com,
        semen.protsenko@linaro.org, robh@kernel.org,
        geert+renesas@glider.be, jie.deng@intel.com, sven@svenpeter.dev,
        bence98@sch.bme.hu, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/28] i2c: imx: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:29:25 -0500
Message-Id: <20220223022929.241127-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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

[ Upstream commit 2ce4462f2724d1b3cedccea441c6d18bb360629a ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 652b754a66db0..f76aaf9559365 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -677,7 +677,7 @@ config I2C_IMG
 
 config I2C_IMX
 	tristate "IMX I2C interface"
-	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE
+	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE || COMPILE_TEST
 	select I2C_SLAVE
 	help
 	  Say Y here if you want to use the IIC bus controller on
-- 
2.34.1

