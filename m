Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDE470ED
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfFOPbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:31:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57835 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbfFOPbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:31:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AAD40217DD;
        Sat, 15 Jun 2019 11:31:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l3vamm
        Us6keExPiB3hDq8ZYuTx+Up0nRkOXDFOwxXBM=; b=FCTRQEzJ7bA5AQiIdX9gxn
        GAyfvYbqACt9PldFOrwFMQQ7mjcJGNkK9cR8kHV6iCZjNQ+2cDa9iFl9r3wrMX2K
        raPpbktDtkCrKdMHNf6JIn8hhAwPCroqmyRroBdbEdGMjH1kt87PNbyWBYUtlom3
        951MLAB+5RgcrZOlYgIILVnsL3jFI2B3Q/U5d0X70Ci60immsuRYDelePMmInqoV
        czH4LT61K7JFNz3oy7f79iae3kmoojJHnwdAL63ZJzBYZuaE73QxZHTVZ5b7Tlrc
        m1AC2l1/vM2ShUqHYIkHyqL9sYwekQntBRND7I9a/7wi+TXKRbWAzBcUhiU8AHLg
        ==
X-ME-Sender: <xms:YA8FXTKQ4YFpSqJjaVZJ1qujNfHZQ0Ks6oHy8G8EM6qd3fdI4o9NKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:YA8FXc6Z-3Gg3r6h9ZhI7EP2eDVI0f_LD8xY65VgRuuAkkzCQsgPsQ>
    <xmx:YA8FXZzfOt5kLpa_yrt1zbw73vc9AFVjDD8EmffPrPbAYpJZIh41Fg>
    <xmx:YA8FXW9E2_imRWfREVaD8-6uml7sEYYjbTnF6ORp3jSp6hHgPw_9dw>
    <xmx:YA8FXfDf4yuVL3_WEfkZwmLR02U-SR8bEkAXahaX86EnXHmbA_2iuA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 254AD380085;
        Sat, 15 Jun 2019 11:31:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser" failed to apply to 4.14-stable tree
To:     jason.gerecke@wacom.com, aaron.skomra@wacom.com,
        benjamin.tissoires@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 17:31:42 +0200
Message-ID: <1560612702110252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe7f8d73d1af19b678171170e4e5384deb57833d Mon Sep 17 00:00:00 2001
From: Jason Gerecke <jason.gerecke@wacom.com>
Date: Tue, 7 May 2019 11:53:20 -0700
Subject: [PATCH] HID: wacom: Send BTN_TOUCH in response to INTUOSP2_BT eraser
 contact

The Bluetooth reports from the 2nd-gen Intuos Pro have separate bits for
indicating if the tip or eraser is in contact with the tablet. At the
moment, only the tip contact bit controls the state of the BTN_TOUCH
event. This prevents the eraser from working as expected. This commit
changes the driver to send BTN_TOUCH whenever either the tip or eraser
contact bit is set.

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 613342bb9d6b..af62a630fee9 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1301,7 +1301,7 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 						 range ? frame[7] : wacom->features.distance_max);
 			}
 
-			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x09);
 			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
 			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 

