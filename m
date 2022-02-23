Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8663E4C091D
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiBWCi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiBWChP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF694E385;
        Tue, 22 Feb 2022 18:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 323E461518;
        Wed, 23 Feb 2022 02:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0CCC340E8;
        Wed, 23 Feb 2022 02:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583510;
        bh=KU9KxHdaFgt17cuA03Z+1RGe0NpG03ZvA+hiQ+3fiuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSaMT+c9tvcvVZ6qiwnGyAZqpIFoknUVpGiWqrtu3CcZaecZ1be4zzRl9no/fC744
         woCOEK6F+4o39UicIQo7pRW7D8SujAO2PNNVL23/fPAwD4gXr0/bGEqPKvFqrGW8y8
         NP0gAh6tNIX7J4it8Hm4otmyziMPP5nJusM3GPVQA8Ik6WYP7RB59H5059jYkrUInX
         i1QW5Wq/IbcZ0akiTVbTsdkaOhASrRW7tCWO7OO8I2gxJn9OakmcUlUjb0NpYDvrPb
         KyMV12XEZlDXMEmD9tdLXz2C+WQGbmLHyjGAQjUjkcq8CweCtD6Cd6MId0nz2dtn95
         5oifC20GDlcIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        robh@kernel.org, yangyicong@hisilicon.com, lukas.bulwahn@gmail.com,
        jie.deng@intel.com, sven@svenpeter.dev, bence98@sch.bme.hu,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/13] i2c: qup: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:31:16 -0500
Message-Id: <20220223023118.241815-12-sashal@kernel.org>
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

[ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]

Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
and easier maintenance.

Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 94c78329f841c..854f1b2658b82 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -894,7 +894,7 @@ config I2C_QCOM_GENI
 
 config I2C_QUP
 	tristate "Qualcomm QUP based I2C controller"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the Qualcomm SoCs.
-- 
2.34.1

