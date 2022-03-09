Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471FE4D310A
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 15:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiCIOex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 09:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiCIOew (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 09:34:52 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467054090A;
        Wed,  9 Mar 2022 06:33:53 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id n7so2827623oif.5;
        Wed, 09 Mar 2022 06:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1b50c+WKpVTFCjWYgMcD8MnA9YQprdxUUGnxlUxFyE=;
        b=BKRmxwrg0l5+pesZjwKBN7gR0PtX03ClY+5YnxudE6AAywCh2WOm3qxMNGgc6SfNuR
         mmyqQmQXlTI2P0+E+792K13OOKTppudr0w9KPV4J2gW7/90i7vGdtvO59WfzbE2Z7fAy
         SsF892LQGts05rqHqhZEYxPST8/BPaf/sgpwgCgQK5lK6bepZxnH9CVeQAyniwrzHWxu
         BMRrsi9PQRC/FbLDOctXbxfoyCS7dzk0SsgadtXo3Ajw3N/jtf3QJUOhI8PBhmArQM7e
         W3B4bVY92UQF0U6VCuQHhZ4K10yPob1uyvPoSIyc+ZPTyFYrdBd6croFeVyWeLGiVxCH
         OPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1b50c+WKpVTFCjWYgMcD8MnA9YQprdxUUGnxlUxFyE=;
        b=gsJRAkcF1DLQlYlUxrkr5I3+pqQEUlnEd9jlkvVzJJgM/yIXgV762jeVkrjA9noAt1
         Kh8UnT9R8cv9+RJh95+XIrGEoTZTo4gq0tBfHmmYEeb4pOG8z/WNPZqfI8gkk03pjFJF
         VdFPNCqsFnXUl8MbytN5EvFOa+KhW5HnYGKr4nx2XgCwkbvgbNbgVKegbgo0FhuQiSlp
         a9MdJHe4+AtNHftjrvEhrLqS0DBfB0tpfnx++8M6L1NIBZQ0LtuGIVobNJNJvxM2CsGL
         vHSpwtwSJpmDAV34sqwk0hKmRCMWzHP2/Lz1ipXe2s7DhUkAHRgC6OGaHhqEfFi5YRVd
         HgJQ==
X-Gm-Message-State: AOAM533JNqGn69z9btJIFuEAI5LqbCoE91MH78G9MSJjhQNYzfMOgHyw
        MhWh7dNMAGIwqy/vQXWJulebgg3Jdn8=
X-Google-Smtp-Source: ABdhPJxeIFe9Xi1Na4kiR29mb6qrfjO4Eg25raZT4ZG4VYPTgeBFHwaiQlUdNpYlrEEsqbU/XL5EZA==
X-Received: by 2002:a05:6808:209e:b0:2da:4de9:e632 with SMTP id s30-20020a056808209e00b002da4de9e632mr301299oiw.214.1646836432626;
        Wed, 09 Mar 2022 06:33:52 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:9f7c:9178:2645:4362])
        by smtp.gmail.com with ESMTPSA id j25-20020a4ad199000000b003171dfeb5bfsm1007362oor.15.2022.03.09.06.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 06:33:52 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, ezequiel@collabora.com,
        kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2 2/2] media: coda: Add more H264 levels for CODA960
Date:   Wed,  9 Mar 2022 11:33:22 -0300
Message-Id: <20220309143322.1755281-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309143322.1755281-1-festevam@gmail.com>
References: <20220309143322.1755281-1-festevam@gmail.com>
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

This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
While the hardware does not fully support these levels, it do support
most of them. The constraints on frame size and pixel formats already
cover the limitation.

This fixes negotiation of level on GStreamer 1.17.1.

Cc: stable@vger.kernel.org
Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Pascal Speck <kernel@iktek.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- None - only added Pascal's Tested-by tag.

 drivers/media/platform/coda/coda-common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 53b2dd1b268c..f1234ad24f65 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2364,7 +2364,10 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
-			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_0)),
 			V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
 	}
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
@@ -2437,7 +2440,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
 	    ctx->dev->devtype->product == CODA_7541)
 		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
 	else if (ctx->dev->devtype->product == CODA_960)
-		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+		max = V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
 	else
 		return;
 	ctx->h264_level_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
-- 
2.25.1

