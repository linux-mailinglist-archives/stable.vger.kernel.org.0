Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED34914E290
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgA3SmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgA3SmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:42:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BA5205F4;
        Thu, 30 Jan 2020 18:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409738;
        bh=6/9kNlDigzEBI4QnTX0McEshXMO71HabDysRJW1rBEc=;
        h=From:To:Cc:Subject:Date:From;
        b=De97qwlY+Jm08BO6ghhm5jcutFZ7U5l7dDB+uLZ0xlVffS3KwCNX12fVBwxNCORKF
         ERE9lq60TzoFF1a+3NBp2ztS8Yv+3RLzUa3lKAH68ZzHBjVRyfiegk9C784bve0A16
         Q+fv3t1h8JqtYN9FuklDmz/y/q2aM4ep9CBg34yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/110] 5.4.17-stable review
Date:   Thu, 30 Jan 2020 19:37:36 +0100
Message-Id: <20200130183613.810054545@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.17-rc1
X-KernelTest-Deadline: 2020-02-01T18:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.17 release.
There are 110 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.17-rc1

Paul Cercueil <paul@crapouillou.net>
    power/supply: ingenic-battery: Don't change scale if there's only one

Johannes Berg <johannes.berg@intel.com>
    Revert "um: Enable CONFIG_CONSTRUCTORS"

Andrew Murray <andrew.murray@arm.com>
    KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix user-after-free on module unload

Iuliana Prodan <iuliana.prodan@nxp.com>
    crypto: caam - do not reset pointer size from MCFGR register

Daniel Axtens <dja@axtens.net>
    crypto: vmx - reject xts inputs that are too short

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Use bh_lock_sock in sk_destruct

Johan Hovold <johan@kernel.org>
    rsi: fix non-atomic allocation in completion handler

Johan Hovold <johan@kernel.org>
    rsi: fix memory leak on failed URB submission

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on probe errors

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on failed probe and unbind

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix missing force mstandby quirk handling

Andre Heider <a.heider@gmail.com>
    Bluetooth: btbcm: Use the BDADDR_PROPERTY quirk

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Allow combination of BDADDR_PROPERTY and INVALID_BDADDR quirks

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Move some alc236 pintbls to fallback table

Laura Abbott <labbott@fedoraproject.org>
    usb-storage: Disable UAS on JMicron SATA enclosure

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Add module enable quirk for audio AESS

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add support for Intel JSL

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-pci: Quirk for AMD SDHC Device 0x7906

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition

Joel Stanley <joel@jms.id.au>
    ARM: config: aspeed-g5: Enable 8250_DW quirks

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Add Intel Comet Lake PCH-H PCI IDs

Joakim Zhang <qiangqing.zhang@nxp.com>
    perf/imx_ddr: Add enhanced AXI ID filter support

Logan Gunthorpe <logang@deltatee.com>
    iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping

Logan Gunthorpe <logang@deltatee.com>
    iommu/amd: Support multiple PCI DMA aliases in device table

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    spi: pxa2xx: Add support for Intel Comet Lake-H

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use swsup quirks also for am335x musb

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Handle mstandby quirk and use it for musb

Thomas Voegtle <tv@lio96.de>
    media: dvbsky: add support for eyeTV Geniatech T2 lite

Slawomir Pawlowski <slawomir.pawlowski@intel.com>
    PCI: Add DMA alias quirk for Intel VCA NTB

Pacien TRAN-GIRARD <pacien.trangirard@pacien.net>
    platform/x86: dell-laptop: disable kbd backlight on Inspiron 10xx

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: add quirks for 'E2' revision using 'soc_device_attribute'

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix BTF-defined map's __type macro handling of arrays

Jiange Zhao <Jiange.Zhao@amd.com>
    drm/amdgpu/SRIOV: add navi12 pci id for SRIOV (v2)

Sam McNally <sammc@chromium.org>
    ASoC: Intel: cht_bsw_rt5645: Add quirk for boards using pmc_plt_clk_0

Yauhen Kharuzhy <jekhor@gmail.com>
    extcon-intel-cht-wc: Don't reset USB data connection at probe

Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
    HID: steam: Fix input device disappearing

Arnd Bergmann <arnd@arndb.de>
    atm: eni: fix uninitialized variable warning

