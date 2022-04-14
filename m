Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0227D5018BE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiDNQfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiDNQe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 12:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79AE483BF
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 09:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E10B829E1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E73C385A9;
        Thu, 14 Apr 2022 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649952242;
        bh=j+m3jK5wnuiKVTUH+FfeKvea8JjVtNiRGjXjTkybUiQ=;
        h=Subject:To:From:Date:From;
        b=Z9Vqt4nO7L2E1zmH6DtFf9Onn+KNioQ9KOrQeYUznTyXgGAf9vwG0IdA5nmUKv/uX
         wRwYhhBjpun4BP4uX9Nyj1pw5oNVaSAYJu+5T8DABiriaHhXegTGlwL1e1ILlIH6zT
         kPG3OlnVL0aJ2KTFW6gOAKV3PJ0AZNaJmoypA444=
Subject: patch "USB: quirks: add a Realtek card reader" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 Apr 2022 18:03:59 +0200
Message-ID: <1649952239121122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: add a Realtek card reader

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2a7ccf6bb6f147f64c025ad68f4255d8e1e0ce6d Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 14 Apr 2022 13:02:09 +0200
Subject: USB: quirks: add a Realtek card reader

This device is reported to stall when enummerated.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20220414110209.30924-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index d3c14b5ed4a1..8ce8c0d06c66 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -404,6 +404,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Realtek Semiconductor Corp. Mass Storage Device (Multicard Reader)*/
+	{ USB_DEVICE(0x0bda, 0x0151), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* Realtek hub in Dell WD19 (Type-C) */
 	{ USB_DEVICE(0x0bda, 0x0487), .driver_info = USB_QUIRK_NO_LPM },
 
-- 
2.35.2


