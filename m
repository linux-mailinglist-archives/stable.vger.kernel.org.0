Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD7C49969C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445907AbiAXVFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391106AbiAXUq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB6AC0619C3;
        Mon, 24 Jan 2022 11:56:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A39BB8122F;
        Mon, 24 Jan 2022 19:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E19CC340E7;
        Mon, 24 Jan 2022 19:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054213;
        bh=dxlHkkDhrDWGJRS2ZBt0S7lqBxv/VVktAClM8xc6FqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+8ZZenoKIRTXJGgWteeSA3Mhk95GYezmHKLlHrl0y3iCDRnkPzVQzW+1PTcgPJ3o
         5VX6KgIv8ZIpcL3cSnBVjQ9mslKCh/KIM+Bc7pA7+cU5KrNo3ngScxhm7D2V2gzhj5
         T5WHvc3bk+wd/ibYdi8p8gcLURKrn0lK9fE1g0Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/563] drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
Date:   Mon, 24 Jan 2022 19:41:19 +0100
Message-Id: <20220124184035.287668311@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index a950d5db211c5..9d1bd8f491ad7 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -248,6 +248,12 @@ static const struct dmi_system_id orientation_data[] = {
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



