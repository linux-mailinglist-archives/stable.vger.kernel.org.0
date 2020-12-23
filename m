Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019742E1E09
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgLWPeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgLWPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6AE323343;
        Wed, 23 Dec 2020 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737607;
        bh=mLDTgU0xU8qsivjyIMSRzDAadyE34XB/VvXeVQ+7CkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duNO1goL228SaGuuaJFEDKaDmER3Ur6iIW+0s5aAT8vbxFZ95fbKlTM0Ybw8e5wDk
         /LHO9f9KH1tGJzGe8H6cNI1/sTmtqHD0mS86ktlEgRI4i3km0cfVMMN14rW8x4sdio
         UrcLgW59DfcJDwth9J1BP8yrt0UfG6rnV9vh836w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Sax <jsbc@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 27/40] HID: i2c-hid: add Vero K147 to descriptor override
Date:   Wed, 23 Dec 2020 16:33:28 +0100
Message-Id: <20201223150516.854835830@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
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
@@ -405,6 +405,14 @@ static const struct dmi_system_id i2c_hi
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
 


