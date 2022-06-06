Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714F553E259
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiFFHFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiFFHFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB502DD73;
        Mon,  6 Jun 2022 00:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1579BB80DEF;
        Mon,  6 Jun 2022 07:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DABC385A9;
        Mon,  6 Jun 2022 07:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499097;
        bh=yxyAG4ds1waye8mVwWdz7Ikap0O1inI6ak7Nz6TPC4c=;
        h=From:To:Cc:Subject:Date:From;
        b=Hb/OE6IVFKbz0l6SriDTkh1y44mJxI55arIhXFmz7vAdevKNTLasC2XD2igqSYiUK
         TMSLCRIbIC9VZJPlHQKkEIloBmkgYT8otlriVh+4e1ZoLJ+E55RBsVA5bQb5xNBlQN
         jAvqnz178TNTFBqKBInyyRALdKFL4IUos7e5ZfH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.45
Date:   Mon,  6 Jun 2022 09:04:49 +0200
Message-Id: <16544990891688@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.45 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/submitting-patches.rst  |    2 
 Makefile                                      |    2 
 arch/arm/boot/dts/s5pv210-aries.dtsi          |    2 
 arch/arm64/kvm/arm.c                          |    3 
 arch/powerpc/kvm/book3s_hv_uvmem.c            |    8 +
 arch/x86/kernel/cpu/sgx/encl.c                |  113 +++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/encl.h                |    2 
 arch/x86/kernel/cpu/sgx/main.c                |   13 ++
 arch/x86/kernel/kvm.c                         |   41 ++++++---
 arch/x86/kvm/svm/nested.c                     |    3 
 arch/x86/kvm/svm/sev.c                        |   12 +-
 arch/x86/kvm/vmx/nested.c                     |    3 
 arch/x86/kvm/x86.c                            |   31 ++++---
 crypto/Kconfig                                |    2 
 crypto/drbg.c                                 |  110 ++++++++++---------------
 crypto/ecrdsa.c                               |    8 -
 drivers/bluetooth/hci_qca.c                   |    4 
 drivers/char/random.c                         |    2 
 drivers/char/tpm/tpm2-cmd.c                   |   11 ++
 drivers/char/tpm/tpm_ibmvtpm.c                |    1 
 drivers/crypto/caam/ctrl.c                    |   18 ++++
 drivers/gpu/drm/i915/intel_pm.c               |    2 
 drivers/hid/hid-ids.h                         |    1 
 drivers/hid/hid-multitouch.c                  |    9 ++
 drivers/i2c/busses/i2c-ismt.c                 |   17 +++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c      |    1 
 drivers/md/dm-crypt.c                         |   14 ++-
 drivers/md/dm-integrity.c                     |    2 
 drivers/md/dm-stats.c                         |    8 +
 drivers/md/dm-verity-target.c                 |    1 
 drivers/md/raid5.c                            |   47 +++++-----
 drivers/media/i2c/imx412.c                    |    8 -
 drivers/net/ethernet/faraday/ftgmac100.c      |    5 +
 drivers/net/ipa/ipa_endpoint.c                |    4 
 drivers/nfc/pn533/pn533.c                     |    5 -
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c |    2 
 fs/exfat/balloc.c                             |    8 +
 fs/exfat/exfat_fs.h                           |    8 +
 fs/exfat/fatent.c                             |    8 -
 fs/nfs/internal.h                             |    1 
 fs/nfsd/nfs4state.c                           |   12 --
 fs/ntfs3/super.c                              |   10 +-
 fs/pipe.c                                     |   33 ++++---
 include/crypto/drbg.h                         |   10 +-
 include/linux/pipe_fs_i.h                     |    2 
 include/net/netfilter/nf_conntrack_core.h     |    7 +
 kernel/bpf/stackmap.c                         |    1 
 kernel/bpf/trampoline.c                       |   18 ++--
 kernel/bpf/verifier.c                         |   17 +++
 lib/Kconfig                                   |    2 
 lib/assoc_array.c                             |    8 +
 lib/crypto/Kconfig                            |   17 ++-
 lib/percpu-refcount.c                         |    1 
 mm/zsmalloc.c                                 |   37 +++++++-
 net/core/filter.c                             |    4 
 net/key/af_key.c                              |    6 -
 net/netfilter/nf_tables_api.c                 |   94 +++++++++++++++------
 sound/usb/clock.c                             |   11 ++
 sound/usb/pcm.c                               |   17 ++-
 sound/usb/quirks-table.h                      |    3 
 sound/usb/quirks.c                            |    2 
 61 files changed, 585 insertions(+), 269 deletions(-)

Akira Yokosawa (1):
      docs: submitting-patches: Fix crossref to 'The canonical patch format'

Al Viro (1):
      percpu_ref_init(): clean ->percpu_count_ref on failure

Alex Elder (1):
      net: ipa: compute proper aggregation limit

Ashish Kalra (1):
      KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak

Bryan O'Donoghue (2):
      media: i2c: imx412: Fix reset GPIO polarity
      media: i2c: imx412: Fix power_off ordering

Chuck Lever (1):
      NFSD: Fix possible sleep during nfsd4_release_lockowner()

Craig McLure (1):
      ALSA: usb-audio: Configure sync endpoints before data

Dan Carpenter (2):
      i2c: ismt: prevent memory corruption in ismt_access()
      dm integrity: fix error code in dm_integrity_ctr()

David Howells (1):
      pipe: Fix missing lock in pipe_resize_ring()

Fabio Estevam (1):
      crypto: caam - fix i.MX6SX entropy delay value

Florian Westphal (1):
      netfilter: conntrack: re-fetch conntrack after insertion

Forest Crossman (1):
      ALSA: usb-audio: Don't get sample rate for MCT Trigger 5 USB-to-HDMI

Greg Kroah-Hartman (1):
      Linux 5.15.45

Gustavo A. R. Silva (1):
      drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

IotaHydrae (1):
      pinctrl: sunxi: fix f1c100s uart2 function

Joel Stanley (1):
      net: ftgmac100: Disable hardware checksum on AST2600

Jonathan Bakker (1):
      ARM: dts: s5pv210: Correct interrupt name for bluetooth in Aries

Justin M. Forbes (1):
      lib/crypto: add prompts back to crypto libraries

Kumar Kartikeya Dwivedi (2):
      bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access
      bpf: Check PTR_TO_MEM | MEM_RDONLY in check_helper_mem_access

Kuniyuki Iwashima (1):
      pipe: make poll_usage boolean and annotate its access

Lin Ma (1):
      nfc: pn533: Fix buggy cleanup order

Liu Jian (1):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Marek Maślanka (1):
      HID: multitouch: Add support for Google Whiskers Touchpad

Mariusz Tkaczyk (1):
      raid5: introduce MD_BROKEN

Mika Westerberg (1):
      i2c: ismt: Provide a DMA buffer for Interrupt Cause Logging

Mikulas Patocka (2):
      dm crypt: make printing of the key constant-time
      dm stats: add cond_resched when looping over entries

Nicolai Stange (4):
      crypto: drbg - prepare for more fine-grained tracking of seeding state
      crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()
      crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
      crypto: drbg - make reseeding from get_random_bytes() synchronous

Pablo Neira Ayuso (4):
      netfilter: nf_tables: disallow non-stateful expression in sets earlier
      netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
      netfilter: nf_tables: hold mutex on netns pre_exit path
      netfilter: nf_tables: double hook unregistration in netns path

Paolo Bonzini (1):
      x86, kvm: use correct GFP flags for preemption disabled

Piyush Malgujar (1):
      drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Quentin Perret (1):
      KVM: arm64: Don't hypercall before EL2 init

Randy Dunlap (1):
      fs/ntfs3: validate BOOT sectors_per_clusters

Reinette Chatre (5):
      x86/sgx: Disconnect backing page references from dirty status
      x86/sgx: Mark PCMD page as dirty when modifying contents
      x86/sgx: Obtain backing storage page with enclave mutex held
      x86/sgx: Fix race between reclaimer and page fault handler
      x86/sgx: Ensure no data in PCMD page after truncate

Sarthak Kukreti (1):
      dm verity: set DM_TARGET_IMMUTABLE feature flag

Sean Christopherson (3):
      x86/kvm: Alloc dummy async #PF token outside of raw spinlock
      KVM: x86: avoid calling x86 emulator without a decoded instruction
      KVM: x86: Drop WARNs that assert a triple fault never "escapes" from L2

Stefan Mahnke-Hartmann (1):
      tpm: Fix buffer access in tpm2_get_tpm_pt()

Stephen Brennan (1):
      assoc_array: Fix BUG_ON during garbage collect

Steven Rostedt (1):
      Bluetooth: hci_qca: Use del_timer_sync() before freeing

Sultan Alsawaf (1):
      zsmalloc: fix races between asynchronous zspage free and page migration

Tadeusz Struk (1):
      exfat: check if cluster num is valid

Takashi Iwai (3):
      ALSA: usb-audio: Workaround for clock setup on TEAC devices
      ALSA: usb-audio: Add missing ep_idx in fixed EP quirks
      ALSA: usb-audio: Optimize TEAC clock quirk

Tao Jin (1):
      HID: multitouch: add quirks to enable Lenovo X12 trackpoint

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

Trond Myklebust (1):
      NFS: Memory allocation failures are not server fatal errors

Vitaly Chikunov (1):
      crypto: ecrdsa - Fix incorrect use of vli_cmp

Xiaomeng Tong (1):
      KVM: PPC: Book3S HV: fix incorrect NULL check on list iterator

Xiu Jianfeng (1):
      tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

Yuntao Wang (2):
      bpf: Fix potential array overflow in bpf_trampoline_get_progs()
      bpf: Fix excessive memory allocation in stack_map_alloc()

