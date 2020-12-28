Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB52E37D3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgL1NBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729610AbgL1NBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19FF22B40;
        Mon, 28 Dec 2020 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160421;
        bh=5bGTUm81ag/3S89yN7MpSFV2B8qeibKXJ+LYrlFFpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyc3zPOzVh7QvCEZaqV1L5s+FKxNLPeyxlZ9xu05qxxK9SyIUBzE9OcVUKrlE3I/W
         tehYHoWg9K5dWbpD4CZweAACe7XKB70giWYY6oGTvZseZPYQA7aMw55fJsLbtd2XMy
         /NjlcpcsTChdhQexbhTqM2U7qA+Pcf86iwIQfURI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 045/175] HID: i2c-hid: add Vero K147 to descriptor override
Date:   Mon, 28 Dec 2020 13:48:18 +0100
Message-Id: <20201228124855.436560568@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
 


