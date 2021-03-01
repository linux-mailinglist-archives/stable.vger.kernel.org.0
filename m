Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E732839A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhCAQWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:22:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237733AbhCAQTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A89564E99;
        Mon,  1 Mar 2021 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615436;
        bh=FCBLtX3chwMRI96sfhNEf8m8xGWzWVep0z4Q8E7Qvw4=;
        h=From:To:Cc:Subject:Date:From;
        b=URK5xJ2QKDCl3N9aqhnpJjVakF0ayJ01LmC58MIcQN/NZSDwjvP/oTCw7fphNVLle
         bCrX3Zy7x1Y1cFz+vKFp5t6ydZPRTeLoMAZsJ3knT3lC/0koSGYJEC5mOXpNibksAI
         OMUWzf4XHL9YvpVCr6DLsOztBprfVonuYSXjVkzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/93] 4.4.259-rc1 review
Date:   Mon,  1 Mar 2021 17:12:12 +0100
Message-Id: <20210301161006.881950696@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.259-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.259-rc1
X-KernelTest-Deadline: 2021-03-03T16:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.259 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.259-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.259-rc1

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Update in-core bitset after committing the metadata

Peter Zijlstra <peterz@infradead.org>
    futex: Fix OWNER_DEAD fixup

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: only resize metadata in preresume

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Reinitialize bitset cache before digesting a new writeset

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Use correct value size in equality function of writeset tree

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Fix bitset memory leaks

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Verify the data block size hasn't changed

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Recover committed writeset after crash

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't skip dlm unlock if glock has an lvb

Al Viro <viro@zeniv.linux.org.uk>
    sparc32: fix a user-triggerable oops in clear_user()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix out-of-repair __setattr_copy()

Maxim Kiselev <bigunclemax@gmail.com>
    gpio: pcf857x: Fix missing first interrupt

Fangrui Song <maskray@google.com>
    module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/dimm: Avoid race between probe and available_slots_show()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix a race between freeing and dissolving the page

Jiri Kosina <jkosina@suse.cz>
    floppy: reintroduce O_NDELAY fix

Sean Christopherson <seanjc@google.com>
    x86/reboot: Force all cpus to exit VMX root if VMX is supported

Martin Kaiser <martin@kaiser.cx>
    staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix migratable=1 failing

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7720: fix error code in mos7720_write()

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7840: fix error code in mos7840_write()

Lech Perczak <lech.perczak@gmail.com>
    USB: serial: option: update interface mapping for ZTE P685M

Marcos Paulo de Souza <mpdesouza@suse.com>
    Input: i8042 - add ASUS Zenbook Flip to noselftest list

Dan Carpenter <dan.carpenter@oracle.com>
    Input: joydev - prevent potential read overflow in ioctl

Olivier Crête <olivier.crete@ocrete.ca>
    Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

Mikulas Patocka <mpatocka@redhat.com>
    blk-settings: align max_sectors on "logical_block_size" boundary

Bart Van Assche <bart.vanassche@wdc.com>
    block: Move SECTOR_SIZE and SECTOR_SHIFT definitions into <linux/blkdev.h>

Randy Dunlap <rdunlap@infradead.org>
    scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Maxime Ripard <maxime@cerno.tech>
    i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential double free in hugetlb_register_node() error path

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory.c: fix potential pte_unmap_unlock pte error

Jann Horn <jannh@google.com>
    Take mmap lock in cacheflush syscall

Heiner Kallweit <hkallweit1@gmail.com>
    PCI: Align checking of syscall user config accessors

Jorgen Hansen <jhansen@vmware.com>
    VMCI: Use set_page_dirty_lock() when unregistering guest memory

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Fix module alias to enable module autoprobe

Randy Dunlap <rdunlap@infradead.org>
    sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set

Dan Carpenter <dan.carpenter@oracle.com>
    Input: elo - fix an error code in elo_connect()

Namhyung Kim <namhyung@kernel.org>
    perf test: Fix unaligned access in sample parsing test

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix missing CYC processing in PSB

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/dlpar: handle ibm, configure-connector delay status

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracepoint: Do not fail unregistering a probe due to memory failure

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    amba: Fix resource leak for drivers without .remove

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/47x: Disable 256k page size

