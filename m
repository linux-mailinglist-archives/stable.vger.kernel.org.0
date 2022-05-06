Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116A351D1F5
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 09:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388382AbiEFHLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 03:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386803AbiEFHLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 03:11:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F25C644F2;
        Fri,  6 May 2022 00:08:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id bo5so5552665pfb.4;
        Fri, 06 May 2022 00:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJZVl5EvwvcXVjSPcNvmPIb3iIpc3e94gPZeNfEIGDE=;
        b=RquPcCEtPTQ8NBVOkNpgpfhMCaOU7gI0N2vmjXVEjeXEe47eK3VzRCiPPHMYYCxLg1
         P6CPTSsRWdUdNnPe/pRgZi+CAMTXOUW0aypCBBwy8+E+GZt1qfHSrSgiWhFOXQrDerPl
         DatPmAPOlMB2tmNlha9NwkZVVfrkt7/5nPmmGw1r/xOKTjKETDCaCs0tDLHNU6qL6xi7
         zAW9JgkwQRnxFAMqJeCE+U8r5dQmqbrlgs9EClh2uSa24oGIURlPYADWhRa9yFHAXrQC
         CnveAh8yJez5ypZvu1OL+WLOuhds+4ACEz2XKq+7SS60PyrasC1F8NQ9g5oL9GzwDwCI
         gxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJZVl5EvwvcXVjSPcNvmPIb3iIpc3e94gPZeNfEIGDE=;
        b=qK1vn2nqt1Md+hdox47ytmman1cEfeu4t+wX4oFgwPxSYFqL0Cr91BAwhJVAUjzeCd
         oJCpFatfpdUV+mIj5meHZrPPp3gLlLm8mGm5w2tDd/+3isk8y9RtDN1QH5vXeum4x/wW
         SeZa5ohmRDSCmVsuKxI+RtH46iNAuLrOjp5RsD6IykQKgiiLTQilew/66OkeRYRv+VEz
         /yPNjw8ZcoLtEjLPPsmqp1S3LsGZNNoD3hmd1Xq0B2epc6fzrc3tFh1PWb+wIXYvqwek
         JOn+LQyoBUiZjgVpiDdmhFK9RGKJBRoW9WcPueevYjnYiBoGy3wyNqH4pfpV+ZhqklxO
         3SUg==
X-Gm-Message-State: AOAM533lWyDP9QXbS3jX3ggBZl6SRdxnfnhSUVQDOr0tarnLREPBY1nj
        2xWwjydIgQOFW5EKMhJKvxV7+GSZ+HMtG42g
X-Google-Smtp-Source: ABdhPJyQwhu+TLbFod80h890qcGGw9VNP9GSkzdKgcSkhgYmo6vXqdsuzS9lzJ1uVtzCOtokQbwb6A==
X-Received: by 2002:a63:ee50:0:b0:3c5:f762:c709 with SMTP id n16-20020a63ee50000000b003c5f762c709mr1648410pgk.222.1651820881250;
        Fri, 06 May 2022 00:08:01 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-93.three.co.id. [180.214.233.93])
        by smtp.gmail.com with ESMTPSA id i12-20020a170902e48c00b0015e8d4eb26dsm844317ple.183.2022.05.06.00.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 00:08:00 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] KVM: powerpc: remove extraneous asterisk from rm_host_ipi_action comment
Date:   Fri,  6 May 2022 14:07:47 +0700
Message-Id: <20220506070747.16309-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel test robot reported kernel-doc warning for rm_host_ipi_action():

>> arch/powerpc/kvm/book3s_hv_rm_xics.c:887: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Host Operations poked by RM KVM

Since the function is static, remove the extraneous (second) asterisk at
the head of function comment.

Fixes: 0c2a66062470cd ("KVM: PPC: Book3S HV: Host side kick VCPU when poked by real-mode KVM")
Link: https://lore.kernel.org/linux-doc/202204252334.Cd2IsiII-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org # v5.15, v5.17
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rm_xics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index 587c33fc45640f..6e16bd751c8423 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -883,7 +883,7 @@ long kvmppc_deliver_irq_passthru(struct kvm_vcpu *vcpu,
 
 /*  --- Non-real mode XICS-related built-in routines ---  */
 
-/**
+/*
  * Host Operations poked by RM KVM
  */
 static void rm_host_ipi_action(int action, void *data)

base-commit: a7391ad3572431a354c927cf8896e86e50d7d0bf
-- 
An old man doll... just what I always wanted! - Clara

