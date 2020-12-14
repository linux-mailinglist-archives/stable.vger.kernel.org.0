Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02112D998A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438730AbgLNOOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:14:43 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59441 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439896AbgLNOOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:14:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2EA1C1942EAB;
        Mon, 14 Dec 2020 09:13:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=b9bN0b
        mICqSxE3poZGdZ9Lgj07iP9FaD4C5BCEVdXmY=; b=ftj5DtdwlS/eldatJn68qo
        ZfuNq/Jlp8nnhC74LtnCNKdKusnciXLgBoojLFv2V/RNQe9oj+rtN0C8BIuegRdL
        RAxTq0FFCLDQhYL7/WaPP/UMQDZXNrMvmfq5loQ9xaLOIUS1MbV7eUrW1DDIH4CL
        I1ohuJ6SOYyJIeBUeBbL1gNgsl2K3NuxQUyd4J5Rq/70qWbMVVmwXTKxALkikjjk
        +YNnAcNxpQpfscPLf7zhJkHCHIqiGB/OtjPLl/TDWN4Q6P7voCyI1RpZrOrxBtTh
        V/C9Ksb7y0cm1EeR4/tyheNxANjyew+vlqKGzz0Z+fhfqD3gZXSjauH8SPRWU2Vg
        ==
X-ME-Sender: <xms:IXPXXz7rPW9ovPYqgwcP6WyjG6mOwFsbV3VygwzuDdnppvqluZU5dA>
    <xme:IXPXX4751OdsxJx4bKY6BPp6TKidpFmCsZmWNCSAI5IL_Tl6ZRlHGZQIFUxrTebWA
    XnLm3PDG0xcXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:IXPXX6ctLDhXPmTVxMc-v4SCJfqPSucne9A5iD8jwGtMlkziXSE7FQ>
    <xmx:IXPXX0Lmqsih2sB--ZxDaTZTjvX-LeZOx8xLiZGQFkpn6oBnJ1WBiA>
    <xmx:IXPXX3Iav7iUCV7s8Ar-7NyISkQ4J6JjrjQn5itpJtRdfhE0evptVA>
    <xmx:IXPXX9i362OdyNYAq3vShg3Tiemqwf4hdMNqDln3Vr2RTx5D7uQHYQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB616240057;
        Mon, 14 Dec 2020 09:13:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/pm: update smu10.h WORKLOAD_PPLIB setting for raven" failed to apply to 5.9-stable tree
To:     Changfeng.Zhu@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:14:59 +0100
Message-ID: <160795529922152@kroah.com>
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

From c9918d1f63a3e77ec20997a77c997a6fa7282f2f Mon Sep 17 00:00:00 2001
From: Changfeng <Changfeng.Zhu@amd.com>
Date: Mon, 7 Dec 2020 15:42:29 +0800
Subject: [PATCH] drm/amd/pm: update smu10.h WORKLOAD_PPLIB setting for raven

When using old WORKLOAD_PPLIB setting in smu10.h, there is problem that
it can't be able to switch to mak gpu clk during compute workload.
It needs to update WORKLOAD_PPLIB setting to fix this issue.

Signed-off-by: Changfeng <Changfeng.Zhu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/inc/smu10.h b/drivers/gpu/drm/amd/pm/inc/smu10.h
index b96520528240..9e837a5014c5 100644
--- a/drivers/gpu/drm/amd/pm/inc/smu10.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu10.h
@@ -136,14 +136,12 @@
 #define FEATURE_CORE_CSTATES_MASK     (1 << FEATURE_CORE_CSTATES_BIT)
 
 /* Workload bits */
-#define WORKLOAD_DEFAULT_BIT              0
-#define WORKLOAD_PPLIB_FULL_SCREEN_3D_BIT 1
-#define WORKLOAD_PPLIB_POWER_SAVING_BIT   2
-#define WORKLOAD_PPLIB_VIDEO_BIT          3
-#define WORKLOAD_PPLIB_VR_BIT             4
-#define WORKLOAD_PPLIB_COMPUTE_BIT        5
-#define WORKLOAD_PPLIB_CUSTOM_BIT         6
-#define WORKLOAD_PPLIB_COUNT              7
+#define WORKLOAD_PPLIB_FULL_SCREEN_3D_BIT 0
+#define WORKLOAD_PPLIB_VIDEO_BIT          2
+#define WORKLOAD_PPLIB_VR_BIT             3
+#define WORKLOAD_PPLIB_COMPUTE_BIT        4
+#define WORKLOAD_PPLIB_CUSTOM_BIT         5
+#define WORKLOAD_PPLIB_COUNT              6
 
 typedef struct {
 	/* MP1_EXT_SCRATCH0 */
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index cf60f3992303..e6f40ee9f313 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1297,15 +1297,9 @@ static int conv_power_profile_to_pplib_workload(int power_profile)
 	int pplib_workload = 0;
 
 	switch (power_profile) {
-	case PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT:
-		pplib_workload = WORKLOAD_DEFAULT_BIT;
-		break;
 	case PP_SMC_POWER_PROFILE_FULLSCREEN3D:
 		pplib_workload = WORKLOAD_PPLIB_FULL_SCREEN_3D_BIT;
 		break;
-	case PP_SMC_POWER_PROFILE_POWERSAVING:
-		pplib_workload = WORKLOAD_PPLIB_POWER_SAVING_BIT;
-		break;
 	case PP_SMC_POWER_PROFILE_VIDEO:
 		pplib_workload = WORKLOAD_PPLIB_VIDEO_BIT;
 		break;
@@ -1315,6 +1309,9 @@ static int conv_power_profile_to_pplib_workload(int power_profile)
 	case PP_SMC_POWER_PROFILE_COMPUTE:
 		pplib_workload = WORKLOAD_PPLIB_COMPUTE_BIT;
 		break;
+	case PP_SMC_POWER_PROFILE_CUSTOM:
+		pplib_workload = WORKLOAD_PPLIB_CUSTOM_BIT;
+		break;
 	}
 
 	return pplib_workload;

