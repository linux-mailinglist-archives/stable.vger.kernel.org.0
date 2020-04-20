Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327BE1B0A2F
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgDTMpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgDTMpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27E6222202;
        Mon, 20 Apr 2020 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386733;
        bh=Sf4Vh/rSwyKRWT01j6WPSw7LFC92TStfAQekuw4H//Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbfY4Auaf9+mEA0y2Tlc7DTE/eIPXrsgOZK2N6I/dcTUgUjmAcwlH5/ivzFL0POTV
         XJEyiwnBP2qA2gmkbfqGAhhV3gNY57ndwApD04QVRBbQ39CJQZmfwWVbuKcXnl9bQC
         QfHVSgEVWcQi5K1SvMRagYPhzGyykS1TK+PeQjeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.6 62/71] drm/nouveau/sec2/gv100-: add missing MODULE_FIRMWARE()
Date:   Mon, 20 Apr 2020 14:39:16 +0200
Message-Id: <20200420121521.357918260@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit 92f673a12d14b5393138d2b1cfeb41d72b47362d upstream.

ASB was failing to load on Turing GPUs when firmware is being loaded
from initramfs, leaving the GPU in an odd state and causing suspend/
resume to fail.

Add missing MODULE_FIRMWARE() lines for initramfs generators.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: <stable@vger.kernel.org> # 5.6
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/engine/sec2/gp108.c |    3 +++
 drivers/gpu/drm/nouveau/nvkm/engine/sec2/tu102.c |   16 ++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/sec2/gp108.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/sec2/gp108.c
@@ -25,6 +25,9 @@
 MODULE_FIRMWARE("nvidia/gp108/sec2/desc.bin");
 MODULE_FIRMWARE("nvidia/gp108/sec2/image.bin");
 MODULE_FIRMWARE("nvidia/gp108/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/gv100/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/gv100/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/gv100/sec2/sig.bin");
 
 static const struct nvkm_sec2_fwif
 gp108_sec2_fwif[] = {
--- a/drivers/gpu/drm/nouveau/nvkm/engine/sec2/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/sec2/tu102.c
@@ -56,6 +56,22 @@ tu102_sec2_nofw(struct nvkm_sec2 *sec2,
 	return 0;
 }
 
+MODULE_FIRMWARE("nvidia/tu102/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/tu102/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/tu102/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/tu104/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/tu104/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/tu104/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/tu106/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/tu106/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/tu106/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/tu116/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/tu116/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/tu116/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/tu117/sec2/desc.bin");
+MODULE_FIRMWARE("nvidia/tu117/sec2/image.bin");
+MODULE_FIRMWARE("nvidia/tu117/sec2/sig.bin");
+
 static const struct nvkm_sec2_fwif
 tu102_sec2_fwif[] = {
 	{  0, gp102_sec2_load, &tu102_sec2, &gp102_sec2_acr_1 },


