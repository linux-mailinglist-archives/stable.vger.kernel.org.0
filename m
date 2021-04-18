Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3636D36351A
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhDRMV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:21:58 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44547 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhDRMV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:21:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E25AE1A7C;
        Sun, 18 Apr 2021 08:21:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1NQjvb
        bqLYMW3mQL4HWSI0ZvP47PrvfBRMxD7chr004=; b=fyh0lDM6jWWdGblSWyohSB
        n//DYf60pFTeFLZm7oNWksJSBDO4rEwksSc2Ibl4SmaC86uOYdg+5H9uJHDJD7S0
        klTYKX7KoBFC/57fHtuC3t92ThQ9szOFibgpyrrLZLhAN9t0MotirMNPbYR8C1Cc
        1/+pqY4l6J6nBVzuDHgG+z4wAveFObwe8EHnzbQYzFe1vylmdONxraB9Mi/Ykr/y
        KRC/LsFAO1NJJWeL+HN99wymurej/JWxr9Y31PA8cCpaF6QPhxRROaUwfzdzITEG
        A2SCGAbHPKRqDheG/3VGi5W4+9sufL3pil9LEBEFnKKnZXbnH3AqO7SIXzUxNg0g
        ==
X-ME-Sender: <xms:SCR8YM_x_HjSHsekSyWsAhEyF7C678I-_tFVt6qKNmD9RIxoJVskQw>
    <xme:SCR8YEsLvXnTfQ9QDCh-6S1fMIWoGkDGuCqtUN2eiH_VNRn9bgBvKF3i-_HQB2Znz
    rtAqWjU8xrGzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:SCR8YCCJJxhMSMbnCmDF0coW6nEZ6RX6heX-nZo9v9ugWwVSvITcdg>
    <xmx:SCR8YMeOazzmyYE-fiY3Uro9pzlJR8dL9iXcRHmbBc4bsw8GTgMtyQ>
    <xmx:SCR8YBNZyskKFBvXFVPXOC7H-9LParbe6rjSgHSy7LcWoX_hLpDkjg>
    <xmx:SCR8YP0Lpe4ldkUyjXGX75TEbbuzAQKNbfe99klfVS41KfD5k472jIl_QWg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06E5D108005B;
        Sun, 18 Apr 2021 08:21:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Use correct permission flag for mixed signed bounds" failed to apply to 5.11-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, john.fastabend@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:21:26 +0200
Message-ID: <1618748486253240@kroah.com>
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

From 9601148392520e2e134936e76788fc2a6371e7be Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 23 Mar 2021 08:32:59 +0100
Subject: [PATCH] bpf: Use correct permission flag for mixed signed bounds
 arithmetic

We forbid adding unknown scalars with mixed signed bounds due to the
spectre v1 masking mitigation. Hence this also needs bypass_spec_v1
flag instead of allow_ptr_leaks.

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3a738724a380..2ede4b850230 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6085,7 +6085,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
 	case PTR_TO_MAP_VALUE:
-		if (!env->allow_ptr_leaks && !known && (smin_val < 0) != (smax_val < 0)) {
+		if (!env->env->bypass_spec_v1 && !known && (smin_val < 0) != (smax_val < 0)) {
 			verbose(env, "R%d has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root\n",
 				off_reg == dst_reg ? dst : src);
 			return -EACCES;

