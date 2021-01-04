Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131672E966B
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhADNxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 08:53:49 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39945 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhADNxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 08:53:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 35D01E11;
        Mon,  4 Jan 2021 08:53:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 04 Jan 2021 08:53:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gXVdhV
        Q4dgbv7quKI8tTu/j6gv8gEZd2IPDDiN/Zy/0=; b=POwaeJz3hNOehtyhk9KTwK
        MfwUMsxtyKH5rYTD6TL2mKcvb0/egewZTKQxpZ7Gyum016jrEITi6R10lWdrK7ds
        xqtDz1nYWxXtNKV3kY8ym1GQXpbmWhgG67WGXlJkYcEyF/EyZeLdmMZFiTC0dHLa
        j+3uGspKBxeOhVQ2J2sO/68B74gTQDoRgpgcq9IkKxm4ReKcNlANHlbiI32L3VNH
        pX4vPnIVHEKW5x0mLEcq1nFT1VXWVORiwQuvFHEsA1sh5hKrjvcCkfvFP7M4eg2X
        pTt02Nx/zYso+0FpM2c0PpOwgFvD6gJ0nt47+BSWNuRuoZr1vq+lUdZ4SeeCwbpw
        ==
X-ME-Sender: <xms:vh3zX_A8Dp2B4bA--lQFhpYEYTqTggyLhFnB4v6EiHudX4PhDxsagg>
    <xme:vh3zX1iuBT9AfWjj-hXYNVSq4LjrOyXvt0sAJdSPsRPuy7PIqWfc0G7gLfjX50qhV
    l-z2HjD1zRqhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vh3zX6mjjvAP2Tf21YKr1SztS31ZSW0A_0h2TBEy_S2kj3UFur8j0A>
    <xmx:vh3zXxzxdEah6fO3XY-Iu0HkfW0GK89Z3HwIeE0_blt_u1zqQq8giA>
    <xmx:vh3zX0SVfdqw0H1OpAJDuHd76FAvMLhV-CewhlPmsi0s-TpVkmbd4w>
    <xmx:vh3zX_KDNg9g6MZwmoefWXMiHVpm8Ci6kymFKPHWaUssraiNb8HQzPUt8HE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2F81240057;
        Mon,  4 Jan 2021 08:53:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: ufs: Re-enable WriteBooster after device reset" failed to apply to 5.10-stable tree
To:     stanley.chu@mediatek.com, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 14:54:28 +0100
Message-ID: <1609768468110187@kroah.com>
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

From bd14bf0e4a084514aa62d24d2109e0f09a93822f Mon Sep 17 00:00:00 2001
From: Stanley Chu <stanley.chu@mediatek.com>
Date: Tue, 8 Dec 2020 21:56:34 +0800
Subject: [PATCH] scsi: ufs: Re-enable WriteBooster after device reset

UFS 3.1 specification mentions that the WriteBooster flags listed below
will be set to their default values, i.e. disabled, after power cycle or
any type of reset event. Thus we need to reset the flag variables kept in
struct hba to align with the device status and ensure that
WriteBooster-related functions are configured properly after device reset.

Without this fix, WriteBooster will not be enabled successfully after by
ufshcd_wb_ctrl() after device reset because hba->wb_enabled remains true.

Flags required to be reset to default values:

 - fWriteBoosterEn: hba->wb_enabled

 - fWriteBoosterBufferFlushEn: hba->wb_buf_flush_enabled

 - fWriteBoosterBufferFlushDuringHibernate: No variable mapped

Link: https://lore.kernel.org/r/20201208135635.15326-2-stanley.chu@mediatek.com
Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 08c8a591e6b0..36d367eb8139 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1221,8 +1221,13 @@ static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
 	if (hba->vops && hba->vops->device_reset) {
 		int err = hba->vops->device_reset(hba);
 
-		if (!err)
+		if (!err) {
 			ufshcd_set_ufs_dev_active(hba);
+			if (ufshcd_is_wb_allowed(hba)) {
+				hba->wb_enabled = false;
+				hba->wb_buf_flush_enabled = false;
+			}
+		}
 		if (err != -EOPNOTSUPP)
 			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
 	}

