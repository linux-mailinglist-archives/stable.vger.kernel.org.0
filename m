Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43E635D85
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiKWMns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbiKWMnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:43:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FFD6D4A6;
        Wed, 23 Nov 2022 04:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA5E61C61;
        Wed, 23 Nov 2022 12:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA691C433D7;
        Wed, 23 Nov 2022 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207312;
        bh=/61jfsLdljMDFPdtEBS2vw7prXiq2jdHhKMEl3xl418=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNxpJrfD0SXcfGuLhytO5Wvh0TgWY8YVzLmVKjdXkJ/0Re9DFTlAVJ5gC7777DeQk
         wpZP11TFA9NlCBZvfpJtSq74R9/SXvJp84J78V/sVEIdhIqRZYvf9hMfe1ZSv9fdJP
         O/H/bOr+H0nXrDaV7rc2yLrSo1V5/Aw1gBo9C1kEk97Sz2PtB6xu8UXbbwLHXh9dr6
         6gHeP+/Cgiy01snNvtq6cnwwWj/XQ6Ptys5zr/D2qQ7YRiN8NOP3bjHKHOwnvdcvZq
         5lFPbfVXgfK3FMlNvreDgRRpINKUhU2luqCJqJBGNMVdPIDUFIyb4zbSW0whceps9V
         si3InNeevk3Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Lennard=20G=C3=A4her?= <gaeher@mpi-sws.org>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 22/44] platform/x86: thinkpad_acpi: Enable s2idle quirk for 21A1 machine type
Date:   Wed, 23 Nov 2022 07:40:31 -0500
Message-Id: <20221123124057.264822-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lennard Gäher <gaeher@mpi-sws.org>

[ Upstream commit 53e16a6e3e69425081f8352e13e9fd23bf1abfca ]

Previously, the s2idle quirk was only active for the 21A0 machine type
of the P14s Gen2a product. This also enables it for the second 21A1 type,
thus reducing wake-up times from s2idle.

Signed-off-by: Lennard Gäher <gaeher@mpi-sws.org>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2181
Link: https://lore.kernel.org/r/20221108072023.17069-1-gaeher@mpi-sws.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2dbb9fc011a7..379dfd6fa1b2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4495,6 +4495,14 @@ static const struct dmi_system_id fwbug_list[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A0"),
 		}
 	},
+	{
+		.ident = "P14s Gen2 AMD",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1

