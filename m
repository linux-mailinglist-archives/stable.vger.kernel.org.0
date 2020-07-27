Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8B22F210
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgG0OhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730303AbgG0ONF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:13:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 241662173E;
        Mon, 27 Jul 2020 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859183;
        bh=YOGvFtTiNqeJkQER4GSTkwLPGSVpSiZvsKEaO/wyXFk=;
        h=From:To:Cc:Subject:Date:From;
        b=s6hONPf0X82c9r5QUcpGFCyWr5c7IJXZCbxwNsTYNC5EPoUJEUkt2NDXVA5QSYqRb
         bDNi/cgAAM8D8JvGDpKjwV7t+4T1GKhDuCH8SbciUxNUui3+3KlSyLYpBlMXivM5k3
         ep9/WQE30LYPkA6w5n0DdZJveXXn5y7M/DjaON/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/138] 5.4.54-rc1 review
Date:   Mon, 27 Jul 2020 16:03:15 +0200
Message-Id: <20200727134925.228313570@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.54-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.54-rc1
X-KernelTest-Deadline: 2020-07-29T13:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.54 release.
There are 138 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.54-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.54-rc1

Mark O'Donovan <shiftee@posteo.net>
    ath9k: Fix regression with Atheros 9271

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix integrity recalculation that is improperly skipped

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: topology: fix tlvs in error handling for widget_dmixer

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: topology: fix kernel oops on route addition error

Geert Uytterhoeven <geert@linux-m68k.org>
    ASoC: qcom: Drop HAS_DMA dependency to fix link failure

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Add new gpio1_is_ext_spk_en quirk and enable it on the Lenovo Miix 2 10

Joerg Roedel <jroedel@suse.de>
    x86, vmlinux.lds: Page-align end of ..page_aligned sections

John David Anglin <dave.anglin@bell.net>
    parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Qiu Wenbo <qiuwenbo@phytium.com.cn>
    drm/amd/powerplay: fix a crash when overclocking Vega M

Paweł Gronowski <me@woland.xyz>
    drm/amdgpu: Fix NULL dereference in dpm sysfs handlers

Eddie James <eajames@linux.ibm.com>
    mmc: sdhci-of-aspeed: Fix clock divider calculation

Michael J. Ruhl <michael.j.ruhl@intel.com>
    io-mapping: indicate mapping failure

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    khugepaged: fix null-pointer dereference due to race

Muchun Song <songmuchun@bytedance.com>
    mm: memcg/slab: fix memory leak at non-root kmem_cache destroy

Hugh Dickins <hughd@google.com>
    mm/memcg: fix refcount error while moving and swapping

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm/mmap.c: close race between munmap() and expand_upwards()/downwards()

Fangrui Song <maskray@google.com>
    Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    vt: Reject zero-sized screen buffer size.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.

Eric Biggers <ebiggers@google.com>
    /dev/mem: Add missing memory barriers for devmem_inode

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250_mtk: Fix high-speed baud rates clamping

Yang Yingliang <yangyingliang@huawei.com>
    serial: 8250: fix null-ptr-deref in serial8250_start_tx()

Johan Hovold <johan@kernel.org>
    serial: tegra: fix CREAD handling for PIO

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: properly check endpoint types

Helmut Grohne <helmut.grohne@intenta.de>
    tty: xilinx_uartps: Really fix id assignment

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: don't call iwl_mvm_free_inactive_queue() under RCU

Steve French <stfrench@microsoft.com>
    Revert "cifs: Fix the target file was deleted when rename failed."

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASM2142/ASM3142 DMA addressing

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix the failure of bandwidth allocation

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    binder: Don't use mmput() from shrinker function.

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Upgrade smp_mb__after_spinlock() to iorw,iorw

Qi Liu <liuqi115@huawei.com>
    drivers/perf: Prevent forced unbinding of PMU drivers

Will Deacon <will@kernel.org>
    asm-generic/mmiowb: Allow mmiowb_set_pending() when preemptible()

Arnd Bergmann <arnd@arndb.de>
    x86: math-emu: Fix up 'cmp' insn for clang ias

Will Deacon <will@kernel.org>
    arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP

Qi Liu <liuqi115@huawei.com>
    drivers/perf: Fix kernel panic when rmmod PMU modules during perf sampling

PeiSen Hou <pshou@realtek.com.tw>
    ALSA: hda/realtek - fixup for yet another Intel reference board

Cristian Marussi <cristian.marussi@arm.com>
    hwmon: (scmi) Fix potential buffer overflow in scmi_hwmon_probe()