Shay Drory <shayd@nvidia.com>
    IB/umad: Return EIO in case of when device disassociated

Pan Bian <bianpan2016@163.com>
    isofs: release buffer head before return

Pan Bian <bianpan2016@163.com>
    regulator: axp20x: Fix reference cout leak

Tom Rix <trix@redhat.com>
    clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in the remove function

Randy Dunlap <rdunlap@infradead.org>
    HID: core: detect and skip invalid inputs to snto32()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL

Tom Rix <trix@redhat.com>
    jffs2: fix use after free in jffs2_sum_write_data()

Colin Ian King <colin.king@canonical.com>
    fs/jfs: fix potential integer overflow on shift of a int

Zhihao Cheng <chengzhihao1@huawei.com>
    btrfs: clarify error returns values in __load_free_space_cache

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cx25821: Fix a bug when reallocating some dma memory

Joe Perches <joe@perches.com>
    media: lmedm04: Fix misuse of comma

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs42l56: fix up error handling in probe

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: tm6000: Fix memleak in tm6000_start_stream

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: media/pci: Fix memleak in empress_init

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: c-r4k: Fix section mismatch for loongson2_sc_init

Dan Carpenter <dan.carpenter@oracle.com>
    gma500: clean up error handling in init

Jialin Zhang <zhangjialin11@huawei.com>
    drm/gma500: Fix error return code in psb_driver_load()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: aty: SPARC64 requires FB_ATY_CT

Colin Ian King <colin.king@canonical.com>
    b43: N-PHY: Fix the update of coef for the PHY revision >= 3case

Juergen Gross <jgross@suse.com>
    xen/netback: fix spurious event detection for common event case

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: reverse order of TX disable and carrier off

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c: fix fiq for clang IAS

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Make "trimming xfer length" a debug message

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Abort transaction after errors with unknown reason

Pan Bian <bianpan2016@163.com>
    Bluetooth: Put HCI device if inquiry procedure interrupts

Pan Bian <bianpan2016@163.com>
    Bluetooth: drop HCI device reference before return

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Spring

Christopher William Snowhill <chris@kode54.net>
    Bluetooth: Fix initializing response id after clearing struct

Alexander Lobakin <alobakin@pm.me>
    MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Sumit Garg <sumit.garg@linaro.org>
    kdb: Make memory allocations more robust

Rong Chen <rong.a.chen@intel.com>
    scripts/recordmcount.pl: support big endian for ARCH sh

Corinna Vinschen <vinschen@redhat.com>
    igb: Remove incorrect "unexpected SYS WRAP" log message

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: check for valid standard information attribute

David Vrabel <david.vrabel@citrix.com>
    xen-netback: delete NAPI instance when queue fails to initialize

