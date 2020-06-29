Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEC20DE72
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbgF2UZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732530AbgF2TZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E282534C;
        Mon, 29 Jun 2020 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445211;
        bh=kj/a9rhu1nXPzvykKE/cUJFAdlEj7hddiWmWD/dI8Fs=;
        h=From:To:Cc:Subject:Date:From;
        b=ddBr12W5KRpLMo5G6VgmTrqEk0O6jVJ8228FpYHnysrtZjAg1AvZQEaGMxBcS3u+6
         MVAlFAyB9FaJQvvJDPVwpffK4Hoj6dHhUzXX1lAyQpNJYMDOLlpv7eXsS3aqooCQmH
         zUwC4GJaWJaVvu1btG14ol2bUn65rX0t3zrUkxB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: [PATCH 4.9 000/191] 4.9.229-rc1 review
Date:   Mon, 29 Jun 2020 11:36:56 -0400
Message-Id: <20200629154007.2495120-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 4.9.229 release.
There are 191 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 01 Jul 2020 03:40:00 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.9.y&id2=v4.9.228

or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

--
Thanks,
Sasha

-------------------------

Pseudo-Shortlog of commits:

Aaron Plattner (1):
  ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Adam Honse (1):
  i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Aditya Pakki (1):
  rocker: fix incorrect error handling in dma_rings_init

Ahmed S. Darwish (2):
  block: nr_sects_write(): Disable preemption on seqcount write
  net: core: device_rename: Use rwsem instead of a seqcount

Al Cooper (1):
  xhci: Fix enumeration issue when setting max packet size for FS
    devices.

Al Viro (1):
  fix a braino in "sparc32: fix register window handling in
    genregs32_[gs]et()"

Alain Volmat (1):
  clk: clk-flexgen: fix clock-critical handling

Alex Williamson (1):
  vfio-pci: Mask cap zero

Alexander Lobakin (3):
  net: qed: fix left elements count calculation
  net: qed: fix NVMe login fails over VFs
  net: qed: fix excessive QM ILT lines consumption

Alexander Tsoy (1):
  ALSA: usb-audio: Improve frames size computation

Andreas Klinger (1):
  iio: bmp280: fix compensation of humidity

Andrew Murray (1):
  PCI: rcar: Fix incorrect programming of OB windows

Andy Shevchenko (1):
  iio: pressure: bmp280: Tolerate IRQ before registering

Ard Biesheuvel (1):
  x86/boot/compressed: Relax sed symbol type regex for LLVM ld.lld

Arnd Bergmann (2):
  dlm: remove BUG() before panic()
  include/linux/bitops.h: avoid clang shift-count-overflow warnings

Bjorn Helgaas (1):
  PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream
    Port

Bob Peterson (1):
  gfs2: Allow lock_nolock mount to specify jid=X

Boris Brezillon (1):
  mtd: rawnand: Pass a nand_chip object to nand_release()

Bryan O'Donoghue (1):
  clk: qcom: msm8916: Fix the address location of pll->config_reg

Chen Yu (1):
  e1000e: Do not wake up the system via WOL if device wakeup is disabled

Chris Wilson (1):
  drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Christophe JAILLET (4):
  power: supply: lp8788: Fix an error handling path in
    'lp8788_charger_probe()'
  extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'
  pinctrl: imxl: Fix an error handling path in
    'imx1_pinctrl_core_probe()'
  scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Chuck Lever (1):
  SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()

Chuhong Yuan (1):
  USB: ohci-sm501: Add missed iounmap() in remove

Colin Ian King (2):
  usb: gadget: lpc32xx_udc: don't dereference ep pointer before null
    check
  media: dvb_frontend: initialize variable s with FE_NONE instead of 0

Dan Carpenter (2):
  ALSA: isa/wavefront: prevent out of bounds write in ioctl
  usb: gadget: udc: Potential Oops in error handling code

David Christensen (1):
  tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (1):
  rxrpc: Fix notification call on completion of discarded calls

Denis Efremov (1):
  drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Dmitry Osipenko (1):
  power: supply: smb347-charger: IRQSTAT_D is volatile

