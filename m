Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78FE249F85
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHSNWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:36 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46557 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728442AbgHSNWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:22:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 39B293CB;
        Wed, 19 Aug 2020 09:22:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=i7QMFo
        2No73oCzmCKtOf1CJGYVmohs+HDH5ssnvqAuI=; b=VTZM+cQ6qMYfvX65a/3rU9
        /24A8DnubeoLW9nfwnKh1kMC4ZhoZw6hZi2e1mQgoOI9LRcWkA/keDpidptGvKfa
        RPTpUbElzdUwARk60UL+pa4C5RAjrGfN81oTx/27iDBPmN225Skmt4Ikh84f9eR7
        9UlJnYPLC0qP5ylfiHWu/h0avvzvzIRa4OnyaX+BolbICEk6HWTx4tNhtSAXK8Q8
        oVm7bJXrAUyZZapMX5uDQcE3xnneSOnU4j1797Rj2TPKScGKvDcgDxaXjaelYCsN
        Qmvpu6pqjincZOEEuVt+dFQVU0ZECLHqoylX6BfmUJK96LReXBMLgV3VJ/1CMJfg
        ==
X-ME-Sender: <xms:iSc9X5ZZEQTw6CiMw5R86yLsBz5s0iNypK9tXFfKvY4wMlK4BvcGjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iSc9XwYFHkSpEK7c3mb8ysUjLx3uhbTZfZS0ByW9a1mlZvi9-lsO2A>
    <xmx:iSc9X7_fM8ZRPhLRZwoJC1ExyHE8d8VoDoqn8n_3ggMK1X1oC-yiCA>
    <xmx:iSc9X3pKEyq8SVq-ic_sL4uCpsyIhUMXWTZM7YDlRhrJpYt4mNZZQw>
    <xmx:iSc9X6GSn1AiWF4f1hyQkRworexuLvDlA2d03mVX8r2tGhnCpcTPrQ-6Qrs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 788B03280060;
        Wed, 19 Aug 2020 09:22:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before" failed to apply to 4.9-stable tree
To:     sibis@codeaurora.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:22:38 +0200
Message-ID: <159784335831227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e013f455d95add874f310dc47c608e8c70692ae5 Mon Sep 17 00:00:00 2001
From: Sibi Sankar <sibis@codeaurora.org>
Date: Thu, 23 Jul 2020 01:40:45 +0530
Subject: [PATCH] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before
 load

The following mem abort is observed when the mba firmware size exceeds
the allocated mba region. MBA firmware size is restricted to a maximum
size of 1M and remaining memory region is used by modem debug policy
firmware when available. Hence verify whether the MBA firmware size lies
within the allocated memory region and is not greater than 1M before
loading.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0x40/0x218
  rproc_boot+0x5b4/0x608
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
  __arm64_sys_write+0x24/0x30
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 03d7f3d702b3..7826f229957d 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -411,6 +411,12 @@ static int q6v5_load(struct rproc *rproc, const struct firmware *fw)
 {
 	struct q6v5 *qproc = rproc->priv;
 
+	/* MBA is restricted to a maximum size of 1M */
+	if (fw->size > qproc->mba_size || fw->size > SZ_1M) {
+		dev_err(qproc->dev, "MBA firmware load failed\n");
+		return -EINVAL;
+	}
+
 	memcpy(qproc->mba_region, fw->data, fw->size);
 
 	return 0;

