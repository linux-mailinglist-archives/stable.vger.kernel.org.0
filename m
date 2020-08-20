Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A138224B124
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgHTIeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:34:06 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52199 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgHTIeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:34:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 60639194008D;
        Thu, 20 Aug 2020 04:34:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=urPG+3
        fERiE/IKlSLSfZ8LthLQahgOMxIYW+w1jv4gg=; b=JI1LhUw/ModMb5WFQMLjwu
        tfGUsqc/egwHYmDNTgMHklKbhJwhGGtMdXeESlVEGUV4ByNRpL10FViK+kJM8mlK
        GvlIfQd9VctVe6t02/Ux+uk6Ep3zG+iDr1Vp3nUX7U5jO8aYrcdO1Dw7jAGT7alJ
        vGnHCPp3zB5NysG84b0gV6JxR8klo0ZAKb5CrxFLsJMKfTxTSz9oKrL3Fvk5F/Xk
        UztyPX33g1fKQ93yFTe04C2s7dfvI7CIYaY4yWh9Na+GpvsO+rW4C7cDuHWZR3Kn
        FU1+cFPq+dZe1a8x4oFdbGw7f7RiB+mZS9H+HyO2HhZqhE4v7nIa3AWgFeRUd4nQ
        ==
X-ME-Sender: <xms:fDU-X5N4_lHIfFmuPQ5OmiYUlNX20XHJ6qSlOwXLOlpWFBOgti1XKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:fDU-X7-EJ3OxE9by0KTuLOfYP9yE9hVDPHNkVddNPCxZna9hPkrH9w>
    <xmx:fDU-X4R3i4IiOpkOGvR0Cxu_S9R0ZaAX2pob1DCU7xY9kwLgfOXXsQ>
    <xmx:fDU-X1vnVc14NrLmxTkOdROMibTOj4sUKrKb0o6czvmtMvqM-27QDw>
    <xmx:fDU-XxFjQuMuNoP4CWe38zBHP8c5BGgEzWTMQAj0F5KdRYzGg0ylPw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 006A0328005A;
        Thu, 20 Aug 2020 04:34:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: OLED panel backlight adjust not work with" failed to apply to 5.8-stable tree
To:     hersenxs.wu@amd.com, Nicholas.Kazlauskas@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:34:26 +0200
Message-ID: <159791246617317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec11fe3705a7d434ec3493bdaddb9b6367e7366a Mon Sep 17 00:00:00 2001
From: hersen wu <hersenxs.wu@amd.com>
Date: Mon, 22 Jun 2020 13:29:16 -0400
Subject: [PATCH] drm/amd/display: OLED panel backlight adjust not work with
 external display connected

[Why]
amdgpu_dm->backlight_caps is for single eDP only. the caps are upddated
for very connector. Real eDP caps will be overwritten by other external
display. For OLED panel, caps->aux_support is set to 1 for OLED pnael.
after external connected, caps+.aux_support is set to 0. This causes
OLED backlight adjustment not work.

[How]
within update_conector_ext_caps, backlight caps will be updated only for
eDP connector.

Cc: stable@vger.kernel.org
Signed-off-by: hersen wu <hersenxs.wu@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6f937e25a62c..9c283531e1a2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2028,6 +2028,7 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	struct amdgpu_display_manager *dm;
 	struct drm_connector *conn_base;
 	struct amdgpu_device *adev;
+	struct dc_link *link = NULL;
 	static const u8 pre_computed_values[] = {
 		50, 51, 52, 53, 55, 56, 57, 58, 59, 61, 62, 63, 65, 66, 68, 69,
 		71, 72, 74, 75, 77, 79, 81, 82, 84, 86, 88, 90, 92, 94, 96, 98};
@@ -2035,6 +2036,10 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 	if (!aconnector || !aconnector->dc_link)
 		return;
 
+	link = aconnector->dc_link;
+	if (link->connector_signal != SIGNAL_TYPE_EDP)
+		return;
+
 	conn_base = &aconnector->base;
 	adev = conn_base->dev->dev_private;
 	dm = &adev->dm;

