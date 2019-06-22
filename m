Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC6B4F4D8
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVJpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbfFVJpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:45:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CE72084E;
        Sat, 22 Jun 2019 09:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196715;
        bh=kbAyVgqctNegaSITNukFLACbLPJ08DvQ/d7YVeteZXM=;
        h=Date:From:To:Cc:Subject:From;
        b=T2K0S06R+Q+Ah5PB3V4JbMk2y0mtd00TqYECyTgCmUgi4fsb96/mWGRcDGiv2qHS1
         8A2QgwAkEfW1PYuCJ5gcqc6R6w6LdLtMumCThBBQtJP0bIjjkTdf/B2WoTenShKqBg
         EsJ/fXhBxWZf8pqJ1XGWTt7/geLk8jm/yLKQX1h4=
Date:   Sat, 22 Jun 2019 11:45:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.183
Message-ID: <20190622094511.GA12147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.183 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 -
 arch/arm/boot/dts/exynos5420-arndale-octa.dts  |    2 +
 arch/arm/boot/dts/imx6qdl.dtsi                 |    2 -
 arch/arm/boot/dts/imx6sl.dtsi                  |    2 -
 arch/arm/boot/dts/imx6sx.dtsi                  |    2 -
 arch/arm/mach-exynos/suspend.c                 |   19 +++++++++++++
 arch/ia64/mm/numa.c                            |    1 
 arch/powerpc/include/asm/kvm_host.h            |    1 
 arch/powerpc/kvm/book3s.c                      |    1 
 arch/powerpc/kvm/book3s_rtas.c                 |   14 ++++------
 arch/s390/kvm/kvm-s390.c                       |   35 +++++++++++++++----------
 arch/x86/kernel/cpu/amd.c                      |    7 +++--
 arch/x86/kernel/cpu/perf_event_intel.c         |    2 -
 arch/x86/kvm/pmu_intel.c                       |   13 +++++----
 arch/x86/pci/irq.c                             |   10 +++++--
 drivers/android/binder.c                       |    6 ++++
 drivers/ata/libata-core.c                      |    9 ++++--
 drivers/clk/rockchip/clk-rk3288.c              |   11 +++++++
 drivers/crypto/amcc/crypto4xx_alg.c            |    3 --
 drivers/crypto/amcc/crypto4xx_core.c           |    9 ------
 drivers/dma/idma64.c                           |    6 ++--
 drivers/dma/idma64.h                           |    2 +
 drivers/gpio/Kconfig                           |    1 
 drivers/gpio/gpio-omap.c                       |   25 ++++++++++++-----
 drivers/gpu/drm/i2c/adv7511.c                  |    6 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |    7 ++++-
 drivers/i2c/busses/i2c-acorn.c                 |    1 
 drivers/i2c/i2c-dev.c                          |    1 
 drivers/infiniband/hw/mlx4/main.c              |    3 ++
 drivers/iommu/intel-iommu.c                    |    7 ++---
 drivers/isdn/mISDN/socket.c                    |    5 ++-
 drivers/md/bcache/bset.c                       |   16 +++++++++--
 drivers/md/bcache/bset.h                       |   34 ++++++++++++++----------
 drivers/mfd/intel-lpss.c                       |    3 ++
 drivers/mfd/twl6040.c                          |   13 ++++++++-
 drivers/misc/kgdbts.c                          |    4 +-
 drivers/net/ethernet/dec/tulip/de4x5.c         |    1 
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    2 -
 drivers/net/ethernet/renesas/sh_eth.c          |    4 ++
 drivers/net/usb/ipheth.c                       |    3 +-
 drivers/nvmem/core.c                           |   15 +++++++---
 drivers/pci/host/pcie-rcar.c                   |    4 ++
 drivers/pci/host/pcie-xilinx.c                 |   12 +++++++-
 drivers/pci/hotplug/rpadlpar_core.c            |    4 ++
 drivers/platform/chrome/cros_ec_proto.c        |   11 +++++++
 drivers/pwm/core.c                             |   10 +++----
 drivers/pwm/pwm-tiehrpwm.c                     |    2 +
 drivers/pwm/sysfs.c                            |   14 ----------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c               |    2 -
 drivers/scsi/cxgbi/libcxgbi.c                  |    4 ++
 drivers/scsi/libsas/sas_expander.c             |    2 +
 drivers/scsi/lpfc/lpfc_els.c                   |    5 ++-
 drivers/soc/mediatek/mtk-pmic-wrap.c           |    2 -
 drivers/spi/spi-pxa2xx.c                       |    7 -----
 drivers/tty/serial/8250/8250_dw.c              |    4 +-
 drivers/tty/serial/sunhv.c                     |    2 -
 drivers/usb/core/quirks.c                      |    3 ++
 drivers/usb/serial/option.c                    |    6 ++++
 drivers/usb/serial/pl2303.c                    |    1 
 drivers/usb/serial/pl2303.h                    |    3 ++
 drivers/usb/storage/unusual_realtek.h          |    5 +++
 drivers/video/fbdev/hgafb.c                    |    2 +
 drivers/video/fbdev/imsttfb.c                  |    5 +++
 fs/configfs/dir.c                              |   14 ++++------
 fs/f2fs/recovery.c                             |   10 ++++++-
 fs/f2fs/segment.h                              |    3 --
 fs/fat/file.c                                  |   11 +++++--
 fs/fuse/dev.c                                  |    2 -
 fs/inode.c                                     |    9 +++++-
 fs/nfsd/vfs.h                                  |    5 ++-
 fs/ocfs2/dcache.c                              |   12 ++++++++
 fs/proc/task_mmu.c                             |   18 ++++++++++++
 fs/userfaultfd.c                               |    7 +++++
 include/linux/cgroup.h                         |   10 +++++--
 include/linux/mm.h                             |   21 +++++++++++++++
 include/linux/pwm.h                            |    5 ---
 include/net/bluetooth/hci_core.h               |    3 --
 ipc/mqueue.c                                   |   10 +++++--
 ipc/msgutil.c                                  |    6 ++++
 kernel/cred.c                                  |    9 ++++++
 kernel/events/ring_buffer.c                    |   33 ++++++++++++++++++++---
 kernel/futex.c                                 |    4 +-
 kernel/ptrace.c                                |   20 ++++++++++++--
 kernel/sys.c                                   |    2 -
 kernel/sysctl.c                                |    6 ++--
 kernel/time/ntp.c                              |    2 -
 mm/cma.c                                       |    4 ++
 mm/cma_debug.c                                 |    2 -
 mm/hugetlb.c                                   |   21 +++++++++++----
 mm/list_lru.c                                  |    2 -
 mm/mmap.c                                      |    7 ++++-
 net/ax25/ax25_route.c                          |    2 +
 net/bluetooth/hci_conn.c                       |    8 -----
 net/core/neighbour.c                           |    7 +++++
 net/ipv6/ip6_flowlabel.c                       |    7 ++---
 net/lapb/lapb_iface.c                          |    1 
 sound/core/seq/seq_ports.c                     |    2 -
 sound/pci/hda/hda_intel.c                      |    6 ++--
 sound/soc/codecs/cs42xx8.c                     |    1 
 99 files changed, 517 insertions(+), 195 deletions(-)

