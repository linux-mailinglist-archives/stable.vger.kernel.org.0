Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5AF432E4A
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhJSGaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhJSGaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345F1610A1;
        Tue, 19 Oct 2021 06:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634624919;
        bh=iLpzzCKqanbW3Hs5KR8NyEvZ/A8fLe6SAY2t6dD9eZ4=;
        h=From:To:Cc:Subject:Date:From;
        b=xy8LJF67dFNJ1jjo1VDp1sJuXhQDya81iEh3TNyGxw7g4vTxGyZ+TbX26SPsRysYv
         Vw2NB245JgkouSfns7gGflWia4F2lBCu8ROvy1x4pWiYhbRXEgEaUJB7TfLuwcZB4E
         yZszryVisAuA2tPKcpJBxfdVok30BV1psJurV69U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 000/151] 5.14.14-rc2 review
Date:   Tue, 19 Oct 2021 08:28:35 +0200
Message-Id: <20211019061402.629202866@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.14-rc2
X-KernelTest-Deadline: 2021-10-21T06:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.14 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Oct 2021 06:13:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.14-rc2

Shannon Nelson <snelson@pensando.io>
    ionic: don't remove netdev->dev_addr when syncing uc list

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: break at first CPU port during init and teardown

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: deny TX timestamping of non-PTP packets

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: make use of all 63 PTP timestamp identifiers

Baowen Zheng <baowen.zheng@corigine.com>
    nfp: flow_offload: move flow_indr_dev_register from app init to app start

Dan Carpenter <dan.carpenter@oracle.com>
    block/rnbd-clt-sysfs: fix a couple uninitialized variable bugs

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix locking for Tx timestamp tracking flush

Vegard Nossum <vegard.nossum@oracle.com>
    r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

chongjiapeng <jiapeng.chong@linux.alibaba.com>
    qed: Fix missing error code in qed_slowpath_start()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix possible stall on recvmsg()

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

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: dsi_phy_14nm: Take ready-bit into account in poll_for_ready

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/a3xx: fix error handling in a3xx_gpu_init()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/a4xx: fix error handling in a4xx_gpu_init()

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Track current ctx by seqno

Arnd Bergmann <arnd@arndb.de>
    drm/msm/submit: fix overflow check on 64-bit architectures

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

Mark Brown <broonie@kernel.org>
    spi: spidev: Add SPI ID table

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

Alvin Šipraga <alsi@bang-olufsen.dk>
    net: dsa: fix spurious error message when unoffloaded port leaves bridge

Arun Ramadoss <arun.ramadoss@microchip.com>
    net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work

Maarten Zanders <maarten.zanders@mind.be>
    net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Do not shutdown PHYs in READY state

Herve Codina <herve.codina@bootlin.com>
    net: stmmac: fix get_hw_feature() on old hardware

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Switchdev representors are not vlan challenged

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Valentine Fatiev <valentinef@nvidia.com>
    net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: improved fix wait on already cleared link

Vegard Nossum <vegard.nossum@oracle.com>
    net: korina: select CRC32

Vegard Nossum <vegard.nossum@oracle.com>
    net: arc: select CRC32

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Improve bias setting

Mark Brown <broonie@kernel.org>
    gpio: 74x164: Add SPI device ID table

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    sctp: account stream padding length for reconf chunk

Keith Busch <kbusch@kernel.org>
    nvme-pci: Fix abort command id

Biju Das <biju.das.jz@bp.renesas.com>
    clk: renesas: rzg2l: Fix clk status function

Nicolas Saenz Julienne <nsaenz@kernel.org>
    ARM: dts: bcm2711-rpi-4-b: Fix pcie0's unit address formatting

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2711-rpi-4-b: fix sd_io_1v8_reg regulator states

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Add missing remove callback to ffa_bus_type

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Fix __ffa_devices_unregister

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2711: fix MDIO #address- and #size-cells

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    ARM: dts: bcm283x: Fix VEC address for BCM2711

Nicolas Saenz Julienne <nsaenz@kernel.org>
    ARM: dts: bcm2711-rpi-4-b: Fix usb's unit address

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix missing devices unregister during optee_remove

