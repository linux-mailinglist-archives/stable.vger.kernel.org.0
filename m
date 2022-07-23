Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6D857EBBE
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 05:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGWDoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 23:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiGWDoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 23:44:32 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B026C8049B
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 20:44:31 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EA145C00A8;
        Fri, 22 Jul 2022 23:44:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 22 Jul 2022 23:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658547871; x=1658634271; bh=kIshqhgj647286FiEwZIn8F2MuAyAKY1Gro
        0c4s+gcU=; b=JSx2PtzEibgqrkEZvGoBG8CqK+2r9TveSD7YgfXhFqGIPOCRIDx
        CNqujNo0dpXwsCZYMb77VVlctLv+wq85vt4nTZVQB3aDmLTJu4X9bMrCpOI60n6H
        Ut6f4JX2r1Wo2xdRTgp+ScdCBzvEMaDz4ECoUXV2kseUr+m8TejW+P5VQGAKS62y
        MUfynq/6Zzi9cB5MWxMkDT5jw1jyqfmdHJAOnfGvKZ7bRAqBHnGIatZ7OLruAnCw
        09IMEHA5ogA0Ni7xY5Q24+3xaJCMBz5oze2bxC3lTxRMNRwP+Xcu+G2xmJrI1ut+
        K2SE9ej2nkUynmRVsaCgYhJCJbnnaZQFUTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658547871; x=1658634271; bh=kIshqhgj64728
        6FiEwZIn8F2MuAyAKY1Gro0c4s+gcU=; b=QLHmLeMDfqL+icAIL083qO6iMLevo
        3NggKb84AMD2NMJwLlCzStS5W4tJNeNqznnJ8R6zNyxVuK88pE7RICfFZ2cX6Jh1
        BzoTbL6VST26O/6XLo0SkU1SaJ3pDx5crVPNVhC5Fi8mS/ZBhQRYKH+TVSyJ3UOZ
        4KbTWwM6s3yiQeruZ5dwanozvwnDCmqGAemsEu5wVba1KnTzgurum6krrLSf5w2n
        qvEBEzEqamTrSh092ifXcbA736Ou12PA8pasS5pG5irRRP+MRoGJokDYnJjURmWu
        UnBmPgbJULdtFxXMThGb/xL/gi1DyDA8tsNTccGkk9v5An1VghyN8GXvg==
X-ME-Sender: <xms:nm7bYjrbS9jNjBw7nbXefDMu46YSbGbp1KsJ2tTIXD4TZ7GbCbtZ4Q>
    <xme:nm7bYtqPsOyODtYH9KifjONihUQ7K310TB5Oxy0n7Y-XDagt_GgGToO6CpbN6-LZv
    h_hXtRRlPLyCBE>
X-ME-Received: <xmr:nm7bYgN0wwjtQnACIK3HtJt_IqaeGBo2o0CrDByvjIEL7Cz0gip0xLonzDapB1mSZQHCz9GObAvk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
    gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:nm7bYm6DGifxtU6PZuxoN0HN3T5cnUzFQuBm_uy_c3SqiTsIO6abrg>
    <xmx:nm7bYi6OCkJp-hpquKGgWSLKF2mgWoBWWrt5XgyNjfFAvdwAHR_Kog>
    <xmx:nm7bYuh5ihGotun_aMnTFIMzFk5iZtvcEb6-GyG6NncagM0OyxZWnw>
    <xmx:n27bYt0TVlw4gktHC4Mm_-INdehySHYfE6gwa-oHLP9e2KrcJM99AQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Jul 2022 23:44:30 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 5.4] Ignore failure to unmap -1
Date:   Fri, 22 Jul 2022 23:44:14 -0400
Message-Id: <20220723034415.1560-5-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723034415.1560-1-demi@invisiblethingslab.com>
References: <20220723034415.1560-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 166d3863231667c4f64dee72b77d1102cdfad11f ]

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not -1.  The handle field of any page that was not
successfully mapped will be -1, so this catches all cases where
unmapping can legitimately fail.

Suggested-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: ee25841221c1 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f464793477650e631c8928e85c1990c5964c2e94..bba849e5d8a7b4d54925b842fbe3c6792e0f0214 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -413,7 +413,8 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
