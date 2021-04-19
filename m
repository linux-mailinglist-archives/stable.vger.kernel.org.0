Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0259736414A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhDSMNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:13:17 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50293 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238882AbhDSMNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 08:13:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B8D8B1940A5A;
        Mon, 19 Apr 2021 08:12:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 19 Apr 2021 08:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ChBrDf
        PTDqqPPjMj/FKpyLeQDzWHFsGNFMYDCTtUBhE=; b=wBiEj0qFjzKWtVylDiqWaU
        cJNqkAtqCvnZ5ZgaflsxlgVLLvJ5jHkBtMZZdAyCOQGbm+PqCvNV7CXWqn54+zo6
        vS2TKFi00CzRlhIbqd9aGZdd9qN7RHraH5h0r0BqFfS0pqMZ2i3FgbzDku0VXPCl
        VdAafEIggf5TPg3bcgN5hsI37ITgkAkbCLw7n2wQtPLrxBnHfcL5I+LsN+uYxqWl
        S6lIO/zHIMDqM0POgPUGEksUa6ShskQ+YBIwHnOKtqKGBssftW6/VyLduHHIzEXI
        PjaYibHnkhG4iuDTLXvZS5VsUwUzHkl7dsQf7QxtmSLC8T7HR7QYiGK2+XkEzWKQ
        ==
X-ME-Sender: <xms:vnN9YKJOapgiYFjBRNHWfCLAfBmB-D5TdMOB9UOtK-udOULNrT_YHw>
    <xme:vnN9YCIjN6lxs9-TmMzgYZ_BIPqomZsNTPg0yCxOpTA79hMjQuTN2atjE5UGuY6ei
    T7OeW6mdGCAsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:vnN9YKvZwmz1LCzWk4xX3R2QJZSPxhcetSYBmimovNUUcSacxEUvAg>
    <xmx:vnN9YPa7DZfM23VNzlZOBsn5PjQHHJQZx2g-cK3kuwKEC5-nAg_jUA>
    <xmx:vnN9YBbQw344mAVAD2wRn7m_AbX1--9prCdoqfiQEGza_7I3o6LZDQ>
    <xmx:vnN9YAwQaBA1o-WGn0QZAnoPd5ppT0RCkEgmEjii7147pXW89L_94A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEA6E1080057;
        Mon, 19 Apr 2021 08:12:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Refactor and streamline bounds check into helper" failed to apply to 5.11-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, john.fastabend@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Apr 2021 14:12:43 +0200
Message-ID: <16188343637693@kroah.com>
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

From 073815b756c51ba9d8384d924c5d1c03ca3d1ae4 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue, 23 Mar 2021 15:05:48 +0100
Subject: [PATCH] bpf: Refactor and streamline bounds check into helper

Move the bounds check in adjust_ptr_min_max_vals() into a small helper named
sanitize_check_bounds() in order to simplify the former a bit.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f378d4ae405f..db77e2c670b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6075,6 +6075,37 @@ static int check_stack_access_for_ptr_arithmetic(
 	return 0;
 }
 
+static int sanitize_check_bounds(struct bpf_verifier_env *env,
+				 const struct bpf_insn *insn,
+				 const struct bpf_reg_state *dst_reg)
+{
+	u32 dst = insn->dst_reg;
+
+	/* For unprivileged we require that resulting offset must be in bounds
+	 * in order to be able to sanitize access later on.
+	 */
+	if (env->bypass_spec_v1)
+		return 0;
+
+	switch (dst_reg->type) {
+	case PTR_TO_STACK:
+		if (check_stack_access_for_ptr_arithmetic(env, dst, dst_reg,
+					dst_reg->off + dst_reg->var_off.value))
+			return -EACCES;
+		break;
+	case PTR_TO_MAP_VALUE:
+		if (check_map_access(env, dst, dst_reg->off, 1, false)) {
+			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
+				"prohibited for !root\n", dst);
+			return -EACCES;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
 
 /* Handles arithmetic on a pointer and a scalar: computes new min/max and var_off.
  * Caller should also handle BPF_MOV case separately.
@@ -6300,22 +6331,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 
-	/* For unprivileged we require that resulting offset must be in bounds
-	 * in order to be able to sanitize access later on.
-	 */
-	if (!env->bypass_spec_v1) {
-		if (dst_reg->type == PTR_TO_MAP_VALUE &&
-		    check_map_access(env, dst, dst_reg->off, 1, false)) {
-			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
-				"prohibited for !root\n", dst);
-			return -EACCES;
-		} else if (dst_reg->type == PTR_TO_STACK &&
-			   check_stack_access_for_ptr_arithmetic(
-				   env, dst, dst_reg, dst_reg->off +
-				   dst_reg->var_off.value)) {
-			return -EACCES;
-		}
-	}
+	if (sanitize_check_bounds(env, insn, dst_reg) < 0)
+		return -EACCES;
 
 	return 0;
 }

