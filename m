Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E856A3DD9CB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHBOEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236295AbhHBOCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51BFA61107;
        Mon,  2 Aug 2021 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912609;
        bh=XK3Mw1yoiMEvsv70NE4Sy+IE10PN1+VV2hFZpME66iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iff0l+GwQSj0gujyEU4KXptfxn54vItkBCxmg7skjs29tepOwe83N5encLIAAiOHR
         R1GvY2Z2d07FlfM17c7YBX5/yUR2CEpsRoGRF4yifkxGCUNEyWjF8FSuI80EK/ed6t
         ui3DgnUJq4TWSjNHwVgeJXNwpgbp0czKNLBKUSlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 070/104] drm/msm/dpu: Fix sm8250_mdp register length
Date:   Mon,  2 Aug 2021 15:45:07 +0200
Message-Id: <20210802134346.310009990@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit b910a0206b59eb90ea8ff76d146f4c3156da61e9 ]

The downstream dts lists this value as 0x494, and not
0x45c.

Fixes: af776a3e1c30 ("drm/msm/dpu: add SM8250 to hw catalog")
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210628085033.9905-1-robert.foss@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index b569030a0847..2daf81f63076 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -268,7 +268,7 @@ static const struct dpu_mdp_cfg sc7180_mdp[] = {
 static const struct dpu_mdp_cfg sm8250_mdp[] = {
 	{
 	.name = "top_0", .id = MDP_TOP,
-	.base = 0x0, .len = 0x45C,
+	.base = 0x0, .len = 0x494,
 	.features = 0,
 	.highest_bank_bit = 0x3, /* TODO: 2 for LP_DDR4 */
 	.clk_ctrls[DPU_CLK_CTRL_VIG0] = {
-- 
2.30.2



