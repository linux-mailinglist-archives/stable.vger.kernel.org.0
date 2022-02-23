Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8D84C0846
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiBWCab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiBWCaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D2648389;
        Tue, 22 Feb 2022 18:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24FA7B81E09;
        Wed, 23 Feb 2022 02:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E6AC340E8;
        Wed, 23 Feb 2022 02:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583360;
        bh=XAdpkROvnoCMJTGEPTjC+34Zy9TbnvDoLlFeyd/ocdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZWnKEQtxnnQ4myriBfgRvaJ/zqQIo4ukoc+5M5qIhIspEbYYxBULh+h4r0uG8mlO
         b5Hqq+79qvDttSPnt9A+Ko0lo8hoDLIQsMq5xYt5hKJ03M7A4vwO1XLEOqJ2QwQVLF
         iywZasJ9dsGzTdaFOW5lzjpBGbjUxS5tXlarxrwKebC1suYRBZe5ByYf/dHiprWxIE
         QKwhGozKJh2pkOQrHJRKs84576ZdYJ8bY7V9IPt6DzzWplAo3VnJL2gJtKZI2M6uCp
         F1SCW1WEPrSoBQyUYzM4SSaX8ZsDk9/9lEDgRYSVrtqWBTsknfQcJSBDTsAAWdA5Jy
         61eqTs+T7Cmpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, robh@kernel.org,
        yangyicong@hisilicon.com, semen.protsenko@linaro.org,
        jie.deng@intel.com, sven@svenpeter.dev, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 26/30] i2c: imx: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:28:15 -0500
Message-Id: <20220223022820.240649-26-sashal@kernel.org>
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
index b1c20859fe8c9..66476c2257553 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -680,7 +680,7 @@ config I2C_IMG
 
 config I2C_IMX
 	tristate "IMX I2C interface"
-	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE
+	depends on ARCH_MXC || ARCH_LAYERSCAPE || COLDFIRE || COMPILE_TEST
 	select I2C_SLAVE
 	help
 	  Say Y here if you want to use the IIC bus controller on
-- 
2.34.1

