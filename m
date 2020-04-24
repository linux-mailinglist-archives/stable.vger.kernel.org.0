Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1971C1B7065
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgDXJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgDXJOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:14:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DA820728;
        Fri, 24 Apr 2020 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719674;
        bh=+OfR0MtsR2+nwfka1mzx736r0pOWEVrdygmLgDKFhSc=;
        h=Date:From:To:Cc:Subject:From;
        b=lEYtAwTNWIb0HEujlW1JocBnAf8MVX/w7YvH2ZwL4KBEhUFMBh4ipNgnpehBnbxSJ
         /CfXNDlxj8ehYjUyyOVUjIYJ9TkwSEb9TELh37okH0x+2j5q4ryZuZIYUeOX0vtHVu
         LCW8GTGFBArEa54RkGB23mNJfz9vns1GbZNhIy2s=
Date:   Fri, 24 Apr 2020 11:14:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.177
Message-ID: <20200424091431.GA359689@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.177 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/sound/hd-audio/index.rst                |    1=20
 Documentation/sound/hd-audio/realtek-pc-beep.rst      |  129 +++++++++++++=
++++
 Makefile                                              |    2=20
 arch/arm/net/bpf_jit_32.c                             |   12 +
 arch/arm64/kernel/armv8_deprecated.c                  |    2=20
 arch/arm64/kernel/perf_event.c                        |    6=20
 arch/arm64/kernel/process.c                           |    8 -
 arch/arm64/kernel/traps.c                             |   65 --------
 arch/mips/cavium-octeon/octeon-irq.c                  |    3=20
 arch/powerpc/include/asm/book3s/64/hash-4k.h          |    6=20
 arch/powerpc/include/asm/book3s/64/hash-64k.h         |    8 -
 arch/powerpc/include/asm/book3s/64/pgtable.h          |    4=20
 arch/powerpc/include/asm/book3s/64/radix.h            |    5=20
 arch/powerpc/include/asm/setjmp.h                     |    6=20
 arch/powerpc/kernel/Makefile                          |    3=20
 arch/powerpc/kernel/idle_book3s.S                     |   27 +++
 arch/powerpc/kernel/kprobes.c                         |    3=20
 arch/powerpc/kernel/signal_64.c                       |    4=20
 arch/powerpc/mm/tlb_nohash_low.S                      |   12 +
 arch/powerpc/platforms/maple/setup.c                  |   34 ++--
 arch/powerpc/platforms/pseries/lpar.c                 |    2=20
 arch/powerpc/sysdev/xive/common.c                     |   12 -
 arch/powerpc/sysdev/xive/native.c                     |    4=20
 arch/powerpc/sysdev/xive/spapr.c                      |    4=20
 arch/powerpc/sysdev/xive/xive-internal.h              |    7=20
 arch/powerpc/xmon/Makefile                            |    3=20
 arch/s390/kernel/diag.c                               |    2=20
 arch/s390/kernel/processor.c                          |    5=20
 arch/s390/kvm/vsie.c                                  |    1=20
 arch/s390/mm/gmap.c                                   |    7=20
 arch/x86/boot/compressed/head_32.S                    |    2=20
 arch/x86/boot/compressed/head_64.S                    |    4=20
 arch/x86/entry/entry_32.S                             |    1=20
 arch/x86/include/asm/cpufeatures.h                    |    2=20
 arch/x86/include/asm/kvm_host.h                       |    2=20
 arch/x86/include/asm/microcode_amd.h                  |    2=20
 arch/x86/include/asm/pgtable.h                        |    7=20
 arch/x86/include/asm/pgtable_types.h                  |    2=20
 arch/x86/kernel/acpi/boot.c                           |    2=20
 arch/x86/kernel/acpi/cstate.c                         |    3=20
 arch/x86/kernel/cpu/intel_rdt.c                       |   68 +++++++--
 arch/x86/kernel/cpu/intel_rdt.h                       |    6=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c              |  133 +++++++++++++=
