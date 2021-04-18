Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D2A36351B
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhDRMWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:22:05 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:37949 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230441AbhDRMWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:22:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F11FB1A99;
        Sun, 18 Apr 2021 08:21:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/3QsSu
        xZ5NTdnmYBDbSxLQfoyw1zpi3hFr9yy+NZgZg=; b=DPl/Mt3kn+o4ZCMW1KD8v0
        vJEz++gndj5vaH1m6j/lwwm0R4dTQvhPetwqCcmXmbrvGxrtaCOxKWMlntIOr/1B
        LQcXGcrndHLkSjZJlfctMKeBZAY1QgulOHG4vdYcb6+IW/LcoIaQLfzRYlcKLE6G
        9HawNSryOPAsQHYgcYEpPUhQo60ldQQvLfsaBUz+v9idzeE1xCxM/pY2qoZ2ialf
        U+mt1GroZFx0nGjAKXzOriFl3JMn8k6xic95BhKweJQxn+BhQWEFCBDtWBxQ86nF
        7EA3MJVFAzRFmhBEP/xUmidos+kvx88GRhKTLJ4tWNjUXd83DoGQ4TrhTCfDZhTQ
        ==
X-ME-Sender: <xms:UCR8YPoCJddyMRzeuJ0xSgfpYxPGayWKxvws9yvxg94TgS_x0QIphQ>
    <xme:UCR8YJr83K2iBMX8h3AvZv8EH7l2nvUHK6IjzyLJc7B0zlsfwIs-07HKW0VUf7sFz
    -eI6YH1ypVWtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:UCR8YMNBYvOk9qlF8xap4k3bLvYSMEI3CbhkF4sLJHCfOOCsoay8bg>
    <xmx:UCR8YC6ekuZ_N0N9VKrCEE3e93LTTmFS1-ZF3OkzLfA3ZBhy_kddiA>
    <xmx:UCR8YO5xNtl46U2tnl3B4cJypqMBmdM_4t5TFcX8PviwExoP7H9MKw>
    <xmx:UCR8YEQBIlPtMs86NTD8KNgTPSnJ8YzgPw5Vip10Jxf3DZhKYgM1WpaGPs4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F851240057;
        Sun, 18 Apr 2021 08:21:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Use correct permission flag for mixed signed bounds" failed to apply to 5.10-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, john.fastabend@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:21:26 +0200
Message-ID: <1618748486233102@kroah.com>
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

