Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85BC20D4AB
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgF2TKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730962AbgF2TKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8276325494;
        Mon, 29 Jun 2020 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445991;
        bh=WdvE+JD6yEeHiJfz2GaoDxJcOdpqu6YtdarHMHw/168=;
        h=From:To:Cc:Subject:Date:From;
        b=0dRSChdEJ3a94EJw/RpGZo9bvT+MNaaj+BMqvoSzjobkd0qjtQwzCbZVRu6KZ+beu
         UMTSytl8PvG2Bk9vvREwdfdYi+bB5RW10O98cxznGVsYZPpQuPYuedby0sDMnLvPjF
         4F8mILcQ65pnDffOwtP3BsXQWUwd21sBNjTlobII=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: [PATCH 4.4 000/135] 4.4.229-rc1 review
Date:   Mon, 29 Jun 2020 11:50:54 -0400
Message-Id: <20200629155309.2495516-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.4.229 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 01 Jul 2020 03:53:07 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.4.y&id2=v4.4.228

or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

--
Thanks,
Sasha

-------------------------

Pseudo-Shortlog of commits:

Adam Honse (1):
  i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Ahmed S. Darwish (2):
  block: nr_sects_write(): Disable preemption on seqcount write
  net: core: device_rename: Use rwsem instead of a seqcount

Al Cooper (1):
  xhci: Fix enumeration issue when setting max packet size for FS
    devices.

Al Viro (2):
  sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()
  fix a braino in "sparc32: fix register window handling in
    genregs32_[gs]et()"

Alex Williamson (1):
  vfio-pci: Mask cap zero

Alexander Tsoy (1):
  ALSA: usb-audio: Improve frames size computation

Arnd Bergmann (2):
  dlm: remove BUG() before panic()
  include/linux/bitops.h: avoid clang shift-count-overflow warnings

Bob Peterson (1):
  gfs2: Allow lock_nolock mount to specify jid=X

Bryan O'Donoghue (1):
  clk: qcom: msm8916: Fix the address location of pll->config_reg

Chen Yu (1):
  e1000e: Do not wake up the system via WOL if device wakeup is disabled

Christophe JAILLET (1):
  scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Chuck Lever (1):
  SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()

Chuhong Yuan (1):
  USB: ohci-sm501: Add missed iounmap() in remove

Colin Ian King (1):
  usb: gadget: lpc32xx_udc: don't dereference ep pointer before null
    check

Dan Carpenter (2):
  ALSA: isa/wavefront: prevent out of bounds write in ioctl
  usb: gadget: udc: Potential Oops in error handling code

Daniel Mack (1):
  ALSA: usb-audio: allow clock source validity interrupts

David Christensen (1):
  tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

Denis Efremov (1):
  drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Dmitry Osipenko (1):
  power: supply: smb347-charger: IRQSTAT_D is volatile

Dmitry V. Levin (1):
  s390: fix syscall_get_error for compat processes

Dongdong Liu (2):
  PCI: Disable MSI for HiSilicon Hip06/Hip07 Root Ports
  PCI: Disable MSI for HiSilicon Hip06/Hip07 only in Root Port mode

Emmanuel Nicolet (1):
  ps3disk: use the default segment boundary

Eric Biggers (1):
  crypto: algboss - don't wait during notifier callback

Eric Dumazet (1):
  tcp: grow window for OOO packets only for SACK flows

Fabrice Gasnier (1):
  usb: dwc2: gadget: move gadget resume after the core is in L0 state

Fan Guo (1):
  RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Fedor Tokarev (1):
  net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Gaurav Singh (1):
  perf report: Fix NULL pointer dereference in
    hists__fprintf_nr_sample_events()

Geoff Levand (1):
  powerpc/ps3: Fix kexec shutdown hang

Gregory CLEMENT (3):
  tty: n_gsm: Fix SOF skipping
  tty: n_gsm: Fix waking up upper tty layer when room available
  tty: n_gsm: Fix bogus i++ in gsm_data_kick

Huacai Chen (1):
  drm/qxl: Use correct notify port address when creating cursor ring

Jann Horn (1):
  lib/zlib: remove outdated and incorrect pre-increment optimization

Jason Yan (1):
  block: Fix use-after-free in blkdev_get()

Jeffle Xu (1):
  ext4: fix partial cluster initialization when splitting extent

Jeremy Kerr (1):
  net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
  arm64: perf: Report the PC value in REGS_ABI_32 mode

Jiri Olsa (1):
  kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

Joakim Tjernlund (1):
  cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

John Stultz (1):
  serial: amba-pl011: Make sure we initialize the port.lock spinlock

Julian Scheel (1):
  ALSA: usb-audio: uac1: Invalidate ctl on interrupt

Julian Wiedmann (1):
  s390/qdio: put thinint indicator after early error

