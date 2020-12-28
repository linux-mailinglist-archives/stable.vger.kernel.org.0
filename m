Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0092E386F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgL1NKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731322AbgL1NKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:10:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1172120776;
        Mon, 28 Dec 2020 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160973;
        bh=5bGTUm81ag/3S89yN7MpSFV2B8qeibKXJ+LYrlFFpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUaEgdq/J1YscM8eXKvwUKEHE0VH9dsm8tgxOKxIntBVl0aG8/Q9WaMHH7dEzRYvZ
         KQExQwDM2WHmaOxT/HpqyAf1VD0qMXC3sbxrgc2Oo/Sy3f458E5mNqCv+WUr+xdOZ0
         CchHno3jly3f4d9HRM9iPuG+yUfCQRFOJMwsG+v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 058/242] HID: i2c-hid: add Vero K147 to descriptor override
Date:   Mon, 28 Dec 2020 13:47:43 +0100
Message-Id: <20201228124907.538171229@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Sax <jsbc@gmx.de>

commit c870d50ce387d84b6438211a7044c60afbd5d60a upstream.

This device uses the SIPODEV SP1064 touchpad, which does not
supply descriptors, so it has to be added to the override list.

Cc: stable@vger.kernel.org
Signed-off-by: Julian Sax <jsbc@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -397,6 +397,14 @@ static const struct dmi_system_id i2c_hi
 		},
 		.driver_data = (void *)&sipodev_desc
 	},
+	{
+		.ident = "Vero K147",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "VERO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "K147"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
 	{ }	/* Terminate list */
 };
 


