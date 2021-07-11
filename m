Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57253C3CA4
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhGKM7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:59:14 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50427 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhGKM7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:59:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D52D91AC10D1;
        Sun, 11 Jul 2021 08:56:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C2QwQV
        Yo7pDVGlldaNdJk0mdus3VlOheimIKG1/4/jw=; b=aX2iGJtAIxnkW8GsMkZv4K
        iSe/fMtsYyLcr/SwWfTiziwSI6r4glm8jrHKa4YPAvlSvGzSpEnT2qWcSZrZ7Rla
        pPDcsTKTg0pb8Bog79hHURBEE5WbOLp3zr4+lRrUVZAXlISdhXmcAgmoixTzfESI
        1kAMndmNvrCp5EQ3PpZSqZnw1U57OVpnxvS1uM7xlmJPc0KUvF6FvFKlqufNXa9h
        StB4EYspi6uHAwaYeoFMWS0RwrC0HRiLwsTjzsx3vVqD5te60vIPRNUG3LNr//PV
        EDmVKV1gyyl3GPXdlcRtqGNwDj/newF1zZWoVyvaUc89YeB7d8QhrVsfj+iH6AxA
        ==
X-ME-Sender: <xms:eurqYEbgfa1xT0fLR5RfE_NZ4LsZKXXFNAhoFjdFGMHEK3qyacz0YA>
    <xme:eurqYPZ9lbLbTS73KT4UdLgTqQnsD5eyVakJcYC5vhcYzCm-bNVUWzOruFJnjBh0T
    0uuI11al40H6Q>
X-ME-Received: <xmr:eurqYO_9-cIYyhdbTMmnp5JXu4oSTOU-QTDjkyH_HhdC2GvAUUVPThWDLCNOOngZCihT8HwUE0Dht2I4zvhPoxyRvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:eurqYOpEzT2hqjrI_ZWw99uK9jeFIA4LVjcorI9-4BZqgDgvigNcGQ>
    <xmx:eurqYPpXTGz26qDDpGYo3cXKJKHGE3kGtops9WZq3uNSkmatiiByPg>
    <xmx:eurqYMSt6hoNSDh0460O1evAywjAnp8X2h-7IzknvitDQaUyubUYvw>
    <xmx:eurqYOWHKfkXUslSLRve4WLTN1Q6LCFc8UA2tj-aVVZT7AJtNnvpRHzMRB4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:56:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: Show casefolding support only when supported" failed to apply to 5.12-stable tree
To:     drosen@google.com, ebiggers@google.com, jaegeuk@kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:56:21 +0200
Message-ID: <162600818162180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

