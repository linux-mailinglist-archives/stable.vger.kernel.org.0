Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12441272EA5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgIUQvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgIUQu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF2F206DC;
        Mon, 21 Sep 2020 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707059;
        bh=AhN4QZWvk+lWeRI3C59MK5A0TKBlb9Ah+gcQ4bpwLoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUXoog5gYHPSvfvf71H48dMHjh2NUk/i9yF3ANm9Frw3ulHw9ZjMKKjTompCPg1NH
         yIXvb/UdQS0P2i5EboQnBJ6zpz4S7vy+pNF1Jt6RzeBJxvFtgrsFktxNlXEKRXLm+x
         H+ogcRvmm/Gs74kCxf3hN/3AOagJPn2mT5ysihbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Penghao <penghao@uniontech.com>
Subject: [PATCH 5.4 52/72] USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook
Date:   Mon, 21 Sep 2020 18:31:31 +0200
Message-Id: <20200921163124.355427005@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Penghao <penghao@uniontech.com>

commit bcea6dafeeef7d1a6a8320a249aabf981d63b881 upstream.

Add a USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for the BYD zhaoxin notebook.
This notebook come with usb touchpad. And we would like to disable
touchpad wakeup on this notebook by default.

Signed-off-by: Penghao <penghao@uniontech.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200907023026.28189-1-penghao@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -397,6 +397,10 @@ static const struct usb_device_id usb_qu
 	/* Generic RTL8153 based ethernet adapters */
 	{ USB_DEVICE(0x0bda, 0x8153), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* SONiX USB DEVICE Touchpad */
+	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },


