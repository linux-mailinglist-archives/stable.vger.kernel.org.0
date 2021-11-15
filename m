Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49BB45215A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348896AbhKPBDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:03:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245580AbhKOTUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3EF63563;
        Mon, 15 Nov 2021 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001433;
        bh=nSosOyqjZ5AqMs0T6sr0nJBrA4Lt2qn/AX2MCMDgxDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoitiavD+ctPkg2CIuWpu5ZbvSGxQ26VMog8xJDB0pYjH10etLMjteycZYMjnQrPh
         fDV/8r9o06zKqhUAFmoZhxHL15CFtDI2ycy6Zz3T9wnXVW8o3Fj3zbFTlyY/eGoqww
         EKgKpD+PQieM2rC5cI+x9DPN36BE2LA4XSrAxIGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Jared Baldridge <jrb@expunge.us>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/917] drm/panel-orientation-quirks: add Valve Steam Deck
Date:   Mon, 15 Nov 2021 17:54:44 +0100
Message-Id: <20211115165435.199629080@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

[ Upstream commit 9eeb7b4e40bfd69d8aaa920c7e9df751c9e11dce ]

Valve's Steam Deck has a 800x1280 LCD screen.

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: Jared Baldridge <jrb@expunge.us>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hans de Goede <hdegoede@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210911102430.253986-1-contact@emersion.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 926094b83e2f4..a950d5db211c5 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -261,6 +261,13 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Galaxy Book 10.6"),
 		},
 		.driver_data = (void *)&lcd1280x1920_rightside_up,
+	}, {	/* Valve Steam Deck */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Valve"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Jupiter"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "1"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* VIOS LTH17 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VIOS"),
-- 
2.33.0



