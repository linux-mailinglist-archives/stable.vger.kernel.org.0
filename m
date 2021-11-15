Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B9A4527A6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243665AbhKPC3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236913AbhKORQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFC363255;
        Mon, 15 Nov 2021 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996365;
        bh=odmSdevAFY5g9HT/JAMOlYz3PtCpVziVvFLpahWTVxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBjy9bPMWZYIgxPxWyVNm4EJ0sVGc/LQGjdTDiZUpWmEdlgSw7IUePYC0oeXQj3Cc
         e3+MYQPWGw4JjsPQCnP2T3R3ZQcTgqfHJCJR6pa1zbK/jUdo8rC/1q/T0wjO5BR/HX
         AJlM1MXZqlZ69zKdri66QOI0o99WqRoKXAQ9IUHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/355] drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
Date:   Mon, 15 Nov 2021 18:00:38 +0100
Message-Id: <20211115165317.493587845@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5d0942e3985b2..cf4db2cdebbbd 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -205,6 +205,13 @@ static const struct dmi_system_id orientation_data[] = {
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



