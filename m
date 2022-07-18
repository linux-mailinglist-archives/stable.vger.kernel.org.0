Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B1E578946
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbiGRSJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiGRSJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:21 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2C02D1E2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:09:19 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C5BA65C0136;
        Mon, 18 Jul 2022 14:09:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 Jul 2022 14:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658167758; x=1658254158; bh=zetN2Gdm7SQF49L9d/RaHd27ZFZZJEqIZva
        4v9uU+Uo=; b=MyGqT2z9GBTFrKYQ/kjsuueYUB/qcbvKvzqSkuRT/sH8woIPgVH
        As0fUMduWrZ4wCc/Nurhl17cSHwghbe+q5S+U6A9C5iSX/Vnv82sNZEBrJjNA2Or
        0dIrt9jPrmG2cSDgk91g35AXwYDehPBMRIrUfY05zsu57U3gl6o9aYIslsaNpu14
        wBasI0U/q0UZlyiuiMvciVFRuS2zXFSRQH6EQUVU1osNxqdMpzvvACHBb4lbMUYs
        /QKOSppcsUPjJd2opPcDsgwZbB17ZTc1+AX0um88hKDZgnWtob68GS9mnRvLHNvc
        7LMJv45BxxcHJ92+P5KNZ27U2CHyLI7T3zA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658167758; x=1658254158; bh=zetN2Gdm7SQF4
        9L9d/RaHd27ZFZZJEqIZva4v9uU+Uo=; b=hChnZsCnCeM7i5qyYiHA08uFDvtS1
        RmChDdLXcnweH5uJl5gXVt5moXdW13Y3A9CsIasGtrUs828+1M5mW9qiiG0vd7Yi
        d7lgPt3/QJLuw5YWDn76zYgc1lnJdMGVyPj5jRSib6bB8auTuK3PqQMJxsEH4A7z
        HuJgU1M4RFdYoNB3CZcj9Rfl2l9MD2oUgY/dMAvtVLAr/DCu6Iqz/0Oi21M91eR1
        0tAA8uIeeD1z6KjiaYvIap+7mzeihX5jNXYto3x2upBukbgOMMIMHuEiDAkgAPhm
        yiWqH0usd5hKx3Lq0z6GNgWoOEgvfu97NQIH+LUDEKTTUbhUH97DsbT0w==
X-ME-Sender: <xms:zqHVYphSD1nSPcrjuWhXYEJ9jEcH5T21zncHVsbHglUW3WC6mFaaFA>
    <xme:zqHVYuDW0OtzhVNfwKGI1Zcb9yXiR6cEHjbpP0nbuq_jSQezTFBUmv8R2yTGTwK3o
    IWSPmrdoofoin0>
X-ME-Received: <xmr:zqHVYpEV2VbMNnjDdrl3MD2XTZbeCU5UV-KgSDTSdT6K3Q40DeWa_Qniq5MAGdWokPqjLwOBdhSU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:zqHVYuTgXejzC2BU3Gf1cUeoZX5jRRR8__E4bZs0JPQjZKUoHvSnDA>
    <xmx:zqHVYmxdeY58J5cTXPUv01V7ydzfpCI5tx47ROkhV_id1i47S_VUAw>
    <xmx:zqHVYk5rEvxO3y-9hQmrJWCt_vLy47bnvihVc-e0CDlpNlA6NSAViw>
    <xmx:zqHVYgtgzUifzsg73I53O2w68gkBsIJq54YGyJMzmMnFTj7M_q0iyA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:09:17 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 3/5] Ignore failure to unmap -1
Date:   Mon, 18 Jul 2022 14:08:20 -0400
Message-Id: <20220718180820.2555-4-demi@invisiblethingslab.com>
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
