Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C3C593691
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbiHOS6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244960AbiHOS4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220AE2A72C;
        Mon, 15 Aug 2022 11:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B244461041;
        Mon, 15 Aug 2022 18:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C01C433C1;
        Mon, 15 Aug 2022 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588259;
        bh=OCR+DclVKf0xQJ9S7RLXh1tW8XReanFojT84UmrK5oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI8ZirHpeEuSqDj+nWLJJmK0GKhT+KTqt38qLsZFEkT36BnJp4TGDPAP3rRxzcRo9
         uaKi62b2/n2JA195YRVIAn0aBTrFV+0r6L6p5MfYYLHAPkM/jat23kF3mPZh3sRyRW
         4WJuNYhIFbELw+44fOFZtCm2ZNHctA6MokthvZOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/779] media: staging: media: hantro: Fix typos
Date:   Mon, 15 Aug 2022 19:59:49 +0200
Message-Id: <20220815180351.985437656@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 87086f5c5495..bcdfa359de7f 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -413,7 +413,7 @@ static int set_ref(struct hantro_ctx *ctx)
 
 	set_ref_pic_list(ctx);
 
-	/* We will only keep the references picture that are still used */
+	/* We will only keep the reference pictures that are still used */
 	ctx->hevc_dec.ref_bufs_used = 0;
 
 	/* Set up addresses of DPB buffers */
diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index 5347f5a41c2a..7ce98a2b1655 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -98,7 +98,7 @@ dma_addr_t hantro_hevc_get_ref_buf(struct hantro_ctx *ctx,
 	struct hantro_hevc_dec_hw_ctx *hevc_dec = &ctx->hevc_dec;
 	int i;
 
-	/* Find the reference buffer in already know ones */
+	/* Find the reference buffer in already known ones */
 	for (i = 0;  i < NUM_REF_PICTURES; i++) {
 		if (hevc_dec->ref_bufs_poc[i] == poc) {
 			hevc_dec->ref_bufs_used |= 1 << i;
-- 
2.35.1



