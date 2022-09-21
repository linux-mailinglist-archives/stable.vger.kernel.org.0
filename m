Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBA5C0291
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIUPyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiIUPwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08CE3C144;
        Wed, 21 Sep 2022 08:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D7F63138;
        Wed, 21 Sep 2022 15:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AC2C433D6;
        Wed, 21 Sep 2022 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775370;
        bh=T4HvC8yXhIBoI7Uz+o4CufFA8Nd+teDpEZ+zCprH8uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=siwDE4RVpihCwjAIo/3l4MeYL4XplCLkaK3DVr8tyRf7l5VKMSOpU+3dJsN8aTxxE
         +jKkbHrJkeNtq4h7CMgXxSSsUICybhXreeoSH3IYqsNRh33Bu7NcxqSQ7NhIXAayYh
         B7m69o9G79xSckkVVycXoIMAfcqhuniifH4ncrSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Molly Sophia <mollysophia379@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/45] pinctrl: qcom: sc8180x: Fix wrong pin numbers
Date:   Wed, 21 Sep 2022 17:45:57 +0200
Message-Id: <20220921153647.148379218@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Molly Sophia <mollysophia379@gmail.com>

[ Upstream commit 48ec73395887694f13c9452b4dcfb43710451757 ]

The pin numbers for UFS_RESET and SDC2_* are not
consistent in the pinctrl driver for sc8180x.
So fix it.

Signed-off-by: Molly Sophia <mollysophia379@gmail.com>
Fixes: 97423113ec4b ("pinctrl: qcom: Add sc8180x TLMM driver")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220807122645.13830-3-mollysophia379@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc8180x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc8180x.c b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
index 32a2d8c5ceae..a4725ff12da0 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8180x.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
@@ -530,10 +530,10 @@ DECLARE_MSM_GPIO_PINS(187);
 DECLARE_MSM_GPIO_PINS(188);
 DECLARE_MSM_GPIO_PINS(189);
 
-static const unsigned int sdc2_clk_pins[] = { 190 };
-static const unsigned int sdc2_cmd_pins[] = { 191 };
-static const unsigned int sdc2_data_pins[] = { 192 };
-static const unsigned int ufs_reset_pins[] = { 193 };
+static const unsigned int ufs_reset_pins[] = { 190 };
+static const unsigned int sdc2_clk_pins[] = { 191 };
+static const unsigned int sdc2_cmd_pins[] = { 192 };
+static const unsigned int sdc2_data_pins[] = { 193 };
 
 enum sc8180x_functions {
 	msm_mux_adsp_ext,
-- 
2.35.1



