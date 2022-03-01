Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D04C962D
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbiCAUTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbiCAUR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4910793A3;
        Tue,  1 Mar 2022 12:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0769E6170E;
        Tue,  1 Mar 2022 20:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1549C340F5;
        Tue,  1 Mar 2022 20:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165811;
        bh=2Uzh0/OS4z7vTKLHAOXfStTxevEP7fmgDp2vpjSmQos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZYiQ4w4acxXcx47fB62HHUv36Jon92WabrMKMElOGD5cWrjPO9cxK5RCv+CWORIs
         tVPEPvZdIoiiOeM+PBWE3zB0qliDSeeM509w3ZJPEKnODbv0jE+RAtw7MKo9hfrG4+
         /epVunLhwQnUtEwT6ZzopujYswkvN8QwfyY85mJD9RS1g1vct1i+v3UeUuvmK0kmpA
         WkVT0Xaq9vh8o/74zXZ51yQdTeMdVXu/15/pDTWJJNAc8HMGIGSuLFrNkqf3qH25XQ
         4J4idoOj8sXG5Ej/61hDpnSlok2wVOaViT1CZ0qbM2PoonthX2Z0nS55kF9fb1DzCk
         CXRQIhynv/Rrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, andy@kernel.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/23] pinctrl: tigerlake: Revert "Add Alder Lake-M ACPI ID"
Date:   Tue,  1 Mar 2022 15:16:03 -0500
Message-Id: <20220301201629.18547-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6f66db29e2415cbe8759c48584f9cae19b3c2651 ]

It appears that last minute change moved ACPI ID of Alder Lake-M
to the INTC1055, which is already in the driver.

This ID on the other hand will be used elsewhere.

This reverts commit 258435a1c8187f559549e515d2f77fa0b57bcd27.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-tigerlake.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-tigerlake.c b/drivers/pinctrl/intel/pinctrl-tigerlake.c
index 0bcd19597e4ad..3ddaeffc04150 100644
--- a/drivers/pinctrl/intel/pinctrl-tigerlake.c
+++ b/drivers/pinctrl/intel/pinctrl-tigerlake.c
@@ -749,7 +749,6 @@ static const struct acpi_device_id tgl_pinctrl_acpi_match[] = {
 	{ "INT34C5", (kernel_ulong_t)&tgllp_soc_data },
 	{ "INT34C6", (kernel_ulong_t)&tglh_soc_data },
 	{ "INTC1055", (kernel_ulong_t)&tgllp_soc_data },
-	{ "INTC1057", (kernel_ulong_t)&tgllp_soc_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, tgl_pinctrl_acpi_match);
-- 
2.34.1

