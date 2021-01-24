Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60247301C40
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbhAXNeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:34:15 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37111 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbhAXNeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:34:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C36F5DF2;
        Sun, 24 Jan 2021 08:33:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aO6UfE
        iFHVRcs08RGidxlxg6zKViZ2iMzPFYbu46giE=; b=GoGZFt3kh5Q3SzKvaDDL6/
        ayovv6IFz3+XM93nndMcR0IRIPwepruankhGQSxMfm03PQS68+NgmD+QYl+SXSqc
        d9cCbKz4eQ57wfhmvLWup0cB+xEbFa2U/J0gjQbwjiX1MJl/cgjCjdZt4nL/0yCM
        UOSbWi1WVmW0FAnNyR0kN0ddQgD1EIqfikAt9WQA/Xp0rt1ETjyaN6UOQ52k4HwN
        pKPbMTv+hed1+Wqq2kUJKbndeL/Mb6Ts9gv3XgjVNlLOtd6wYVzMph5lKF4F51F1
        efdG8npptCjZmfOidYTfGIIbaLeelhbMB7+XoYr7Cu9EHnfffTiSoGsyi70UlsUQ
        ==
X-ME-Sender: <xms:FHcNYKanLQY9a8lOdB73_k6omvxsABmhD_rIVo69ISDeCC1qbjhk1g>
    <xme:FHcNYNahDW_Q-i2ECLmI-rBSb9yClD-UOYCta70k_cObyMcMvX2BlSFcBYk4vrCyk
    IZWYBzohFLDNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:FHcNYE-E3ETU3mLlf0-LhJb87n9DBLeq2YdsmZlfTzeKi_0E2980QQ>
    <xmx:FHcNYMq7ejCfWcrqArjVKq3-LVGyIhXYjFOZQCVJmunQC19mWDMlfA>
    <xmx:FHcNYFo1dW9ABaJAmpoFhCdLfNsRUd3-QoKelagDh3NRWoCQJbhhZg>
    <xmx:FHcNYGC2_S8Bxa7Z9wf8XV9zBDsDlzpBRm5HI9ihUXiiY6shWrwbNdl3P8w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0821F1080057;
        Sun, 24 Jan 2021 08:33:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu/pm: no need GPU status set since" failed to apply to 5.10-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:33:06 +0100
Message-ID: <161149518616731@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51e87da7d4014f49769dcf60b8626a81492df2c4 Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Thu, 17 Dec 2020 13:55:46 +0800
Subject: [PATCH] drm/amdgpu/pm: no need GPU status set since
 mmnbif_gpu_BIF_DOORBELL_FENCE_CNTL added in FSDL

In the renoir there is no need GpuChangeState message set to exit gfxoff in the s0i3 resume since
mmnbif_gpu_BIF_DOORBELL_FENCE_CNTL has been added in the s0i3 FSDL.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index f743685a20e8..9a9697038016 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -1121,7 +1121,7 @@ static ssize_t renoir_get_gpu_metrics(struct smu_context *smu,
 static int renoir_gfx_state_change_set(struct smu_context *smu, uint32_t state)
 {
 
-	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GpuChangeState, state, NULL);
+	return 0;
 }
 
 static const struct pptable_funcs renoir_ppt_funcs = {

