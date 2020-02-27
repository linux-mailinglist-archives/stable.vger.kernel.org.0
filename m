Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC501716F3
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgB0MTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:19:33 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42071 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728856AbgB0MTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 07:19:33 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 86429220CA;
        Thu, 27 Feb 2020 07:19:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 07:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OWbpxs
        uCQQLfl1G6G5epOXyI1Mst7vuqwr/uaBQnyu0=; b=BcVQKoP57uAYhqLsQVZWID
        pG/MA5H17+7C/Yy9L6TS95bCqCavIS6agAqiii1uu7DfYZt3FxwXoE8K6YUqx6WB
        jvIbvhBkahFCYD+Gri1q5JRuQW7v8zncbgvxcG/mVtnBEr3vE1BpeXK6Dpbtz4rU
        CWqClLF5LIdsRpGY7/Ar/vK8r1O3aCup2hnqsjnXVK2ZBArKYQoQkEnATaqNm1u0
        zUIHi44WNjdODz6O7yYcDCKe4Hza0r5x7C5t/ZYRvKvFVGjllaVqyTXuP61hKYK7
        FEaP/I8u6qTIptPvtO0lfcdHiru7BCqbjPnI8vdPsx+HafYKzpL1Jgk/ku6dHlEA
        ==
X-ME-Sender: <xms:07NXXporaCkkvKa4EPbgi0kn2W4KW3Iv0Kw3TWOQahayFe9SPwcUZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:07NXXkf6OHW4Si7Q2NDw-AtnEHYQFHMPx1oIHAwGxjjNVhxtq9V1ZA>
    <xmx:07NXXngLZAMspB1UtZzVDeNQzpXUKc7H4lsZP6gIcrTbapOZCBzopg>
    <xmx:07NXXqK2tZEqfyHQrwdttqtPS7CJ-cvSJpsTlFTj9610HVIVYrLhwA>
    <xmx:1LNXXhEj2Rtxcw-3272ZeeT-8D9_YWdq7U81hFSLTrRGy64uLMclbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3C723280064;
        Thu, 27 Feb 2020 07:19:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: fix dtm unloading" failed to apply to 5.5-stable tree
To:     Bhawanpreet.Lakha@amd.com, Feifei.Xu@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 13:19:29 +0100
Message-ID: <1582805969210220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c6f8c440441029d5621ee5153676243234a4b76e Mon Sep 17 00:00:00 2001
From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Date: Fri, 7 Feb 2020 10:41:20 -0500
Subject: [PATCH] drm/amd/display: fix dtm unloading

there was a type in the terminate command.

We should be calling psp_dtm_unload() instead of psp_hdcp_unload()

Fixes: 143f23053333 ("drm/amdgpu: psp DTM init")
Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 3a1570dafe34..146f96661b6b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1013,6 +1013,30 @@ static int psp_dtm_initialize(struct psp_context *psp)
 	return 0;
 }
 
+static int psp_dtm_unload(struct psp_context *psp)
+{
+	int ret;
+	struct psp_gfx_cmd_resp *cmd;
+
+	/*
+	 * TODO: bypass the unloading in sriov for now
+	 */
+	if (amdgpu_sriov_vf(psp->adev))
+		return 0;
+
+	cmd = kzalloc(sizeof(struct psp_gfx_cmd_resp), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	psp_prep_ta_unload_cmd_buf(cmd, psp->dtm_context.session_id);
+
+	ret = psp_cmd_submit_buf(psp, NULL, cmd, psp->fence_buf_mc_addr);
+
+	kfree(cmd);
+
+	return ret;
+}
+
 int psp_dtm_invoke(struct psp_context *psp, uint32_t ta_cmd_id)
 {
 	/*
@@ -1037,7 +1061,7 @@ static int psp_dtm_terminate(struct psp_context *psp)
 	if (!psp->dtm_context.dtm_initialized)
 		return 0;
 
-	ret = psp_hdcp_unload(psp);
+	ret = psp_dtm_unload(psp);
 	if (ret)
 		return ret;
 

