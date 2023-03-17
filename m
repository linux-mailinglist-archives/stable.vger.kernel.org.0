Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A216B6BE292
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjCQIFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCQIF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:05:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4891AB71B3;
        Fri, 17 Mar 2023 01:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95FF1B824AE;
        Fri, 17 Mar 2023 08:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C70C433EF;
        Fri, 17 Mar 2023 08:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040273;
        bh=COGKtVU38G0h5Oc6ErSGx6+gRoEZERNs1qFkTfyDZ4M=;
        h=From:To:Cc:Subject:Date:From;
        b=qTHImShFqzvGgjz0b7j7gq9uB1uZw5P8YuXEcINkYvR5HKEykDG8x95/qhMdf6Xsx
         x0f6lfcDG4yXcmXZNaOAHvzmRj+Q+p5m7SirF01ZjbD5rJpZMorpnN1AhFWC+OxtWt
         9Li8iKpxQq5S3jcs1hjnlyfinGaEL4exa5EqkATc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.103
Date:   Fri, 17 Mar 2023 09:04:23 +0100
Message-Id: <1679040264214179@kroah.com>
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

I'm announcing the release of the 5.15.103 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt         |   51 +-
 Documentation/trace/ftrace.rst                          |    2 
 Makefile                                                |    3 
 arch/alpha/kernel/module.c                              |    4 
 arch/arm64/include/asm/efi.h                            |    6 
 arch/arm64/kernel/efi.c                                 |    2 
 arch/mips/include/asm/mach-rc32434/pci.h                |    2 
 arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts            |    1 
 arch/powerpc/kernel/iommu.c                             |    4 
 arch/powerpc/kernel/time.c                              |    4 
 arch/powerpc/kernel/vmlinux.lds.S                       |    6 
 arch/riscv/include/asm/ftrace.h                         |    2 
 arch/riscv/include/asm/parse_asm.h                      |    5 
 arch/riscv/include/asm/patch.h                          |    2 
 arch/riscv/kernel/ftrace.c                              |   14 
 arch/riscv/kernel/patch.c                               |   28 +
 arch/riscv/kernel/stacktrace.c                          |    2 
 arch/riscv/kernel/traps.c                               |   14 
 arch/s390/kernel/ftrace.c                               |   86 ---
 arch/s390/kernel/vmlinux.lds.S                          |    2 
 arch/sh/kernel/vmlinux.lds.S                            |    1 
 arch/um/kernel/vmlinux.lds.S                            |    2 
 arch/x86/kernel/cpu/amd.c                               |    9 
 arch/x86/kvm/lapic.c                                    |    1 
 arch/x86/kvm/svm/avic.c                                 |   28 -
 arch/x86/kvm/vmx/evmcs.h                                |   11 
 arch/x86/kvm/vmx/vmx.c                                  |   44 +
 drivers/block/brd.c                                     |   10 
 drivers/block/nbd.c                                     |   14 
 drivers/char/ipmi/ipmi_ssif.c                           |   34 +
 drivers/char/tpm/eventlog/acpi.c                        |    6 
 drivers/gpu/drm/amd/amdgpu/soc15.c                      |    5 
 drivers/gpu/drm/drm_atomic.c                            |    1 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                   |    6 
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c               |    4 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c          |    6 
 drivers/gpu/drm/msm/msm_gem_submit.c                    |    5 
 drivers/gpu/drm/nouveau/dispnv50/disp.c                 |   16 
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                 |   12 
 drivers/gpu/drm/nouveau/dispnv50/wndw.h                 |    7 
 drivers/iommu/amd/init.c                                |  105 +++-
 drivers/iommu/intel/pasid.c                             |    7 
 drivers/macintosh/windfarm_lm75_sensor.c                |    4 
 drivers/macintosh/windfarm_smu_sensors.c                |    4 
 drivers/media/i2c/ov5640.c                              |    2 
 drivers/media/rc/gpio-ir-recv.c                         |   18 
 drivers/net/dsa/mt7530.c                                |   35 -
 drivers/net/ethernet/broadcom/bgmac.c                   |    8 
 drivers/net/ethernet/broadcom/bgmac.h                   |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c               |   23 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c            |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         |    5 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c |    7 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     |   16 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c     |   58 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c             |    3 
 drivers/net/ethernet/mediatek/mtk_eth_soc.h             |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |    1 
 drivers/net/phy/microchip.c                             |   32 +
 drivers/net/phy/phy_device.c                            |    8 
 drivers/net/phy/smsc.c                                  |   20 
 drivers/net/usb/lan78xx.c                               |   27 -
 drivers/nfc/fdp/i2c.c                                   |    4 
 drivers/platform/x86/Kconfig                            |    3 
 drivers/regulator/core.c                                |   27 +
 drivers/scsi/hosts.c                                    |    2 
 drivers/scsi/megaraid/megaraid_sas.h                    |    2 
 drivers/scsi/megaraid/megaraid_sas_fp.c                 |    2 
 drivers/staging/rtl8723bs/core/rtw_ap.c                 |   20 
 drivers/staging/rtl8723bs/core/rtw_cmd.c                |   96 ++--
 drivers/staging/rtl8723bs/core/rtw_ioctl_set.c          |    4 
 drivers/staging/rtl8723bs/core/rtw_mlme.c               |    6 
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c           |   56 +-
 drivers/staging/rtl8723bs/core/rtw_security.c           |    6 
 drivers/staging/rtl8723bs/include/rtw_security.h        |    8 
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c       |  355 +++++-----------
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c          |   51 +-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c             |    4 
 fs/attr.c                                               |   72 +++
 fs/btrfs/block-group.c                                  |    3 
 fs/dlm/lockspace.c                                      |   21 
 fs/dlm/lowcomms.c                                       |   16 
 fs/dlm/lowcomms.h                                       |    1 
 fs/dlm/main.c                                           |    7 
 fs/dlm/midcomms.c                                       |   17 
 fs/dlm/midcomms.h                                       |    3 
 fs/ext4/block_validity.c                                |   26 -
 fs/ext4/ext4.h                                          |    3 
 fs/ext4/fsmap.c                                         |    2 
 fs/ext4/inline.c                                        |    1 
 fs/ext4/inode.c                                         |    7 
 fs/ext4/ioctl.c                                         |    1 
 fs/ext4/mballoc.c                                       |  205 +++++----
 fs/ext4/namei.c                                         |   36 +
 fs/ext4/page-io.c                                       |   11 
 fs/ext4/xattr.c                                         |    3 
 fs/f2fs/checkpoint.c                                    |    2 
 fs/f2fs/compress.c                                      |    2 
 fs/f2fs/data.c                                          |    8 
 fs/f2fs/f2fs.h                                          |    2 
 fs/f2fs/file.c                                          |    2 
 fs/f2fs/gc.c                                            |    6 
 fs/f2fs/inline.c                                        |    4 
 fs/f2fs/inode.c                                         |   14 
 fs/f2fs/node.c                                          |   23 -
 fs/f2fs/recovery.c                                      |    2 
 fs/f2fs/segment.c                                       |    2 
 fs/file.c                                               |    1 
 fs/fuse/file.c                                          |    2 
 fs/inode.c                                              |   90 ++--
 fs/internal.h                                           |   10 
 fs/locks.c                                              |    3 
 fs/namei.c                                              |   82 +++
 fs/namespace.c                                          |   29 -
 fs/ocfs2/file.c                                         |    4 
 fs/ocfs2/namei.c                                        |    1 
 fs/open.c                                               |    8 
 fs/udf/inode.c                                          |    2 
 fs/xfs/xfs_bmap_util.c                                  |    9 
 fs/xfs/xfs_file.c                                       |   24 -
 fs/xfs/xfs_iops.c                                       |   56 --
 fs/xfs/xfs_iops.h                                       |    1 
 fs/xfs/xfs_pnfs.c                                       |    9 
 include/asm-generic/vmlinux.lds.h                       |    5 
 include/linux/fs.h                                      |    6 
 include/linux/pci_ids.h                                 |    2 
 include/net/netfilter/nf_tproxy.h                       |    7 
 kernel/bpf/btf.c                                        |    1 
 kernel/fork.c                                           |    2 
 kernel/irq/irqdomain.c                                  |  152 ++++--
 kernel/watch_queue.c                                    |    1 
 net/caif/caif_usb.c                                     |    3 
 net/ipv4/netfilter/nf_tproxy_ipv4.c                     |    2 
 net/ipv4/tcp_bpf.c                                      |    6 
 net/ipv4/udp_bpf.c                                      |    3 
 net/ipv6/ila/ila_xlat.c                                 |    1 
 net/ipv6/netfilter/nf_tproxy_ipv6.c                     |    2 
 net/netfilter/nf_conntrack_core.c                       |    4 
 net/netfilter/nf_conntrack_netlink.c                    |   14 
 net/nfc/netlink.c                                       |    2 
 net/smc/af_smc.c                                        |   13 
 net/sunrpc/svc.c                                        |    6 
 net/unix/af_unix.c                                      |   16 
 net/unix/unix_bpf.c                                     |    3 
 scripts/checkkconfigsymbols.py                          |   13 
 scripts/clang-tools/run-clang-tools.py                  |   21 
 scripts/diffconfig                                      |   16 
 tools/bpf/Makefile                                      |    5 
 tools/bpf/bpf_jit_disasm.c                              |    5 
 tools/bpf/bpftool/Makefile                              |    5 
 tools/bpf/bpftool/jit_disasm.c                          |   42 +
 tools/build/Makefile.feature                            |    1 
 tools/build/feature/Makefile                            |    4 
 tools/build/feature/test-all.c                          |    4 
 tools/build/feature/test-disassembler-init-styled.c     |   13 
 tools/include/tools/dis-asm-compat.h                    |   55 ++
 tools/perf/Makefile.config                              |    8 
 tools/perf/builtin-inject.c                             |    1 
 tools/perf/builtin-stat.c                               |   15 
 tools/perf/util/annotate.c                              |    7 
 tools/perf/util/stat.c                                  |    6 
 tools/perf/util/stat.h                                  |    1 
 tools/perf/util/target.h                                |   12 
 tools/testing/selftests/netfilter/nft_nat.sh            |    2 
 virt/kvm/kvm_main.c                                     |  145 ++++--
 166 files changed, 1779 insertions(+), 1189 deletions(-)

