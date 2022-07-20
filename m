Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4980657ACB6
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbiGTB2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242125AbiGTB1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:27:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E9F7694F;
        Tue, 19 Jul 2022 18:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7AFC6176A;
        Wed, 20 Jul 2022 01:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29716C341CA;
        Wed, 20 Jul 2022 01:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279916;
        bh=QzX7BxSAv4pBnsCKOQ5V7oQozFAEs1cKaM+HZsg4hjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXlmO3duOSEGMooFdU50ARTRHAZQQpvKSPCmZWNc9gWUG1cREtVWGQQMeasVhyP5V
         LxgT7zuh1BcCzzgHr/C5OmY41aoeygN+eeoWpZVYQ2EVKxWbusU0xPOmpS1Yjkdl7/
         X995yTxobRAKO3vYbmAIqsLj3MfOj7IjMTF7t5eXVUCjIfGqe6AXLssj8FdQg7kSbY
         n8TfiHf2RlwzYa8GBho3qGFb9Zvz6ua7tcDB8XsL0KQyhghnMEjsiE0JeSg6tc2MBk
         8Vg3Gfw515PXs2+1pQ7bTGR+im1X7G/hTivsMzsIpKhVZ1IcPvDvPViErhTRXaa9+s
         IDxlWaKeRjgcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Misaka19465 <misaka19465@olddoctor.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 8/8] platform/x86: asus-wmi: Add key mappings
Date:   Tue, 19 Jul 2022 21:18:10 -0400
Message-Id: <20220720011810.1025308-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011810.1025308-1-sashal@kernel.org>
References: <20220720011810.1025308-1-sashal@kernel.org>
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
index 8db2dc05b8cf..1ca6f6e8db45 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -451,6 +451,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
+	{ KE_KEY, 0x38, { KEY_PROG3 } }, /* Armoury Crate */
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
 	{ KE_KEY, 0x43, { KEY_STOPCD } }, /* Stop/Eject */
@@ -499,6 +500,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xA5, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + TV + HDMI */
 	{ KE_KEY, 0xA6, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + TV + HDMI */
 	{ KE_KEY, 0xA7, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + CRT + TV + HDMI */
+	{ KE_KEY, 0xB3, { KEY_PROG4 } }, /* AURA */
 	{ KE_KEY, 0xB5, { KEY_CALC } },
 	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
-- 
2.35.1