Vasiliy Kupriakov <rublag-ns@yandex.ru>
    platform/x86: asus-wmi: allow BAT1 battery name

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add new PCI device ids

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775) Accept PECI Calibration as temperature source for NCT6798D

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix preemption unit test

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu/gfx10: fix race condition for kiq

Chu Lin <linchuyuan@google.com>
    hwmon: (adm1275) Make sure we are reading enough data for different chips

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: trace: fix some endian issues

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: ep0: fix some endian issues

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Jasper Lake

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Tiger Lake PCH -H variant

Derek Basehore <dbasehore@chromium.org>
    Input: elan_i2c - only increment wakeup count on touch

Ilya Katsnelson <me@0upti.me>
    Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen

Leonid Ravich <Leonid.Ravich@emc.com>
    dmaengine: ioat setting ioat timeout as module parameter

Angelo Dureghello <angelo.dureghello@timesys.com>
    dmaengine: fsl-edma: fix wrong tcd endianness for big-endian cpu

Evgeny Novikov <novikov@ispras.ru>
    hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow

Marc Kleine-Budde <mkl@pengutronix.de>
    regmap: dev_get_regmap_match(): fix string comparison

leilk.liu <leilk.liu@mediatek.com>
    spi: mediatek: use correct SPI_CFG2_REG MACRO

Merlijn Wajer <merlijn@wizzup.org>
    ARM: dts: n900: remove mmc1 card detect gpio

Merlijn Wajer <merlijn@wizzup.org>
    Input: add `SW_MACHINE_COVER`

Dinghao Liu <dinghao.liu@zju.edu.cn>
    dmaengine: tegra210-adma: Fix runtime PM imbalance on error

Hans de Goede <hdegoede@redhat.com>
    HID: apple: Disable Fn-key key-re-mapping on clone keyboards

Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
    HID: steam: fixes race in handling device list.

Caiyuan Xie <caiyuan.xie@cn.alps.com>
    HID: alps: support devices with report id 2

Federico Ricchiuto <fed.ricchiuto@gmail.com>
    HID: i2c-hid: add Mediacom FlexBook edge13 to descriptor override

Stefano Garzarella <sgarzare@redhat.com>
    scripts/gdb: fix lx-symbols 'gdb.error' while loading modules

Pi-Hsun Shih <pihsun@chromium.org>
    scripts/decode_stacktrace: strip basepath from all paths

Matthew Howell <matthew.howell@sealevel.com>
    serial: exar: Fix GPIO configuration for Sealevel cards based on XR17V35X

Cong Wang <xiyou.wangcong@gmail.com>
    geneve: fix an uninitialized value in geneve_changelink()

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: check return value of register_netdevice() in bond_newlink()

Douglas Anderson <dianders@chromium.org>
    i2c: i2c-qcom-geni: Fix DMA transfer race

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: always clear ICSAR to avoid side effects

Claudiu Manoil <claudiu.manoil@nxp.com>
    enetc: Remove the mdio bus on PF probe bailout

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix NULL dereference in nfsd/clients display code

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/PM: Assume ports without DLL Link Active train links in 100 ms"

Wang Hai <wanghai38@huawei.com>
    net: ethernet: ave: Fix error returns in ave_init

guodeqing <geffrey.guo@huawei.com>
    ipvs: fix the connection sync failed in some cases

Alexander Lobakin <alobakin@marvell.com>
    qed: suppress false-positives interrupt error messages on HW init

Alexander Lobakin <alobakin@marvell.com>
    qed: suppress "don't support RoCE & iWARP" flooding on HW init

Taehee Yoo <ap420073@gmail.com>
    netdevsim: fix unbalaced locking in nsim_create()

Helmut Grohne <helmut.grohne@intenta.de>
    net: dsa: microchip: call phy_remove_link_mode during probe

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix error handling for desc filling

Huang Guobin <huangguobin4@huawei.com>
    net: ag71xx: add missed clk_disable_unprepare in error path of probe

Shannon Nelson <snelson@pensando.io>
    ionic: fix up filter locks and debug msgs

Shannon Nelson <snelson@pensando.io>
    ionic: use offset for ethtool regs data

Liu Jian <liujian56@huawei.com>
    mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

Taehee Yoo <ap420073@gmail.com>
    bonding: check error value of register_netdevice() immediately

Wang Hai <wanghai38@huawei.com>
    net: smc91x: Fix possible memory leak in smc_drv_probe()

Chen-Yu Tsai <wens@csie.org>
    drm: sun4i: hdmi: Fix inverted HPD result

Liu Jian <liujian56@huawei.com>
    ieee802154: fix one possible memleak in adf7242_probe