Jackie Liu <liuyun01@kylinos.cn>
    tracing: Fix missing osnoise tracer on max_latency

Dan Carpenter <dan.carpenter@oracle.com>
    iio: dac: ti-dac5571: fix an error code in probe()

Mark Brown <broonie@kernel.org>
    fpga: ice40-spi: Add SPI device ID table

Mark Brown <broonie@kernel.org>
    eeprom: at25: Add SPI ID table

Arnd Bergmann <arnd@arndb.de>
    eeprom: 93xx46: fix MODULE_DEVICE_TABLE

Mark Brown <broonie@kernel.org>
    eeprom: 93xx46: Add SPI device ID table

Oleksij Rempel <linux@rempel-privat.de>
    Input: resistive-adc-touch - fix division by zero error on z1 == 0

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Fix the number of max1X31 channels

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed

Jiri Valek - 2N <valek@2n.cz>
    iio: light: opt3001: Fixed timeout error when 0 lux

Hui Liu <hui.liu@mediatek.com>
    iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

Nuno Sá <nuno.sa@analog.com>
    iio: adis16475: fix deadlock on frequency set

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: adc: max1027: Fix wrong shift with 12-bit devices

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: fix devices that do not support sleep mode

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

Borislav Petkov <bp@suse.de>
    x86/fpu: Mask out the invalid MXCSR bits properly

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()

Michael S. Tsirkin <mst@redhat.com>
    Revert "virtio-blk: Add validation for block size in config space"

Max Gurtovoy <mgurtovoy@nvidia.com>
    virtio-blk: remove unneeded "likely" statements

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

Jonathan Bell <jonathan@raspberrypi.org>
    xhci: add quirk for host controllers that don't update endpoint DCS

Jonathan Bell <jonathan@raspberrypi.com>
    xhci: guard accesses to ep_state in xhci_endpoint_reset()

Johan Hovold <johan@kernel.org>
    USB: xhci: dbc: fix tty registration race

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: hbm: drop hbm responses on early shutdown

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mei: me: add Ice Lake-N device id.

James Morse <james.morse@arm.com>
    x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

Arnd Bergmann <arnd@arndb.de>
    module: fix clang CFI with MODULE_UNLOAD=n

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

Fabio Estevam <festevam@gmail.com>
    drm/msm: Do not run snapshot on non-DPU devices

Marek Vasut <marex@denx.de>
    drm/nouveau/fifo: Reinstate the correct engine bit programming

Mike Kravetz <mike.kravetz@oracle.com>
    arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fbdev: Clamp fbdev surface size if too large

Guo Ren <guoren@linux.alibaba.com>
    csky: Fixup regs.sr broken in ptrace

Al Viro <viro@zeniv.linux.org.uk>
    csky: don't let sigreturn play with priveleged bits of status register

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: agilex: fix duplicate s2f_user0_clk

Roberto Sassu <roberto.sassu@huawei.com>
    s390: fix strrchr() implementation

Ming Lei <ming.lei@redhat.com>
    dm rq: don't queue request to blk-mq during DM suspend

Sachi King <nakato@nakato.io>
    ACPI: PM: Include alternate AMDI0005 id in special behaviour

Jiazi Li <jqqlijiazi@gmail.com>
    dm: fix mempool NULL pointer race when completing IO

Steven Rostedt <rostedt@goodmis.org>
    nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Md Sadre Alam <mdalam@codeaurora.org>
    mtd: rawnand: qcom: Update code word value for raw read

Ville Baillie <villeb@bytesnap.co.uk>
    spi: atmel: Fix PDC transfer setup bug

Sachi King <nakato@nakato.io>
    platform/x86: amd-pmc: Add alternative acpi id for PMC controller

Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
    platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE AX V2

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
    ALSA: usb-audio: Fix a missing error check in scarlett gen2 mixer

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Workaround for a wrong offset in SYNC_PTR compat ioctl

