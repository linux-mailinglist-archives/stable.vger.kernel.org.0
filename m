Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D927D53CFB7
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiFCR4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbiFCRz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDB53A65;
        Fri,  3 Jun 2022 10:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D45A61244;
        Fri,  3 Jun 2022 17:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EC7C385A9;
        Fri,  3 Jun 2022 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278783;
        bh=Pl3/sxLGlFCJOP2t/rB+qlDEdWgdF4eQeoQWCl+osWU=;
        h=From:To:Cc:Subject:Date:From;
        b=LbkuI6CWKSAMdc90EnU69NWUao2uGLX0GVQgciI4FsKpaX4REPx3g2oFCZeIu0sFm
         yoh6Kcamt/pGLZWuqh7pw1rfZ2jUmvufyCEghTPdpmJDHjxqS+GtYvUhC/DNt6d4ww
         KIYuNDWtcwo37GWN9l6iDU8If/0iuK+afhVEN8Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.17 00/75] 5.17.13-rc1 review
Date:   Fri,  3 Jun 2022 19:42:44 +0200
Message-Id: <20220603173821.749019262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.17.13-rc1
X-KernelTest-Deadline: 2022-06-05T17:38+00:00
Content-Type: text/plain; charset=UTF-8
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

This is the start of the stable review cycle for the 5.17.13 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.17.13-rc1

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check PTR_TO_MEM | MEM_RDONLY in check_helper_mem_access

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access

Yuntao Wang <ytcoode@gmail.com>
    bpf: Fix excessive memory allocation in stack_map_alloc()

KP Singh <kpsingh@kernel.org>
    bpf: Fix usage of trace RCU in local storage.

Liu Jian <liujian56@huawei.com>
    bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix combination of jit blinding and pointers to bpf subprogs.

Yuntao Wang <ytcoode@gmail.com>
    bpf: Fix potential array overflow in bpf_trampoline_get_progs()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix possible sleep during nfsd4_release_lockowner()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Memory allocation failures are not server fatal errors

Akira Yokosawa <akiyks@gmail.com>
    docs: submitting-patches: Fix crossref to 'The canonical patch format'

Xiu Jianfeng <xiujianfeng@huawei.com>
    tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
    tpm: Fix buffer access in tpm2_get_tpm_pt()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: i2c: imx412: Fix power_off ordering

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: i2c: imx412: Fix reset GPIO polarity

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Ensure no data in PCMD page after truncate

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Fix race between reclaimer and page fault handler

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Obtain backing storage page with enclave mutex held

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Mark PCMD page as dirty when modifying contents

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Disconnect backing page references from dirty status

Tao Jin <tao-j@outlook.com>
    HID: multitouch: add quirks to enable Lenovo X12 trackpoint

Marek Maślanka <mm@semihalf.com>
    HID: multitouch: Add support for Google Whiskers Touchpad

Randy Dunlap <rdunlap@infradead.org>
    fs/ntfs3: validate BOOT sectors_per_clusters

Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
    raid5: introduce MD_BROKEN

Sarthak Kukreti <sarthakkukreti@google.com>
    dm verity: set DM_TARGET_IMMUTABLE feature flag

Mikulas Patocka <mpatocka@redhat.com>
    dm stats: add cond_resched when looping over entries

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: make printing of the key constant-time

Dan Carpenter <dan.carpenter@oracle.com>
    dm integrity: fix error code in dm_integrity_ctr()

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Correct interrupt name for bluetooth in Aries

Steven Rostedt <rostedt@goodmis.org>
    Bluetooth: hci_qca: Use del_timer_sync() before freeing

Craig McLure <craig@mclure.net>
    ALSA: usb-audio: Configure sync endpoints before data

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add missing ep_idx in fixed EP quirks

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Workaround for clock setup on TEAC devices

Akira Yokosawa <akiyks@gmail.com>
    tools/memory-model/README: Update klitmus7 compat table

Sultan Alsawaf <sultan@kerneltoast.com>
    zsmalloc: fix races between asynchronous zspage free and page migration

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix incorrect use of vli_cmp

Fabio Estevam <festevam@denx.de>
    crypto: caam - fix i.MX6SX entropy delay value

Ashish Kalra <ashish.kalra@amd.com>
    KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86/mmu: Don't rebuild page when the page is synced and no tlb flushing is required

Sean Christopherson <seanjc@google.com>
    KVM: x86: Drop WARNs that assert a triple fault never "escapes" from L2

Yanfei Xu <yanfei.xu@intel.com>
    KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: avoid loading a vCPU after .vm_destroy was called

Sean Christopherson <seanjc@google.com>
    KVM: x86: avoid calling x86 emulator without a decoded instruction

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: fix typo in __try_cmpxchg_user causing non-atomicness

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Implement macros for CMPXCHG on user addresses

Paolo Bonzini <pbonzini@redhat.com>
    x86, kvm: use correct GFP flags for preemption disabled

Sean Christopherson <seanjc@google.com>
    x86/kvm: Alloc dummy async #PF token outside of raw spinlock

Sean Christopherson <seanjc@google.com>
    x86/fpu: KVM: Set the base guest FPU uABI size to sizeof(struct kvm_xsave)

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: re-fetch conntrack after insertion

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: double hook unregistration in netns path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: hold mutex on netns pre_exit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: sanitize nft_set_desc_concat_parse()

Phil Sutter <phil@nwl.cc>
    netfilter: nft_limit: Clone packet limits' cost value

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix referencing wrong parent directory information after renaming

Tadeusz Struk <tadeusz.struk@linaro.org>
    exfat: check if cluster num is valid

Gustavo A. R. Silva <gustavoars@kernel.org>
    drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Alex Elder <elder@linaro.org>
    net: ipa: compute proper aggregation limit

