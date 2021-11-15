Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF8A450D38
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhKORxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238936AbhKORur (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23E5660296;
        Mon, 15 Nov 2021 17:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997485;
        bh=odmSdevAFY5g9HT/JAMOlYz3PtCpVziVvFLpahWTVxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aG8Ycsn93D0T2RWtNCJthRkW1ZmaRvpWR0ywPg656J7ifPFcA6BRsHB9HDXEoxIU5
         QHZHhuTZ2DlKOlYvng7bU11q61JBZnN7k9d55qJv32EtkVJ9oiozTgpkTCsCpq1xQ8
         /4wspARNMq9cHTvwJQ8fvSyOsFuznd/dQC/Cn9Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/575] drm: panel-orientation-quirks: Add quirk for KD Kurio Smart C15200 2-in-1
Date:   Mon, 15 Nov 2021 17:58:10 +0100
Message-Id: <20211115165349.423004883@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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



