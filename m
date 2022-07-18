Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E634578948
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiGRSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiGRSJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:09:23 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561211F2E2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 11:09:22 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AF2185C00C5;
        Mon, 18 Jul 2022 14:09:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 14:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1658167761; x=1658254161; bh=flbY27l8SG12tvSsNQqmUwpFJSmusaEnV0T
        4ZJqcCMU=; b=71MPLL0NWx9kTocP1rKjbOI78zXLHdgL3p6pHwlND3ZNdqwrV95
        95VlL1cRX9c+y4rO2EefucIHkGNdJEwzGdKW4wOACzAsHTH8BYQGhXi99BJInVJp
        ZZBqXo4JJZDnkqPDA0dumkKWUi3chW6cL37v3wJgjsZpa2ASIUM4XcJqPLWsxotD
        VYb4liCDOqpLPisWVO/7buk5oZfWO390LIVdAJNVtsZvVkL711oKBjH6Art06DXx
        9vvTQEBVfCuxfgfDxQlthGRogmgEqlJ+iYoUaVTNAY8BB/1Tt8bg82O+lrIGj+r8
        1pVfu09UxNT5qs9/GaD08V4T/twa8rWXe1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658167761; x=1658254161; bh=flbY27l8SG12t
        vSsNQqmUwpFJSmusaEnV0T4ZJqcCMU=; b=SLmdhozsqJqHWicLofNrlPBBwk1gl
        d5lDJvHq/db4rjY4QQoQMvS7x2WQOVmPvPWy7cPeqd/JBH/r5NWKqjqHeoPjoTSu
        OApdh20yhL6RmK+qGR1fdLy9kWCWOqeGawqqNQnSNuiZ9sdLFSHow5A0P4d6bZj6
        Jso/wGqNEYC6ZpTHGHir3YVLpBNIdsOX5Rtl+0wn88IVSuk8porrxs7LsJBkKpE3
        MGrO+42kx3kcnNtXuzbhoiG3M9TH5/tFq84xaDDjoPFee4MxgThZfXnheXBEgr8r
        xzsMuho9Ebb4UBMbosjw2BCW/dKxNxBv9m1jUads4vxcRjm4S+Htph4lw==
X-ME-Sender: <xms:0aHVYte65YJiN302VJuqI2V5z5-sJHdIovKUkXRh1lrrsOBfff2C5g>
    <xme:0aHVYrPT1xnLyI9ekQOQLfhEyATgSLAm3Gslq2Yu3IsKjZycSz2CanUtTrRN3FlZl
    gSLAY9gYndFIqo>
X-ME-Received: <xmr:0aHVYmhNfEOYKYzwAYoveQDrEDw42UB3y5S4cqlU2ky4c0boluEqdKPU938iQapoQfg3UtFryLww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:0aHVYm_ROzpeqSqol2etNhCONYRZn86wWOKwk1RzR9kdc_NFmluvKw>
    <xmx:0aHVYpuqORoW_UnXL-JmD-CJL0MnGAcYR_CePvA2bmql6YLhtJ45Xg>
    <xmx:0aHVYlGCnyt-uTh-flT_H0SlGWw7edig-7FFPISdtShwzwtJsyUCpg>
    <xmx:0aHVYjLAcXCjf9cajKFqAtcNUz56ai5eFpoz1ZYPr9c9Vg3koKce3A>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 14:09:21 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 5/5] Ignore failure to unmap -1
Date:   Mon, 18 Jul 2022 14:08:22 -0400
Message-Id: <20220718180820.2555-6-demi@invisiblethingslab.com>
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
