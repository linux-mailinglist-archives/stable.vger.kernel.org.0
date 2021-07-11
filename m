Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90D3C3CA3
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhGKM7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:59:11 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45525 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhGKM7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:59:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 2F1471AC1033;
        Sun, 11 Jul 2021 08:56:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7/pLtl
        XXDyfdR4BkejE4AnMsYvMSIP31lh6GeuVJFE0=; b=m4AjAB79anzALlt/FGXukg
        napy2BoP0xqaKJtZuEjPqFMaNOWREZKX22a+kb/z44whVlvacNwWuJ6zqrBrPB4W
        0l+ZoB4Xp42Fb2NtaesRX5tZjbEIQxHp/w+EilUjCt9HuAs4ELzHPbUupdgCI5rb
        GgUydNJSHQXsEsOPRNdrHw/6APBL0Ca6xiHuSh+uh5Q3wIdcUk3C9bWNNEuplxZ1
        gxxwndM6B02fWT96THDBvqSx8SRFY8XZ4RHKtdnL/UnDF9iTj0BIdWY4ZEvMv33/
        vldN00fu1Hxf1uEtI+00H/bxR4G/MTrwDUvQk+gC+nlXUb7YPqO8ZQCAf+DjwKiA
        ==
X-ME-Sender: <xms:d-rqYNSSj0besQ8tP9V6o7arVPlxrdFNLfuCRw-SXHuecaDijut-PA>
    <xme:d-rqYGwYcoQBVX6P-hCxaxmbKk9oDuB87raOBmbHzXi6yUgjKfEHq_FXZC07VBpBh
    4mk7OoOnEMICA>
X-ME-Received: <xmr:d-rqYC3GdQlABUg8CtOEqr58fRSnQ7KVr0DHDf9YEcc3Pxte-a6sJxDA1bt0ZTu-DyLbGWR1NV6_hYSuTmAKRjm3TQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:d-rqYFA7kdNY2pc9losxjCFdBNwuufEYyTbNXgSJaR5ZfucG-XeL4A>
    <xmx:d-rqYGjlI9p6ePP27pVYMp3ytNb2DBxD89OmtwC_KMwUq53ZpH6z-w>
    <xmx:d-rqYJq5Kk542GpPi6Jsrd2ehqsUrE0c8Gj-qyec0NI1pu3ST1UP_A>
    <xmx:d-rqYHv4svvXl81QXDAzh05BBWzBPB0T6yrncceKCiR3MuCupd7_xOezTek>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:56:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: Show casefolding support only when supported" failed to apply to 5.10-stable tree
To:     drosen@google.com, ebiggers@google.com, jaegeuk@kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:56:19 +0200
Message-ID: <1626008179930@kroah.com>
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

From 39307f8ee3539478c28e71b4909b5b028cce14b1 Mon Sep 17 00:00:00 2001
From: Daniel Rosenberg <drosen@google.com>
Date: Thu, 3 Jun 2021 09:50:37 +0000
Subject: [PATCH] f2fs: Show casefolding support only when supported

The casefolding feature is only supported when CONFIG_UNICODE is set.
This modifies the feature list f2fs presents under sysfs accordingly.

Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index c579d5d3a916..62fbe4f20dd6 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -725,7 +725,9 @@ F2FS_FEATURE_RO_ATTR(lost_found, FEAT_LOST_FOUND);
 F2FS_FEATURE_RO_ATTR(verity, FEAT_VERITY);
 #endif
 F2FS_FEATURE_RO_ATTR(sb_checksum, FEAT_SB_CHECKSUM);
+#ifdef CONFIG_UNICODE
 F2FS_FEATURE_RO_ATTR(casefold, FEAT_CASEFOLD);
+#endif
 F2FS_FEATURE_RO_ATTR(readonly, FEAT_RO);
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 F2FS_FEATURE_RO_ATTR(compression, FEAT_COMPRESSION);
@@ -836,7 +838,9 @@ static struct attribute *f2fs_feat_attrs[] = {
 	ATTR_LIST(verity),
 #endif
 	ATTR_LIST(sb_checksum),
+#ifdef CONFIG_UNICODE
 	ATTR_LIST(casefold),
+#endif
 	ATTR_LIST(readonly),
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	ATTR_LIST(compression),