+----
 arch/x86/kernel/cpu/scattered.c                       |    1=20
 arch/x86/kvm/cpuid.c                                  |    3=20
 arch/x86/kvm/vmx.c                                    |  106 ++++----------
 arch/x86/kvm/x86.c                                    |   21 ++
 block/bfq-iosched.c                                   |   16 +-
 block/blk-ioc.c                                       |    7=20
 block/blk-settings.c                                  |    3=20
 drivers/acpi/processor_throttling.c                   |    7=20
 drivers/ata/libata-pmp.c                              |    1=20
 drivers/ata/libata-scsi.c                             |    9 -
 drivers/base/arch_topology.c                          |    2=20
 drivers/block/null_blk.c                              |   10 +
 drivers/block/rbd.c                                   |   25 ++-
 drivers/bus/sunxi-rsb.c                               |    2=20
 drivers/char/ipmi/ipmi_msghandler.c                   |    4=20
 drivers/clk/at91/clk-usb.c                            |    3=20
 drivers/clk/clk.c                                     |   32 ++--
 drivers/clk/tegra/clk-tegra-pmc.c                     |   12 -
 drivers/cpufreq/powernv-cpufreq.c                     |    6=20
 drivers/crypto/caam/caamalg_desc.c                    |   16 +-
 drivers/crypto/mxs-dcp.c                              |   58 +++----
 drivers/firmware/efi/efi.c                            |    2=20
 drivers/gpio/gpiolib.c                                |   31 ----
 drivers/gpu/drm/amd/amdkfd/kfd_device.c               |    4=20
 drivers/gpu/drm/drm_dp_mst_topology.c                 |   15 +-
 drivers/gpu/drm/drm_pci.c                             |   25 ---
 drivers/i2c/busses/i2c-st.c                           |    1=20
 drivers/input/serio/i8042-x86ia64io.h                 |   11 +
 drivers/iommu/amd_iommu_types.h                       |    2=20
 drivers/iommu/intel-svm.c                             |    7=20
 drivers/irqchip/irq-gic-v3-its.c                      |    6=20
 drivers/irqchip/irq-mbigen.c                          |    8 -
 drivers/irqchip/irq-versatile-fpga.c                  |   18 +-
 drivers/md/dm-flakey.c                                |    5=20
 drivers/md/dm-verity-fec.c                            |    1=20
 drivers/md/dm-zoned-metadata.c                        |    1=20
 drivers/media/platform/ti-vpe/cal.c                   |   16 +-
 drivers/mfd/dln2.c                                    |    9 -
 drivers/mfd/rts5227.c                                 |    1=20
 drivers/misc/echo/echo.c                              |    2=20
 drivers/mtd/devices/phram.c                           |   15 +-
 drivers/mtd/lpddr/lpddr_cmds.c                        |    1=20
 drivers/net/dsa/bcm_sf2_cfp.c                         |    9 -
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c              |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c        |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c     |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c      |   51 ------
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c     |    5=20
 drivers/net/ethernet/neterion/vxge/vxge-config.h      |    2=20
 drivers/net/ethernet/neterion/vxge/vxge-main.h        |   14 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c     |    2=20
 drivers/net/wireless/ath/ath9k/main.c                 |    3=20
 drivers/net/wireless/ath/wil6210/cfg80211.c           |    7=20
 drivers/net/wireless/ath/wil6210/debugfs.c            |    7=20
 drivers/net/wireless/ath/wil6210/fw_inc.c             |   58 +++++--
 drivers/net/wireless/ath/wil6210/interrupt.c          |   22 ++
 drivers/net/wireless/ath/wil6210/main.c               |    2=20
 drivers/net/wireless/ath/wil6210/pcie_bus.c           |   24 ++-
 drivers/net/wireless/ath/wil6210/pm.c                 |   10 -
 drivers/net/wireless/ath/wil6210/txrx.c               |    4=20
 drivers/net/wireless/ath/wil6210/wil6210.h            |    5=20
 drivers/net/wireless/ath/wil6210/wmi.c                |   13 +
 drivers/net/wireless/mac80211_hwsim.c                 |   12 -
 drivers/nvdimm/bus.c                                  |    6=20
 drivers/nvme/host/fc.c                                |   14 -
 drivers/nvme/target/fcloop.c                          |    1=20
 drivers/of/base.c                                     |    3=20
 drivers/of/unittest.c                                 |    7=20
 drivers/pci/endpoint/pci-epc-mem.c                    |   10 +
 drivers/pci/pcie/aspm.c                               |    4=20
 drivers/pci/switch/switchtec.c                        |    2=20
 drivers/power/supply/bq27xxx_battery.c                |    5=20
 drivers/pwm/pwm-pca9685.c                             |   85 ++++++-----
 drivers/rpmsg/qcom_glink_native.c                     |    1=20
 drivers/rpmsg/qcom_glink_smem.c                       |    6=20
 drivers/rtc/rtc-88pm860x.c                            |   14 +
 drivers/rtc/rtc-omap.c                                |    4=20
 drivers/rtc/rtc-pm8xxx.c                              |   49 +++++-
 drivers/s390/scsi/zfcp_erp.c                          |    2=20
 drivers/scsi/lpfc/lpfc_nvme.c                         |    2=20
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                  |    8 -
 drivers/scsi/qla2xxx/qla_nvme.c                       |    1=20
 drivers/scsi/sg.c                                     |    4=20
 drivers/scsi/ufs/ufs-qcom.c                           |    2=20
 drivers/scsi/ufs/ufshcd.c                             |   32 +++-
 drivers/soc/imx/gpc.c                                 |   24 +--
 drivers/soc/qcom/smem.c                               |    2=20
 drivers/target/iscsi/iscsi_target.c                   |   79 +++-------
 drivers/target/iscsi/iscsi_target.h                   |    1=20
 drivers/target/iscsi/iscsi_target_configfs.c          |    5=20
 drivers/target/iscsi/iscsi_target_login.c             |    5=20
 drivers/tty/ehv_bytechan.c                            |   21 ++
 drivers/usb/dwc3/core.c                               |    5=20
 drivers/usb/dwc3/core.h                               |    4=20
 drivers/usb/gadget/composite.c                        |    9 +
 drivers/usb/gadget/function/f_fs.c                    |    1=20
 drivers/video/fbdev/core/fbmem.c                      |    2=20
 drivers/video/fbdev/sis/init301.c                     |    4=20
 fs/btrfs/async-thread.c                               |    8 +
 fs/btrfs/async-thread.h                               |    2=20
 fs/btrfs/delayed-inode.c                              |   13 +
 fs/btrfs/disk-io.c                                    |   13 +
 fs/btrfs/relocation.c                                 |   39 +++--
 fs/buffer.c                                           |   11 +
 fs/cifs/file.c                                        |    2=20
 fs/exec.c                                             |    2=20
 fs/ext2/xattr.c                                       |    8 -
 fs/ext4/extents.c                                     |    8 -
 fs/ext4/inode.c                                       |    4=20
 fs/ext4/super.c                                       |   11 -
 fs/filesystems.c                                      |    4=20
 fs/gfs2/glock.c                                       |    3=20
 fs/hfsplus/attributes.c                               |    4=20
 fs/jbd2/commit.c                                      |    7=20
 fs/nfs/callback_proc.c                                |    2=20
 fs/nfs/direct.c                                       |    2=20
 fs/nfs/pagelist.c                                     |   17 +-
 fs/nfs/write.c                                        |    1=20
 fs/ocfs2/alloc.c                                      |    4=20
 include/acpi/processor.h                              |    8 +
 include/keys/big_key-type.h                           |    2=20
 include/keys/user-type.h                              |    3=20
 include/linux/buffer_head.h                           |    8 +
 include/linux/compiler.h                              |    2=20
 include/linux/devfreq_cooling.h                       |    2=20
 include/linux/iocontext.h                             |    1=20
 include/linux/key-type.h                              |    2=20
 include/linux/nvme-fc-driver.h                        |    4=20
 include/linux/pci-epc.h                               |    3=20
 include/linux/percpu_counter.h                        |    4=20
 include/linux/sched.h                                 |    4=20
 include/linux/swab.h                                  |    1=20
 include/linux/swapops.h                               |    3=20
 include/net/ip6_route.h                               |    1=20
 include/target/iscsi/iscsi_target_core.h              |    2=20
 include/uapi/linux/swab.h                             |   10 +
 kernel/cpu.c                                          |    5=20
 kernel/irq/irqdomain.c                                |   10 -
 kernel/kmod.c                                         |    4=20
 kernel/locking/lockdep.c                              |    4=20
 kernel/locking/locktorture.c                          |    8 -
 kernel/sched/sched.h                                  |    8 -
 kernel/signal.c                                       |    2=20
 kernel/trace/trace_events_trigger.c                   |   10 -
 kernel/trace/trace_kprobe.c                           |    2=20
 lib/find_bit.c                                        |   16 --
 lib/raid6/neon.uc                                     |    5=20
 lib/raid6/recov_neon_inner.c                          |    7=20
 mm/page_alloc.c                                       |    8 -
 mm/slub.c                                             |    2=20
 mm/vmalloc.c                                          |    8 -
 net/core/dev.c                                        |    3=20
 net/core/rtnetlink.c                                  |    2=20
 net/dns_resolver/dns_key.c                            |    2=20
 net/hsr/hsr_netlink.c                                 |   10 +
 net/ipv4/devinet.c                                    |   13 +
 net/netfilter/nf_tables_api.c                         |    4=20
 net/qrtr/qrtr.c                                       |    7=20
 net/rxrpc/key.c                                       |   27 +--
 security/keys/big_key.c                               |  119 ++++++++++++-=
