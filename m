Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80758578943
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiGRSJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiGRSJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:08 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3FD101E8;
        Mon, 18 Jul 2022 11:09:07 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A70405C00C5;
        Mon, 18 Jul 2022 14:09:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 18 Jul 2022 14:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658167746; x=1658254146; bh=9EVYFQs3TfjexPazUkgkLFWSM4eN+61vSya
        zDvU3JXY=; b=D3Otbn+w9zgEgOzUpLm3pClk07nfXG50Dt/6CcsQlNjM9PfPEz/
        VbuvRVBlrYrrgZbD+HDhBHLUoywquEgh+6OfGTao9Ko1zYukMfuUyIzm1W4dcPE0
        zI6dGadXxfzLNzyQLGjNjAsm2S2v4Iih7ZQ0w1p6HAYPmcne0ppKhfgnY5w3+CtZ
        zmZnknZx6t/1DTrpzWypMruZKd16AJGfKgK1dqcc/EUwuXkJpJANAkv/xjTNZhGb
        bXUrBtexNOxCB1T+y706BXIoKRvJeiBVPPQmg9eYzSqKnRhQNFORzcSYIB2zxgDA
        0Yo8pmLdFhyZugbg+JrveMK5kpXQ7YmLmYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658167746; x=1658254146; bh=9EVYFQs3Tfjex
        PazUkgkLFWSM4eN+61vSyazDvU3JXY=; b=KWVz+WBPo4wOHR+z4RZpBCV9hQosu
        o3HEjIvXLc49G0rE6pJ14HFj+Idp8hNanjbdKg0w0uXReFUVX/wDKviIOcSWH2i9
        q2jlTrJE/Y5bqUD2ObM+QJjd86FCL/fKGlHHzZSrJL+FsbJDXst00vYIieKZpt6G
        2hXepp5R9NZul/A2G6bRv/hgb+gEhTJX3+wyoa3y7gbmh8olfLA8ZXyFwLkEnq3z
        UrsbW1jYLF2faP2vQpwzUjWLsKm3pFgXWC4aXq7zFHGtjdtXMMWoVKbOGdDd20qc
        luNBVYlkia5VgIBy1e+MojiSms9YuvlUU0PmtYZuF04vNfIDh2zKOKYYA==
X-ME-Sender: <xms:wqHVYoMm7syGZ67I_8Df6HgCjmudF0d4Vpuvc7M0skGhX3ldZoPXPQ>
    <xme:wqHVYu8zupr4vNJ-92-v-YU9TS6_1a-rzHo8Usb4lAYYl4gZtyEFT7yTxVuELEwka
    -vSGoPLawUv3rU>
X-ME-Received: <xmr:wqHVYvQupUW4L8RmfamPv7ulqGIpeZcW200OD0_-XoxXcnS7XtNNZrq30efFFe6Kn3eUPNRuWPor>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:wqHVYguiVzURQRGpGwJy2nc_FjqfwbWAdEHthCXIw1RTTKtiOyKgAQ>
    <xmx:wqHVYgelTZqpGS5sXiu5H3pAf0BUL6avuviLO4c72ClT-iQtUfA_dQ>
    <xmx:wqHVYk0qrioFrxLSjULkueOFpKLztTASZ18VwOf0L1NhFvN8A1t7CA>
    <xmx:wqHVYlFlbj2XKNxQGSXoneenWCG6HfKGen5a61XS7Y9RheSK5vkg-Q>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:09:05 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/5] Ignore failure to unmap -1
Date:   Mon, 18 Jul 2022 14:08:18 -0400
Message-Id: <20220718180820.2555-2-demi@invisiblethingslab.com>
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
