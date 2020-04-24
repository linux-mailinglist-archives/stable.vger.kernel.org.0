Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88C71B7059
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDXJNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXJNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371F920700;
        Fri, 24 Apr 2020 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719617;
        bh=Mi/24eORl+G3RXkKfDe4K3DtBctDEhCnz853ESLjjVs=;
        h=Date:From:To:Cc:Subject:From;
        b=uCKqGlNQV5M4bFPJDDNJNnIFYyic8MR/JCeuuzZ1+EFr+CU8+ppaVMvfnveze1hKS
         S3apddnVDhrEckbo1TSKwIxOUbjJJeGwXZiSxvqIyzNhZo93YSiLYqFDDIEnpbQcxX
         kt/Upxu25tMyFEuIbG0TbNVFT9AotcQ+W7PcHgG4=
Date:   Fri, 24 Apr 2020 11:13:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.220
Message-ID: <20200424091335.GA359410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.220 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm64/kernel/armv8_deprecated.c                  |    2 
 arch/mips/cavium-octeon/octeon-irq.c                  |    3 
 arch/powerpc/kernel/signal_64.c                       |    4 -
 arch/powerpc/mm/tlb_nohash_low.S                      |   12 +++
 arch/s390/kernel/diag.c                               |    2 
 arch/x86/boot/compressed/head_32.S                    |    2 
 arch/x86/boot/compressed/head_64.S                    |    4 -
 arch/x86/entry/entry_32.S                             |    1 
 arch/x86/entry/entry_64.S                             |    2 
 arch/x86/include/asm/microcode_intel.h                |    2 
 arch/x86/include/asm/processor.h                      |   18 +++++
 arch/x86/include/asm/spec-ctrl.h                      |    2 
 arch/x86/include/asm/vgtod.h                          |    2 
 arch/x86/kernel/acpi/boot.c                           |    2 
 arch/x86/kernel/cpu/bugs.c                            |    5 +
 arch/x86/kvm/cpuid.c                                  |    3 
 arch/x86/kvm/x86.c                                    |   11 +++
 drivers/ata/libata-pmp.c                              |    1 
 drivers/ata/libata-scsi.c                             |    9 --
 drivers/bus/sunxi-rsb.c                               |    2 
 drivers/char/ipmi/ipmi_msghandler.c                   |    4 -
 drivers/clk/at91/clk-usb.c                            |    3 
 drivers/clk/tegra/clk-tegra-pmc.c                     |   12 +--
 drivers/crypto/mxs-dcp.c                              |   58 ++++++++----------
 drivers/gpu/drm/drm_dp_mst_topology.c                 |   15 +++-
 drivers/i2c/busses/i2c-st.c                           |    1 
 drivers/infiniband/ulp/ipoib/ipoib_ib.c               |    7 --
 drivers/input/serio/i8042-x86ia64io.h                 |   11 +++
 drivers/iommu/amd_iommu_types.h                       |    2 
 drivers/irqchip/irq-versatile-fpga.c                  |   18 ++++-
 drivers/md/dm-flakey.c                                |    5 +
 drivers/mfd/dln2.c                                    |    9 ++
 drivers/mfd/rts5227.c                                 |    1 
 drivers/misc/echo/echo.c                              |    2 
 drivers/mtd/devices/phram.c                           |   15 ++--
 drivers/mtd/lpddr/lpddr_cmds.c                        |    1 
 drivers/net/ethernet/neterion/vxge/vxge-config.h      |    2 
 drivers/net/ethernet/neterion/vxge/vxge-main.h        |   14 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    2 
 drivers/net/wireless/ath/ath9k/main.c                 |    3 
 drivers/net/wireless/ath/wil6210/debugfs.c            |    7 +-
 drivers/net/wireless/ath/wil6210/main.c               |    2 
 drivers/net/wireless/ath/wil6210/txrx.c               |    4 -
 drivers/net/wireless/mac80211_hwsim.c                 |   12 +--
 drivers/net/xen-netfront.c                            |   14 +++-
 drivers/of/base.c                                     |    3 
 drivers/of/unittest.c                                 |    7 +-
 drivers/rtc/rtc-pm8xxx.c                              |   49 +++++++++++----
 drivers/s390/scsi/zfcp_erp.c                          |    2 
 drivers/scsi/sg.c                                     |    4 -
 drivers/scsi/ufs/ufs-qcom.c                           |    2 
 drivers/scsi/ufs/ufshcd.c                             |    5 +
 drivers/soc/qcom/smem.c                               |    2 
 drivers/tty/ehv_bytechan.c                            |   21 +++++-
 drivers/usb/gadget/composite.c                        |    9 ++
 drivers/usb/gadget/function/f_fs.c                    |    1 
 drivers/video/fbdev/core/fbmem.c                      |    2 
 drivers/video/fbdev/sis/init301.c                     |    4 -
 fs/btrfs/async-thread.c                               |    8 ++
 fs/btrfs/async-thread.h                               |    2 
 fs/btrfs/disk-io.c                                    |   13 ++++
 fs/btrfs/relocation.c                                 |   33 ++++++----
 fs/btrfs/send.c                                       |    7 +-
 fs/exec.c                                             |    2 
 fs/ext2/xattr.c                                       |    5 -
 fs/ext4/extents.c                                     |    8 +-
 fs/ext4/inode.c                                       |    2 
 fs/ext4/super.c                                       |    9 +-
 fs/gfs2/glock.c                                       |    3 
 fs/hfsplus/attributes.c                               |    4 +
 fs/jbd2/commit.c                                      |    7 +-
 fs/nfs/direct.c                                       |    2 
 fs/nfs/pagelist.c                                     |   17 ++---
 fs/ocfs2/alloc.c                                      |    4 +
 include/linux/compiler.h                              |    2 
 include/linux/devfreq_cooling.h                       |    2 
 include/linux/percpu_counter.h                        |    4 -
 include/linux/sched.h                                 |    4 -
 include/net/ip6_route.h                               |    1 
 kernel/futex.c                                        |   12 +++
 kernel/kmod.c                                         |    4 -
 kernel/locking/lockdep.c                              |    4 +
 kernel/locking/locktorture.c                          |    8 +-
 kernel/signal.c                                       |    2 
 kernel/trace/trace_events_trigger.c                   |   10 ---
 net/ipv4/devinet.c                                    |   13 ++--
 security/keys/key.c                                   |    2 
 security/keys/keyctl.c                                |    4 -
 sound/core/oss/pcm_plugin.c                           |   32 +++++++--
 sound/pci/hda/hda_beep.c                              |    6 +
 sound/pci/hda/hda_codec.c                             |    1 
 sound/pci/hda/hda_intel.c                             |   35 ++++++----
 sound/pci/ice1712/prodigy_hifi.c                      |    4 -
 sound/soc/intel/atom/sst-atom-controls.c              |    2 
 sound/soc/intel/atom/sst/sst_pci.c                    |    2 
 sound/soc/soc-dapm.c                                  |    8 ++
 sound/soc/soc-ops.c                                   |    4 -
 sound/soc/soc-pcm.c                                   |    6 +
 sound/soc/soc-topology.c                              |    2 
 sound/usb/mixer.c                                     |    2 
 sound/usb/mixer_maps.c                                |   28 ++++++++
 tools/testing/selftests/x86/ptrace_syscall.c          |    8 +-
 103 files changed, 530 insertions(+), 234 deletions(-)