Dmitry V. Levin (1):
  s390: fix syscall_get_error for compat processes

Emmanuel Nicolet (1):
  ps3disk: use the default segment boundary

Enric Balletbo i Serra (1):
  power: supply: bq24257_charger: Replace depends on REGMAP_I2C with
    select

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

Jaedon Shin (3):
  media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
  media: dvb_frontend: Add compat_ioctl callback
  media: dvb_frontend: Add commands implementation for compat ioct

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

Jon Hunter (1):
  backlight: lp855x: Ensure regulators are disabled on probe failure

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

Kajol Jain (1):
  powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple
    hv-24x7 events run

Katsuhiro Suzuki (1):
  media: dvb_frontend: fix wrong cast in compat_ioctl

Kuppuswamy Sathyanarayanan (1):
  drivers: base: Fix NULL pointer exception in __platform_driver_probe()
    if a driver developer is foolish

Linus Walleij (1):
  ARM: integrator: Add some Kconfig selections

Longfang Liu (1):
  USB: ehci: reopen solution for Synopsys HC bug

Luis Chamberlain (1):
  blktrace: break out of blktrace setup on concurrent calls

Lyude Paul (2):
  drm/dp_mst: Reformat drm_dp_check_act_status() a bit
  drm/dp_mst: Increase ACT retry timeout to 3s

Maor Gottlieb (1):
  IB/cma: Fix ports memory leak in cma_configfs

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

Mauro Carvalho Chehab (14):
  media: dvb/frontend.h: move out a private internal structure
  media: dvb/frontend.h: document the uAPI file
  media: dvb_frontend: get rid of get_property() callback
  media: stv0288: get rid of set_property boilerplate
  media: stv6110: get rid of a srate dead code
  media: friio-fe: get rid of set_property()
  media: dvb_frontend: get rid of set_property() callback
  media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
  media: dvb_frontend: cleanup ioctl handling logic
  media: dvb_frontend: get rid of property cache's state
  media: dvb_frontend: better document the -EPERM condition
  media: dvb_frontend: fix return values for FE_SET_PROPERTY
  media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl()
    return code
  media: dvb_frontend: fix return error code

Minas Harutyunyan (1):
  usb: dwc2: Postponed gadget registration to the udc class driver

Miquel Raynal (8):
  mtd: rawnand: diskonchip: Fix the probe error path
  mtd: rawnand: sharpsl: Fix the probe error path
  mtd: rawnand: xway: Fix the probe error path
  mtd: rawnand: orion: Fix the probe error path
  mtd: rawnand: socrates: Fix the probe error path
  mtd: rawnand: plat_nand: Fix the probe error path
  mtd: rawnand: mtk: Fix the probe error path
  mtd: rawnand: tmio: Fix the probe error path

Nathan Chancellor (3):
  USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in
    s3c2410_udc_nuke
  clk: bcm2835: Fix return type of bcm2835_register_gate
  ACPI: sysfs: Fix pm_profile_attr type

Naveen N. Rao (1):
  powerpc/kprobes: Fixes for kprobe_lookup_name() on BE

Neal Cardwell (1):
  tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Nicholas Piggin (1):
  powerpc/pseries/ras: Fix FWNMI_VALID off by one

Nick Desaulniers (1):
  elfnote: mark all .note sections SHF_ALLOC

Olga Kornievskaia (2):
  NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION
  NFSv4 fix CLOSE not waiting for direct IO compeletion

Oliver Neukum (1):
  usblp: poison URBs upon disconnect

Pali Rohár (1):
  PCI: aardvark: Don't blindly enable ASPM L0s and don't write to
    read-only register

Pawel Laszczak (1):
  usb: gadget: Fix issue with config_ep_by_speed function

Pingfan Liu (1):
  powerpc/crashkernel: Take "mem=" option into account

Qais Yousef (3):
  usb/ohci-platform: Fix a warning when hibernating
  usb/xhci-plat: Set PM runtime as active on resume
  usb/ehci-platform: Set PM runtime as active on resume

