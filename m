Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449E62E1684
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgLWCTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbgLWCTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81061233F8;
        Wed, 23 Dec 2020 02:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689963;
        bh=dIfa+AoqY/hATkxwXQSMO3x2NsDLSL31oNsuX1MjOd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVe/hEU6cs/LjFv3tGKdsaBLFHF/SWPs6HW8EyF8kUmS6KjAaEyHs4OsZcqO6KWEw
         7s4nILfd7aTgQxFO5H8+SJacGbnRB8G/wnFAWhS8oGgrYud9z0/rRvviUtHyWhqtdJ
         u3V1BxtGjZQU6Q689LA0UNzZggxUu9A6O4C0IWjcYHSCkc9yqGDBhCvKAwmp9B7Unt
         sx2Py1xvRBR9PaRNIlzX/c0wDEjky98jYO7vqwcWWLEIFwQhnB3HUKzCe/Olj6u0dP
         vZlG2Sg9GJ4H/FjAQqOihqdFOTcSqNPM9DWSUdtYP517wkjl9iSYqX8F217nJh+d9z
         U7vrpa2VCVNxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 054/130] Bluetooth: hci_h5: Add OBDA0623 ACPI HID
Date:   Tue, 22 Dec 2020 21:16:57 -0500
Message-Id: <20201223021813.2791612-54-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 5df0651b6cd55..ddee3d498a210 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -989,6 +989,7 @@ static struct h5_vnd rtl_vnd = {
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id h5_acpi_match[] = {
 #ifdef CONFIG_BT_HCIUART_RTL
+	{ "OBDA0623", (kernel_ulong_t)&rtl_vnd },
 	{ "OBDA8723", (kernel_ulong_t)&rtl_vnd },
 #endif
 	{ },
-- 
2.27.0

