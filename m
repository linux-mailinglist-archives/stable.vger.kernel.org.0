Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3DF44A16A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhKIBJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237209AbhKIBHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF20619F9;
        Tue,  9 Nov 2021 01:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419801;
        bh=uki0/g9FoayK8Au37rz7OiZWnU+KkFYcc+IlyY4EuFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4N6p0I2fxRYWjZsxOM++8g+VrBlQ4Po2DbzL8xEIDZ4RO0R2rrNtSw4FoD8wD7VR
         bht/kwlLQJSKFidIjrDLWK7SEWYraSIq0o9fK2F/kiHMmhySOZMKbRxaYDN+ORfyX6
         Dum9y96f1upWw0FMoqBamqjNeGEMz70winkfUemHfffz3myAzhETFUqK2aAD58aa/Q
         8ATtLl18AjPqOmrnbw/rx0n6+Bjz/8qZPfBlJzKjZL7D2EMo3YVDbfqZn9PA/VEsof
         k/5/UzVS/alx5QPwdny8Iu9fZ/+4dtUucnO/cCCh/v3+1X7hPf4rY1hal//vC2kwZK
         aTJ4HRpTWxdnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 003/101] drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
Date:   Mon,  8 Nov 2021 12:46:53 -0500
Message-Id: <20211108174832.1189312-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
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
index 604535b1c3a95..d662292560c73 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id orientation_data[] = {
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