Qian Cai (2):
  vfio/pci: fix memory leaks in alloc_perm_bits()
  powerpc/64s/pgtable: fix an undefined behaviour

Qiushi Wu (3):
  usb: gadget: fix potential double-free in m66592_probe.
  scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj
  efi/esrt: Fix reference count leak in esre_create_sysfs_entry.

Raghavendra Rao Ananta (1):
  tty: hvc: Fix data abort due to race in hvc_open

Ram Pai (1):
  selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

Ridge Kennedy (1):
  l2tp: Allow duplicate session creation with UDP

Rikard Falkeborn (1):
  clk: sunxi: Fix incorrect usage of round_down()

Roy Spliet (1):
  drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation

Russell King (3):
  i2c: pxa: clear all master action bits in i2c_pxa_stop_message()
  i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output
  netfilter: ipset: fix unaligned atomic access

Sasha Levin (1):
  Linux 4.9.229-rc1

Satendra Singh Thakur (1):
  media: dvb_frontend: dtv_property_process_set() cleanups

Simon Arlott (1):
  scsi: sr: Fix sr_probe() missing deallocate of device minor

Stafford Horne (1):
  openrisc: Fix issue with argument clobbering for clone/fork

Stefan Riedmueller (1):
  watchdog: da9062: No need to ping manually before setting timeout

Suganath Prabu S (1):
  scsi: mpt3sas: Fix double free warnings

Sven Schnelle (1):
  s390/ptrace: fix setting syscall number

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

Tero Kristo (2):
  clk: ti: composite: fix memory leak
  crypto: omap-sham - add proper load balancing support for multicore

Thomas Gleixner (1):
  sched/rt, net: Use CONFIG_PREEMPTION.patch

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

Ye Bin (1):
  ata/libata: Fix usage of page address by page_address in
    ata_scsi_mode_select_xlat function

Yick W. Tse (1):
  ALSA: usb-audio: add quirk for Denon DCD-1500RE

Zekun Shen (1):
  net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
  cifs/smb3: Fix data inconsistent when punch hole
  cifs/smb3: Fix data inconsistent when zero file range

