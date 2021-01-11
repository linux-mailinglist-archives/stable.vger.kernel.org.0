Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECEC2F0E9C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbhAKI6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:58:52 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56981 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbhAKI6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:58:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 35FBB195C39D;
        Mon, 11 Jan 2021 03:58:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:58:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4KZZaS
        ZZBlKunHtLBcAR28qYxQfWARjGBCL1sS6rSks=; b=Hbthg/MBKdH7+HWdTHZizQ
        kKgTrBaAjs+/8qJYKnH3IzeW+qDdVAQzuAr/Cs4ntyMhwBtcybHNjt17mhfTrt3e
        A3KJp7p518fA9qU88BNrEEWsdUhE0xQh85CpV8gKm/FV6PuFYlMUQUVVARL/pOcW
        VTAtBSJYGc00APVV1WnZy3dLsynVKHAuf9W/QSip46G1WND8j1KmRegxiBVZLQq/
        tHCD/SJtuy+aP15NBOYVBuRS9v7ru2rxnbLZMLWhSPROOHl2qtxY4CANGEgtB+oz
        eT9Gqo4zTAGx02nWtyXfg+MRf/5zh9JQMD3NpzpGpOOPYpaTtNmgonuhvSseLCkQ
        ==
X-ME-Sender: <xms:HhP8X2DxSoUL64FmDzbRyogS6FqEsRX2J0ohv_SekGpnx-UMXrz4Sg>
    <xme:HhP8XwgiOyL7qRdG84YbT8gFE2CNXp8pcM0RdON20Dnr6rGv0eh0iThoF6VKSC6T8
    PPx_BXUPHnnww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekiedtieejieejgfetfeehheektddtheeuteeggf
    eiudfhjeffvefhveehfeehheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhfrhgv
    vgguvghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:HhP8X5kFgfoY2C3S9D0X_2gnkP2INcnVWs5OYP1372hL8mpkOuNelA>
    <xmx:HhP8X0xE5q9-R8-SUqVEgzdX0dGpdNZ4w2UmM-NvDU65ilIVoq0uDQ>
    <xmx:HhP8X7Qgu-BrzbO0h0jzlvC6b6I9i53Wh7of6Tx9U17l_iTRgPXd4A>
    <xmx:HhP8X5PRuFBFu2O42_Wgyd6Rh-Vf07ANAzKGBuyl1v1rDf_Z6aSiug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D43EE108005B;
        Mon, 11 Jan 2021 03:58:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"" failed to apply to 5.10-stable tree
To:     alexander.deucher@amd.com, andre@tomt.net, harry.wentland@amd.com,
        nicholas.kazlauskas@amd.com, oleksandr@natalenko.name,
        stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:59:10 +0100
Message-ID: <1610355550144178@kroah.com>
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

From 5efc1f4b454c6179d35e7b0c3eda0ad5763a00fc Mon Sep 17 00:00:00 2001
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
index 3fb6baf9b0ba..146486071d01 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2386,8 +2386,7 @@ void amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
-			drm_connector_list_update(connector);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,

