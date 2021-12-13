Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6541472861
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbhLMKLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242865AbhLMKI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04DC08EA7D;
        Mon, 13 Dec 2021 01:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 333C4CE0DEF;
        Mon, 13 Dec 2021 09:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F99C341C5;
        Mon, 13 Dec 2021 09:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389210;
        bh=4lE5xyDfBdAx1IuPMURO1h/W4wXJYI6g7u7ER7nwqzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcXubCeP93WBz9AdEf9KQkoEY4vs8po0YOJCHjuZd1eLcNq//OhA5dbtPypihsRQn
         upg2h4aapa5GPq6PUE26A6SYU8Xqtc4Y3RBFfhrPcuNyiE/tptpaRHu8CVp6cNTtsc
         9n6bQuwSfryqDfFhBjFKZLpagCLxxsrFaVW8yGvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 003/171] HID: google: add eel USB id
Date:   Mon, 13 Dec 2021 10:28:38 +0100
Message-Id: <20211213092945.206256559@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>

commit caff009098e6cf59fd6ac21c3a3befcc854978b4 upstream.

Add one additional hammer-like device.

Signed-off-by: xiazhengqiao <xiazhengqiao@huaqin.corp-partner.google.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211203030119.28612-1-xiazhengqiao@huaqin.corp-partner.google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-google-hammer.c |    2 ++
 drivers/hid/hid-ids.h           |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -586,6 +586,8 @@ static const struct hid_device_id hammer
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_DON) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_EEL) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_HAMMER) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MAGNEMITE) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -496,6 +496,7 @@
 #define USB_DEVICE_ID_GOOGLE_MAGNEMITE	0x503d
 #define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
 #define USB_DEVICE_ID_GOOGLE_DON	0x5050
+#define USB_DEVICE_ID_GOOGLE_EEL	0x5057
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f


