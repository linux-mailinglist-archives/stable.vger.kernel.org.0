Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25D5CDFAE
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfJGKwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:52:23 -0400
Received: from www.linuxtv.org ([130.149.80.248]:32900 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbfJGKwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 06:52:23 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iHQcn-0005mv-Ac; Mon, 07 Oct 2019 10:52:21 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Mon, 07 Oct 2019 10:32:11 +0000
Subject: [git:media_tree/master] media: rc: mark input device as pointing stick
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iHQcn-0005mv-Ac@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc: mark input device as pointing stick
Author:  Sean Young <sean@mess.org>
Date:    Sat Sep 28 17:46:14 2019 -0300

libinput refuses pointer movement from rc-core, since it believes it's not
a pointer-type device:

libinput error: event17 - Media Center Ed. eHome Infrared Remote Transceiver (1784:0008): libinput bug: REL_X/Y from a non-pointer device

Fixes: 158bc148a31e ("media: rc: mce_kbd: input events via rc-core's input device")
Fixes: 0ac5a603a732 ("media: rc: imon: report mouse events using rc-core's input device")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/rc/rc-main.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 13da4c5c7d17..7741151606ef 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1773,6 +1773,7 @@ static int rc_prepare_rx_device(struct rc_dev *dev)
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
 
 	/* Pointer/mouse events */
+	set_bit(INPUT_PROP_POINTING_STICK, dev->input_dev->propbit);
 	set_bit(EV_REL, dev->input_dev->evbit);
 	set_bit(REL_X, dev->input_dev->relbit);
 	set_bit(REL_Y, dev->input_dev->relbit);
