Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06175527955
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbiEOSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbiEOSsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B3513D5C;
        Sun, 15 May 2022 11:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C1BB80DE0;
        Sun, 15 May 2022 18:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2B7C385B8;
        Sun, 15 May 2022 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640462;
        bh=2fH/pOZPH86gdJDhGoDN98IuMvK/upNUUriu34moWOA=;
        h=From:To:Cc:Subject:Date:From;
        b=Ncd/5ue/Q1hkPYmQMm/UAa4nvDf4/x8aarR8ME5SQM8Vi5f83A0nENV1zR0YZcH5X
         mwGsIIyuRaSjj1FyjhwYqZw9ZwqTLc0bA4p9dBtSVHdl+ZkAjohRyYjYytHTOKUDa9
         5smijngFxvohLMQIT8bCqJA/y3VnFaze3eKDFsNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.40
Date:   Sun, 15 May 2022 20:47:27 +0200
Message-Id: <1652640447116155@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.40 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/x86/Kconfig                              |   12 +++
 arch/x86/Makefile                             |    4 +
 arch/x86/boot/compressed/efi_thunk_64.S       |    2 
 arch/x86/boot/compressed/head_64.S            |    8 +-
 arch/x86/boot/compressed/mem_encrypt.S        |    6 -
 arch/x86/crypto/aegis128-aesni-asm.S          |   48 +++++++-------
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S       |    2 
 arch/x86/crypto/aesni-intel_asm.S             |   56 ++++++++--------
 arch/x86/crypto/aesni-intel_avx-x86_64.S      |   40 ++++++------
 arch/x86/crypto/blake2s-core.S                |    4 -
 arch/x86/crypto/blowfish-x86_64-asm_64.S      |   12 +--
 arch/x86/crypto/camellia-aesni-avx-asm_64.S   |   14 ++--
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S  |   14 ++--
 arch/x86/crypto/camellia-x86_64-asm_64.S      |   12 +--
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S     |   12 +--
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S     |   10 +--
 arch/x86/crypto/chacha-avx2-x86_64.S          |    6 -
 arch/x86/crypto/chacha-avx512vl-x86_64.S      |    6 -
 arch/x86/crypto/chacha-ssse3-x86_64.S         |    8 +-
 arch/x86/crypto/crc32-pclmul_asm.S            |    2 
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S     |    2 
 arch/x86/crypto/crct10dif-pcl-asm_64.S        |    2 
 arch/x86/crypto/des3_ede-asm_64.S             |    4 -
 arch/x86/crypto/ghash-clmulni-intel_asm.S     |    6 -
 arch/x86/crypto/nh-avx2-x86_64.S              |    2 
 arch/x86/crypto/nh-sse2-x86_64.S              |    2 
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl |   38 +++++------
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S   |   10 +--
 arch/x86/crypto/serpent-avx2-asm_64.S         |   10 +--
 arch/x86/crypto/serpent-sse2-i586-asm_32.S    |    6 -
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S  |    6 -
 arch/x86/crypto/sha1_avx2_x86_64_asm.S        |    2 
 arch/x86/crypto/sha1_ni_asm.S                 |    2 
 arch/x86/crypto/sha1_ssse3_asm.S              |    2 
 arch/x86/crypto/sha256-avx-asm.S              |    2 
 arch/x86/crypto/sha256-avx2-asm.S             |    2 
 arch/x86/crypto/sha256-ssse3-asm.S            |    2 
 arch/x86/crypto/sha256_ni_asm.S               |    2 
 arch/x86/crypto/sha512-avx-asm.S              |    2 
 arch/x86/crypto/sha512-avx2-asm.S             |    2 
 arch/x86/crypto/sha512-ssse3-asm.S            |    2 
 arch/x86/crypto/sm4-aesni-avx-asm_64.S        |   12 +--
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S       |    8 +-
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S   |   10 +--
 arch/x86/crypto/twofish-i586-asm_32.S         |    4 -
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S  |    6 -
 arch/x86/crypto/twofish-x86_64-asm_64.S       |    4 -
 arch/x86/entry/entry_32.S                     |    2 
 arch/x86/entry/entry_64.S                     |   10 +--
 arch/x86/entry/thunk_32.S                     |    2 
 arch/x86/entry/thunk_64.S                     |    2 
 arch/x86/entry/vdso/vdso32/system_call.S      |    2 
 arch/x86/entry/vdso/vsgx.S                    |    2 
 arch/x86/entry/vsyscall/vsyscall_emu_64.S     |    6 -
 arch/x86/include/asm/linkage.h                |   14 ++++
 arch/x86/include/asm/paravirt.h               |    2 
 arch/x86/include/asm/qspinlock_paravirt.h     |    4 -
 arch/x86/include/asm/static_call.h            |    2 
 arch/x86/kernel/acpi/wakeup_32.S              |    6 -
 arch/x86/kernel/alternative.c                 |   51 ++++++++++-----
 arch/x86/kernel/ftrace.c                      |    2 
 arch/x86/kernel/ftrace_32.S                   |    6 -
 arch/x86/kernel/ftrace_64.S                   |   10 +--
 arch/x86/kernel/head_32.S                     |    2 
 arch/x86/kernel/irqflags.S                    |    2 
 arch/x86/kernel/kprobes/core.c                |    2 
 arch/x86/kernel/paravirt.c                    |    2 
 arch/x86/kernel/relocate_kernel_32.S          |   10 +--
 arch/x86/kernel/relocate_kernel_64.S          |   10 +--
 arch/x86/kernel/sev_verify_cbit.S             |    2 
 arch/x86/kernel/static_call.c                 |    5 -
 arch/x86/kernel/verify_cpu.S                  |    4 -
 arch/x86/kvm/emulate.c                        |   23 +++++-
 arch/x86/kvm/svm/vmenter.S                    |    4 -
 arch/x86/kvm/vmx/vmenter.S                    |   14 ++--
 arch/x86/lib/atomic64_386_32.S                |   86 ++++++++++++++------------
 arch/x86/lib/atomic64_cx8_32.S                |   16 ++--
 arch/x86/lib/checksum_32.S                    |    8 +-
 arch/x86/lib/clear_page_64.S                  |    6 -
 arch/x86/lib/cmpxchg16b_emu.S                 |    4 -
 arch/x86/lib/cmpxchg8b_emu.S                  |    4 -
 arch/x86/lib/copy_mc_64.S                     |    6 -
 arch/x86/lib/copy_page_64.S                   |    4 -
 arch/x86/lib/copy_user_64.S                   |   12 +--
 arch/x86/lib/csum-copy_64.S                   |    2 
 arch/x86/lib/error-inject.c                   |    3 
 arch/x86/lib/getuser.S                        |   22 +++---
 arch/x86/lib/hweight.S                        |    6 -
 arch/x86/lib/iomap_copy_64.S                  |    2 
 arch/x86/lib/memcpy_64.S                      |   12 +--
 arch/x86/lib/memmove_64.S                     |    4 -
 arch/x86/lib/memset_64.S                      |    6 -
 arch/x86/lib/msr-reg.S                        |    4 -
 arch/x86/lib/putuser.S                        |    6 -
 arch/x86/lib/retpoline.S                      |    4 -
 arch/x86/math-emu/div_Xsig.S                  |    2 
 arch/x86/math-emu/div_small.S                 |    2 
 arch/x86/math-emu/mul_Xsig.S                  |    6 -
 arch/x86/math-emu/polynom_Xsig.S              |    2 
 arch/x86/math-emu/reg_norm.S                  |    6 -
 arch/x86/math-emu/reg_round.S                 |    2 
 arch/x86/math-emu/reg_u_add.S                 |    2 
 arch/x86/math-emu/reg_u_div.S                 |    2 
 arch/x86/math-emu/reg_u_mul.S                 |    2 
 arch/x86/math-emu/reg_u_sub.S                 |    2 
 arch/x86/math-emu/round_Xsig.S                |    4 -
 arch/x86/math-emu/shr_Xsig.S                  |    8 +-
 arch/x86/math-emu/wm_shrx.S                   |   16 ++--
 arch/x86/mm/mem_encrypt_boot.S                |    4 -
 arch/x86/platform/efi/efi_stub_32.S           |    2 
 arch/x86/platform/efi/efi_stub_64.S           |    2 
 arch/x86/platform/efi/efi_thunk_64.S          |    2 
 arch/x86/platform/olpc/xo1-wakeup.S           |    6 -
 arch/x86/power/hibernate_asm_32.S             |    4 -
 arch/x86/power/hibernate_asm_64.S             |    4 -
 arch/x86/um/checksum_32.S                     |    4 -
 arch/x86/um/setjmp_32.S                       |    2 
 arch/x86/um/setjmp_64.S                       |    2 
 arch/x86/xen/xen-asm.S                        |   12 +--
 arch/x86/xen/xen-head.S                       |    2 
 fs/udf/namei.c                                |    8 +-
 include/net/bluetooth/hci_core.h              |    3 
 include/uapi/linux/rfkill.h                   |    2 
 mm/gup.c                                      |    2 
 mm/memory-failure.c                           |    4 -
 mm/memory.c                                   |    2 
 mm/migrate.c                                  |    7 +-
 mm/mlock.c                                    |    1 
 mm/shmem.c                                    |    4 -
 mm/userfaultfd.c                              |    3 
 net/bluetooth/hci_core.c                      |    6 -
 samples/ftrace/ftrace-direct-modify.c         |    4 -
 samples/ftrace/ftrace-direct-too.c            |    2 
 samples/ftrace/ftrace-direct.c                |    2 
 scripts/Makefile.build                        |   11 +++
 scripts/Makefile.lib                          |   11 ---
 scripts/link-vmlinux.sh                       |    3 
 tools/arch/x86/lib/memcpy_64.S                |   12 +--
 tools/arch/x86/lib/memset_64.S                |    6 -
 tools/objtool/arch/x86/decode.c               |   13 ++-
 tools/objtool/builtin-check.c                 |    3 
 tools/objtool/check.c                         |   24 +++++++
 tools/objtool/include/objtool/arch.h          |    1 
 tools/objtool/include/objtool/builtin.h       |    2 
 145 files changed, 607 insertions(+), 483 deletions(-)

