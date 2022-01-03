Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F12B48321D
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiACOZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55600 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiACOYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:24:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C987D610B1;
        Mon,  3 Jan 2022 14:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD608C36AEB;
        Mon,  3 Jan 2022 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219891;
        bh=lwj2r/vdy5EfWCyc7fU8IpKZOJHgY2+UDpLNt7x7nbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDEYT1MoK8A9iN8P3Rq7ERTQ4J4PKKUB8aOjvm5HWWuak7losUQzV7qe/GWmiLa8z
         HGbsKPhGe1jEgfqBb0oQezDYo8ewsFcWbEuGkqg8VPxvgSwqKdg3eFUVKP8uZG2VCs
         nPPuVZiQd2/UWonKt65X7ILL1I9q2qt63Lhltj9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Self <jason@bluehome.net>
Subject: [PATCH 4.19 01/27] HID: asus: Add depends on USB_HID to HID_ASUS Kconfig option
Date:   Mon,  3 Jan 2022 15:23:41 +0100
Message-Id: <20220103142052.218007981@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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


