Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E31449A35C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2367972AbiAXX52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846019AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1843EC061759;
        Mon, 24 Jan 2022 13:21:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4F1BB811FB;
        Mon, 24 Jan 2022 21:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E599CC340E4;
        Mon, 24 Jan 2022 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059301;
        bh=0mE4HMQmvBOAF1RsNUNu4EhUlU0J1p1amXqdxPdIfWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRPGAL1nZl119s2rG6dQpBYL42hSCYjA6ww63VFhyIggKUWGRpmqfpaTM6pIB7bJW
         AWSQ+G6lmqkSsf4/3uyKkMtvR9LRaiJQFJfrPNaEQVaHmwOeM8hdMWRX6dJ4/d4mRx
         L/irQ+D4sNMW7gtoJpr3cdwFQXmgjYFkDAct8MQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0570/1039] drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
Date:   Mon, 24 Jan 2022 19:39:19 +0100
Message-Id: <20220124184144.495199759@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bc30c3b0c8a1904d83d5f0d60fb8650a334b207b ]

The Lenovo Yoga Book X91F/L uses a panel which has been mounted
90 degrees rotated. Add a quirk for this.

Cc: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Tested-by: Yauhen Kharuzhy <jekhor@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211106130227.11927-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index a9359878f4ed6..042bb80383c93 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -262,6 +262,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
+		.matches = {
+		  /* Non exact match to match all versions */
+		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
-- 
2.34.1



