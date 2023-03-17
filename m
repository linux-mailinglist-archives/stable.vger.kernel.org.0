Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3523A6BE287
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCQIE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjCQIEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A3EAD033;
        Fri, 17 Mar 2023 01:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD01062205;
        Fri, 17 Mar 2023 08:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E0EC4339B;
        Fri, 17 Mar 2023 08:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040267;
        bh=J9VI7hV+7M2xAab1Pct2iLnwGPAThxz72acHT3fG7Vg=;
        h=From:To:Cc:Subject:Date:From;
        b=Y3lTFOBjEyPJJxKiJrcE3S8MHLMRb9724EQ6nQTHJrwTDWSIluN9lSk5tHRsJbbPq
         wpmhskHT5Z4Gj5F+KSzq/5vTNQAE96J0pzNUl/mGvEZGFYQOetW1GzKPQBgudRrMXH
         RtpoE0YPgE0FevopyVuw23CpKAWs2bozzvnGX+OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.175
Date:   Fri, 17 Mar 2023 09:04:18 +0100
Message-Id: <1679040259217113@kroah.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.175 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/kernel/module.c                        |    4 
 arch/arm64/include/asm/efi.h                      |    6 
 arch/arm64/kernel/efi.c                           |    2 
 arch/mips/include/asm/mach-rc32434/pci.h          |    2 
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts      |    1 
 arch/powerpc/kernel/time.c                        |    4 
 arch/powerpc/kernel/vmlinux.lds.S                 |    6 
 arch/riscv/include/asm/ftrace.h                   |    2 
 arch/riscv/include/asm/parse_asm.h                |    5 
 arch/riscv/include/asm/patch.h                    |    2 
 arch/riscv/kernel/ftrace.c                        |   14 +
 arch/riscv/kernel/patch.c                         |   28 ++
 arch/riscv/kernel/stacktrace.c                    |    2 
 arch/riscv/kernel/traps.c                         |   14 -
 arch/s390/kernel/vmlinux.lds.S                    |    2 
 arch/sh/kernel/vmlinux.lds.S                      |    1 
 arch/um/kernel/vmlinux.lds.S                      |    2 
 arch/x86/kernel/cpu/amd.c                         |    9 
 arch/x86/kvm/vmx/evmcs.h                          |   11 
 arch/x86/kvm/vmx/vmx.c                            |   44 ++-
 block/bfq-cgroup.c                                |    8 
 block/bfq-iosched.c                               |   19 +
 drivers/char/ipmi/ipmi_watchdog.c                 |    8 
 drivers/char/tpm/eventlog/acpi.c                  |    6 
 drivers/gpu/drm/amd/amdgpu/soc15.c                |    5 
 drivers/gpu/drm/drm_atomic.c                      |    1 
 drivers/gpu/drm/i915/gt/intel_ring.c              |    4 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c             |    8 
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c         |   16 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c             |    4 
 drivers/gpu/drm/msm/msm_gem_submit.c              |    5 
 drivers/gpu/drm/msm/msm_ringbuffer.c              |    2 
 drivers/gpu/drm/msm/msm_ringbuffer.h              |    7 
 drivers/gpu/drm/nouveau/dispnv50/disp.c           |   16 -
 drivers/gpu/drm/nouveau/dispnv50/wndw.c           |   12 -
 drivers/gpu/drm/nouveau/dispnv50/wndw.h           |    7 
 drivers/iommu/amd/init.c                          |   16 +
 drivers/iommu/intel/pasid.c                       |   28 +-
 drivers/irqchip/irq-aspeed-vic.c                  |    4 
 drivers/irqchip/irq-bcm7120-l2.c                  |    2 
 drivers/irqchip/irq-csky-apb-intc.c               |    2 
 drivers/irqchip/irq-gic-v2m.c                     |    2 
 drivers/irqchip/irq-gic-v3-its.c                  |   10 
 drivers/irqchip/irq-gic-v3.c                      |    2 
 drivers/irqchip/irq-loongson-pch-pic.c            |    2 
 drivers/irqchip/irq-meson-gpio.c                  |    2 
 drivers/irqchip/irq-mtk-cirq.c                    |    2 
 drivers/irqchip/irq-mxs.c                         |    4 
 drivers/irqchip/irq-sun4i.c                       |    2 
 drivers/irqchip/irq-ti-sci-inta.c                 |    2 
 drivers/irqchip/irq-vic.c                         |    4 
 drivers/irqchip/irq-xilinx-intc.c                 |    2 
 drivers/macintosh/windfarm_lm75_sensor.c          |    4 
 drivers/macintosh/windfarm_smu_sensors.c          |    4 
 drivers/media/i2c/ov5640.c                        |    2 
 drivers/media/rc/gpio-ir-recv.c                   |   18 +
 drivers/net/ethernet/broadcom/bgmac.c             |    8 
 drivers/net/ethernet/broadcom/bgmac.h             |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   23 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h       |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    1 
 drivers/net/phy/microchip.c                       |   32 ++
 drivers/net/phy/phy_device.c                      |    8 
 drivers/net/usb/lan78xx.c                         |  189 ++++++---------
 drivers/nfc/fdp/i2c.c                             |    4 
 drivers/platform/x86/Kconfig                      |    3 
 drivers/s390/block/dasd_diag.c                    |    7 
 drivers/s390/block/dasd_fba.c                     |    7 
 drivers/s390/block/dasd_int.h                     |    1 
 drivers/scsi/hosts.c                              |    2 
 drivers/scsi/megaraid/megaraid_sas.h              |    2 
 drivers/scsi/megaraid/megaraid_sas_fp.c           |    2 
 fs/ext4/block_validity.c                          |   26 +-
 fs/ext4/ext4.h                                    |    3 
 fs/ext4/fsmap.c                                   |    2 
 fs/ext4/inline.c                                  |    1 
 fs/ext4/inode.c                                   |    7 
 fs/ext4/ioctl.c                                   |    1 
 fs/ext4/mballoc.c                                 |  205 +++++++++--------
 fs/ext4/namei.c                                   |   36 ++-
 fs/ext4/page-io.c                                 |   11 
 fs/ext4/xattr.c                                   |    3 
 fs/file.c                                         |    1 
 fs/udf/inode.c                                    |    2 
 include/asm-generic/vmlinux.lds.h                 |    5 
 include/linux/irq.h                               |    4 
 include/linux/irqdesc.h                           |    2 
 include/linux/irqdomain.h                         |    2 
 include/linux/pci_ids.h                           |    2 
 include/net/netfilter/nf_tproxy.h                 |    7 
 kernel/bpf/btf.c                                  |    1 
 kernel/fork.c                                     |    2 
 kernel/irq/chip.c                                 |    2 
 kernel/irq/dummychip.c                            |    2 
 kernel/irq/irqdesc.c                              |    2 
 kernel/irq/irqdomain.c                            |  262 +++++++++++++---------
 kernel/irq/manage.c                               |    6 
 kernel/irq/msi.c                                  |    2 
 kernel/irq/timings.c                              |    2 
 kernel/watch_queue.c                              |    1 
 net/caif/caif_usb.c                               |    3 
 net/core/dev.c                                    |    1 
 net/core/skbuff.c                                 |    1 
 net/ipv4/netfilter/nf_tproxy_ipv4.c               |    2 
 net/ipv6/ila/ila_xlat.c                           |    1 
 net/ipv6/netfilter/nf_tproxy_ipv6.c               |    2 
 net/netfilter/nf_conntrack_netlink.c              |   14 -
 net/nfc/netlink.c                                 |    2 
 net/smc/af_smc.c                                  |   13 -
 net/sunrpc/svc.c                                  |    6 
 scripts/checkkconfigsymbols.py                    |   13 +
 scripts/clang-tools/run-clang-tools.py            |   21 +
 scripts/diffconfig                                |   16 +
 tools/testing/selftests/netfilter/nft_nat.sh      |    2 
 116 files changed, 855 insertions(+), 544 deletions(-)

