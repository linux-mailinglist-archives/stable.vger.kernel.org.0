Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEB879849
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfG2Tkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389230AbfG2Tkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:40:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56F3F206DD;
        Mon, 29 Jul 2019 19:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429249;
        bh=bgdC2LwUwCrrNCVIicOP0wcu4yM5gueLPQe4toJx7V0=;
        h=From:To:Cc:Subject:Date:From;
        b=wPWZoAKYxvKy8Tvw5q//rj2qqiDkO/mZImv7VsIgS7mNUnlDAIaK3SXSGM307n/I7
         0SWhrgPM6RAWPQwvDgEvebL4dJAqnWj9nIRw1hhZygEqh6v/C4gMUWJth5HmKszmkY
         jVqu9DgvgBdzRdgo8zRrOTfdH/yY9bzoRPWs0Bnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/113] 4.19.63-stable review
Date:   Mon, 29 Jul 2019 21:21:27 +0200
Message-Id: <20190729190655.455345569@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.63-rc1
X-KernelTest-Deadline: 2019-07-31T19:07+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.63 release.
There are 113 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.63-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    access: avoid the RCU grace period for the temporary subjective credentials

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix oops on sigreturn on systems without TM

Gautham R. Shenoy <ego@linux.vnet.ibm.com>
    powerpc/xive: Fix loop exit-condition in xive_find_target_in_mask()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add a conexant codec entry to let mute led work

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1

Ding Xiang <dingxiang@cmss.chinamobile.com>
    ALSA: ac97: Fix double free of ac97_codec_device

Kefeng Wang <wangkefeng.wang@huawei.com>
    hpet: Fix division by zero in hpet_time_div()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add mule creek canyon (EHL) device ids

YueHaibing <yuehaibing@huawei.com>
    fpga-manager: altera-ps-spi: Fix build error

Hridya Valsaraju <hridya@google.com>
    binder: prevent transactions to context manager from its own process.

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86/speculation/mds: Apply more accurate check on hypervisor platform

Hans de Goede <hdegoede@redhat.com>
    x86/sysfb_efi: Add quirks for some devices with swapped width and height

Qu Wenruo <wqu@suse.com>
    btrfs: inode: Don't compress if NODATASUM or NODATACOW set

Ryan Kennedy <ryan5544@gmail.com>
    usb: pci-quirks: Correct AMD PLL quirk detection

Phong Tran <tranmanphong@gmail.com>
    usb: wusbcore: fix unbalanced get/put cluster_id

Arnd Bergmann <arnd@arndb.de>
    locking/lockdep: Hide unused 'class' variable

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm: use down_read_killable for locking mmap_sem in access_remote_vm

Yuyang Du <duyuyang@gmail.com>
    locking/lockdep: Fix lock used or unused stats error

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/maps

Arnd Bergmann <arnd@arndb.de>
    cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/map_files

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/clear_refs

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/pagemap

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    proc: use down_read_killable mmap_sem for /proc/pid/smaps_rollup

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    mm/mmu_notifier: use hlist_add_head_rcu()

Shakeel Butt <shakeelb@google.com>
    memcg, fsnotify: no oom-kill for remote memcg charging

Andy Lutomirski <luto@kernel.org>
    mm/gup.c: remove some BUG_ONs from get_gate_page()

Guenter Roeck <linux@roeck-us.net>
    mm/gup.c: mark undo_dev_pagemap as __maybe_unused

Christoph Hellwig <hch@lst.de>
    9p: pass the correct prototype to read_cache_page

Dmitry Vyukov <dvyukov@google.com>
    mm/kmemleak.c: fix check for softirq context

Sam Ravnborg <sam@ravnborg.org>
    sh: prevent warnings when using iounmap

Wenwen Wang <wenwen@cs.uga.edu>
    block/bio-integrity: fix a memory leak bug

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Handle hugepages in ioremap space

David Windsor <dwindsor@redhat.com>
    dlm: check if workqueues are NULL before flushing/destroying

morten petersen <morten_bp@live.dk>
    mailbox: handle failed named mailbox channel request

Ocean Chen <oceanchen@google.com>
    f2fs: avoid out-of-range memory access

Josef Bacik <josef@toxicpanda.com>
    block: init flush rq ref count to 1

Masahiro Yamada <yamada.masahiro@socionext.com>
    powerpc/boot: add {get, put}_unaligned_be32 to xz_config.h

YueHaibing <yuehaibing@huawei.com>
    PCI: dwc: pci-dra7xx: Fix compilation when !CONFIG_GPIOLIB

