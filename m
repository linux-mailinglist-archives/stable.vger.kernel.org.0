Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87DF5AE9EB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbiIFNfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240617AbiIFNeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:34:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD2D79A50;
        Tue,  6 Sep 2022 06:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC16B816A0;
        Tue,  6 Sep 2022 13:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E406C433D6;
        Tue,  6 Sep 2022 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471203;
        bh=KInf7nXmZCQz9nRyt3phsKM3hc7mqdIKeVR71CKLHwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVrfV0Jb2VgJKc+t7juSfvDAniJcgdOW+2Wzi9yeL5UC5IQCBgAodBAI7GaxclFmc
         NoHN0j7LigxOjCO1i0vCTdWKzCWd8a9sDX6D/Uoan5Pt6nf/HBn1rgE1RO1pk5EOMG
         tE7XM/RBJYaaap48z9nKdHkaFweRIHqeZeHwvjhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/80] drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Tue,  6 Sep 2022 15:30:30 +0200
Message-Id: <20220906132818.357402519@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 233f56745be446b289edac2ba8184c09365c005e ]

There is a spelling mistake in a gvt_vgpu_err error message. Fix it.

Fixes: 695fbc08d80f ("drm/i915/gvt: replace the gvt_err with gvt_vgpu_err")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Zhi Wang <zhi.a.wang@intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220315202449.2952845-1-colin.i.king@gmail.com
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/handlers.c b/drivers/gpu/drm/i915/gvt/handlers.c
index 0b1ea29dcffac..606e6c315fe24 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -660,7 +660,7 @@ static int update_fdi_rx_iir_status(struct intel_vgpu *vgpu,
 	else if (FDI_RX_IMR_TO_PIPE(offset) != INVALID_INDEX)
 		index = FDI_RX_IMR_TO_PIPE(offset);
 	else {
-		gvt_vgpu_err("Unsupport registers %x\n", offset);
+		gvt_vgpu_err("Unsupported registers %x\n", offset);
 		return -EINVAL;
 	}
 
-- 
2.35.1



