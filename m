Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201DC5B73FD
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiIMPQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiIMPOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1601678BCA;
        Tue, 13 Sep 2022 07:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A2F8614CE;
        Tue, 13 Sep 2022 14:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41740C433D6;
        Tue, 13 Sep 2022 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079631;
        bh=vFvwAh1oiOsmNqlxm7mbIjC5CoxMOKLwzRwiX9I8R4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXVdYWVl1YV86FABIcnRV0kMHWrEJfnOsCrP1H3cy7hJw6ugIdtD56MFn8tVCQllv
         KFE/Pr1jrgetb+h6pBcvRWSB6iu5idwaBQAxF5zIWL57Th7pm6Rl0/vXyuxG4HbT3a
         xRjdin+fZeA6lTKgKUlnZ3BCxLAzlcLaXO+hRT5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/61] drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Tue, 13 Sep 2022 16:07:16 +0200
Message-Id: <20220913140347.227530651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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
index a5bed2e71b926..2a6c3004ff6d9 100644
--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -601,7 +601,7 @@ static int update_fdi_rx_iir_status(struct intel_vgpu *vgpu,
 	else if (FDI_RX_IMR_TO_PIPE(offset) != INVALID_INDEX)
 		index = FDI_RX_IMR_TO_PIPE(offset);
 	else {
-		gvt_vgpu_err("Unsupport registers %x\n", offset);
+		gvt_vgpu_err("Unsupported registers %x\n", offset);
 		return -EINVAL;
 	}
 
-- 
2.35.1



