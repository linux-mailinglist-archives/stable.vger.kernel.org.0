Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9599F49806A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiAXNFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:05:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242901AbiAXNFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:05:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643029547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h49/bKUPqr3RkXF2tm8wJ/T4Ahp4fwLJTequ0tWkrks=;
        b=FDthh41bCCqXolhQZmBsJKZsEwXh/6lU8klc55eIqHrPMqHPBkPL0tguBh/q3CfrwYUSOn
        FEKR3TjLIbO3yFgzCJVsmEhgbfxGfS/hSKAANc7g8NVKjnBgNQkSixdOJEU40/JxKZXyq/
        If60IEGfOWL1ESC9twGyEOwxpZov4wI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-TaGqBkWiPp-holdjgIHgdw-1; Mon, 24 Jan 2022 08:05:43 -0500
X-MC-Unique: TaGqBkWiPp-holdjgIHgdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C25448143F2;
        Mon, 24 Jan 2022 13:05:42 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BE807D533;
        Mon, 24 Jan 2022 13:05:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.16 v1 3/4] KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
Date:   Mon, 24 Jan 2022 14:05:33 +0100
Message-Id: <20220124130534.2645955-4-vkuznets@redhat.com>
In-Reply-To: <20220124130534.2645955-1-vkuznets@redhat.com>
References: <20220124130534.2645955-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9e6d484f9991176269607bb3c54a494e32eab27a upstream.

In preparation to reusing the existing 'get_cpuid_test' for testing
"KVM_SET_CPUID{,2} after KVM_RUN" rename it to 'cpuid_test' to avoid
the confusion.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220117150542.2176196-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                        | 2 +-
 tools/testing/selftests/kvm/Makefile                          | 4 ++--
 .../selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c}   | 0
 3 files changed, 3 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 3cb5ac5da087..289d4cc32d2f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,11 +7,11 @@
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
+/x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
 /x86_64/emulator_error_test
-/x86_64/get_cpuid_test
 /x86_64/get_msr_index_features
 /x86_64/kvm_clock_test
 /x86_64/kvm_pv_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17342b575e85..290b1b0552d6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -38,11 +38,11 @@ LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x8
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
-TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
+TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
-TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
rename to tools/testing/selftests/kvm/x86_64/cpuid_test.c
-- 
2.34.1

