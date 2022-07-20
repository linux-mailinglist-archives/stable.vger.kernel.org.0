Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC3757AC3E
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbiGTBVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240841AbiGTBUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB7F655A7;
        Tue, 19 Jul 2022 18:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02AFDB81DE8;
        Wed, 20 Jul 2022 01:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDDDC341D1;
        Wed, 20 Jul 2022 01:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279761;
        bh=b/YFQZ/cCeh4t/njU6qYLaBSWrdRC0xNYA6SQ22L0p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5gjv6YVy5rC8J7AzjytFmOicpgg2tk9Sj8AQDerpRQX8YZLDANuwN440kMsG3i21
         EDcBqrIlzeJV3ydmgZE3Ycrtk00HSdXbno7QofkOVOJ3m++haW8Zet3kbWMuoEedE8
         HeVR7O/Pp9YjqBdvGZVBENsgMPu3UTLN9Kw2wxHUjSBR9KFF0BWHO1dA2Q/Y0hQQsZ
         ehyJXhLZagrEIoOb+zuPnbPeSJtqqrmz89pe1Iitbcw9Lp5qOxmeXv58gHGmc0uTom
         5vJv7j9pIG2teuljEhERn8bAXjhyzkmgYC3czkL8l/AmXR4wDa8VWhXyvfOCWFixqW
         LkkTYfGJAARDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Misaka19465 <misaka19465@olddoctor.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 36/42] platform/x86: asus-wmi: Add key mappings
Date:   Tue, 19 Jul 2022 21:13:44 -0400
Message-Id: <20220720011350.1024134-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
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

