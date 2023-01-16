Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89E66C1CC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjAPOPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjAPONv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542F525E1D;
        Mon, 16 Jan 2023 06:05:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350FF60FC9;
        Mon, 16 Jan 2023 14:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F8CC433D2;
        Mon, 16 Jan 2023 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877916;
        bh=rtzIhw+xi7hvSwN3JDX33u/nds0r8ebY+Rk9l6ErSrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POIgLXLmcNufJdDrHlOoqQHd9JePK480yAs/AT4aZK7zZnwuPjJ3qpURX37Hb9a9p
         HUh2YOV4Bs+5ffbOk+v95bfDc+Jam5jmRte9S+wa6OF5cKPm6mWefqYi3RBWCU7N2q
         pUIzpyN0WJjc8KKvkFX8J3DU2K22C9kDBhqhAIEKPS2BAepZ/az5/4xWEg4bf63F7Q
         Ku64dWIri5+xn0bVVeMnUopIfBvd1tGLyjpmZ0x59Vw77nHf0dajI7FORcxnl0Zcbm
         M09gvIOSz0YG3ra7j/9zewMTRZLrTso/KSfRvadqGQq6TYa5dBJD3/zCVRJbR8Y5nR
         b4iQqz8Bm2pYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Nemcev Aleksey <Nemcev_Aleksey@inbox.ru>,
        Sasha Levin <sashal@kernel.org>, corentin.chary@gmail.com,
        markgross@kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/17] platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK
Date:   Mon, 16 Jan 2023 09:04:47 -0500
Message-Id: <20230116140448.116034-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit db9494895b405bf318dc7e563dee6daa51b3b6ed ]

The 0x33 keycode is emitted by Fn + F6 on a ASUS FX705GE laptop.

Reported-by: Nemcev Aleksey <Nemcev_Aleksey@inbox.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230112181841.84652-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 949ddeb673bc..74637bd0433e 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -478,6 +478,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x33, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
-- 
2.35.1

