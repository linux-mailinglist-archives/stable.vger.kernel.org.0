Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D6C41B5
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfJAUVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 16:21:49 -0400
Received: from www.linuxtv.org ([130.149.80.248]:49851 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfJAUVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 16:21:49 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iFOea-0006qO-03; Tue, 01 Oct 2019 20:21:48 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Tue, 01 Oct 2019 20:18:56 +0000
Subject: [git:media_tree/master] media: cec.h: CEC_OP_REC_FLAG_ values were swapped
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iFOea-0006qO-03@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cec.h: CEC_OP_REC_FLAG_ values were swapped
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Mon Sep 16 02:47:41 2019 -0300

CEC_OP_REC_FLAG_NOT_USED is 0 and CEC_OP_REC_FLAG_USED is 1, not the
other way around.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Jiunn Chang <c0d1n61at3@gmail.com>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 include/uapi/linux/cec.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index d8c04eb79d89..7a5d843af8c9 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -768,8 +768,8 @@ struct cec_event {
 #define CEC_MSG_SELECT_DIGITAL_SERVICE			0x93
 #define CEC_MSG_TUNER_DEVICE_STATUS			0x07
 /* Recording Flag Operand (rec_flag) */
-#define CEC_OP_REC_FLAG_USED				0
-#define CEC_OP_REC_FLAG_NOT_USED			1
+#define CEC_OP_REC_FLAG_NOT_USED			0
+#define CEC_OP_REC_FLAG_USED				1
 /* Tuner Display Info Operand (tuner_display_info) */
 #define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL		0
 #define CEC_OP_TUNER_DISPLAY_INFO_NONE			1
