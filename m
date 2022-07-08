Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1156BFC2
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbiGHQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbiGHQi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:38:29 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567B3B35;
        Fri,  8 Jul 2022 09:38:28 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1664C320098A;
        Fri,  8 Jul 2022 12:38:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 08 Jul 2022 12:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1657298306; x=1657384706; bh=SHamRkjqTyAr3nH7T1rIG7+h7aFHO22A/2u
        vJRAbcyU=; b=WQh8q0tluMw9RQlOpOae4YI83RM8QU8J+8n2r+/162ToKKVqGPr
        +m4PTB/UQENz4DC5MmyuXUaOvzypADYc+z8OYanM9BHneOqUH1y2cR/yA/jjJZKZ
        AGEHEJWRHHkmQX5la9T+dDEnHbJYco8+JL25+SfgV+jVTdXvbFsJLiUwccbEy/Fr
        yPt2OdUpsjnk6riecXMCxQUS6y8ncL8uLnwahcSHGp/YrQ5PbEdayrOoZ9rZiJ96
        zKFIlWSUl+9luYQVi7K/t2TJIouNFOiu25n7L2XN2PSVYeglkzxgVcgBLJy3/t/Y
        4pdRlsjt6E0iQ8KTXVCw65K+umfe1DrgGBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657298306; x=1657384706; bh=SHamRkjqTyAr3
        nH7T1rIG7+h7aFHO22A/2uvJRAbcyU=; b=PLBy5hHeQZcX2ypdyoj2GfoatrTHJ
        EAVwFUWZywMm5VL0vBpSTX9uZvjIrnZFnSg5SpFmDrgEVRpodVTkKK2BuMuvN9E5
        H3hH0ljuYpg5kNju1YKYZO/gqq/7IVc3gZt5Rxpg2calW3xutUJ4e1dchS76ko5o
        LKZem2LM2ssL3FhT5HYcAUev6cDq0SIvy2cVg3n37POMJtIukAJJq9y2nGhAMPE4
        HFj8G0Sv86v5Hptzvgrc4Nw+2NdFm6kPxQtQS001UOHz+H7DxGaFbr59/wwboQCd
        v0oPTHC2i9LC7eP6sJDy59OmctvzeDvr5bNjnnzM8swr/wOPQAocylU2Q==
X-ME-Sender: <xms:gl3IYkTNH9zgBR8X7Et9XR1W48n4SwDDCyURMa1PGGogJm0Cmo9W-w>
    <xme:gl3IYhyam8aCmXIphD6J6K-jeyeDzNpq9XiFFrnaghmsGIuN76b_b1OB6vRkloG3V
    9gXBgOUCyIHzc8>
X-ME-Received: <xmr:gl3IYh0e5q24hTxirTUQ4nTsQ6OQ6BMZR9Xr49TCY0ThekcFPm9HA3JwRF9rvlTy2U1PjQgYwwpF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:gl3IYoBMqPdUd1O8eET6i9gv_lBwXEoyVkrW-K9xpF_MpEjQ8zqj4Q>
    <xmx:gl3IYthWp2neFOKC8y5vYzb2W00T0QU15VmvF_5BFGyGFayd6a-lbA>
    <xmx:gl3IYkqmTDTyRfygvFu_XjlDuiBsvBaoE_kmDuJzJcVDHEoaDBwDsw>
    <xmx:gl3IYoUL61EDIhUazUsMdM3OAoZDveAjrOphULAlUQ7p2-e9jQDlfw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:38:25 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: [PATCH 4.19] Ignore failure to unmap -1
Date:   Fri,  8 Jul 2022 12:37:45 -0400
Message-Id: <20220708163750.2005-2-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708163750.2005-1-demi@invisiblethingslab.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not -1.  The handle field of any page that was not
successfully mapped will be -1, so this catches all cases wherr
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
