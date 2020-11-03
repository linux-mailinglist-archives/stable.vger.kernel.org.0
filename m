Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8732A4A5B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCPwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:52:16 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39731 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCPwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:52:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 05FAB1942D4F;
        Tue,  3 Nov 2020 10:52:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E8MqS/
        rkq0Z9Wvj7TrjBf7DQ6tzCXbgBbMMJTqESMog=; b=VQjqjH+r3ZVJk4a8FdUHIt
        MHn1WPeN8FfSgExPJDb8dZJ1wI+5+KoL4hTqxk9wpY1e3Se3RY80pKBDFric4xxc
        VCk/idbhNY8NfKwnwa2kK71rMzzKtWQ/Pj0u4vrBk7INqYeZ6MUDCY4pmRceeIlf
        0MU1RJO3olwJdcPnLMSgLIlNuFeFR+EYaSqCMYybLIO+1mHLR0PmR4wiyZ0KBwnp
        F2w8tTnsnwj97vm8q0ExA33/3e1fP3w0bxMSvpNLyvnaLaScXewLGD/1aJzZ55Qe
        Xk/Td8bOhFGBTc9LIzxMIoDWLvvRurk9EV7CPQ1SNgCPAN9wlNzgy8ZVDirjS6DA
        ==
X-ME-Sender: <xms:rnyhX-Tt0wiJtmen7bAaeEre9nljYk1wgCiMcF1BpqkbfkPuqU0oRg>
    <xme:rnyhXzw-HXjGuSEem3USG5smi2eAUIRaydWFzdRWqtMIKq_dZdjxeBcv56ghlIRHk
    ol6tkDH_BNmNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenuc
    fjughrpefuvffhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhhes
    lhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepieetve
    ehuedvhfdtgfdvieeiheehfeelveevheejudetveeuveeludejjefgteehnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:rnyhX72_DcmzYH5TmV9GdIjZHnaEyosmZrdHlOUPdpJMbXGOc0j26w>
    <xmx:rnyhX6DdPeKrjJPrsVOvVKNpn61JcjByYbJPFLpBzSK6NhqfoP7RPA>
    <xmx:rnyhX3jhODWehQHYkQ1MgNE-O6HUF5dTVw5GIJ2_2PdJ4r6GD5Fzrw>
    <xmx:r3yhX6ulgQvGA2fbNkH-nOqNKoXevf8v66eWCYpq4bCyANez540GbA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F59D3280067;
        Tue,  3 Nov 2020 10:52:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu/display: use kvzalloc again in dc_create_state" failed to apply to 5.9-stable tree
To:     alexander.deucher@amd.com, alex_y_xu@yahoo.ca, aric.cyr@amd.com,
        nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:53:08 +0100
Message-ID: <160441878847175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0689dcf3e4d6b89cc2087139561dc12b60461dca Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Mon, 26 Oct 2020 10:25:36 -0400
Subject: [PATCH] drm/amdgpu/display: use kvzalloc again in dc_create_state

It looks this was accidently lost in a follow up patch.
dc context is large and we don't need contiguous pages.

Fixes: e4863f118a7d ("drm/amd/display: Multi display cause system lag on mode change")
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Aric Cyr <aric.cyr@amd.com>
Cc: Alex Xu <alex_y_xu@yahoo.ca>
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Tested-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1eb29c362122..45ad05f6e03b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1571,8 +1571,8 @@ static void init_state(struct dc *dc, struct dc_state *context)
 
 struct dc_state *dc_create_state(struct dc *dc)
 {
-	struct dc_state *context = kzalloc(sizeof(struct dc_state),
-					   GFP_KERNEL);
+	struct dc_state *context = kvzalloc(sizeof(struct dc_state),
+					    GFP_KERNEL);
 
 	if (!context)
 		return NULL;

