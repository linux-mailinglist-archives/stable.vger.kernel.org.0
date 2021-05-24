Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4838E9D4
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhEXOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233069AbhEXOt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7416613F2;
        Mon, 24 May 2021 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867648;
        bh=++Gvob/5i3UQSKep7Q0P08CfuIhWyKIUp8gYkapj0vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdKBXrSXfyQ5KhIJCDh+nRhN5t+sSH6riGAlFsngJHAOOHs9vtil4aaEPxvNvhxLv
         QkoOpTr3Et7JH20bXYCFxeacjFvizf6GwQ2qrLgOfuq18wddt0gkYrHFaIYsFMQ9tf
         lXgeVomHjmZqp1uKi1AY9c4pvIRhk0F3g/FwpAf/nRvOXJzsc3Lp9EkoCoDf4ppiCg
         Op9R7VSZ7W1CAb0nYORgYA0RhHkrtYp61KfM3oXbRDFc5vljh6xpKCVPqV1i9nH7Sp
         pl+U7+KNzM0CVNVKX2+D+joJyBGsDkgqCMNxYhfAcBot+/TYILdD6GOODoW0aDZcXT
         kcb+1h07nueiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 52/63] platform/x86: hp-wireless: add AMD's hardware id to the supported list
Date:   Mon, 24 May 2021 10:46:09 -0400
Message-Id: <20210524144620.2497249-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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