Jiping Ma <jiping.ma2@windriver.com>
    stmmac: debugfs entry name is not be changed when udev rename device name.

Thomas Anderson <thomasanderson@google.com>
    drm/amd/display: Reduce HDMI pixel encoding if max clock is exceeded

Qian Cai <cai@lca.pw>
    iommu/dma: fix variable 'cookie' set but not used

Dmitry Osipenko <digetx@gmail.com>
    gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Krzysztof Kozlowski <krzk@kernel.org>
    net: wan: sdla: Fix cast from pointer to integer of different size

Fenghua Yu <fenghua.yu@intel.com>
    drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Liran Alon <liran.alon@oracle.com>
    net: Google gve: Remove dma_wmb() before ringing doorbell

wuxu.wu <wuxu.wu@huawei.com>
    spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

Sean Nyekjaer <sean@geanix.com>
    can: tcan4x5x: tcan4x5x_parse_config(): reset device before register access

Paul Cercueil <paul@crapouillou.net>
    usb: musb: jz4740: Silence error if code is -EPROBE_DEFER

Russell King <rmk+kernel@armlinux.org.uk>
    watchdog: orion: fix platform_get_irq() complaints

Andreas Kemnade <andreas@kemnade.info>
    watchdog: rn5t618_wdt: fix module aliases

David Engraf <david.engraf@sysgo.com>
    watchdog: max77620_wdt: fix potential build errors

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    HID: intel-ish-hid: ipc: Add Tiger Lake PCI device ID

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Prevent USB line glitches from waking up modem

Dragos Tarcatu <dragos_tarcatu@mentor.com>
    ASoC: topology: Prevent use-after-free in snd_soc_get_pcm_runtime()

Chuhong Yuan <hslester96@gmail.com>
    ASoC: fsl_audmix: add missed pm_runtime_disable

Bjorn Andersson <bjorn.andersson@linaro.org>
    phy: qcom-qmp: Increase PHY ready timeout

Pan Zhang <zhangpan26@huawei.com>
    drivers/hid/hid-multitouch.c: fix a possible null pointer access.

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda: hda-dai: fix oops on hda_link .hw_free

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: fix fault at driver unload after failed probe

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Recognize new MobileStudio Pro PID

Even Xu <even.xu@intel.com>
    HID: intel-ish-hid: ipc: add CMP device id

Pavel Balan <admin@kryma.net>
    HID: Add quirk for incorrect input length on Lenovo Y720

Hans de Goede <hdegoede@redhat.com>
    HID: asus: Ignore Asus vendor-page usage-code 0xff events

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Add USB id match for Acer SW5-012 keyboard dock

Priit Laes <plaes@plaes.org>
    HID: Add quirk for Xin-Mo Dual Controller

Randy Dunlap <rdunlap@infradead.org>
    arc: eznps: fix allmodconfig kconfig warning

Aaron Ma <aaron.ma@canonical.com>
    HID: multitouch: Add LG MELF0410 I2C touchscreen support

David Howells <dhowells@redhat.com>
    rxrpc: Fix use-after-free in rxrpc_receive_data()

Stephen Worley <sworley@cumulusnetworks.com>
    net: include struct nhmsg size in nh nlmsg size

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mlxsw: minimal: Fix an error handling path in 'mlxsw_m_port_create()'

Willem de Bruijn <willemb@google.com>
    udp: segment looped gso packets correctly

Lorenzo Bianconi <lorenzo@kernel.org>
    net: socionext: fix xdp_result initialization in netsec_process_rx

Lorenzo Bianconi <lorenzo@kernel.org>
    net: socionext: fix possible user-after-free in netsec_process_rx

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: walk through all child classes in tc_bind_tclass()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix ops->bind_class() implementations

Eric Dumazet <edumazet@google.com>
    net_sched: ematch: reject invalid TCF_EM_SIMPLE

Johan Hovold <johan@kernel.org>
    zd1211rw: fix storage endpoint lookup

Johan Hovold <johan@kernel.org>
    rtl8xxxu: fix interface sanity check

Johan Hovold <johan@kernel.org>
    brcmfmac: fix interface sanity check

