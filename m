Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18887F67C9
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfKJGmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:47 -0500
Received: from www.linuxtv.org ([130.149.80.248]:55938 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfKJGmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:47 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvt-0004wd-8i; Sun, 10 Nov 2019 06:42:45 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 09 Nov 2019 08:07:02 +0000
Subject: [git:media_tree/master] media: vimc: sen: remove unused kthread_sen field
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvt-0004wd-8i@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: vimc: sen: remove unused kthread_sen field
Author:  Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Date:    Tue Nov 5 18:53:17 2019 +0100

The field kthread_sen in the vimc_sen_device is
not set and used. So remove the field and
the code that check if it is non NULL

Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/vimc/vimc-sensor.c | 5 -----
 1 file changed, 5 deletions(-)

---

diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 25ee89a067f7..32380f504591 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -18,7 +18,6 @@ struct vimc_sen_device {
 	struct vimc_ent_device ved;
 	struct v4l2_subdev sd;
 	struct tpg_data tpg;
-	struct task_struct *kthread_sen;
 	u8 *frame;
 	/* The active format */
 	struct v4l2_mbus_framefmt mbus_format;
@@ -202,10 +201,6 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 		const struct vimc_pix_map *vpix;
 		unsigned int frame_size;
 
-		if (vsen->kthread_sen)
-			/* tpg is already executing */
-			return 0;
-
 		/* Calculate the frame size */
 		vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
 		frame_size = vsen->mbus_format.width * vpix->bpp *
