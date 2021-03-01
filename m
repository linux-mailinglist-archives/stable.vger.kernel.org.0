Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD90327B74
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhCAKDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:03:35 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36807 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhCAKDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:03:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6DF8B1940E31;
        Mon,  1 Mar 2021 05:02:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:02:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cRxbhO
        rl8Gh3RWVl3gKGWDWe/XmH/VmhYI04xrGLZ/w=; b=uvEHUY4OnnJj3hUllpuA34
        1VoKGR6nJvcxXvcaD81ZVChyJM/OweGDPFg7vV//jENnhHdlCP/sMpzq5uCq0FPv
        dpB/Yk0y1sD5/lJxwtj9h+yJeovEqiWrQjcmGfKB8+hqKwPzCT0pG5blezWFzM/h
        5MMzrIulxCjt0sNYyRxnwsLFcAUHg97BA4ImlcfKKMbZAtc8tq989W6KrmokHewf
        QMUM024gM1rzwLq161Nxbp0vY7RpZs6zuFyiARglV3d/TnWZmfoOQ3SejZE/nRlv
        NOxcwnNHu2C+5WbHvUHSge1PMmGWZ67GHP2b93a114qeCFktybVlVfJzUZKdk8Dw
        ==
X-ME-Sender: <xms:srs8YG-ZACjRMkgvWjm19s0z1kOY35KK-NhmV9Ny41tBqz9Kwf5yMg>
    <xme:srs8YGsqZY5YcitB1KsFVImwviDFwJsnA3VxsobOdd8ffT1anLpBAACy6-nZ8Jl_i
    V_lmwTGVA6-cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekiedtieejieejgfetfeehheektddtheeuteeggfeiud
    fhjeffvefhveehfeehheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhfrhgvvggu
    vghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:srs8YMCJM2Eo-Bsku4wrMflWD1CkoDXbRpAtRrD4HiSrLDivR9DEsw>
    <xmx:srs8YOeSl3J3dVdEbK8EUFHJsxkf6TDWaftYSXKOzdcKnJWgKEXK4w>
    <xmx:srs8YLPavPP0JM1L8ZCLy2fGydNB1qjVRHDeLLM6BXouFNy6hM3Z1w>
    <xmx:srs8YArNy3SuGj8vVOUkJO5T7do0g_leXw8KVOojcmrza7R8koJovQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E845B1080063;
        Mon,  1 Mar 2021 05:02:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"" failed to apply to 5.10-stable tree
To:     alexander.deucher@amd.com, andre@tomt.net, harry.wentland@amd.com,
        nicholas.kazlauskas@amd.com, oleksandr@natalenko.name,
        stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:02:16 +0100
Message-ID: <16145929369948@kroah.com>
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