Johan Hovold <johan@kernel.org>
    ath9k: fix storage endpoint lookup

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: set correct max-buffer-size for smb2_ioctl_init()

Vincent Whitchurch <vincent.whitchurch@axis.com>
    CIFS: Fix task struct use-after-free on reconnect

Eric Biggers <ebiggers@google.com>
    crypto: chelsio - fix writing tfm flags to wrong place

Guenter Roeck <linux@roeck-us.net>
    driver core: Fix test_async_driver_probe if NUMA is disabled

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: st_gyro: Correct data for LSM9DS0 gyro

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-dfsdm: fix single conversion

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add comet point (lake) H device ids

Tomas Winkler <tomas.winkler@intel.com>
    mei: hdcp: bind only with i915 on the same PCH

Martin Fuzzey <martin.fuzzey@flowbird.group>
    binder: fix log spam for existing debugfs file creation.

Lubomir Rintel <lkundrak@v3.sk>
    component: do not dereference opaque pointer in debugfs

Eric Snowberg <eric.snowberg@oracle.com>
    debugfs: Return -EPERM when locked down

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: fix a race condition in receive path

Lukas Wunner <lukas@wunner.de>
    serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix false Tx excessive retries reporting.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: use NULLFUCTION stack on mac80211

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: correct packet types for CTS protect, mode.

Colin Ian King <colin.king@canonical.com>
    staging: wlan-ng: ensure error return is actually returned

Andrey Shvetsov <andrey.shvetsov@k2l.de>
    staging: most: net: fix buffer overflow

Thomas Hebb <tommyhebb@gmail.com>
    usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW

Thomas Hebb <tommyhebb@gmail.com>
    usb: typec: wcove: fix "op-sink-microwatt" default that was in mW

Bin Liu <b-liu@ti.com>
    usb: dwc3: turn off VBUS when leaving host mode

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix IrLAP framing

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix link-speed handling

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: add missing endpoint sanity check

