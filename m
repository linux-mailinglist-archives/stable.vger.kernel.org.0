Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD4E7BCD4
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfGaJVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfGaJVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:21:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D4C2089E;
        Wed, 31 Jul 2019 09:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564564890;
        bh=0EH4SVEybO1N8xBCiUS2ZjILrLqtXn+uvOdyLrDA0D4=;
        h=Date:From:To:Cc:Subject:From;
        b=DH85hWaY37GctIw1MdqIYVyiAXgS09Mo3QdSPxBb7u+GhmaOJ7gU8xs41Zc2tTz3I
         TrwCzUs4Pj9UiV2CGyjwKgPsxnfvbB86c+pUdzR9AWZSv4ez7pncOBEjUDRDni+tTl
         3yNHH2/vsBaTksF5P5MCO5VvOltPd3in8XO/ypqs=
Date:   Wed, 31 Jul 2019 11:21:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.63
Message-ID: <20190731092128.GA15669@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.63 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    3=20
 arch/arm64/include/asm/assembler.h                          |    4=20
 arch/powerpc/boot/xz_config.h                               |   20 ++
 arch/powerpc/include/asm/cacheflush.h                       |    7=20
 arch/powerpc/kernel/eeh.c                                   |   15 +
 arch/powerpc/kernel/pci_of_scan.c                           |    2=20
 arch/powerpc/kernel/signal_32.c                             |    3=20
 arch/powerpc/kernel/signal_64.c                             |    5=20
 arch/powerpc/mm/hugetlbpage.c                               |    8 +
 arch/powerpc/platforms/4xx/uic.c                            |    1=20
 arch/powerpc/platforms/pseries/mobility.c                   |    9 +
 arch/powerpc/sysdev/xive/common.c                           |    7=20
 arch/powerpc/xmon/xmon.c                                    |    6=20
 arch/sh/include/asm/io.h                                    |    6=20
 arch/um/include/asm/mmu_context.h                           |    2=20
 arch/x86/kernel/cpu/bugs.c                                  |    2=20
 arch/x86/kernel/sysfb_efi.c                                 |   46 +++++
 block/bio-integrity.c                                       |    8 -
 block/blk-core.c                                            |    1=20
 drivers/android/binder.c                                    |    2=20
 drivers/char/hpet.c                                         |    3=20
 drivers/fpga/Kconfig                                        |    1=20
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                       |    3=20
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c       |   21 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c             |    5=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |   10 -
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c                |    2=20
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    3=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c   |    1=20
 drivers/gpu/drm/bridge/sii902x.c                            |    5=20
 drivers/gpu/drm/bridge/tc358767.c                           |    7=20
 drivers/gpu/drm/drm_debugfs_crc.c                           |    9 -
 drivers/gpu/drm/drm_edid_load.c                             |    2=20
 drivers/gpu/drm/msm/msm_drv.c                               |   14 +
 drivers/gpu/drm/panel/panel-simple.c                        |    9 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c                 |    3=20
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                      |    3=20
 drivers/gpu/drm/virtio/virtgpu_vq.c                         |    2=20
 drivers/gpu/host1x/bus.c                                    |    3=20
 drivers/i2c/busses/i2c-stm32f7.c                            |   26 +--
 drivers/iio/adc/stm32-dfsdm-adc.c                           |    6=20
 drivers/iio/adc/stm32-dfsdm-core.c                          |    8 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c                   |    2=20
 drivers/infiniband/hw/mlx5/mad.c                            |   60 ++++---
 drivers/infiniband/sw/rxe/rxe_resp.c                        |    5=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                       |    1=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c                   |   34 ++--
 drivers/mailbox/mailbox.c                                   |    6=20
 drivers/memstick/core/memstick.c                            |   13 +
 drivers/mfd/arizona-core.c                                  |    2=20
 drivers/mfd/hi655x-pmic.c                                   |    2=20
 drivers/mfd/madera-core.c                                   |    1=20
 drivers/mfd/mfd-core.c                                      |    1=20
 drivers/misc/mei/hw-me-regs.h                               |    3=20
 drivers/misc/mei/pci-me.c                                   |    3=20
 drivers/mmc/host/sdhci-pci-o2micro.c                        |   12 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c              |   19 +-
 drivers/nvdimm/bus.c                                        |   96 +++++++=
