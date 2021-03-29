Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB18B34CDAC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhC2KKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:10:36 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42335 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhC2KKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:10:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DCF001940B35;
        Mon, 29 Mar 2021 06:10:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Mar 2021 06:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xdBHqn
        AjObSPC1Qs6SBThxoy8x7hgGXqAQDwzywttAU=; b=HGImmjqj6ZuQAI3BNnpFOq
        f+Hw1gsgwDsPUyO65dvzIfl3n/bQOBeb4ogW8fq677+9M3F+mkPkh8MG6tW1PMu6
        rk7e2sHSEwoN92cPycf3DNyoECYaCP5opyiKzvS+/eofRjNkahQ4/Q5yzjYZUj/1
        tpR+3/GfbdovGK3AdWhUf30tUs2/6BubPw0gxnCMFq9U+UaMEmii6Z3zHJhkqYHr
        hdqRb4yOaYHl/ZDgd24Xsg/cSyNQllEvQXQgxpA/WD2f8OfOyoC+lOfNMqJgZRJc
        18N6qZXSAufhvDVbstTXBBfe1DZY9KlG+yEC+2x0GjeacuQVGK2BtZVwXacvFDVw
        ==
X-ME-Sender: <xms:gKdhYN9HXZKa_km4eCJHO5X-hWw8kcVrk2IXM6WvmJavnoB3z7Z-3Q>
    <xme:gKdhYKpN2sdjPHnx4cTHTcn7sUetv-W6Lwr2XEaKO6CkHxDGnW48rvXbg463P4FDs
    8E_UPfd4HmFJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gKdhYGkVq5Svp9pRNH5VC34e2DZP8N1Qi58dEm49jWNossmkm-L9xA>
    <xmx:gKdhYBi1UcT8Yr_Al6rXyhholIepyhZ4VY1CnmJNrBe-fTUV235JgQ>
    <xmx:gKdhYOcFYQrNCKHKnwz4xPK9D7jX1g27wWjbU100-WkqIIiiJnMY1g>
    <xmx:gKdhYAadK0eijaZovvDo9Ehc73gO9qwLhU_6UYV1MgN7K-fv6sYxQQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0658424005B;
        Mon, 29 Mar 2021 06:10:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: mm: correct the inside linear map range during hotplug" failed to apply to 5.10-stable tree
To:     pasha.tatashin@soleen.com, anshuman.khandual@arm.com,
        tyhicks@linux.microsoft.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 12:10:05 +0200
Message-ID: <161701260551228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee7febce051945be28ad86d16a15886f878204de Mon Sep 17 00:00:00 2001
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Feb 2021 10:03:51 -0500
Subject: [PATCH] arm64: mm: correct the inside linear map range during hotplug
 check

Memory hotplug may fail on systems with CONFIG_RANDOMIZE_BASE because the
linear map range is not checked correctly.

The start physical address that linear map covers can be actually at the
end of the range because of randomization. Check that and if so reduce it
to 0.

This can be verified on QEMU with setting kaslr-seed to ~0ul:

memstart_offset_seed = 0xffff
START: __pa(_PAGE_OFFSET(vabits_actual)) = ffff9000c0000000
END:   __pa(PAGE_END - 1) =  1000bfffffff

Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Fixes: 58284a901b42 ("arm64/mm: Validate hotplug range before creating linear mapping")
Tested-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210216150351.129018-2-pasha.tatashin@soleen.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7484ea4f6ba0..5d9550fdb9cf 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1448,6 +1448,22 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
 struct range arch_get_mappable_range(void)
 {
 	struct range mhp_range;
+	u64 start_linear_pa = __pa(_PAGE_OFFSET(vabits_actual));
+	u64 end_linear_pa = __pa(PAGE_END - 1);
+
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		/*
+		 * Check for a wrap, it is possible because of randomized linear
+		 * mapping the start physical address is actually bigger than
+		 * the end physical address. In this case set start to zero
+		 * because [0, end_linear_pa] range must still be able to cover
+		 * all addressable physical addresses.
+		 */
+		if (start_linear_pa > end_linear_pa)
+			start_linear_pa = 0;
+	}
+
+	WARN_ON(start_linear_pa > end_linear_pa);
 
 	/*
 	 * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
@@ -1455,8 +1471,9 @@ struct range arch_get_mappable_range(void)
 	 * range which can be mapped inside this linear mapping range, must
 	 * also be derived from its end points.
 	 */
-	mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
-	mhp_range.end =  __pa(PAGE_END - 1);
+	mhp_range.start = start_linear_pa;
+	mhp_range.end =  end_linear_pa;
+
 	return mhp_range;
 }
 

