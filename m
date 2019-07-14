Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94F767E1B
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 09:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfGNHSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 03:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfGNHSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 03:18:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECA8F2089C;
        Sun, 14 Jul 2019 07:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563088728;
        bh=BKNdIRHyF9UVDUUcsabRAT3ObdcQYtbxLK3pqrSO+Ns=;
        h=Date:From:To:Cc:Subject:From;
        b=Er2OyCu3sg+yCuCGWAoJF8dCEh4ZLb8ko8BROFVrb+1CzSNcwZ8Doo98jM3MnIwJB
         zgdOE/yjCkik1mNCeO6Wq0l3lgmsgMNlzdm5nbH57mTSEWwjHLIxChwU7/FxSCko5X
         tA732nB2jZXc7OIyZpGwj56bKLKYgLlCseWUuJXQ=
Date:   Sun, 14 Jul 2019 09:18:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.18
Message-ID: <20190714071845.GA29660@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.18 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-class-net-qmi                      |    4=
=20
 Documentation/admin-guide/hw-vuln/index.rst                        |    1=
=20
 Documentation/admin-guide/hw-vuln/spectre.rst                      |  697 =
++++++++++
 Documentation/admin-guide/kernel-parameters.txt                    |    6=
=20
 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt    |    1=
=20
 Documentation/userspace-api/spec_ctrl.rst                          |    2=
=20
 Makefile                                                           |    2=
=20
 arch/arm/boot/dts/am335x-pcm-953.dtsi                              |    2=
=20
 arch/arm/boot/dts/am335x-wega.dtsi                                 |    2=
=20
 arch/arm/boot/dts/dra7-l4.dtsi                                     |    2=
=20
 arch/arm/mach-davinci/board-da850-evm.c                            |    2=
=20
 arch/arm/mach-davinci/devices-da8xx.c                              |    3=
=20
 arch/powerpc/include/asm/page.h                                    |    7=
=20
 arch/powerpc/mm/mem.c                                              |    3=
=20
 arch/powerpc/platforms/powermac/Kconfig                            |    1=
=20
 arch/riscv/configs/defconfig                                       |    4=
=20
 arch/riscv/lib/delay.c                                             |    2=
=20
 arch/riscv/net/bpf_jit_comp.c                                      |   24=
=20
 arch/s390/Makefile                                                 |    1=
=20
 arch/x86/kernel/ptrace.c                                           |    5=
=20
 arch/x86/kernel/tls.c                                              |    9=
=20
 arch/x86/kvm/vmx/nested.c                                          |    4=
=20
 arch/x86/net/bpf_jit_comp.c                                        |   74 -
 block/bfq-iosched.c                                                |    1=
=20
 crypto/lrw.c                                                       |    2=
=20
 drivers/android/binder.c                                           |  157 =
+-
 drivers/android/binder_alloc.c                                     |   44=
=20
 drivers/android/binder_alloc.h                                     |   22=
=20
 drivers/char/tpm/tpm-chip.c                                        |    6=
=20
 drivers/char/tpm/tpm1-cmd.c                                        |    7=
=20
 drivers/char/tpm/tpm2-cmd.c                                        |    7=
=20
 drivers/crypto/talitos.c                                           |   16=
=20
 drivers/gpu/drm/drm_bufs.c                                         |    5=
=20
 drivers/gpu/drm/drm_ioc32.c                                        |    5=
=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                |    3=
=20
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c                         |   10=
=20
 drivers/gpu/ipu-v3/ipu-image-convert.c                             |   40=
=20
 drivers/hid/hid-ids.h                                              |    1=
=20
 drivers/hid/hid-quirks.c                                           |    1=
=20
 drivers/iio/adc/stm32-adc-core.c                                   |   21=
=20
 drivers/infiniband/hw/hfi1/hfi.h                                   |   31=
=20
 drivers/infiniband/hw/hfi1/pio.c                                   |   21=
=20
 drivers/infiniband/hw/hfi1/rc.c                                    |   53=
=20
 drivers/infiniband/hw/hfi1/sdma.c                                  |   17=
=20
 drivers/infiniband/hw/hfi1/ud.c                                    |    4=
=20
 drivers/infiniband/hw/hfi1/verbs.c                                 |   14=
=20
 drivers/infiniband/hw/hfi1/verbs.h                                 |    1=
=20
 drivers/input/keyboard/imx_keypad.c                                |   18=
=20
 drivers/input/mouse/elantech.c                                     |    2=
