Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2334831F3
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiACOXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiACOWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:22:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2973AC0613B4;
        Mon,  3 Jan 2022 06:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BD37CE110C;
        Mon,  3 Jan 2022 14:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FFFC36AEB;
        Mon,  3 Jan 2022 14:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219770;
        bh=lwj2r/vdy5EfWCyc7fU8IpKZOJHgY2+UDpLNt7x7nbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9RhM5iK0r8xHkGx3OZf/Mu2MGBvigaL64drccF2lQf/AdXCPX2xGiv1iUEhFZnXw
         I2NXtPwyYxOzVrcTLbtX5Fc5xUz4NGHOJIO2tXkYeu34T4CApTg9ACJQg+zUrgggCm
         pPf0ic4J2TV00rziBFwk59uAsjXHb78uZJcVkORg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Self <jason@bluehome.net>
Subject: [PATCH 4.14 01/19] HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option
Date:   Mon,  3 Jan 2022 15:21:18 +0100
Message-Id: <20220103142052.115671711@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
References: <20220103142052.068378906@linuxfoundation.org>
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
@@ -148,6 +148,7 @@ config HID_APPLEIR
 
 config HID_ASUS
 	tristate "Asus"
+	depends on USB_HID
 	depends on LEDS_CLASS
 	---help---
 	Support for Asus notebook built-in keyboard and touchpad via i2c, and