Junxiao Bi (3):
  ocfs2: load global_inode_alloc
  ocfs2: fix value of OCFS2_INVALID_SLOT
  ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (1):
  sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (3):
  PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges
  libata: Use per port sync for detach
  xhci: Poll for U0 after disabling USB2 LPM

Kuppuswamy Sathyanarayanan (1):
  drivers: base: Fix NULL pointer exception in __platform_driver_probe()
    if a driver developer is foolish

Longfang Liu (1):
  USB: ehci: reopen solution for Synopsys HC bug

Luis Chamberlain (1):
  blktrace: break out of blktrace setup on concurrent calls

Lyude Paul (2):
  drm/dp_mst: Reformat drm_dp_check_act_status() a bit
  drm/dp_mst: Increase ACT retry timeout to 3s

Marcelo Ricardo Leitner (1):
  sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Marek Szyprowski (2):
  mfd: wm8994: Fix driver operation if loaded as modules
  clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Martin Wilck (1):
  scsi: scsi_devinfo: handle non-terminated strings

Masahiro Yamada (1):
  kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (3):
  kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex
  x86/kprobes: Avoid kretprobe recursion bug
  tracing: Fix event trigger to accept redundant spaces

Matej Dujava (1):
  staging: sm750fb: add missing case while setting FB_VISUAL

Mathias Nyman (1):
  xhci: Fix incorrect EP_STATE_MASK

Minas Harutyunyan (1):
  usb: dwc2: Postponed gadget registration to the udc class driver

Nathan Chancellor (2):
  USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in
    s3c2410_udc_nuke
  ACPI: sysfs: Fix pm_profile_attr type

Naveen N. Rao (1):
  powerpc/kprobes: Fixes for kprobe_lookup_name() on BE

Neal Cardwell (1):
  tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Nicholas Piggin (1):
  powerpc/pseries/ras: Fix FWNMI_VALID off by one

Nick Desaulniers (1):
  elfnote: mark all .note sections SHF_ALLOC

Olga Kornievskaia (1):
  NFSv4 fix CLOSE not waiting for direct IO compeletion

Oliver Neukum (1):
  usblp: poison URBs upon disconnect

Pingfan Liu (1):
  powerpc/crashkernel: Take "mem=" option into account

Qais Yousef (3):
  usb/ohci-platform: Fix a warning when hibernating
  usb/xhci-plat: Set PM runtime as active on resume
  usb/ehci-platform: Set PM runtime as active on resume

Qian Cai (1):
  vfio/pci: fix memory leaks in alloc_perm_bits()

Qiushi Wu (3):
  usb: gadget: fix potential double-free in m66592_probe.
  scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj
  efi/esrt: Fix reference count leak in esre_create_sysfs_entry.

Raghavendra Rao Ananta (1):
  tty: hvc: Fix data abort due to race in hvc_open

Ridge Kennedy (1):
  l2tp: Allow duplicate session creation with UDP

Rikard Falkeborn (1):
  clk: sunxi: Fix incorrect usage of round_down()

Russell King (3):
  i2c: pxa: clear all master action bits in i2c_pxa_stop_message()
  i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output
  netfilter: ipset: fix unaligned atomic access

Sasha Levin (1):
  Linux 4.4.229-rc1

Simon Arlott (1):
  scsi: sr: Fix sr_probe() missing deallocate of device minor

Stafford Horne (1):
  openrisc: Fix issue with argument clobbering for clone/fork

Stefan Riedmueller (1):
  watchdog: da9062: No need to ping manually before setting timeout

Suganath Prabu S (1):
  scsi: mpt3sas: Fix double free warnings

Taehee Yoo (3):
  ip_tunnel: fix use-after-free in ip_tunnel_lookup()
  ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
  net: core: reduce recursion limit value

Takashi Iwai (3):
  ALSA: usb-audio: Clean up mixer element list traverse
  ALSA: usb-audio: Fix OOB access of mixer element list
  ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()

Tang Bin (2):
  USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()
  usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
  net: Do not clear the sock TX queue in sk_set_socket()

Tero Kristo (1):
  clk: ti: composite: fix memory leak

Thomas Gleixner (1):
  sched/rt, net: Use CONFIG_PREEMPTION.patch

Toke Høiland-Jørgensen (1):
  net: Revert "pkt_sched: fq: use proper locking in fq_dump_stats()"

Tom Rix (1):
  selinux: fix double free

Tomasz Meresiński (1):
  usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Trond Myklebust (1):
  pNFS/flexfiles: Fix list corruption if the mirror count changes

Tyrel Datwyler (1):
  scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Valentin Longchamp (1):
  net: sched: export __netdev_watchdog_up()

Vasily Averin (1):
  sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Viacheslav Dubeyko (1):
  scsi: qla2xxx: Fix issue with adapter's stopping state

