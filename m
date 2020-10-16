Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CDA28FF55
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404731AbgJPHmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:42:54 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:57379 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404726AbgJPHmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:42:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0C0ADF8D;
        Fri, 16 Oct 2020 03:42:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 16 Oct 2020 03:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=32C9y2
        50ZND9z2DL/mO170+hDP3d/iWwGyFuDV/fQXE=; b=LkhT1/1QRqoyqOLj9/2a/Q
        Uanw0fR9iK36UNdoSx4woggRxICAICArzJkLsW4yLOWdCL62UJCcLmB7/OFh8G//
        nqA2Rp2WEyOs/P3dZMHHgWCUYn3BsWTazsJjkejdKSQY+N+Z/sBChvhYsw7JOo/F
        OnfFQaSZpGQVIe8KmV9F9W2b89M3MY/f6k9An533VrCf3VHPQK2yUYSaUEjHMUmo
        A109TQ81HTPaniIxnplAtZhDU8813g0034gN/jvCuDKF1I+EBRHcfyhyUvwxanTr
        iL9rS3qugA4+PG/2/9mWYo9amKArQW+cUpOEuaef1yzvmC04fReSgWEfv7OHteHw
        ==
X-ME-Sender: <xms:_E6JXyjAaN5zA1cj99kE5dkCIUP2910np5huxtKNukS31uk0Kgjnog>
    <xme:_E6JXzDdE-ygzk5_ZlPCJPnVDaks9HL8p22zdVmbKBg8j0iDX_SyFCPEP1NhEtytU
    C23do8AzeiFhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieeggdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_E6JX6GlztwDGRkyfbE7EfpnoqSaAuPh1Di0DC_l693XOJ9ATpWSuw>
    <xmx:_E6JX7SXGkAaE3FsRcRJCd_HfQ5GkbNROXp2ajCwymzrF2ku2iiluw>
    <xmx:_E6JX_wT0l1KdZnY664oVvfhcsIjwk_6VRyfTUm0EZVQJ95dbZk_Xg>
    <xmx:_E6JXwuGpPyB7MvrbVcrZNPSp8Y5oD6mimFOzdy5WiwNJgTZQC_Xp8b4CZc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 407F0328005D;
        Fri, 16 Oct 2020 03:42:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs" failed to apply to 4.14-stable tree
To:     alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Oct 2020 09:43:24 +0200
Message-ID: <1602834204153149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2456c290a7889be492cb96092b62d16c11176f72 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Thu, 30 Jul 2020 11:02:30 -0400
Subject: [PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs
 handlers"

This regressed some working configurations so revert it.  Will
fix this properly for 5.9 and backport then.

This reverts commit 38e0c89a19fd13f28d2b4721035160a3e66e270b.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index f44157daf3ec..576e3ac98365 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -872,7 +872,8 @@ static ssize_t amdgpu_set_pp_od_clk_voltage(struct device *dev,
 		tmp_str++;
 	while (isspace(*++tmp_str));
 
-	while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+	while (tmp_str[0]) {
+		sub_str = strsep(&tmp_str, delimiter);
 		ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 		if (ret)
 			return -EINVAL;
@@ -1165,7 +1166,8 @@ static ssize_t amdgpu_read_mask(const char *buf, size_t count, uint32_t *mask)
 	memcpy(buf_cpy, buf, bytes);
 	buf_cpy[bytes] = '\0';
 	tmp = buf_cpy;
-	while ((sub_str = strsep(&tmp, delimiter)) != NULL) {
+	while (tmp[0]) {
+		sub_str = strsep(&tmp, delimiter);
 		if (strlen(sub_str)) {
 			ret = kstrtol(sub_str, 0, &level);
 			if (ret)
@@ -1858,7 +1860,8 @@ static ssize_t amdgpu_set_pp_power_profile_mode(struct device *dev,
 			i++;
 		memcpy(buf_cpy, buf, count-i);
 		tmp_str = buf_cpy;
-		while ((sub_str = strsep(&tmp_str, delimiter)) != NULL) {
+		while (tmp_str[0]) {
+			sub_str = strsep(&tmp_str, delimiter);
 			ret = kstrtol(sub_str, 0, &parameter[parameter_size]);
 			if (ret)
 				return -EINVAL;

