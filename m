Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332338E9D9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhEXOvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233205AbhEXOt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01EC5613E1;
        Mon, 24 May 2021 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867650;
        bh=1m1lvHMZRM41MlBa4EFWZQLiMkDhEqr5cEsP18CrtqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYXUE0JJVxUalFwkYy4KAawBaJKn8Oegx+WsZB7frLUC2VVQwEKc+6o7htH8YbbIZ
         4Gea+4tRjEmqn4pbJ043VPU+XmwPPf64+BC6gJTD+0rYaaAbrDfCQEV+NHgwbdNi+o
         AEwB89vfRRkjuP2W+7bLcslcDbDDF5D/DIHRWnzbQi4vLjBEvc6Bqa9GwMKiR8sLgl
         YmlRC2VF0wVCXPDhAJ6u/uHsRR02nScgWCUklzbyGoN1FeQeooH8ov3HxKRjlh429R
         EREmsFTjVjtjZpvprrAyEg4JFk/oBBtvfNVzsRwBKhvgZZWtBlp8/9zecIHRTaCinq
         1Rj8gmwaqOkXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teava Radu <rateava@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 54/63] platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet
Date:   Mon, 24 May 2021 10:46:11 -0400
Message-Id: <20210524144620.2497249-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index c44a6e8dceb8..5e4eb3b36d70 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1070,6 +1070,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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

