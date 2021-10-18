Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BB5431C6C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhJRNkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhJRNjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:39:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DD2F61409;
        Mon, 18 Oct 2021 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563964;
        bh=ogcfhigG7+cIafG8rhx1dh3zb4gfzvo7em1ap1gZ1oQ=;
        h=From:To:Cc:Subject:Date:From;
        b=11BOCLqnjDIwK2GyRh5x615/cAWvtp8orjzU3yjFAqgMGGfluplh62pa7m+BmCGQC
         vvbfTKz2aekoARP/tg2T1P7BNzDr5RS42Uwbdtx9O9GQ81qOSxYvrU9fHWs5sFofhY
         yyJwz/xuL47ms71Cx8Gd9PQThfwqdHpwY6ZpiW2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/103] 5.10.75-rc1 review
Date:   Mon, 18 Oct 2021 15:23:36 +0200
Message-Id: <20211018132334.702559133@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.75-rc1
X-KernelTest-Deadline: 2021-10-20T13:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.75 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.75-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.75-rc1

Maarten Zanders <maarten.zanders@mind.be>
    net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

Shannon Nelson <snelson@pensando.io>
    ionic: don't remove netdev->dev_addr when syncing uc list

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb

Baowen Zheng <baowen.zheng@corigine.com>
    nfp: flow_offload: move flow_indr_dev_register from app init to app start

Vegard Nossum <vegard.nossum@oracle.com>
    r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

chongjiapeng <jiapeng.chong@linux.alibaba.com>
    qed: Fix missing error code in qed_slowpath_start()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mqprio: Correct stats in mqprio_dump_class_stats().

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Fix busy loop expiry time

Jackie Liu <liuyun01@kylinos.cn>
    acpi/arm64: fix next_platform_timer() section mismatch error

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Track current ctx by seqno

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/mdp5: fix cursor-related warnings

Colin Ian King <colin.king@canonical.com>
    drm/msm: Fix null pointer dereference on pointer edp

Douglas Anderson <dianders@chromium.org>
    drm/edid: In connector_bad_edid() cap num_of_ext by num_blocks read

Vegard Nossum <vegard.nossum@oracle.com>
    drm/panel: olimex-lcd-olinuxino: select CRC32

Kamal Dasu <kdasu@broadcom.com>
    spi: bcm-qspi: clear MSPI spifie interrupt during probe

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-io: Fix read access of n-bytes size attributes

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

Cindy Lu <lulu@redhat.com>
    vhost-vdpa: Fix the wrong input in config_cb

Arnd Bergmann <arnd@arndb.de>
    ethernet: s2io: fix setting mac address during resume

Nanyong Sun <sunnanyong@huawei.com>
    net: encx24j600: check error in devm_regmap_init_encx24j600

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: fix get_hw_feature() on old hardware

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Valentine Fatiev <valentinef@nvidia.com>
    net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path

Vegard Nossum <vegard.nossum@oracle.com>
    net: korina: select CRC32

Vegard Nossum <vegard.nossum@oracle.com>
    net: arc: select CRC32

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Improve bias setting

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    sctp: account stream padding length for reconf chunk

Keith Busch <kbusch@kernel.org>
    nvme-pci: Fix abort command id

Nicolas Saenz Julienne <nsaenz@kernel.org>
    ARM: dts: bcm2711-rpi-4-b: Fix pcie0's unit address formatting

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2711-rpi-4-b: fix sd_io_1v8_reg regulator states

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2711: fix MDIO #address- and #size-cells

Nicolas Saenz Julienne <nsaenz@kernel.org>
    ARM: dts: bcm2711-rpi-4-b: Fix usb's unit address

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix missing devices unregister during optee_remove

Dan Carpenter <dan.carpenter@oracle.com>
    iio: dac: ti-dac5571: fix an error code in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Fix the number of max1X31 channels

Jiri Valek - 2N <valek@2n.cz>
    iio: light: opt3001: Fixed timeout error when 0 lux

Hui Liu <hui.liu@mediatek.com>
    iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Fix wrong shift with 12-bit devices

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7793: Fix IRQ flag

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7780: Fix IRQ flag

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7192: Add IRQ flag

Saravana Kannan <saravanak@google.com>
    driver core: Reject pointless SYNC_STATE_ONLY device links

Saravana Kannan <saravanak@google.com>
    drivers: bus: simple-pm-bus: Add support for probing simple bus only devices

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: Add missing lock before accessing find_vma()

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

Johan Hovold <johan@kernel.org>
    USB: xhci: dbc: fix tty registration race

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mei: me: add Ice Lake-N device id.

James Morse <james.morse@arm.com>
    x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix abort logic in btrfs_replace_file_extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: update refs for any root except tree log roots

Filipe Manana <fdmanana@suse.com>
    btrfs: check for error when looking up inode during dir entry replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when adding inode reference during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when replaying dir entry during log replay

Qu Wenruo <wqu@suse.com>
    btrfs: unlock newly allocated extent buffer after error

Marek Vasut <marex@denx.de>
    drm/msm: Avoid potential overflow in timeout_to_jiffies()

Mike Kravetz <mike.kravetz@oracle.com>
    arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup regs.sr broken in ptrace

Al Viro <viro@zeniv.linux.org.uk>
    csky: don't let sigreturn play with priveleged bits of status register

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: agilex: fix duplicate s2f_user0_clk

Roberto Sassu <roberto.sassu@huawei.com>
    s390: fix strrchr() implementation

Steven Rostedt <rostedt@goodmis.org>
    nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW

Cameron Berkenpas <cam@neo-zeon.de>
    ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo 13s Gen2

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang PHxTxX1

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - ALC236 headset MIC recording issue

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Clevo X170KM-G

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Complete partial device name to avoid ambiguity

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda - Enable headphone mic on Dell Latitude laptops with ALC3254

John Liu <johnliu55tw@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output for Dell Precision 5560 laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix a potential UAF by wrong private_free call order

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Workaround for a wrong offset in SYNC_PTR compat ioctl

Jonas Hahnfeld <hahnjo@hahnjo.de>
    ALSA: usb-audio: Add quirk for VF0770


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              | 11 ++--
 arch/arm/boot/dts/bcm2711.dtsi                     |  4 +-
 arch/arm64/mm/hugetlbpage.c                        |  2 +-
 arch/csky/kernel/ptrace.c                          |  3 +-
 arch/csky/kernel/signal.c                          |  4 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            | 28 ++++----
 arch/powerpc/sysdev/xive/common.c                  |  3 +-
 arch/s390/lib/string.c                             | 15 ++---
 arch/x86/Kconfig                                   |  1 -
 arch/x86/kernel/cpu/resctrl/core.c                 |  2 +
 drivers/acpi/arm64/gtdt.c                          |  2 +-
 drivers/ata/libahci_platform.c                     |  5 +-
 drivers/ata/pata_legacy.c                          |  6 +-
 drivers/base/core.c                                |  3 +-
 drivers/bus/simple-pm-bus.c                        | 39 ++++++++++-
 drivers/clk/socfpga/clk-agilex.c                   |  9 ---
 drivers/edac/armada_xp_edac.c                      |  2 +-
 drivers/firmware/efi/cper.c                        |  4 +-
 drivers/firmware/efi/runtime-wrappers.c            |  2 +-
 drivers/gpio/gpio-pca953x.c                        | 16 +++--
 drivers/gpu/drm/drm_edid.c                         | 15 ++++-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              | 11 +++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          | 16 +++++
 drivers/gpu/drm/msm/dsi/dsi.c                      |  4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +-
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |  3 +-
 drivers/gpu/drm/msm/msm_drv.c                      |  3 +
 drivers/gpu/drm/msm/msm_drv.h                      |  5 +-
 drivers/gpu/drm/panel/Kconfig                      |  1 +
 drivers/iio/adc/ad7192.c                           |  1 +
 drivers/iio/adc/ad7780.c                           |  2 +-
 drivers/iio/adc/ad7793.c                           |  2 +-
 drivers/iio/adc/aspeed_adc.c                       |  1 +
 drivers/iio/adc/max1027.c                          |  3 +-
 drivers/iio/adc/mt6577_auxadc.c                    |  8 +++
 drivers/iio/adc/ti-adc128s052.c                    |  6 ++
 drivers/iio/common/ssp_sensors/ssp_spi.c           | 11 +++-
 drivers/iio/dac/ti-dac5571.c                       |  1 +
 drivers/iio/light/opt3001.c                        |  6 +-
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/misc/cb710/sgbuf2.c                        |  2 +-
 drivers/misc/fastrpc.c                             |  2 +
 drivers/misc/mei/hw-me-regs.h                      |  1 +
 drivers/misc/mei/pci-me.c                          |  1 +
 drivers/net/dsa/microchip/ksz_common.c             |  4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   | 13 +++-
 drivers/net/ethernet/Kconfig                       |  1 +
 drivers/net/ethernet/arc/Kconfig                   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 57 ++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 52 ++-------------
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 10 ++-
 drivers/net/ethernet/microchip/encx24j600.c        |  5 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |  4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  6 +-
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c   | 19 ++++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    | 13 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  6 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  6 +-
 drivers/net/usb/Kconfig                            |  4 ++
 drivers/nvme/host/pci.c                            |  2 +-
 drivers/nvmem/core.c                               |  3 +-
 drivers/platform/mellanox/mlxreg-io.c              |  4 +-
 drivers/platform/x86/intel_scu_ipc.c               |  2 +-
 drivers/spi/spi-bcm-qspi.c                         | 77 +++++++++++++---------
 drivers/tee/optee/core.c                           |  3 +
 drivers/tee/optee/device.c                         | 22 +++++++
 drivers/tee/optee/optee_private.h                  |  1 +
 drivers/usb/host/xhci-dbgtty.c                     | 28 ++++----
 drivers/usb/host/xhci-pci.c                        |  2 +
 drivers/usb/host/xhci-ring.c                       | 14 ++--
 drivers/usb/host/xhci.c                            |  5 ++
 drivers/usb/musb/musb_dsps.c                       |  4 +-
 drivers/usb/serial/option.c                        |  8 +++
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/vhost/vdpa.c                               |  2 +-
 drivers/virtio/virtio.c                            | 11 ++++
 fs/btrfs/extent-tree.c                             |  1 +
 fs/btrfs/file.c                                    | 19 +++---
 fs/btrfs/tree-log.c                                | 32 ++++++---
 include/linux/mlx5/mlx5_ifc.h                      | 10 ++-
 net/nfc/af_nfc.c                                   |  3 +
 net/nfc/digital_core.c                             |  9 ++-
 net/nfc/digital_technology.c                       |  8 ++-
 net/sched/sch_mqprio.c                             | 30 +++++----
 net/sctp/sm_make_chunk.c                           |  2 +-
 scripts/recordmcount.pl                            |  2 +-
 sound/core/pcm_compat.c                            | 72 +++++++++++++++++++-
 sound/core/seq_device.c                            |  8 +--
 sound/pci/hda/patch_realtek.c                      | 66 +++++++++++++++++--
 sound/usb/quirks-table.h                           | 42 ++++++++++++
 97 files changed, 722 insertions(+), 272 deletions(-)