Zheng Bin (1):
  xfs: add agf freeblocks verify in xfs_agf_verify

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

 .../media/uapi/dvb/fe-get-property.rst        |   7 +-
 Makefile                                      |   4 +-
 arch/arm/mach-imx/pm-imx5.c                   |   6 +-
 arch/arm/mach-integrator/Kconfig              |   7 +-
 arch/arm64/kernel/perf_regs.c                 |  25 +-
 arch/openrisc/kernel/entry.S                  |   4 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h  |  23 +-
 arch/powerpc/include/asm/kprobes.h            |   3 +-
 arch/powerpc/kernel/machine_kexec.c           |   8 +-
 arch/powerpc/perf/hv-24x7.c                   |  10 -
 arch/powerpc/platforms/ps3/mm.c               |  22 +-
 arch/powerpc/platforms/pseries/ras.c          |   5 +-
 arch/s390/include/asm/syscall.h               |  12 +-
 arch/s390/kernel/ptrace.c                     |  31 +-
 arch/sparc/kernel/ptrace_32.c                 |   9 +-
 arch/x86/boot/Makefile                        |   2 +-
 arch/x86/kernel/kprobes/core.c                |  12 +-
 arch/x86/kvm/x86.c                            |   4 +-
 crypto/algboss.c                              |   2 -
 drivers/acpi/sysfs.c                          |   4 +-
 drivers/ata/libata-core.c                     |  11 +-
 drivers/ata/libata-scsi.c                     |   9 +-
 drivers/base/platform.c                       |   2 +
 drivers/block/ps3disk.c                       |   1 -
 drivers/clk/bcm/clk-bcm2835.c                 |  10 +-
 drivers/clk/qcom/gcc-msm8916.c                |   8 +-
 drivers/clk/samsung/clk-exynos5433.c          |   3 +-
 drivers/clk/st/clk-flexgen.c                  |   1 +
 drivers/clk/sunxi/clk-sunxi.c                 |   2 +-
 drivers/clk/ti/composite.c                    |   1 +
 drivers/crypto/omap-sham.c                    |  64 +-
 drivers/extcon/extcon-adc-jack.c              |   3 +-
 drivers/firmware/efi/esrt.c                   |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c         |  58 +-
 drivers/gpu/drm/drm_encoder_slave.c           |   5 +-
 drivers/gpu/drm/i915/i915_cmd_parser.c        |   4 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c       |   3 +-
 drivers/gpu/drm/qxl/qxl_kms.c                 |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c               |   2 +-
 drivers/i2c/busses/i2c-piix4.c                |   3 +-
 drivers/i2c/busses/i2c-pxa.c                  |  13 +-
 drivers/iio/pressure/bmp280-core.c            |   7 +-
 drivers/infiniband/core/cma_configfs.c        |  13 +
 drivers/infiniband/core/mad.c                 |   1 +
 drivers/md/bcache/btree.c                     |   8 +-
 drivers/media/dvb-core/dvb_frontend.c         | 569 +++++++++++------
 drivers/media/dvb-core/dvb_frontend.h         |  13 -
 drivers/media/dvb-frontends/lg2160.c          |  14 -
 drivers/media/dvb-frontends/stv0288.c         |   7 -
 drivers/media/dvb-frontends/stv6110.c         |   9 -
 drivers/media/usb/dvb-usb/friio-fe.c          |  24 -
 drivers/mfd/wm8994-core.c                     |   1 +
 drivers/mtd/nand/ams-delta.c                  |   2 +-
 drivers/mtd/nand/atmel_nand.c                 |   2 +-
 drivers/mtd/nand/au1550nd.c                   |   2 +-
 drivers/mtd/nand/bcm47xxnflash/main.c         |   2 +-
 drivers/mtd/nand/bf5xx_nand.c                 |   2 +-
 drivers/mtd/nand/brcmnand/brcmnand.c          |   2 +-
 drivers/mtd/nand/cafe_nand.c                  |   2 +-
 drivers/mtd/nand/cmx270_nand.c                |   2 +-
 drivers/mtd/nand/cs553x_nand.c                |   2 +-
 drivers/mtd/nand/davinci_nand.c               |   2 +-
 drivers/mtd/nand/denali.c                     |   2 +-
 drivers/mtd/nand/diskonchip.c                 |   9 +-
 drivers/mtd/nand/docg4.c                      |   4 +-
 drivers/mtd/nand/fsl_elbc_nand.c              |   2 +-
 drivers/mtd/nand/fsl_ifc_nand.c               |   2 +-
 drivers/mtd/nand/fsl_upm.c                    |   2 +-
 drivers/mtd/nand/fsmc_nand.c                  |   2 +-
 drivers/mtd/nand/gpio.c                       |   2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   2 +-
 drivers/mtd/nand/hisi504_nand.c               |   5 +-
 drivers/mtd/nand/jz4740_nand.c                |   4 +-
 drivers/mtd/nand/jz4780_nand.c                |   4 +-
 drivers/mtd/nand/lpc32xx_mlc.c                |   5 +-
 drivers/mtd/nand/lpc32xx_slc.c                |   5 +-
 drivers/mtd/nand/mpc5121_nfc.c                |   2 +-
 drivers/mtd/nand/mtk_nand.c                   |   4 +-
 drivers/mtd/nand/mxc_nand.c                   |   2 +-
 drivers/mtd/nand/nand_base.c                  |   8 +-
 drivers/mtd/nand/nandsim.c                    |   4 +-
 drivers/mtd/nand/ndfc.c                       |   2 +-
 drivers/mtd/nand/nuc900_nand.c                |   2 +-
 drivers/mtd/nand/omap2.c                      |   2 +-
 drivers/mtd/nand/orion_nand.c                 |   5 +-
 drivers/mtd/nand/pasemi_nand.c                |   2 +-
 drivers/mtd/nand/plat_nand.c                  |   4 +-
 drivers/mtd/nand/pxa3xx_nand.c                |   2 +-
 drivers/mtd/nand/qcom_nandc.c                 |   4 +-
 drivers/mtd/nand/r852.c                       |   4 +-
 drivers/mtd/nand/s3c2410.c                    |   2 +-
 drivers/mtd/nand/sh_flctl.c                   |   2 +-
 drivers/mtd/nand/sharpsl.c                    |   4 +-
 drivers/mtd/nand/socrates_nand.c              |   5 +-
 drivers/mtd/nand/sunxi_nand.c                 |   4 +-
 drivers/mtd/nand/tmio_nand.c                  |   4 +-
 drivers/mtd/nand/txx9ndfmc.c                  |   2 +-
 drivers/mtd/nand/vf610_nfc.c                  |   2 +-
 drivers/mtd/nand/xway_nand.c                  |   4 +-
 drivers/net/ethernet/atheros/alx/main.c       |   9 +-
 drivers/net/ethernet/broadcom/tg3.c           |   4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  14 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |  23 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 drivers/net/hamradio/yam.c                    |   1 +
 drivers/net/usb/ax88179_178a.c                |  11 +-
 drivers/pci/host/pci-aardvark.c               |   4 -
 drivers/pci/host/pcie-rcar.c                  |   9 +-
 drivers/pci/pcie/aspm.c                       |  10 -
 drivers/pci/pcie/ptm.c                        |  22 +-
 drivers/pinctrl/freescale/pinctrl-imx1-core.c |   1 -
 drivers/power/supply/Kconfig                  |   2 +-
 drivers/power/supply/lp8788-charger.c         |  18 +-
 drivers/power/supply/smb347-charger.c         |   1 +
 drivers/s390/cio/qdio.h                       |   1 -
 drivers/s390/cio/qdio_setup.c                 |   1 -
 drivers/s390/cio/qdio_thinint.c               |  14 +-
 drivers/scsi/arm/acornscsi.c                  |   4 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |   2 +
 drivers/scsi/iscsi_boot_sysfs.c               |   2 +-
 drivers/scsi/lpfc/lpfc_els.c                  |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c           |   2 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c            |   2 +
 drivers/scsi/scsi_devinfo.c                   |   5 +-
 drivers/scsi/sr.c                             |   6 +-
 drivers/staging/sm750fb/sm750.c               |   1 +
 drivers/tty/hvc/hvc_console.c                 |  16 +-
 drivers/tty/n_gsm.c                           |  26 +-
 drivers/tty/serial/amba-pl011.c               |   1 +
 drivers/usb/class/cdc-acm.c                   |   2 +
 drivers/usb/class/usblp.c                     |   5 +-
 drivers/usb/core/quirks.c                     |   3 +-
 drivers/usb/dwc2/core_intr.c                  |   7 +-
 drivers/usb/dwc2/gadget.c                     |   6 -
 drivers/usb/dwc2/platform.c                   |  11 +
 drivers/usb/gadget/composite.c                |  78 ++-
 drivers/usb/gadget/udc/lpc32xx_udc.c          |  11 +-
 drivers/usb/gadget/udc/m66592-udc.c           |   2 +-
 drivers/usb/gadget/udc/mv_udc_core.c          |   3 +-
 drivers/usb/gadget/udc/s3c2410_udc.c          |   4 -
 drivers/usb/host/ehci-exynos.c                |   5 +-
 drivers/usb/host/ehci-mxc.c                   |   2 +
 drivers/usb/host/ehci-pci.c                   |   7 +
 drivers/usb/host/ehci-platform.c              |   5 +
 drivers/usb/host/ohci-platform.c              |   5 +
 drivers/usb/host/ohci-sm501.c                 |   1 +
 drivers/usb/host/xhci-plat.c                  |  11 +-
 drivers/usb/host/xhci.c                       |   4 +
 drivers/usb/host/xhci.h                       |   2 +-
 drivers/vfio/pci/vfio_pci_config.c            |  14 +-
 drivers/video/backlight/lp855x_bl.c           |  20 +-
 drivers/watchdog/da9062_wdt.c                 |   5 -
 fs/block_dev.c                                |  12 +-
 fs/cifs/smb2ops.c                             |  12 +
 fs/compat_ioctl.c                             |  17 -
 fs/dlm/dlm_internal.h                         |   1 -
 fs/ext4/extents.c                             |   2 +-
 fs/gfs2/ops_fstype.c                          |   2 +-
 fs/nfs/direct.c                               |  13 +-
 fs/nfs/file.c                                 |   1 +
 fs/nfs/flexfilelayout/flexfilelayout.c        |  11 +-
 fs/nfs/nfs4proc.c                             |   2 +-
 fs/nfsd/nfs4callback.c                        |   2 +
 fs/ocfs2/ocfs2_fs.h                           |   4 +-
 fs/ocfs2/suballoc.c                           |   9 +-
 fs/xfs/libxfs/xfs_alloc.c                     |  16 +
 include/linux/bitops.h                        |   2 +-
 include/linux/elfnote.h                       |   2 +-
 include/linux/genhd.h                         |   2 +
 include/linux/kprobes.h                       |   4 +
 include/linux/libata.h                        |   3 +
 include/linux/mtd/nand.h                      |   6 +-
 include/linux/netdevice.h                     |   2 +-
 include/linux/qed/qed_chain.h                 |  26 +-
 include/linux/usb/composite.h                 |   3 +
 include/net/sctp/constants.h                  |   8 +-
 include/net/sock.h                            |   1 -
 include/uapi/linux/dvb/frontend.h             | 591 +++++++++++++++---
 kernel/kprobes.c                              |  27 +-
 kernel/sched/core.c                           |   3 +-
 kernel/trace/blktrace.c                       |  13 +
 kernel/trace/trace_events_trigger.c           |  21 +-
 lib/zlib_inflate/inffast.c                    |  91 ++-
 mm/slab_common.c                              |   2 +-
 net/core/dev.c                                |  47 +-
 net/core/sock.c                               |   2 +
 net/ipv4/fib_semantics.c                      |   2 +-
 net/ipv4/ip_tunnel.c                          |  14 +-
 net/ipv4/tcp_cubic.c                          |   2 +
 net/ipv4/tcp_input.c                          |  12 +-
 net/ipv6/ip6_gre.c                            |   9 +-
 net/ipv6/mcast.c                              |   1 +
 net/l2tp/l2tp_core.c                          |   7 +-
 net/netfilter/ipset/ip_set_core.c             |   2 +
 net/rxrpc/call_accept.c                       |   7 +
 net/sched/sch_generic.c                       |   1 +
 net/sctp/associola.c                          |   5 +-
 net/sctp/bind_addr.c                          |   1 +
 net/sctp/protocol.c                           |   1 +
 net/sunrpc/addr.c                             |   4 +-
 net/sunrpc/rpc_pipe.c                         |   1 +
 net/sunrpc/xdr.c                              |   4 +
 scripts/Kbuild.include                        |  11 +-
 scripts/mksysmap                              |   2 +-
 security/selinux/ss/services.c                |   4 +
 sound/isa/wavefront/wavefront_synth.c         |   8 +-
 sound/pci/hda/patch_hdmi.c                    |   5 +
 sound/soc/fsl/fsl_asrc_dma.c                  |   1 +
 sound/usb/card.h                              |   4 +
 sound/usb/endpoint.c                          |  43 +-
 sound/usb/endpoint.h                          |   1 +
 sound/usb/mixer.c                             |  34 +-
 sound/usb/mixer.h                             |  15 +-
 sound/usb/mixer_quirks.c                      |  11 +-
 sound/usb/mixer_scarlett.c                    |   6 +-
 sound/usb/pcm.c                               |   2 +
 sound/usb/quirks.c                            |   1 +
 tools/perf/builtin-report.c                   |   3 +-
 .../networking/timestamping/timestamping.c    |  10 +-
 tools/testing/selftests/x86/protection_keys.c |   3 +-
 221 files changed, 1919 insertions(+), 930 deletions(-)

-- 
2.25.1