=20
 drivers/md/md.c                                                    |   36=
=20
 drivers/media/dvb-frontends/stv0297.c                              |    2=
=20
 drivers/misc/lkdtm/Makefile                                        |    3=
=20
 drivers/misc/vmw_vmci/vmci_context.c                               |   80 -
 drivers/misc/vmw_vmci/vmci_handle_array.c                          |   38=
=20
 drivers/misc/vmw_vmci/vmci_handle_array.h                          |   29=
=20
 drivers/mmc/core/mmc.c                                             |    6=
=20
 drivers/net/can/flexcan.c                                          |    3=
=20
 drivers/net/can/m_can/m_can.c                                      |   21=
=20
 drivers/net/can/spi/Kconfig                                        |    5=
=20
 drivers/net/can/spi/mcp251x.c                                      |   25=
=20
 drivers/net/dsa/mv88e6xxx/global1_vtu.c                            |    2=
=20
 drivers/net/ethernet/8390/Kconfig                                  |    2=
=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                |    3=
=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                   |    1=
=20
 drivers/net/ethernet/cavium/liquidio/lio_core.c                    |    2=
=20
 drivers/net/ethernet/ibm/ibmvnic.c                                 |   19=
=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h                          |    2=
=20
 drivers/net/phy/Kconfig                                            |    2=
=20
 drivers/net/phy/Makefile                                           |    2=
=20
 drivers/net/phy/asix.c                                             |   57=
=20
 drivers/net/phy/ax88796b.c                                         |   57=
=20
 drivers/net/usb/qmi_wwan.c                                         |   27=
=20
 drivers/net/wireless/ath/carl9170/usb.c                            |   39=
=20
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                       |    1=
=20
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h                      |    7=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                        |   23=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                  |    2=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                       |    2=
=20
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                       |   17=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h                 |    2=
=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                    |   50=
=20
 drivers/net/wireless/intersil/p54/p54usb.c                         |   43=
=20
 drivers/net/wireless/intersil/p54/txrx.c                           |    5=
=20
 drivers/net/wireless/marvell/mwifiex/fw.h                          |   12=
=20
 drivers/net/wireless/marvell/mwifiex/ie.c                          |   47=
=20
 drivers/net/wireless/marvell/mwifiex/scan.c                        |   31=
=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                   |    4=
=20
 drivers/net/wireless/marvell/mwifiex/wmm.c                         |    2=
=20
 drivers/scsi/qedi/qedi_main.c                                      |    3=
=20
 drivers/soc/bcm/brcmstb/biuctrl.c                                  |    6=
=20
 drivers/soundwire/intel.c                                          |    4=
=20
 drivers/soundwire/stream.c                                         |    7=
=20
 drivers/staging/comedi/drivers/amplc_pci230.c                      |    3=
=20
 drivers/staging/comedi/drivers/dt282x.c                            |    3=
=20
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c                            |    1=
=20
 drivers/staging/iio/cdc/ad7150.c                                   |   19=
=20
 drivers/staging/mt7621-pci/pci-mt7621.c                            |    2=
=20
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                      |  157 =
+-
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c      |   43=
=20
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c          |   32=
=20
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h          |    3=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    2=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c      |   21=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c     |   31=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_util.c     |    6=
=20
 drivers/staging/wilc1000/wilc_netdev.c                             |   12=
=20
 drivers/tty/serial/8250/8250_port.c                                |    3=
=20
 drivers/usb/dwc2/core.c                                            |    2=
=20
 drivers/usb/gadget/function/f_fs.c                                 |    3=
=20
 drivers/usb/gadget/function/u_ether.c                              |    6=
=20
 drivers/usb/renesas_usbhs/fifo.c                                   |   34=
=20
 drivers/usb/serial/ftdi_sio.c                                      |    1=
=20
 drivers/usb/serial/ftdi_sio_ids.h                                  |    6=
=20
 drivers/usb/serial/option.c                                        |    1=
=20
 drivers/usb/typec/tps6598x.c                                       |    6=
=20
 fs/crypto/policy.c                                                 |    2=
=20
 fs/nfs/nfs4proc.c                                                  |   20=
=20
 fs/quota/dquot.c                                                   |    4=
=20
 fs/udf/inode.c                                                     |   93 -
 include/linux/skmsg.h                                              |    2=
=20
 include/linux/vmw_vmci_defs.h                                      |   11=
=20
 include/net/ip6_tunnel.h                                           |    9=
