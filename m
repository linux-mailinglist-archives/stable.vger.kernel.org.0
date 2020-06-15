Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B71F9BEE
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbgFOPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:25:05 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:49513 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728773AbgFOPZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:25:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 3EF84750;
        Mon, 15 Jun 2020 11:25:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jm1v+D
        bGfjAOdGKGNkpIuZUpu5sCsIbWhBIuDMQfdiw=; b=TgTlTJNKam84g4TBVFpirp
        FYJ9vZHVnsCQnVLmi4Be2YW7XyeYlh9+5F24qBTyi7vjjtYMs8l1L6TfMs3II5P6
        OwVBGz0uiSXcp50uripGbrSqLMkXDK+4YunXO9LIaso49K/h/XyT/TsTjpi3ug5W
        st8uNn64lw+KcwJY7QRjhLdAqb06RzQTN4ztNp+eWnExU6yjaeUXwknWU7fN4oqj
        1pgMUx6hsMIc6OarjPpaoLZqDCdrLR+YhPNd2V2zOzIy5ElJ7ov7ZYhmhJXiV2tQ
        wnE3+NltJEiOCXUq/7mRevr2Kw+ZGmBmwSdFNcNddv6GEW60PyRYXqZ8yoFLWMDg
        ==
X-ME-Sender: <xms:z5LnXmp2LwCMaBUq7NdHZaAhca9mqSKlvty24na6bCbU3iP2souLbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:z5LnXkrDRha8w2PrNI11F9vZOKR8-55q_XPR5jJP0US4aSAjMgOyag>
    <xmx:z5LnXrP6LTtlvZMqXWk2M-Mo6qcHz3cnsayZRYfapzmULXLM2EbU4g>
    <xmx:z5LnXl78tx27qo_RTe5mlp_PgQF658jpEpQD9-7dVjJn0xmFv4Mdew>
    <xmx:z5LnXmVV4HFPH5wwv5PWOMfAf_31jIo-eMRate2NM46j_HUEQ4BwTSFPlrU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18FC83280065;
        Mon, 15 Jun 2020 11:25:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: disable dcn20 abm feature for bring up" failed to apply to 5.4-stable tree
To:     hersenxs.wu@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:24:51 +0200
Message-ID: <159223469153162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96cb7cf13d8530099c256c053648ad576588c387 Mon Sep 17 00:00:00 2001
From: hersen wu <hersenxs.wu@amd.com>
Date: Thu, 28 Feb 2019 16:35:24 -0500
Subject: [PATCH] drm/amd/display: disable dcn20 abm feature for bring up

[WHY] dcn20 enable usb-c dp ALT mode in dmcu. There is bug
when enable abm feature which cause system crash. dal team
will debug this bug later.

[HOW] disable dcn abm feature for dcn20.

Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 5971aef4f033..72d14f680932 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -781,7 +781,7 @@ static int dm_late_init(void *handle)
 	unsigned int linear_lut[16];
 	int i;
 	struct dmcu *dmcu = adev->dm.dc->res_pool->dmcu;
-	bool ret;
+	bool ret = false;
 
 	for (i = 0; i < 16; i++)
 		linear_lut[i] = 0xFFFF * i / 15;
@@ -792,10 +792,13 @@ static int dm_late_init(void *handle)
 	params.backlight_lut_array_size = 16;
 	params.backlight_lut_array = linear_lut;
 
-	ret = dmcu_load_iram(dmcu, params);
+	/* todo will enable for navi10 */
+	if (adev->asic_type <= CHIP_RAVEN) {
+		ret = dmcu_load_iram(dmcu, params);
 
-	if (!ret)
-		return -EINVAL;
+		if (!ret)
+			return -EINVAL;
+	}
 
 	return detect_mst_link_for_all_connectors(adev->ddev);
 }

