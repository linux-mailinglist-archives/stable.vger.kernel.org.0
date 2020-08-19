Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6CA249F7F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgHSNWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:19 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42435 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728477AbgHSNWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:22:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 458A2309;
        Wed, 19 Aug 2020 09:22:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oNNjL7
        I9zo6kWhalK7C98i4IWaikwNaTVG1CpD8eqzk=; b=kGrWSNPbo2YjYTn4go6qA2
        jhkSpqt7jFu1tcAgvEu4JGEPU8J8CtDaAaEBhMFQ2oHEOlFN3ktIFFSxSUvi6BjY
        HDoZG9rC+7bkVxhQl36EfGwRKLLriTPW36g1mAiiOjEqQYnKk+n4oPM40gToWtyn
        ko/xTnkbx8TG0Yi5Z+MiguhYsC1tCRVzX21zEI3bqgz+Mwll+uEGS4R3DW7rKRxH
        q4gjXQ3BNLenjs6Pdn1p8fBKxf/dqibXmyu3BgJtEN5s5qSHwMdZiJE6OPzQal23
        qwDnmHqaBRaqhArIQzc5UwGQKE72+j6rq+piZ4UKd5jpYE3ev/JthCTCl1o1AyWA
        ==
X-ME-Sender: <xms:hSc9Xx_YFX-rVo4HTK2KMb5cHh8nDR_SnLmmBOz9C5qS7HSphcZwog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hSc9X1v7AiNedqbqL0BxF8FsA8-i8uzpjar_vYFvl8VC2u-Cy5PhAA>
    <xmx:hSc9X_AfXS_-6SYpdEuNKrpT4YI03a6BI9opeW5JAc8J8Lv5u1QY3A>
    <xmx:hSc9X1ele6twHDXmYmtHTfSb0dDHBKhOvj6JlqUjjt57PPldJRVcvA>
    <xmx:hSc9X5Yea6ZbsSuoI4kKkwUJqxLFI5lBVL8HW_SbljkfoU0c-RlNoaZg1_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E9ED306005F;
        Wed, 19 Aug 2020 09:22:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before" failed to apply to 4.19-stable tree
To:     sibis@codeaurora.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:22:36 +0200
Message-ID: <1597843356243112@kroah.com>
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

