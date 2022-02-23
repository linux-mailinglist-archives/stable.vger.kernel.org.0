Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989D44C0821
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiBWCab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237017AbiBWCaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A245676B;
        Tue, 22 Feb 2022 18:29:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0641A6151F;
        Wed, 23 Feb 2022 02:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267B6C340E8;
        Wed, 23 Feb 2022 02:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583364;
        bh=vK/HHEI0xeGlH7UTjcjOEOkuJUzXcQ8w+cItaKNXuLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFdFVf7O0c/zgy4so8jb/RKnZorhXJzSa/1sQopYhB94oAJP9eU7YrqLeAoRQ7z6h
         kcs299zJ7sFhZdL9nNvSRKPnU26LUVdFYnOYBF2WRhDWVuweSIXwdWsYdGDi69uy05
         34C5X1Dz6cFHmuCEC8F+0V0gzpQXx5W4pDJ6uxH4uSviowUuOoowrzgeM8eCZVuFzG
         OSzHBYrwn3ZGJ9j3/nRspVA6l0NXBrix9b0K/UdT4ARoUJa+zwIBp8SKvLukTMNuI9
         KXfcDo3PHDykEu8kr3TAirRTz46R/7lhy5gP5+ZSBfMWXZdNcrjc8k+peikrbicwxz
         3yaqPaE3fvR1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        yangyicong@hisilicon.com, robh@kernel.org, geert+renesas@glider.be,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 27/30] i2c: qup: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:28:16 -0500
Message-Id: <20220223022820.240649-27-sashal@kernel.org>
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

[ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 66476c2257553..37233bb483a17 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -935,7 +935,7 @@ config I2C_QCOM_GENI
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
-- 
2.34.1