Alexander Lochmann (1):
      Abort file_remove_privs() for non-reg. files

Andrea Arcangeli (1):
      coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping

Andrey Smirnov (3):
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA

Andy Shevchenko (1):
      dmaengine: idma64: Use actual device for DMA transfers

Bernd Eckstein (1):
      usbnet: ipheth: fix racing condition

Binbin Wu (1):
      mfd: intel-lpss: Set the device in reset state when init

Chao Yu (2):
      f2fs: fix to avoid panic in do_recover_data()
      f2fs: fix to do sanity check on valid block count of segment

Chris Packham (1):
      USB: serial: pl2303: add Allied Telesis VT-Kit3

Christian Borntraeger (1):
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christian Brauner (1):
      sysctl: return -EINVAL if val violates minmax

Christoph Vogtländer (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Coly Li (1):
      bcache: fix stack corruption by PRECEDING_KEY()

Cyrill Gorcunov (1):
      kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Dan Carpenter (1):
      mISDN: make sure device name is NUL terminated

Daniele Palmas (1):
      USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Douglas Anderson (1):
      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288

Enrico Granata (1):
      platform/chrome: cros_ec_proto: check for NULL transfer function

Eric Dumazet (3):
      ax25: fix inconsistent lock state in ax25_destroy_timer
      ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
      neigh: fix use-after-free read in pneigh_get_next

Eric W. Biederman (1):
      signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO

Frank van der Linden (1):
      x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
      Revert "crypto: crypto4xx - properly set IV after de- and encrypt"
      Linux 4.4.183

Hans de Goede (1):
      libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Hou Tao (1):
      fs/fat/file.c: issue flush after the writeback of FAT

Ivan Vecera (1):
      be2net: Fix number of Rx queues used for flow hashing

J. Bruce Fields (1):
      nfsd: allow fh_want_write to be called twice

James Smart (1):
      scsi: lpfc: add check for loss of ndlp when sending RRQ

Jann Horn (1):
      ptrace: restore smp_rmb() in __ptrace_may_access()

Jason Yan (1):
      scsi: libsas: delete sas port if expander discover failed

Jeremy Sowden (1):
      lapb: fixed leak of control-blocks.

John Paul Adrian Glaubitz (1):
      sunhv: Fix device naming inconsistency between sunhv_console and sunhv_reg

Jorge Ramirez-Ortiz (1):
      nvmem: core: fix read buffer in place

Jörgen Storvist (1):
      USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Kai-Heng Feng (1):
      USB: usb-storage: Add new ID to ums-realtek

Kangjie Lu (4):
      PCI: rcar: Fix a potential NULL pointer dereference
      video: hgafb: fix potential NULL pointer dereference
      video: imsttfb: fix potential NULL pointer dereferences
      PCI: xilinx: Check for __get_free_pages() failure

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Kirill Smelkov (1):
      fuse: retrieve: cap requested size to negotiated max_write

Krzysztof Kozlowski (1):
      ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regulators on Arndale Octa

Li Rongqing (1):
      ipc: prevent lockup on alloc_msg and free_msg

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Marco Zatta (1):
      USB: Fix chipmunk-like voice when using Logitech C270 for recording audio.

Marek Szyprowski (1):
      ARM: exynos: Fix undefined instruction during Exynos5422 resume

Matt Redfearn (1):
      drm/bridge: adv7511: Fix low refresh rate selection

Mike Kravetz (1):
      hugetlbfs: on restore reserve error path retain subpool reservation

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Murray McAllister (2):
      drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read
      drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Nathan Chancellor (1):
      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Paolo Bonzini (1):
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Paul Mackerras (1):
      KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list

Peter Zijlstra (1):
      perf/ring_buffer: Add ordering to rb->nest increment

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Randy Dunlap (2):
      gpio: fix gpio-adp5588 build errors
      ia64: fix build errors by exporting paddr_to_nid()

Russell King (1):
      i2c: acorn: fix i2c warning

S.j. Wang (1):
      ASoC: cs42xx8: Add regcache mask dirty

Sahitya Tummala (1):
      configfs: Fix use-after-free when accessing sd->s_dentry

Shakeel Butt (1):
      mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Stephane Eranian (1):
      perf/x86/intel: Allow PEBS multi-entry in watermark mode

Takashi Iwai (2):
      ALSA: hda - Register irq handler after the chip initialization
      ALSA: seq: Cover unsubscribe_port() in list_mutex

Tejun Heo (1):
      cgroup: Use css_tryget() instead of css_tryget_online() in task_get_css()

Tony Lindgren (2):
      mfd: twl6040: Fix device init errors for ACCCTL register
      gpio: gpio-omap: add check for off wake capable gpios

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Varun Prakash (1):
      scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Wengang Wang (1):
      fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Wenwen Wang (1):
      x86/PCI: Fix PCI IRQ routing table memory leak

Yabin Cui (1):
      perf/ring_buffer: Fix exposing a temporarily decreased data_head

Yingjoe Chen (1):
      i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Yoshihiro Shimoda (1):
      net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs

Young Xiao (1):
      Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var

Yue Hu (2):
      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

ZhangXiaoxu (1):
      futex: Fix futex lock the wrong page

