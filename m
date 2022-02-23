Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E661B4C08FC
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbiBWCdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiBWCcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743B9593BA;
        Tue, 22 Feb 2022 18:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C67B81E16;
        Wed, 23 Feb 2022 02:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59464C340E8;
        Wed, 23 Feb 2022 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583422;
        bh=TTpzorY7CU9ZxKx5aL88krYIEwNU8a+X9B4wT5I8UsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsx4plufgWAQvtJSmZhY2CuKxWJmLq/s4kvc24HMkviBoAloB46uUboN8izhn+Qsg
         kXaCl0L/pRJNik3Dnf1/bGMLudYnc1VoDQm2+C+NtMiISUohIde5deWbVXZAWv393j
         8ZLmHAw7OPEscho5+yTt7H7aN9B6gcG748bTKAysCKxFL7tXHEqnRe2VFZCV8F6VP3
         mA0gtjlW/lHWINw+LcVXA0smRlWswLKetrER5EXRdhudfomCUselJ0MX5CXEs3NwdK
         UJRicMWpNLd4ivQU8etUyGKKvj/vgU3v7ZNbJa/s3qN0BvOgCR97gHnFzrGsdeDoaz
         ad6tS+8ZrVIiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, yangyicong@hisilicon.com,
        robh@kernel.org, semen.protsenko@linaro.org, bence98@sch.bme.hu,
        sven@svenpeter.dev, jie.deng@intel.com, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 23/28] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:29:24 -0500
Message-Id: <20220223022929.241127-23-sashal@kernel.org>
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
index e17790fe35a74..652b754a66db0 100644
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

