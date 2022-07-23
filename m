Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6214857EBBB
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 05:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiGWDo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 23:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGWDo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 23:44:28 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2F977A7C;
        Fri, 22 Jul 2022 20:44:27 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DE2435C00A8;
        Fri, 22 Jul 2022 23:44:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 22 Jul 2022 23:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658547866; x=1658634266; bh=9EVYFQs3TfjexPazUkgkLFWSM4eN+61vSya
        zDvU3JXY=; b=RcBEtNP8oYQgdE7PhROvqMVJnmJebGH9Dxpv/SnrKBJk1fDlr1v
        fZgw30SFvmeZbNGJCV3k5YwBly3Ik0M5cDx8Si33qIyKNg3uaG3xPQ27/+JLvfwS
        VvDy4Lenhc8igbigKtRiQmg+ojnjnyDBG70Ueo8OZZhsXioKaMQgnZYR3erfwXKZ
        rqUOS2AAMVbPvQ2pxBxKdtercd7sXCV2I/gxt+dlI92XaawMv+aIsENFQX8/sRNT
        3f9mHVsKt/XthsHhiCjnjdaQBK0uOHYF/v1pC48hzRv+YRYgCI149TP8GmugOypp
        r/DzRapvNBkF7KsXTlR6Ni+4re4tD7/ytQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658547866; x=1658634266; bh=9EVYFQs3Tfjex
        PazUkgkLFWSM4eN+61vSyazDvU3JXY=; b=Y/A0P4Tc/sW0dbP6uJYXE3eVZJQ1E
        rtbAL/RtaQhhliRjoxxYyHKVGpxcAmDpAf8n4bT73/d3kbJuRaBKPrxMh9K38E35
        1OB+14RaUsVux01fx9FB7JNlmUh2JAsxuTuDRxrG03ALZr5TDJJpcu7lxoZAhDKU
        dDX90LldNTeBcW3qttqZTPZ+FKDP4dtQiLqPw5p8pqshnMw9f4Yy6XZ18B+iwLYT
        2Z+LjCQabPi4MftzQmGj4x5lOGsGpnCJR/KbCVp06fgumYWD9CLvqakJN1VRt1+N
        kw7HhV5ZSM1h/nLn3PCbXt6hz4gGaPD9swFyB155/cA8q1QfBpGBjwo9w==
X-ME-Sender: <xms:mm7bYlifrfwiqP6Eofstz2tcMXFdkTOkxhITL8mHS9UcKjaFmy57hg>
    <xme:mm7bYqAELBC_seMCrcWT8S8O8keJhKCneeFAybJbTFbOH_yQR38J3CvtJKljGdz7_
    jQLLT9wG6M-5kQ>
X-ME-Received: <xmr:mm7bYlEQxmkJOAc7QR7nP_jXVY3f4lE8BTfs4G-3uOlT3RXMVm4ELAF2YSgrJwzPvBrycRtOtZ5s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
    gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
    lhgrsgdrtghomh
X-ME-Proxy: <xmx:mm7bYqQkjYnHgxLSmK1-Qd4BoLcndVGukJH4M1hB-NMEiHzvkp5cZw>
    <xmx:mm7bYiy2d5v7Wz8YC3woQOpp0ZjG0XaUBTSnAd3rf3nBm2zazrUsfg>
    <xmx:mm7bYg61GlnDmWZrIuw5t9cmmRguh4_ET4UkGLaFcHu4pHoCbbbDpw>
    <xmx:mm7bYpq0QN_InW8uGxoBnzhUmlI6S7nf-JBWwIoEaSvSVGmXzXakXg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Jul 2022 23:44:26 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9] Ignore failure to unmap -1
Date:   Fri, 22 Jul 2022 23:44:11 -0400
Message-Id: <20220723034415.1560-2-demi@invisiblethingslab.com>
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
Fixes: 36cd49b071fc ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2c3248e71e9c1a3e032b847d177b02855cdda1a1..a6585854a85fc6fffc16c3498ba73fbee84ad6ca 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -390,7 +390,8 @@ static void __unmap_grant_pages_done(int result,
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
