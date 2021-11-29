Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF23461D7E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349796AbhK2SZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:25:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbhK2SXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:23:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5EC8B815B1;
        Mon, 29 Nov 2021 18:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5310C53FAD;
        Mon, 29 Nov 2021 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210001;
        bh=CjbY79dv2jU3xtUg5dUBCmMcEBoINte9RcrPnwcPROM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPTZvevQauN1g6fbl6qp5/7HuEukUaEnM7QhxLc4PbvvRKDi6OYtpy0nc39hLMCPR
         cJ6SiWpwCkjjIMHSSFbUhbseXzXq4TYQz25sXteE7freDGYwFhyoIcw+frLzTabxsW
         J3gu2PYmsgh5RxArpXqghq/+ks6QyO0Tnlyw7gYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 01/69] USB: serial: option: add Telit LE910S1 0x9200 composition
Date:   Mon, 29 Nov 2021 19:17:43 +0100
Message-Id: <20211129181703.718243576@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit e353f3e88720300c3d72f49a4bea54f42db1fa5e upstream.

Add the following Telit LE910S1 composition:

0x9200: tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20211119140319.10448-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1267,6 +1267,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */
+	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },


