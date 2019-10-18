Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDFDDD308
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388886AbfJRWJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388387AbfJRWJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:09:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15351222C2;
        Fri, 18 Oct 2019 22:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436565;
        bh=NwcaHzqZ1lU4FzfoWU8IZZNT9FuebeODGEm+5dugqd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YtmuNUw7CPFwaVw35NX3L+/b4+hccYYIHGLQTOAhKpR+Cty0szW8oqMxj/x2KfLd
         pMb75BIm9EeKHe2W3iVkhTig8kAAATVps1ljisRsvJStte+m35aboKQaMIsmwjYgkq
         VOmDGTlhySZpydOGdxsHruuJ7g7E4IixNsdPnVZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Sax <jsbc@gmx.de>, Tim Aldridge <taldridge@mac.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/29] HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override
Date:   Fri, 18 Oct 2019 18:08:53 -0400
Message-Id: <20191018220920.10545-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220920.10545-1-sashal@kernel.org>
References: <20191018220920.10545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sax <jsbc@gmx.de>

[ Upstream commit 399474e4c1100bca264ed14fa3ad0d68fab484d8 ]

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override list.

Reported-by: Tim Aldridge <taldridge@mac.com>
Signed-off-by: Julian Sax <jsbc@gmx.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index cac262a912c12..89f2976f9c534 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -330,6 +330,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Direkt-Tek DTLAPY133-1",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Direkt-Tek"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "DTLAPY133-1"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{
 		.ident = "Mediacom Flexbook Edge 11",
 		.matches = {
-- 
2.20.1