---
 security/keys/encrypted-keys/encrypted.c              |    7=20
 security/keys/key.c                                   |    2=20
 security/keys/keyctl.c                                |   77 +++++++---
 security/keys/keyring.c                               |    6=20
 security/keys/request_key_auth.c                      |    7=20
 security/keys/trusted.c                               |   14 -
 security/keys/user_defined.c                          |    5=20
 sound/core/oss/pcm_plugin.c                           |   32 +++-
 sound/pci/hda/hda_beep.c                              |    6=20
 sound/pci/hda/hda_codec.c                             |    1=20
 sound/pci/hda/hda_intel.c                             |   35 ++--
 sound/pci/hda/patch_realtek.c                         |   15 +-
 sound/pci/ice1712/prodigy_hifi.c                      |    4=20
 sound/soc/intel/atom/sst-atom-controls.c              |    2=20
 sound/soc/intel/atom/sst/sst_pci.c                    |    2=20
 sound/soc/soc-dapm.c                                  |    8 -
 sound/soc/soc-ops.c                                   |    4=20
 sound/soc/soc-pcm.c                                   |    6=20
 sound/soc/soc-topology.c                              |    2=20
 sound/usb/mixer.c                                     |    2=20
 sound/usb/mixer_maps.c                                |   28 +++
 tools/gpio/Makefile                                   |    2=20
 tools/objtool/check.c                                 |    5=20
 tools/perf/Makefile.config                            |   11 +
 tools/testing/selftests/x86/ptrace_syscall.c          |    8 -
 229 files changed, 1637 insertions(+), 995 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alain Volmat (1):
      i2c: st: fix missing struct parameter description

