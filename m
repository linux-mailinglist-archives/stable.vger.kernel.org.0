Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88837450F16
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhKOS0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241175AbhKOSYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B508C63326;
        Mon, 15 Nov 2021 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998857;
        bh=777d4et2zH62T8YPExYiwamsUuPq5njEPm0SdYLRbv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpC1aSqVqHkPnGsg9AXLII0ckL4byCFmlmmlABl+WZLi6fDXTGYWLKitS3mbTuM0/
         YG8mi8dMXRqnWMeuhuTGc7TX7O7sMLh+M/xF1Oy8fnXb1bjXpZ41fVK5vvin9pC50l
         K0FAzpYA8yuD187umv0HgqlMZV6v0Q22o3SQ52Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Risoldi <awxkrnl@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/849] drm: panel-orientation-quirks: Add quirk for GPD Win3
Date:   Mon, 15 Nov 2021 17:52:50 +0100
Message-Id: <20211115165423.018161688@linuxfoundation.org>
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

From: Mario <awxkrnl@gmail.com>

[ Upstream commit 61b1d445f3bfe4c3ba4335ceeb7e8ba688fd31e2 ]

Fixes screen orientation for GPD Win 3 handheld gaming console.

Signed-off-by: Mario Risoldi <awxkrnl@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211026112737.9181-1-awxkrnl@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 30c17a76f49ae..e1b2ce4921ae7 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -191,6 +191,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
 		},
 		.driver_data = (void *)&gpd_win2,
+	}, {	/* GPD Win 3 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "G1618-03")
+		},
+		.driver_data = (void *)&lcd720x1280_rightside_up,
 	}, {	/* I.T.Works TW891 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "To be filled by O.E.M."),
-- 
2.33.0