Konstantin Taranov <konstantin.taranov@inf.ethz.ch>
    RDMA/rxe: Fill in wc byte_len with IB_WC_RECV_RDMA_WITH_IMM

Leo Yan <leo.yan@linaro.org>
    perf hists browser: Fix potential NULL pointer dereference found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf annotate: Fix dereferencing freed memory found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf session: Fix potential NULL pointer dereference found by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf top: Fix potential NULL pointer dereference detected by the smatch tool

Leo Yan <leo.yan@linaro.org>
    perf stat: Fix use-after-freed pointer detected by the smatch tool

Numfor Mbiziwo-Tiapo <nums@google.com>
    perf test mmap-thread-lookup: Initialize variable to suppress memory sanitizer warning

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Use the 1st inbound window for MEM inbound transactions

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Initialize Primary/Secondary/Subordinate bus numbers

Vasily Gorbik <gor@linux.ibm.com>
    kallsyms: exclude kasan local symbols on s390

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix the Class Code field

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows

James Morse <james.morse@arm.com>
    arm64: assembler: Switch ESB-instruction with a vanilla nop if !ARM64_HAS_RAS

Valentine Fatiev <valentinef@mellanox.com>
    IB/ipoib: Add child to parent list only if device initialized

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Handle page table allocation failures

Parav Pandit <parav@mellanox.com>
    IB/mlx5: Fixed reporting counters on 2nd port for Dual port RoCE

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix TX DMA buffer flushing and workqueue races

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Terminate TX DMA during buffer flushing

Liu, Changcheng <changcheng.liu@intel.com>
    RDMA/i40iw: Set queue pair state when being queried

Christian Lamparter <chunkeey@gmail.com>
    powerpc/4xx/uic: clear pending interrupt after irq type/pol change

Johannes Berg <johannes.berg@intel.com>
    um: Silence lockdep complaint about mmap_sem

Ira Weiny <ira.weiny@intel.com>
    mm/swap: fix release_pages() when releasing devmap pages

Axel Lin <axel.lin@ingics.com>
    mfd: hi655x-pmic: Fix missing return value check for devm_regmap_init_mmio_clk

Arnd Bergmann <arnd@arndb.de>
    mfd: arizona: Fix undefined behavior

Robert Hancock <hancock@sedsystems.ca>
    mfd: core: Set fwnode for created devices

Daniel Gomez <dagmcr@gmail.com>
    mfd: madera: Add missing of table registration

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    recordmcount: Fix spurious mcount entries on powerpc

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/xmon: Fix disabling tracing while in xmon

Qian Cai <cai@lca.pw>
    powerpc/cacheflush: fix variable set but not used

Bastien Nocera <hadess@hadess.net>
    iio: iio-utils: Fix possible incorrect mask calculation

Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
    PCI: xilinx-nwl: Fix Multi MSI data programming

Will Deacon <will.deacon@arm.com>
    genksyms: Teach parser about 128-bit built-in types

Nathan Chancellor <natechancellor@gmail.com>
    kbuild: Add -Werror=unknown-warning-option to CLANG_FLAGS

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix the get_irq error cases

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: sysfs: Ignore lockdep for remove attribute

Stefan Roese <sr@denx.de>
    serial: mctrl_gpio: Check if GPIO property exisits before requesting it

Sean Paul <seanpaul@chromium.org>
    drm/msm: Depopulate platform on probe failure

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Fix OF flags parsing for 64bit BARs

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci: sdhci-pci-o2micro: Check if controller supports 8-bit width

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    usb: gadget: Zero ffs_io_data

Serge Semin <fancer.lancer@gmail.com>
    tty: serial_core: Set port active bit in uart_port_activate

Sergey Organov <sorganov@gmail.com>
    serial: imx: fix locking in set_termios()

Douglas Anderson <dianders@chromium.org>
    drm/rockchip: Properly adjust to a true clock in adjusted_mode

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: prevent cpu hotplug during DT update

Hariprasad Kelam <hariprasad.kelam@gmail.com>
    drm/amd/display: fix compilation error

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen2: Fix memory leak at error paths

David Riley <davidriley@chromium.org>
    drm/virtio: Add memory barriers for capset cache.

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Always allocate initial connector state state

Rautkoski Kimmo EXT <ext-kimmo.rautkoski@vaisala.com>
    serial: 8250: Fix TX interrupt handling condition

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: avoid system lockup condition