Peter Robinson <pbrobinson@gmail.com>
    usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Johan Hovold <johan@kernel.org>
    rsi_91x_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    orinoco_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    Bluetooth: btusb: fix non-atomic allocation in completion handler


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/plat-eznps/Kconfig                        |   2 +-
 arch/arm/configs/aspeed_g5_defconfig               |   1 +
 arch/arm64/kvm/debug.c                             |   6 +-
 arch/um/include/asm/common.lds.S                   |   2 +-
 arch/um/kernel/dyn.lds.S                           |   1 +
 crypto/af_alg.c                                    |   6 +-
 crypto/pcrypt.c                                    |   3 +-
 drivers/android/binder.c                           |  37 ++---
 drivers/atm/eni.c                                  |   4 +-
 drivers/base/component.c                           |   8 +-
 drivers/base/test/test_async_driver_probe.c        |   3 +-
 drivers/bluetooth/btbcm.c                          |   6 +
 drivers/bluetooth/btusb.c                          |   2 +-
 drivers/bus/ti-sysc.c                              |  27 +++-
 drivers/crypto/caam/ctrl.c                         |   6 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  16 +-
 drivers/crypto/vmx/aes_xts.c                       |   3 +
 drivers/extcon/extcon-intel-cht-wc.c               |  16 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  45 +++---
 drivers/hid/hid-asus.c                             |   3 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-ite.c                              |   3 +
 drivers/hid/hid-multitouch.c                       |   5 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-steam.c                            |   4 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  16 +-
 drivers/hid/intel-ish-hid/ipc/hw-ish.h             |   2 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   2 +
 drivers/hid/wacom_wac.c                            |   6 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   2 +
 drivers/iio/gyro/st_gyro_core.c                    |  75 ++++++++-
 drivers/iommu/amd_iommu.c                          | 170 +++++++++++----------
 drivers/iommu/amd_iommu_types.h                    |   2 +-
 drivers/iommu/dma-iommu.c                          |   3 -
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   3 +
 drivers/mfd/intel-lpss-pci.c                       |  13 +-
 drivers/misc/mei/hdcp/mei_hdcp.c                   |  33 +++-
 drivers/misc/mei/hw-me-regs.h                      |   4 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/mmc/host/sdhci-pci-core.c                  |  53 ++++++-
 drivers/mmc/host/sdhci-pci.h                       |   2 +
 drivers/net/can/m_can/tcan4x5x.c                   |  27 +++-
 drivers/net/ethernet/broadcom/b44.c                |   9 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   2 -
 drivers/net/ethernet/google/gve/gve_tx.c           |   6 -
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  32 ++++
 drivers/net/wan/sdla.c                             |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   4 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   4 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  12 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  37 +++--
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   2 +-
 drivers/pci/quirks.c                               |  34 +++++
 drivers/perf/fsl_imx8_ddr_perf.c                   |  63 +++++---
 drivers/phy/motorola/phy-cpcap-usb.c               |  18 ++-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   2 +-
 drivers/platform/x86/dell-laptop.c                 |  26 ++++
 drivers/power/supply/ingenic-battery.c             |  15 +-
 drivers/spi/spi-dw.c                               |  15 +-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/spi/spi-pxa2xx.c                           |   4 +
 drivers/staging/most/net/net.c                     |  10 ++
 drivers/staging/mt7621-pci/pci-mt7621.c            |  23 ++-
 drivers/staging/vt6656/device.h                    |   2 +
 drivers/staging/vt6656/int.c                       |   6 +-
 drivers/staging/vt6656/main_usb.c                  |   1 +
 drivers/staging/vt6656/rxtx.c                      |  26 ++--
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/tty/serial/8250/8250_bcm2835aux.c          |   2 +-
 drivers/tty/serial/imx.c                           |  51 +++++--
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/host/xhci-tegra.c                      |   1 +
 drivers/usb/musb/jz4740.c                          |   7 +-
 drivers/usb/serial/ir-usb.c                        | 136 +++++++++++++----
 drivers/usb/storage/unusual_uas.h                  |   7 +-
 drivers/usb/typec/tcpm/fusb302.c                   |   2 +-
 drivers/usb/typec/tcpm/wcove.c                     |   2 +-
 drivers/watchdog/Kconfig                           |   1 +
 drivers/watchdog/orion_wdt.c                       |   4 +-
 drivers/watchdog/rn5t618_wdt.c                     |   1 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/smb2misc.c                                 |   2 +-
 fs/cifs/smb2ops.c                                  |   9 +-
 fs/cifs/smb2transport.c                            |   2 +
 fs/cifs/transport.c                                |   3 +
 fs/debugfs/file.c                                  |  17 ++-
 include/linux/platform_data/ti-sysc.h              |   2 +
 include/linux/power/smartreflex.h                  |   3 +
 include/linux/usb/irda.h                           |  13 +-
 include/media/dvb-usb-ids.h                        |   1 +
 include/net/pkt_cls.h                              |  33 ++--
 include/net/sch_generic.h                          |   3 +-
 include/net/udp.h                                  |   3 +
 init/Kconfig                                       |   1 +
 kernel/gcov/Kconfig                                |   2 +-
 net/bluetooth/hci_core.c                           |  26 +++-
 net/ipv4/nexthop.c                                 |   4 +-
 net/rxrpc/input.c                                  |  12 +-
 net/sched/cls_basic.c                              |  11 +-
 net/sched/cls_bpf.c                                |  11 +-
 net/sched/cls_flower.c                             |  11 +-
 net/sched/cls_fw.c                                 |  11 +-
 net/sched/cls_matchall.c                           |  11 +-
 net/sched/cls_route.c                              |  11 +-
 net/sched/cls_rsvp.h                               |  11 +-
 net/sched/cls_tcindex.c                            |  11 +-
 net/sched/cls_u32.c                                |  11 +-
 net/sched/ematch.c                                 |   3 +
 net/sched/sch_api.c                                |  47 ++++--
 sound/pci/hda/patch_realtek.c                      |  17 +--
 sound/soc/fsl/fsl_audmix.c                         |   9 +-
 sound/soc/intel/boards/cht_bsw_rt5645.c            |  26 +++-
 sound/soc/soc-topology.c                           |   6 +-
 sound/soc/sof/intel/hda-dai.c                      |  11 +-
 sound/soc/sof/ipc.c                                |   3 +
 tools/testing/selftests/bpf/bpf_helpers.h          |   2 +-
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |   3 +-
 125 files changed, 1162 insertions(+), 424 deletions(-)