Waiman Long (1):
  mm/slab: use memzero_explicit() in kzfree()

Wang Hai (2):
  yam: fix possible memory leak in yam_init_driver
  mld: fix memory leak in ipv6_mc_destroy_dev()

Wolfram Sang (1):
  drm: encoder_slave: fix refcouting error for modules

Xiaoyao Li (1):
  KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Xiyu Yang (3):
  scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event
  nfsd: Fix svc_xprt refcnt leak when setup callback client failed
  ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

Yang Yingliang (1):
  net: fix memleak in register_netdevice()

Yick W. Tse (1):
  ALSA: usb-audio: add quirk for Denon DCD-1500RE

Zekun Shen (1):
  net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
  cifs/smb3: Fix data inconsistent when punch hole
  cifs/smb3: Fix data inconsistent when zero file range

Zhiqiang Liu (1):
  bcache: fix potential deadlock problem in btree_gc_coalesce

ashimida (1):
  mksysmap: Fix the mismatch of '.L' symbols in System.map

guodeqing (1):
  net: Fix the arp error in some cases

tannerlove (1):
  selftests/net: in timestamping, strncpy needs to preserve null byte

yu kuai (1):
  ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

 Makefile                                      |  4 +-
 arch/arm/mach-imx/pm-imx5.c                   |  6 +-
 arch/arm64/kernel/perf_regs.c                 | 25 ++++-
 arch/openrisc/kernel/entry.S                  |  4 +-
 arch/powerpc/include/asm/kprobes.h            |  3 +-
 arch/powerpc/kernel/machine_kexec.c           |  8 +-
 arch/powerpc/platforms/ps3/mm.c               | 22 +++--
 arch/powerpc/platforms/pseries/ras.c          |  5 +-
 arch/s390/include/asm/syscall.h               | 12 ++-
 arch/sparc/kernel/ptrace_32.c                 |  9 +-
 arch/sparc/kernel/ptrace_64.c                 | 13 +--
 arch/x86/kernel/kprobes/core.c                | 12 ++-
 arch/x86/kvm/x86.c                            |  4 +-
 crypto/algboss.c                              |  2 -
 drivers/acpi/sysfs.c                          |  4 +-
 drivers/ata/libata-core.c                     | 11 +--
 drivers/base/platform.c                       |  2 +
 drivers/block/ps3disk.c                       |  1 -
 drivers/clk/qcom/gcc-msm8916.c                |  8 +-
 drivers/clk/samsung/clk-exynos5433.c          |  3 +-
 drivers/clk/sunxi/clk-sunxi.c                 |  2 +-
 drivers/clk/ti/composite.c                    |  1 +
 drivers/firmware/efi/esrt.c                   |  2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c         | 58 +++++++-----
 drivers/gpu/drm/drm_encoder_slave.c           |  5 +-
 drivers/gpu/drm/qxl/qxl_kms.c                 |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c               |  2 +-
 drivers/i2c/busses/i2c-piix4.c                |  3 +-
 drivers/i2c/busses/i2c-pxa.c                  | 13 +--
 drivers/infiniband/core/mad.c                 |  1 +
 drivers/md/bcache/btree.c                     |  8 +-
 drivers/mfd/wm8994-core.c                     |  1 +
 drivers/net/ethernet/atheros/alx/main.c       |  9 +-
 drivers/net/ethernet/broadcom/tg3.c           |  4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    | 14 ++-
 drivers/net/hamradio/yam.c                    |  1 +
 drivers/net/usb/ax88179_178a.c                | 11 ++-
 drivers/pci/pcie/aspm.c                       | 10 --
 drivers/pci/quirks.c                          |  1 +
 drivers/power/smb347-charger.c                |  1 +
 drivers/s390/cio/qdio.h                       |  1 -
 drivers/s390/cio/qdio_setup.c                 |  1 -
 drivers/s390/cio/qdio_thinint.c               | 14 +--
 drivers/scsi/arm/acornscsi.c                  |  4 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  2 +
 drivers/scsi/iscsi_boot_sysfs.c               |  2 +-
 drivers/scsi/lpfc/lpfc_els.c                  |  2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c           |  2 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c            |  2 +
 drivers/scsi/scsi_devinfo.c                   |  5 +-
 drivers/scsi/sr.c                             |  6 +-
 drivers/staging/sm750fb/sm750.c               |  1 +
 drivers/tty/hvc/hvc_console.c                 | 16 +++-
 drivers/tty/n_gsm.c                           | 26 +++---
 drivers/tty/serial/amba-pl011.c               |  1 +
 drivers/usb/class/cdc-acm.c                   |  2 +
 drivers/usb/class/usblp.c                     |  5 +-
 drivers/usb/core/quirks.c                     |  3 +-
 drivers/usb/dwc2/core_intr.c                  |  7 +-
 drivers/usb/dwc2/gadget.c                     |  6 --
 drivers/usb/dwc2/platform.c                   | 11 +++
 drivers/usb/gadget/udc/lpc32xx_udc.c          | 11 ++-
 drivers/usb/gadget/udc/m66592-udc.c           |  2 +-
 drivers/usb/gadget/udc/mv_udc_core.c          |  3 +-
 drivers/usb/gadget/udc/s3c2410_udc.c          |  4 -
 drivers/usb/host/ehci-exynos.c                |  5 +-
 drivers/usb/host/ehci-mxc.c                   |  2 +
 drivers/usb/host/ehci-pci.c                   |  7 ++
 drivers/usb/host/ehci-platform.c              |  5 +
 drivers/usb/host/ohci-platform.c              |  5 +
 drivers/usb/host/ohci-sm501.c                 |  1 +
 drivers/usb/host/xhci-plat.c                  | 11 ++-
 drivers/usb/host/xhci.c                       |  4 +
 drivers/usb/host/xhci.h                       |  2 +-
 drivers/vfio/pci/vfio_pci_config.c            | 14 ++-
 drivers/watchdog/da9062_wdt.c                 |  5 -
 fs/block_dev.c                                | 12 ++-
 fs/cifs/smb2ops.c                             | 12 +++
 fs/dlm/dlm_internal.h                         |  1 -
 fs/ext4/extents.c                             |  2 +-
 fs/gfs2/ops_fstype.c                          |  2 +-
 fs/nfs/direct.c                               | 13 ++-
 fs/nfs/file.c                                 |  1 +
 fs/nfs/flexfilelayout/flexfilelayout.c        | 11 ++-
 fs/nfsd/nfs4callback.c                        |  2 +
 fs/ocfs2/ocfs2_fs.h                           |  4 +-
 fs/ocfs2/suballoc.c                           |  9 +-
 include/linux/bitops.h                        |  2 +-
 include/linux/elfnote.h                       |  2 +-
 include/linux/genhd.h                         |  2 +
 include/linux/kprobes.h                       |  4 +
 include/linux/libata.h                        |  3 +
 include/linux/pci_ids.h                       |  2 +
 include/net/sctp/constants.h                  |  8 +-
 include/net/sock.h                            |  1 -
 kernel/kprobes.c                              | 27 +++++-
 kernel/sched/core.c                           |  3 +-
 kernel/trace/blktrace.c                       | 13 +++
 kernel/trace/trace_events_trigger.c           | 21 ++++-
 lib/zlib_inflate/inffast.c                    | 91 +++++++------------
 mm/slab_common.c                              |  2 +-
 net/core/dev.c                                | 49 +++++-----
 net/core/sock.c                               |  2 +
 net/ipv4/fib_semantics.c                      |  2 +-
 net/ipv4/ip_tunnel.c                          | 14 +--
 net/ipv4/tcp_cubic.c                          |  2 +
 net/ipv4/tcp_input.c                          | 12 ++-
 net/ipv6/ip6_gre.c                            |  9 +-
 net/ipv6/mcast.c                              |  1 +
 net/l2tp/l2tp_core.c                          |  7 +-
 net/netfilter/ipset/ip_set_core.c             |  2 +
 net/sched/sch_fq.c                            | 32 +++----
 net/sched/sch_generic.c                       |  1 +
 net/sctp/associola.c                          |  5 +-
 net/sctp/bind_addr.c                          |  1 +
 net/sctp/protocol.c                           |  1 +
 net/sunrpc/addr.c                             |  4 +-
 net/sunrpc/rpc_pipe.c                         |  1 +
 net/sunrpc/xdr.c                              |  4 +
 scripts/Kbuild.include                        | 11 ++-
 scripts/mksysmap                              |  2 +-
 security/selinux/ss/services.c                |  4 +
 sound/isa/wavefront/wavefront_synth.c         |  8 +-
 sound/soc/fsl/fsl_asrc_dma.c                  |  1 +
 sound/usb/card.h                              |  4 +
 sound/usb/endpoint.c                          | 43 ++++++++-
 sound/usb/endpoint.h                          |  1 +
 sound/usb/mixer.c                             | 41 ++++++---
 sound/usb/mixer.h                             | 15 ++-
 sound/usb/mixer_quirks.c                      | 11 ++-
 sound/usb/mixer_scarlett.c                    |  6 +-
 sound/usb/pcm.c                               |  2 +
 sound/usb/quirks.c                            |  1 +
 tools/perf/builtin-report.c                   |  3 +-
 .../networking/timestamping/timestamping.c    | 10 +-
 135 files changed, 699 insertions(+), 370 deletions(-)

-- 
2.25.1

