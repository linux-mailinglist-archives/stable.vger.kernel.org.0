Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0124831D5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiACOWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiACOWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D698BC061784;
        Mon,  3 Jan 2022 06:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54A22CE1107;
        Mon,  3 Jan 2022 14:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD93C36AEB;
        Mon,  3 Jan 2022 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219726;
        bh=QMaM8yOKO3rs2bs50dJgVC/IMfvUqjeKHvazUcO26js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMGM30jQ6iWWoB6zG5FW39W2H6yhLat1ZPL+l7Twxe9DOdYofaKimdEBMv0WKA3fk
         KngpJMkrbkBrzL3yk8Y1GNQ0SJyD1qMeXu0OzUYslNBu/Fw+hVQZqyfKjpYRY2yfHV
         KSFBun6QRidyXv88CaLDIe1kPjScMl/46udMYVyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Self <jason@bluehome.net>
Subject: [PATCH 4.9 01/13] HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option
Date:   Mon,  3 Jan 2022 15:21:17 +0100
Message-Id: <20220103142052.025852961@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
References: <20220103142051.979780231@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit c4f0126d487f3c68ab19ccb7c561e8fbf3ea2247 upstream.

Since commit 4bc43a421218 ("HID: asus: Add
hid_is_using_ll_driver(usb_hid_driver) check") the hid-asus.c depends
on the usb_hid_driver symbol. Add a depends on USB_HID to Kconfig to
fix missing symbols errors in hid-asus when USB_HID is not enabled.

Fixes: 4bc43a421218 ("HID: asus: Add hid_is_using_ll_driver(usb_hid_driver) check")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Jason Self <jason@bluehome.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -136,6 +136,7 @@ config HID_APPLEIR
 
 config HID_ASUS
 	tristate "Asus"
+	depends on USB_HID
 	depends on I2C_HID
 	---help---
 	Support for Asus notebook built-in keyboard via i2c.


