Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7B395EEF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhEaOFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:05:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhEaODb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D164361404;
        Mon, 31 May 2021 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468266;
        bh=hniJiFp2sLbqLGigdh4OnKrH/Op3ooEehqon8f4Ojzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5hnKOkXKLpKWbi7GU+ZhSHIMdWSUxgoPoK+A4Ecjl36Q4mW5/gHgo1jU237B0vPX
         61XA5V+2diickvRbGYUm3UWZBzYuo+d3dZDWJSZv0xLDpGRalqopTOwgilgc76AKYO
         eaOwOaYRJgnZOAzDT0GFc3o+LN9sR5QMYW39x8Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Teava Radu <rateava@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/252] platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet
Date:   Mon, 31 May 2021 15:14:04 +0200
Message-Id: <20210531130704.098872356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Teava Radu <rateava@gmail.com>

[ Upstream commit 39a6172ea88b3117353ae16cbb0a53cd80a9340a ]

Add touchscreen info for the Mediacom Winpad 7.0 W700 tablet.
Tested on 5.11 hirsute.
Note: it's hw clone to Wintron surftab 7.

Signed-off-by: Teava Radu <rateava@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210504185746.175461-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index c4de932302d6..e1455f1d2472 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1043,6 +1043,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "jumperx.T87.KFBNEEA"),
 		},
 	},
+	{
+		/* Mediacom WinPad 7.0 W700 (same hw as Wintron surftab 7") */
+		.driver_data = (void *)&trekstor_surftab_wintron70_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIACOM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WinPad 7 W10 - WPW700"),
+		},
+	},
 	{
 		/* Mediacom Flexbook Edge 11 (same hw as TS Primebook C11) */
 		.driver_data = (void *)&trekstor_primebook_c11_data,
-- 
2.30.2