Alexander Duyck (1):
      mm: Use fixed constant in page_frag_alloc instead of size + 1

Alexander Gordeev (1):
      s390/cpuinfo: fix wrong output when CPU0 is offline

Alexander Sverdlin (1):
      genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Alexandre Belloni (1):
      rtc: 88pm860x: fix possible race condition

Alexey Dobriyan (1):
      null_blk: fix spurious IO errors after failed past-wp access

Andrei Botila (1):
      crypto: caam - update xts sector size for large input length

Andy Lutomirski (1):
      selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Andy Shevchenko (1):
      mfd: dln2: Fix sanity checking for endpoints

Aneesh Kumar K.V (1):
      powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devma=
p PTE entries

Anssi Hannula (1):
      tools: gpio: Fix out-of-tree build regression

Ard Biesheuvel (1):
      efi/x86: Ignore the memory attributes table on i386

Arvind Sankar (1):
      x86/boot: Use unsigned comparison for addresses

Arvind Yadav (1):
      rpmsg: glink: use put_device() if device_register fail

Austin Kim (1):
      mm/vmalloc.c: move 'area->pages' after if statement

Bart Van Assche (2):
      null_blk: Fix the null_add_dev() error path
      null_blk: Handle null_add_dev() failures properly

Benoit Parrot (1):
      media: ti-vpe: cal: fix disable_irqs to only the intended target

