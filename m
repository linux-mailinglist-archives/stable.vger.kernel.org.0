Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB61450CF9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237770AbhKORrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238734AbhKORpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E86A63305;
        Mon, 15 Nov 2021 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997351;
        bh=777d4et2zH62T8YPExYiwamsUuPq5njEPm0SdYLRbv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFVcejGKp5lo/yBeN824BURpnkDwPdyh/lWQdyiZ8a+c0gpCO/mNMhCuUN14jTt+n
         8LzoFipROvIjqbRtYT+tiS5UwAR41H6ZzZncibdxRAk+Xt1O8KeWxUUS62fS0Oe/S1
         hCztiUXHBDnUHK07ybvuMk6H70ComwEdgLwyolko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Risoldi <awxkrnl@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/575] drm: panel-orientation-quirks: Add quirk for GPD Win3
Date:   Mon, 15 Nov 2021 17:56:39 +0100
Message-Id: <20211115165346.198484697@linuxfoundation.org>
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



