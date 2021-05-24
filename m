Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F5638EB6E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhEXPC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhEXPAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489376145F;
        Mon, 24 May 2021 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867801;
        bh=xqcJR1KERW8KFWTM2WRvC/CRYUvxYo0LiAy0HNtebjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fvqu1QC88vX1+B/3j6aEQgTbU+awx0d5u6C3Qj5zxs3K3jVFNgm5RTJWCKIYU80+Z
         48vK2h/Ek12IrOG1S0+UmN53Ca5vIye7TAbCgcS9HNyQ0n71qe4IDySBwWWDb6zeaK
         890jH4r15b9yieBdCjQrgMkQPSxhy9GopMawm0Ean1ZD1AQ4a06Z2UFYU7mRBfTPqS
         OTcZAJV0mIQOf+227v0WtfdUQoTecTGMNm2CrZcfyytlHuHqZexrBUMHM+wqmJwnw8
         /YwC9DPH2p3ZdQcg3QE4REP+luIvb3hvq207K7KjjdXjNqg4PBcxG5VaqnlkZYyxKl
         0IJowHd0A3tgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teava Radu <rateava@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 47/52] platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet
Date:   Mon, 24 May 2021 10:48:57 -0400
Message-Id: <20210524144903.2498518-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 7ed1189a7200..515c66ca1aec 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -838,6 +838,14 @@ static const struct dmi_system_id touchscreen_dmi_table[] = {
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

