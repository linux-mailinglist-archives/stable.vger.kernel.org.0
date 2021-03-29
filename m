Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41F334CDAB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 12:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhC2KKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 06:10:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52987 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232562AbhC2KKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 06:10:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3E17C1940B24;
        Mon, 29 Mar 2021 06:10:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UNFdGj
        j/A30OvWn4Qn+4JTF2EwOXFyfZmYU+4Daee0Q=; b=fjbQkgEZKu5Ss5einCGLea
        oNKrq2R6NMtdz4o+OEiYhcsuv/2yufEQTLtuxSkIzmlYQjXxc422wgRtLtNmW1qI
        J3AB2chUFpHIQcLUHgbVtpLRRD5BF8iEmfdNr/WVcw32pv2dAWn5O46XCzSGDtS0
        W8aCehYMzHmPq8C/cSblR6OWYbBr1UsVO7ihLW/ZiPiNmf11PaUFMTeHgrsEvbPi
        Hz1AF17Sop0inzJqjUnxtwrjRsd0+q4439LuuYZx/p2rFY2kxOgQ06fl1GxAlYvR
        veLOc/1oqH0p7cWWpEwBfhX9J7gPaVsh8zfaIHcg1zUHlpzPOux8o7ilZzyHrpgg
        ==
X-ME-Sender: <xms:iadhYGHiy9Oag-3S7yLEtHW8o8RR4zl2vqyQ7sYxx92pT-KS69P5-w>
    <xme:iadhYO_keJ7fUp7pwBIhEij5QkTEKyXQjI8Nli9BF6JMpdkz-AkgM4Rm90BzfLyoO
    RDoNenTShHZwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iadhYNwu5fMcRWniMlsB2uHLGkPzF8AvDzwX4Eaf1ENvpq1Ejia_Tg>
    <xmx:iadhYKNZC085mxd-nEdIzQUUOxyi9AxuQNXrlylmXrqjvoR6yvS1vA>
    <xmx:iadhYC-6iks1BHQIGCV7ugx0bYyXTuaymkAjJSM8dz95piBN3GgpJA>
    <xmx:iqdhYBmFACcRoAHEfgAs9vdp7zcrs1L9JNSu2oUVBRBNGZQTw7xtsw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 384F91080066;
        Mon, 29 Mar 2021 06:10:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: mm: correct the inside linear map range during hotplug" failed to apply to 5.11-stable tree
To:     pasha.tatashin@soleen.com, anshuman.khandual@arm.com,
        tyhicks@linux.microsoft.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 12:10:06 +0200
Message-ID: <1617012606191248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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
 

