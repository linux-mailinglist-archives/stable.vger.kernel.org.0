Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699FF5835D8
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 02:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbiG1ACd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 20:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbiG1ACc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 20:02:32 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9108118345
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 17:02:31 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z25so588562lfr.2
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 17:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBsuLV2Kcuz0I195V1tt9wJXgZd8wQhbwFhjdKnnIJE=;
        b=l3MGDDEdS9t9yQxk624TuJG1yi8Q65z7u1Kbu1NGAGE5iTZqEyvSpMIssIgZqFbcog
         tgnqIdBLB5ZyY01UAVkhNmm08bUwvtYktXorCFReTU6g1W3UEQ71DFIvS1QxHdwBYaBe
         l1dkPVjdWppEix7iwqiFhqXCBId631FcZLwaU+RdLbVqguhF2XtJkWgCGKKKWQ7+EOi3
         YVyXFf9I+QMPBz/N/FzKGSfpAidyW1O2O2Q9dqX9sywEb0g7SbOSdNzAhzbhRSLirQ9R
         f06nl3wGAqpcepN/PuNK/WvfOceNFDYHD+Bzpj+S7lEbu5x1YuTZzkIvVBFEO41MccVj
         J/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBsuLV2Kcuz0I195V1tt9wJXgZd8wQhbwFhjdKnnIJE=;
        b=lqrtemMB9fVM+O2cmc6hKhqd+JS0o49SeMwhxjDAI+A2b8WEu+63B7MgPmsJRKqBZB
         Gfuh2jCdnz6E9W/vFc2ghYxVSe1O5FmP/m4wkRIu/A9j9F3ong0jJrGlC6aC8BaXu/cr
         9Awo5Tu0Qe1cufGPo/QL7RGLdLju8F5e04/l5AxL9AUNPnTu+UReXWzKjnpaGuTmDszX
         mBa7plbYSgoOtRI0x03+lyKQmdRF1jAjwiYQdtm16o3l7L2svvCLGIzv8jmKlRfvwb1r
         qVMwXxpqNli+tSUtrD/qXNZ1toT6QyaHG/0D7ctE0vh3/RAFv9yamKMy5b+Q77RwkW/8
         KKQg==
X-Gm-Message-State: AJIora/TWRE3S+8LtuMHzoeh1cimxl6jJUfgDRb/vMU6i2N4zYJHGuAq
        ls1vY6JUAjdyjv0WJnGiJ97HQw==
X-Google-Smtp-Source: AGRyM1uJOZj/Ud8yjL00jfvfNrl8tmJjn2jtL+kO+cqfm7FOI+GilysBPfZMbkNBrIU8/Qy5rZM+9g==
X-Received: by 2002:a05:6512:1694:b0:48a:9d45:763f with SMTP id bu20-20020a056512169400b0048a9d45763fmr4368355lfb.662.1658966549714;
        Wed, 27 Jul 2022 17:02:29 -0700 (PDT)
Received: from localhost (91-154-92-55.elisa-laajakaista.fi. [91.154.92.55])
        by smtp.gmail.com with ESMTPSA id q27-20020ac2515b000000b0048a897adbc9sm2096529lfd.211.2022.07.27.17.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 17:02:29 -0700 (PDT)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@profian.com>, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] KVM: x86/mmu: Fix incorrect use of CONFIG_RETPOLINE
Date:   Thu, 28 Jul 2022 03:02:21 +0300
Message-Id: <20220728000221.19088-1-jarkko@profian.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use "#ifdef" instead of "#if", as it is possible to select KVM
without enabling RETPOLINE.

Adding the following list of flags on top of tinyconfig is an
example of a failing config file:

CONFIG_64BIT=y
CONFIG_PCI=y
CONFIG_ACPI=y
CONFIG_VIRTUALIZATION=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CRYPTO=y
CONFIG_DMADEVICES=y
CONFIG_X86_MCE=y
CONFIG_RETPOLINE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_KVM=y
CONFIG_KVM_AMD=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_SP_PSP=y
CONFIG_KVM_AMD_SEV=y
CONFIG_AMD_MEM_ENCRYPT=y
CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=n

Cc: stable@vger.kernel.org # 5.19
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Fixes: d1f5c8366288 ("KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP")
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0b99ee4ea184..e08c7e85bbb9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4213,7 +4213,7 @@ kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
 		 * direct_page_fault() when appropriate.
 		 */
 		//r = direct_page_fault(vcpu, &fault);
-#if CONFIG_RETPOLINE
+#ifdef CONFIG_RETPOLINE
 		if (fault.is_tdp)
 			r = kvm_tdp_page_fault(vcpu, &fault);
 #else
-- 
2.36.1

