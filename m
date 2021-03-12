Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573C0338E1E
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCLNB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:01:29 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40565 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbhCLNBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 08:01:12 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9118B19402F6;
        Fri, 12 Mar 2021 08:01:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 12 Mar 2021 08:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zQDOWl
        0ZI7KmjxeVAMaO49tu+yxSUW1d32B2mryULbo=; b=TJtZvGc6cKS6cyf56wfN13
        G2mwQvpGcfpiFqjsUZPAgiTDcz5UzeFgnlxjJsFUJUULUuC8p1UH7AMZzxiJpz0v
        RekGj978QDmAFNVrgO9ljcxaba3U29PfLFPeZ9Qr88A2DejVxmfYbfv3pDzaoDpO
        ZhfOIvkw/UO4dHmvTgFyEGhgJ3q/oI2mdJQYC5MLKmmqdo7NeQb/zJDD88Ehpceo
        pUab69YPU+avwVJC6WfQ2buNL4ofAWqMfX3+0bWxCN7n3ktgzKFEliaYIyHRy+v6
        JFDEXXMRpIU/pA+4akBms6/4D9RM8YvZpKTjjegpzFa0NZnH8Bx4ezfrRMgsRPkQ
        ==
X-ME-Sender: <xms:F2ZLYA_-Dtp7Y6xygHr3lB_7jXmmgLcajZjmXJry6S24SLpHKPnPCg>
    <xme:F2ZLYGSCu3O5A17ZaQsvDTD8q29IlqWChAQhP5i9rUb1_RONtg4XPMMLF1PG2d4oV
    7AtlEfqIZA3Sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:F2ZLYMfK2zi1rsjGq2hCLp3VmTItXg1v9rVSJZzeqFm9Oh21Sx2pJQ>
    <xmx:F2ZLYCD17HZLEzk9G4tUbhUGO6_3jF3SOBBxaLZVn-vm0bTcGLjUrg>
    <xmx:F2ZLYGl-7JL_d895GJo_QEOLqLa4hwSgO_heFn_UupQyzn_nwCqyPw>
    <xmx:F2ZLYDKeEmVOF23DZ9g6zhXKIU4Eepe383e7NZLFfsI4D7ObD_rmGA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB13324006B;
        Fri, 12 Mar 2021 08:01:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: hns3: fix error mask definition of flow director" failed to apply to 5.4-stable tree
To:     shenjian15@huawei.com, kuba@kernel.org, tanhuazhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 14:01:01 +0100
Message-ID: <1615554061134255@kroah.com>
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