Arnaldo Carvalho de Melo (1):
      tools arch: Update arch/x86/lib/mem{cpy,set}_64.S copies used in 'perf bench mem memcpy'

Borislav Petkov (1):
      kvm/emulate: Fix SETcc emulation function offsets with SLS

Gleb Fotengauer-Malinovskiy (1):
      rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Greg Kroah-Hartman (1):
      Linux 5.15.40

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Jan Kara (1):
      udf: Avoid using stale lengthOfImpUse

Masahiro Yamada (1):
      kbuild: move objtool_args back to scripts/Makefile.build

Miaohe Lin (1):
      mm/mlock: fix potential imbalanced rlimit ucounts adjustment

Muchun Song (4):
      mm: fix missing cache flush for all tail pages of compound page
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Naoya Horiguchi (1):
      mm/hwpoison: fix error page recovered but reported "not recovered"

Peter Xu (1):
      mm: fix invalid page pointer returned with FOLL_PIN gups

Peter Zijlstra (8):
      x86/lib/atomic64_386_32: Rename things
      x86: Prepare asm files for straight-line-speculation
      x86: Prepare inline-asm for straight-line-speculation
      objtool: Add straight-line-speculation validation
      x86/alternative: Relax text_poke_bp() constraint
      x86: Add straight-line-speculation mitigation
      crypto: x86/poly1305 - Fixup SLS
      objtool: Fix SLS validation for kcov tail-call replacement