Bjorn Andersson (1):
      rpmsg: glink: smem: Ensure ordering during tx

Bob Liu (1):
      dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Bob Peterson (1):
      gfs2: Don't demote a glock until its revokes are written

Boqun Feng (1):
      locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps=
()

Can Guo (1):
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Changwei Ge (1):
      ocfs2: no need try to truncate file beyond i_size

Chris Lew (1):
      soc: qcom: smem: Use le32_to_cpu for comparison

Chris Wilson (1):
      drm: Remove PageReserved manipulation from drm_pci_alloc

Christophe Leroy (1):
      powerpc/kprobes: Ignore traps that happened in real mode

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Clement Courbet (1):
      powerpc: Make setjmp/longjmp signature standard

Colin Ian King (2):
      ASoC: Intel: mrfld: fix incorrect check on p->sink
      ASoC: Intel: mrfld: return error codes when an error occurs

C=C3=A9dric Le Goater (1):
      powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configure=
d IPIs

Dan Carpenter (3):
      libnvdimm: Out of bounds read in __nd_ioctl()
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

David Hildenbrand (3):
      KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
      KVM: s390: vsie: Fix delivery of addressing exceptions
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables

David Howells (1):
      KEYS: Use individual pages in big_key for crypto buffers

Dedy Lansky (2):
      wil6210: fix temperature debugfs
      wil6210: rate limit wil_rx_refill error

Dmitry Osipenko (1):
      power: supply: bq27xxx_battery: Silence deferred-probe error

Eric Biggers (2):
      fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_onc=
e()
      kmod: make request_module() return an error when autoloading is disab=
led

Eric Sandeen (1):
      ext4: do not commit super on read-only bdev

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Fenghua Yu (3):
      x86/intel_rdt: Enumerate L2 Code and Data Prioritization (CDP) feature
      x86/intel_rdt: Add two new resources for L2 Code and Data Prioritizat=
ion (CDP)
      x86/intel_rdt: Enable L2 CDP in MSR IA32_L2_QOS_CFG

Filipe Manana (1):
      Btrfs: fix crash during unmount due to race with delayed inode workers

Florian Fainelli (2):
      net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes
      net: dsa: bcm_sf2: Fix overflow checks

Frank Rowand (1):
      of: unittest: kmemleak in of_unittest_platform_populate()

Fredrik Strupe (1):
      arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Geert Uytterhoeven (1):
      clk: Fix debugfs_create_*() usage

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()

Greg Kroah-Hartman (1):
      Linux 4.14.177

Gustavo A. R. Silva (1):
      MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Hamad Kadmany (2):
      wil6210: increase firmware ready timeout
      wil6210: abort properly in cfg suspend

Hans de Goede (1):
      Input: i8042 - add Acer Aspire 5738z to nomux list

