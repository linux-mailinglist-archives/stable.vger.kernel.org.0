Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC302C640B
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgK0Lo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:44:26 -0500
Received: from www.linuxtv.org ([130.149.80.248]:54648 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgK0LoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 06:44:25 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kicAp-00CYaj-Pm; Fri, 27 Nov 2020 11:44:23 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 27 Nov 2020 07:12:11 +0000
Subject: [git:media_tree/master] media: msi2500: assign SPI bus number dynamically
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        syzbot+c60ddb60b685777d9d59@syzkaller.appspotmail.com,
        Antti Palosaari <crope@iki.fi>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kicAp-00CYaj-Pm@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: msi2500: assign SPI bus number dynamically
Author:  Antti Palosaari <crope@iki.fi>
Date:    Sat Aug 17 03:12:10 2019 +0200

SPI bus number must be assigned dynamically for each device, otherwise it
will crash when multiple devices are plugged to system.

Reported-and-tested-by: syzbot+c60ddb60b685777d9d59@syzkaller.appspotmail.com

Cc: stable@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/msi2500/msi2500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 269f3ef34bc9..63882a5248ae 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1230,7 +1230,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	}
 
 	dev->master = master;
-	master->bus_num = 0;
+	master->bus_num = -1;
 	master->num_chipselect = 1;
 	master->transfer_one_message = msi2500_transfer_one_message;
 	spi_master_set_devdata(master, dev);
