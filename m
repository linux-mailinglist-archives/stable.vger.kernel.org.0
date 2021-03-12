Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A63338E1D
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhCLNB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:01:27 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:45803 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhCLNBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 08:01:04 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 786291942B13;
        Fri, 12 Mar 2021 08:01:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 12 Mar 2021 08:01:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xZlOE2
        teAatQFkLdcGNG5TGIhMrZ8E/QFLlIGYJXhFQ=; b=iW6r3mtubIoEf2sz02r4/J
        CK3jp04HY0YDv4xOihdgIv0MToM3Kpeq6VkhatJr5Uq3ZCMX+HroU/legr11s/gT
        omlKVLHEXwK78TWoOQGaKEQztv4QmzGVUr/mFeHb1smVIck8SUP00sGgaJWBeLyo
        reWTsKohKAzRibFwAh6x+We3GhKNG2+QgUhrodJQH6iqMXXXfXkG6WHPTeUhjRx1
        qCFoWb9QCee0xRJ6vI2DEZvK03m720C6TWTAX037kNdfAgEXhESAWvjJf4yPiRgQ
        ZO/STSWi26saE39yaCK3lx5FeYU8DXdrQ2BuDaOyDa38A6jDLahd9PGwM7pQ8p8w
        ==
X-ME-Sender: <xms:DmZLYIei_a-uAnAYGoCOSlLwuAJENMefYaBWE2wpEIto_u3CB6Xf9Q>
    <xme:DmZLYKL-7B0Pt0F5P3TwAohRjxa2OPkq4AMrEXNZKNhiUuKWKwNT2WU98Q13ReUvd
    yDzkxP3ekq60w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DmZLYGbsKoWLP14-3fgr8gch7P3Wrd2heCKL1DLKakpKB6SS2l-Vyg>
    <xmx:DmZLYFs4XWfOvF6P5WeSqGH6Jnp0bd1bPDeVQlwfgnXGdo-AgKMOdQ>
    <xmx:DmZLYDvKNbAH1iexze5Kof4xqrUxGtPmBvXKXcwo1_LnQkZ2Za3RdQ>
    <xmx:D2ZLYHb602rRjoII0S7Fph1Jd4QZ7B6SBP7-WUMhvJG22SCqtJuHdg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 502611080068;
        Fri, 12 Mar 2021 08:01:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: hns3: fix error mask definition of flow director" failed to apply to 5.10-stable tree
To:     shenjian15@huawei.com, kuba@kernel.org, tanhuazhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 14:01:01 +0100
Message-ID: <161555406124523@kroah.com>
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

From ae85ddda0f1b341b2d25f5a5e0eff1d42b6ef3df Mon Sep 17 00:00:00 2001
From: Jian Shen <shenjian15@huawei.com>
Date: Sat, 27 Feb 2021 15:24:51 +0800
Subject: [PATCH] net: hns3: fix error mask definition of flow director

Currently, some bit filed definitions of flow director TCAM
configuration command are incorrect. Since the wrong MSB is
always 0, and these fields are assgined in order, so it still works.

Fix it by redefine them.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index ff52a65b4cff..057dda735492 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1053,16 +1053,16 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_DROP_B		0
 #define HCLGE_FD_AD_DIRECT_QID_B	1
 #define HCLGE_FD_AD_QID_S		2
-#define HCLGE_FD_AD_QID_M		GENMASK(12, 2)
+#define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
 #define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(20, 13)
 #define HCLGE_FD_AD_NXT_STEP_B		20
 #define HCLGE_FD_AD_NXT_KEY_S		21
-#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(26, 21)
+#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(25, 21)
 #define HCLGE_FD_AD_WR_RULE_ID_B	0
 #define HCLGE_FD_AD_RULE_ID_S		1
-#define HCLGE_FD_AD_RULE_ID_M		GENMASK(13, 1)
+#define HCLGE_FD_AD_RULE_ID_M		GENMASK(12, 1)
 #define HCLGE_FD_AD_TC_OVRD_B		16
 #define HCLGE_FD_AD_TC_SIZE_S		17
 #define HCLGE_FD_AD_TC_SIZE_M		GENMASK(20, 17)

