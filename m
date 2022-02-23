Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C184C0930
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiBWCjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbiBWCh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDE45C66D;
        Tue, 22 Feb 2022 18:32:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C229F61558;
        Wed, 23 Feb 2022 02:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1285C340F0;
        Wed, 23 Feb 2022 02:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583551;
        bh=faKb8S+dj0AamNTJtP4wWkYFDzropf0AlV3qAJECMQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6O5sM8QjUlLA9030bHNMP+z+uOEJkDPbjY0XcJtmfN3gspjLIzxLigELCrDL4XBR
         Y/WfuFNh6MfbUjEOZLgT97ID/EpW0IMz3KSrB7lnu0EF7Y2RFEjg3KB/1yA5vRrTAu
         +tYiOQNHa3CS25KaIG0NznH/QERdcMJB6nBmFnyGglgrQM9z/FjrPgLwQMwDCq1P7X
         Z5XXK0WM19EvE2l1sN2uqws/iC0c5mdP0THQU8M3sm3RE7Dzl7IxPGs7SLBNY0DvYT
         A9TW/SMYSW/9Rly3ZRfB79oQhq5cfMQTnsqayoc30vKzSofkhZWGkn9MpxkmpGfuCC
         Imrt4kVFbSyZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        robh@kernel.org, yangyicong@hisilicon.com, geert+renesas@glider.be,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/13] i2c: qup: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:31:51 -0500
Message-Id: <20220223023152.242065-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023152.242065-1-sashal@kernel.org>
References: <20220223023152.242065-1-sashal@kernel.org>
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
index 3a2f85d811f75..165c112bc5b9a 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -849,7 +849,7 @@ config I2C_QCOM_GENI
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
-- 
2.34.1