Adrian Huang (1):
      iommu/amd: Fix the configuration of GCR3 table root pointer

Alain Volmat (1):
      i2c: st: fix missing struct parameter description

Alex Vesker (1):
      IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush

Andy Lutomirski (1):
      selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Andy Shevchenko (1):
      mfd: dln2: Fix sanity checking for endpoints

Arvind Sankar (1):
      x86/boot: Use unsigned comparison for addresses

Bob Peterson (1):
      gfs2: Don't demote a glock until its revokes are written

Boqun Feng (1):
      locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()

Borislav Petkov (2):
      x86/mitigations: Clear CPU buffers on the SYSCALL fast path
      x86/CPU: Add native CPUID variants returning a single datum

Can Guo (1):
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Changwei Ge (1):
      ocfs2: no need try to truncate file beyond i_size

Chris Lew (1):
      soc: qcom: smem: Use le32_to_cpu for comparison

Claudiu Beznea (1):
      clk: at91: usb: continue if clk_hw_round_rate() return zero

Colin Ian King (2):
      ASoC: Intel: mrfld: fix incorrect check on p->sink
      ASoC: Intel: mrfld: return error codes when an error occurs

Dan Carpenter (2):
      fbdev: potential information leak in do_fb_ioctl()
      mtd: lpddr: Fix a double free in probe()

Dedy Lansky (2):
      wil6210: fix temperature debugfs
      wil6210: rate limit wil_rx_refill error

Eric Biggers (1):
      kmod: make request_module() return an error when autoloading is disabled

Eric Sandeen (1):
      ext4: do not commit super on read-only bdev

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Evalds Iodzevics (1):
      x86/microcode/intel: replace sync_core() with native_cpuid_reg(eax)