Ilya Dryomov (2):
      rbd: avoid a deadlock on header_rwsem when flushing notifies
      rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Jack Zhang (1):
      drm/amdkfd: kfree the wrong pointer

Jacob Pan (1):
      iommu/vt-d: Fix mm reference leak

James Morse (1):
      x86/resctrl: Preserve CDP enable over CPU hotplug

James Smart (1):
      nvme-fc: Revert "add module to ops template to allow module reference=
s"

Jan Engelhardt (1):
      acpi/x86: ignore unspecified bit positions in the ACPI global lock fi=
eld

Jan Kara (2):
      ext4: do not zeroout extents beyond i_disksize
      ext2: fix debug reference to ext2_xattr_cache

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Joe Moriarty (1):
      drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

John Allen (1):
      x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

John Garry (1):
      libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Josef Bacik (5):
      btrfs: remove a BUG_ON() from merge_reloc_roots()
      btrfs: track reloc roots based on their commit root bytenr
      btrfs: drop block from cache on error in relocation
      btrfs: use nofs allocations for running delayed items
      btrfs: check commit root generation in should_ignore_root

Josh Poimboeuf (1):
      objtool: Fix switch table detection in .text.unlikely

Josh Triplett (2):
      ext4: fix incorrect group count in ext4_fill_super error message
      ext4: fix incorrect inodes per group in error message

Kai-Heng Feng (1):
      libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DF=
LAG_DETACH is set

Kees Cook (1):
      slub: improve bit diffusion for freelist ptr obfuscation

Kishon Vijay Abraham I (1):
      PCI: endpoint: Fix for concurrent memory allocation in OB address reg=
ion

Konstantin Khlebnikov (2):
      block: keep bdi->io_pages in sync with max_sectors_kb for stacked dev=
ices
      net: revert default NAPI poll timeout to 2 jiffies

Laurentiu Tudor (1):
      powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Lazar Alexei (1):
      wil6210: fix PCIe bus mastering in case of interface down

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Lior David (2):
      wil6210: add block size checks during FW load
      wil6210: fix length check in __wmi_send

Logan Gunthorpe (1):
      PCI/switchtec: Fix init_completion race condition with poll_wait()

Lucas Stach (1):
      soc: imx: gpc: fix power up sequencing

Luke Nelson (1):
      arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Luo bin (2):
      hinic: fix a bug of waitting for IO stopped
      hinic: fix wrong para of wait_for_completion_timeout

Lyude Paul (1):
      drm/dp_mst: Fix clearing payload state on topology disable

Marc Zyngier (1):
      irqchip/gic-v4: Provide irq_retrigger to avoid circular locking depen=
dency

Martin Blumenstingl (1):
      thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=
=3Dn

Masami Hiramatsu (1):
      ftrace/kprobe: Show the maxactive number on kprobe_events

Maurizio Lombardi (2):
      scsi: target: remove boilerplate code
      scsi: target: fix hang when multiple threads try to destroy the same =
iscsi session

Michael Ellerman (2):
      powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle
      powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Mueller (1):
      s390/diag: fix display of diagnose call statistics

Michael Wang (1):
      sched: Avoid scale real weight down to zero

Misono Tomohiro (1):
      NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Mohit Aggarwal (1):
      rtc: pm8xxx: Fix issue in RTC write path

Nathan Chancellor (4):
      rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH
      misc: echo: Remove unnecessary parentheses and simplify check for zero
      video: fbdev: sis: Remove unnecessary parentheses and commented code
      powerpc/maple: Fix declaration made after definition

Neil Armstrong (1):
      usb: dwc3: core: add support for disabling SS instances in park mode

Oliver O'Halloran (1):
      cpufreq: powernv: Fix use-after-free

Ondrej Jirman (1):
      bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads

Pablo Neira Ayuso (1):
      netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object t=
ype

Paul E. McKenney (1):
      locktorture: Print ratio of acquisitions, not failures