Sergey Organov <sorganov@gmail.com>
    net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

Jing Xiangfeng <jingxiangfeng@huawei.com>
    ASoC: Intel: bytcht_es8316: Add missed put_device()

Maor Gottlieb <maorg@mellanox.com>
    RDMA/mlx5: Use xa_lock_irq when access to SRQ table

George Kennedy <george.kennedy@oracle.com>
    ax88172a: fix ax88172a_unbind() failures

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: annotate 'the_virtio_vsock' RCU pointer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Matthew Gerlach <matthew.gerlach@linux.intel.com>
    fpga: dfl: fix bug in port reset handshake

Xu Yilun <yilun.xu@intel.com>
    fpga: dfl: pci: reduce the scope of variable 'ret'

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix completion ring sizing with TPA enabled.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix race when modifying pause settings.

Robbie Ko <robbieko@synology.com>
    btrfs: fix page leaks after failure to lock page for delalloc

Boris Burkov <boris@bur.io>
    btrfs: fix mount failure caused by race with umount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double free on ulist after backref resolution failure

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Correct RT5670_LDO_SEL_MASK

Takashi Iwai <tiwai@suse.de>
    ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Joonho Wohn <doomsheart@gmail.com>
    ALSA: hda/realtek: Fixed ALC298 sound bug by adding quirk for Samsung Notebook Pen S

Oleg Nesterov <oleg@redhat.com>
    uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: clear DEAD_RELOC_TREE bit for orphan roots to prevent runaway balance

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: fix reloc root leak and NULL pointer dereference

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Ming Lei <ming.lei@redhat.com>
    dm: do not use waitqueue for request-based DM

Gabriel Krisman Bertazi <krisman@collabora.com>
    dm mpath: pass IO start time to path selector

Jerry (Fangzhi) Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Check DMCU Exists Before Loading

Charan Teja Kalla <charante@codeaurora.org>
    dmabuf: use spinlock to access dmabuf->name

Tim Harvey <tharvey@gateworks.com>
    ARM: dts: imx6qdl-gw551x: fix audio SSI

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-gw551x: Do not use 'simple-audio-card,dai-link'

Thomas Gleixner <tglx@linutronix.de>
    irqdomain/treewide: Keep firmware node unconditionally allocated

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix weird page warning

Gavin Shan <gshan@redhat.com>
    drivers/firmware/psci: Fix memory leakage in alloc_init_cpu_groups()

Christoph Hellwig <hch@lst.de>
    dm: use bio_uninit instead of bio_disassociate_blkg

Steve Schremmer <steve.schremmer@netapp.com>
    scsi: dh: Add Fujitsu device to devinfo and dh lists

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    scsi: mpt3sas: Fix error returns in BRM_status_show

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Tom Rix <trix@redhat.com>
    net: sky2: initialize return of gm_phy_read

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix failures at PCM open on Intel ICL and later

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Fixed the value of hard_header_len

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: mpt3sas: Fix unlock imbalance

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: update *pos in cpuinfo_op.next

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix __sync_fetch_and_{and,or}_4 declarations

Tom Rix <trix@redhat.com>
    scsi: scsi_transport_spi: Fix function pointer check

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: allow rx of mesh eapol frames with default rx key

Jacky Hu <hengqing.hu@gmail.com>
    pinctrl: amd: fix npins for uart0 in kerncz_groups

Navid Emamdoost <navid.emamdoost@gmail.com>
    gpio: arizona: put pm_runtime in case of failure

Navid Emamdoost <navid.emamdoost@gmail.com>
    gpio: arizona: handle pm_runtime_get_sync failure case

Douglas Anderson <dianders@chromium.org>
    soc: qcom: rpmh: Dirt can only make you dirtier, not cleaner


-------------