Alex Deucher (1):
      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15

Alexander Aring (3):
      fs: dlm: fix log of lowcomms vs midcomms
      fs: dlm: add midcomms init/start functions
      fs: dlm: start midcomms before scand

Alexandre Ghiti (1):
      riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

Alexandru Matei (1):
      KVM: VMX: Fix crash due to uninitialized current_vmcs

Alvaro Karsz (1):
      PCI: Add SolidRun vendor ID

Andres Freund (5):
      tools build: Add feature test for init_disassemble_info API changes
      tools include: add dis-asm-compat.h to handle version differences
      tools perf: Fix compilation error with new binutils
      tools bpf_jit_disasm: Fix compilation error with new binutils
      tools bpftool: Fix compilation error with new binutils

Andrew Cooper (1):
      x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Bart Van Assche (1):
      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Ben Skeggs (1):
      drm/nouveau/kms/nv50-: remove unused functions

Benjamin Coddington (1):
      SUNRPC: Fix a server shutdown leak

Chandrakanth Patil (1):
      scsi: megaraid_sas: Update max supported LD IDs to 240

Changbin Du (1):
      perf stat: Fix counting when initial delay configured

Christian Brauner (6):
      attr: add in_group_or_capable()
      fs: move should_remove_suid()
      attr: add setattr_should_drop_sgid()
      attr: use consistent sgid stripping checks
      fs: use consistent setgid checks in is_sxid()
      fs: hold writers when changing mount's idmapping

