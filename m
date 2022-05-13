Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7352E526499
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380993AbiEMOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381043AbiEMOaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984428B0A8;
        Fri, 13 May 2022 07:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E484E62153;
        Fri, 13 May 2022 14:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFADC34100;
        Fri, 13 May 2022 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452084;
        bh=AXzPA1O54eLd3vG4mFEvZntWq/xW4DOrWM+TiF6qYLQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cpdbi7qscLNzRv7KDapTV8+CpCPD8r1V/g6s+4uEaNl18wjbJFN9mORUDgFzThhYw
         X9dM3UKkDUk5B/jydvb5Nddan4ZhB9j73Gts0y5fMItppuusgflupGlguEQgkLmkwx
         obi2tgSery9cXUZOzu2DTUcNM3Vyufni82Y4kQhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/21] 5.15.40-rc1 review
Date:   Fri, 13 May 2022 16:23:42 +0200
Message-Id: <20220513142229.874949670@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.40-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.40-rc1
X-KernelTest-Deadline: 2022-05-15T14:22+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.40 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.40-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.40-rc1

Peter Xu <peterx@redhat.com>
    mm: fix invalid page pointer returned with FOLL_PIN gups

Miaohe Lin <linmiaohe@huawei.com>
    mm/mlock: fix potential imbalanced rlimit ucounts adjustment

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm/hwpoison: fix error page recovered but reported "not recovered"

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Muchun Song <songmuchun@bytedance.com>
    mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

Muchun Song <songmuchun@bytedance.com>
    mm: fix missing cache flush for all tail pages of compound page

Jan Kara <jack@suse.cz>
    udf: Avoid using stale lengthOfImpUse

Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
    rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name

Peter Zijlstra <peterz@infradead.org>
    objtool: Fix SLS validation for kcov tail-call replacement

Peter Zijlstra <peterz@infradead.org>
    crypto: x86/poly1305 - Fixup SLS

Borislav Petkov <bp@suse.de>
    kvm/emulate: Fix SETcc emulation function offsets with SLS

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy'

Peter Zijlstra <peterz@infradead.org>
    x86: Add straight-line-speculation mitigation

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: move objtool_args back to scripts/Makefile.build

Peter Zijlstra <peterz@infradead.org>
    x86/alternative: Relax text_poke_bp() constraint

Peter Zijlstra <peterz@infradead.org>
    objtool: Add straight-line-speculation validation

Peter Zijlstra <peterz@infradead.org>
    x86: Prepare inline-asm for straight-line-speculation

Peter Zijlstra <peterz@infradead.org>
    x86: Prepare asm files for straight-line-speculation

