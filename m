Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4074A65D39B
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjADNBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjADNBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:01:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F251869E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D991B8162B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9119C433D2;
        Wed,  4 Jan 2023 13:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837280;
        bh=SQng/tvM74h8qAlHlSTDmrXSvEeskkhYRohvL2Y79kQ=;
        h=Subject:To:Cc:From:Date:From;
        b=2wLyC8oa6FSdkURPmIsGYjglIrbruk0bP2msPl+NlNSW8E49QCuzBdX8Q1eC1qXLK
         1R5bEXaNhjALqlzTRuXGrC+V/Z+sroQeD8lfSouTLHo3Xynn4EeOOJv3HVVib4byLn
         R4eo0+dUwzztrYFnlm6H/Py22GwU5sgy3zQCvqjQ=
Subject: FAILED: patch "[PATCH] media: s5p-mfc: Fix to handle reference queue during" failed to apply to 4.14-stable tree
To:     smitha.t@samsung.com, hverkuil-cisco@xs4all.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:01:08 +0100
Message-ID: <167283726819857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d8a46bc4e1e0 ("media: s5p-mfc: Fix to handle reference queue during finishing")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")
5f327f08192e ("dt-bindings: mtd: partitions: Add binding for Qcom SMEM parser")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8a46bc4e1e0446459daa77c4ce14218d32dacf9 Mon Sep 17 00:00:00 2001
From: Smitha T Murthy <smitha.t@samsung.com>
Date: Wed, 7 Sep 2022 16:02:27 +0530
Subject: [PATCH] media: s5p-mfc: Fix to handle reference queue during
 finishing

On receiving last buffer driver puts MFC to MFCINST_FINISHING state which
in turn skips transferring of frame from SRC to REF queue. This causes
driver to stop MFC encoding and last frame is lost.

This patch guarantees safe handling of frames during MFCINST_FINISHING and
correct clearing of workbit to avoid early stopping of encoding.

Fixes: af9357467810 ("[media] MFC: Add MFC 5.1 V4L2 driver")

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
index b65e506665af..f62703cebb77 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
@@ -1218,6 +1218,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned long mb_y_addr, mb_c_addr;
 	int slice_type;
 	unsigned int strm_size;
+	bool src_ready;
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
@@ -1257,7 +1258,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			}
 		}
 	}
-	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
+	if (ctx->src_queue_cnt > 0 && (ctx->state == MFCINST_RUNNING ||
+				       ctx->state == MFCINST_FINISHING)) {
 		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
 		if (mb_entry->flags & MFC_BUF_FLAG_USED) {
@@ -1288,7 +1290,13 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+
+	src_ready = true;
+	if (ctx->state == MFCINST_RUNNING && ctx->src_queue_cnt == 0)
+		src_ready = false;
+	if (ctx->state == MFCINST_FINISHING && ctx->ref_queue_cnt == 0)
+		src_ready = false;
+	if (!src_ready || ctx->dst_queue_cnt == 0)
 		clear_work_bit(ctx);
 
 	return 0;

