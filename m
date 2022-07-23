Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E2B57EBC2
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 05:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiGWDoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 23:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGWDob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 23:44:31 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A58796A8
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 20:44:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BBBD15C0110;
        Fri, 22 Jul 2022 23:44:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 22 Jul 2022 23:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658547869; x=1658634269; bh=zetN2Gdm7SQF49L9d/RaHd27ZFZZJEqIZva
        4v9uU+Uo=; b=WdkjChwxrvlfemtCy+k8/LlCUSTcWbbPu7lJgsih+BAixvKhuH7
        4JHWJsFBa9X929jnbwN84wsTwWd/7kkK1yFmp9GInuuk8K4Ot0xSOw8lmkhByc3s
        6f32V5an7x2f7AEXfgvlsV43LLYH5Wsi6shrT71O05uzyyg3mTQgF70hRWdxF/up
        nMKSR8xCGb+We4tWs0E4zl7a/2lHGE/SXeME+IZmY39ORV8oBzZuaLXs0hO6h2Du
        QJwdczqlmS01z9+9BllO0buWCrZhbWlax7e6TV3hTlMzoOH0+E7mawIqEbsQ/Piv
        WyIjHwcnXgOVHEf8JKBonVyUoCHG9IZ9/Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658547869; x=1658634269; bh=zetN2Gdm7SQF4
        9L9d/RaHd27ZFZZJEqIZva4v9uU+Uo=; b=MXr/yLrlk0Yd3w8l6zkGqUFCBb99n
        QKdhJAjm5DP27t8994iPVdFhjYnAuctrPQ0Hoe4CC7xX7CoAzRNNVa3VRk+WtOtX
        jb0e7IAdbCLcDckMqUGNB3sOUKAFzdjqdQ8wWZo/ft1QPluAFioaGBM6qXyvc0vF
        Te3b6avTwX5qNmb3YkRvddUpRZwBjQNCDcHdk7QgQNNx+nGSYlMYkJRvjEhkOSAt
        E35uE4yL4duH69ooN0RPaqL9dg6f92ARYcqAWlWNrfgCG8ZdrXCbK5FjeBRKHBA5
        X1sU/+KcVs3VjIWzh7BhaEdPUKYpK8wrEVRoI+GfW/EXtstzrTgHTF0eA==
X-ME-Sender: <xms:nW7bYu9a4kus90GP6BrAP0nkSzrJvF6AJF0ZllvGe2g7G8fiZir7Kg>
    <xme:nW7bYuuNXQvAnWNN0i32pCAuPugzsZ7qNL5wGJB335wtw6ZRyZalY2YAJUFLX-bdG
    UWs0jJPObt_uUQ>
X-ME-Received: <xmr:nW7bYkDnWnpa9X6ZMGyruSl8ADwzg7nnYNqzX2eP_Bk0FKXWffg4yeHz5y22jY95BOtItTeTSSy5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
    gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:nW7bYmdiW7hOcgPNLJpYuLTbXOvJPIt-dUVKV2Ie0XditYvz_ek_nA>
    <xmx:nW7bYjM0id4Ge6gAw3CfTJWL_8UK-uuO1-P-25biG8pgvtVX49--OQ>
    <xmx:nW7bYgmoO9_FU1g-aR4NXanIOpC52eRFvern9oDIW4vRBhQfEZTwug>
    <xmx:nW7bYoqyTLWhq5nRVY_9zz7tEsePFRivklGsjjg95rjzued_-Ln1ZQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Jul 2022 23:44:29 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 4.19] Ignore failure to unmap -1
Date:   Fri, 22 Jul 2022 23:44:13 -0400
Message-Id: <20220723034415.1560-4-demi@invisiblethingslab.com>
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
Fixes: 73e9e72247b9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 492084814f55d8ed46d2d656db75b28a91dd7f06..27d955c5d9f9076266f77b9fedfa1a6a2ba08f56 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -416,7 +416,8 @@ static void __unmap_grant_pages_done(int result,
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
