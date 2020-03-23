Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B396118F6EB
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgCWO26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:28:58 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40853 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgCWO26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:28:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F2903596;
        Mon, 23 Mar 2020 10:28:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=k1S8vO
        WIU+x2ctUwwHQbh3goEmRcqMSTW2AoVYAr/ZE=; b=35x5FUbfy+5Ez8+Nt29nUm
        YC3fmnO2ZeAIYvTZX1Rd8GyniY8CoSPgm5m75ubobQrSNRKJ4ow7jFrxptVF4d+b
        YfH4+Dp/lqQ12g/BRuUymdeX4As+yvaN4STKqjg9VU0HtqDUt1ZvcLGSYZgv7+fh
        MsQNB/qJU5PauspEnnrb4DvHY++iKF7mceLB9zLFbbLoIsED4Ku5XPVRmU5VdXpZ
        NBvCJCL8eD+MyNdQhFzC2UOQhfS6kjjKSJP3tZjSC3azam+wGhZDT//NNWfu8TZt
        9oLGSGOTjL9H8odjtXnb31SYipElKV2740628ivBcEg7Pr68fPnM/It3DajLuVpA
        ==
X-ME-Sender: <xms:qcd4XpHmsUvdLZtim4I8hRJK55qhd7c2_zbRJ_jjBXkmfDHTUdMFBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpegsohhothhlihhnrdgtohhmpdhgihhthhhusgdrtghomhenuc
    fkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghr
    rghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qcd4XtW7RhUI5aGb0mMTT4yH_yslC3uDpab6-pqFJA7jwtG6c3sHdw>
    <xmx:qcd4XnxFVmCjqUtwiARdUImKMuVX8FAEzGOZza6mwgx3a4j5UP5wjg>
    <xmx:qcd4XpTUo5qzX_Sd1F8-Ti0cGWBSwJnDW-C5nxDtrFYaK7qCS_IBUg>
    <xmx:qcd4Xiyf0zN0tCNcOTKFZK7mPUD_04ZJVk93aFAFj2D_HTv12ubmNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 363EE3062AFB;
        Mon, 23 Mar 2020 10:28:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] kbuild: Disable -Wpointer-to-enum-cast" failed to apply to 4.19-stable tree
To:     natechancellor@gmail.com, masahiroy@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:28:48 +0100
Message-ID: <15849737281461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82f2bc2fcc0160d6f82dd1ac64518ae0a4dd183f Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 11 Mar 2020 12:41:21 -0700
Subject: [PATCH] kbuild: Disable -Wpointer-to-enum-cast

Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
casting to enums. The kernel does this in certain places, such as device
tree matches to set the version of the device being used, which allows
the kernel to avoid using a gigantic union.

https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264

To avoid a ton of false positive warnings, disable this particular part
of the warning, which has been split off into a separate diagnostic so
that the entire warning does not need to be turned off for clang. It
will be visible under W=1 in case people want to go about fixing these
easily and enabling the warning treewide.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/887
Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index ecddf83ac142..ca08f2fe7c34 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -48,6 +48,7 @@ KBUILD_CFLAGS += -Wno-initializer-overrides
 KBUILD_CFLAGS += -Wno-format
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 endif
 
 endif