Kefeng Wang <wangkefeng.wang@huawei.com>
    tty/serial: digicolor: Fix digicolor-usart already registered warning

Wang Hai <wanghai26@huawei.com>
    memstick: Fix error cleanup path of memstick_init

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: Also sprinkle irqrestore over early exits

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/crc-debugfs: User irqsafe spinlock in drm_crtc_add_crc_entry

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Increase maximum DMA segment size

Jyri Sarha <jsarha@ti.com>
    drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tc358767: read display_props in get_modes()

Alex Williamson <alex.williamson@redhat.com>
    PCI: Return error if cannot probe VF

Gen Zhang <blackgod016574@gmail.com>
    drm/edid: Fix a missing-check bug in drm_load_edid_firmware()

Oak Zeng <Oak.Zeng@amd.com>
    drm/amdkfd: Fix sdma queue map issue

Oak Zeng <ozeng@amd.com>
    drm/amdkfd: Fix a potential memory leak

Paul Hsieh <paul.hsieh@amd.com>
    drm/amd/display: Disable ABM before destroy ABM struct

Tiecheng Zhou <Tiecheng.Zhou@amd.com>
    drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fill prescale_params->scale for RGB565

Christophe Leroy <christophe.leroy@c-s.fr>
    tty: serial: cpm_uart - fix init when SMC is relocated

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: rockchip: fix leaked of_node references

Serge Semin <fancer.lancer@gmail.com>
    tty: max310x: Fix invalid baudrate divisors calculator

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: core: hub: Disable hub-initiated U1/U2

Quentin Deslandes <quentin.deslandes@itdev.co.uk>
    staging: vt6656: use meaningful error code during buffer allocation

Fabien Dessenne <fabien.dessenne@st.com>
    iio: adc: stm32-dfsdm: missing error case during probe

Fabien Dessenne <fabien.dessenne@st.com>
    iio: adc: stm32-dfsdm: manage the get_irq error case

Peter Ujfalusi <peter.ujfalusi@ti.com>
    drm/panel: simple: Fix panel_simple_dsi_probe

Sunil Muthuswamy <sunilmut@microsoft.com>
    hvsock: fix epollout hang from race condition


-------------

