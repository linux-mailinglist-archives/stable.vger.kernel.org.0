Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29B66D1245
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 00:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjC3Wk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 18:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjC3Wk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 18:40:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4414CA29
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 15:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680215983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5KLRGaugo3bJYNHTNbGObcKYy+aEw9oHl8WJdhU1s28=;
        b=KPw3AoY/T9ZBgikGUmtAiG6/sukmUtzlTZea7Tk/WnbYZyzN9AAfeBLTJHlXL0jyyvWHuZ
        O9LLMuYeKRMPFPigCCh7OPiwiebz7CtFI6EEAcmWtvv93wxgHBg5aP5Q9IFW2eK7teVm1Z
        cv+mztZbuUpIdk19/onmKUXikUZLHb0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-WYJcRyLBNyyIZqF-5zzJ2Q-1; Thu, 30 Mar 2023 18:39:41 -0400
X-MC-Unique: WYJcRyLBNyyIZqF-5zzJ2Q-1
Received: by mail-ed1-f69.google.com with SMTP id t14-20020a056402240e00b004fb36e6d670so28907489eda.5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 15:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680215980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KLRGaugo3bJYNHTNbGObcKYy+aEw9oHl8WJdhU1s28=;
        b=fa2hf2kVclogAOCdEmHNU3KvUVX1ni1NrW6kjEwll1PsdB/EyyD/eGUiV+1w0AuI1x
         re/GN1FXEEut36AaJ4DbI9feWuSa0A36AdFTid2ugxRyq2hvfyzSQPYWXXUM6tZpfkEA
         IrQgYGy6sWHbX8ii8kCZLBGBC2tQSvYgin73IuSPsPiYrpCuEaKHZyb9i6o31v39KrUg
         lCPo3/E+M8YaUGWBfKHHREJKWH0TTbtVGvNmeHregXTxWvz+zCmxcndouMAYwD40bF2H
         TikQTy5wFVOttIjMpKadPX/gGHBTosjezFrUdxr1EBEpi8GHzJpVpBDXjkqNEqyENFTp
         hk+w==
X-Gm-Message-State: AAQBX9cZvDlu3p1nOqN0S1fuPzlv4TF4jeCD+UjwkGHdYr5PLZipHMcL
        a0J8Qh3OIQa0hjn9Bmx4yPjAbtgGIcJ4/SPsJRTfaXoCiLuGm5PS7aZ1DcQxUEWBHPL3T5VbTFJ
        rNH+6JT69DrIiNold
X-Received: by 2002:a17:906:297:b0:932:170:e07b with SMTP id 23-20020a170906029700b009320170e07bmr2716996ejf.7.1680215980591;
        Thu, 30 Mar 2023 15:39:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350YArwjRfAnCTrwT8vxsxel4wJik3BioMPfTSW1diiRfUzP7BNbx8CC8jIFESIUiLA6Oy1WH9w==
X-Received: by 2002:a17:906:297:b0:932:170:e07b with SMTP id 23-20020a170906029700b009320170e07bmr2716990ejf.7.1680215980283;
        Thu, 30 Mar 2023 15:39:40 -0700 (PDT)
Received: from kherbst.pingu (ip1f113ce7.dynamic.kabel-deutschland.de. [31.17.60.231])
        by smtp.gmail.com with ESMTPSA id t2-20020a1709061be200b00932b3e2c015sm288612ejg.51.2023.03.30.15.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 15:39:39 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drm/nouveau/disp: Support more modes by checking with lower bpc
Date:   Fri, 31 Mar 2023 00:39:38 +0200
Message-Id: <20230330223938.4025569-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This allows us to advertise more modes especially on HDR displays.

Fixes using 4K@60 modes on my TV and main display both using a HDMI to DP
adapter. Also fixes similiar issues for users running into this.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 32 +++++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_dp.c    |  8 ++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index ed9d374147b8d..f28e47c161dd9 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -363,6 +363,35 @@ nv50_outp_atomic_check_view(struct drm_encoder *encoder,
 	return 0;
 }
 
+static void
+nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_state *crtc_state)
+{
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
+	struct drm_display_mode *mode = &asyh->state.adjusted_mode;
+	unsigned int max_rate, mode_rate;
+
+	switch (nv_encoder->dcb->type) {
+	case DCB_OUTPUT_DP:
+		max_rate = nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
+
+                /* we don't support more than 10 anyway */
+		asyh->or.bpc = max_t(u8, asyh->or.bpc, 10);
+
+		/* reduce the bpc until it works out */
+		while (asyh->or.bpc > 6) {
+			mode_rate = DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
+			if (mode_rate <= max_rate)
+				break;
+
+			asyh->or.bpc -= 2;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 nv50_outp_atomic_check(struct drm_encoder *encoder,
 		       struct drm_crtc_state *crtc_state,
@@ -381,6 +410,9 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
 	if (crtc_state->mode_changed || crtc_state->connectors_changed)
 		asyh->or.bpc = connector->display_info.bpc;
 
+	/* We might have to reduce the bpc */
+	nv50_outp_atomic_fix_depth(encoder, crtc_state);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index e00876f92aeea..d49b4875fc3c9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -263,8 +263,6 @@ nouveau_dp_irq(struct work_struct *work)
 }
 
 /* TODO:
- * - Use the minimum possible BPC here, once we add support for the max bpc
- *   property.
  * - Validate against the DP caps advertised by the GPU (we don't check these
  *   yet)
  */
@@ -276,7 +274,11 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 {
 	const unsigned int min_clock = 25000;
 	unsigned int max_rate, mode_rate, ds_max_dotclock, clock = mode->clock;
-	const u8 bpp = connector->display_info.bpc * 3;
+	/* Check with the minmum bpc always, so we can advertise better modes.
+	 * In particlar not doing this causes modes to be dropped on HDR
+	 * displays as we might check with a bpc of 16 even.
+	 */
+	const u8 bpp = 6 * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
-- 
2.39.2

