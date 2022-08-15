Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7F4594130
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiHOVK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348039AbiHOVIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E1E2E691;
        Mon, 15 Aug 2022 12:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD945B8107A;
        Mon, 15 Aug 2022 19:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3656C433C1;
        Mon, 15 Aug 2022 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591074;
        bh=Wyzz/kX11fAf7yn4QudM02EmmHD4vOUHB5xDkUDigwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3WrSgvsx/pjV5teS6Gb4XU8eBvozrYaTTfOC6nHj3uWyLy+Qx8+f8w/Tx3MzuQZ9
         YmdWv18MYFSt5rpnXVqHSE6OTN/OPs5jFGqFW5H4VlGSIJ0lKaYA2dBiy8D+2UyJdg
         /Ffw9VZnuWjYwiGS+SQI9ZAIj9ByQTKiE1ZLJNu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0433/1095] media: staging: media: hantro: Fix typos
Date:   Mon, 15 Aug 2022 19:57:12 +0200
Message-Id: <20220815180447.594816922@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Fricke <sebastian.fricke@collabora.com>

[ Upstream commit d8f6f1c56d5469e22eeb7cc1f3580b29e2f0fef5 ]

Fix typos in comments within the Hantro driver.

Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c | 2 +-
 drivers/staging/media/hantro/hantro_hevc.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index 5f3178bac9c8..a4642ed1f463 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -401,7 +401,7 @@ static int set_ref(struct hantro_ctx *ctx)
 
 	set_ref_pic_list(ctx);
 
-	/* We will only keep the references picture that are still used */
+	/* We will only keep the reference pictures that are still used */
 	ctx->hevc_dec.ref_bufs_used = 0;
 
 	/* Set up addresses of DPB buffers */
diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index b49a41d7ae91..9c351f7fe6bd 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -59,7 +59,7 @@ dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx,
 	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
 	int i;
 
-	/* Find the reference buffer in already know ones */
+	/* Find the reference buffer in already known ones */
 	for (i = 0;  i < NUM_REF_PICTURES; i++) {
 		if (hevc_dec->ref_bufs_poc[i] == poc) {
 			hevc_dec->ref_bufs_used |= 1 << i;
-- 
2.35.1