-----
 drivers/nvdimm/nd-core.h                                    |    3=20
 drivers/pci/controller/dwc/pci-dra7xx.c                     |    1=20
 drivers/pci/controller/pcie-mobiveil.c                      |   22 ++
 drivers/pci/controller/pcie-xilinx-nwl.c                    |   11 -
 drivers/pci/pci-driver.c                                    |   13 -
 drivers/pci/pci-sysfs.c                                     |    2=20
 drivers/phy/renesas/phy-rcar-gen2.c                         |    2=20
 drivers/pinctrl/pinctrl-rockchip.c                          |    1=20
 drivers/staging/vt6656/main_usb.c                           |   42 +++--
 drivers/tty/serial/8250/8250_port.c                         |    3=20
 drivers/tty/serial/cpm_uart/cpm_uart_core.c                 |   17 +-
 drivers/tty/serial/digicolor-usart.c                        |    6=20
 drivers/tty/serial/imx.c                                    |   23 +-
 drivers/tty/serial/max310x.c                                |   51 +++---
 drivers/tty/serial/msm_serial.c                             |    4=20
 drivers/tty/serial/serial_core.c                            |    7=20
 drivers/tty/serial/serial_mctrl_gpio.c                      |   14 +
 drivers/tty/serial/sh-sci.c                                 |   33 +++-
 drivers/usb/core/hub.c                                      |   28 ++-
 drivers/usb/gadget/function/f_fs.c                          |    6=20
 drivers/usb/host/hwa-hc.c                                   |    2=20
 drivers/usb/host/pci-quirks.c                               |   31 ++-
 fs/9p/vfs_addr.c                                            |    6=20
 fs/btrfs/inode.c                                            |   24 ++-
 fs/dlm/lowcomms.c                                           |   18 +-
 fs/f2fs/segment.c                                           |    5=20
 fs/notify/fanotify/fanotify.c                               |    5=20
 fs/notify/inotify/inotify_fsnotify.c                        |    8 -
 fs/open.c                                                   |   19 ++
 fs/proc/base.c                                              |   28 ++-
 fs/proc/task_mmu.c                                          |   23 ++
 fs/proc/task_nommu.c                                        |    6=20
 include/linux/cred.h                                        |    7=20
 include/linux/host1x.h                                      |    2=20
 kernel/cred.c                                               |   21 ++
 kernel/locking/lockdep_proc.c                               |    8 -
 mm/gup.c                                                    |   12 +
 mm/kmemleak.c                                               |    2=20
 mm/memory.c                                                 |    4=20
 mm/mmu_notifier.c                                           |    2=20
 mm/nommu.c                                                  |    3=20
 mm/swap.c                                                   |   13 +
 net/vmw_vsock/hyperv_transport.c                            |   44 +----
 scripts/genksyms/keywords.c                                 |    4=20
 scripts/genksyms/parse.y                                    |    2=20
 scripts/kallsyms.c                                          |    3=20
 scripts/recordmcount.h                                      |    3=20
 sound/ac97/bus.c                                            |   13 -
 sound/pci/hda/patch_conexant.c                              |    1=20
 sound/usb/line6/podhd.c                                     |    2=20
 tools/iio/iio_utils.c                                       |    4=20
 tools/perf/builtin-stat.c                                   |    2=20
 tools/perf/builtin-top.c                                    |    8 -
 tools/perf/tests/mmap-thread-lookup.c                       |    2=20
 tools/perf/ui/browsers/hists.c                              |   15 +
 tools/perf/util/annotate.c                                  |    6=20
 tools/perf/util/session.c                                   |    3=20
 115 files changed, 855 insertions(+), 358 deletions(-)

Alex Williamson (1):
      PCI: Return error if cannot probe VF

Alexander Usyskin (1):
      mei: me: add mule creek canyon (EHL) device ids

Alexey Kardashevskiy (1):
      powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Andrzej Pietrasiewicz (1):
      usb: gadget: Zero ffs_io_data

Andy Lutomirski (1):
      mm/gup.c: remove some BUG_ONs from get_gate_page()

Aneesh Kumar K.V (1):
      powerpc/mm: Handle page table allocation failures

Arnd Bergmann (3):
      mfd: arizona: Fix undefined behavior
      cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()
      locking/lockdep: Hide unused 'class' variable

Axel Lin (1):
      mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init=
_mmio_clk

Bastien Nocera (1):
      iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada (1):
      PCI: xilinx-nwl: Fix Multi MSI data programming

Christian Lamparter (1):
      powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Christoph Hellwig (1):
      9p: pass the correct prototype to read_cache_page

Christophe Leroy (1):
      tty: serial: cpm_uart - fix init when SMC is relocated

Dan Williams (1):
      libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()

Daniel Gomez (1):
      mfd: madera: Add missing of table registration

Daniel Vetter (2):
      drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry
      drm/crc-debugfs: Also sprinkle irqrestore over early exits

David Riley (1):
      drm/virtio: Add memory barriers for capset cache.

David Windsor (1):
      dlm: check if workqueues are NULL before flushing/destroying

