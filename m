Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849CC5607B
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfFZDlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFZDlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:21 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCC820659;
        Wed, 26 Jun 2019 03:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520480;
        bh=ILdNPj3z8+pezhYzm9dmkr3+dbNKAPUfRHgz8RruHVE=;
        h=From:To:Cc:Subject:Date:From;
        b=cm/aPTtJt6wfLaEafSQjy45xWKhn/Uqe0U1Yp9vw7d01UG1hIt75e9fnuXYHbglHT
         mf8wfRhuplYPZ2CP5u3f0NEx4Iof5NQgkb4y2v0uD+ibp5j6rh9QrEpE4COIfWqVlK
         KdjLxB/iMyM2pBOmCWTIfezvXPTf2Ha3QnYmXKVA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 01/51] HID: i2c-hid: add iBall Aer3 to descriptor override
Date:   Tue, 25 Jun 2019 23:40:17 -0400
Message-Id: <20190626034117.23247-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit eb6964fa6509b4f1152313f1e0bb67f0c54a6046 ]

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override
list.

BugLink: https://bugs.launchpad.net/bugs/1825718
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index fd1b6eea6d2f..75078c83be1a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -354,6 +354,14 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "iBall Aer3",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "iBall"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Aer3"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };
 
-- 
2.20.1

