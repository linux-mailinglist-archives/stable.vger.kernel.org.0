Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA553CF39
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbiFCRxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346024AbiFCRul (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13B45403B;
        Fri,  3 Jun 2022 10:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C40DB82435;
        Fri,  3 Jun 2022 17:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ED8C3411C;
        Fri,  3 Jun 2022 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278415;
        bh=PX8mr3eZ+Q52m4unIrWUH22XGTjYUpmbql69Qqof9/o=;
        h=From:To:Cc:Subject:Date:From;
        b=elWFhwMhrOktDWSxZCs1kUkIYPl909h7IMqc/8rwPvpSdN0AkFS+qiOMGYjVsNDDE
         j+CGiof7kjHwdqi5UR9pvTn38LWXY9Gb693u2Cf+xyzobUe/5MsrkNdoXxdWY3Qbif
         1tgCTyxiwcYxNubATx4G/utV542bYQEPqdT+DhJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/53] 5.10.120-rc1 review
Date:   Fri,  3 Jun 2022 19:42:45 +0200
Message-Id: <20220603173818.716010877@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.120-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.120-rc1
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

This is the start of the stable review cycle for the 5.10.120 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.120-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.120-rc1

Liu Jian <liujian56@huawei.com>
    bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

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

Tao Jin <tao-j@outlook.com>
    HID: multitouch: add quirks to enable Lenovo X12 trackpoint

Marek Maślanka <mm@semihalf.com>
    HID: multitouch: Add support for Google Whiskers Touchpad

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

Sultan Alsawaf <sultan@kerneltoast.com>
    zsmalloc: fix races between asynchronous zspage free and page migration

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix incorrect use of vli_cmp

Fabio Estevam <festevam@denx.de>
    crypto: caam - fix i.MX6SX entropy delay value

Sean Christopherson <seanjc@google.com>
    KVM: x86: avoid calling x86 emulator without a decoded instruction

Paolo Bonzini <pbonzini@redhat.com>
    x86, kvm: use correct GFP flags for preemption disabled

Sean Christopherson <seanjc@google.com>
    x86/kvm: Alloc dummy async #PF token outside of raw spinlock

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: re-fetch conntrack after insertion

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: sanitize nft_set_desc_concat_parse()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - make reseeding from get_random_bytes() synchronous

Nicolai Stange <nstange@suse.de>
    crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()

Nicolai Stange <nstange@suse.de>
    crypto: drbg - prepare for more fine-grained tracking of seeding state

Justin M. Forbes <jforbes@fedoraproject.org>
    lib/crypto: add prompts back to crypto libraries

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix referencing wrong parent directory information after renaming

Tadeusz Struk <tadeusz.struk@linaro.org>
    exfat: check if cluster num is valid

Gustavo A. R. Silva <gustavoars@kernel.org>
    drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Dave Chinner <dchinner@redhat.com>
    xfs: Fix CIL throttle hang when CIL space used going backwards

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix an ABBA deadlock in xfs_rename

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks

Kaixu Xia <kaixuxia@tencent.com>
    xfs: show the proper user quota options

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: detect overflows in bmbt records

Alex Elder <elder@linaro.org>
    net: ipa: compute proper aggregation limit

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix using under-expanded iters

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't re-import iovecs from callbacks

Stephen Brennan <stephen.s.brennan@oracle.com>
    assoc_array: Fix BUG_ON during garbage collect

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    cfg80211: set custom regdomain after wiphy registration

David Howells <dhowells@redhat.com>
    pipe: Fix missing lock in pipe_resize_ring()

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    pipe: make poll_usage boolean and annotate its access

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

IotaHydrae <writeforever@foxmail.com>
    pinctrl: sunxi: fix f1c100s uart2 function


-------------

Diffstat:

 Documentation/process/submitting-patches.rst  |   2 +-
 Makefile                                      |   4 +-
 arch/arm/boot/dts/s5pv210-aries.dtsi          |   2 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c            |   8 +-
 arch/x86/kernel/kvm.c                         |  41 ++++++----
 arch/x86/kvm/x86.c                            |  31 +++++---
 crypto/Kconfig                                |   2 -
 crypto/drbg.c                                 | 110 +++++++++++---------------
 crypto/ecrdsa.c                               |   8 +-
 drivers/bluetooth/hci_qca.c                   |   4 +-
 drivers/char/random.c                         |   2 -
 drivers/char/tpm/tpm2-cmd.c                   |  11 ++-
 drivers/char/tpm/tpm_ibmvtpm.c                |   1 +
 drivers/crypto/caam/ctrl.c                    |  18 +++++
 drivers/gpu/drm/i915/intel_pm.c               |   2 +-
 drivers/hid/hid-ids.h                         |   1 +
 drivers/hid/hid-multitouch.c                  |   9 +++
 drivers/i2c/busses/i2c-ismt.c                 |  14 ++++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c      |   1 +
 drivers/md/dm-crypt.c                         |  14 +++-
 drivers/md/dm-integrity.c                     |   2 -
 drivers/md/dm-stats.c                         |   8 ++
 drivers/md/dm-verity-target.c                 |   1 +
 drivers/md/raid5.c                            |  47 ++++++-----
 drivers/net/ethernet/faraday/ftgmac100.c      |   5 ++
 drivers/net/ipa/ipa_endpoint.c                |   4 +-
 drivers/nfc/pn533/pn533.c                     |   5 +-
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c |   2 +-
 fs/exfat/balloc.c                             |   8 +-
 fs/exfat/exfat_fs.h                           |   8 ++
 fs/exfat/fatent.c                             |   8 --
 fs/exfat/namei.c                              |  27 +------
 fs/io_uring.c                                 |  47 ++---------
 fs/nfs/internal.h                             |   1 +
 fs/nfsd/nfs4state.c                           |  12 +--
 fs/pipe.c                                     |  33 ++++----
 fs/xfs/libxfs/xfs_bmap.c                      |   5 ++
 fs/xfs/libxfs/xfs_dir2.h                      |   2 -
 fs/xfs/libxfs/xfs_dir2_sf.c                   |   2 +-
 fs/xfs/xfs_buf_item.c                         |  37 +++++----
 fs/xfs/xfs_inode.c                            |  42 ++++++----
 fs/xfs/xfs_inode_item.c                       |  14 ++++
 fs/xfs/xfs_iwalk.c                            |   2 +-
 fs/xfs/xfs_log_cil.c                          |  22 ++++--
 fs/xfs/xfs_super.c                            |  10 ++-
 include/crypto/drbg.h                         |  10 ++-
 include/linux/pipe_fs_i.h                     |   2 +-
 include/net/netfilter/nf_conntrack_core.h     |   7 +-
 kernel/bpf/trampoline.c                       |  18 +++--
 lib/Kconfig                                   |   2 +
 lib/assoc_array.c                             |   8 ++
 lib/crypto/Kconfig                            |  17 ++--
 lib/percpu-refcount.c                         |   1 +
 mm/zsmalloc.c                                 |  37 ++++++++-
 net/core/filter.c                             |   4 +-
 net/key/af_key.c                              |   6 +-
 net/netfilter/nf_tables_api.c                 |  36 ++++++---
 net/wireless/core.c                           |   8 +-
 net/wireless/reg.c                            |   1 +
 59 files changed, 461 insertions(+), 335 deletions(-)


