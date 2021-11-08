Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6888544A22E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241989AbhKIBQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241704AbhKIBMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:12:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36F5961A2E;
        Tue,  9 Nov 2021 01:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419917;
        bh=IUHhLpJnBmLUC1z0AntfwflJjnRUzX+6/H+/sqk0CcU=;
        h=From:To:Cc:Subject:Date:From;
        b=V2ri+t0xH7fQBdMx+jjkSIcjro9vk00YrW3zSEhGbjhD+qwLY7yL5sZp27t2Sko87
         V0CV8N/UJfJvkDBSPS7ESaiMT3tpq4zH9oJ68HFu+sT839OMEIC84qo+bGrPK66IxO
         GY8f89yMoLN85MkDEkRNib4+HCZtj9TzRcUVgy5g/ubQK2Df5qmWWxTtqfeenIuCOO
         2lr6QpWjhI+WzxzxAiX0KJtZpXHwmaUBOOJT/SNfi6XATKf6vwa4ivYfeXQLbSoMCY
         45ZpbrLP7Ptsf4ZF2454odEOPP8sfNr53u0UzT8HvLOhnEhrss2rCwf7uGuTte9+1u
         g3XkbNesdNBxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 01/47] drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
Date:   Mon,  8 Nov 2021 12:49:45 -0500
Message-Id: <20211108175031.1190422-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a53f1dd3ab9fec715c6c2e8e01bf4d3c07eef8e5 ]

The KD Kurio Smart C15200 2-in-1 uses  a panel which has been mounted 90
degrees rotated. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20210530110428.12994-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 652de972c3aea..6c04181470a67 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -164,6 +164,13 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "TW891"),
 		},
 		.driver_data = (void *)&itworks_tw891,
+	}, {	/* KD Kurio Smart C15200 2-in-1 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "KD Interactive"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Kurio Smart"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "KDM960BCP"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/*
 		 * Lenovo Ideapad Miix 310 laptop, only some production batches
 		 * have a portrait screen, the resolution checks makes the quirk
-- 
2.33.0

