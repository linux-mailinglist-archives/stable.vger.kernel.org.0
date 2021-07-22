Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37283D1E31
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 08:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhGVFn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 01:43:28 -0400
Received: from www.linuxtv.org ([130.149.80.248]:40638 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhGVFn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 01:43:27 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1m6S7m-000C7U-2b; Thu, 22 Jul 2021 06:24:02 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 22 Jul 2021 06:19:17 +0000
Subject: [git:media_stage/master] media: rc-loopback: return number of emitters rather than error
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1m6S7m-000C7U-2b@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc-loopback: return number of emitters rather than error
Author:  Sean Young <sean@mess.org>
Date:    Sat Jul 3 15:37:17 2021 +0200

The LIRC_SET_TRANSMITTER_MASK ioctl should return the number of emitters
if an invalid list was set.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/rc-loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 1ba3f96ffa7d..40ab66c850f2 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -42,7 +42,7 @@ static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);
