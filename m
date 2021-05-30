Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E05239512E
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhE3N7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:59:47 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56453 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3N7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:59:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id D16F11940234;
        Sun, 30 May 2021 09:58:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 30 May 2021 09:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eG9FVo
        hh959/LxFar+91GVY00iQ5EizIszQFubCxl1U=; b=SCFW9LnybHNFSIyepiH7Yt
        ovD9XYCbHbYu3UIFdVbUxvNm/hy6bJbJLPdmwK6Nytln/NQUFRpwD9A9dM3G4JYE
        IT4ID7ywu+w056hvzyo+eEO4EqXyXUZ4oXLqtWIuGqmqy0bye1LcoTKOH403RH4A
        li0uOzauiXRjOQOiEr6Lnj7oMrKY4XZmpUeUtw9F4/3TYMJ9x+ZDZamx01l0sUNu
        oe2iideBGn3AIKmgBV0UwMn2qEU8WNaOQZYT0oiNnFCKMLf1wRqI+ACCXF3VNDla
        gW2agFrS192gBJihnUgv3RSr3I99dd3T+q1WOfa1r07JhfgjdYaDZcl50Wx7UQFw
        ==
X-ME-Sender: <xms:8JmzYKICZDZJyNmmYBUQUMe20C9qUBjpGEuHA-zxNqAuUPNlSfcjKg>
    <xme:8JmzYCLHQDTIHGG5h0vLbY1CXfu23cndg_TuYSyRqS34mrPijibZ198x3ikXUU7BK
    Oz8hGe4uTtVGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8JmzYKutNXn-dPADUdNXkx21syMMAnL4R05XtiG1riFEes3HvqZ3hw>
    <xmx:8JmzYPb_aX5gcQUcTxD8x9R4upFDxR8SMX_ec_yURcSAtT3dUaAmxA>
    <xmx:8JmzYBbEJJZi0K05bO25Adzojt0qsdWRdWEHzKHaUGj_BoEwLTfALw>
    <xmx:8JmzYFFJBphUuwFgBDXi9LUIKUF37PBuh4N9lichwnYduqhmwgLwBA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:58:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()" failed to apply to 5.4-stable tree
To:     dmatlack@google.com, drjones@redhat.com, pbonzini@redhat.com,
        peterx@redhat.com, venkateshs@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:58:07 +0200
Message-ID: <162238308715773@kroah.com>
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

From ef4c9f4f654622fa15b7a94a9bd1f19e76bb7feb Mon Sep 17 00:00:00 2001
From: David Matlack <dmatlack@google.com>
Date: Fri, 21 May 2021 17:38:28 +0000
Subject: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()

vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
which causes the upper 32-bits of the max_gfn to get truncated.

Nobody noticed until now likely because vm_get_max_gfn() is only used
as a mechanism to create a memslot in an unused region of the guest
physical address space (the top), and the top of the 32-bit physical
address space was always good enough.

This fix reveals a bug in memslot_modification_stress_test which was
trying to create a dummy memslot past the end of guest physical memory.
Fix that by moving the dummy memslot lower.

Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210521173828.1180619-1-dmatlack@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8f022794ce3..2e0d253dabd6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -302,7 +302,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
-unsigned int vm_get_max_gfn(struct kvm_vm *vm);
+uint64_t vm_get_max_gfn(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1255744758e3..ea3f0db85b3e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2117,7 +2117,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
 	return vm->page_shift;
 }
 
-unsigned int vm_get_max_gfn(struct kvm_vm *vm)
+uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 81490b9b4e32..abf381800a59 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#include <inttypes.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
@@ -80,7 +81,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 */
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
+		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
+		    " vcpus: %d wss: %" PRIx64 "]\n",
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6096bf0a5b34..98351ba0933c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -71,14 +71,22 @@ struct memslot_antagonist_args {
 };
 
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
-			      uint64_t nr_modifications, uint64_t gpa)
+			       uint64_t nr_modifications)
 {
+	const uint64_t pages = 1;
+	uint64_t gpa;
 	int i;
 
+	/*
+	 * Add the dummy memslot just below the perf_test_util memslot, which is
+	 * at the top of the guest physical address space.
+	 */
+	gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
+
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
-					    DUMMY_MEMSLOT_INDEX, 1, 0);
+					    DUMMY_MEMSLOT_INDEX, pages, 0);
 
 		vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
 	}
@@ -120,11 +128,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Started all vCPUs\n");
 
 	add_remove_memslot(vm, p->memslot_modification_delay,
-			   p->nr_memslot_modifications,
-			   guest_test_phys_mem +
-			   (guest_percpu_mem_size * nr_vcpus) +
-			   perf_test_args.host_page_size +
-			   perf_test_args.guest_page_size);
+			   p->nr_memslot_modifications);
 
 	run_vcpus = false;
 

