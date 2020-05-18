Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444681D7B47
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgEROcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:32:12 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57749 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbgEROcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:32:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A10621940EF4;
        Mon, 18 May 2020 10:32:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 10:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UAhMzx
        NAyZ/e77hetQni7J2nqHjNlXCqBhGd0UYJUmA=; b=IBmeg8t3OEy6SZ2vPWML8/
        X+AIOdghPPKwmKvWhAqohkoITRB6YSN30sJIdKODO7wfqgMEe71qLvLNeedrJLha
        ROmPPcXhxQaWH3KhcneiLno9B5mS89Jd/pTM/Y3WbEXBNsoFCTXHLvznsegImGru
        f1kzMqM7Yqtwo6BW1op8g4Ic0g7IqNL3icgN+PWgChWtj2yI3D5MLOQvnyQKhIVD
        XYrOg4HIDqbXnm/cqnnnpvxr+NsFC32RX3548usPgH6m9RLh/933aQJWyJ7jV/M0
        Aj4ii7SyB7g04hnWFONm4wVYCv2BGDojZFcnmHvQkFpbIC19SEEnzXNxMgkpu/tA
        ==
X-ME-Sender: <xms:apzCXiFQZ72MRAIhIMp6l3bGPQkOyh2xOfD10VJ_28Cf__Cav_6QNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:apzCXjXgXDunLHq-FLvK35SEG5YrOe7on9zbGGi34FXL6xP7rCeiDw>
    <xmx:apzCXsJsN1YYLHXU_1dKl6_UyljVe_2j-ro8p9uVLAMDmiYJuswmnw>
    <xmx:apzCXsEGC0XlmU8AXfZ7fJkklUVSNfGdoMT0yJAaxUfDyNexvKiSkg>
    <xmx:a5zCXrAEpxhVoqcx0WNhwgAhnp10N38RjZn_F2Ty-V3qWb4Dm-l0vw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E93E330663FB;
        Mon, 18 May 2020 10:32:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/uaccess: Evaluate macro arguments once, before user" failed to apply to 5.4-stable tree
To:     npiggin@gmail.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 16:32:04 +0200
Message-ID: <158981232435119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From d02f6b7dab8228487268298ea1f21081c0b4b3eb Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Tue, 7 Apr 2020 14:12:45 +1000
Subject: [PATCH] powerpc/uaccess: Evaluate macro arguments once, before user
 access is allowed

get/put_user() can be called with nontrivial arguments. fs/proc/page.c
has a good example:

    if (put_user(stable_page_flags(ppage), out)) {

stable_page_flags() is quite a lot of code, including spin locks in
the page allocator.

Ensure these arguments are evaluated before user access is allowed.

This improves security by reducing code with access to userspace, but
it also fixes a PREEMPT bug with KUAP on powerpc/64s:
stable_page_flags() is currently called with AMR set to allow writes,
it ends up calling spin_unlock(), which can call preempt_schedule. But
the task switch code can not be called with AMR set (it relies on
interrupts saving the register), so this blows up.

It's fine if the code inside allow_user_access() is preemptible,
because a timer or IPI will save the AMR, but it's not okay to
explicitly cause a reschedule.

Fixes: de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace Access Protection")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200407041245.600651-1-npiggin@gmail.com

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 2f500debae21..0969285996cb 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -166,13 +166,17 @@ do {								\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
+	__typeof__(*(ptr)) __pu_val = (x);			\
+	__typeof__(size) __pu_size = (size);			\
+								\
 	if (!is_kernel_addr((unsigned long)__pu_addr))		\
 		might_fault();					\
-	__chk_user_ptr(ptr);					\
+	__chk_user_ptr(__pu_addr);				\
 	if (do_allow)								\
-		__put_user_size((x), __pu_addr, (size), __pu_err);		\
+		__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err);	\
 	else									\
-		__put_user_size_allowed((x), __pu_addr, (size), __pu_err);	\
+		__put_user_size_allowed(__pu_val, __pu_addr, __pu_size, __pu_err); \
+								\
 	__pu_err;						\
 })
 
@@ -180,9 +184,13 @@ do {								\
 ({									\
 	long __pu_err = -EFAULT;					\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
+	__typeof__(*(ptr)) __pu_val = (x);				\
+	__typeof__(size) __pu_size = (size);				\
+									\
 	might_fault();							\
-	if (access_ok(__pu_addr, size))			\
-		__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	if (access_ok(__pu_addr, __pu_size))				\
+		__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err); \
+									\
 	__pu_err;							\
 })
 
@@ -190,8 +198,12 @@ do {								\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
-	__chk_user_ptr(ptr);					\
-	__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	__typeof__(*(ptr)) __pu_val = (x);			\
+	__typeof__(size) __pu_size = (size);			\
+								\
+	__chk_user_ptr(__pu_addr);				\
+	__put_user_size(__pu_val, __pu_addr, __pu_size, __pu_err); \
+								\
 	__pu_err;						\
 })
 
@@ -283,15 +295,18 @@ do {								\
 	long __gu_err;						\
 	__long_type(*(ptr)) __gu_val;				\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
-	__chk_user_ptr(ptr);					\
+	__typeof__(size) __gu_size = (size);			\
+								\
+	__chk_user_ptr(__gu_addr);				\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
 	barrier_nospec();					\
 	if (do_allow)								\
-		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);		\
+		__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err);	\
 	else									\
-		__get_user_size_allowed(__gu_val, __gu_addr, (size), __gu_err);	\
+		__get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
+								\
 	__gu_err;						\
 })
 
@@ -300,12 +315,15 @@ do {								\
 	long __gu_err = -EFAULT;					\
 	__long_type(*(ptr)) __gu_val = 0;				\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
+	__typeof__(size) __gu_size = (size);				\
+									\
 	might_fault();							\
-	if (access_ok(__gu_addr, (size))) {		\
+	if (access_ok(__gu_addr, __gu_size)) {				\
 		barrier_nospec();					\
-		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+		__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	}								\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
+									\
 	__gu_err;							\
 })
 
@@ -314,10 +332,13 @@ do {								\
 	long __gu_err;						\
 	__long_type(*(ptr)) __gu_val;				\
 	__typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
-	__chk_user_ptr(ptr);					\
+	__typeof__(size) __gu_size = (size);			\
+								\
+	__chk_user_ptr(__gu_addr);				\
 	barrier_nospec();					\
-	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	__get_user_size(__gu_val, __gu_addr, __gu_size, __gu_err); \
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+								\
 	__gu_err;						\
 })
 