Diffstat:

 Makefile                                           |  5 +-
 arch/arm64/include/asm/assembler.h                 |  4 +
 arch/powerpc/boot/xz_config.h                      | 20 +++++
 arch/powerpc/include/asm/cacheflush.h              |  7 +-
 arch/powerpc/kernel/eeh.c                          | 15 +++-
 arch/powerpc/kernel/pci_of_scan.c                  |  2 +
 arch/powerpc/kernel/signal_32.c                    |  3 +
 arch/powerpc/kernel/signal_64.c                    |  5 ++
 arch/powerpc/mm/hugetlbpage.c                      |  8 ++
 arch/powerpc/platforms/4xx/uic.c                   |  1 +
 arch/powerpc/platforms/pseries/mobility.c          |  9 ++
 arch/powerpc/sysdev/xive/common.c                  |  7 +-
 arch/powerpc/xmon/xmon.c                           |  6 +-
 arch/sh/include/asm/io.h                           |  6 +-
 arch/um/include/asm/mmu_context.h                  |  2 +-
 arch/x86/kernel/cpu/bugs.c                         |  2 +-
 arch/x86/kernel/sysfb_efi.c                        | 46 +++++++++++
 block/bio-integrity.c                              |  8 +-
 block/blk-core.c                                   |  1 +
 drivers/android/binder.c                           |  2 +-
 drivers/char/hpet.c                                |  3 +-
 drivers/fpga/Kconfig                               |  1 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  3 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 21 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |  5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 10 ++-
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |  2 +
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |  3 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  1 +
 drivers/gpu/drm/bridge/sii902x.c                   |  5 +-
 drivers/gpu/drm/bridge/tc358767.c                  |  7 ++
 drivers/gpu/drm/drm_debugfs_crc.c                  |  9 +-
 drivers/gpu/drm/drm_edid_load.c                    |  2 +
 drivers/gpu/drm/msm/msm_drv.c                      | 14 +++-
 drivers/gpu/drm/panel/panel-simple.c               |  9 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |  3 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  3 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |  2 +
 drivers/gpu/host1x/bus.c                           |  3 +
 drivers/i2c/busses/i2c-stm32f7.c                   | 26 +++---
 drivers/iio/adc/stm32-dfsdm-adc.c                  |  6 ++
 drivers/iio/adc/stm32-dfsdm-core.c                 |  8 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          |  2 +
 drivers/infiniband/hw/mlx5/mad.c                   | 60 ++++++++------
 drivers/infiniband/sw/rxe/rxe_resp.c               |  5 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 34 ++++----
 drivers/mailbox/mailbox.c                          |  6 +-
 drivers/memstick/core/memstick.c                   | 13 ++-
 drivers/mfd/arizona-core.c                         |  2 +-
 drivers/mfd/hi655x-pmic.c                          |  2 +
 drivers/mfd/madera-core.c                          |  1 +
 drivers/mfd/mfd-core.c                             |  1 +
 drivers/misc/mei/hw-me-regs.h                      |  3 +
 drivers/misc/mei/pci-me.c                          |  3 +
 drivers/mmc/host/sdhci-pci-o2micro.c               | 12 ++-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     | 19 +++--
 drivers/nvdimm/bus.c                               | 96 +++++++++++++---------
 drivers/nvdimm/nd-core.h                           |  3 +-
 drivers/pci/controller/dwc/pci-dra7xx.c            |  1 +
 drivers/pci/controller/pcie-mobiveil.c             | 22 +++--
 drivers/pci/controller/pcie-xilinx-nwl.c           | 11 ++-
 drivers/pci/pci-driver.c                           | 13 +--
 drivers/pci/pci-sysfs.c                            |  2 +-
 drivers/phy/renesas/phy-rcar-gen2.c                |  2 +
 drivers/pinctrl/pinctrl-rockchip.c                 |  1 +
 drivers/staging/vt6656/main_usb.c                  | 42 ++++++----
 drivers/tty/serial/8250/8250_port.c                |  3 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        | 17 ++--
 drivers/tty/serial/digicolor-usart.c               |  6 +-
 drivers/tty/serial/imx.c                           | 23 +++---
 drivers/tty/serial/max310x.c                       | 51 +++++++-----
 drivers/tty/serial/msm_serial.c                    |  4 +
 drivers/tty/serial/serial_core.c                   |  7 +-
 drivers/tty/serial/serial_mctrl_gpio.c             | 14 ++++
 drivers/tty/serial/sh-sci.c                        | 33 ++++++--
 drivers/usb/core/hub.c                             | 28 ++++---
 drivers/usb/gadget/function/f_fs.c                 |  6 +-
 drivers/usb/host/hwa-hc.c                          |  2 +-
 drivers/usb/host/pci-quirks.c                      | 31 ++++---
 fs/9p/vfs_addr.c                                   |  6 +-
 fs/btrfs/inode.c                                   | 24 +++++-
 fs/dlm/lowcomms.c                                  | 18 ++--
 fs/f2fs/segment.c                                  |  5 ++
 fs/notify/fanotify/fanotify.c                      |  5 +-
 fs/notify/inotify/inotify_fsnotify.c               |  8 +-
 fs/open.c                                          | 19 +++++
 fs/proc/base.c                                     | 28 +++++--
 fs/proc/task_mmu.c                                 | 23 ++++--
 fs/proc/task_nommu.c                               |  6 +-
 include/linux/cred.h                               |  7 +-
 include/linux/host1x.h                             |  2 +
 kernel/cred.c                                      | 21 ++++-
 kernel/locking/lockdep_proc.c                      |  8 +-
 mm/gup.c                                           | 12 ++-
 mm/kmemleak.c                                      |  2 +-
 mm/memory.c                                        |  4 +-
 mm/mmu_notifier.c                                  |  2 +-
 mm/nommu.c                                         |  3 +-
 mm/swap.c                                          | 13 ++-
 net/vmw_vsock/hyperv_transport.c                   | 44 +++-------
 scripts/genksyms/keywords.c                        |  4 +
 scripts/genksyms/parse.y                           |  2 +
 scripts/kallsyms.c                                 |  3 +
 scripts/recordmcount.h                             |  3 +-
 sound/ac97/bus.c                                   | 13 +--
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/usb/line6/podhd.c                            |  2 +-
 tools/iio/iio_utils.c                              |  4 +-
 tools/perf/builtin-stat.c                          |  2 +-
 tools/perf/builtin-top.c                           |  8 +-
 tools/perf/tests/mmap-thread-lookup.c              |  2 +-
 tools/perf/ui/browsers/hists.c                     | 15 +++-
 tools/perf/util/annotate.c                         |  6 +-
 tools/perf/util/session.c                          |  3 +
 115 files changed, 856 insertions(+), 359 deletions(-)


