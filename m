Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9974B58C124
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243707AbiHHB5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbiHHB4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09829F591;
        Sun,  7 Aug 2022 18:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A2FA60DF5;
        Mon,  8 Aug 2022 01:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE9C433D7;
        Mon,  8 Aug 2022 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922772;
        bh=B+3p/GQqQOtvQA60D7Hg3pIgqOkJKFL3MaPiyOP8loE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRw6T1BGT2IpWWIG1dX3ELnyXeCnG3yUrsT/Z9Pg3VCnyBRjvEAL998uO7uZ1bSO9
         +nQDW7K5iVJgUyCCgdMs6sbEP1ihCXh57uA8/VKZErx0CUJtR21+hGkw6Td4Ymqcmp
         in85+CgR4w8DPearL1f4BFkhEU0zbblL697SuNIts0ENEE24AY4ayhI3Ag5ppE5xcB
         S6KhFZKMOP/DW035l9j8OqvRxlDI2blsd1lUqllcZUDA+vrQn4sx4sD2Rh0pVfrUr0
         DSV1GY3oPPv0TZorH7qJ0Ayfq90U/YpTkV11WJPsZ/DQMQtN5ny3+oStVW+Q+qvgEM
         skv8+Gx8osoyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/16] ACPI: EC: Remove duplicate ThinkPad X1 Carbon 6th entry from DMI quirks
Date:   Sun,  7 Aug 2022 21:39:07 -0400
Message-Id: <20220808013914.316709-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013914.316709-1-sashal@kernel.org>
References: <20220808013914.316709-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 0dd6db359e5f206cbf1dd1fd40dd211588cd2725 ]

Somehow the "ThinkPad X1 Carbon 6th" entry ended up twice in the
struct dmi_system_id acpi_ec_no_wakeup[] array. Remove one of
the entries.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e3df3dda0332..3394ec64fe95 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2118,13 +2118,6 @@ static const struct dmi_system_id acpi_ec_no_wakeup[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Thinkpad X1 Carbon 6th"),
 		},
 	},
-	{
-		.ident = "ThinkPad X1 Carbon 6th",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Carbon 6th"),
-		},
-	},
 	{
 		.ident = "ThinkPad X1 Yoga 3rd",
 		.matches = {
-- 
2.35.1