Christian Kohlschütter (1):
      regulator: core: Fix off-on-delay-us for always-on/boot-on regulators

Christoph Hellwig (1):
      nbd: use the correct block_device in nbd_bdev_reset

Conor Dooley (1):
      RISC-V: Don't check text_mutex during stop_machine

Corey Minyard (2):
      ipmi:ssif: Increase the message retry time
      ipmi:ssif: Add a timer between request retries

D. Wythe (1):
      net/smc: fix fallback failed while sendmsg with fastopen

Daniel Golle (1):
      net: ethernet: mtk_eth_soc: fix RX data corruption issue

Darrick J. Wong (2):
      ext4: fix another off-by-one fsmap error on 1k block filesystems
      xfs: use setattr_copy to set vfs inode attributes

Dave Chinner (3):
      xfs: remove XFS_PREALLOC_SYNC
      xfs: fallocate() should call file_modified()
      xfs: set prealloc flag in xfs_alloc_file_space()

David Disseldorp (1):
      watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths

Dmitry Baryshkov (5):
      drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
      drm/msm/a5xx: fix highest bank bit for a530
      drm/msm/a5xx: fix the emptyness check in the preempt code
      drm/msm/a5xx: fix context faults during ring switch
      drm/msm/dpu: fix len of sc7180 ctl blocks

