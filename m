Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386923C3CA5
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhGKM7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:59:16 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45719 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhGKM7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:59:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 8975D1AC10D3;
        Sun, 11 Jul 2021 08:56:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3Q4C0w
        yozH5Lh0dUzl2rvUmPmuxheNbkIv6GtFi8T4o=; b=SKMVYOhrpGqPdLTIN7bipH
        3TLpeWs9n//MaUx2C5VMztZMd8c8V9TtY/Ny28ULWpDSUicoVF9Z0k3mtHB21xjb
        ta1JDewx/DAwuciZRMvYOfepzaqA6B8ZXUNzSEGZuAAAsj9xFyh1UP5oUwjrG+R7
        oZGobMwUQxbgxYp/wGk9EUYp5lSa9h1Tv/jUjll7HHxETH7Il0rmxepQ97qt+65Z
        JupcFu17Fl4Qh77PnYgheHSHOHiiA2UZcWmVL2sQUbZ6gWAYuiBYExiub+D7E0/L
        FFi2WhOMdAq9X+WDbx7WQmxZwzk3sF//PGVQ8o8LrGYjnl0mUntIf8uA5hDyy8ug
        ==
X-ME-Sender: <xms:ferqYFURT2I84UH31tp_WF03xvMElnmzpGOCASYWv8QqCAW3ZNoHQw>
    <xme:ferqYFnbjt3M1fNVCAFBJZgqUT9d75VGcsZiBAhA_3hhwvY9gGzwvybMEHLtY1uSn
    lfkj15sT940Gw>
X-ME-Received: <xmr:ferqYBazUQquHHIizysNqK2eWC8tR9AXWDKq2ythlIOxQhnk0n5FrvaJ3yr-2pbOeIUB7gUigIOmFIqPJZk6tpQqAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ferqYIVw2jxy5G95NN8Ad27Y_oXmTGVlNx-hxMNpUodXlSXc763a2A>
    <xmx:ferqYPkq-XaFR7Hv3Tvr1TgCKKGb7lfgTRMb6ci_4Ymo5ECAPCHnAg>
    <xmx:ferqYFeeJZFmvzrLt5veLnTRhCZTVdwnZG-7JFIl9cSjx21wz_QsUg>
    <xmx:ferqYNjXbOT9DCSFDXK3QCbP6KBWL1jNf8X8Y7YCitw-e1InrrKOEFIcLeQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:56:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: Show casefolding support only when supported" failed to apply to 5.13-stable tree
To:     drosen@google.com, ebiggers@google.com, jaegeuk@kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:56:23 +0200
Message-ID: <1626008183201104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
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

