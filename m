Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBA131AFB5
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 09:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhBNIO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 03:14:27 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40075 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229673AbhBNIOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 03:14:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 82CA119405F6;
        Sun, 14 Feb 2021 03:13:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 14 Feb 2021 03:13:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=527OIX
        eCcXPIUhODZqN9NBMokNm7csWkUsRV6szu0E4=; b=qm0HPQD5RI4RFpW90OpyQe
        cSKibFxKsFptczDKGCefcqcS0yTAoW3fzvmun0bOCBvJioarVDOt1Rt6KMsSp2SG
        ZMF6Gj20aHjJBx1oS3DHZEiPPJ5fL01ShnCO4j+PAqGXBYdyhApvZqQPor6+b0u8
        iOH3xvnuASpZ+SPfz1F/GdyFKjRBrfcWaaSZto5EFtVpARn0yTQJcKu7TOUXuhks
        yaHWetZTvOiXxs2pGSvkZTZOnB3F4K+8tSnXG4QBNaaciCGXSMi/3Yvxkjy/b82m
        u8gJ1l+a/htw3P44Law0nQjoByK49AcPFlxSB6xdGBqvrTWYky8pxksXWcGSnb3g
        ==
X-ME-Sender: <xms:r9soYPN1_J5n0jmLSzJ2R31TwZ4sJeY3Q3O78ig_y2md5LqIK-zsLQ>
    <xme:r9soYJ-mcEFYof5-0vVk01RIMzEqYY3Hidv1z7X5zqhLVKzayfGaj_txhMZwx4OQx
    RahD4ZqqAamGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieeggdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:r9soYOQjnobQyhoowZ7bcXFSJ3ueJwUaMUzUXDFchb_gazpJ6IDJ6A>
    <xmx:r9soYDuMp3hqTctV9Vi7rKJ281zCqkEg6-1OPxH-QTFN6qVRjFkdCA>
    <xmx:r9soYHd7-5MgaPnmcTn_fhMnnddPr0i5_O20RZV8MiYGwfPK2lPBKA>
    <xmx:r9soYIrgF8M7N-63TiNPp4uNy21HJi6auJCBVhCfOhtofn8o5-fqRg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E29081080059;
        Sun, 14 Feb 2021 03:13:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page" failed to apply to 5.10-stable tree
To:     catalin.marinas@arm.com, luis.machado@linaro.org,
        stable@vger.kernel.org, vincenzo.frascino@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Feb 2021 09:13:32 +0100
Message-ID: <161329041297231@kroah.com>
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

From 68d54ceeec0e5fee4fb8048e6a04c193f32525ca Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Feb 2021 18:03:16 +0000
Subject: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page

The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
-EIO.

A newly created (PROT_MTE) mapping points to the zero page which had its
tags zeroed during cpu_enable_mte(). If there were no prior writes to
this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
page does not have the PG_mte_tagged flag set.

Set PG_mte_tagged on the zero page when its tags are cleared during
boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
!PROT_MTE mappings pointing to the zero page, change the
__access_remote_tags() check to (vm_flags & VM_MTE) instead of
PG_mte_tagged.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Will Deacon <will@kernel.org>
Reported-by: Luis Machado <luis.machado@linaro.org>
Tested-by: Luis Machado <luis.machado@linaro.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210210180316.23654-1-catalin.marinas@arm.com

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e99eddec0a46..3e6331b64932 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1701,16 +1701,12 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
-	static bool cleared_zero_page = false;
-
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!cleared_zero_page) {
-		cleared_zero_page = true;
+	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
 		mte_clear_page_tags(lm_alias(empty_zero_page));
-	}
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index dc9ada64feed..80b62fe49dcf 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -329,11 +329,12 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		 * would cause the existing tags to be cleared if the page
 		 * was never mapped with PROT_MTE.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!(vma->vm_flags & VM_MTE)) {
 			ret = -EOPNOTSUPP;
 			put_page(page);
 			break;
 		}
+		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);

