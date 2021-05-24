Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B283438EAAA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhEXO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233066AbhEXOy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F100061416;
        Mon, 24 May 2021 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867729;
        bh=hniJiFp2sLbqLGigdh4OnKrH/Op3ooEehqon8f4Ojzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ljqa0GQ4ZXkrQMyTZbaWGOyreQ95dFuLeH+PW5BixhL6e+gfhXJi319JI2Eb8erfD
         TG+/Wuct5gcrW+2U6YowR2bWCv7cEK3Yo6a3jracw+8gp4Z45Gj+xPAaN1Ce6iTpbO
         RyCjRiw1xyzVfMnQTfTbjRKxkr7o6rVzGwyOjK1gXiyTvoYkqATrkMNHluE9nz4pBE
         0F3UQa5zj46FLGDU9OcHgOvDKA2vGWchFacUIOpGulbmPFkdSuX7YioRl6kKesG877
         Nt0Mv1wzNlOH6k8W5YiyA+EcO2HQaH3KkBzFyqdS+Ak8W5U2yz3GT6hb3BFHI6pkFx
         7sCR60u2rcbFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teava Radu <rateava@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 53/62] platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet
Date:   Mon, 24 May 2021 10:47:34 -0400
Message-Id: <20210524144744.2497894-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Teava Radu <rateava@gmail.com>

[ Upstream commit 39a6172ea88b3117353ae16cbb0a53cd80a9340a ]

Add touchscreen info for the Mediacom Winpad 7.0 W700 tablet.
Tested on 5.11 hirsute.
Note: it's hw clone to Wintron surftab 7.

Signed-off-by: Teava Radu <rateava@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index c4de932302d6..e1455f1d2472 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1043,6 +1043,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "jumperx.T87.KFBNEEA"),
 		},
 	},
+	{
+		/* Mediacom WinPad 7.0 W700 (same hw as Wintron surftab 7") */
+		.driver_data = (void *)&trekstor_surftab_wintron70_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIACOM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WinPad 7 W10 - WPW700"),
+		},
+	},
 	{
 		/* Mediacom Flexbook Edge 11 (same hw as TS Primebook C11) */
 		.driver_data = (void *)&trekstor_primebook_c11_data,
-- 
2.30.2

