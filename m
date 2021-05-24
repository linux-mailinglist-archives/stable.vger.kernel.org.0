Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2640638EAB6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhEXO5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234254AbhEXOyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:54:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C701F6142C;
        Mon, 24 May 2021 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867727;
        bh=++Gvob/5i3UQSKep7Q0P08CfuIhWyKIUp8gYkapj0vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t79CWdajXrzepdyYsBYzOU76VmLcm4NHB2PdW+71xE+INqP5OK6ALCkZ/WWptn8EF
         Y2rm6lP8vzAZ0v7Q5C1PN2Q7TFsN3//UNLZc1Fm8FG91snb6cUUtdTv1NYVN6BCj/d
         HcNMb/sReOkeS82De9qKd9whV0fI87trLGIG5c7lpjYIqVhvuwj/RHcbgGqI4dQyVV
         mNR2kZZHvSMkjbuxfgp0RMoQiSyCHyaw9jVJnLUp5bMgs16UNiaDFW6t8cvTKorPiL
         QE9wyTK9RAD3MvyeHmgwwxa7HQdXeH08YiCOW7EcY2aFjlCkYGpUb/oJpm1Quf927o
         N+51jzX9dJn1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 51/62] platform/x86: hp-wireless: add AMD's hardware id to the supported list
Date:   Mon, 24 May 2021 10:47:32 -0400
Message-Id: <20210524144744.2497894-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
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

