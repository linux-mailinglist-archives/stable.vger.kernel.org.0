Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A070395EEB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhEaOF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhEaODX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A56061454;
        Mon, 31 May 2021 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468261;
        bh=++Gvob/5i3UQSKep7Q0P08CfuIhWyKIUp8gYkapj0vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zpZ24gk0ZKkFMtMVkJMWsqGogeiUXPCrJBROicd2Lbhlx+Mj4XsnmwZHa7c4qGa5a
         s8tkROKKesZ1xzkH6Opw5JEKA6HkjvQzamN9bfKxaq7YXNwrHigVHuzaEkh62xSzfw
         nihUyxu/DQ+ATg0qV2R+N2bfmvOUWELD44VCuqK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/252] platform/x86: hp-wireless: add AMDs hardware id to the supported list
Date:   Mon, 31 May 2021 15:14:02 +0200
Message-Id: <20210531130704.024786818@linuxfoundation.org>
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