Stefan Ursella <stefan.ursella@wolfvision.net>
    usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Will McVicker <willmcvicker@google.com>
    HID: make arrays usage and value to be the same


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/compressed/head.S                    |  4 +-
 arch/arm/boot/dts/exynos5250-spring.dts            |  2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  2 +-
 arch/mips/kernel/vmlinux.lds.S                     |  1 +
 arch/mips/lantiq/irq.c                             |  2 +-
 arch/mips/mm/c-r4k.c                               |  2 +-
 arch/nios2/kernel/sys_nios2.c                      | 11 ++-
 arch/powerpc/Kconfig                               |  2 +-
 arch/powerpc/platforms/pseries/dlpar.c             |  7 +-
 arch/sparc/Kconfig                                 |  2 +-
 arch/sparc/lib/memset.S                            |  1 +
 arch/x86/kernel/reboot.c                           | 29 +++----
 arch/xtensa/platforms/iss/simdisk.c                |  1 -
 block/blk-settings.c                               | 12 +++
 drivers/amba/bus.c                                 | 20 +++--
 drivers/block/brd.c                                |  1 -
 drivers/block/floppy.c                             | 27 ++++---
 drivers/block/rbd.c                                |  9 ---
 drivers/block/zram/zram_drv.h                      |  1 -
 drivers/clk/meson/clk-pll.c                        |  2 +-
 drivers/clocksource/mxs_timer.c                    |  5 +-
 drivers/dma/fsldma.c                               |  6 ++
 drivers/gpio/gpio-pcf857x.c                        |  2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         | 22 ++---
 drivers/gpu/drm/gma500/psb_drv.c                   |  2 +
 drivers/hid/hid-core.c                             |  9 ++-
 drivers/i2c/busses/i2c-brcmstb.c                   |  2 +-
 drivers/ide/ide-cd.c                               |  8 +-
 drivers/ide/ide-cd.h                               |  6 +-
 drivers/infiniband/core/user_mad.c                 |  7 +-
 drivers/input/joydev.c                             |  7 +-
 drivers/input/joystick/xpad.c                      |  1 +
 drivers/input/serio/i8042-x86ia64io.h              |  4 +
 drivers/input/touchscreen/elo.c                    |  4 +-
 drivers/md/dm-era-target.c                         | 93 ++++++++++++++--------
 drivers/media/pci/cx25821/cx25821-core.c           |  4 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |  5 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  2 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |  4 +
 drivers/media/usb/uvc/uvc_v4l2.c                   | 18 ++---
 drivers/mfd/wm831x-auxadc.c                        |  3 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |  1 +
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |  5 +-
 drivers/mmc/host/usdhi6rol0.c                      |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  3 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  2 -
 drivers/net/wireless/b43/phy_n.c                   |  2 +-
 drivers/net/xen-netback/interface.c                |  9 ++-
 drivers/nvdimm/dimm_devs.c                         | 18 ++++-
 drivers/nvdimm/nd.h                                |  1 -
 drivers/pci/syscall.c                              | 10 +--
 drivers/regulator/axp20x-regulator.c               |  7 +-
 drivers/scsi/bnx2fc/Kconfig                        |  1 +
 drivers/scsi/gdth.h                                |  3 -
 drivers/spi/spi-s3c24xx-fiq.S                      |  9 +--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/dwc2/hcd_intr.c                        | 14 +++-
 drivers/usb/dwc3/gadget.c                          | 19 ++++-
 drivers/usb/renesas_usbhs/fifo.c                   |  2 +
 drivers/usb/serial/mos7720.c                       |  4 +-
 drivers/usb/serial/mos7840.c                       |  4 +-
 drivers/usb/serial/option.c                        |  3 +-
 drivers/video/fbdev/Kconfig                        |  2 +-
 fs/btrfs/free-space-cache.c                        |  6 +-
 fs/btrfs/relocation.c                              |  4 +-
 fs/f2fs/file.c                                     |  3 +-
 fs/gfs2/lock_dlm.c                                 |  8 +-
 fs/isofs/dir.c                                     |  1 +
 fs/isofs/namei.c                                   |  1 +
 fs/jffs2/summary.c                                 |  3 +
 fs/jfs/jfs_dmap.c                                  |  2 +-
 fs/ntfs/inode.c                                    |  6 ++
 include/linux/blkdev.h                             | 42 +++++++---
 include/linux/device-mapper.h                      |  2 -
 include/linux/ide.h                                |  1 -
 include/uapi/linux/msdos_fs.h                      |  2 +
 kernel/debug/kdb/kdb_private.h                     |  2 +-
 kernel/futex.c                                     |  7 +-
 kernel/module.c                                    | 21 ++++-
 kernel/tracepoint.c                                | 80 +++++++++++++++----
 mm/hugetlb.c                                       | 43 +++++++++-
 mm/memory.c                                        |  6 +-
 net/bluetooth/a2mp.c                               |  3 +-
 net/bluetooth/hci_core.c                           |  6 +-
 scripts/recordmcount.pl                            |  6 +-
 security/keys/trusted.c                            |  2 +-
 sound/soc/codecs/cs42l56.c                         |  3 +-
 tools/perf/tests/sample-parsing.c                  |  2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  3 +
 91 files changed, 503 insertions(+), 245 deletions(-)


