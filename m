Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE428FF56
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404694AbgJPHnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:43:02 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33353 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404681AbgJPHnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 03:43:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9E8261256;
        Fri, 16 Oct 2020 03:43:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 16 Oct 2020 03:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8WIVNe
        DxPMR64Y/Nh1Sg9nr9B4N38/MGo8mEw7C2cTs=; b=Fdg1qRb6E/5ErmIBRvswmk
        LhlyKAu8ZxIKwEPDucemaLOCMI1oVjV98IfU/8yyR+mjjxPdrGKnL2bYqbTdYvF3
        A1h7CK2jTsPvoxI7TOMlewm1H23pZPbcSFhN7Es2g7qmd2X3Kqj7VRszaM7CXWX0
        Z0N6GbNedVdKkJZ39UkL4AMlyTqBMu5Z8U4RVL8y/V/eW3/vrBETrh21Ki4UJST5
        odfKBp/igRytOJa8UXLGV8ECHZf8Eqm5fhLPzpdwMtN3OSesoEYGiWCupUZdnz77
        WbWtH58IKhbqROYNVYVn/kNBEr1BBHh44u/28T0o1GfV3Gt1JbQHgLhxr27s5Jiw
        ==
X-ME-Sender: <xms:BU-JXz3BM5SXTn2VO1BUY1nJiMVQiYdGOLfpC4DSNEKwEJzyLMVdFQ>
    <xme:BU-JXyEx2OuRUDt7Lo9DZCnioZlBUvtWBPlr5HIlOnksbSveUfq_p-lb4dmK82yxq
    RWkLpsBm2iPQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrieeggdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BU-JXz7p_IYf1vNsyehKvNcCGcIIwlbk3dPxTIhGgRlFX9But56YEQ>
    <xmx:BU-JX41vSMEaQamphGETpZqCVDPAcf5KW_4yKQBAkpJQf8UPIvoGKg>
    <xmx:BU-JX2HxT7hPIBsx2jVCPd1A4_tsp8V3PB-RmPMpVVvY5snw8ZM7QA>
    <xmx:BU-JXxwH67VFu8KrdksfNsP6GU44ypXeiEUFrFkxbfOVuKjMCFfKP7pCV7o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEF993064680;
        Fri, 16 Oct 2020 03:43:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs" failed to apply to 5.4-stable tree
To:     alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Oct 2020 09:43:24 +0200
Message-ID: <160283420410417@kroah.com>
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

