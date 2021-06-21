Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69B3AE775
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFUKqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:46:49 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51575 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhFUKqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:46:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B29319403DD;
        Mon, 21 Jun 2021 06:44:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VPL2bj
        6ifOQw3OiOxygX/TYoQOkxU8hyDxz1yDvfpro=; b=n11ti7me4h7onNvaiWSduL
        u/02GDJUDUMW5V9wly0cHkputlrZ99gMnUfSh1Yjo3e48ckod5wqI2fM7gj5jYje
        v2d6LOVeG72Nui+4BF5u5io1vKZinp2sxPfZxPAawcpKq4k0X/axDH/yvUPDwlsT
        eEycj4q+Lb7KSyM9rXLGHg6TzBjCWLJ5WPO/coAlbptwe9KxRZWxeRjz8LzipcI6
        hM4n5Q+JbEdFdPsGUrvgnM5U/zuaJNIQYDhGzV2wktrvvEwOBJpKqcIw+u2kMARG
        GTy0uDa+CYcSlbHrR5YZ1DJymCId0MctVZYdcaoMpeHFpC07UDPuj+OUUg6YFxpw
        ==
X-ME-Sender: <xms:km3QYMdq_xbyDSdYHlY1ThLA7CoL2u4mEArDlsB0MCbXmIS5TbsLCQ>
    <xme:km3QYONcGY78ld1YQbk4nqKRgjvu06Xue6m-NVSb-NMtbHW5TFZipnqpMOeJQdqaa
    DKARW3vAQ0lVg>
X-ME-Received: <xmr:km3QYNjW5LxjX2rh_vPI2Td5VJ84BD1k9cvMcOCR8vheHJ3FPiSmnSrIHfIfW1CYzAOCHybuO6oibcnCOE3ew0myTyMAWVb9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepveeuudekgeehiedthfefgfevvdetteehvdeiheehud
    egtddvvefgtdeiheekueehnecuffhomhgrihhnpegvnhhtrhihrdhssgenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:km3QYB_2eKpBpm67p3lLBJssKEDQvupqP6OVQLwjoEe9i5r3H8dKOQ>
    <xmx:km3QYItpeEVrDj1XNXITfwFOE--540bZDENbwW6n9zQt4qTgg9KgyQ>
    <xmx:km3QYIFuIho-gZ4D6Jktdf7BjpzK2zF1fLlt_cgs46sWFs_tTeHPBw>
    <xmx:km3QYKIOny1BNvR6ezcqImofubHq7E8Fpk3XXk1alTyqPejnp6-A6w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:44:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/mcck: fix invalid KVM guest condition check" failed to apply to 5.10-stable tree
To:     agordeev@linux.ibm.com, borntraeger@de.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:44:23 +0200
Message-ID: <1624272263130152@kroah.com>
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

From 1874cb13d5d7cafa61ce93a760093ebc5485b6ab Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@linux.ibm.com>
Date: Mon, 17 May 2021 08:18:12 +0200
Subject: [PATCH] s390/mcck: fix invalid KVM guest condition check

Wrong condition check is used to decide if a machine check hit
while in KVM guest. As result of this check the instruction
following the SIE critical section might be considered as still
in KVM guest and _CIF_MCCK_GUEST CPU flag mistakenly set as
result.

Fixes: c929500d7a5a ("s390/nmi: s390: New low level handling for machine check happening in guest")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 3a81e38c95e7..9cc71ca9a88f 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -653,7 +653,7 @@ ENDPROC(stack_overflow)
 	slgr	%r9,%r13
 	lghi	%r13,.Lsie_skip - .Lsie_entry
 	clgr	%r9,%r13
-	jh	.Lcleanup_sie_int
+	jhe	.Lcleanup_sie_int
 	oi	__LC_CPU_FLAGS+7, _CIF_MCCK_GUEST
 .Lcleanup_sie_int:
 	BPENTER	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)

