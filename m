Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689F844A0DB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhKIBFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241716AbhKIBE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689D3619E8;
        Tue,  9 Nov 2021 01:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419693;
        bh=uki0/g9FoayK8Au37rz7OiZWnU+KkFYcc+IlyY4EuFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caMc//I6TL/MUiiuub7AOCbngrALF36/6Fd2V6c9icVlpm8r8I2CdYCb28lM9k5wR
         eRKpnziWboGLx1Hzo6h2N15Y3TdJ/ix/Tl0YFQIfxWujj2GDxE5Tuvbv8yZpZ6KMpi
         haTsaYeRtOhRS0dYMYmSS4oPfC5+hCM7pO6f44I/l6TYzIfMd3dBGLinYRq54n8iuF
         xGpcy06SyKf9YAYS5zv2VhEOgp1NR0fss/oVz5NZE9JdEmdz2IxiFl1t1P6awIcNV4
         waAbYXBhjCGGFgMKPVxBeaEWrHCwjZ4Mm+EZCGVPFeVU/c7O9tLaZFlfHlSMXmDXNR
         AZvrCaWxHw9rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 003/138] drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
Date:   Mon,  8 Nov 2021 12:44:29 -0500
Message-Id: <20211108174644.1187889-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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

