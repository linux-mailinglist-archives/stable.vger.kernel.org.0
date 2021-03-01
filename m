Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09432327B81
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCAKFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:05:41 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58185 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231759AbhCAKDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:03:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 52F8F1940E58;
        Mon,  1 Mar 2021 05:02:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UYD8l/
        /MDMUSa6J104DeJyN1/dYvODwAT0duRf2mTr8=; b=E0TBlBJcdzgf1K6Dw+eOGd
        XMJx65/ScdaZ37GwkpPyfN04rGyF4MwnK939ARAEdNdXzsrYDbc168pPBSFhfmVk
        Z0ehMF1qXLc0T/+H9NHXAYYw57IfJTILVXbMBJfKcBh/Bu+jUQ80Zobo/bIw+rGg
        sjXuWSP3ekUpQ6WnMv4Ugaqb5TMW91/GubajNwc0K60LVfOt676m4MPkxc0+waSD
        FGxq5058ubUXl5rQyW6cVeARzS9wDwE8GNKmRwkgzyMIhoZdQx4lWt4dofES3pit
        WT4iM9eJnIEfgV5C/ylPg2+nkY8Ja1aBWuZod9sQfJO5XODt/NbVO4b+Ur/+lR6w
        ==
X-ME-Sender: <xms:tLs8YDiAAyZbz0UuSfaxqMpVFyShIJZfm0jIOoq4s0aTOIzENqe49w>
    <xme:tLs8YAAERmA1FuXxJQ2nPbvgqX1QwO-2-0KFDxj2OAEpHo8WHPdB8DUYdqDS1DE16
    j6LWhPzhFCneQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekiedtieejieejgfetfeehheektddtheeuteeggfeiud
    fhjeffvefhveehfeehheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhfrhgvvggu
    vghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrh
    fuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:tLs8YDEMyIyeu1nhd3ltZnOlnVUWOj8WtEm_ahce2T4ZpbCA-RKMLQ>
    <xmx:tLs8YASjMKzvr1krgGDC-uu9xPKKgQOR_z-JBr_vK1rHWEHtLgQS-w>
    <xmx:tLs8YAzFHv8b3PylSotCuh3hQo6iah7iDrWK1XZg-rPOu09CZ40qaQ>
    <xmx:tLs8YKuU7LYgWybJy6GjGIrq6sbz1ElcOEEWhAyDfMTEFdQ8TclRMg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00619240054;
        Mon,  1 Mar 2021 05:02:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"" failed to apply to 5.4-stable tree
To:     alexander.deucher@amd.com, andre@tomt.net, harry.wentland@amd.com,
        nicholas.kazlauskas@amd.com, oleksandr@natalenko.name,
        stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:02:17 +0100
Message-ID: <161459293740157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8768ff5efae35acea81b3f0c7db6a7ef519b0861 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 5 Jan 2021 11:42:08 -0500
Subject: [PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"

This reverts commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362.

This leads to blank screens on some boards after replugging a
display.  Revert until we understand the root cause and can
fix both the leak and the blank screen after replug.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211033
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1427
Cc: Stylon Wang <stylon.wang@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Andre Tomt <andre@tomt.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0d2e334be87a..318eb12f8de7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2385,8 +2385,7 @@ void amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
-			drm_connector_list_update(connector);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,

