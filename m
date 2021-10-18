Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63788431BDD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhJRNfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhJRNeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E4B6139E;
        Mon, 18 Oct 2021 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563804;
        bh=6cTzzP40+2sXUFd13XegT4FdP+0uXRTSkcMBTjWA3cQ=;
        h=From:To:Cc:Subject:Date:From;
        b=plRszu9ZWQ60san+OCH89odzncrXxk0JsYR5J2QACIoxYWVHyT7fZzneDGf9s2Tqg
         Bnk2NHrkNEg208MNdmpztDbvNE6nzfYsEjGjmHgcRmB0WCpE8kibGqUiVseIozo0Nw
         71psnJsAy34zuZEpxIYojj4Rhz7HkWg6mMMM9x1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/69] 5.4.155-rc1 review
Date:   Mon, 18 Oct 2021 15:23:58 +0200
Message-Id: <20211018132329.453964125@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.155-rc1
X-KernelTest-Deadline: 2021-10-20T13:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.155 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.155-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.155-rc1

Shannon Nelson <snelson@pensando.io>
    ionic: don't remove netdev->dev_addr when syncing uc list

Vegard Nossum <vegard.nossum@oracle.com>
    r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

chongjiapeng <jiapeng.chong@linux.alibaba.com>
    qed: Fix missing error code in qed_slowpath_start()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mqprio: Correct stats in mqprio_dump_class_stats().

Jackie Liu <liuyun01@kylinos.cn>
    acpi/arm64: fix next_platform_timer() section mismatch error

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdp5: fix cursor-related warnings

Colin Ian King <colin.king@canonical.com>
    drm/msm: Fix null pointer dereference on pointer edp

Vegard Nossum <vegard.nossum@oracle.com>
    drm/panel: olimex-lcd-olinuxino: select CRC32

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call

Ido Schimmel <idosch@nvidia.com>
    mlxsw: thermal: Fix out-of-bounds memory accesses

Wang Hai <wanghai38@huawei.com>
    ata: ahci_platform: fix null-ptr-deref in ahci_platform_enable_regulators()

Dan Carpenter <dan.carpenter@oracle.com>
    pata_legacy: fix a couple uninitialized variable bugs

Ziyang Xuan <william.xuanziyang@huawei.com>
    NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

Ziyang Xuan <william.xuanziyang@huawei.com>
    NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()

Ziyang Xuan <william.xuanziyang@huawei.com>
    nfc: fix error handling of nfc_proto_register()

Arnd Bergmann <arnd@arndb.de>
    ethernet: s2io: fix setting mac address during resume

Nanyong Sun <sunnanyong@huawei.com>
    net: encx24j600: check error in devm_regmap_init_encx24j600

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: fix get_hw_feature() on old hardware

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Vegard Nossum <vegard.nossum@oracle.com>
    net: korina: select CRC32

Vegard Nossum <vegard.nossum@oracle.com>
    net: arc: select CRC32

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Improve bias setting

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    sctp: account stream padding length for reconf chunk

Dan Carpenter <dan.carpenter@oracle.com>
    iio: dac: ti-dac5571: fix an error code in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

Jiri Valek - 2N <valek@2n.cz>
    iio: light: opt3001: Fixed timeout error when 0 lux

Hui Liu <hui.liu@mediatek.com>
    iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: set driver data when adc probe.

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Discard disabled interrupts in get_irqchip_state()

Borislav Petkov <bp@suse.de>
    x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()

Stephen Boyd <swboyd@chromium.org>
    nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Hans Potsch <hans.potsch@nokia.com>
    EDAC/armada-xp: Fix output of uncorrectable error counter

Halil Pasic <pasic@linux.ibm.com>
    virtio: write back F_VERSION_1 before validate

Tomaz Solc <tomaz.solc@tablix.org>
    USB: serial: option: add prod. id for Quectel EG91

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910Cx composition 0x1204

Yu-Tung Chang <mtwget@gmail.com>
    USB: serial: option: add Quectel EC200S-CN module support

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: qcserial: add EM9191 QDL support

Michael Cullen <michael@michaelcullen.name>
    Input: xpad - add support for another USB ID of Nacon GC-100

Miquel Raynal <miquel.raynal@bootlin.com>
    usb: musb: dsps: Fix the probe error path

Zhang Jianhua <chris.zjh@huawei.com>
    efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

Ard Biesheuvel <ardb@kernel.org>
    efi/cper: use stack buffer for error record decoding

Arnd Bergmann <arnd@arndb.de>
    cb710: avoid NULL pointer subtraction

Nikolay Martynov <mar.kolya@gmail.com>
    xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Pavankumar Kondeti <pkondeti@codeaurora.org>
    xhci: Fix command ring pointer corruption while aborting a command

Jonathan Bell <jonathan@raspberrypi.com>
    xhci: guard accesses to ep_state in xhci_endpoint_reset()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mei: me: add Ice Lake-N device id.