Alex Deucher (1):
      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15

Alexandre Ghiti (1):
      riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Alexandru Matei (1):
      KVM: VMX: Fix crash due to uninitialized current_vmcs

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Bart Van Assche (1):
      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Ben Skeggs (1):
      drm/nouveau/kms/nv50-: remove unused functions

Benjamin Coddington (1):
      SUNRPC: Fix a server shutdown leak

Bixuan Cui (1):
      irqdomain: Change the type of 'size' in __irq_domain_add() to be consistent

Chandrakanth Patil (1):
      scsi: megaraid_sas: Update max supported LD IDs to 240

Conor Dooley (1):
      RISC-V: Don't check text_mutex during stop_machine

Corey Minyard (1):
      ipmi:watchdog: Set panic count to proper value on a panic

D. Wythe (1):
      net/smc: fix fallback failed while sendmsg with fastopen

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix RX data corruption issue

Darrick J. Wong (1):
      ext4: fix another off-by-one fsmap error on 1k block filesystems

David Disseldorp (1):
      watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Dmitry Baryshkov (3):
      drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
      drm/msm/a5xx: fix the emptyness check in the preempt code
      drm/msm/a5xx: fix context faults during ring switch

Edward Humes (1):
      alpha: fix R_ALPHA_LITERAL reloc for large modules

