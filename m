Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34AD2E1583
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgLWCtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgLWCWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEBCA225AC;
        Wed, 23 Dec 2020 02:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690107;
        bh=MsgXBX36RNXbJaTgxGZ5gH+/E7pwOkfeIXDe8IMOq9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru9UE8mS9aYdkcWECJc7J89W1Ze6S7qe1PrR5PP0OjdVBkXqteVckN/UP5I73C4mI
         AhocqPkYErCuaVHHoDxZC8mmnS05lFZPvMio5MipMdZK1Dibu/okXscNKVL0RJX1P+
         ITDIzy2G64qAVU18kFBjmwJKJ7gNjbXhM5hxkOGZiEq1f5P4UTfYDGQ3uJcbZTDXDZ
         zCWQefoyxHoj4nu2ufGErQxzDiBd92YYdcAnJtScM/rfz55OmOxW8Tl693ex2iI98T
         PoxlgPdCPyaw9XbcMg1r1nmcxyQjXttKuNZLF66jeM4LX3X5TOUZ+rHu8ZMRqu0K1d
         8MdBN12mZN5CA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/87] Bluetooth: hci_h5: Add OBDA0623 ACPI HID
Date:   Tue, 22 Dec 2020 21:20:12 -0500
Message-Id: <20201223022103.2792705-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e524f252c42fc4f2bc4a2c3f99fe8659af5576a8 ]

Add OBDA0623 ACPI HID to the acpi_device_id table. This HID is used
for the RTL8723BS Bluetooth part on the Acer Switch 10E SW3-016.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1665610
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 5a68cd4dd71cb..702aa08c6395f 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -928,6 +928,7 @@ static struct h5_vnd rtl_vnd = {
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id h5_acpi_match[] = {
 #ifdef CONFIG_BT_HCIUART_RTL
+	{ "OBDA0623", (kernel_ulong_t)&rtl_vnd },
 	{ "OBDA8723", (kernel_ulong_t)&rtl_vnd },
 #endif
 	{ },
-- 
2.27.0

