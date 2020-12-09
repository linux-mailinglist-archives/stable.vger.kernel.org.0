Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F052D4629
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgLIP5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:57:01 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40683 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730084AbgLIPxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2CAB719439D1;
        Wed,  9 Dec 2020 04:03:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:03:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=htU0tb
        NrN47Eq8sSWK7pG5ug+1qrnd6FRneVp8uw5V4=; b=nnmBTUY/MjrelI1DhF91lf
        yiXN9IgJdggeGVPgi+J/MSPLdQ9gueRZZt8gubYc/cGsLUWM2uQnMkr0UgCI7/aH
        9L9/kV2f+m/7absbuytotrgKpVwIaJsU/SZ3m808/P/wzwl9k4BXEPUUDNfImGSl
        ajxn8Gx2N4grLz0RvPY4o3+bqvXY0PYRyNs7TpXVLOu8/mhdhmPXZmldJDYZDcVY
        VRJjLuyYz5sJiNCZQxpFi3dVfI0XZrqE4Mmq5EeGjXioDnNatfSGaNctMz7Kaxf7
        4aojHDeAiQ4y+1USXIDJXzYgl4YxlpK/evRkTxI4HThcHYnZE1fA+8RJ9r7nAiVA
        ==
X-ME-Sender: <xms:95LQXyCXeDMDTue7w1I0wCYsVCpdOYvqlPog1z1eqiFZoS0moo5SoQ>
    <xme:95LQX8g0lZu-fo0QTUW4YvpDHbhXBaxsTYuftXDlBL9ZYG00xZT1O0gwRExv7-_P1
    QpLmwFwyLqOrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffedtgedvje
    euvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:95LQX1mBs1vk5PuDSkkaMhmwceTEIScL_KV3XzjSfkKOZ07BvVH96A>
    <xmx:95LQXwx1kwLRFpXh863sgh-GkV-qHBw7nftAis6Z27CvWtkd7Qxb2Q>
    <xmx:95LQX3RiRR9GbdNFTqrZAWpa3J99wWJG84dUbYHbhedZm9LwIiFUpA>
    <xmx:-JLQX1OB7gFSt7cIwemoWPjRRQuGR3TSH-mBKU3aMUKQL0bSUIlOhA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F1E41080057;
        Wed,  9 Dec 2020 04:03:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1" failed to apply to 5.9-stable tree
To:     ndesaulniers@google.com, dima@golovin.in, masahiroy@kernel.org,
        maskray@google.com, natechancellor@gmail.com,
        sedat.dilek@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:04:20 +0100
Message-ID: <160750466017491@kroah.com>
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

From b8a9092330da2030496ff357272f342eb970d51b Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 Nov 2020 10:35:28 -0800
Subject: [PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1

Clang's integrated assembler produces the warning for assembly files:

warning: DWARF2 only supports one section per compilation unit

If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
assembly sources (it is still emitted for C sources).  This will be
re-enabled for newer DWARF versions in a follow up patch.

Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
LLVM=1 LLVM_IAS=1 for x86_64 and arm64.

Cc: <stable@vger.kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/716
Reported-by: Dmitry Golovin <dima@golovin.in>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Dmitry Golovin <dima@golovin.in>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

diff --git a/Makefile b/Makefile
index 87d659d3c8de..ae1592c1f5d6 100644
--- a/Makefile
+++ b/Makefile
@@ -828,7 +828,9 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
+ifneq ($(LLVM_IAS),1)
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
+endif
 
 ifdef CONFIG_DEBUG_INFO_DWARF4
 DEBUG_CFLAGS	+= -gdwarf-4

