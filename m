Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8870327B79
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhCAKE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:04:26 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52037 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231484AbhCAKD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:03:28 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6743B1940E42;
        Mon,  1 Mar 2021 05:02:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Mar 2021 05:02:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3GavoC
        VqM3qbnas7VH30HeHZ//m51nBfqZFk5H9v36g=; b=ITYoKV84mDM/PVEdz9v/6J
        NtlYAe7JwpXI1QZHNDQYQfL+CwY3jL5rmylq1/dBpqC7IVeW3tS3K9ohiXSYk1tF
        KB3wjI0/uq2gAqegf1q1+kH/EDB33yoA52thnc5j/wZMGfCqIyBUp1dpRERgpxmB
        NVXGijX+v+sABDmmhMzwo1jvllW9WQQz3Yt6d7qCwEELmQ4TUldgU5iuH5dZ7E/t
        FwKJ39cbagmH4CIDZj8WoFrIiNE0qBoGjvacXe2338dt6aWIubxZlrLur7h8PdT/
        9N8K5eu8JWFbeWz5gj5bu5p3kYTUngrPqHE8UNvUjUdebFjtq8Yw8wdE2FAkCfLQ
        ==
X-ME-Sender: <xms:qbs8YGg4TYhWWDo7gOeijuhIzF-VHkR95V9DwVKG1VaNYFU5ZS9FNw>
    <xme:qbs8YP_Nap1kFkpu6grCKak8W5i5WowzgANc_I-kIQFT7IL_78LoVoxsnlgVNsXIn
    CgbEL3SCvudwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekiedtieejieejgfetfeehheektddtheeuteeggfeiud
    fhjeffvefhveehfeehheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhfrhgvvggu
    vghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:qbs8YJoX2loZ64zwFnv5V2PdsQTcqcw0pY9GIXfSotUh4-RbnqJ_9w>
    <xmx:qbs8YPWpeeWepGazbimCKFioSirj9H7FVVQN24QxWe49LPCqlHskpA>
    <xmx:qbs8YADWHnD34xJu7S9oLm1lu3PhLI0J2dejfTBhkmOMrHVcu5n4Pg>
    <xmx:qrs8YA6Z6_AjGWB-9AP8ulKafoxurIq5JlkCggMQhoQAZqqdghMyGA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B77831080057;
        Mon,  1 Mar 2021 05:02:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"" failed to apply to 5.11-stable tree
To:     alexander.deucher@amd.com, andre@tomt.net, harry.wentland@amd.com,
        nicholas.kazlauskas@amd.com, oleksandr@natalenko.name,
        stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:02:16 +0100
Message-ID: <161459293615499@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

