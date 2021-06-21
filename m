Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3133AE774
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFUKqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:46:47 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55131 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhFUKqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:46:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 69F9F1940A32;
        Mon, 21 Jun 2021 06:44:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Jun 2021 06:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Mhlfg8
        bLIkh4rF2p1EloS8Kfg3Qvs8vXevtFc4qJwz4=; b=wERY9Je0trucSwEy6iYf6X
        6R+IZaS3CsWuByPfoBTWtnvrxBDu02xphPKwoBrSEOqnmoK1MNqdTnXQ4632073F
        BQPfE6c28jlAsP0MWny6QbSiY/ifPDcx3vj7NLK3SbFGf9Hz9kKvt+wmxL09/Vxx
        f1u2Id2mFEd3q7KmfzGYyQ8iYwwt+HyJfbLzhgu7u9HZlzuYXIXkjY55aP/eghPw
        bnKyYXzD5Mo3ty1WLKTgo0ehfPhk5+XzCUkPaD/2eRw0Rik9Ale0S5+QNzdbR26t
        07jdm28gSDHJHg79xy1VulmPI3Kj9yx6a/v/0b9lbSvY/g55REpmj9/a+31+xGAA
        ==
X-ME-Sender: <xms:kG3QYOLEqu7BjytavANI4cwdbksddwMh7NPNOLRQUh6BRx1lS7Tqbg>
    <xme:kG3QYGL85s-ff7UmampTGPD-71UWufeP4XXgf-mNx2YVSYdEDm7_Tq0_WAcXq74zi
    nc-xQbzb521Bg>
X-ME-Received: <xmr:kG3QYOvZ0ak_tqWnNU3cuI0lwNe8tHjmf94ClLJL94PDJYAktg8xbeb36ZAHDB9bce1LOYTtlkLQGTaxyErqcW5qS-86nCWV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepveeuudekgeehiedthfefgfevvdetteehvdeiheehud
    egtddvvefgtdeiheekueehnecuffhomhgrihhnpegvnhhtrhihrdhssgenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:kG3QYDZXqsu31WkbLwljGij09WhNPO-rYejB2LzdHG0IIJvuLaMx6Q>
    <xmx:kG3QYFZq7TcGMgfA0TSmz94nXSX8Swpah6uswvCTCPckeC9eoUWFag>
    <xmx:kG3QYPAmzjlmHLgDJMwZiYvRVq2Z_IU7INf4sGInGxcP7AfqAW7xBg>
    <xmx:kG3QYEUVpO1Z3s-eneo9PgohUPE1OptU6TSmwIbmY83bbPDrIrEtoA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:44:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/mcck: fix invalid KVM guest condition check" failed to apply to 4.19-stable tree
To:     agordeev@linux.ibm.com, borntraeger@de.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:44:22 +0200
Message-ID: <162427226210342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

