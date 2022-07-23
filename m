Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990D357EBC1
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 05:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiGWDoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 23:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiGWDod (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 23:44:33 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E9D7A525
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 20:44:32 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5978D5C0108;
        Fri, 22 Jul 2022 23:44:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 22 Jul 2022 23:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658547872; x=1658634272; bh=flbY27l8SG12tvSsNQqmUwpFJSmusaEnV0T
        4ZJqcCMU=; b=xF4f0386+BRstwpc3+9vBKw9cvhM1tkQkF858TzC7uIOjLlSh34
        ORyX/bAT+dAnZ0/VdteC2jCowbUkQI5PgKFTYE9bLM+yHsF9Btjp/3iKqU9B8ui9
        SdVaFifm473sHXZJK9knjbYjCi2/z0DoCMEga4ty932Xavn/qS4i0ZZqt5INi8al
        31cl09EsRpqJiMQ9b1wVDBufJvSxOwKwB9ygLy/BfeEm6Iczsmztv2GuscMLuJba
        Ud7vftBpuB7edh5lUpVhU3gDnyixx9wUEDKvEpPrx//atq1e/ZHOjLzukR7CXznl
        j/09Iipj7aIrGvr2Wg4rQetAvqbib3IAnKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658547872; x=1658634272; bh=flbY27l8SG12t
        vSsNQqmUwpFJSmusaEnV0T4ZJqcCMU=; b=qgzR+RglHcHc38yEZClE9b1aX24dd
        Ri+tHGKDYV0ifeqntUra/V2HFEKxn8C7ECnCZ7qhb/EGnKdqMngBdJq2iETQcfC2
        itYc/6Sj2tiCQUJ28ARkOk9nCPUYA+DV2UIhlz8SVM5ByBEj6dbmBDKq38201drQ
        b9NAYSS5jtt+ING60a7ts/jKv/64EevwNsKkU69tg/YBlUdh9jntqQp9AKu4f7xm
        jgEoxmyPLHgUB7C1KQkHXsFN4O64l6H2J8wHVCNx/PtYbhu1EVm7gxrBT6X+Lagr
        0ZXkYDO70+1d5YjACDcfkdbMtJ4+xKSRZLt89jAFi9MVdkMhuOjcxUzIg==
X-ME-Sender: <xms:oG7bYgjBsEh__ha86Rwl-3SleWOXee2RVYZs-kLLJ64vSz54vV6ysw>
    <xme:oG7bYpB8BezFACfqdStqsNwRMe6YVzAkxg3Y5VF3APcHnD9av6Pv8dFXNJ-nEjZxc
    fRJ00CIaPkzwjY>
X-ME-Received: <xmr:oG7bYoHBXxgunV-n56vpTtXs6uzW4RfMKCfIRzzL-rce9wkwojnW-nUM2fnzh_On2Cy-NsO4AtpW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
    gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:oG7bYhS2bu6w5CknwsGrY-8p1_a7EEHBX6NfHfVyeFl2wuqV5RDlIw>
    <xmx:oG7bYtxCbWsWMCwy_ZEf5GDcTd8mgaQ2cd9nn2q935hDQDEVVfv3BQ>
    <xmx:oG7bYv67TdOoAxfoGNlgrZgx0JUHHixxw-af-ajhF6RsZqhHvTB6XA>
    <xmx:oG7bYvtIx9tTxe9Nh00jqucQ-mUmM8b-fm8LvQoagnWj-B1Zpj56oA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Jul 2022 23:44:31 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 5.10] Ignore failure to unmap -1
Date:   Fri, 22 Jul 2022 23:44:15 -0400
Message-Id: <20220723034415.1560-6-demi@invisiblethingslab.com>
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
Fixes: 79963021fd71 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f415c056ff8ab8d808ee2bacfaa3cad57af28204..54fee4087bf1078803c230ad2081aafa8415cf53 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -401,7 +401,8 @@ static void __unmap_grant_pages_done(int result,
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
