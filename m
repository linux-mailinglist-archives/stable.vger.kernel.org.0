Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027092F0E9E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhAKI7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:59:05 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59971 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbhAKI7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:59:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7769A195AB4C;
        Mon, 11 Jan 2021 03:57:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cNy7e0
        shq2eANQJg1pbLoPQmSBOAnK3DpBuRPbsVpzM=; b=rrMw3ntOjvMsyleX+wvVoc
        xUMGORHRM5Al3T5ECCfiyMgUyHUgnN6WMLXsRcwezM2+oN6lFWnXBfBROXHicI50
        j9sZgXcYqB42zp5VPyGHth23yBVuAHUQE59M4J596vgf9TZD07fxKQyNxvBfPGie
        LL9SGBnijc9eZg4Zp8im7jmlxa4tfx0WHT4pVsvBo1J0mCQfVM0FQ8fGErxi4Ryd
        D2ERhkx+N9vlUcTohJ3ezgxhs4Q+3umvVtB68aSYo/i7oNsrZ39UrwnmNiknPKID
        JIi+XqJmfLydvoShxQ0TR32n4tuREZMzEZh/ebzuJg2rW99OsVJCfxzvIRYA68/A
        ==
X-ME-Sender: <xms:FRP8XwhM0cq1tOqHyqIRq59EzHBHPgmQVI9VZHFROYqvonDxh9Hoig>
    <xme:FRP8X5CrwrQrtdK7V-YFmKFxYcUFo4jCDrHo46WaEy6aNGUqanS_kq3W1gmZ6Cehl
    3ZIR8zxyFZbOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekiedtieejieejgfetfeehheektddtheeuteeggf
    eiudfhjeffvefhveehfeehheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhfrhgv
    vgguvghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:FRP8X4HEJt3EqYGHACqguQcRwcmWos-HGuX_tA55h7FW414kyF77zw>
    <xmx:FRP8XxT93Ef_InyQjfhQxtkfNHtHxVRpLTwH35NEQlzv8COoW2T4iQ>
    <xmx:FRP8X9x9KwegvSXvdTP8-tbe_rr4kYfuSOKXlnm6zSWe6lS-6hvBDA>
    <xmx:FhP8X_vbTuDcOFJcHYxOPwYyb46OGysmwZWXVab11jLlN4xTutOqtg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90F9B240057;
        Mon, 11 Jan 2021 03:57:57 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"" failed to apply to 5.4-stable tree
To:     alexander.deucher@amd.com, andre@tomt.net, harry.wentland@amd.com,
        nicholas.kazlauskas@amd.com, oleksandr@natalenko.name,
        stylon.wang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:59:10 +0100
Message-ID: <1610355550252222@kroah.com>
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

