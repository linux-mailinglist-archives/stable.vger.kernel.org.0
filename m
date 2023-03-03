Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCB6AA1CD
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjCCVnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjCCVmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:42:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D67964276;
        Fri,  3 Mar 2023 13:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E56A0B819F7;
        Fri,  3 Mar 2023 21:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2813C43321;
        Fri,  3 Mar 2023 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879708;
        bh=0ykQITa9rK+UFQlUR4IjVhVNgB3E0ll98TQEFCA0pm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbeJtqEysA9RPZjsOshNgASML6OrBEtzo7+gQr4sZEmi8zLdf0KZ8XjVAbDircXvb
         O4oKDGLkJlC8hq55AfKLdYG5wOvZLkGI2X9WTAPepCQrUg6QM9+CmoH4vgVi6UvHh4
         Bwj3eGybd8ToWtQtGS07Jn56fCD9re+lqMmU7VvY0hBz1xs5Oz9F+457gSgVLcPv1a
         hmoQtNOzlku9Fm36um7bdPpvMZcupOAsYnzaPnDgyu5syfFLYXE79XhKPeyBS+tU3O
         X+crT5B/SmEt/4DLOachVrxmstxFO7U5y9gUo55WOkhbEpRUUos24Z0PGSdyH8Yw/V
         M2AYRP66kc/TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, elder@linaro.org,
        gregkh@linuxfoundation.org, mhi@lists.linux.dev,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 21/64] bus: mhi: ep: Fix the debug message for MHI_PKT_TYPE_RESET_CHAN_CMD cmd
Date:   Fri,  3 Mar 2023 16:40:23 -0500
Message-Id: <20230303214106.1446460-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 8e697fcfdb9809634e268058ca743369c216b7ac ]

The debug log incorrectly mentions that STOP command is received instead of
RESET command. Fix that.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 1dc8a3557a464..8ffaf9c6e61d9 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -217,7 +217,7 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 		mutex_unlock(&mhi_chan->lock);
 		break;
 	case MHI_PKT_TYPE_RESET_CHAN_CMD:
-		dev_dbg(dev, "Received STOP command for channel (%u)\n", ch_id);
+		dev_dbg(dev, "Received RESET command for channel (%u)\n", ch_id);
 		if (!ch_ring->started) {
 			dev_err(dev, "Channel (%u) not opened\n", ch_id);
 			return -ENODEV;
-- 
2.39.2

