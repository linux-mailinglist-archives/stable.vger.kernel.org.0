Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC985BA47C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392051AbfIVStI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392040AbfIVStI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED70E21D56;
        Sun, 22 Sep 2019 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178147;
        bh=rPaLg1m9winrfrc8LJ+1bVDOdUBp4c8jxgZhSx0iDT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB8Joz4K4LoULNQdKJT4IrWPJATfCZYbwn9kBLCm838Z+nL7LVuiX1CGWi+JeLmwp
         zneU8W5hyHIZWkDSl3aft7jGMHY4cGquHh35LqSc6o1St+9871WLgtyOFhvEQkLVeM
         GKtrRW4LkNjz+UziKNNBuF13oVgePfvhUr84Br+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?G=C3=B6ran=20Uddeborg?= <goeran@uddeborg.se>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 195/203] drm: fix module name in edid_firmware log message
Date:   Sun, 22 Sep 2019 14:43:41 -0400
Message-Id: <20190922184350.30563-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit ade925995b172f1d7410d1c665b2f47c5e99bef0 ]

The module is drm_kms_helper, not drm_kms_firmware.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204549
Reported-by: Göran Uddeborg <goeran@uddeborg.se>
Fixes: ac6c35a4d8c7 ("drm: add backwards compatibility support for drm_kms_helper.edid_firmware")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190821094312.5514-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_kms_helper_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_kms_helper_common.c b/drivers/gpu/drm/drm_kms_helper_common.c
index d9a5ac81949e2..221a8528c9937 100644
--- a/drivers/gpu/drm/drm_kms_helper_common.c
+++ b/drivers/gpu/drm/drm_kms_helper_common.c
@@ -40,7 +40,7 @@ MODULE_LICENSE("GPL and additional rights");
 /* Backward compatibility for drm_kms_helper.edid_firmware */
 static int edid_firmware_set(const char *val, const struct kernel_param *kp)
 {
-	DRM_NOTE("drm_kms_firmware.edid_firmware is deprecated, please use drm.edid_firmware instead.\n");
+	DRM_NOTE("drm_kms_helper.edid_firmware is deprecated, please use drm.edid_firmware instead.\n");
 
 	return __drm_set_edid_firmware_path(val);
 }
-- 
2.20.1