James Morse <james.morse@arm.com>
    x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

Chris Packham <chris.packham@alliedtelesis.co.nz>
    watchdog: orion: use 0 for unset heartbeat

Filipe Manana <fdmanana@suse.com>
    btrfs: check for error when looking up inode during dir entry replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when adding inode reference during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when replaying dir entry during log replay

Qu Wenruo <wqu@suse.com>
    btrfs: unlock newly allocated extent buffer after error

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup regs.sr broken in ptrace

Al Viro <viro@zeniv.linux.org.uk>
    csky: don't let sigreturn play with priveleged bits of status register

Roberto Sassu <roberto.sassu@huawei.com>
    s390: fix strrchr() implementation

Steven Rostedt <rostedt@goodmis.org>
    nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - ALC236 headset MIC recording issue

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Clevo X170KM-G

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Complete partial device name to avoid ambiguity

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix a potential UAF by wrong private_free call order

Jonas Hahnfeld <hahnjo@hahnjo.de>
    ALSA: usb-audio: Add quirk for VF0770

Miklos Szeredi <mszeredi@redhat.com>
    ovl: simplify file splice


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/csky/kernel/ptrace.c                          |  3 +-
 arch/csky/kernel/signal.c                          |  4 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            | 28 ++++++-----
 arch/powerpc/sysdev/xive/common.c                  |  3 +-
 arch/s390/lib/string.c                             | 15 +++---
 arch/x86/Kconfig                                   |  1 -
 arch/x86/kernel/cpu/resctrl/core.c                 |  2 +
 drivers/acpi/arm64/gtdt.c                          |  2 +-
 drivers/ata/libahci_platform.c                     |  5 +-
 drivers/ata/pata_legacy.c                          |  6 ++-
 drivers/edac/armada_xp_edac.c                      |  2 +-
 drivers/firmware/efi/cper.c                        |  4 +-
 drivers/firmware/efi/runtime-wrappers.c            |  2 +-
 drivers/gpio/gpio-pca953x.c                        | 16 +++---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          | 16 ++++++
 drivers/gpu/drm/msm/dsi/dsi.c                      |  4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +-
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |  3 +-
 drivers/gpu/drm/panel/Kconfig                      |  1 +
 drivers/iio/adc/aspeed_adc.c                       |  1 +
 drivers/iio/adc/mt6577_auxadc.c                    |  8 +++
 drivers/iio/adc/ti-adc128s052.c                    |  6 +++
 drivers/iio/common/ssp_sensors/ssp_spi.c           | 11 ++++-
 drivers/iio/dac/ti-dac5571.c                       |  1 +
 drivers/iio/light/opt3001.c                        |  6 +--
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/misc/cb710/sgbuf2.c                        |  2 +-
 drivers/misc/mei/hw-me-regs.h                      |  1 +
 drivers/misc/mei/pci-me.c                          |  1 +
 drivers/net/ethernet/Kconfig                       |  1 +
 drivers/net/ethernet/arc/Kconfig                   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 57 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 52 ++------------------
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 10 +++-
 drivers/net/ethernet/microchip/encx24j600.c        |  5 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |  4 +-
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    | 13 ++++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  6 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  6 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  6 +--
 drivers/net/usb/Kconfig                            |  4 ++
 drivers/nvmem/core.c                               |  3 +-
 drivers/platform/mellanox/mlxreg-io.c              |  2 +-
 drivers/usb/host/xhci-pci.c                        |  2 +
 drivers/usb/host/xhci-ring.c                       | 14 ++++--
 drivers/usb/host/xhci.c                            |  5 ++
 drivers/usb/musb/musb_dsps.c                       |  4 +-
 drivers/usb/serial/option.c                        |  8 +++
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/virtio/virtio.c                            | 11 +++++
 drivers/watchdog/orion_wdt.c                       |  2 +-
 fs/btrfs/extent-tree.c                             |  1 +
 fs/btrfs/tree-log.c                                | 32 ++++++++----
 fs/overlayfs/file.c                                | 46 +----------------
 include/linux/mlx5/mlx5_ifc.h                      | 10 +++-
 net/nfc/af_nfc.c                                   |  3 ++
 net/nfc/digital_core.c                             |  9 +++-
 net/nfc/digital_technology.c                       |  8 ++-
 net/sched/sch_mqprio.c                             | 30 +++++++-----
 net/sctp/sm_make_chunk.c                           |  2 +-
 scripts/recordmcount.pl                            |  2 +-
 sound/core/seq_device.c                            |  8 ++-
 sound/pci/hda/patch_realtek.c                      | 35 ++++++++++++-
 sound/usb/quirks-table.h                           | 42 ++++++++++++++++
 68 files changed, 407 insertions(+), 207 deletions(-)


