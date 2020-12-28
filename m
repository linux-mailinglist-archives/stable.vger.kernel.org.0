Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195352E6619
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbgL1QIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388176AbgL1NZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 996FA229EF;
        Mon, 28 Dec 2020 13:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161897;
        bh=5bGTUm81ag/3S89yN7MpSFV2B8qeibKXJ+LYrlFFpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZKCo7utfZTZnQ2nemeeET2hN8NKr40Zo4BzggYEIYscZMRioNKpJ20IMWvdMo0PK
         VieoFRae2N3EFcTaO/sZW1WwIG5YPfvj7fVEQ7hzjmpRn7vfjaMjPU9fee8L4G1cAO
         wM4FJ3VNq4k/vhw2Fi3PbmYF0g64zfE02SKp3cFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 089/346] HID: i2c-hid: add Vero K147 to descriptor override
Date:   Mon, 28 Dec 2020 13:46:48 +0100
Message-Id: <20201228124924.106616942@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
 


