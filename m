Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6667C30A3F5
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhBAJFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:05:36 -0500
Received: from www.linuxtv.org ([130.149.80.248]:41052 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232635AbhBAJFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 04:05:14 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l6V8B-005hge-QX; Mon, 01 Feb 2021 09:04:23 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 26 Jan 2021 18:16:27 +0000
Subject: [git:media_tree/master] media: hantro: Fix reset_raw_fmt initialization
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l6V8B-005hge-QX@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Fix reset_raw_fmt initialization
Author:  Ricardo Ribalda <ribalda@chromium.org>
Date:    Thu Jan 14 14:03:16 2021 +0100

raw_fmt->height in never initialized. But width in initialized twice.

Fixes: 88d06362d1d05 ("media: hantro: Refactor for V4L2 API spec compliancy")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/hantro/hantro_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/staging/media/hantro/hantro_v4l2.c b/drivers/staging/media/hantro/hantro_v4l2.c
index b668a82d40ad..f5fbdbc4ffdb 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -367,7 +367,7 @@ hantro_reset_raw_fmt(struct hantro_ctx *ctx)
 
 	hantro_reset_fmt(raw_fmt, raw_vpu_fmt);
 	raw_fmt->width = encoded_fmt->width;
-	raw_fmt->width = encoded_fmt->width;
+	raw_fmt->height = encoded_fmt->height;
 	if (ctx->is_encoder)
 		hantro_set_fmt_out(ctx, raw_fmt);
 	else
