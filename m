Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D807D2DF336
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgLTDgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:36:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728473AbgLTDgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:36:43 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Beginn <linux@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 6/6] Input: goodix - add upside-down quirk for Teclast X98 Pro tablet
Date:   Sat, 19 Dec 2020 22:35:11 -0500
Message-Id: <20201220033511.2728659-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033511.2728659-1-sashal@kernel.org>
References: <20201220033511.2728659-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Beginn <linux@simonmicro.de>

[ Upstream commit cffdd6d90482316e18d686060a4397902ea04bd2 ]

The touchscreen on the Teclast x98 Pro is also mounted upside-down in
relation to the display orientation.

Signed-off-by: Simon Beginn <linux@simonmicro.de>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20201117004253.27A5A27EFD@localhost
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index b20ba65992735..7e480e2364216 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -136,6 +136,18 @@ static const struct dmi_system_id rotated_screen[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "12/19/2014"),
 		},
 	},
+	{
+		.ident = "Teclast X98 Pro",
+		.matches = {
+			/*
+			 * Only match BIOS date, because the manufacturers
+			 * BIOS does not report the board name at all
+			 * (sometimes)...
+			 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_BIOS_DATE, "10/28/2015"),
+		},
+	},
 	{
 		.ident = "WinBook TW100",
 		.matches = {
-- 
2.27.0

