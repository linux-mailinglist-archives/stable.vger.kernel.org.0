Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771633AE776
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFUKqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:46:52 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36999 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhFUKqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:46:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 611AD19408CD;
        Mon, 21 Jun 2021 06:44:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 06:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JDXPZf
        JRifUP+f996jPZLG1lQOWX5DDc02/Kl/ZGZKM=; b=e9HFzHSC3Cstp5FV2iLW6p
        MoZH5/G7oyx6+r6k8sBX3Oq9lJf2XCBqiycWyxflNZgaE3PR/GA/1wnifW1Tpjoj
        4QHeJle5es3DKnF0shiHOHBnpdtGnDjbNYWkZibcmCKcs9dDYILs819CbE3aUWdy
        OdA5IRS4DdSuMxz/ndrPo0gtzPvfOWO2C4d/CbHQSt7313X7tDKJI4X5ocfr3OOY
        KnoWrAbv+Fo0qJlK3dTcQBFoScNEg8hrpRnEjCpPmJC9r2g7lXOxy63oN5fiXpf2
        aWm/pIlsYvXdsBLv4xum7U6cgzYcj7qbFBI+bDjV1or4nZ7stZYXqJjO3T/W09IQ
        ==
X-ME-Sender: <xms:lW3QYP32LZkABf2V48GzqL8EexEn5dZi9U5JsjNrJXa6ph-ocd4Snw>
    <xme:lW3QYOGTq-PjnEBZU94QN_QgKaUwiefx2wwWHwLkps-qxt01cFmz4jTB2JzeY3NG0
    4TwM-cuYDUJGQ>
X-ME-Received: <xmr:lW3QYP50tn9kllQvWRHZ0oNa00G0yTHLcBupAWYN_RgH0EuKFcB0U3IASWRosKJ2tQILWrs86lissAaOdds14RqX3R-U25dq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepveeuudekgeehiedthfefgfevvdetteehvdeiheehud
    egtddvvefgtdeiheekueehnecuffhomhgrihhnpegvnhhtrhihrdhssgenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:lW3QYE1w17DuUHAKkDAXlvSYSYqFdEYHVdr57J9045zmEuCFqV-njg>
    <xmx:lW3QYCHD32MrvRQ6Tq7uzGl7UsBG3MmtzKMkvzUerffzUqQQaYecKA>
    <xmx:lW3QYF9X6JAzdBDvMWv6uv3eKNjWTMDUStYDZOM5DLBGmUa9kCXfSg>
    <xmx:lW3QYOgzjbBR6XiWSu8pJ9O4pYTua9QS8Qpeq21H9eDjJUfwwpa71g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:44:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/mcck: fix invalid KVM guest condition check" failed to apply to 5.4-stable tree
To:     agordeev@linux.ibm.com, borntraeger@de.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:44:23 +0200
Message-ID: <162427226311534@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

