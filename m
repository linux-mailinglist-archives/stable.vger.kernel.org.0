Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0B9249F89
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgHSNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:55 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:51433 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbgHSNWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:22:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7A2B2B26;
        Wed, 19 Aug 2020 09:22:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=q+DjU8
        PDgtCmeJOhT85izPGdOQy5Ws+G4mlbdqNnkXk=; b=mXgaOL0/c+DxMl4XXUqvfT
        UmF+PDQUolaTh3ybKBL42gzQP2TOLa1nZc42GONpJrToGs+gvcNVBbDbkbiD7Dwq
        SQwjgbQTsrjnevH7ocRnaS/5axWd/lnolkAFeOdBrYALN6xpBNii8o3yXrxDRV+r
        Wq5pjBTJK3irp71n99PD6ln/RKfmKoFQANfOyhO3xMXwmz51HePyH/s5M5Qgrn8C
        xjO+YGr+gx2e3EbrPIxS86koRitP+Pyp3HPverEj7t0PrI6uoBtE9HwSC/Kcw+0R
        i0QySQuVwY55y7XHPbo/rLAGaU9CmWBRiCcL1V4CmUPNVC+23xrToH+dBTu65oNQ
        ==
X-ME-Sender: <xms:oic9X16x1p8AaDAkno9GjUwSVOLk7adiJMkgnEQBc6z9wC7T8B_3Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oic9Xy4VYkBk1dJDb1U66u0GKoWYSdMmLFuA7PSNtxjfuZ4p6RIrhQ>
    <xmx:oic9X8ewkuoZIFYvEbERgHTc1A92RvS4gu_E1IHGYCuJxWowxJCPGA>
    <xmx:oic9X-J6n3khuFXqP_mdfjt2pXAQOhhjoD2cCuqBCtEqYnx8ttRowA>
    <xmx:oic9X8l_Nkm54B-a0xjwnzt85hZnZbzNka9H3a5nBZWFtVwc2D_YdWpISUw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0C8930600A3;
        Wed, 19 Aug 2020 09:22:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate modem blob firmware size" failed to apply to 4.9-stable tree
To:     sibis@codeaurora.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:22:57 +0200
Message-ID: <1597843377191134@kroah.com>
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

From 135b9e8d1cd8ba5ac9ad9bcf24b464b7b052e5b8 Mon Sep 17 00:00:00 2001
From: Sibi Sankar <sibis@codeaurora.org>
Date: Thu, 23 Jul 2020 01:40:46 +0530
Subject: [PATCH] remoteproc: qcom_q6v5_mss: Validate modem blob firmware size
 before load

The following mem abort is observed when one of the modem blob firmware
size exceeds the allocated mpss region. Fix this by restricting the copy
size to segment size using request_firmware_into_buf before load.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0xd0/0x190
  rproc_boot+0x404/0x550
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-3-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 7826f229957d..8199d9f59209 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1173,15 +1173,14 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 		} else if (phdr->p_filesz) {
 			/* Replace "xxx.xxx" with "xxx.bxx" */
 			sprintf(fw_name + fw_name_len - 3, "b%02d", i);
-			ret = request_firmware(&seg_fw, fw_name, qproc->dev);
+			ret = request_firmware_into_buf(&seg_fw, fw_name, qproc->dev,
+							ptr, phdr->p_filesz);
 			if (ret) {
 				dev_err(qproc->dev, "failed to load %s\n", fw_name);
 				iounmap(ptr);
 				goto release_firmware;
 			}
 
-			memcpy(ptr, seg_fw->data, seg_fw->size);
-
 			release_firmware(seg_fw);
 		}
 