Filipe Manana (2):
      Btrfs: incremental send, fix invalid memory access
      Btrfs: fix crash during unmount due to race with delayed inode workers

Frank Rowand (1):
      of: unittest: kmemleak in of_unittest_platform_populate()

Fredrik Strupe (1):
      arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Goldwyn Rodrigues (1):
      dm flakey: check for null arg_name in parse_features()

Greg Kroah-Hartman (1):
      Linux 4.4.220

Gustavo A. R. Silva (1):
      MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Hamad Kadmany (1):
      wil6210: increase firmware ready timeout

Hans de Goede (1):
      Input: i8042 - add Acer Aspire 5738z to nomux list

Jan Engelhardt (1):
      acpi/x86: ignore unspecified bit positions in the ACPI global lock field

Jan Kara (1):
      ext4: do not zeroout extents beyond i_disksize

Jim Mattson (1):
      kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Jiri Slaby (1):
      futex: futex_wake_op, do not fail on invalid op

Joe Moriarty (1):
      drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

John Garry (1):
      libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Josef Bacik (2):
      btrfs: remove a BUG_ON() from merge_reloc_roots()
      btrfs: track reloc roots based on their commit root bytenr

Josh Triplett (2):
      ext4: fix incorrect group count in ext4_fill_super error message
      ext4: fix incorrect inodes per group in error message

Kai-Heng Feng (1):
      libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set

Laurentiu Tudor (1):
      powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Li Bin (1):
      scsi: sg: add sg_remove_request in sg_common_write

Lyude Paul (1):
      drm/dp_mst: Fix clearing payload state on topology disable

Martin Blumenstingl (1):
      thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n

Michael Ellerman (1):
      powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Mueller (1):
      s390/diag: fix display of diagnose call statistics

Misono Tomohiro (1):
      NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Mohit Aggarwal (1):
      rtc: pm8xxx: Fix issue in RTC write path

Nathan Chancellor (2):
      misc: echo: Remove unnecessary parentheses and simplify check for zero
      video: fbdev: sis: Remove unnecessary parentheses and commented code

Ondrej Jirman (1):
      bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads

Paul E. McKenney (1):
      locktorture: Print ratio of acquisitions, not failures

Qian Cai (2):
      ext4: fix a data race at inode->i_blocks
      percpu_counter: fix a data race at vm_committed_as

Randy Dunlap (1):
      ext2: fix empty body warnings when -Wextra is used

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Rob Herring (1):
      of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Samuel Neves (1):
      x86/vdso: Fix lsl operand order

Sean Christopherson (1):
      KVM: x86: Allocate new rmap and large page tracking when moving memslot

Simon Gander (1):
      hfsplus: fix crash and filesystem corruption when deleting files

Sowjanya Komatineni (1):
      clk: tegra: Fix Tegra PMC clock out parents

Sriharsha Allenki (1):
      usb: gadget: f_fs: Fix use after free issue as part of queue failure

Steffen Maier (1):
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Stephen Rothwell (1):
      tty: evh_bytechan: Fix out of bounds accesses

Subhash Jadavani (1):
      scsi: ufs: ufs-qcom: remove broken hci version quirk

Sungbo Eo (2):
      irqchip/versatile-fpga: Handle chained IRQs properly
      irqchip/versatile-fpga: Apply clear-mask earlier

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

Tim Stallard (1):
      net: ipv6: do not consider routes via gateways for anycast address check

Trond Myklebust (1):
      NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Tuomas Tynkkynen (1):
      mac80211_hwsim: Use kstrndup() in place of kasprintf()

Vegard Nossum (1):
      compiler.h: fix error in BUILD_BUG_ON() reporting

Vineeth Remanan Pillai (1):
      xen-netfront: Rework the fix for Rx stall during OOM and network stress

Wen Yang (2):
      ipmi: fix hung processes in __get_guid()
      mtd: phram: fix a double free issue in error path

Xiao Yang (1):
      tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

Xu Wang (1):
      qlcnic: Fix bad kzalloc null test

Yang Xu (1):
      KEYS: reaching the keys quotas correctly

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A

Zheng Wei (1):
      net: vxge: fix wrong __VA_ARGS__ usage

zhangyi (F) (1):
      jbd2: improve comments about freeing data buffers whose page mapping is NULL

이경택 (4):
      ASoC: fix regwmask
      ASoC: dapm: connect virtual mux with default value
      ASoC: dpcm: allow start or stop during pause for backend
      ASoC: topology: use name_prefix for new kcontrol

