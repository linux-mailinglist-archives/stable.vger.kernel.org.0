Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313511F9BF0
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgFOPZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:25:13 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:44979 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728773AbgFOPZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:25:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 90B04340;
        Mon, 15 Jun 2020 11:25:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=x6RL8H
        9DhOTOmI4nRQq6l069jroLkQP4Tk6NLYoppDc=; b=HDlxEV0qR0xwgFVkuG2mKI
        yUL3bh6lpcYrs8TFP3wbIt3wEb1j849JolWbyD9FO8SFEYYawciXKCb6P1/IPdrK
        OlIhYq/PCvt0qHPlXdr6TwtZzSH72xCPpfAOo+ebn6lMSoO+bdLOLKO9gp+NtU54
        lBmYVLR+ovqjQxqSlPUQRwpQT2rBOUpPVaWAlHSNRqJDezgp0WulLTIaZuQedd2z
        pYM0GOhdPpfK9AH6zXyCaCL00ZXss3BaesGjqQfuj+2dp4i3/szY6K3sEsqmrxZR
        3/nSvZ1bGwzKu+bc3vPshjo2FYxDFl7o28/NFUMea5XT1fi9W27znL/ndjMVzaaQ
        ==
X-ME-Sender: <xms:2JLnXvuWi7yY4lKCA1trqBTyWuk67U2tSg0z6mWyC91LA912kzML9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2JLnXgfnbtJv4dmDcUs7t9HdZrLDCnqyc1pulHQJpuXGhabvH2c3mA>
    <xmx:2JLnXiwAnUAOIVvB6mmasfL-h-lWGqDKFWwZQ4pVOEtF4uqAhII1OQ>
    <xmx:2JLnXuMGdCbgLm4-rxFGfOO6kgp0G6NGudCRxFFd5wGNdkxUwpiAww>
    <xmx:2JLnXsJTkC5pnw57Zf9iLwuzxJRbLJGS0S5Lbh9PbxpJkrJLF3l1eA8kiV8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBA0E30614FA;
        Mon, 15 Jun 2020 11:25:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: disable dcn20 abm feature for bring up" failed to apply to 5.6-stable tree
To:     hersenxs.wu@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:24:51 +0200
Message-ID: <159223469188121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

