Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B514F770
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgBAJ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgBAJ47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 04:56:59 -0500
Received: from localhost (unknown [83.216.75.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11074206D3;
        Sat,  1 Feb 2020 09:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580551018;
        bh=wwFdVFJdxstXr3hvXHmGwbtEGhY9NWN6kCrIlN5Z2Hc=;
        h=Date:From:To:Cc:Subject:From;
        b=rAX6+vvXid24OCiqN5GgSpGRWP9d2bAF8bYeQdJ/RQq8L8oC4HlB+l8g/O2ygMz0O
         xpzl+SOqlxCphZ+p/1A34hnH0prJ1TLqPhpOdosKFXloTr14K6iuJRwkRKylWpXzfm
         3ABZA6sx3ib26H3n5awMXi0nIwlCzZSEq2xdqjx0=
Date:   Sat, 1 Feb 2020 09:56:49 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.17
Message-ID: <20200201095649.GA2305217@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.17 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                 |    2=20
 arch/arc/plat-eznps/Kconfig                              |    2=20
 arch/arm/configs/aspeed_g5_defconfig                     |    1=20
 arch/arm64/kvm/debug.c                                   |    6=20
 arch/um/include/asm/common.lds.S                         |    2=20
 arch/um/kernel/dyn.lds.S                                 |    1=20
 crypto/af_alg.c                                          |    6=20
 crypto/pcrypt.c                                          |    3=20
 drivers/android/binder.c                                 |   37 +--
 drivers/atm/eni.c                                        |    4=20
 drivers/base/component.c                                 |    8=20
 drivers/base/test/test_async_driver_probe.c              |    3=20
 drivers/bluetooth/btbcm.c                                |    6=20
 drivers/bluetooth/btusb.c                                |    2=20
 drivers/bus/ti-sysc.c                                    |   27 ++
 drivers/crypto/caam/ctrl.c                               |    6=20
 drivers/crypto/chelsio/chcr_algo.c                       |   16 -
 drivers/crypto/vmx/aes_xts.c                             |    3=20
 drivers/extcon/extcon-intel-cht-wc.c                     |   16 +
 drivers/gpio/Kconfig                                     |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                  |    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c        |   45 ++-
 drivers/hid/hid-asus.c                                   |    3=20
 drivers/hid/hid-ids.h                                    |    3=20
 drivers/hid/hid-ite.c                                    |    3=20
 drivers/hid/hid-multitouch.c                             |    5=20
 drivers/hid/hid-quirks.c                                 |    1=20
 drivers/hid/hid-steam.c                                  |    4=20
 drivers/hid/i2c-hid/i2c-hid-core.c                       |   16 +
 drivers/hid/intel-ish-hid/ipc/hw-ish.h                   |    2=20
 drivers/hid/intel-ish-hid/ipc/pci-ish.c                  |    2=20
 drivers/hid/wacom_wac.c                                  |    6=20
 drivers/iio/adc/stm32-dfsdm-adc.c                        |    2=20
 drivers/iio/gyro/st_gyro_core.c                          |   75 ++++++
 drivers/iommu/amd_iommu.c                                |  170 ++++++++--=
-----
 drivers/iommu/amd_iommu_types.h                          |    2=20
 drivers/iommu/dma-iommu.c                                |    3=20
 drivers/media/usb/dvb-usb-v2/dvbsky.c                    |    3=20
 drivers/mfd/intel-lpss-pci.c                             |   13 +
 drivers/misc/mei/hdcp/mei_hdcp.c                         |   33 ++
 drivers/misc/mei/hw-me-regs.h                            |    4=20
 drivers/misc/mei/pci-me.c                                |    2=20
 drivers/mmc/host/sdhci-pci-core.c                        |   53 ++++
 drivers/mmc/host/sdhci-pci.h                             |    2=20
 drivers/net/can/m_can/tcan4x5x.c                         |   27 ++
 drivers/net/ethernet/broadcom/b44.c                      |    9=20
 drivers/net/ethernet/google/gve/gve_rx.c                 |    2=20
 drivers/net/ethernet/google/gve/gve_tx.c                 |    6=20
 drivers/net/ethernet/mellanox/mlxsw/minimal.c            |    2=20
 drivers/net/ethernet/socionext/netsec.c                  |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |   32 ++
 drivers/net/wan/sdla.c                                   |    2=20
 drivers/net/wireless/ath/ath9k/hif_usb.c                 |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c   |    4=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c      |    4=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    |    2=20
 drivers/net/wireless/rsi/rsi_91x_hal.c                   |   12 -
 drivers/net/wireless/rsi/rsi_91x_usb.c                   |   37 ++-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c             |    2=20
 drivers/pci/quirks.c                                     |   34 +++
 drivers/perf/fsl_imx8_ddr_perf.c                         |   63 +++--
 drivers/phy/motorola/phy-cpcap-usb.c                     |   18 +
 drivers/phy/qualcomm/phy-qcom-qmp.c                      |    2=20
 drivers/platform/x86/dell-laptop.c                       |   26 ++
 drivers/power/supply/ingenic-battery.c                   |   15 -
 drivers/spi/spi-dw.c                                     |   15 +
 drivers/spi/spi-dw.h                                     |    1=20
 drivers/spi/spi-pxa2xx.c                                 |    4=20
 drivers/staging/most/net/net.c                           |   10=20
 drivers/staging/mt7621-pci/pci-mt7621.c                  |   23 +-
 drivers/staging/vt6656/device.h                          |    2=20
 drivers/staging/vt6656/int.c                             |    6=20
 drivers/staging/vt6656/main_usb.c                        |    1=20
 drivers/staging/vt6656/rxtx.c                            |   26 +-
 drivers/staging/wlan-ng/prism2mgmt.c                     |    2=20
 drivers/tty/serial/8250/8250_bcm2835aux.c                |    2=20
 drivers/tty/serial/imx.c                                 |   51 +++-
 drivers/usb/dwc3/core.c                                  |    3=20
 drivers/usb/dwc3/dwc3-pci.c                              |    4=20
 drivers/usb/host/xhci-tegra.c                            |    1=20
 drivers/usb/musb/jz4740.c                                |    7=20
 drivers/usb/serial/ir-usb.c                              |  136 +++++++++-=
--
 drivers/usb/storage/unusual_uas.h                        |    7=20
 drivers/usb/typec/tcpm/fusb302.c                         |    2=20
 drivers/usb/typec/tcpm/wcove.c                           |    2=20
 drivers/watchdog/Kconfig                                 |    1=20
 drivers/watchdog/orion_wdt.c                             |    4=20
 drivers/watchdog/rn5t618_wdt.c                           |    1=20
 fs/cifs/cifsglob.h                                       |    1=20
 fs/cifs/smb2misc.c                                       |    2=20
 fs/cifs/smb2ops.c                                        |    9=20
 fs/cifs/smb2transport.c                                  |    2=20
 fs/cifs/transport.c                                      |    3=20
 fs/debugfs/file.c                                        |   17 -
 include/linux/platform_data/ti-sysc.h                    |    2=20
 include/linux/power/smartreflex.h                        |    3=20
 include/linux/usb/irda.h                                 |   13 +
 include/media/dvb-usb-ids.h                              |    1=20
 include/net/pkt_cls.h                                    |   33 +-
 include/net/sch_generic.h                                |    3=20
 include/net/udp.h                                        |    3=20
 init/Kconfig                                             |    1=20
 kernel/gcov/Kconfig                                      |    2=20
 net/bluetooth/hci_core.c                                 |   26 ++
 net/ipv4/nexthop.c                                       |    4=20
 net/rxrpc/input.c                                        |   12 -
 net/sched/cls_basic.c                                    |   11=20
 net/sched/cls_bpf.c                                      |   11=20
 net/sched/cls_flower.c                                   |   11=20
 net/sched/cls_fw.c                                       |   11=20
 net/sched/cls_matchall.c                                 |   11=20
 net/sched/cls_route.c                                    |   11=20
 net/sched/cls_rsvp.h                                     |   11=20
 net/sched/cls_tcindex.c                                  |   11=20
 net/sched/cls_u32.c                                      |   11=20
 net/sched/ematch.c                                       |    3=20
 net/sched/sch_api.c                                      |   47 +++-
 sound/pci/hda/patch_realtek.c                            |   17 -
 sound/soc/fsl/fsl_audmix.c                               |    9=20
 sound/soc/intel/boards/cht_bsw_rt5645.c                  |   26 +-
 sound/soc/soc-topology.c                                 |    6=20
 sound/soc/sof/intel/hda-dai.c                            |   11=20
 sound/soc/sof/ipc.c                                      |    3=20
 tools/testing/selftests/bpf/bpf_helpers.h                |    2=20
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c |    3=20
 125 files changed, 1161 insertions(+), 423 deletions(-)

Aaron Ma (1):
      HID: multitouch: Add LG MELF0410 I2C touchscreen support

Adrian Hunter (1):
      mmc: sdhci-pci: Add support for Intel JSL

Andre Heider (1):
      Bluetooth: btbcm: Use the BDADDR_PROPERTY quirk

Andreas Kemnade (1):
      watchdog: rn5t618_wdt: fix module aliases

Andrew Murray (1):
      KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Andrii Nakryiko (1):
      libbpf: Fix BTF-defined map's __type macro handling of arrays

Andy Shevchenko (2):
      iio: st_gyro: Correct data for LSM9DS0 gyro
      mfd: intel-lpss: Add Intel Comet Lake PCH-H PCI IDs

Arnd Bergmann (1):
      atm: eni: fix uninitialized variable warning

Ben Dooks (1):
      ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Bjorn Andersson (1):
      phy: qcom-qmp: Increase PHY ready timeout

Christophe JAILLET (1):
      mlxsw: minimal: Fix an error handling path in 'mlxsw_m_port_create()'

Chuhong Yuan (1):
      ASoC: fsl_audmix: add missed pm_runtime_disable

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Cong Wang (2):
      net_sched: fix ops->bind_class() implementations
      net_sched: walk through all child classes in tc_bind_tclass()

Daniel Axtens (1):
      crypto: vmx - reject xts inputs that are too short

David Engraf (1):
      watchdog: max77620_wdt: fix potential build errors

David Howells (1):
      rxrpc: Fix use-after-free in rxrpc_receive_data()

Dmitry Osipenko (1):
      gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Dragos Tarcatu (1):
      ASoC: topology: Prevent use-after-free in snd_soc_get_pcm_runtime()

Eric Biggers (1):
      crypto: chelsio - fix writing tfm flags to wrong place

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Eric Snowberg (1):
      debugfs: Return -EPERM when locked down

Even Xu (1):
      HID: intel-ish-hid: ipc: add CMP device id

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Greg Kroah-Hartman (1):
      Linux 5.4.17

Guenter Roeck (1):
      driver core: Fix test_async_driver_probe if NUMA is disabled

Hans de Goede (2):
      HID: ite: Add USB id match for Acer SW5-012 keyboard dock
      HID: asus: Ignore Asus vendor-page usage-code 0xff events

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Herbert Xu (2):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: pcrypt - Fix user-after-free on module unload

Hui Wang (1):
      ALSA: hda/realtek - Move some alc236 pintbls to fallback table

Iuliana Prodan (1):
      crypto: caam - do not reset pointer size from MCFGR register

Jarkko Nikula (1):
      spi: pxa2xx: Add support for Intel Comet Lake-H

Jason Gerecke (1):
      HID: wacom: Recognize new MobileStudio Pro PID

Jiange Zhao (1):
      drm/amdgpu/SRIOV: add navi12 pci id for SRIOV (v2)

Jiping Ma (1):
      stmmac: debugfs entry name is not be changed when udev rename device =
name.

Joakim Zhang (1):
      perf/imx_ddr: Add enhanced AXI ID filter support

Joel Stanley (1):
      ARM: config: aspeed-g5: Enable 8250_DW quirks

Johan Hovold (14):
      Bluetooth: btusb: fix non-atomic allocation in completion handler
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup
      rsi: fix use-after-free on failed probe and unbind
      rsi: fix use-after-free on probe errors
      rsi: fix memory leak on failed URB submission
      rsi: fix non-atomic allocation in completion handler

Johannes Berg (1):
      Revert "um: Enable CONFIG_CONSTRUCTORS"

Kai Vehmanen (1):
      ASoC: SOF: fix fault at driver unload after failed probe

Krzysztof Kozlowski (1):
      net: wan: sdla: Fix cast from pointer to integer of different size

Laura Abbott (1):
      usb-storage: Disable UAS on JMicron SATA enclosure

Liran Alon (1):
      net: Google gve: Remove dma_wmb() before ringing doorbell

Logan Gunthorpe (2):
      iommu/amd: Support multiple PCI DMA aliases in device table
      iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping

Lorenzo Bianconi (2):
      net: socionext: fix possible user-after-free in netsec_process_rx
      net: socionext: fix xdp_result initialization in netsec_process_rx

Lubomir Rintel (1):
      component: do not dereference opaque pointer in debugfs

Lukas Wunner (1):
      serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley (3):
      staging: vt6656: correct packet types for CTS protect, mode.
      staging: vt6656: use NULLFUCTION stack on mac80211
      staging: vt6656: Fix false Tx excessive retries reporting.

Marcel Holtmann (1):
      Bluetooth: Allow combination of BDADDR_PROPERTY and INVALID_BDADDR qu=
irks

Martin Fuzzey (1):
      binder: fix log spam for existing debugfs file creation.

Olivier Moysan (1):
      iio: adc: stm32-dfsdm: fix single conversion

Pacien TRAN-GIRARD (1):
      platform/x86: dell-laptop: disable kbd backlight on Inspiron 10xx

Pan Zhang (1):
      drivers/hid/hid-multitouch.c: fix a possible null pointer access.

Paul Cercueil (2):
      usb: musb: jz4740: Silence error if code is -EPROBE_DEFER
      power/supply: ingenic-battery: Don't change scale if there's only one

Paulo Alcantara (SUSE) (1):
      cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Pavel Balan (1):
      HID: Add quirk for incorrect input length on Lenovo Y720

Peter Robinson (1):
      usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: hda: hda-dai: fix oops on hda_link .hw_free

Priit Laes (1):
      HID: Add quirk for Xin-Mo Dual Controller

Qian Cai (1):
      iommu/dma: fix variable 'cookie' set but not used

Randy Dunlap (1):
      arc: eznps: fix allmodconfig kconfig warning

Raul E Rangel (1):
      mmc: sdhci-pci: Quirk for AMD SDHC Device 0x7906

Rodrigo Rivas Costa (1):
      HID: steam: Fix input device disappearing

Ronnie Sahlberg (1):
      cifs: set correct max-buffer-size for smb2_ioctl_init()

Russell King (1):
      watchdog: orion: fix platform_get_irq() complaints

Sam McNally (1):
      ASoC: Intel: cht_bsw_rt5645: Add quirk for boards using pmc_plt_clk_0

Sean Nyekjaer (1):
      can: tcan4x5x: tcan4x5x_parse_config(): reset device before register =
access

Sergio Paracuellos (1):
      staging: mt7621-pci: add quirks for 'E2' revision using 'soc_device_a=
ttribute'

Slawomir Pawlowski (1):
      PCI: Add DMA alias quirk for Intel VCA NTB

Srinivas Pandruvada (1):
      HID: intel-ish-hid: ipc: Add Tiger Lake PCI device ID

Stephen Worley (1):
      net: include struct nhmsg size in nh nlmsg size

Thomas Anderson (1):
      drm/amd/display: Reduce HDMI pixel encoding if max clock is exceeded

Thomas Hebb (2):
      usb: typec: wcove: fix "op-sink-microwatt" default that was in mW
      usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW

Thomas Voegtle (1):
      media: dvbsky: add support for eyeTV Geniatech T2 lite

Tomas Winkler (2):
      mei: hdcp: bind only with i915 on the same PCH
      mei: me: add comet point (lake) H device ids

Tony Lindgren (5):
      phy: cpcap-usb: Prevent USB line glitches from waking up modem
      bus: ti-sysc: Handle mstandby quirk and use it for musb
      bus: ti-sysc: Use swsup quirks also for am335x musb
      bus: ti-sysc: Add module enable quirk for audio AESS
      bus: ti-sysc: Fix missing force mstandby quirk handling

Uwe Kleine-K=F6nig (1):
      serial: imx: fix a race condition in receive path

Vincent Whitchurch (1):
      CIFS: Fix task struct use-after-free on reconnect

Willem de Bruijn (1):
      udp: segment looped gso packets correctly

Yauhen Kharuzhy (1):
      extcon-intel-cht-wc: Don't reset USB data connection at probe

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl41S14ACgkQONu9yGCS
aT5pdQ//QIaRVHayBi7syVglubnlNboKUUEvhwu6cuO5k2ff2b0Yusz5ZTuaddxc
CWKKGsOjTCbbwMkKX3NMxhaLUD82+CRm3ijE2FxcipjVmDOOUCheID0vauPKu0lr
aViGVVHfJ4ECVHQdu1GZK6do46GgPXf790f2Zz+pbGSgEAzT1Dda87A1zrqcbnb/
lZx5Yfk7NXZ+JXSJ+uozaf80Fj+qLJMkfuKZP6Nr+MtRYAgCqt/TwPCxjDPUaNsI
XCw/CSKTIH25QUidRAxC0eOBIHbG7NojRugadCvFRmPtaPP4WeIU5NJZiCH7J6Pz
a34iDWaPXm1rCUaAxY9TFhStf83d4IWUa1JwMkYEKnOP3T0dAVzxjADqZb8Bbh6B
JmEBojZJmf2VFVQ1qPP/tHIS+wlT0JsaEttOOE+xRNl3qseb2HwSKkQ2KodSf2zY
3p+HPhUPBaE8yf2hVpfg1T/QTDt0YH6D5QhKzhMb8IWmeLWr9t8fTC9rsOj3mFMx
XBh4oQ3GG2qWFRJ1sJUcwNVTxg2LQMZIEcxu47ZwN6cNE+ZnrZ/r+TUyh75t5XrH
tOHPxVNx5qntTOw2WxlI4aQReEY1Psk7EzfznceWRElAogsoJw2hIsGGJSzbd1V6
1ugsKAozNl9I0CshKFyjbl5K6k3LXoug3TA5XtGR6HlNlHrcnkg=
=1V6h
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