David Howells <dhowells@redhat.com>
    pipe: Fix missing lock in pipe_resize_ring()

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    pipe: make poll_usage boolean and annotate its access

Stephen Brennan <stephen.s.brennan@oracle.com>
    assoc_array: Fix BUG_ON during garbage collect

Dan Carpenter <dan.carpenter@oracle.com>
    i2c: ismt: prevent memory corruption in ismt_access()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow non-stateful expression in sets earlier

Piyush Malgujar <pmalgujar@marvell.com>
    drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Mika Westerberg <mika.westerberg@linux.intel.com>
    i2c: ismt: Provide a DMA buffer for Interrupt Cause Logging

Joel Stanley <joel@jms.id.au>
    net: ftgmac100: Disable hardware checksum on AST2600

Lin Ma <linma@zju.edu.cn>
    nfc: pn533: Fix buggy cleanup order

Thomas Bartschies <thomas.bartschies@cvk.de>
    net: af_key: check encryption module availability consistency

Al Viro <viro@zeniv.linux.org.uk>
    percpu_ref_init(): clean ->percpu_count_ref on failure

Quentin Perret <qperret@google.com>
    KVM: arm64: Don't hypercall before EL2 init

IotaHydrae <writeforever@foxmail.com>
    pinctrl: sunxi: fix f1c100s uart2 function

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: Add quirk for the Framework Laptop

Gabriele Mazzotta <gabriele.mzt@gmail.com>
    ALSA: hda/realtek: Add quirk for Dell Latitude 7520

Forest Crossman <cyrozap@gmail.com>
    ALSA: usb-audio: Don't get sample rate for MCT Trigger 5 USB-to-HDMI


-------------

Diffstat:

 Documentation/process/submitting-patches.rst  |   2 +-
 Makefile                                      |   4 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi          |   2 +-
 arch/arm64/kvm/arm.c                          |   3 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c            |   8 +-
 arch/x86/include/asm/uaccess.h                | 142 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c                | 113 ++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/encl.h                |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                |  13 ++-
 arch/x86/kernel/fpu/core.c                    |  17 ++-
 arch/x86/kernel/kvm.c                         |  41 +++++---
 arch/x86/kvm/mmu/mmu.c                        |  18 ++--
 arch/x86/kvm/mmu/paging_tmpl.h                |  38 +------
 arch/x86/kvm/svm/nested.c                     |   3 -
 arch/x86/kvm/svm/sev.c                        |  12 +--
 arch/x86/kvm/vmx/nested.c                     |   3 -
 arch/x86/kvm/vmx/vmx.c                        |   2 +-
 arch/x86/kvm/x86.c                            |  76 +++++++-------
 crypto/ecrdsa.c                               |   8 +-
 drivers/bluetooth/hci_qca.c                   |   4 +-
 drivers/char/tpm/tpm2-cmd.c                   |  11 +-
 drivers/char/tpm/tpm_ibmvtpm.c                |   1 +
 drivers/crypto/caam/ctrl.c                    |  18 ++++
 drivers/gpu/drm/i915/intel_pm.c               |   2 +-
 drivers/hid/hid-ids.h                         |   1 +
 drivers/hid/hid-multitouch.c                  |   9 ++
 drivers/i2c/busses/i2c-ismt.c                 |  17 +++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c      |   1 +
 drivers/md/dm-crypt.c                         |  14 ++-
 drivers/md/dm-integrity.c                     |   2 -
 drivers/md/dm-stats.c                         |   8 ++
 drivers/md/dm-verity-target.c                 |   1 +
 drivers/md/raid5.c                            |  47 ++++-----
 drivers/media/i2c/imx412.c                    |   8 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |   5 +
 drivers/net/ipa/ipa_endpoint.c                |   4 +-
 drivers/nfc/pn533/pn533.c                     |   5 +-
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c |   2 +-
 fs/exfat/balloc.c                             |   8 +-
 fs/exfat/exfat_fs.h                           |   6 ++
 fs/exfat/fatent.c                             |   6 --
 fs/exfat/namei.c                              |  27 +----
 fs/nfs/internal.h                             |   1 +
 fs/nfsd/nfs4state.c                           |  12 +--
 fs/ntfs3/super.c                              |  10 +-
 fs/pipe.c                                     |  33 +++---
 include/linux/bpf_local_storage.h             |   4 +-
 include/linux/pipe_fs_i.h                     |   2 +-
 include/net/netfilter/nf_conntrack_core.h     |   7 +-
 kernel/bpf/bpf_inode_storage.c                |   4 +-
 kernel/bpf/bpf_local_storage.c                |  29 ++++--
 kernel/bpf/bpf_task_storage.c                 |   4 +-
 kernel/bpf/core.c                             |  10 ++
 kernel/bpf/stackmap.c                         |   1 -
 kernel/bpf/trampoline.c                       |  18 ++--
 kernel/bpf/verifier.c                         |  17 ++-
 lib/assoc_array.c                             |   8 ++
 lib/percpu-refcount.c                         |   1 +
 mm/zsmalloc.c                                 |  37 ++++++-
 net/core/bpf_sk_storage.c                     |   6 +-
 net/core/filter.c                             |   4 +-
 net/key/af_key.c                              |   6 +-
 net/netfilter/nf_tables_api.c                 |  94 ++++++++++++-----
 net/netfilter/nft_limit.c                     |   2 +
 sound/pci/hda/patch_realtek.c                 |  54 ++++++++++
 sound/usb/clock.c                             |   7 ++
 sound/usb/pcm.c                               |  17 +--
 sound/usb/quirks-table.h                      |   3 +
 sound/usb/quirks.c                            |   2 +
 tools/memory-model/README                     |   3 +-
 70 files changed, 798 insertions(+), 312 deletions(-)