Prasad Sodagudi (1):
      arch_topology: Fix section miss match warning due to free_raw_capacit=
y()

Qian Cai (3):
      ext4: fix a data race at inode->i_blocks
      percpu_counter: fix a data race at vm_committed_as
      x86: ACPI: fix CPU hotplug deadlock

Raju Rangoju (1):
      cxgb4/ptp: pass the sign of offset delta in FW CMD

Randy Dunlap (1):
      ext2: fix empty body warnings when -Wextra is used

Reinette Chatre (1):
      x86/resctrl: Fix invalid attempt at removing the default resource gro=
up

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Rob Herring (1):
      of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Roman Gushchin (1):
      ext4: use non-movable memory for superblock readahead

Roopa Prabhu (1):
      net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_f=
lags

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Sahitya Tummala (1):
      block: Fix use-after-free issue accessing struct io_cq

Sam Lunt (1):
      perf tools: Support Python 3.8+ in Makefile

Sean Christopherson (3):
      KVM: nVMX: Properly handle userspace interrupt window request
      KVM: x86: Allocate new rmap and large page tracking when moving memsl=
ot
      KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support

Sebastian Andrzej Siewior (1):
      amd-xgbe: Use __napi_schedule() in BH context

Segher Boessenkool (1):
      powerpc: Add attributes for setjmp/longjmp

Shetty, Harshini X (EXT-Sony Mobile) (1):
      dm verity fec: fix memory leak in verity_fec_dtr

Simon Gander (1):
      hfsplus: fix crash and filesystem corruption when deleting files

Sowjanya Komatineni (1):
      clk: tegra: Fix Tegra PMC clock out parents

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Sriharsha Allenki (1):
      usb: gadget: f_fs: Fix use after free issue as part of queue failure

Steffen Maier (1):
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-t=
o-point

Stephen Rothwell (1):
      tty: evh_bytechan: Fix out of bounds accesses

Steven Price (1):
      include/linux/swapops.h: correct guards for non_swap_entry()

Subhash Jadavani (1):
      scsi: ufs: ufs-qcom: remove broken hci version quirk

Sungbo Eo (2):
      irqchip/versatile-fpga: Handle chained IRQs properly
      irqchip/versatile-fpga: Apply clear-mask earlier

Sven Van Asbroeck (1):
      pwm: pca9685: Fix PWM/GPIO inter-operation

Taehee Yoo (1):
      hsr: check protocol version in hsr_newlink()

Takashi Iwai (8):
      ALSA: usb-audio: Add mixer workaround for TRX40 and co
      ALSA: hda: Add driver blacklist
      ALSA: hda: Fix potential access overflow in beep helper
      ALSA: ice1724: Fix invalid access for enumerated ctl items
      ALSA: pcm: oss: Fix regression by buffer overflow fix
      ALSA: hda: Initialize power_state field properly
      ALSA: usb-audio: Don't override ignore_ctl_error value from the map
      ALSA: hda: Don't release card at firmware loading error

Taras Chornyi (1):
      net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Thinh Nguyen (1):
      usb: gadget: composite: Inform controller driver of self-powered

Thomas Gleixner (1):
      x86/entry/32: Add missing ASM_CLAC to general_protection entry

Thomas Hebb (2):
      ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256
      ALSA: hda/realtek - Set principled PC Beep configuration for ALC256

Thomas Hellstrom (1):
      x86: Don't let pgprot_modify() change the page encryption bit

Tim Stallard (1):
      net: ipv6: do not consider routes via gateways for anycast address ch=
eck

Timur Tabi (1):
      Revert "gpio: set up initial state from .get_direction()"

Trond Myklebust (3):
      NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()
      NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid=
()
      NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

Vegard Nossum (1):
      compiler.h: fix error in BUILD_BUG_ON() reporting

Venkat Gopalakrishnan (1):
      scsi: ufs: make sure all interrupts are processed

Vitaly Kuznetsov (1):
      KVM: VMX: fix crash cleanup when KVM wasn't used