Eric Biggers (1):
      ext4: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (1):
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Eric Whitney (1):
      ext4: fix RENAME_WHITEOUT handling for inline directories

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Gavrilov Ilia (1):
      iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Greg Kroah-Hartman (1):
      Linux 5.10.175

Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Harry Wentland (1):
      drm/connector: print max_requested_bpc in state debugfs

Ingo Molnar (1):
      irq: Fix typos in comments

Ivan Delalande (1):
      netfilter: ctnetlink: revert to dumping mark regardless of event type

Jacob Pan (1):
      iommu/vt-d: Fix PASID directory pointer coherency

Jan Kara (3):
      udf: Fix off-by-one error when discarding preallocation
      ext4: Fix possible corruption when moving a directory
      ext4: Fix deadlock during directory rename

Jiri Slaby (SUSE) (1):
      drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype

Johan Hovold (3):
      irqdomain: Look for existing mapping only once
      irqdomain: Refactor __irq_domain_alloc_irqs()
      irqdomain: Fix mapping-creation race

John Harrison (1):
      drm/i915: Don't use BAR mappings for ring buffers with LLC

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Lee Jones (1):
      net: usb: lan78xx: Remove lots of set but unused 'ret' variables

Li Jun (1):
      media: rc: gpio-ir-recv: add remove function

Liao Chang (1):
      riscv: Add header include guards to insn.h

Lorenz Bauer (1):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Lu Baolu (1):
      iommu/vt-d: Fix lockdep splat in intel_pasid_get_entry()

Lukas Czerner (1):
      ext4: block range must be validated before use in ext4_mb_clear_bb()

Marc Zyngier (1):
      irqdomain: Fix domain registration race

Masahiro Yamada (4):
      scripts: handle BrokenPipeError for python scripts
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
      UML: define RUNTIME_DISCARD_EXIT

Mattias Nissler (1):
      riscv: Avoid enabling interrupts in die()

Michael Chan (1):
      bnxt_en: Avoid order-5 memory allocation for TPA data

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Morten Linderud (1):
      tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

NeilBrown (1):
      block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

Palmer Dabbelt (1):
      RISC-V: Avoid dereferening NULL regs in die()

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Pierre Gondois (1):
      arm64: efi: Make efi_rt_lock a raw_spinlock

Rafał Miłecki (1):
      bgmac: fix *initial* chip reset to support BCM5358

Randy Dunlap (1):
      platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it

Ritesh Harjani (3):
      ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
      ext4: add ext4_sb_block_valid() refactored out of ext4_inode_block_valid()
      ext4: add strict range checks while freeing blocks

Rob Clark (2):
      drm/msm: Fix potential invalid ptr free
      drm/msm: Document and rename preempt_lock

Rohan McLure (1):
      powerpc/kcsan: Exclude udelay to prevent recursive instrumentation

Rongguang Wei (1):
      net: stmmac: add to set device wake up flag when stmmac init phy

Russell King (Oracle) (1):
      net: phylib: get rid of unnecessary locking

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Stefan Haberland (1):
      s390/dasd: add missing discipline function

Tao Liu (1):
      skbuff: Fix nfct leak on napi stolen

Theodore Ts'o (1):
      fs: prevent out-of-bounds array speculation when closing a file descriptor

Tobias Klauser (1):
      fork: allow CLONE_NEWTIME in clone3 flags

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

Vitaly Kuznetsov (2):
      KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
      KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

Vladimir Oltean (1):
      powerpc: dts: t1040rdb: fix compatible string for Rev A boards

Ye Bin (2):
      ext4: move where set the MAY_INLINE_DATA flag is set
      ext4: fix WARNING in ext4_update_inline_data

Yejune Deng (1):
      ipmi/watchdog: replace atomic_add() and atomic_sub()

Yu Kuai (4):
      block, bfq: fix possible uaf for 'bfqq->bic'
      block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq
      block, bfq: replace 0/1 with false/true in bic apis
      block, bfq: fix uaf for bfqq in bic_set_bfqq()

Yuiko Oshino (1):
      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Zhihao Cheng (1):
      ext4: zero i_disksize when initializing the bootloader inode

xurui (1):
      MIPS: Fix a compilation issue

