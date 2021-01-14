Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9AA2F613E
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhANMsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 07:48:19 -0500
Received: from www.linuxtv.org ([130.149.80.248]:45012 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbhANMsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 07:48:18 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l022L-00Eilg-E7; Thu, 14 Jan 2021 12:47:37 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 14 Jan 2021 12:44:35 +0000
Subject: [git:media_tree/master] media: ir_toy: add another IR Droid device
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l022L-00Eilg-E7@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ir_toy: add another IR Droid device
Author:  Sean Young <sean@mess.org>
Date:    Sun Dec 27 14:45:01 2020 +0100

This device is also supported.

Cc: stable@vger.kernel.org
Tested-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Reported-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/ir_toy.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index e0242c9b6aeb..3e729a17b35f 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -491,6 +491,7 @@ static void irtoy_disconnect(struct usb_interface *intf)
 
 static const struct usb_device_id irtoy_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x04d8, 0xfd08, USB_CLASS_CDC_DATA) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x04d8, 0xf58b, USB_CLASS_CDC_DATA) },
 	{ }
 };
 
