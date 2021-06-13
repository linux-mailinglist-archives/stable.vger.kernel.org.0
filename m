Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DCB3A5809
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFMLoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:44:14 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36545 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231736AbhFMLoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:44:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id CD0E211E6;
        Sun, 13 Jun 2021 07:42:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 13 Jun 2021 07:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6aO7Qu
        +0NXzcphfTwyERvKQlvCUhPtC08Xtc9XUyAJM=; b=WMhuV0A5T/D9j2LVkbwdEs
        lL97B1plslxTWIq8TcKiQrLUB4Eo0EzOe/0s0lmuvbVBYKdozWamb1J4eOxJuKx7
        /RqwOufG2AKzx+diczJFSifhGVhyJTorYpIut7zhrAof87Sn9Q/FuSRFFaED8Hyn
        CrvTmWSUhALkVzgLZCb1imo/Rk2sn37K+OoABPP7om03ayftEdEXYmWYiOn/Zd/Z
        YnUkFbJondxlDbuK8jbIPbK1EhUeTXWoC3dEl3pCZLwfB9oP+XgbyI2gz+LkArrj
        YwZQrhkhU9us79ROX7SVkvKbDihnUMEYYbuJsVizG08VaOEugfu19HObgTWA2ThA
        ==
X-ME-Sender: <xms:FO_FYJATxDpUO8LFE6FSKilWpIafxB4iHLtjRraW_tiBq6vQcxA3fg>
    <xme:FO_FYHjQxV-ywNZKgXA4XrCBV5ySQytlA1a-EGtPBBAtK193fjxDq1oUOA4XqoNxg
    4z3JvoA-fuwQw>
X-ME-Received: <xmr:FO_FYEnrhbZBwCOapuw_eTyxgq0-UI6ikcHxPutiVHe6juDadwOCwLSjgDAYk1W_QtijaLwRq45kvXzdr84mfz-wIHsx9c5T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:FO_FYDwwmIKpmBnhvOeMEp8vf-JPOFFR3imAgaOFjKcHhW7llLa1Eg>
    <xmx:FO_FYOQ1thH7GzvSKO4n-DtoApmMPRB6wAJblfcwwGouGd5LHcQGwg>
    <xmx:FO_FYGZmFibOvzFWWXiBTKajLBwLXqYNniwZF3pA8pfAZaaMhEQ-3g>
    <xmx:FO_FYJebtJb9px4FiI8R_R5iIwRl9S1yaNXanYoSDJxqqW2jeKSpWTqWP-k>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:42:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: selftests: introduce P47V64 for s390x" failed to apply to 5.12-stable tree
To:     borntraeger@de.ibm.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:42:10 +0200
Message-ID: <16235845306942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1bc603af73dd8fb2934306e861009c54f973dcc2 Mon Sep 17 00:00:00 2001
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Tue, 8 Jun 2021 14:39:54 +0200
Subject: [PATCH] KVM: selftests: introduce P47V64 for s390x

s390x can have up to 47bits of physical guest and 64bits of virtual
address  bits. Add a new address mode to avoid errors of testcases
going beyond 47bits.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Message-Id: <20210608123954.10991-1-borntraeger@de.ibm.com>
Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
Cc: stable@vger.kernel.org
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fcd8e3855111..b602552b1ed0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -43,6 +43,7 @@ enum vm_guest_mode {
 	VM_MODE_P40V48_4K,
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_P47V64_4K,
 	NUM_VM_MODES,
 };
 
@@ -60,7 +61,7 @@ enum vm_guest_mode {
 
 #elif defined(__s390x__)
 
-#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
+#define VM_MODE_DEFAULT			VM_MODE_P47V64_4K
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 16)
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 28e528c19d28..b126fab6c4e1 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -175,6 +175,7 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P40V48_4K]	= "PA-bits:40,  VA-bits:48,  4K pages",
 		[VM_MODE_P40V48_64K]	= "PA-bits:40,  VA-bits:48, 64K pages",
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
+		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -192,6 +193,7 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	{ 40, 48,  0x1000, 12 },
 	{ 40, 48, 0x10000, 16 },
 	{  0,  0,  0x1000, 12 },
+	{ 47, 64,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -277,6 +279,9 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
 #endif
 		break;
+	case VM_MODE_P47V64_4K:
+		vm->pgtable_levels = 5;
+		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", mode);
 	}

