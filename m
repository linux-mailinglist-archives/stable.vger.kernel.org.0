Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4479D148
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfHZODg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 10:03:36 -0400
Received: from www.linuxtv.org ([130.149.80.248]:36237 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfHZODg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 10:03:36 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1i2Fao-0006Cp-OO; Mon, 26 Aug 2019 14:03:34 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Mon, 26 Aug 2019 13:43:20 +0000
Subject: [git:media_tree/master] media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Hans de Goede <hdegoede@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1i2Fao-0006Cp-OO@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
Author:  Hans de Goede <hdegoede@redhat.com>
Date:    Sun Aug 18 12:03:23 2019 -0300

Like a bunch of other MSI laptops the MS-1039 uses a 0c45:627b
SN9C201 + OV7660 webcam which is mounted upside down.

Add it to the sn9c20x flip_dmi_table to deal with this.

Cc: stable@vger.kernel.org
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/usb/gspca/sn9c20x.c | 7 +++++++
 1 file changed, 7 insertions(+)

---

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 12a2395a36ac..2a6d0a1265a7 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -124,6 +124,13 @@ static const struct dmi_system_id flip_dmi_table[] = {
 		}
 	},
 	{
+		.ident = "MSI MS-1039",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1039"),
+		}
+	},
+	{
 		.ident = "MSI MS-1632",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