Edward Humes (1):
      alpha: fix R_ALPHA_LITERAL reloc for large modules

Eric Biggers (1):
      ext4: fix cgroup writeback accounting with fs-layer encryption

Eric Dumazet (3):
      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
      netfilter: conntrack: adopt safer max chain length
      af_unix: fix struct pid leaks in OOB support

Eric Whitney (1):
      ext4: fix RENAME_WHITEOUT handling for inline directories

Fedor Pchelkin (1):
      nfc: change order inside nfc_se_io error path

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Gaosheng Cui (1):
      xfs: remove xfs_setattr_time() declaration

Gavrilov Ilia (1):
      iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Greg Kroah-Hartman (2):
      powerpc/iommu: fix memory leak with using debugfs_lookup()
      Linux 5.15.103

Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Hannes Braun (1):
      staging: rtl8723bs: fix placement of braces

Hans de Goede (2):
      staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()
      staging: rtl8723bs: Fix key-store index handling

Harry Wentland (1):
      drm/connector: print max_requested_bpc in state debugfs

Heiko Carstens (1):
      s390/ftrace: remove dead code

Heiner Kallweit (1):
      net: phy: smsc: fix link up detection in forced irq mode

Ivan Delalande (1):
      netfilter: ctnetlink: revert to dumping mark regardless of event type

Jacob Pan (1):
      iommu/vt-d: Fix PASID directory pointer coherency

Jaegeuk Kim (3):
      f2fs: avoid down_write on nat_tree_lock during checkpoint
      f2fs: do not bother checkpoint by f2fs_get_node_info
      f2fs: retry to update the inode page given data corruption