Jonas Hahnfeld <hahnjo@hahnjo.de>
    ALSA: usb-audio: Add quirk for VF0770


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts              | 11 +--
 arch/arm/boot/dts/bcm2711.dtsi                     | 12 ++-
 arch/arm/boot/dts/bcm2835-common.dtsi              |  8 ++
 arch/arm/boot/dts/bcm283x.dtsi                     |  8 --
 arch/arm64/mm/hugetlbpage.c                        |  2 +-
 arch/csky/kernel/ptrace.c                          |  3 +-
 arch/csky/kernel/signal.c                          |  4 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            | 28 ++++---
 arch/powerpc/sysdev/xive/common.c                  |  3 +-
 arch/s390/lib/string.c                             | 15 ++--
 arch/x86/Kconfig                                   |  1 -
 arch/x86/kernel/cpu/resctrl/core.c                 |  2 +
 arch/x86/kernel/fpu/signal.c                       |  2 +-
 drivers/acpi/arm64/gtdt.c                          |  2 +-
 drivers/acpi/x86/s2idle.c                          |  3 +-
 drivers/ata/libahci_platform.c                     |  5 +-
 drivers/ata/pata_legacy.c                          |  6 +-
 drivers/base/core.c                                |  3 +-
 drivers/block/rnbd/rnbd-clt-sysfs.c                |  4 +-
 drivers/block/virtio_blk.c                         | 41 ++--------
 drivers/bus/simple-pm-bus.c                        | 42 +++++++++-
 drivers/clk/renesas/renesas-rzg2l-cpg.c            |  2 +-
 drivers/clk/socfpga/clk-agilex.c                   |  9 ---
 drivers/edac/armada_xp_edac.c                      |  2 +-
 drivers/firmware/arm_ffa/bus.c                     | 12 ++-
 drivers/firmware/efi/cper.c                        |  4 +-
 drivers/firmware/efi/runtime-wrappers.c            |  2 +-
 drivers/fpga/ice40-spi.c                           |  7 ++
 drivers/gpio/gpio-74x164.c                         |  8 ++
 drivers/gpio/gpio-pca953x.c                        | 16 ++--
 drivers/gpu/drm/drm_edid.c                         | 15 +++-
 drivers/gpu/drm/drm_fb_helper.c                    |  6 ++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  9 ++-
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c              |  9 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              | 11 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          | 16 ++++
 drivers/gpu/drm/msm/dsi/dsi.c                      |  4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c         | 30 ++++----
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |  3 +-
 drivers/gpu/drm/msm/msm_drv.c                      | 12 ++-
 drivers/gpu/drm/msm/msm_drv.h                      |  5 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |  3 +-
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c |  2 +-
 drivers/gpu/drm/panel/Kconfig                      |  1 +
 drivers/iio/accel/fxls8962af-core.c                |  2 +-
 drivers/iio/adc/ad7192.c                           |  1 +
 drivers/iio/adc/ad7780.c                           |  2 +-
 drivers/iio/adc/ad7793.c                           |  2 +-
 drivers/iio/adc/aspeed_adc.c                       |  1 +
 drivers/iio/adc/max1027.c                          |  3 +-
 drivers/iio/adc/mt6577_auxadc.c                    |  8 ++
 drivers/iio/adc/ti-adc128s052.c                    |  6 ++
 drivers/iio/common/ssp_sensors/ssp_spi.c           | 11 ++-
 drivers/iio/dac/ti-dac5571.c                       |  1 +
 drivers/iio/imu/adis16475.c                        |  3 +-
 drivers/iio/imu/adis16480.c                        | 14 +++-
 drivers/iio/light/opt3001.c                        |  6 +-
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/input/touchscreen/resistive-adc-touch.c    | 29 +++----
 drivers/md/dm-rq.c                                 |  8 ++
 drivers/md/dm.c                                    | 17 ++--
 drivers/misc/cb710/sgbuf2.c                        |  2 +-
 drivers/misc/eeprom/at25.c                         |  8 ++
 drivers/misc/eeprom/eeprom_93xx46.c                | 18 +++++
 drivers/misc/fastrpc.c                             |  2 +
 drivers/misc/mei/hbm.c                             | 12 ++-
 drivers/misc/mei/hw-me-regs.h                      |  1 +
 drivers/misc/mei/pci-me.c                          |  1 +
 drivers/mtd/nand/raw/qcom_nandc.c                  |  8 +-
 drivers/net/dsa/microchip/ksz_common.c             |  4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   | 13 +++-
 drivers/net/dsa/ocelot/felix.c                     | 25 ++++--
 drivers/net/ethernet/Kconfig                       |  1 +
 drivers/net/ethernet/arc/Kconfig                   |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 15 ++--
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 57 ++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  1 -
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 52 ++-----------
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 10 ++-
 drivers/net/ethernet/microchip/encx24j600.c        |  5 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |  4 +-
 drivers/net/ethernet/mscc/ocelot.c                 | 90 +++++++++++++++++-----
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c   | 19 +++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  4 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    | 13 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  6 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  6 +-
 drivers/net/phy/phy_device.c                       |  3 +
 drivers/net/usb/Kconfig                            |  4 +
 drivers/nvme/host/pci.c                            |  2 +-
 drivers/nvmem/core.c                               |  3 +-
 drivers/platform/mellanox/mlxreg-io.c              |  4 +-
 drivers/platform/x86/amd-pmc.c                     |  1 +
 drivers/platform/x86/gigabyte-wmi.c                |  1 +
 drivers/platform/x86/intel_scu_ipc.c               |  2 +-
 drivers/spi/spi-atmel.c                            |  4 +-
 drivers/spi/spi-bcm-qspi.c                         | 77 ++++++++++--------
 drivers/spi/spidev.c                               | 14 ++++
 drivers/tee/optee/core.c                           |  3 +
 drivers/tee/optee/device.c                         | 22 ++++++
 drivers/tee/optee/optee_private.h                  |  1 +
 drivers/usb/host/xhci-dbgtty.c                     | 28 ++++---
 drivers/usb/host/xhci-pci.c                        |  6 +-
 drivers/usb/host/xhci-ring.c                       | 39 ++++++++--
 drivers/usb/host/xhci.c                            |  5 ++
 drivers/usb/host/xhci.h                            |  1 +
 drivers/usb/musb/musb_dsps.c                       |  4 +-
 drivers/usb/serial/option.c                        |  8 ++
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/vhost/vdpa.c                               |  2 +-
 drivers/virtio/virtio.c                            | 11 +++
 fs/btrfs/extent-tree.c                             |  1 +
 fs/btrfs/file.c                                    | 19 ++---
 fs/btrfs/tree-log.c                                | 32 +++++---
 include/linux/mlx5/mlx5_ifc.h                      | 10 ++-
 include/soc/mscc/ocelot.h                          |  6 +-
 include/soc/mscc/ocelot_ptp.h                      |  3 +
 kernel/module.c                                    |  2 +
 kernel/trace/trace.c                               | 11 +--
 net/dsa/switch.c                                   |  2 +-
 net/mptcp/protocol.c                               | 55 ++++---------
 net/nfc/af_nfc.c                                   |  3 +
 net/nfc/digital_core.c                             |  9 ++-
 net/nfc/digital_technology.c                       |  8 +-
 net/sched/sch_mqprio.c                             | 30 +++++---
 net/sctp/sm_make_chunk.c                           |  2 +-
 net/smc/smc_cdc.c                                  |  7 +-
 net/smc/smc_core.c                                 | 20 ++---
 net/smc/smc_llc.c                                  | 63 +++++++++++----
 net/smc/smc_tx.c                                   | 22 ++----
 net/smc/smc_wr.h                                   | 14 ++++
 scripts/recordmcount.pl                            |  2 +-
 sound/core/pcm_compat.c                            | 72 ++++++++++++++++-
 sound/core/seq_device.c                            |  8 +-
 sound/pci/hda/patch_realtek.c                      | 66 +++++++++++++++-
 sound/usb/mixer_scarlett_gen2.c                    |  2 +
 sound/usb/quirks-table.h                           | 42 ++++++++++
 144 files changed, 1164 insertions(+), 508 deletions(-)


