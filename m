Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F99578945
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiGRSJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiGRSJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:20 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0C32A408
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:09:17 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DBD525C00BB;
        Mon, 18 Jul 2022 14:09:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 18 Jul 2022 14:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658167756; x=1658254156; bh=Du7er5SQVhxuW3kUx1splIMx/vSJydk7q3s
        MOCxCorg=; b=4dJ5goc6lMYpkem4v7o0ERbl6Z6YhuumCMBlSRxOvFg0jvk7YwI
        sVMEMUjXtRtJAHJnnsgpocnodLF8ieMPtT/cpJQkpBs58UUG08qDLAU60JRP4aKm
        8+u7+j35linn7XIUsqxE9e8CiDJVoVfvnkU7MCZgAO1tbAw4bObe/NRCpKtrJT/y
        uceV39RxjJ7zowQecrHKgZHrhOKKv/lASOluv7HC30djWqpJEJ/cyg/yC7FHPZKC
        Nq+BpuJMjBVW0FD+5uyAXbh9cYEFaD+tlwIgXkp1Hty7a/CftjbkcltkXt0edJQU
        SsaRLtNaE3TZ6tLLGIKQRA2KQm39r/3QH2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658167756; x=1658254156; bh=Du7er5SQVhxuW
        3kUx1splIMx/vSJydk7q3sMOCxCorg=; b=XbBcUBFLu919Z6KwAfeQGFr4KczHL
        SwfOLg05B1OciMLBoBl2NHIEBcq0e609ejTlYa/gN2Ue5yUQLLTmk5rOqE7y2hO/
        eS9KMQBK9E39Y6ldIZFd1E6LJ0AfOZTjUlP4OWQYe3D9gbDWYHnBCspGIpsYk9+d
        cgmn76Zql7XYJwYJZk05ADfpWSVi78SVhIlCzdR32o2bb9nMlgz2G1kUVP97eMvw
        sHasNyN3Drr+MGZfmTtiZxKWq7tlij1e3fTSmwZlrqYr/oiamgZz/mhSjIKSlWNK
        H4RKC3PiwWfse/bi5YjgLa0da78A9D+6Ijci8Tw/koHccbrv9egEKlKjA==
X-ME-Sender: <xms:zKHVYqhLAs1vpS7xZlCHZB8jIxNmTCHRAJBx_OMmh5Fj-8WfmgFm4A>
    <xme:zKHVYrBCyRCK9nxFfrA2T32uhvEPf-1Eb66vsUF1791iCuBtZ0HMbfvkutBYrofD_
    R1_U3TnUKBJaZg>
X-ME-Received: <xmr:zKHVYiHdOwnxQg9_2uB5KIuz18vrb--_MqopiBaNT9gLzj67kuXVSXTs0ExST8faPfmrqjsz-9vJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:zKHVYjQ5eHTM9J0B2_sdBEkULiScYXy3YFWR9L5D-6Haf9SIEVpjlg>
    <xmx:zKHVYnzXyKqS5KmHtNIjw_ZUbpA8823OJdbaVRiidz69Q2d4mz5Q7g>
    <xmx:zKHVYh7EU9iEx87dzbbtFois8qbxbJI520NGQbRAqSfDWh3YJpFXaw>
    <xmx:zKHVYpuSWtfxhWv2PvI5HxpLPRusL5kgqB62GTjZwKuHkFYsv-NYaQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:09:16 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 2/5] Ignore failure to unmap -1
Date:   Mon, 18 Jul 2022 14:08:19 -0400
Message-Id: <20220718180820.2555-3-demi@invisiblethingslab.com>
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