Diffstat:

 Makefile                                           |  6 +-
 arch/arm/boot/dts/imx6qdl-gw551x.dtsi              | 19 ++---
 arch/arm/boot/dts/omap3-n900.dts                   | 12 ++-
 arch/arm64/kernel/debug-monitors.c                 |  4 +-
 arch/mips/pci/pci-xtalk-bridge.c                   |  5 +-
 arch/parisc/include/asm/atomic.h                   |  2 +
 arch/riscv/include/asm/barrier.h                   | 10 ++-
 arch/x86/kernel/apic/io_apic.c                     | 10 +--
 arch/x86/kernel/apic/msi.c                         | 18 +++--
 arch/x86/kernel/apic/vector.c                      |  1 -
 arch/x86/kernel/vmlinux.lds.S                      |  1 +
 arch/x86/math-emu/wm_sqrt.S                        |  2 +-
 arch/x86/platform/uv/uv_irq.c                      |  3 +-
 arch/xtensa/kernel/setup.c                         |  3 +-
 arch/xtensa/kernel/xtensa_ksyms.c                  |  4 +-
 drivers/android/binder_alloc.c                     |  2 +-
 drivers/base/regmap/regmap.c                       |  2 +-
 drivers/char/mem.c                                 | 10 ++-
 drivers/dma-buf/dma-buf.c                          | 11 ++-
 drivers/dma/fsl-edma-common.c                      | 26 ++++---
 drivers/dma/ioat/dma.c                             | 12 +++
 drivers/dma/ioat/dma.h                             |  2 -
 drivers/dma/tegra210-adma.c                        |  5 +-
 drivers/firmware/psci/psci_checker.c               |  5 +-
 drivers/fpga/dfl-afu-main.c                        |  3 +-
 drivers/fpga/dfl-pci.c                             |  3 +-
 drivers/gpio/gpio-arizona.c                        |  7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        | 20 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c             |  9 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  9 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  7 +-
 .../gpu/drm/amd/powerplay/smumgr/vegam_smumgr.c    | 10 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   |  4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |  4 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |  2 +-
 drivers/hid/hid-alps.c                             |  2 +
 drivers/hid/hid-apple.c                            | 18 +++++
 drivers/hid/hid-steam.c                            |  6 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 ++
 drivers/hwmon/aspeed-pwm-tacho.c                   |  2 +
 drivers/hwmon/nct6775.c                            |  6 +-
 drivers/hwmon/pmbus/adm1275.c                      | 10 ++-
 drivers/hwmon/scmi-hwmon.c                         |  2 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  6 +-
 drivers/i2c/busses/i2c-rcar.c                      |  3 +
 drivers/infiniband/hw/mlx5/srq_cmd.c               |  4 +-
 drivers/input/mouse/elan_i2c_core.c                |  9 ++-
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/iommu/amd_iommu.c                          |  5 +-
 drivers/iommu/hyperv-iommu.c                       |  5 +-
 drivers/iommu/intel_irq_remapping.c                |  2 +-
 drivers/md/dm-integrity.c                          |  4 +-
 drivers/md/dm-mpath.c                              |  9 ++-
 drivers/md/dm-path-selector.h                      |  2 +-
 drivers/md/dm-queue-length.c                       |  2 +-
 drivers/md/dm-rq.c                                 |  4 -
 drivers/md/dm-service-time.c                       |  2 +-
 drivers/md/dm.c                                    | 87 ++++++++++++++++------
 drivers/mmc/host/sdhci-of-aspeed.c                 |  2 +-
 drivers/net/bonding/bond_main.c                    | 10 ++-
 drivers/net/bonding/bond_netlink.c                 |  3 +-
 drivers/net/dsa/microchip/ksz9477.c                | 42 ++++++-----
 drivers/net/dsa/microchip/ksz_common.c             |  2 -
 drivers/net/dsa/microchip/ksz_common.h             |  2 -
 drivers/net/ethernet/atheros/ag71xx.c              |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 12 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  5 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 ++
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  3 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  7 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 17 ++---
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |  5 ++
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          | 50 +++++++------
 drivers/net/ethernet/qlogic/qed/qed_int.h          |  4 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  4 +-
 drivers/net/ethernet/socionext/sni_ave.c           |  2 +-
 drivers/net/geneve.c                               |  2 +-
 drivers/net/hippi/rrunner.c                        |  2 +-
 drivers/net/ieee802154/adf7242.c                   |  4 +-
 drivers/net/netdevsim/netdev.c                     |  4 +-
 drivers/net/phy/dp83640.c                          |  4 +
 drivers/net/usb/ax88172a.c                         |  1 +
 drivers/net/wan/lapbether.c                        |  9 ++-
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 52 ++++++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h           |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  8 +-
 drivers/pci/controller/vmd.c                       |  5 +-
 drivers/pci/pci.c                                  | 30 +++-----
 drivers/perf/arm-cci.c                             |  1 +
 drivers/perf/arm-ccn.c                             |  1 +
 drivers/perf/arm_dsu_pmu.c                         |  1 +
 drivers/perf/arm_smmuv3_pmu.c                      |  2 +
 drivers/perf/arm_spe_pmu.c                         |  1 +
 drivers/perf/fsl_imx8_ddr_perf.c                   |  2 +
 drivers/perf/hisilicon/hisi_uncore_ddrc_pmu.c      |  2 +
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c       |  2 +
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c       |  2 +
 drivers/perf/qcom_l2_pmu.c                         |  1 +
 drivers/perf/qcom_l3_pmu.c                         |  1 +
 drivers/perf/thunderx2_pmu.c                       |  1 +
 drivers/perf/xgene_pmu.c                           |  1 +
 drivers/pinctrl/pinctrl-amd.h                      |  2 +-
 drivers/platform/x86/asus-wmi.c                    |  1 +
 .../x86/intel_speed_select_if/isst_if_common.h     |  3 +
 .../x86/intel_speed_select_if/isst_if_mbox_pci.c   |  1 +
 .../x86/intel_speed_select_if/isst_if_mmio.c       |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 | 12 +--
 drivers/scsi/scsi_devinfo.c                        |  1 +
 drivers/scsi/scsi_dh.c                             |  1 +
 drivers/scsi/scsi_transport_spi.c                  |  2 +-
 drivers/soc/qcom/rpmh.c                            |  8 +-
 drivers/spi/spi-mt65xx.c                           | 15 ++--
 drivers/staging/comedi/drivers/addi_apci_1032.c    | 20 +++--
 drivers/staging/comedi/drivers/addi_apci_1500.c    | 24 ++++--
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 20 +++--
 drivers/staging/comedi/drivers/ni_6527.c           |  2 +-
 drivers/staging/wlan-ng/prism2usb.c                | 16 +++-
 drivers/tty/serial/8250/8250_core.c                |  2 +-
 drivers/tty/serial/8250/8250_exar.c                | 12 ++-
 drivers/tty/serial/8250/8250_mtk.c                 | 18 +++++
 drivers/tty/serial/serial-tegra.c                  |  7 +-
 drivers/tty/serial/xilinx_uartps.c                 |  8 +-
 drivers/tty/vt/vt.c                                | 29 +++++---
 drivers/usb/cdns3/ep0.c                            | 30 ++++----
 drivers/usb/cdns3/trace.h                          |  6 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  8 ++
 drivers/usb/gadget/udc/gr_udc.c                    |  7 +-
 drivers/usb/host/xhci-mtk-sch.c                    |  4 +
 drivers/usb/host/xhci-pci.c                        |  3 +
 drivers/video/fbdev/core/bitblit.c                 |  4 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |  4 +-
 drivers/video/fbdev/core/fbcon_cw.c                |  4 +-
 drivers/video/fbdev/core/fbcon_ud.c                |  4 +-
 fs/btrfs/backref.c                                 |  1 +
 fs/btrfs/extent_io.c                               |  3 +-
 fs/btrfs/relocation.c                              | 11 ++-
 fs/btrfs/volumes.c                                 |  8 ++
 fs/cifs/inode.c                                    | 10 +--
 fs/fuse/dev.c                                      |  3 +-
 fs/nfs/direct.c                                    | 13 +---
 fs/nfs/file.c                                      |  1 -
 fs/nfsd/nfs4state.c                                | 20 ++++-
 include/asm-generic/mmiowb.h                       |  6 +-
 include/asm-generic/vmlinux.lds.h                  |  5 +-
 include/linux/device-mapper.h                      |  3 +
 include/linux/dma-buf.h                            |  1 +
 include/linux/io-mapping.h                         |  5 +-
 include/linux/mod_devicetable.h                    |  2 +-
 include/sound/rt5670.h                             |  1 +
 include/uapi/linux/input-event-codes.h             |  3 +-
 kernel/events/uprobes.c                            |  2 +-
 mm/khugepaged.c                                    |  3 +
 mm/memcontrol.c                                    |  4 +-
 mm/mmap.c                                          | 16 +++-
 mm/slab_common.c                                   | 35 +++++++--
 net/mac80211/rx.c                                  | 26 +++++++
 net/netfilter/ipvs/ip_vs_sync.c                    | 12 ++-
 net/vmw_vsock/virtio_transport.c                   |  2 +-
 scripts/decode_stacktrace.sh                       |  4 +-
 scripts/gdb/linux/symbols.py                       |  2 +-
 sound/core/info.c                                  |  4 +-
 sound/pci/hda/patch_hdmi.c                         | 36 +++++----
 sound/pci/hda/patch_realtek.c                      |  2 +
 sound/soc/codecs/rt5670.c                          | 71 ++++++++++++++----
 sound/soc/codecs/rt5670.h                          |  2 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  4 +-
 sound/soc/qcom/Kconfig                             |  2 +-
 sound/soc/soc-topology.c                           | 24 ++++--
 173 files changed, 975 insertions(+), 438 deletions(-)