=20
 include/uapi/linux/usb/audio.h                                     |   37=
=20
 kernel/bpf/devmap.c                                                |    9=
=20
 net/can/af_can.c                                                   |   24=
=20
 net/core/skbuff.c                                                  |    1=
=20
 net/ipv6/netfilter/nf_conntrack_reasm.c                            |   22=
=20
 net/mac80211/ieee80211_i.h                                         |    9=
=20
 net/mac80211/mesh.c                                                |    6=
=20
 net/mac80211/util.c                                                |    4=
=20
 net/wireless/pmsr.c                                                |    4=
=20
 net/wireless/util.c                                                |    4=
=20
 net/xdp/xdp_umem.c                                                 |   11=
=20
 samples/bpf/bpf_load.c                                             |    2=
=20
 samples/bpf/task_fd_query_user.c                                   |    2=
=20
 sound/pci/hda/patch_realtek.c                                      |    2=
=20
 sound/usb/mixer.c                                                  |   16=
=20
 tools/bpf/bpftool/map.c                                            |    2=
=20
 tools/perf/Documentation/intel-pt.txt                              |   10=
=20
 tools/perf/util/auxtrace.c                                         |    3=
=20
 tools/perf/util/header.c                                           |    1=
=20
 tools/perf/util/intel-pt.c                                         |    3=
=20
 tools/perf/util/pmu.c                                              |   28=
=20
 tools/perf/util/thread-stack.c                                     |   30=
=20
 tools/testing/selftests/bpf/verifier/div_overflow.c                |   14=
=20
 virt/kvm/arm/arch_timer.c                                          |    5=
=20
 virt/kvm/arm/vgic/vgic-its.c                                       |    1=
=20
 147 files changed, 2085 insertions(+), 801 deletions(-)

Aaron Ma (1):
      Input: elantech - enable middle button support on 2 ThinkPads

Adrian Hunter (4):
      perf intel-pt: Fix itrace defaults for perf script
      perf auxtrace: Fix itrace defaults for perf script
      perf intel-pt: Fix itrace defaults for perf script intel-pt documenta=
tion
      perf thread-stack: Fix thread stack return from kernel for kernel-onl=
y case

Ajay Singh (1):
      staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

Alan Stern (1):
      p54usb: Fix race between disconnect and firmware loading

Alexei Starovoitov (1):
      bpf, x64: fix stack layout of JITed bpf code

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1

Andrew Jones (1):
      KVM: arm/arm64: Fix emulated ptimer irq injection

Andy Lutomirski (1):
      Documentation/admin: Remove the vsyscall=3Dnative documentation

Anson Huang (1):
      Input: imx_keypad - make sure keyboard can always wake up system

Arnd Bergmann (1):
      staging: rtl8712: reduce stack usage, again

Avraham Stern (1):
      cfg80211: report measurement start TSF correctly

Bartosz Golaszewski (2):
      ARM: davinci: da850-evm: call regulator_has_full_constraints()
      ARM: davinci: da8xx: specify dma_coherent_mask for lcdc

Benjamin Coddington (1):
      NFS4: Only set creation opendata if O_CREAT

Bj=F6rn T=F6pel (1):
      bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32

Brian Norris (1):
      mwifiex: Don't abort on small, spec-compliant vendor IEs

Chang-Hsien Tsai (1):
      samples, bpf: fix to change the buffer size for read()

Christian Lamparter (2):
      p54: fix crash during initialization
      carl9170: fix misuse of device driver API

Christoph Hellwig (1):
      powerpc: enable a 30-bit ZONE_DMA for 32-bit pmac

Christophe Leroy (1):
      crypto: talitos - rename alternative AEAD algos.

Colin Ian King (2):
      net: lio_core: fix potential sign-extension overflow on large shift
      staging: fsl-dpaa2/ethsw: fix memory leak of switchdev_work

Dan Carpenter (1):
      drm: return -EFAULT if copy_to_user() fails

Dave Martin (1):
      KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Dave Stevenson (4):
      staging: bcm2835-camera: Replace spinlock protecting context_map with=
 mutex
      staging: bcm2835-camera: Ensure all buffers are returned on disable
      staging: bcm2835-camera: Remove check of the number of buffers suppli=
ed
      staging: bcm2835-camera: Handle empty EOS buffers whilst streaming

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Douglas Anderson (1):
      block, bfq: NULL out the bic when it's no longer valid

Emmanuel Grumbach (1):
      iwlwifi: fix load in rfkill flow for unified firmware

