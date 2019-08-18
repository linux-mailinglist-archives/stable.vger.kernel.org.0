Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3529176E
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 17:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfHRPD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 11:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfHRPD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 11:03:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2463301A893;
        Sun, 18 Aug 2019 15:03:26 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-70.ams2.redhat.com [10.36.116.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52103871C8;
        Sun, 18 Aug 2019 15:03:25 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Brian Johnson <brijohn@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>
Subject: [PATCH] [media] sn9c20x: Add MSI MS-1039 laptop to flip_dmi_table
Date:   Sun, 18 Aug 2019 17:03:23 +0200
Message-Id: <20190818150323.292507-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sun, 18 Aug 2019 15:03:26 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Like a bunch of other MSI laptops the MS-1039 uses a 0c45:627b
SN9C201 + OV7660 webcam which is mounted upside down.

Add it to the sn9c20x flip_dmi_table to deal with this.

Cc: stable@vger.kernel.org
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/sn9c20x.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index b43f89fee6c1..700575757c86 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -123,6 +123,13 @@ static const struct dmi_system_id flip_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "0341")
 		}
 	},
+	{
+		.ident = "MSI MS-1039",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1039"),
+		}
+	},
 	{
 		.ident = "MSI MS-1632",
 		.matches = {
-- 
2.23.0.rc2

