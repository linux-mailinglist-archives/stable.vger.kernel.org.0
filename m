Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99729439F8A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhJYTV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhJYTUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFED3600D3;
        Mon, 25 Oct 2021 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189496;
        bh=mXO0r1CmN7AqeW0CR2gHNCQ1yTi50mGTKyJ1aq/NdgM=;
        h=From:To:Cc:Subject:Date:From;
        b=Pxa0QTU4P1FwlfbWLhJM60PmXbfsxxcfbSgRNSsfVHti+tPJETFix4LM5/S5ShYfi
         RPbKBdHeCQPyWpq9azAgBVKWw5sA1yzTmPje3STSJqywSQNehgr4ZYao+5vSn05suT
         WkQTnFjVYJxqfpfvNETHo5QRR89tsVZ2/Iics31Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/50] 4.9.288-rc1 review
Date:   Mon, 25 Oct 2021 21:13:47 +0200
Message-Id: <20211025190932.542632625@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.288-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.288-rc1
X-KernelTest-Deadline: 2021-10-27T19:09+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.288 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.288-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.288-rc1

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have all levels of checks prevent recursion

Yanfei Xu <yanfei.xu@windriver.com>
    net: mdiobus: Fix memory leak in __mdiobus_register

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: avoid write to STATESTS if controller is in reset

Prashant Malani <pmalani@chromium.org>
    platform/x86: intel_scu_ipc: Update timeout value in comment

Zheyu Ma <zheyuma97@gmail.com>
    isdn: mISDN: Fix sleeping function called from invalid context

Herve Codina <herve.codina@bootlin.com>
    ARM: dts: spear3xx: Fix gmac node

Vegard Nossum <vegard.nossum@gmail.com>
    netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang <butterflyhuangxx@gmail.com>
    isdn: cpai: check ctr->cnr to avoid array index out of bound

Lin Ma <linma@zju.edu.cn>
    nfc: nci: fix the UAF of rf_conn_info object

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Fix missing kctl change notifications

Brendan Grieve <brendan@grieve.com.au>
    ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Matthew Wilcox (Oracle) <willy@infradead.org>
    vfs: check fd has read access in kernel_read_file_from_fd()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    elfcore: correct reference to CONFIG_UML

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    ocfs2: mount fails with buffer overflow in strlen

Jan Kara <jack@suse.cz>
    ocfs2: fix data corruption after conversion from inline format

Zheyu Ma <zheyuma97@gmail.com>
    can: peak_pci: peak_pci_remove(): fix UAF

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    can: rcar_can: fix suspend/resume

Randy Dunlap <rdunlap@infradead.org>
    NIOS2: irqflags: rename a redefined register name

Antoine Tenart <atenart@kernel.org>
    netfilter: ipvs: make global sysctl readonly in non-init netns

Benjamin Coddington <bcodding@redhat.com>
    NFSD: Keep existing listeners on portlist error

Guenter Roeck <linux@roeck-us.net>
    xtensa: xtfpga: Try software restart before simulating CPU reset

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Vegard Nossum <vegard.nossum@oracle.com>
    r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling

Colin Ian King <colin.king@canonical.com>
    drm/msm: Fix null pointer dereference on pointer edp

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

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: fix error code in ssp_print_mcu_debug()

Dan Carpenter <dan.carpenter@oracle.com>
    iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

Jiri Valek - 2N <valek@2n.cz>
    iio: light: opt3001: Fixed timeout error when 0 lux

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Stephen Boyd <swboyd@chromium.org>
    nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910Cx composition 0x1204

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: qcserial: add EM9191 QDL support

Michael Cullen <michael@michaelcullen.name>
    Input: xpad - add support for another USB ID of Nacon GC-100

Zhang Jianhua <chris.zjh@huawei.com>
    efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

Ard Biesheuvel <ardb@kernel.org>
    efi/cper: use stack buffer for error record decoding

Arnd Bergmann <arnd@arndb.de>
    cb710: avoid NULL pointer subtraction

Nikolay Martynov <mar.kolya@gmail.com>
    xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Roberto Sassu <roberto.sassu@huawei.com>
    s390: fix strrchr() implementation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix a potential UAF by wrong private_free call order


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/Kconfig                                   |  1 +
 arch/arm/boot/dts/spear3xx.dtsi                    |  2 +-
 arch/nios2/include/asm/irqflags.h                  |  4 +-
 arch/nios2/include/asm/registers.h                 |  2 +-
 arch/s390/lib/string.c                             | 15 +++--
 arch/xtensa/platforms/xtfpga/setup.c               | 12 ++--
 drivers/ata/pata_legacy.c                          |  6 +-
 drivers/firmware/efi/cper.c                        |  4 +-
 drivers/firmware/efi/runtime-wrappers.c            |  2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  2 +-
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |  3 +-
 drivers/iio/adc/ti-adc128s052.c                    |  6 ++
 drivers/iio/common/ssp_sensors/ssp_spi.c           | 11 +++-
 drivers/iio/light/opt3001.c                        |  6 +-
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/isdn/capi/kcapi.c                          |  5 ++
 drivers/isdn/hardware/mISDN/netjet.c               |  2 +-
 drivers/misc/cb710/sgbuf2.c                        |  2 +-
 drivers/net/can/rcar/rcar_can.c                    | 20 ++++---
 drivers/net/can/sja1000/peak_pci.c                 |  9 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  5 +-
 drivers/net/ethernet/Kconfig                       |  1 +
 drivers/net/ethernet/arc/Kconfig                   |  1 +
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 10 +++-
 drivers/net/ethernet/microchip/encx24j600.c        |  5 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |  4 +-
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 drivers/net/phy/mdio_bus.c                         |  1 +
 drivers/net/usb/Kconfig                            |  4 ++
 drivers/net/usb/usbnet.c                           |  4 ++
 drivers/nvmem/core.c                               |  3 +-
 drivers/platform/x86/intel_scu_ipc.c               |  2 +-
 drivers/usb/host/xhci-pci.c                        |  2 +
 drivers/usb/serial/option.c                        |  2 +
 drivers/usb/serial/qcserial.c                      |  1 +
 fs/exec.c                                          |  2 +-
 fs/nfsd/nfsctl.c                                   |  5 +-
 fs/ocfs2/alloc.c                                   | 46 ++++------------
 fs/ocfs2/super.c                                   | 14 +++--
 include/linux/elfcore.h                            |  2 +-
 kernel/trace/ftrace.c                              |  4 +-
 kernel/trace/trace.h                               | 64 +++++++---------------
 kernel/trace/trace_functions.c                     |  2 +-
 net/netfilter/Kconfig                              |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  5 ++
 net/nfc/af_nfc.c                                   |  3 +
 net/nfc/digital_core.c                             |  9 ++-
 net/nfc/digital_technology.c                       |  8 ++-
 net/nfc/nci/rsp.c                                  |  2 +
 sound/core/seq/seq_device.c                        |  8 +--
 sound/hda/hdac_controller.c                        |  5 +-
 sound/soc/soc-dapm.c                               | 13 +++--
 sound/usb/quirks-table.h                           | 32 +++++++++++
 54 files changed, 232 insertions(+), 161 deletions(-)


