Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30E24F6CA0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiDFV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiDFV1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:27:44 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC8F33DC9C;
        Wed,  6 Apr 2022 13:24:02 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t21so3578387oie.11;
        Wed, 06 Apr 2022 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UsbI1bUf+oEzotxIP+Fs5/H08oH3yRAdv/ki6o157Es=;
        b=ccxnHQKij+OlcMfXfqKHSeZa3bCvcdW77WgeNF0pUY7TSAixSmhH/bMcO2deihTR/t
         ODmeuLfL+1wakaSzRSJB8t0js3Qb+3b/tEHxkyy2268QGHfOVAVUJcUJvZab7QjrYVTO
         4D40WeiCn+yBb1oD3pqlDqLS+HvNgI/z3SVp20g9T0t6bD3+SEXgjic4LImKDI//O5V2
         i5Yceiut2Vop8uT0WWmIDrRzZm01Oyf5Q7Oltv4yme6kj89C1Z/SeQbqCYQ+ZaWKxFW2
         ec8uYzQXrqotoZ4z7Zys3PLhgS5mbSdyZ+e5KciL0CnyPw0gGWvP2WPa2QcOx4doivCf
         Tdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsbI1bUf+oEzotxIP+Fs5/H08oH3yRAdv/ki6o157Es=;
        b=lYBm/JebmIMvk/4r4zdPVU1+sWX1CXsEFfupiYY+RRUKS4weDJt6S+NzXGlOK7yo+N
         ZKJkxR7eXrNv60ba9aWXERpUwLcx2WbaK08sCixnscP0SVUzRF7PJYtvasw8ARpRRrjX
         Z0cuyzdGBqw03fADP7Jmtma4kyhim+0OEmXMaJH56bcUq2PAbDvhHtPdeTUWJBnANx+J
         3kvcKCJWxKBuMiqna9MgQM/TNFK1QsB8RiUULaL//XhgjO1XYDbfxp6M1UT9OcbX89UI
         BLyof2+Bf8MFFkizs5JQUQqmWA3usGGIoImycmeMTV55v4ZOLprbgqEiv4mxBy/IHb32
         Ez2g==
X-Gm-Message-State: AOAM530cPqsDzRJ+5n/ZRLnYmBKEeryCyeDD9+ELN2pH8R3kUiB+ffbR
        OXiMuSAmTmxvcmPHmq7SDzE=
X-Google-Smtp-Source: ABdhPJxy9TY1jqeDcDbToGRVt8MIGo0iRLxgaXjdmOVkd3NI8heidpFzW828vD1Ytv+6nL/dq3If+A==
X-Received: by 2002:a05:6808:90d:b0:2ef:1f7e:3da2 with SMTP id w13-20020a056808090d00b002ef1f7e3da2mr4159039oih.196.1649276642236;
        Wed, 06 Apr 2022 13:24:02 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:d779:c3b1:bb03:19d1])
        by smtp.gmail.com with ESMTPSA id r23-20020a056830237700b005b2610517c8sm7497894oth.56.2022.04.06.13.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:24:01 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     nicolas.dufresne@collabora.com, kernel@iktek.de,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v5 2/2] media: coda: Add more H264 levels for CODA960
Date:   Wed,  6 Apr 2022 17:23:43 -0300
Message-Id: <20220406202343.139638-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220406202343.139638-1-festevam@gmail.com>
References: <20220406202343.139638-1-festevam@gmail.com>
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
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v4:
- Use the correct v3 for rebasing.

 drivers/media/platform/chips-media/coda-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-common.c b/drivers/media/platform/chips-media/coda-common.c
index 53b2dd1b268c..6d2989504b33 100644
--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -2359,12 +2359,15 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
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

