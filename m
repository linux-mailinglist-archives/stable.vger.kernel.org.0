Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24A657ACFC
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiGTBaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242242AbiGTB2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:28:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88A56C125;
        Tue, 19 Jul 2022 18:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E4B61702;
        Wed, 20 Jul 2022 01:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9293FC341CE;
        Wed, 20 Jul 2022 01:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279937;
        bh=QzX7BxSAv4pBnsCKOQ5V7oQozFAEs1cKaM+HZsg4hjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPBwPh4LM4bVaUPNo9OT6ULBzo6pf19NkY2/pFnmbeTuyENoiwGSXBmhBq+CRCKcv
         wyiOBzCq78r0o+Ukb9ay8AmIWwoR0NMk5PWFygNcX5pN42GgtfqaYwipm7yn3Gld2E
         cfgES0i8d1en6LpmaNDaLo+Nf4mv29T6chQSo1yqzM0V2DPWMs65/5weqKhUps9SXo
         nl+Jc9/LOwzT9DDBq7TrRJ9L0S7p3Y9zlpPmxFL83Mi1uqH5elq0hTLsY6aoSVCVEJ
         SO6MVqOOZzRz0bzzyV+NSelCF68JXi+jPeDgIbN+rHcx4cDOGhzYMizp9HoCVCbIbV
         L2qpaVVTGklgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Misaka19465 <misaka19465@olddoctor.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/6] platform/x86: asus-wmi: Add key mappings
Date:   Tue, 19 Jul 2022 21:18:36 -0400
Message-Id: <20220720011836.1025430-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011836.1025430-1-sashal@kernel.org>
References: <20220720011836.1025430-1-sashal@kernel.org>
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

