Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2825EEEFCA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387889AbfKDVyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387883AbfKDVyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:54:13 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDE8217F5;
        Mon,  4 Nov 2019 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904453;
        bh=NwcaHzqZ1lU4FzfoWU8IZZNT9FuebeODGEm+5dugqd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXahjCZ00TS5eFbRhPA93y3f9ZQ6M650LWBvxyW1Mp0uTQkzy5k6gRchEUHru0FIA
         AFfXsNj8fhYYJJ1YkWQiSh6VXdbIha9moGSKcQKEufo1TKh1xhs5cYRzKVoNyxvXf+
         N3sG/gVkq7gfQ5fu6eq6mJJmunrvvKiji7mklhHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Aldridge <taldridge@mac.com>,
        Julian Sax <jsbc@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/95] HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override
Date:   Mon,  4 Nov 2019 22:44:08 +0100
Message-Id: <20191104212042.995305786@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