Ding Xiang (1):
      ALSA: ac97: Fix double free of ac97_codec_device

Dmitry Vyukov (1):
      mm/kmemleak.c: fix check for softirq context

Douglas Anderson (1):
      drm/rockchip: Properly adjust to a true clock in adjusted_mode

Fabien Dessenne (2):
      iio: adc: stm32-dfsdm: manage the get_irq error case
      iio: adc: stm32-dfsdm: missing error case during probe

Fabrice Gasnier (1):
      i2c: stm32f7: fix the get_irq error cases

Gautham R. Shenoy (1):
      powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()

Geert Uytterhoeven (2):
      serial: sh-sci: Terminate TX DMA during buffer flushing
      serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Gen Zhang (1):
      drm/edid: Fix a missing-check bug in drm_load_edid_firmware()

Greg Kroah-Hartman (1):
      Linux 4.19.63

Guenter Roeck (1):
      mm/gup.c: mark undo_dev_pagemap as __maybe_unused

Hans de Goede (1):
      x86/sysfb_efi: Add quirks for some devices with swapped width and hei=
ght

Hariprasad Kelam (1):
      drm/amd/display: fix compilation error

Hou Zhiqiang (4):
      PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows
      PCI: mobiveil: Fix the Class Code field
      PCI: mobiveil: Initialize Primary/Secondary/Subordinate bus numbers
      PCI: mobiveil: Use the 1st inbound window for MEM inbound transactions

Hridya Valsaraju (1):
      binder: prevent transactions to context manager from its own process.

Hui Wang (1):
      ALSA: hda - Add a conexant codec entry to let mute led work

Ira Weiny (1):
      mm/swap: fix release_pages() when releasing devmap pages

James Morse (1):
      arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64=
_HAS_RAS

Jean-Philippe Brucker (1):
      mm/mmu_notifier: use hlist_add_head_rcu()

Johannes Berg (1):
      um: Silence lockdep complaint about mmap_sem

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: avoid system lockup condition

Josef Bacik (1):
      block: init flush rq ref count to 1

Jyri Sarha (1):
      drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

Kai-Heng Feng (1):
      ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Kefeng Wang (2):
      tty/serial: digicolor: Fix digicolor-usart already registered warning
      hpet: Fix division by zero in hpet_time_div()

Konstantin Khlebnikov (6):
      proc: use down_read_killable mmap_sem for /proc/pid/smaps_rollup
      proc: use down_read_killable mmap_sem for /proc/pid/pagemap
      proc: use down_read_killable mmap_sem for /proc/pid/clear_refs
      proc: use down_read_killable mmap_sem for /proc/pid/map_files
      proc: use down_read_killable mmap_sem for /proc/pid/maps
      mm: use down_read_killable for locking mmap_sem in access_remote_vm

Konstantin Taranov (1):
      RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Leo Yan (5):
      perf stat: Fix use-after-freed pointer detected by the smatch tool
      perf top: Fix potential NULL pointer dereference detected by the smat=
ch tool
      perf session: Fix potential NULL pointer dereference found by the sma=
tch tool
      perf annotate: Fix dereferencing freed memory found by the smatch tool
      perf hists browser: Fix potential NULL pointer dereference found by t=
he smatch tool

Linus Torvalds (1):
      access: avoid the RCU grace period for the temporary subjective crede=
ntials

Liu, Changcheng (1):
      RDMA/i40iw: Set queue pair state when being queried

Marek Vasut (1):
      PCI: sysfs: Ignore lockdep for remove attribute

Masahiro Yamada (1):
      powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

Michael Neuling (1):
      powerpc/tm: Fix oops on sigreturn on systems without TM

Nathan Chancellor (1):
      kbuild: Add -Werror=3Dunknown-warning-option to CLANG_FLAGS

Nathan Lynch (1):
      powerpc/pseries/mobility: prevent cpu hotplug during DT update

Naveen N. Rao (2):
      powerpc/xmon: Fix disabling tracing while in xmon
      recordmcount: Fix spurious mcount entries on powerpc

Nicholas Kazlauskas (2):
      drm/amd/display: Fill prescale_params->scale for RGB565
      drm/amd/display: Always allocate initial connector state state

Numfor Mbiziwo-Tiapo (1):
      perf test mmap-thread-lookup: Initialize variable to suppress memory =
sanitizer warning

Oak Zeng (2):
      drm/amdkfd: Fix a potential memory leak
      drm/amdkfd: Fix sdma queue map issue

Ocean Chen (1):
      f2fs: avoid out-of-range memory access

Oliver O'Halloran (1):
      powerpc/eeh: Handle hugepages in ioremap space

Parav Pandit (1):
      IB/mlx5: Fixed reporting counters on 2nd port for Dual port RoCE

