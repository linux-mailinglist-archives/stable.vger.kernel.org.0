Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1040F6D41B3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 12:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjDCKR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 06:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjDCKR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 06:17:28 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D756E85
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 03:17:24 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id i10so24864637vss.5
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 03:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680517043;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OoLKLYoRAGeWSs8hPWLefekC4bfs3Ci1BnBoichOSh4=;
        b=GVzeFcvnxSIL3fDUzm/9SDNAQs7He4Pn8pK98GIMcC+g9S/d0NFAChwCMeAC877wFR
         TsHlwV8ojaVC4TkjBMJqV1KPWXUfDWN86auQYR5vv8hgBLrWiTewy58m6dFsJLMgCd3W
         V2E2bDk8hyT9ripLQJuYN/C0OGZR5H4TxJW2u1VMkXTFHeon4hOOyQccwg0/bETWIZ9j
         jJCSDuALjWqzCuK9BBfw5Xi/wf0hctj1mSXjGpHpdqD+M/xGD2GiLYsBDybTyFjjazpR
         UQbPttjPU4MaRf4M43NZ22qn2AksvtPhXqgMdLwMOcAZBZX1vI8CIaYdHmR77xvOfW/Z
         LeBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680517043;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OoLKLYoRAGeWSs8hPWLefekC4bfs3Ci1BnBoichOSh4=;
        b=YKPqlGO2G49mSNi2Zu54CzRJKtbwsmrozdy8bx6J2HYFQFvFa8yrBpZj5x9D6eDLE6
         r7xfwFMFo1ZUEtasm2/xep7yZKUppJXFwxBoG3fn20oVSpPfTE6HGId9bt0JpuQLNKEh
         xH8b65q71DwVni1FqKxPiropuzStPXaUe957mdS0M11fRrtTn/mz3CoW5Rn/GyD16mdC
         8q4ZQCUs74t6NCvXcN2ckzbHSKoA98oU039ykGxEaF73/cCvQI2i3JgyxL7Wd0eCdJrL
         epKqteP1gfLm9mjlC6s4D2v1nWX1H+CvfUdvgQm38s8u8u8DLJdIkBa4bjAoNuJUVD4s
         +Y3w==
X-Gm-Message-State: AAQBX9cZ/6wEiyhfVo8oRhv+25fp+XR0guBuEyFdNG7VOSJ69YQf/zoK
        u5QyHI44G+IFWI1Ad45I/Wjp+CTBw9RctVK7OPdz2Z5gM8kCtcOpm2g=
X-Google-Smtp-Source: AKy350b1Cr336Py6dU22c2MIRN9LqoyAmD1dJZrkE6sV03Jxz6FWW4TSRC8RO4VffWKYgAlGo5EYToQ660d1rHuy3eM=
X-Received: by 2002:a67:e04d:0:b0:425:e623:360a with SMTP id
 n13-20020a67e04d000000b00425e623360amr19127570vsl.1.1680517042889; Mon, 03
 Apr 2023 03:17:22 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 3 Apr 2023 15:47:11 +0530
Message-ID: <CA+G9fYsF4D7o1iNW6fMNMdX9fKqqrvJw5GHcbW5yGr9PLSWcrw@mail.gmail.com>
Subject: stable-rc / queue : 5.15: arm64 build failed
To:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build warning noticed on arm64,

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

suspecting commit:
KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
commit 9228b26194d1cc00449f12f306f53ef2e234a55b upstream.


Build log:
----------
arch/arm64/kvm/sys_regs.c:1671:43: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
 1671 |           .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
      |                                           ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1671:43: note: (near initialization for
'sys_reg_descs[224].__get_user')
arch/arm64/kvm/sys_regs.c:999:48: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1768:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
 1768 |         PMU_PMEVCNTR_EL0(0),
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:999:48: note: (near initialization for
'sys_reg_descs[307].__get_user')
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1768:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
 1768 |         PMU_PMEVCNTR_EL0(0),
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:999:48: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1769:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
 1769 |         PMU_PMEVCNTR_EL0(1),
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:999:48: note: (near initialization for
'sys_reg_descs[308].__get_user')
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1769:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
 1769 |         PMU_PMEVCNTR_EL0(1),
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:999:48: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~~~~~~~~~~~

Test history:

https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.105-89-gcc2d591a5bc2/testrun/16027152/suite/build/test/gcc-11-defconfig-lkftconfig/history/


build_name : gcc-11-defconfig-lkftconfig
config : https://storage.tuxsuite.com/public/linaro/lkft/builds/2NuUVvMlXSgSoQEcLJRppFfOniR/config
download_url : https://storage.tuxsuite.com/public/linaro/lkft/builds/2NuUVvMlXSgSoQEcLJRppFfOniR/
git_describe : v5.15.105-89-gcc2d591a5bc2
git_repo : https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
git_sha : cc2d591a5bc25e770c332a191509830e883b1a28
git_short_log : cc2d591a5bc2 ("KVM: arm64: Disable interrupts while
walking userspace PTs")



--
Linaro LKFT
https://lkft.linaro.org
