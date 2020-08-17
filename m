Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F49124667B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgHQMlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 08:41:23 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59185 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbgHQMlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 08:41:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 499FD194018E;
        Mon, 17 Aug 2020 08:41:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 08:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tcnTFO
        3HR/2mSflCNriOXvqDVBpj9pPWofyNNnnGhto=; b=FTi0E7ayi0C9lFfygrQelj
        oH3KmgpcCJ8N5zg36UMwIyXadbBnT17eLwhK/CjU8Ngsn1xIBdirqFbN44IFeNQO
        KbpKlkr6cZSZwcaOQ5ps0AZRNnMayAMrFtJP859Y6DlMZEqnCMd8++nMgsDqYkHd
        NQkiB8g9PEpQ3yvA1xfBdtSosdFu8lFg/AZGaOPyR1eRYiZ4xomT5IL3reUKG2sB
        eaPjMSBnaGwoIa/LJhEKHBNmjmexLpSr6Oz5KXPBmGLZyOcyAXFAncQIZH8dZfCs
        qDrhh7JmfhdNILSb8cOvpGvEnzKiDL2Dl7p4P0KTUHMJN1t6H3Egs7d8FZ1wXsZA
        ==
X-ME-Sender: <xms:8Xo6X5f8-fLB1UNQuMxNsm06BsqQaHLHEp9zb_D2O8vMs_Mmmpe28A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:8Xo6X3NSiiJEq6AVPQ-Yc2qe32ktRYG5hCNnWv9MUdz7-srT9t5fIg>
    <xmx:8Xo6XyjFXK7UVnpw-A1ew0aw1cNAt5JB90OKJc0u0d68TOrzQK1y0Q>
    <xmx:8Xo6Xy9OZUyz-O-MjpFndpEqh0TVEPuGS9Xlfehip9yiYGlFafUrWw>
    <xmx:8no6Xz7DPm1KExBHIRjKXoJPBZOhG1Poz5c1XBn7fPczBpSOu5ACFg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C457306005F;
        Mon, 17 Aug 2020 08:41:21 -0400 (EDT)
Subject: WTF: patch "[PATCH] parisc: Whitespace cleanups in atomic.h" was seriously submitted to be applied to the 5.8-stable tree?
To:     deller@gmx.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 14:41:39 +0200
Message-ID: <159766809925341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.8-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3bc6e3dc5a54d5842938c6f1ed78dd1add379af7 Mon Sep 17 00:00:00 2001
From: Helge Deller <deller@gmx.de>
Date: Sun, 14 Jun 2020 10:50:42 +0200
Subject: [PATCH] parisc: Whitespace cleanups in atomic.h

Fix whitespace indenting and drop trailing backslashes.

Cc: <stable@vger.kernel.org> # 4.19+
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 6dd4171c9530..90e8267fc509 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -34,13 +34,13 @@ extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
 /* Can't use raw_spin_lock_irq because of #include problems, so
  * this is the substitute */
 #define _atomic_spin_lock_irqsave(l,f) do {	\
-	arch_spinlock_t *s = ATOMIC_HASH(l);		\
+	arch_spinlock_t *s = ATOMIC_HASH(l);	\
 	local_irq_save(f);			\
 	arch_spin_lock(s);			\
 } while(0)
 
 #define _atomic_spin_unlock_irqrestore(l,f) do {	\
-	arch_spinlock_t *s = ATOMIC_HASH(l);			\
+	arch_spinlock_t *s = ATOMIC_HASH(l);		\
 	arch_spin_unlock(s);				\
 	local_irq_restore(f);				\
 } while(0)
@@ -85,7 +85,7 @@ static __inline__ void atomic_##op(int i, atomic_t *v)			\
 	_atomic_spin_lock_irqsave(v, flags);				\
 	v->counter c_op i;						\
 	_atomic_spin_unlock_irqrestore(v, flags);			\
-}									\
+}
 
 #define ATOMIC_OP_RETURN(op, c_op)					\
 static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
@@ -150,7 +150,7 @@ static __inline__ void atomic64_##op(s64 i, atomic64_t *v)		\
 	_atomic_spin_lock_irqsave(v, flags);				\
 	v->counter c_op i;						\
 	_atomic_spin_unlock_irqrestore(v, flags);			\
-}									\
+}
 
 #define ATOMIC64_OP_RETURN(op, c_op)					\
 static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\