Paul Hsieh (1):
      drm/amd/display: Disable ABM before destroy ABM struct

Peter Ujfalusi (1):
      drm/panel: simple: Fix panel_simple_dsi_probe

Phong Tran (1):
      usb: wusbcore: fix unbalanced get/put cluster_id

Qian Cai (1):
      powerpc/cacheflush: fix variable set but not used

Qu Wenruo (1):
      btrfs: inode: Don't compress if NODATASUM or NODATACOW set

Quentin Deslandes (1):
      staging: vt6656: use meaningful error code during buffer allocation

Raul E Rangel (1):
      mmc: sdhci: sdhci-pci-o2micro: Check if controller supports 8-bit wid=
th

Rautkoski Kimmo EXT (1):
      serial: 8250: Fix TX interrupt handling condition

Robert Hancock (1):
      mfd: core: Set fwnode for created devices

Ryan Kennedy (1):
      usb: pci-quirks: Correct AMD PLL quirk detection

Sam Ravnborg (1):
      sh: prevent warnings when using iounmap

Sean Paul (1):
      drm/msm: Depopulate platform on probe failure

Serge Semin (2):
      tty: max310x: Fix invalid baudrate divisors calculator
      tty: serial_core: Set port active bit in uart_port_activate

Sergey Organov (1):
      serial: imx: fix locking in set_termios()

Shakeel Butt (1):
      memcg, fsnotify: no oom-kill for remote memcg charging

Stefan Roese (1):
      serial: mctrl_gpio: Check if GPIO property exisits before requesting =
it

Sunil Muthuswamy (1):
      hvsock: fix epollout hang from race condition

Thierry Reding (1):
      gpu: host1x: Increase maximum DMA segment size

Thinh Nguyen (1):
      usb: core: hub: Disable hub-initiated U1/U2

Tiecheng Zhou (1):
      drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE

Tomi Valkeinen (1):
      drm/bridge: tc358767: read display_props in get_modes()

Valentine Fatiev (1):
      IB/ipoib: Add child to parent list only if device initialized

Vasily Gorbik (1):
      kallsyms: exclude kasan local symbols on s390

Wang Hai (1):
      memstick: Fix error cleanup path of memstick_init

Wen Yang (1):
      pinctrl: rockchip: fix leaked of_node references

Wenwen Wang (1):
      block/bio-integrity: fix a memory leak bug

Will Deacon (1):
      genksyms: Teach parser about 128-bit built-in types

Yoshihiro Shimoda (1):
      phy: renesas: rcar-gen2: Fix memory leak at error paths

YueHaibing (2):
      PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB
      fpga-manager: altera-ps-spi: Fix build error

Yuyang Du (1):
      locking/lockdep: Fix lock used or unused stats error

Zhenzhong Duan (1):
      x86/speculation/mds: Apply more accurate check on hypervisor platform

morten petersen (1):
      mailbox: handle failed named mailbox channel request


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1BXZcACgkQONu9yGCS
aT7lkg//XLQ52xrCKoEJGKUJd4XtRYw4i4qZD+SDeg9Tw2NgJJ91iuvxcMxpMy5C
JkS3uEUxBwQcrqhvUKpx/XBGg7F5BiPun1BiUvLXfeSKPT7IbxaVWWALunreuu1+
b8vUuN1+2JPgR6WCvzHInX/5kiyBNRAQ6UxvHujmr7h/cB0BTs5N/Q+qYByhmJPE
ZQqctQ2/YQdJPK7EBmN4C38cu+kUEi4AHWJEHr+BnXkxDiPzcLKzemhoh5B4wrkd
EW7ZcrjGR2jPttui4e9yPf0gQHwfXI1RzgSjFeeGpXZShnY5Dgj1a8O0j1xWCNr2
ht0YQlHz/kV6wK31be0t+r+qQqVMzgd1kzj1ylCOWCxtpuDt23Lwl+lQa8w34GRn
A42jjbjO2lWduNGyPWtXg/GCd1VXHWxyPHGCTG4wmvXZExt0dMnLWZDpPUZI461x
YLFJitGkoG/4y4rdbOg2n0x4QWrGeqaY2SUNMDDSrWaC6UC0aT1LYstdp7MTAObK
54ll2nWzl4jT+z4by0QUwY4BiNBAPKpWU6UWUNnKVGkzITHl2UJf3IxNlEh2Uae1
WJk2Q+6gv5eW5KN5Bw0R7zS2ZVDe3G+Qha8+iwYgrMeLDpt3ZDO/nwdUs7GqiAeB
nj3Wk0gjGxKN5DBySl6FGWqw4GFKGKSwdoZGTwTsdAhG0NNGjiE=
=Lvs4
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