Jagath Jog J (1):
      Staging: rtl8723bs: Placing opening { braces in previous line

Jan Kara (3):
      udf: Fix off-by-one error when discarding preallocation
      ext4: Fix possible corruption when moving a directory
      ext4: Fix deadlock during directory rename

Jens Axboe (1):
      brd: mark as nowait compatible

Jiri Slaby (SUSE) (1):
      drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype

Johan Hovold (2):
      irqdomain: Refactor __irq_domain_alloc_irqs()
      irqdomain: Fix mapping-creation race

Johannes Thumshirn (1):
      btrfs: fix percent calculation for bg reclaim message

Kang Chen (1):
      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Kim Phillips (1):
      iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Kuniyuki Iwashima (1):
      af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.

Li Jun (1):
      media: rc: gpio-ir-recv: add remove function

Liao Chang (1):
      riscv: Add header include guards to insn.h

Liu Jian (1):
      bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()

Lorenz Bauer (1):
      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Luis Chamberlain (1):
      block/brd: add error handling support for add_disk()

Lukas Czerner (1):
      ext4: block range must be validated before use in ext4_mb_clear_bb()

Lukas Wunner (1):
      net: phy: smsc: Cache interrupt mask

Mark Brown (1):
      regulator: Flag uncontrollable regulators as always_on

Masahiro Yamada (4):
      scripts: handle BrokenPipeError for python scripts
      arch: fix broken BuildID for arm64 and riscv
      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
      UML: define RUNTIME_DISCARD_EXIT

Matthias Kaehlcke (1):
      regulator: core: Use ktime_get_boottime() to determine how long a regulator was off

Mattias Nissler (1):
      riscv: Avoid enabling interrupts in die()

Miaohe Lin (1):
      KVM: fix memoryleak in kvm_init()

Michael Chan (1):
      bnxt_en: Avoid order-5 memory allocation for TPA data

Michael Ellerman (2):
      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Michael Straube (1):
      staging: rtl8723bs: clean up comparsions to NULL

Morten Linderud (1):
      tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address

Namhyung Kim (1):
      perf inject: Fix --buildid-all not to eat up MMAP2

Nathan Chancellor (1):
      macintosh: windfarm: Use unsigned type for 1-bit bitfields

Nick Desaulniers (1):
      Makefile: use -gdwarf-{4|5} for assembler for DEBUG_INFO_DWARF{4|5}

Palmer Dabbelt (1):
      RISC-V: Avoid dereferening NULL regs in die()

Paul Elder (1):
      media: ov5640: Fix analogue gain control

Petr Oros (1):
      ice: copy last block omitted in ice_get_module_eeprom()

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

Rob Clark (1):
      drm/msm: Fix potential invalid ptr free

Rohan McLure (1):
      powerpc/kcsan: Exclude udelay to prevent recursive instrumentation

Rongguang Wei (1):
      net: stmmac: add to set device wake up flag when stmmac init phy

Russell King (Oracle) (1):
      net: phylib: get rid of unnecessary locking

Sean Christopherson (3):
      KVM: Register /dev/kvm as the _very_ last thing during initialization
      KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure
      KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target

Seth Forshee (1):
      filelocks: use mount idmapping for setlease permission check

Shigeru Yoshida (1):
      net: caif: Fix use-after-free in cfusbl_device_notify()

Suman Ghosh (1):
      octeontx2-af: Unlock contexts in the queue context cache in case of fault detection

Suravee Suthikulpanit (1):
      iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Theodore Ts'o (1):
      fs: prevent out-of-bounds array speculation when closing a file descriptor

Tobias Klauser (1):
      fork: allow CLONE_NEWTIME in clone3 flags

Tom Saeger (1):
      sh: define RUNTIME_DISCARD_EXIT

Vitaly Kuznetsov (4):
      KVM: Optimize kvm_make_vcpus_request_mask() a bit
      KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
      KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
      KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper

Vladimir Oltean (2):
      powerpc: dts: t1040rdb: fix compatible string for Rev A boards
      net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC

Yang Xu (2):
      fs: add mode_strip_sgid() helper
      fs: move S_ISGID stripping into the vfs_*() helpers

Ye Bin (2):
      ext4: move where set the MAY_INLINE_DATA flag is set
      ext4: fix WARNING in ext4_update_inline_data

Yuiko Oshino (1):
      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Zhihao Cheng (1):
      ext4: zero i_disksize when initializing the bootloader inode

xurui (1):
      MIPS: Fix a compilation issue

