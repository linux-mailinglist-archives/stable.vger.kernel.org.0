Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60750452507
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358071AbhKPBq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241585AbhKOSX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD68632AD;
        Mon, 15 Nov 2021 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998824;
        bh=KgNYs70AqdvifhnDfLu/6gP4SPOTkLTRF+1SM1Y2Zpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOM71l/0oMO4WuqUh1lWKemf68MK3+pPuyY0dUQBQbR61st4PBY5UouMkju1i3mCw
         GbUUiTDGwopT2Lnse1KAXawI2mupbcPYmW/wIR3eukdksTZ/bv+C5Yk2rFjpowYElh
         wIA03qR9N7gBagk7w68kvd0OqWuPNqYKTETM21Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bryant Mairs <bryant@mai.rs>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 076/849] drm: panel-orientation-quirks: Add quirk for Aya Neo 2021
Date:   Mon, 15 Nov 2021 17:52:39 +0100
Message-Id: <20211115165422.628816975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryant Mairs <bryant@mai.rs>

[ Upstream commit def0c3697287f6e85d5ac68b21302966c95474f9 ]

Fixes screen orientation for the Aya Neo 2021 handheld gaming console.

Signed-off-by: Bryant Mairs <bryant@mai.rs>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211019142433.4295-1-bryant@mai.rs
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f6bdec7fa9253..30c17a76f49ae 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -134,6 +134,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T103HAF"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO 2021 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "AYADEVICE"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "AYA NEO 2021"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* GPD MicroPC (generic strings, also match on bios date) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
-- 
2.33.0