Waiman Long (1):
      KEYS: Don't write out to userspace while holding key semaphore

Wang Wenhu (1):
      net: qrtr: send msgs from local of same id as broadcast

Wei Yongjun (1):
      rpmsg: glink: Fix missing mutex_init() in qcom_glink_alloc_channel()

Wen Yang (2):
      ipmi: fix hung processes in __get_guid()
      mtd: phram: fix a double free issue in error path

Will Deacon (1):
      arm64: traps: Don't print stack or raw PC/LR values in backtraces

Xiao Yang (1):
      tracing: Fix the race between registering 'snapshot' event trigger an=
d triggering 'snapshot' operation

Xu Wang (1):
      qlcnic: Fix bad kzalloc null test

Xu YiPing (1):
      arm64: perf: remove unsupported events for Cortex-A73

Yang Xu (1):
      KEYS: reaching the keys quotas correctly

Yicong Yang (1):
      PCI/ASPM: Clear the correct bits when enabling L1 substates

Yilu Lin (1):
      CIFS: Fix bug which the return value by asynchronous read is error

YueHaibing (2):
      misc: rtsx: set correct pcr_ops for rts522A
      powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()

Yury Norov (1):
      uapi: rename ext2_swab() to swab() and share globally in swab.h

Zenghui Yu (1):
      irqchip/mbigen: Free msi_desc on device teardown

Zheng Wei (1):
      net: vxge: fix wrong __VA_ARGS__ usage

Zhenzhong Duan (1):
      x86/speculation: Remove redundant arch_smt_update() invocation

Zhiqiang Liu (1):
      block, bfq: fix use-after-free in bfq_idle_slice_timer_body

ndesaulniers@google.com (1):
      lib/raid6: use vdupq_n_u8 to avoid endianness warnings

zhangyi (F) (1):
      jbd2: improve comments about freeing data buffers whose page mapping =
is NULL

=EC=9D=B4=EA=B2=BD=ED=83=9D (4):
      ASoC: fix regwmask
      ASoC: dapm: connect virtual mux with default value
      ASoC: dpcm: allow start or stop during pause for backend
      ASoC: topology: use name_prefix for new kcontrol


--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6irfcACgkQONu9yGCS
aT5BXhAAr0l6MpficflFUYLKljFtvdNeIhMp2rCUMe+yzVnStdjqWJQx+BdK03Z6
LdbONO0+Zd7vvhZg64Ro3CLDecSy8z670J7l1lK8ViN/HbB1mDYDQ6iQQVzbse6k
39GDb/wJrQWMfKNrkJrS0cfNfFrhnC2O/r48OqhlFBBYO7sylMZzZlDYz48o+j3f
Qd1BfvD/AXp4FEs6Is0sWkQclyycadQM/rBqRNPKAQLDTmMSZCKmepmR37tOM74o
neCgVGHbGzqbaJsND82RLXb/3z2nJRCWlTV3RyuqeLR2bcWZwTYqUT0xCGpJkO8N
8Ov3+qlZYKbT3LvVmer5u2ArVLdaF5mHpsS9POxTLoygCVmalYkeT7UobBvg8tC1
EaVU8Z/Afb0PRpEBUTy311y41UTzChPogkbZdhdWj7QX8v/864+kwJJNlCNlGUQ+
wrh8p+MgeulmaAtPX5pDwW/EKf9ZZ3pyO51XcnmZelN+iB/P7v8u784F2/QDVxIP
eJrrl6hnJQUchqyZkA/ZW0zyUEoba4Rpjixdqly10frQQS204zdxKoIy1L2SkXt/
qmV54IrNGXeMYwQtlna2M+XueLx0+tfIYXe5taWaj3J/Hogz4ttV0CUmJ6ZdDvEI
Mwc+LjPuOn5UWx4YnEi6TiJhljxnalM/ARJWxUGa7UxMzq4zKI0=
=NrUE
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
