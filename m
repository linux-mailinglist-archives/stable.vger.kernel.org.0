Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2383578947
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiGRSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiGRSJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:21 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6FAF583
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:09:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 498735C013B;
        Mon, 18 Jul 2022 14:09:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 14:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658167760; x=1658254160; bh=kIshqhgj647286FiEwZIn8F2MuAyAKY1Gro
        0c4s+gcU=; b=p7zAmQtT9+CJjEyLPQ+PxSOJn5fhxPBbVLVhIAVWUZ73lievbgn
        CCqgqUru/ZzrVEMSEJF3C8JE0wmzWkevqvM8D2SoLWkbN6pG/A6IBvQ6KR+AZhFY
        c0OFwPViWbdkCD5KXHx6OfGH2rzkQsmekmjV/XkChERbIcXQ2kyi3Tkg0LjzPVjR
        hRsgIJli0KCFZnftCBch5X2ork23FTC+HtnyG65Ga/5KTtXAH9S+xlOx8rQC0zx5
        6ZZpw55H0OOhCpIgucHla+ZeQL7Kpsw+IipYPdtMnD4hCroe9YLBMJbyI46SXlqr
        XChU92pdUlY3U+RakilS+oP2nrjZ2n1+dmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658167760; x=1658254160; bh=kIshqhgj64728
        6FiEwZIn8F2MuAyAKY1Gro0c4s+gcU=; b=JGVp7CSheLaV6MqKByzzgQEho/X9+
        KVrjZo3uBqMf9X5/vmx1BKgc5+lVGScWGKRLQ58tG9OSOyyIHXCeKdbvG89l8sfy
        KLlZPhmW/ocIZU7y+wKxANBEOmNhDt1SgELYmxuv6OHSNw0qJ0Ad9C8Yi0gTIjXm
        RmAR4zaHszLrvJx0Bay92XrxckkbfdcjQpnPIGwKS7I6/HzZSfNiBMH2Q/CpaLPM
        yqEcL61dihtXpzupcv7vC0CSFkK45wxpSIZwVatsxNfO8GeZlGhP5Jb4npEVGTZl
        OPxvEQlGc+xuiJLfBVT1kcHfs8QBzDfXU5QHVfNODSXCiiB1wAOuS52DA==
X-ME-Sender: <xms:0KHVYiziIHvB1pi8xnLzZXzYK6ipJ55JfsWoVGQsv1J7FiGUz4pw1A>
    <xme:0KHVYuTwueiXRSoQP7doQOh68pkVTYKn129Agb7d078SCZ-tS-P-L3xi7vgs1tAH1
    aw7GgSdLJmdBSk>
X-ME-Received: <xmr:0KHVYkXBKOfD769T9Zhj6aOsH_NH12yv3h-DuafP0cqtEUIngrvZit-ASjACcjjcQJFFs36A3UKh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:0KHVYoi0fVCsMeZcNg8CRhTCuWT7rTIqSsWFNoHW2hNh-smkkXlUcg>
    <xmx:0KHVYkDSW8-78-ec_pwQQXg4xP_xM4sC2JVbE41b6hsaHRFn8oU4vQ>
    <xmx:0KHVYpKh5JyF-INa5aRTMpt2umnD-_wkIlhMQihwu-UhTHfVv1ewtg>
    <xmx:0KHVYn9975L1yeESP7AGLSAEcFkbuKMu5HYxEyQkaplggKdTUiAECQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:09:19 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 4/5] Ignore failure to unmap -1
Date:   Mon, 18 Jul 2022 14:08:21 -0400
Message-Id: <20220718180820.2555-5-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220718180820.2555-1-demi@invisiblethingslab.com>
References: <20220718180820.2555-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