Eric Biggers (1):
      crypto: lrw - use correct alignmask

Eugen Hristev (1):
      can: m_can: implement errata "Needless activation of MRAF irq"

Fabio Estevam (1):
      can: flexcan: Remove unneeded registration message

Fabrice Gasnier (1):
      iio: adc: stm32-adc: add missing vdda-supply

Fei Yang (1):
      usb: gadget: f_fs: data_len used before properly set

Florian Fainelli (2):
      soc: brcmstb: Fix error path for unsupported CPUs
      soc: bcm: brcmstb: biuctrl: Register writes require a barrier

Greg Kroah-Hartman (1):
      Linux 5.1.18

Guillaume Nault (2):
      netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
      netfilter: ipv6: nf_defrag: accept duplicate fragments again

Heiko Carstens (1):
      s390/boot: disable address-of-packed-member warning

Hongjie Fang (1):
      fscrypt: don't set policy for a dead directory

Ian Abbott (2):
      staging: comedi: dt282x: fix a null pointer deref on interrupt
      staging: comedi: amplc_pci230: fix null pointer deref on interrupt

Ido Schimmel (1):
      mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Ilya Maximets (1):
      xdp: check device pointer before clearing

Jakub Sitnicki (1):
      bpf: sockmap, restore sk_write_space when psock gets dropped

Jia-Ju Bai (1):
      iwlwifi: Fix double-free problems in iwl_req_fw_callback()

John Crispin (1):
      mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()

John Fastabend (1):
      bpf: sockmap, fix use after free from sleep in psock backlog workqueue

John Garry (1):
      perf pmu: Fix uncore PMU alias list for ARM64

J=F6rgen Storvist (1):
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Kailang Yang (1):
      ALSA: hda/realtek - Headphone Mic can't record after S3

Kees Cook (1):
      tpm: Actually fail on TPM errors during "get random"

Kevin Hilman (1):
      RISC-V: defconfig: enable clocks, serial console

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Krzesimir Nowak (1):
      tools: bpftool: Fix JSON output when lookup fails

Luke Nelson (1):
      bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh

Mariusz Tkaczyk (1):
      md: fix for divide error in status_resync

Martin Blumenstingl (1):
      usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()

Matt Chen (1):
      iwlwifi: fix AX201 killer sku loading firmware issue

Matteo Croce (1):
      samples, bpf: suppress compiler warning

Mauro Carvalho Chehab (1):
      media: stv0297: fix frequency range limit

Mauro S. M. Rodrigues (1):
      bnx2x: Check if transceiver implements DDM before access

Melissa Wen (1):
      staging:iio:ad7150: fix threshold mode config bit

Michael Schmitz (1):
      net: phy: rename Asix Electronics PHY driver

Mike Marciniszyn (5):
      IB/hfi1: Create inline to get extended headers
      IB/hfi1: Use aborts to trigger RC throttling
      IB/hfi1: Wakeup QPs orphaned on wait list after flush
      IB/hfi1: Handle wakeup of orphaned QPs for pio
      IB/hfi1: Handle port down properly in pio

Mordechay Goodstein (1):
      cfg80211: util: fix bit count off by one

Naftali Goldstein (1):
      mac80211: do not start any work during reconfigure flow

Naveen N. Rao (1):
      bpf: fix div64 overflow tests to properly detect errors

Nick Desaulniers (1):
      lkdtm: support llvm-objcopy

Nick Hu (1):
      riscv: Fix udelay in RV32.

Nicolas Saenz Julienne (3):
      staging: vchiq_2835_arm: revert "quit using custom down_interruptible=
()"
      staging: vchiq: revert "switch to wait_for_completion_killable"
      staging: vchiq: make wait events interruptible

Nikolaus Voss (2):
      drivers/usb/typec/tps6598x.c: fix portinfo width
      drivers/usb/typec/tps6598x.c: fix 4CC cmd write

Nilesh Javali (1):
      scsi: qedi: Check targetname while finding boot target information

Oliver Barta (1):
      Revert "serial: 8250: Don't service RX FIFO if interrupts are disable=
d"

Pradeep Kumar Chitrapu (1):
      mac80211: free peer keys before vif down in mesh

Qian Cai (1):
      drm/vmwgfx: fix a warning due to missing dma_parms

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: fix shift of FID bits in mv88e6185_g1_vtu_loadpu=
rge()

