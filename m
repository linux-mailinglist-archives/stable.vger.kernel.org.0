Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2138C57ABDC
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbiGTBQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbiGTBPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A1666AFA;
        Tue, 19 Jul 2022 18:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED27C6176B;
        Wed, 20 Jul 2022 01:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E455C341CA;
        Wed, 20 Jul 2022 01:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279615;
        bh=b/YFQZ/cCeh4t/njU6qYLaBSWrdRC0xNYA6SQ22L0p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArHTcf1wZA6KqirMKA+19II5xZQbQA28E6yPs0cz3dFzKLlAisuCzQNjCdhRzIUKR
         PH7x6HKE3w+2EG6YxHJUk7+Sdd5CXu/kLoQHpjvKESMEC5fIx9jWu/A1Iklcy2y7+1
         UPlpVWvBvumHPk6ZoMUvZOgeOdUAqpOU5Y2J4RPqDY1Ho0nlhaoooSBUZOJqkqlyep
         vYm79t3Q8qShXJWpzp99ZAz9OYCat2/kfwkKX76le5s8UWiEaU1mY3WYsdrDftgMxe
         Esz5DZ0Ka1tNz6CMagSt0/Jx8LwPMCT86n5gDmmXcWpPm9WKNiOt/BCt8cIkbrxc7Z
         v5OqTcynoIC4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Misaka19465 <misaka19465@olddoctor.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 48/54] platform/x86: asus-wmi: Add key mappings
Date:   Tue, 19 Jul 2022 21:10:25 -0400
Message-Id: <20220720011031.1023305-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Misaka19465 <misaka19465@olddoctor.net>

[ Upstream commit f56e676a7f1ca7de9002526df3d2ee0e47dfd8ce ]

On laptops like ASUS TUF Gaming A15, which have hotkeys to start Armoury
Crate or AURA Sync, these hotkeys are unavailable. This patch add
mappings for them.

Signed-off-by: Misaka19465 <misaka19465@olddoctor.net>
Link: https://lore.kernel.org/r/20220710113727.281634-1-misaka19465@olddoctor.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a81dc4b191b7..6ec9529f8142 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -522,6 +522,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
+	{ KE_KEY, 0x38, { KEY_PROG3 } }, /* Armoury Crate */
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
 	{ KE_KEY, 0x43, { KEY_STOPCD } }, /* Stop/Eject */
@@ -573,6 +574,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xA5, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + TV + HDMI */
 	{ KE_KEY, 0xA6, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + TV + HDMI */
 	{ KE_KEY, 0xA7, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + CRT + TV + HDMI */
+	{ KE_KEY, 0xB3, { KEY_PROG4 } }, /* AURA */
 	{ KE_KEY, 0xB5, { KEY_CALC } },
 	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
-- 
2.35.1

