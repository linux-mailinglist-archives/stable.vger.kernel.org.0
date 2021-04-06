Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB81A35545A
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243443AbhDFM56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:57:58 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54906 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243376AbhDFM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTlHA-00EYj0-VQ; Tue, 06 Apr 2021 12:57:48 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:51:21 +0000
Subject: [git:media_tree/master] media: venus: venc_ctrls: Change default header mode
To:     linuxtv-commits@linuxtv.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTlHA-00EYj0-VQ@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: venc_ctrls: Change default header mode
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Sat Mar 6 13:13:46 2021 +0100

It is observed that on Venus v1 the default header-mode is producing
a bitstream which is not playble. Change the default header-mode to
joined with 1st frame.

Fixes: 002c22bd360e ("media: venus: venc: set inband mode property to FW.")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/venc_ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/platform/qcom/venus/venc_ctrls.c b/drivers/media/platform/qcom/venus/venc_ctrls.c
index fa6324414339..e452acf285cf 100644
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -396,7 +396,7 @@ int venc_ctrl_init(struct venus_inst *inst)
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
 		~((1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) |
 		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME)),
-		V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
 
 	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
