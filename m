Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591415B6326
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiILV43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiILV40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:56:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C874D27B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663019779; x=1694555779;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NzQAWVKtDd+tcca+Czlf8nXES8spcQxcb9fkqwdGwQs=;
  b=Aanfdc8HCVuda5NtFJZQ45i0amlz7463ypaf8/2AD91dQleOmwPd9L7e
   eIWMiTqp30Mh+ypVeFRcXZCJZSA9tzRYKkKJ/pckn66zu8Qy+RuTGfyKg
   IKaBjzmSxDrxtV4n3aKSxZIlGiZbAXX3p+Velma9+cjBymxsNzK6gpqrV
   1DPvEnxRpvvRLEuOx0hbl761f82RJXO3ep//Ue4PXivKw6wsIkvGlVeUp
   mgKNKkuZ7xGfNjrXV8YQUql6bviFpJVIUi9P3sxD1yULg4hQoZYYyPdxU
   FLibTJiTk3LsMtqExovb88d9HRnE00K+2/T4Qn9KUnVkXtQ36AyImOhFy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="297981668"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208,223";a="297981668"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 14:56:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208,223";a="567333017"
Received: from sho10-mobl1.amr.corp.intel.com (HELO desk) ([10.251.9.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 14:56:17 -0700
Date:   Mon, 12 Sep 2022 14:56:16 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <20220912215616.wbnfp4m6lizsvwi5@desk>
References: <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
 <Yxc4CeyDS2tWLXfo@kroah.com>
 <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
 <20220906212010.rfvxzkt25nwakfad@desk>
 <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
 <20220908060949.dcybz74j3wm7pzrg@desk>
 <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
 <Yx12bQVdycfVQkp0@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3jlbuyeat3nekot7"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yx12bQVdycfVQkp0@kroah.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3jlbuyeat3nekot7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 11, 2022 at 07:47:25AM +0200, Greg KH wrote:
> On Thu, Sep 08, 2022 at 02:44:33PM +0200, Ben Hutchings wrote:
> > On Wed, 2022-09-07 at 23:09 -0700, Pawan Gupta wrote:
> > > On Wed, Sep 07, 2022 at 02:23:58AM +0200, Ben Hutchings wrote:
> > > > > > - The added mitigation, for PBRSB, requires removing any RET
> > > > > > instructions executed between VM exit and the RSB filling.  In these
> > > > > > older branches that hasn't been done, so the mitigation doesn't work.
> > > > > 
> > > > > I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> > > > > filling. Could you please point me to any specific instance you are
> > > > > seeing?
> > > > 
> > > > Yes, you're right.  The backported versions avoid this problem.  They
> > > > are quite different from the upstream commit - and I would have
> > > > appreciated some explanation of this in their commit messages.
> > > 
> > > Ahh right, I will keep in mind next time.
> > > 
> > > > So, let's try again to move forward.  I've attached a backport for 4.19
> > > > and 5.4 (only tested with the latter so far).
> > > 
> > > I am not understanding why lfence in single-entry-fill sequence is okay
> > > on 32-bit kernels?
> > > 
> > > #define __FILL_ONE_RETURN                               \
> > >         __FILL_RETURN_SLOT                              \
> > >         add     $(BITS_PER_LONG/8), %_ASM_SP;           \
> > >         lfence;
> > 
> > This isn't exactly about whether the kernel is 32-bit vs 64-bit, it's
> > about whether the code may run on a processor that lacks support for
> > LFENCE (part of SSE2).
> > 
> > - SSE2 is architectural on x86_64, so 64-bit kernels can use LFENCE
> > unconditionally.
> > - PBRSB doesn't affect any of those old processors, so its mitigation
> > can use LFENCE unconditionally.  (Those procesors don't support VMX
> > either.)
> 
> Ok, it seems that I need to take Ben's patch to resolve this.  Pawan, if
> you object, please let us know.

I don't see any issue taking Ben's patch to resolve this.

Backport for 5.4 didn't apply cleanly on 4.19 and needed a minor change.

Attaching the patch for 4.19. It built fine with CONFIG_64BIT=n.

I don't see LFENCE in the i386 version of FILL_RETURN_BUFFER:

Dump of assembler code for function __switch_to_asm:
   0xc1d63e00 <+0>:     push   %ebp
   0xc1d63e01 <+1>:     push   %ebx
   0xc1d63e02 <+2>:     push   %edi
   0xc1d63e03 <+3>:     push   %esi
   0xc1d63e04 <+4>:     pushf
   0xc1d63e05 <+5>:     mov    %esp,0x69c(%eax)
   0xc1d63e0b <+11>:    mov    0x69c(%edx),%esp
   0xc1d63e11 <+17>:    mov    0x378(%edx),%ebx
   0xc1d63e17 <+23>:    mov    %ebx,%fs:0xc23b0e74
   0xc1d63e1e <+30>:    call   0xc1d63e24 <__switch_to_asm+36>     ---> //FILL_RETURN_BUFFER
   0xc1d63e23 <+35>:    int3
   0xc1d63e24 <+36>:    call   0xc1d63e2a <__switch_to_asm+42>
   0xc1d63e29 <+41>:    int3
   0xc1d63e2a <+42>:    call   0xc1d63e30 <__switch_to_asm+48>
   0xc1d63e2f <+47>:    int3
   0xc1d63e30 <+48>:    call   0xc1d63e36 <__switch_to_asm+54>
   0xc1d63e35 <+53>:    int3
   0xc1d63e36 <+54>:    call   0xc1d63e3c <__switch_to_asm+60>
   0xc1d63e3b <+59>:    int3
   0xc1d63e3c <+60>:    call   0xc1d63e42 <__switch_to_asm+66>

   [...]

   0xc1d63ecc <+204>:   call   0xc1d63ed2 <__switch_to_asm+210>
   0xc1d63ed1 <+209>:   int3
   0xc1d63ed2 <+210>:   call   0xc1d63ed8 <__switch_to_asm+216>
   0xc1d63ed7 <+215>:   int3
   0xc1d63ed8 <+216>:   call   0xc1d63ede <__switch_to_asm+222>
   0xc1d63edd <+221>:   int3
   0xc1d63ede <+222>:   add    $0x80,%esp

--3jlbuyeat3nekot7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-x86-nospec-Fix-i386-RSB-stuffing.patch"
Content-Transfer-Encoding: 8bit

From 60487cc8dd7eda1f8aafc75a51cff179e1d95e83 Mon Sep 17 00:00:00 2001
Message-Id: <60487cc8dd7eda1f8aafc75a51cff179e1d95e83.1663018922.git.pawan.kumar.gupta@linux.intel.com>
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Fri, 19 Aug 2022 13:01:35 +0200
Subject: [PATCH] x86/nospec: Fix i386 RSB stuffing

From: Peter Zijlstra <peterz@infradead.org>

commit 332924973725e8cdcc783c175f68cf7e162cb9e5 upstream.

Turns out that i386 doesn't unconditionally have LFENCE, as such the
loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
chips.

Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net
[bwh: Backported to 4.19/5.4:
 - __FILL_RETURN_BUFFER takes an sp parameter
 - Open-code __FILL_RETURN_SLOT]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/nospec-branch.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 747549934fe3..17a236a8b237 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -35,6 +35,7 @@
  * the optimal version — two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
@@ -55,6 +56,19 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
+	.rept nr;				\
+	call	772f;				\
+	int3;					\
+772:;						\
+	.endr;					\
+	add	$(BITS_PER_LONG/8) * nr, sp;
+#endif
 
 /* Sequence to mitigate PBRSB on eIBRS CPUs */
 #define __ISSUE_UNBALANCED_RET_GUARD(sp)	\

base-commit: 41b46409f97a703ab1dd9227c40e76a0d3eeea1c
-- 
2.37.2


--3jlbuyeat3nekot7--
