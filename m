Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206913C3CA2
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhGKM7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:59:07 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50165 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232554AbhGKM7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:59:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 608A01AC10CE;
        Sun, 11 Jul 2021 08:56:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 08:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oIwH0K
        bRhniDxK3jP322TL+7w1uT8xuyKReH9EQe+JE=; b=cp29MVC38N0yw+/5Pji8q0
        qfMz+QbpDKr+OA0UV+pCfJylOwuRtG3lWdcbsxbijOz8huFzvDp7bOYGDMwwUZGo
        X07t/B3AUMoJ3/bRNpvAdQZ4/irw9B/J3HjOPLrKkfQR2svmjAyOj+KWMwM5XT6Z
        bBjWSz3PUVj9u2qATo7PfgWoWjAj+J8XHch53zCKGLWq8R1r/m+3NLYg6he+MZ3s
        NcxZE0khjGbJFhMw2r8GJAJT/YLncSa76q6pBoGKYwyk8h11a/CCocuBuMuIusmX
        j5qJw9zpQJi/BKsqmI5uZMs3X+gYtSb+oReHwWXwJe7nHdL1ABqDKPr69WZtU7Fg
        ==
X-ME-Sender: <xms:c-rqYCxBKipYF3SzsSNcnwFmoRjWmoFNM1r78SOrGsEv_-3REx99iw>
    <xme:c-rqYORjEW8nZZg63NUof_Hw-i2bo8jHHzjEdWYVItCqvIO4oNJeccz76LOMeNAQP
    HCaIMgfIzTvFQ>
X-ME-Received: <xmr:c-rqYEW4tq-5y9LqqZYDKYy3DgUWOzR-qeP-RFxrNhzumtco_OyZD25sIzwzK7t060MLZqjMKhcDqLIQo-dmuV5wbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:c-rqYIjf2fRzDLwqIFc9fIH2BqDmAukqGQhUUe_K5659ZPf35qH42g>
    <xmx:c-rqYEAhPD3meIVyWZEr4Lco9jV8uFaktK6js8jPMQdkSS7nNpY_Lw>
    <xmx:c-rqYJJEYMAXVVbDQKNWJaJ6ebRkCTAVSIhUAayTWTq-Emkv3fo7DA>
    <xmx:dOrqYHPqwRMLW_r3peEAKQgiZuSByscgp-cw3SAtsweeQIr-Y8r2Vg6dOOY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:56:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: Show casefolding support only when supported" failed to apply to 5.4-stable tree
To:     drosen@google.com, ebiggers@google.com, jaegeuk@kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:56:17 +0200
Message-ID: <1626008177177179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

