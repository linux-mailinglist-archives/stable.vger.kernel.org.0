Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30144EFDE
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfFUUKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 16:10:20 -0400
Received: from www.linuxtv.org ([130.149.80.248]:37165 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUUKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 16:10:20 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hePrW-000460-EA; Fri, 21 Jun 2019 20:10:18 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Wed, 22 May 2019 19:32:08 +0000
Subject: [git:media_tree/master] media: dvb: warning about dvb frequency limits produces too much noise
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hePrW-000460-EA@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dvb: warning about dvb frequency limits produces too much noise
Author:  Sean Young <sean@mess.org>
Date:    Mon May 20 15:43:49 2019 -0400

This can be a debug message. Favour dev_dbg() over dprintk() as this is
already used much more than dprintk().

dvb_frontend: dvb_frontend_get_frequency_limits: frequency interval: tuner: 45000000...860000000, frontend: 44250000...867250000

Fixes: 00ecd6bc7128 ("media: dvb_frontend: add debug message for frequency intervals")

Cc: <stable@vger.kernel.org> # 5.0
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fbdb4ecc7c50..7402c9834189 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -917,7 +917,7 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 			 fe->dvb->num, fe->id);
 
-	dprintk("frequency interval: tuner: %u...%u, frontend: %u...%u",
+	dev_dbg(fe->dvb->device, "frequency interval: tuner: %u...%u, frontend: %u...%u",
 		tuner_min, tuner_max, frontend_min, frontend_max);
 
 	/* If the standard is for satellite, convert frequencies to kHz */
