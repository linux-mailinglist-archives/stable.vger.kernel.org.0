Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05328FF57
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404765AbgJPHnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:43:03 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44943 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404681AbgJPHnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:43:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EB94FF99;
        Fri, 16 Oct 2020 03:43:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 16 Oct 2020 03:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NzpUJB
        v+1jCrBK2WrToueLJbF4swlOxGeNdI78c2L3A=; b=hPyjb0+3UFxwAhKYnSddIR
        nH4E8Q4Cz3M9KhV2PaX9BYipbb/QD5PEWY+F0Fx8JtM2vBdEcUsIOBzEBx8XMTBL
        yNU9Z89WsM6MFV+/P3qxH0zxiO+xOpbCrL3s51Cz+lQkQrqk93XlK2JFOKFH/NXr
        c1sFYMYzd/Ww/a8IV16LCsAwKqmgOWQ07T5jM30/Iphslu4C0vGbI6pkE7D3Nkdx
        vwpOKlMuZezwJR60tAiCa9WPmMcIZwssujc5vInlq4raUwft9UmCwBJtDuNJr8vj
        5qKglJXK29E+TlOOPCzcAb0jvHdHV7tXqwRCk3ClbCrE1NGAgDJvHaf8ZGDfjY6Q
        ==
X-ME-Sender: <xms:Bk-JX4LhArOIeMNo4Gc3vbhYaiZKhR_5LtgcsvuSPlZk2pv4PuoAHw>
    <xme:Bk-JX4LsorZlOg3E4hCcmYvGXsBu8UNlHbAXEzF3EaZP2cgN61AUrNEs32qYPYk7k
    d34ewOF79ctGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieeggdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Bk-JX4vXE9-21STszczRloBpb4REwA4VOaa-ILgeZE770YvJy7ISYA>
    <xmx:Bk-JX1YUIVIs168LPpcYSdsZvRwEzkezNcLF2W-Eq8NrkzzI4l7PLA>
    <xmx:Bk-JX_aw5j_lZEGD1Xh8q69Ue9niFQ8gZhQVz_2bWBo1CYMA5xuCZw>
    <xmx:Bk-JX51tcxjvvfGE1nIj7__2mTBYSoDJ89RrWTTUxWeLPd9ArrOgz-YnKzU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39B6B3280059;
        Fri, 16 Oct 2020 03:43:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs" failed to apply to 5.8-stable tree
To:     alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Oct 2020 09:43:25 +0200
Message-ID: <160283420587109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

