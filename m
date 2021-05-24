Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F3A38EB66
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhEXPCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234123AbhEXPAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413D761464;
        Mon, 24 May 2021 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867798;
        bh=++Gvob/5i3UQSKep7Q0P08CfuIhWyKIUp8gYkapj0vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdgT8YCvLN9H8P0arWq0ZYW0ZCJ1+XQiG9TdI+b9YECi5eEz1K+FskGSG8SwFargs
         srpcJery7IOF5fmHFjDWu7buFIlkwtqjaJHsqv7Yh8OBfFnrbqWiXJT6gLuMxYCaqQ
         /nLAqTMIfh5G49KDc7G/QbuVQVicp2N2PAlOJ2qVN0WgVDzP7devR2BUvapTJsjGyM
         kOWjmR2bSRyXWuBwMkx0CXQF+KCN/oT6+W0rQx1aYimZkSmn4JCGYEtJZhBis0bp9u
         8XCH3C/5qMEQLt/UzYUO8By3qefGRLY2jrUQi+soHbFgZK2DEQVbHpp1rN0RrIO2iE
         pfNUDunS3gUMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 45/52] platform/x86: hp-wireless: add AMD's hardware id to the supported list
Date:   Mon, 24 May 2021 10:48:55 -0400
Message-Id: <20210524144903.2498518-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit f048630bdd55eb5379ef35f971639fe52fabe499 ]

Newer AMD based laptops uses AMDI0051 as the hardware id to support the
airplane mode button. Adding this to the supported list.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20210514180047.1697543-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wireless.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
index 12c31fd5d5ae..0753ef18e721 100644
--- a/drivers/platform/x86/hp-wireless.c
+++ b/drivers/platform/x86/hp-wireless.c
@@ -17,12 +17,14 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Hung");
 MODULE_ALIAS("acpi*:HPQ6001:*");
 MODULE_ALIAS("acpi*:WSTADEF:*");
+MODULE_ALIAS("acpi*:AMDI0051:*");
 
 static struct input_dev *hpwl_input_dev;
 
 static const struct acpi_device_id hpwl_ids[] = {
 	{"HPQ6001", 0},
 	{"WSTADEF", 0},
+	{"AMDI0051", 0},
 	{"", 0},
 };
 
-- 
2.30.2

