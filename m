Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4659F4F47D7
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345533AbiDEVWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443844AbiDEPkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:40:22 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDB110E551;
        Tue,  5 Apr 2022 07:00:42 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k25-20020a056830151900b005b25d8588dbso9435680otp.4;
        Tue, 05 Apr 2022 07:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p9jy8faFTuQ229CsUYYE/yESsUOhyH54H367lXKP/jc=;
        b=cDGcXEj1ACMb9MBwy68J37LOy1ggap2IqVvA81jCA27h0z5w0r7mKXbCpBs4idhu/1
         ZtTD40OG8GcoH12DJGbCzWKY9ElTxQg7riArkSmqg9O5swlKUkj+U1EbOHQ8XDBK4pHd
         O1I0UjxHg+CLBaPcWlW7ZuXz7M2GZerFJfO0Puk3JvGGZkf47a1yEE0Uq3r/NMiwn1sc
         fXmr4+tNAOdFRYwjkNPv07928PVaIslfPLscMeJvl1o2tcwPIPJpITcMElbaKAURm9qI
         5sB4UQRnqlbfcxljVJZCvADtsJp9D6VPiM2n4Z9AOrumD/t0ydLv4wxrNpoI9uQ6R9WM
         osdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p9jy8faFTuQ229CsUYYE/yESsUOhyH54H367lXKP/jc=;
        b=diAm0dmZ/y5AlgCWe1TtbQvzQlMFyniwmG8nBCasWc6squjbY+pdDXtIHjaEEb8+/F
         GEuCHmqdAwxlH5BTnWgVQjxqlgVQUQrUps3DuO7yYl3M6lEaOgFiaOapLdy0nZI5Epo/
         ORp10tLPTXMVm3YuhYwxI6VvdSMPfTHG9Lz6eNcrzpa8vL5VADkSL2Jau13SQAMPsZuI
         6+tqOopzLEjMPXljgIlIeYfgeLuKHVN+m2nEzclB3jlj5qn0poVahuYlT+Jr+bvuDQ9Z
         /1AySVVT7UY0Xg6++C1nu3yNgtf1DyKL3VFbVF1CquVOUDbnLeKfHExsUPjhtDU3JhtY
         0Dng==
X-Gm-Message-State: AOAM533RCNokkga0gh0jCaQ4p68gTDS9hZIj5EQ2aXOudJeMiP5hCjf+
        c7s/lR3BDhuc3Lj30i3bt6g=
X-Google-Smtp-Source: ABdhPJy4GWCxgS5aTFC3lDqJc2TgeYOu9TUTpAVBGoGpTKfqMvF+94mvIJHGnijoX7dEq63BRbeTJA==
X-Received: by 2002:a9d:2927:0:b0:5b2:62f9:894c with SMTP id d36-20020a9d2927000000b005b262f9894cmr1223119otb.56.1649167241974;
        Tue, 05 Apr 2022 07:00:41 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:99d5:2af:ddde:2ce0])
        by smtp.gmail.com with ESMTPSA id c3-20020a056808138300b002f76b9a9ef6sm5537029oiw.10.2022.04.05.07.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 07:00:41 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     nicolas.dufresne@collabora.com, kernel@iktek.de,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v4 2/2] media: coda: Add more H264 levels for CODA960
Date:   Tue,  5 Apr 2022 10:59:57 -0300
Message-Id: <20220405135957.3580343-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405135957.3580343-1-festevam@gmail.com>
References: <20220405135957.3580343-1-festevam@gmail.com>
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
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
- Rebased against linux-next and took the coda->chips-media rename
in consideration.
- Added Philipp's Reviewed-by tag.

 drivers/media/platform/chips-media/coda-common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-common.c b/drivers/media/platform/chips-media/coda-common.c
index 53b2dd1b268c..f1234ad24f65 100644
--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
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