Peter Zijlstra <peterz@infradead.org>
    x86/lib/atomic64_386_32: Rename things


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/x86/Kconfig                              | 12 ++++
 arch/x86/Makefile                             |  4 ++
 arch/x86/boot/compressed/efi_thunk_64.S       |  2 +-
 arch/x86/boot/compressed/head_64.S            |  8 +--
 arch/x86/boot/compressed/mem_encrypt.S        |  6 +-
 arch/x86/crypto/aegis128-aesni-asm.S          | 48 +++++++--------
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S       |  2 +-
 arch/x86/crypto/aesni-intel_asm.S             | 56 ++++++++---------
 arch/x86/crypto/aesni-intel_avx-x86_64.S      | 40 ++++++-------
 arch/x86/crypto/blake2s-core.S                |  4 +-
 arch/x86/crypto/blowfish-x86_64-asm_64.S      | 12 ++--
 arch/x86/crypto/camellia-aesni-avx-asm_64.S   | 14 ++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S  | 14 ++---
 arch/x86/crypto/camellia-x86_64-asm_64.S      | 12 ++--
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S     | 12 ++--
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S     | 10 ++--
 arch/x86/crypto/chacha-avx2-x86_64.S          |  6 +-
 arch/x86/crypto/chacha-avx512vl-x86_64.S      |  6 +-
 arch/x86/crypto/chacha-ssse3-x86_64.S         |  8 +--
 arch/x86/crypto/crc32-pclmul_asm.S            |  2 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S     |  2 +-
 arch/x86/crypto/crct10dif-pcl-asm_64.S        |  2 +-
 arch/x86/crypto/des3_ede-asm_64.S             |  4 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S     |  6 +-
 arch/x86/crypto/nh-avx2-x86_64.S              |  2 +-
 arch/x86/crypto/nh-sse2-x86_64.S              |  2 +-
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 38 ++++++------
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S   | 10 ++--
 arch/x86/crypto/serpent-avx2-asm_64.S         | 10 ++--
 arch/x86/crypto/serpent-sse2-i586-asm_32.S    |  6 +-
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S  |  6 +-
 arch/x86/crypto/sha1_avx2_x86_64_asm.S        |  2 +-
 arch/x86/crypto/sha1_ni_asm.S                 |  2 +-
 arch/x86/crypto/sha1_ssse3_asm.S              |  2 +-
 arch/x86/crypto/sha256-avx-asm.S              |  2 +-
 arch/x86/crypto/sha256-avx2-asm.S             |  2 +-
 arch/x86/crypto/sha256-ssse3-asm.S            |  2 +-
 arch/x86/crypto/sha256_ni_asm.S               |  2 +-
 arch/x86/crypto/sha512-avx-asm.S              |  2 +-
 arch/x86/crypto/sha512-avx2-asm.S             |  2 +-
 arch/x86/crypto/sha512-ssse3-asm.S            |  2 +-
 arch/x86/crypto/sm4-aesni-avx-asm_64.S        | 12 ++--
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S       |  8 +--
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S   | 10 ++--
 arch/x86/crypto/twofish-i586-asm_32.S         |  4 +-
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S  |  6 +-
 arch/x86/crypto/twofish-x86_64-asm_64.S       |  4 +-
 arch/x86/entry/entry_32.S                     |  2 +-
 arch/x86/entry/entry_64.S                     | 10 ++--
 arch/x86/entry/thunk_32.S                     |  2 +-
 arch/x86/entry/thunk_64.S                     |  2 +-
 arch/x86/entry/vdso/vdso32/system_call.S      |  2 +-
 arch/x86/entry/vdso/vsgx.S                    |  2 +-
 arch/x86/entry/vsyscall/vsyscall_emu_64.S     |  6 +-
 arch/x86/include/asm/linkage.h                | 14 +++++
 arch/x86/include/asm/paravirt.h               |  2 +-
 arch/x86/include/asm/qspinlock_paravirt.h     |  4 +-
 arch/x86/include/asm/static_call.h            |  2 +-
 arch/x86/kernel/acpi/wakeup_32.S              |  6 +-
 arch/x86/kernel/alternative.c                 | 51 +++++++++++-----
 arch/x86/kernel/ftrace.c                      |  2 +-
 arch/x86/kernel/ftrace_32.S                   |  6 +-
 arch/x86/kernel/ftrace_64.S                   | 10 ++--
 arch/x86/kernel/head_32.S                     |  2 +-
 arch/x86/kernel/irqflags.S                    |  2 +-
 arch/x86/kernel/kprobes/core.c                |  2 +-
 arch/x86/kernel/paravirt.c                    |  2 +-
 arch/x86/kernel/relocate_kernel_32.S          | 10 ++--
 arch/x86/kernel/relocate_kernel_64.S          | 10 ++--
 arch/x86/kernel/sev_verify_cbit.S             |  2 +-
 arch/x86/kernel/static_call.c                 |  5 +-
 arch/x86/kernel/verify_cpu.S                  |  4 +-
 arch/x86/kvm/emulate.c                        | 23 +++++--
 arch/x86/kvm/svm/vmenter.S                    |  4 +-
 arch/x86/kvm/vmx/vmenter.S                    | 14 ++---
 arch/x86/lib/atomic64_386_32.S                | 86 +++++++++++++++------------
 arch/x86/lib/atomic64_cx8_32.S                | 16 ++---
 arch/x86/lib/checksum_32.S                    |  8 +--
 arch/x86/lib/clear_page_64.S                  |  6 +-
 arch/x86/lib/cmpxchg16b_emu.S                 |  4 +-
 arch/x86/lib/cmpxchg8b_emu.S                  |  4 +-
 arch/x86/lib/copy_mc_64.S                     |  6 +-
 arch/x86/lib/copy_page_64.S                   |  4 +-
 arch/x86/lib/copy_user_64.S                   | 12 ++--
 arch/x86/lib/csum-copy_64.S                   |  2 +-
 arch/x86/lib/error-inject.c                   |  3 +-
 arch/x86/lib/getuser.S                        | 22 +++----
 arch/x86/lib/hweight.S                        |  6 +-
 arch/x86/lib/iomap_copy_64.S                  |  2 +-
 arch/x86/lib/memcpy_64.S                      | 12 ++--
 arch/x86/lib/memmove_64.S                     |  4 +-
 arch/x86/lib/memset_64.S                      |  6 +-
 arch/x86/lib/msr-reg.S                        |  4 +-
 arch/x86/lib/putuser.S                        |  6 +-
 arch/x86/lib/retpoline.S                      |  4 +-
 arch/x86/math-emu/div_Xsig.S                  |  2 +-
 arch/x86/math-emu/div_small.S                 |  2 +-
 arch/x86/math-emu/mul_Xsig.S                  |  6 +-
 arch/x86/math-emu/polynom_Xsig.S              |  2 +-
 arch/x86/math-emu/reg_norm.S                  |  6 +-
 arch/x86/math-emu/reg_round.S                 |  2 +-
 arch/x86/math-emu/reg_u_add.S                 |  2 +-
 arch/x86/math-emu/reg_u_div.S                 |  2 +-
 arch/x86/math-emu/reg_u_mul.S                 |  2 +-
 arch/x86/math-emu/reg_u_sub.S                 |  2 +-
 arch/x86/math-emu/round_Xsig.S                |  4 +-
 arch/x86/math-emu/shr_Xsig.S                  |  8 +--
 arch/x86/math-emu/wm_shrx.S                   | 16 ++---
 arch/x86/mm/mem_encrypt_boot.S                |  4 +-
 arch/x86/platform/efi/efi_stub_32.S           |  2 +-
 arch/x86/platform/efi/efi_stub_64.S           |  2 +-
 arch/x86/platform/efi/efi_thunk_64.S          |  2 +-
 arch/x86/platform/olpc/xo1-wakeup.S           |  6 +-
 arch/x86/power/hibernate_asm_32.S             |  4 +-
 arch/x86/power/hibernate_asm_64.S             |  4 +-
 arch/x86/um/checksum_32.S                     |  4 +-
 arch/x86/um/setjmp_32.S                       |  2 +-
 arch/x86/um/setjmp_64.S                       |  2 +-
 arch/x86/xen/xen-asm.S                        | 12 ++--
 arch/x86/xen/xen-head.S                       |  2 +-
 fs/udf/namei.c                                |  8 +--
 include/net/bluetooth/hci_core.h              |  3 +
 include/uapi/linux/rfkill.h                   |  2 +-
 mm/gup.c                                      |  2 +-
 mm/memory-failure.c                           |  4 +-
 mm/memory.c                                   |  2 +
 mm/migrate.c                                  |  7 ++-
 mm/mlock.c                                    |  1 +
 mm/shmem.c                                    |  4 +-
 mm/userfaultfd.c                              |  3 +
 net/bluetooth/hci_core.c                      |  6 +-
 samples/ftrace/ftrace-direct-modify.c         |  4 +-
 samples/ftrace/ftrace-direct-too.c            |  2 +-
 samples/ftrace/ftrace-direct.c                |  2 +-
 scripts/Makefile.build                        | 11 ++++
 scripts/Makefile.lib                          | 11 ----
 scripts/link-vmlinux.sh                       |  3 +
 tools/arch/x86/lib/memcpy_64.S                | 12 ++--
 tools/arch/x86/lib/memset_64.S                |  6 +-
 tools/objtool/arch/x86/decode.c               | 13 ++--
 tools/objtool/builtin-check.c                 |  3 +-
 tools/objtool/check.c                         | 24 ++++++++
 tools/objtool/include/objtool/arch.h          |  1 +
 tools/objtool/include/objtool/builtin.h       |  2 +-
 145 files changed, 608 insertions(+), 484 deletions(-)


