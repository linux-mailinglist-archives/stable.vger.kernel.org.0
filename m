Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D66249F8C
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgHSNW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:58 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56363 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728434AbgHSNWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:22:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E1264A6F;
        Wed, 19 Aug 2020 09:22:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kHubnn
        eKAquqUr2dnh0zwQwV2K7VPXyWdi8xbx2AXgk=; b=FhqX0gXnx2CzVHV6UmNDLg
        /0AcjUIreO0cGs98UBSEhi9UmHpuU0jb8Z0XL4RlP6zYHAvOc/KT6h+mPfPeEOru
        PSmPd9ALACLZr//1ZfQashv6reKQ/fJGwfh9zBCvNnA414VWCm5+hgf4dv+dOk3N
        ZWzV/jLLwtWrdYwmrg7ceOMt1i2MsUuReF1dJW9ND7CUVvfITyIxwQBVLigpxWYe
        fU84HJ0HJVR2seyQjrUx3e8teFyMWmET66Vl2qQwmqrrHPrqMqqiq4M43470Rk+B
        3XL04VRL2TWpzoraswi6PSc3Iow18l3ryBxRbAzhTX+xU9m+ILQDyAwAw3XjJWTg
        ==
X-ME-Sender: <xms:mSc9X7I6vG533mUh4SzzLg7k7GHxZ07dSKKsx8gLMQM1ty7IkyALIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mSc9X_IF7wL0ioSQbDa2z1c0aiwoQw-NjoGGW5BtyFax5Cc_5EX27w>
    <xmx:mSc9XztMlU3uJGp3Jy5VFPcSSjTTX9ZqtbcZuVVDFspoWBuMJSlzmg>
    <xmx:mSc9X0bjVeASaRqIfiSnMh22pou6aAOUB89Utmi_e_Aq0SdDFfvsqw>
    <xmx:mSc9Xw1FP2-Z3joAgEJJpQCm_3p9yGe_oymEbwVaP0hVerh4kEGWQYT_dnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 254AA30600B1;
        Wed, 19 Aug 2020 09:22:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate modem blob firmware size" failed to apply to 4.19-stable tree
To:     sibis@codeaurora.org, bjorn.andersson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:22:56 +0200
Message-ID: <15978433765775@kroah.com>
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
 