Reinhard Speyerer (3):
      qmi_wwan: add support for QMAP padding in the RX path
      qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
      qmi_wwan: extend permitted QMAP mux_id value range

Sean Nyekjaer (2):
      dt-bindings: can: mcp251x: add mcp25625 support
      can: mcp251x: add support for mcp25625

Sebastian Parschauer (1):
      HID: Add another Primax PIXART OEM mouse quirk

Sergio Paracuellos (1):
      staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro

Shahar S Matityahu (1):
      iwlwifi: clear persistence bit according to device family

Song Liu (1):
      perf header: Assign proper ff->ph in perf_event__synthesize_features()

Srinivas Kandagatla (3):
      soundwire: stream: fix out of boundary access on port properties
      soundwire: stream: fix bad unlock balance
      soundwire: intel: set dai min and max channels correctly

Steve Longerbeam (3):
      gpu: ipu-v3: image-convert: Fix input bytesperline width/height align
      gpu: ipu-v3: image-convert: Fix input bytesperline for packed formats
      gpu: ipu-v3: image-convert: Fix image downsize coefficients

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Takashi Iwai (4):
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
      ALSA: usb-audio: Fix parse of UAC2 Extension Units
      mwifiex: Abort at too short BSS descriptor element

Teresa Remmet (1):
      ARM: dts: am335x phytec boards: Fix cd-gpios active level

Thomas Falcon (3):
      ibmvnic: Do not close unopened driver during reset
      ibmvnic: Refresh device multicast list after reset
      ibmvnic: Fix unchecked return codes of memory allocations

Thomas Hellstrom (1):
      drm/vmwgfx: Honor the sg list segment size limitation

Thomas Pedersen (1):
      mac80211: mesh: fix RCU warning

Tim Chen (1):
      Documentation: Add section about CPU vulnerabilities for Spectre

Todd Kjos (2):
      binder: fix memory leak in error path
      binder: return errors from buffer copy functions

Tony Lindgren (1):
      ARM: dts: Drop bogus CLKSEL for timer12 on dra7

Toshiaki Makita (3):
      bpf, devmap: Fix premature entry free on destroying map
      bpf, devmap: Add missing bulk queue free
      bpf, devmap: Add missing RCU read lock on flush

Vadim Sukhomlinov (1):
      tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays

Vitaly Kuznetsov (1):
      KVM: nVMX: use correct clean fields when copying from eVMCS

Wolfram Sang (1):
      mmc: core: complete HS400 before checking status

Xin Long (1):
      ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL

Yibo Zhao (1):
      mac80211: only warn once on chanctx_conf being NULL

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: add a workaround for a race condition of workqueue

YueHaibing (1):
      can: af_can: Fix error path of can_init()

yangerkun (1):
      quota: fix a problem about transfer quota


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0q11UACgkQONu9yGCS
aT5yXxAAkyz6W4EjkJGNVm9P+zaPVrhhA5ZpO2hFUmLRYtiLEcFglkgGnTRuV2EV
//I6UrBk8uPE3jQCgQMHbOrG7Yux+ZKvuCPIrXb+isfCv1DYk6C7oBZVOqksIZyx
+1QM0+BL7pPdDxr2orks8iJ1jRQfBxsfu7khYeuI/QHA4AjbEhr6SjzKcTYfNwu6
PWQ3GCbDQyXy1yLpBAFXhWMN6PzFZ5D6f3fP8cL5La7rPgTqjUDKlmF+yjHUyMeb
3wQvmgg9EL5yF+1Duia2nCZo+tMIOeeDbpUnHNylZ57iIBSh3TlVAGMDAtNntJ33
eo2RLNTeAoe0haZHCg6VKxRX2zB14Wcs4vMzksyvhQTbHOHt6HxTOREH+ri1dgCG
inOGMTpk+xRLWj29ifw++OUqroaA3HKeiKP51X3HNvoEih7+0bnsRXkaV3sYvzwJ
4Dg57Pbk9D8xFdolJdBkijVvIEUbAkNU2i/izu+mgtR6rXRTHz2CK5wqXOFY4Zbl
mGusVekb92cOWKCB1Mr+sqMrHlMti9VRmkpi9arQ50JhooVylIc4kCpnXjos3C/+
vcY9gF8vopkNPhe+YEStmnB+10WaX6ejT8mGOW31pcg+GMbio/NZQxySORmPP8bS
dnI7LL8bPjFQVPKMbhmtdYFBynFjwOKWv8YFo/2ojugmNPRQd+k=
=2qf5
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
