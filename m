Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB094C958D
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiCAUOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbiCAUOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:14:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711BE74DF9;
        Tue,  1 Mar 2022 12:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E9C261707;
        Tue,  1 Mar 2022 20:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CDEC340EE;
        Tue,  1 Mar 2022 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165647;
        bh=2Uzh0/OS4z7vTKLHAOXfStTxevEP7fmgDp2vpjSmQos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ih/LZSiJzNXuGdx1a15qlVT4si7Oz8c2BL+JNIA5SL7+3EARE6AntJviV1fds8lA/
         G3UwGd6ZqBSSJCHNwYEqgl8qNVnvmhBajVxrZ4nBJ9jw2GmjSG+7MT/SdZ85h7L7bc
         Z43xQXm5W0Riv6P9JcNhD2fq/lOg1HOpGaH/FftJiI+n2paR7k/Y7ipIAryivui+lZ
         33PFhFEd6ehmxwxqb8zw9tX4fwBrTRb8uQVKqbyqQe9VUi4cGBETtYlygQ53J9w4KY
         qeoeNKaNpppzVQ+bju9B74y34w3mWX+Bp7AkHqNS4syR+9mvOsD/9XpfCNGnmCpNij
         l9Q1JdKO1hKNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        mika.westerberg@linux.intel.com, andy@kernel.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 04/28] pinctrl: tigerlake: Revert "Add Alder Lake-M ACPI ID"
Date:   Tue,  1 Mar 2022 15:13:09 -0500
Message-Id: <20220301201344.18191-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
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

