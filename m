Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA194D3809
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiCIRiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiCIRht (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:37:49 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52EA101F05;
        Wed,  9 Mar 2022 09:36:49 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 17-20020a9d0611000000b005b251571643so2277163otn.2;
        Wed, 09 Mar 2022 09:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOmGz3bt6vb4hFgw3uud8EFYKeOnqhNNOTXYfsPbvM8=;
        b=kXKOJmI/+7SU2IuaZRT7arv9r6+bXJEoLbKMxk/7U1plsL9U2xEvqon6DFE8nmJLsL
         WvM5uhmaiSskJ52iRxNympVi7G4iD1uoZigDk5ySkWDvmI2mQx3xaNK0UUgCvCkrdFQX
         C2estlXvyz7FC4YSuDp+keLDortAWBA+oicqyZXZyw6l+cw0SOc6FnTRD79gxAP5/mOp
         f7XwoHlCqyF2ifiXoRujt2dWsNAZ4DoxmOLiPmn2xum5+ubl+kNN5b5SaH54jGkBa0D5
         L1c2+c9PHg8JPW/ZeiSSUOy1O2pwwtlhvDeK1rYi/ZLmYLAFyklJVy/RnaP+RCiVpQTH
         YcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOmGz3bt6vb4hFgw3uud8EFYKeOnqhNNOTXYfsPbvM8=;
        b=IKY7lSrw5zdFAEbWluXNHQ25nzCZ0c5A/wHKgeLHkyxPghBym3ouq3PEnTP8MWbCgP
         ix58LYLw10JhXxOfv4bmefi0208/WW2DB58Rgpq5XXW+YZFIKN993yTJfkscM2A+RqyA
         rmaHW5yCKSp7/XMpCJUgZFFcWAFZdCa7pTnv5xiLv+ReJIFdmeVa/gniDTucGriAYKwk
         XSBJzqbdnLO8fbqC2qMAprCrHtgt0NEUzvJ/Ajw0ZpuNys4rTRzSMPDsq/tJQS0SCOq5
         XdEQwJfZdxthfO/VWYeHElRR/ruGJREHbK+TrOHyeIJ4xNQ5KYg6Rx62OztPz1GocM1X
         aLfw==
X-Gm-Message-State: AOAM5306WLQI4IQJVr4sw3aAEZSdTbzf8dqeivjBrjqE6nXT6M1xHBR3
        OEkAzkMBMs2m3TSTw8f5S9LZUPIbD48=
X-Google-Smtp-Source: ABdhPJwS4GrbmBgJ4g6TnaE+fn43IecLtUbN0HG7b3PjvdCVu0tBrYWcroJE/vtS77WcKDdU4VGAtA==
X-Received: by 2002:a05:6830:2012:b0:5b2:4a95:2281 with SMTP id e18-20020a056830201200b005b24a952281mr440571otp.47.1646847409248;
        Wed, 09 Mar 2022 09:36:49 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:34e1:d0f:6368:c8ce])
        by smtp.gmail.com with ESMTPSA id o17-20020a9d5c11000000b005b2611a13edsm1220891otk.61.2022.03.09.09.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:36:48 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, ezequiel@collabora.com,
        kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v3 2/2] media: coda: Add more H264 levels for CODA960
Date:   Wed,  9 Mar 2022 14:36:36 -0300
Message-Id: <20220309173636.1879419-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309173636.1879419-1-festevam@gmail.com>
References: <20220309173636.1879419-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Add H264 level 1.0, 4.1, 4.2 to the list of supported formats.
While the hardware does not fully support these levels, it does support
most of them. The constraints on frame size and pixel formats already
cover the limitation.

This fixes negotiation of level on GStreamer 1.17.1.

Cc: stable@vger.kernel.org
Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v2:
- Remove 5.0 level and use Phillip's suggestion to get the correct levels
being reported by v4l2h264enc:

                     h264_level 0x00990a67 (menu)   : min=0 max=13 default=11 value=11
				0: 1
				5: 2
				8: 3
				9: 3.1
				10: 3.2
				11: 4
				12: 4.1
				13: 4.2

 drivers/media/platform/coda/coda-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 280d77f1567c..da8bc1f87ba0 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2349,12 +2349,15 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 	if (ctx->dev->devtype->product == CODA_960) {
 		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_H264_LEVEL,
-			V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
-			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
+			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_1_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
-			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2)),
 			V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
 	}
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-- 
2.25.1

