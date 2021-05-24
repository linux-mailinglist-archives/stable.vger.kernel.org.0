Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D14538EC31
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhEXPMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235001AbhEXPFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA8B6162F;
        Mon, 24 May 2021 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867862;
        bh=5BAGGJiXLxcegIokpiVUMA9UTbznoTBcL431gAL3K2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QST1ifKAwCcr0er+tT68/8nRq5wKqrK03RWx2Jg48QZvp6agHke0tA4U3S1cQvcdf
         sHJvjRjrH9UHUzmdZqIQfu4E16hs3/zzFHuR5pNrgKUVAC0u+2UJhbQS8OiANG3Xv7
         uLXfmUo0fbWmsxYxVcEmZw3wVEDk6tmVIQDAKhr36l5vnZ4bbMvgQc4s1GxxZrYaEe
         fS9lGWjw5V4DDLuFjMQEdtnv8GJ4T8fqCRDABbpFotv9zzFXpm/IUIDG+U4m1UDwMR
         m95m7fTzjWNOJIQF3QRUQeNi0uVmEMwWSIpzGW+xkSCMwyHK23Uujak02eNttGfoou
         yGOu9r3o5zqiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/21] platform/x86: hp-wireless: add AMD's hardware id to the supported list
Date:   Mon, 24 May 2021 10:50:37 -0400
Message-Id: <20210524145040.2499322-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
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
index d6ea5e998fb8..bb95bec0b110 100644
--- a/drivers/platform/x86/hp-wireless.c
+++ b/drivers/platform/x86/hp-wireless.c
@@ -30,12 +30,14 @@ MODULE_LICENSE("GPL");
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

