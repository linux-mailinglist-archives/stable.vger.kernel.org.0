Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278484C090F
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbiBWChe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237396AbiBWChP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D735AEC2;
        Tue, 22 Feb 2022 18:32:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA624B81E1B;
        Wed, 23 Feb 2022 02:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9565C340E8;
        Wed, 23 Feb 2022 02:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583547;
        bh=jLKMO32rA0KjtQgvheUPI/dFWNoxa++1fZrLUNzJ5aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYXiR/NeApJrlGKQK1p269aPZPEdB504CDp0pP97TYZDCeEXGsgjv6RJqvolNhUyu
         QTY0w73NCW6lVYzCTobj6K0VD3+UbmpAiHURHw9xekhVL3hAtxUQqqSBgtdVRym7ov
         KNZgSwrESh33ru8SqB9Q4hVWvynaaYQg7Ca9/pD4JP3sQj4ZSNY5VIWjmQoVPBnpRM
         Nwpm6ObIFdyB+oiqvtUTNGQxLre9LY58ZRGQwwBWpk4vZlXPn7u3v7A5SWjRyeMxPl
         HbgnQxVtJ25KgH/FQSAHb9OLuFElcTKzXp8lqvwuFBJaPudb0AmWTQWxMkSpA9n0Re
         HOmlW21Ov2VPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@canonical.com, robh@kernel.org,
        semen.protsenko@linaro.org, yangyicong@hisilicon.com,
        geert+renesas@glider.be, jie.deng@intel.com, sven@svenpeter.dev,
        bence98@sch.bme.hu, lukas.bulwahn@gmail.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/13] i2c: cadence: allow COMPILE_TEST
Date:   Tue, 22 Feb 2022 21:31:50 -0500
Message-Id: <20220223023152.242065-11-sashal@kernel.org>
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
index 017aec34a238d..3a2f85d811f75 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -445,7 +445,7 @@ config I2C_BRCMSTB
 
 config I2C_CADENCE
 	tristate "Cadence I2C Controller"
-	depends on ARCH_ZYNQ || ARM64 || XTENSA
+	depends on ARCH_ZYNQ || ARM64 || XTENSA || COMPILE_TEST
 	help
 	  Say yes here to select Cadence I2C Host Controller. This controller is
 	  e.g. used by Xilinx Zynq.
-- 
2.34.1

