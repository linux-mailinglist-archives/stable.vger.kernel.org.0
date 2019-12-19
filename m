Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AE126003
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 11:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLSKyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 05:54:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58255 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfLSKyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 05:54:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 057A722385;
        Thu, 19 Dec 2019 05:54:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 05:54:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6tMrUN
        9B09eqW85FBoYm88tHGz7GJqaa/WE72YYu8qk=; b=aliui+9r0xIKmtvr3EVTnD
        IavuwtCmVYkCFHA+sdkI3oxW7+UtLKt0PXtvhCyiICRKur0rQ4Zc1rYGtoqVHO/K
        i6nG970XWeAFiWc1QzYlPGDHJCdT2U8Xtsdjc2OEGzhXpqxm0Wa2YawkkX1j/CBy
        V3y5BnEsgkgYCVSiG96lvT30AjkMyo6bvOqMqrChlZIFVIvWsCmCGT/OSnFYgFoX
        KHa4MHHnVFlKPy74eeB1Re4GF4754xC/gAG/J2zqBH2OLyQrQDKSaCNewvdRM3nh
        Led47jvrDpIxIZKv7eGVEdh911Qxz15V0pIYdg9ykCFMXMnAfS1BRBgy4CshjckQ
        ==
X-ME-Sender: <xms:1Vb7XQJWqligwYeVkRfhslyc-klsmU96m1_SHz4RtasU9nyjkD5pdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:1Vb7XcnrM7N2vL8fM4CUZ8JhT2Pp9cx9MJ36vhCovKw0HTPnpxr0PA>
    <xmx:1Vb7XX9FHKnNYTifjCuCi55TrMQNPa5BImQvAjcFVdfGLIHYeFGI1Q>
    <xmx:1Vb7XT7N4lceTsBYxQ4fGNwPO4URKcalaCSq3McZ_T8f7E54y5xeuA>
    <xmx:1lb7XTCHyFT5Hb0KRg-90onBlbavU6KXJsLjNLMLGqhtke0dM_nuCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EDE280059;
        Thu, 19 Dec 2019 05:54:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: smbd: Return -ECONNABORTED when trasnport is not in" failed to apply to 4.19-stable tree
To:     longli@microsoft.com, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 11:54:12 +0100
Message-ID: <15767528524266@kroah.com>
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

From acd4680e2bef2405a0e1ef2149fbb01cce7e116c Mon Sep 17 00:00:00 2001
From: Long Li <longli@microsoft.com>
Date: Wed, 16 Oct 2019 13:51:54 -0700
Subject: [PATCH] cifs: smbd: Return -ECONNABORTED when trasnport is not in
 connected state

The transport should return this error so the upper layer will reconnect.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5462cf752432..d91f2f60e2df 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1972,7 +1972,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_read(ERR, "disconnected\n");
-		return 0;
+		return -ECONNABORTED;
 	}
 
 	goto again;

