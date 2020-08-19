Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A396E249F83
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHSNWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:20 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39839 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728434AbgHSNWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:22:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 14F82683;
        Wed, 19 Aug 2020 09:22:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KZTqtV
        lv15BtZgAJTBTPV++VnlD3v3Wv9bVARsCEYdk=; b=ivqlIKT3Dwl0dwv59eLo04
        8pEeH04jbU0Be5xBC2y81GpnyewJx4MKO9/eMhq6YaKKY7qyMwFXywGNoB+6nxn/
        /Dojz6sUTq39dQ7Tg6tcD1rjzPSZhp9P63yKqqPe7SWx21MrlDmUkIAGfuRK0P+y
        gT1MNymj3Vn00kUEV8SmTTa6W9OxXw0vVgWegBvm1+PB+EAZ0HmJb0DASwmqUYpU
        ryhqBkOE2Cd2QPcPuzMYeyTVw1JhFPejdmE2t0BwxR5ajCuAUoQY33hMRYu7nLrT
        Uxy8lya9MM4PeUd0YoVhb8mPTXkwoz9TPL9cL8OY9KRjp6rLFJzv7Mu5Iz1+OpdQ
        ==
X-ME-Sender: <xms:hyc9X3icI1u7yP38uU_74OogyI1pk-gavqh3eGnwghwLnmRJBh56zA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hyc9X0CLU2P4e5qEKe7mQMhgMTJ5jBsKgDYjcKPT4Ib4lPXtjIz79Q>
    <xmx:hyc9X3EiDjBoGzL6_LRx4ZIRKo7-BDigrtaRxMPNiMHD9mJR6_zGmg>
    <xmx:hyc9X0ScBSwKGZpziHTNRCxn0z48-FoQdXbDDWHnR7wJeVew7mGGTg>
    <xmx:hyc9XxvmRQFkBQvDBBZvVn_VnhfGS-EEkdtY39h_RY72uicZf3H0iPP-8uQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5128B3060067;
        Wed, 19 Aug 2020 09:22:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before" failed to apply to 4.14-stable tree
To:     sibis@codeaurora.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:22:37 +0200
Message-ID: <1597843357397@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

