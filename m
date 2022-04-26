Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66B50F2F9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 09:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiDZHvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 03:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbiDZHvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 03:51:45 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00741A040;
        Tue, 26 Apr 2022 00:48:37 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h1so17219580pfv.12;
        Tue, 26 Apr 2022 00:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3CunhxLC3mb3e6UNr+xNX95pgRojNIa+JUKiN4OUms=;
        b=TljaTwoD8SLvOhWYTxOMKfYY4caoHsVCypcKaTpr1fj0K9eavwC4WSrr8G2XGElv8x
         TV9kj4OpypB/7rTo+tSov6Fhh50nCp6quQer1GYUvmSyAxLUzyGDQwX6SW4ddDzFDIOx
         6NB1aq9idon2IZZRJdp8SP825iqygYG2wCZap9YmIKbCh1GtDzbZSPKq6e1EU+rYfu3Q
         DysNrV27KbaIKIkDTDBGraC+yTWaPMQGx3+ki4BKfk4HizU8csvTp0Ol0uCs3egEEEzh
         S0HZdkVei0DhgK4TtYnkwmcRYoRjDjQH2Ho5T6mcxx2QupLuE1DZthyiYYsEEzAdy8aq
         DKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3CunhxLC3mb3e6UNr+xNX95pgRojNIa+JUKiN4OUms=;
        b=4yZQCA26rgytSVQg66+gNMaq5dwTDEuljoYzkpJhW547TMDWlso3xheFlGFvgcgCKT
         tAPSljbENDe/EmRdTOFciCO+VXPqcMtFvtYcYmnN27Fi9LVRs7C4hfyNWcE5ayKUf3Bc
         5puG8JGgYoGzu+9k0OmzE5Im13xveuA5tuspsAUecUXtbpXY+gbCzytc6HoKah7T3Seu
         xODILt1EgNYg7PwHXuN1IOrdcAsulECVMRlQYEDwalUIWXbyNh1qj5y/4is8DUtexsEJ
         hpRCHEU06xEuYCGHUPyApcoQisHGCvJHleTFkEbgw8oIb+0FVSO+YsSb2p6t7+OM0Gb7
         FuLQ==
X-Gm-Message-State: AOAM531mF+vsF/RsoM9IwpmJmweqx2nDBsZ9pXVLANRVWlnVnR42/flT
        A2aDZAeb5tQARb6DgxYGZPCD0hKsCaQ=
X-Google-Smtp-Source: ABdhPJzbS6CSlbSiL3g2XpFHPHeAZCURvdyStjTGUIx8QfAcYIPh4pe5nzI/LP307yAagUaH8Nk2Bg==
X-Received: by 2002:a63:3115:0:b0:3ab:2131:5f12 with SMTP id x21-20020a633115000000b003ab21315f12mr9658991pgx.0.1650959316856;
        Tue, 26 Apr 2022 00:48:36 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-30.three.co.id. [116.206.28.30])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ade8c00b001d25dfb9d39sm1845467pjv.14.2022.04.26.00.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 00:48:35 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: powerpc: remove extraneous asterisk from rm_host_ipi_action comment
Date:   Tue, 26 Apr 2022 14:47:51 +0700
Message-Id: <20220426074750.71251-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel test robot reported kernel-doc warning for rm_host_ipi_action():

arch/powerpc/kvm/book3s_hv_rm_xics.c:887: warning: This comment
starts with '/**', but isn't a kernel-doc comment. Refer
Documentation/doc-guide/kernel-doc.rst

Since the function is static, remove the extraneous (second) asterisk at
the head of function comment.

Link: https://lore.kernel.org/linux-doc/202204252334.Cd2IsiII-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
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

base-commit: d615b5416f8a1afeb82d13b238f8152c572d59c0
-- 
An old man doll... just what I always wanted! - Clara

