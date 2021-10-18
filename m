Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707CB431FBD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhJROdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhJROdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C0060FC3;
        Mon, 18 Oct 2021 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634567454;
        bh=ovyGrIMwQL8dg86Jk8gWanJYidtAl3EEhZhW3izA2zU=;
        h=From:To:Cc:Subject:Date:From;
        b=tSyi3LvEGkxd7ndglOlkoIWT/oq2CaJ0eu711xjbDcITy9zee1FTgB1qLvGhjIPLS
         CZXZP4m1kQu41d3E+2swZ0yz/+Kxbg8qYIv7n6xBW7zI48KCI9CJ+2gRQczpk17iAv
         Z2PGR9dpr5MOHZWR/HVY9qHdN5+Sd7XBEGmZ+nHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/49] 4.19.213-rc2 review
Date:   Mon, 18 Oct 2021 16:30:51 +0200
Message-Id: <20211018143033.725101193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.213-rc2
X-KernelTest-Deadline: 2021-10-20T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.213 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Oct 2021 14:30:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.213-rc2

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

Colin Ian King <colin.king@canonical.com>
    drm/msm: Fix null pointer dereference on pointer edp

Vadim Pasternak <vadimp@nvidia.com>
    platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call

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

Vegard Nossum <vegard.nossum@oracle.com>
    net: korina: select CRC32

Vegard Nossum <vegard.nossum@oracle.com>
    net: arc: select CRC32

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: set driver data when adc probe.

Borislav Petkov <bp@suse.de>
    x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

Stephen Boyd <swboyd@chromium.org>
    nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

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

Filipe Manana <fdmanana@suse.com>
    btrfs: check for error when looking up inode during dir entry replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when adding inode reference during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: deal with errors when replaying dir entry during log replay

Roberto Sassu <roberto.sassu@huawei.com>
    s390: fix strrchr() implementation

Steven Rostedt <rostedt@goodmis.org>
    nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - ALC236 headset MIC recording issue

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Clevo X170KM-G

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Complete partial device name to avoid ambiguity

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix a potential UAF by wrong private_free call order


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/s390/lib/string.c                             | 15 +++++-----
 arch/x86/Kconfig                                   |  1 -
 arch/x86/kernel/cpu/intel_rdt.c                    |  2 ++
 drivers/acpi/arm64/gtdt.c                          |  2 +-
 drivers/ata/pata_legacy.c                          |  6 ++--
 drivers/firmware/efi/cper.c                        |  4 +--
 drivers/firmware/efi/runtime-wrappers.c            |  2 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |  4 ++-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +-
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |  3 +-
 drivers/iio/adc/aspeed_adc.c                       |  1 +
 drivers/iio/adc/ti-adc128s052.c                    |  6 ++++
 drivers/iio/common/ssp_sensors/ssp_spi.c           | 11 ++++++--
 drivers/iio/dac/ti-dac5571.c                       |  1 +
 drivers/iio/light/opt3001.c                        |  6 ++--
 drivers/input/joystick/xpad.c                      |  2 ++
 drivers/misc/cb710/sgbuf2.c                        |  2 +-
 drivers/misc/mei/hw-me-regs.h                      |  1 +
 drivers/misc/mei/pci-me.c                          |  1 +
 drivers/net/ethernet/Kconfig                       |  1 +
 drivers/net/ethernet/arc/Kconfig                   |  1 +
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 10 +++++--
 drivers/net/ethernet/microchip/encx24j600.c        |  5 +++-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |  4 +--
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  1 +
 drivers/net/usb/Kconfig                            |  4 +++
 drivers/nvmem/core.c                               |  3 +-
 drivers/platform/mellanox/mlxreg-io.c              |  2 +-
 drivers/usb/host/xhci-pci.c                        |  2 ++
 drivers/usb/host/xhci-ring.c                       | 14 +++++++---
 drivers/usb/host/xhci.c                            |  5 ++++
 drivers/usb/musb/musb_dsps.c                       |  4 ++-
 drivers/usb/serial/option.c                        |  8 ++++++
 drivers/usb/serial/qcserial.c                      |  1 +
 drivers/virtio/virtio.c                            | 11 ++++++++
 fs/btrfs/tree-log.c                                | 32 +++++++++++++++-------
 net/nfc/af_nfc.c                                   |  3 ++
 net/nfc/digital_core.c                             |  9 ++++--
 net/nfc/digital_technology.c                       |  8 ++++--
 net/sched/sch_mqprio.c                             | 30 ++++++++++++--------
 net/sctp/sm_make_chunk.c                           |  2 +-
 scripts/recordmcount.pl                            |  2 +-
 sound/core/seq_device.c                            |  8 ++----
 sound/pci/hda/patch_realtek.c                      |  8 ++++--
 46 files changed, 182 insertions(+), 74 deletions(-)


