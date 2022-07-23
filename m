Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D24457EBC0
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 05:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiGWDob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 23:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiGWDoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 23:44:30 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0CC7A525
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 20:44:29 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D1545C00AB;
        Fri, 22 Jul 2022 23:44:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 22 Jul 2022 23:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658547868; x=1658634268; bh=Du7er5SQVhxuW3kUx1splIMx/vSJydk7q3s
        MOCxCorg=; b=BCfGo0YGXpJJWQLnZlFcCYNqz0PW4gLDxZ0brfHPJ1WKGupvT9O
        Lgyzb0mQhjsxfvSUk4M2XagIVT60vPH+OA0sxRBdk5aRk4e4KVuMBW7POIcQEX5N
        YRawmPVgPl0vFLttyk1tTpr6LvkXsvVajtMSqwGAKguuavNcRVNX7nrO7Tzk1hdd
        24sve1DGEYVmm4UgVG2agglRFSIU8dMSYhFKDsGU7gU8yg0jwDVVdwJTGJO7oWKj
        GUj6k8xDrNFPZCdkUK+AcPMvBmT9PPKncpGt5rOShan3hRqIrMaTSfV30+WjZnpb
        NcSIy3tD8SmSV8al98x24Ya5NxIyfC4PapQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658547868; x=1658634268; bh=Du7er5SQVhxuW
        3kUx1splIMx/vSJydk7q3sMOCxCorg=; b=JQZZ/tAL35rpY/iPYzDQl8unwVHG+
        bEdFAwYP50vYxfBAmfg7+BrlEMt11rNQ0aYIEcdkr9jUtfoXjfTTjE97GRRfws+N
        wysZ55j2rPOxYwLFpRNpRUn965fq8R5gIsF9dEr1UZWnIHup5w8Z5npB90I0ypxq
        slkSjPiXWwYXRu+AE7XKHLG/4bmXPgpP0Yk1OhGn8xDr3x69Qhdg6VrCVml8Pn9Z
        D+xFc23ouETZHFdqbebiKcjpuOUunS/N6LoSCFNf5uXqlIq21tV4eJgq5dr1EN2a
        SVVeJ7F8H0oIDxhOyueLqRPdS1XYKMAW3e/BGZLjt3wzWvw5LdJFRWJIA==
X-ME-Sender: <xms:nG7bYrk2XT-mo5Zg39yuqoUYsBuVT7soHiUknX5CX8N6DlcFsGRCeQ>
    <xme:nG7bYu2eXOJeUB59l0TFHqo279aaC5GVQyuoayKlfZRnVt2mApQnIHvr46WsiEGSW
    oZNKpNwENAHbuw>
X-ME-Received: <xmr:nG7bYhrxFJheyRdgZAucXQaC0CdIfzuaOX13p9eK2ML5dEiKRye1o83r_CvrhV-2HT7lR5cXBhGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
    gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:nG7bYjlwY6a6vMRSRXzKnVPEmieBArCDUHFxBK1xc01nzHlXwemiTw>
    <xmx:nG7bYp3C-U3fiOLyTNeHQhh-OYaoeqR02NziXN2yeGwCE5P0jDCx_w>
    <xmx:nG7bYiuH06dMv7aPKN1dsufcmqB17wk1p4K8bVQJYWMpAns_IuhOvw>
    <xmx:nG7bYkS1mWXFKtVbH16m7Rw5X7T4mEZaRt2X8avaQpB2jEqSm8-HtQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Jul 2022 23:44:27 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 4.14] Ignore failure to unmap -1
Date:   Fri, 22 Jul 2022 23:44:12 -0400
Message-Id: <20220723034415.1560-3-demi@invisiblethingslab.com>
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
Fixes: 2fe26a9a7048 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2827015604fbaa45f0ca60c342bbf71ce4132dec..799173755b785e2f3e2483855f75af1eba8e9373 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -393,7 +393,8 @@ static void __unmap_grant_pages_done(int result,
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
