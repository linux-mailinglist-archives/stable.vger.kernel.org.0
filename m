Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6031BE622
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgD2SVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 14:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2SVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 14:21:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5E72068E;
        Wed, 29 Apr 2020 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588184468;
        bh=gSvKCWwgMOZ5pS+eD/qqwInVZ6dZoC2MNYPokm/j6GE=;
        h=Date:From:To:Cc:Subject:From;
        b=INCGMG28YUoLt1jpmZb9WslPj9FtLJUfwITgblrtIL6dUlo5fhQRt1mjYgvKO44Kc
         rexr05kXM9MlNpwEwrffUsBmHTNuYef8XKQmomCFTcVLsAm/fVLppGqEUB0pjGN6NC
         0aWfs8KRan/DMDYZG8yszi/RzAoquwwOZM8DqPRs=
Date:   Wed, 29 Apr 2020 20:21:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.36
Message-ID: <20200429182105.GA2338521@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.36 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt             |    3=20
 Documentation/arm64/silicon-errata.rst                      |    2=20
 Makefile                                                    |    2=20
 arch/arm/mach-imx/Makefile                                  |    2=20
 arch/arm64/Kconfig                                          |   16=20
 arch/arm64/include/asm/cache.h                              |    3=20
 arch/arm64/include/asm/compat.h                             |    5=20
 arch/arm64/include/asm/cpucaps.h                            |    3=20
 arch/arm64/kernel/cpu_errata.c                              |   32 +
 arch/arm64/kernel/sys_compat.c                              |   11=20
 arch/arm64/kernel/traps.c                                   |    9=20
 arch/powerpc/kernel/entry_32.S                              |    2=20
 arch/powerpc/kernel/setup_64.c                              |    2=20
 arch/powerpc/kernel/time.c                                  |   44 --
 arch/powerpc/platforms/Kconfig.cputype                      |    2=20
 arch/powerpc/platforms/pseries/ras.c                        |   11=20
 arch/s390/kvm/kvm-s390.c                                    |    3=20
 arch/s390/lib/uaccess.c                                     |    4=20
 arch/s390/mm/pgalloc.c                                      |   16=20
 arch/x86/kvm/vmx/vmx.c                                      |    2=20
 drivers/block/loop.c                                        |   42 +-
 drivers/block/virtio_blk.c                                  |    9=20
 drivers/char/tpm/tpm-interface.c                            |    2=20
 drivers/char/tpm/tpm_ibmvtpm.c                              |  136 +++----
 drivers/char/tpm/tpm_tis_core.c                             |    8=20
 drivers/fpga/dfl-pci.c                                      |    6=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |   38 +-
 drivers/iio/adc/stm32-adc.c                                 |   31 +
 drivers/iio/adc/ti-ads8344.c                                |    6=20
 drivers/iio/adc/xilinx-xadc-core.c                          |   95 +++--
 drivers/iio/common/st_sensors/st_sensors_core.c             |    2=20
 drivers/net/dsa/b53/b53_common.c                            |   38 +-
 drivers/net/dsa/b53/b53_regs.h                              |    8=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    3=20
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c              |   27 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c              |   27 -
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                |    3=20
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                  |   14=20
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c    |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c          |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c      |    4=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c         |    1=20
 drivers/net/geneve.c                                        |    2=20
 drivers/net/macsec.c                                        |   12=20
 drivers/net/macvlan.c                                       |    2=20
 drivers/net/team/team.c                                     |    4=20
 drivers/net/vrf.c                                           |   10=20
 drivers/net/vxlan.c                                         |    6=20
 drivers/net/wireless/intel/iwlegacy/3945-rs.c               |    2=20
 drivers/net/wireless/intel/iwlegacy/4965-rs.c               |    2=20
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c                 |    2=20
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h             |    6=20
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c          |    6=20
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c                 |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                 |   13=20
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                |    9=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c           |    3=20
 drivers/net/wireless/realtek/rtlwifi/rc.c                   |    2=20
 drivers/nvme/host/core.c                                    |   27 +
 drivers/nvme/host/multipath.c                               |    4=20
 drivers/nvme/host/tcp.c                                     |   13=20
 drivers/pci/hotplug/pciehp.h                                |    6=20
 drivers/pci/hotplug/pciehp_core.c                           |   11=20
 drivers/pci/hotplug/pciehp_ctrl.c                           |    4=20
 drivers/pci/hotplug/pciehp_hpc.c                            |   59 ++-
 drivers/pci/pci-driver.c                                    |   11=20
 drivers/pci/pci.c                                           |  142 +++++++
 drivers/pci/pci.h                                           |    1=20
 drivers/pci/pcie/aspm.c                                     |   18=20
 drivers/pwm/pwm-bcm2835.c                                   |    1=20
 drivers/pwm/pwm-rcar.c                                      |   10=20
 drivers/pwm/pwm-renesas-tpu.c                               |    9=20
 drivers/s390/cio/device.c                                   |   13=20
 drivers/s390/cio/vfio_ccw_drv.c                             |    5=20
 drivers/scsi/libfc/fc_rport.c                               |    8=20
 drivers/scsi/lpfc/lpfc_nvme.c                               |   14=20
 drivers/scsi/lpfc/lpfc_sli.c                                |    7=20
 drivers/scsi/scsi_transport_iscsi.c                         |    4=20
 drivers/scsi/smartpqi/smartpqi.h                            |   10=20
 drivers/scsi/smartpqi/smartpqi_init.c                       |  225 ++++++-=
-----
 drivers/scsi/smartpqi/smartpqi_sas_transport.c              |    2=20
 drivers/staging/comedi/comedi_fops.c                        |    4=20
 drivers/staging/comedi/drivers/dt2815.c                     |    3=20
 drivers/staging/gasket/gasket_sysfs.c                       |    3=20
 drivers/staging/gasket/gasket_sysfs.h                       |    4=20
 drivers/staging/vt6656/int.c                                |    3=20
 drivers/staging/vt6656/key.c                                |   14=20
 drivers/staging/vt6656/main_usb.c                           |   31 -
 drivers/tty/hvc/hvc_console.c                               |   23 -
 drivers/tty/rocket.c                                        |   25 -
 drivers/tty/serial/owl-uart.c                               |    7=20
 drivers/tty/serial/sh-sci.c                                 |   13=20
 drivers/tty/serial/xilinx_uartps.c                          |  211 ++-----=
----
 drivers/tty/vt/vt.c                                         |    7=20
 drivers/usb/class/cdc-acm.c                                 |   36 +
 drivers/usb/class/cdc-acm.h                                 |    5=20
 drivers/usb/core/hub.c                                      |   18=20
 drivers/usb/core/message.c                                  |    9=20
 drivers/usb/core/quirks.c                                   |    4=20
 drivers/usb/dwc3/gadget.c                                   |   12=20
 drivers/usb/early/xhci-dbc.c                                |    8=20
 drivers/usb/early/xhci-dbc.h                                |   18=20
 drivers/usb/gadget/function/f_fs.c                          |    4=20
 drivers/usb/host/xhci-hub.c                                 |   70 +++
 drivers/usb/host/xhci-mem.c                                 |    1=20
 drivers/usb/host/xhci-ring.c                                |   47 ++
 drivers/usb/host/xhci.c                                     |   14=20
 drivers/usb/host/xhci.h                                     |    6=20
 drivers/usb/misc/sisusbvga/sisusb.c                         |   20 -
 drivers/usb/misc/sisusbvga/sisusb_init.h                    |   14=20
 drivers/usb/storage/uas.c                                   |   46 ++
 drivers/usb/storage/unusual_devs.h                          |    7=20
 drivers/usb/typec/bus.c                                     |    5=20
 drivers/usb/typec/tcpm/tcpm.c                               |   26 +
 drivers/watchdog/watchdog_dev.c                             |    1=20
 fs/ceph/caps.c                                              |    8=20
 fs/ceph/export.c                                            |    5=20
 fs/cifs/smb2ops.c                                           |    5=20
 fs/coredump.c                                               |    2=20
 fs/ext4/extents.c                                           |   47 +-
 fs/f2fs/xattr.c                                             |   14=20
 fs/nfsd/nfs4callback.c                                      |    4=20
 fs/proc/vmcore.c                                            |    5=20
 include/linux/iio/iio.h                                     |    2=20
 include/linux/kvm_host.h                                    |    2=20
 include/linux/vmalloc.h                                     |    2=20
 include/net/mac80211.h                                      |    4=20
 include/net/tcp.h                                           |    2=20
 ipc/util.c                                                  |    2=20
 kernel/audit.c                                              |    3=20
 kernel/dma/direct.c                                         |    3=20
 kernel/events/core.c                                        |    9=20
 kernel/gcov/fs.c                                            |    2=20
 kernel/signal.c                                             |    6=20
 lib/raid6/test/Makefile                                     |    6=20
 mm/hugetlb.c                                                |   14=20
 mm/ksm.c                                                    |   12=20
 mm/vmalloc.c                                                |   16=20
 net/ipv4/fib_semantics.c                                    |    6=20
 net/ipv4/ip_tunnel.c                                        |    6=20
 net/ipv4/xfrm4_output.c                                     |    2=20
 net/ipv6/ipv6_sockglue.c                                    |   13=20
 net/ipv6/xfrm6_output.c                                     |    2=20
 net/mac80211/main.c                                         |    5=20
 net/mac80211/rate.c                                         |   15=20
 net/mac80211/rate.h                                         |   23 +
 net/mac80211/rc80211_minstrel_ht.c                          |   19 -
 net/netrom/nr_route.c                                       |    1=20
 net/openvswitch/conntrack.c                                 |    3=20
 net/openvswitch/datapath.c                                  |    4=20
 net/sched/sch_etf.c                                         |    7=20
 net/sunrpc/svc_xprt.c                                       |    2=20
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c                  |    2=20
 net/sunrpc/xprtsock.c                                       |    1=20
 net/x25/x25_dev.c                                           |    4=20
 samples/vfio-mdev/mdpy.c                                    |    2=20
 scripts/kconfig/qconf.cc                                    |   13=20
 security/keys/internal.h                                    |   12=20
 security/keys/keyctl.c                                      |   58 ++-
 sound/pci/hda/hda_intel.c                                   |    1=20
 sound/pci/hda/patch_hdmi.c                                  |    9=20
 sound/pci/hda/patch_realtek.c                               |   11=20
 sound/soc/intel/atom/sst-atom-controls.c                    |    2=20
 sound/soc/intel/boards/bytcr_rt5640.c                       |   11=20
 sound/soc/soc-dapm.c                                        |   20 -
 sound/soc/sof/trace.c                                       |    7=20
 sound/usb/format.c                                          |   52 ++
 sound/usb/mixer.c                                           |   37 +
 sound/usb/mixer.h                                           |   10=20
 sound/usb/mixer_maps.c                                      |   37 +
 sound/usb/mixer_quirks.c                                    |   12=20
 sound/usb/quirks-table.h                                    |   56 ++
 sound/usb/usx2y/usbusx2yaudio.c                             |    2=20
 tools/lib/bpf/Makefile                                      |    4=20
 tools/testing/nvdimm/Kbuild                                 |    4=20
 tools/testing/nvdimm/test/Kbuild                            |    4=20
 tools/testing/nvdimm/test/nfit.c                            |    2=20
 tools/testing/selftests/ftrace/settings                     |    1=20
 tools/testing/selftests/kmod/kmod.sh                        |   13=20
 tools/testing/selftests/net/fib_nexthops.sh                 |   23 +
 tools/testing/selftests/net/fib_tests.sh                    |   10=20
 tools/vm/Makefile                                           |    2=20
 183 files changed, 1952 insertions(+), 843 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=3Dy

Alan Stern (4):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
      USB: hub: Fix handling of connect changes during sleep
      USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration =
scheme first for high speed devices")
      usb-storage: Add unusual_devs entry for JMicron JMS566

Alexander Tsoy (1):
      ALSA: usb-audio: Filter out unsupported sample rates on Focusrite dev=
ices

Alexandre Belloni (1):
      iio: adc: ti-ads8344: properly byte swap value

Amit Singh Tomar (1):
      tty: serial: owl: add "much needed" clk_prepare_enable()

Andrew Melnychenko (1):
      tty: hvc: fix buffer overflow during hvc_alloc().

Arnd Bergmann (1):
      compat: ARM64: always include asm-generic/compat.h

Aurelien Jarno (1):
      libbpf: Fix readelf output parsing on powerpc with recent binutils

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change

Catalin Marinas (1):
      arm64: Silence clang warning on mismatched value/register sizes

Changming Liu (1):
      USB: sisusbvga: Change port variable from signed to unsigned

Chris Packham (1):
      powerpc/setup_64: Set cache-line-size based on cache-block-size

Christian Borntraeger (1):
      s390/mm: fix page table upgrade vs 2ndary address mode accesses

Christophe Leroy (1):
      powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32

Chuck Lever (1):
      SUNRPC: Fix backchannel RPC soft lockups

Cornelia Huck (2):
      s390/cio: generate delayed uevent for vfio-ccw subchannels
      s390/cio: avoid duplicated 'ADD' uevents

Dan Carpenter (1):
      mlxsw: Fix some IS_ERR() vs NULL bugs

David Ahern (5):
      ipv4: Update fib_select_default to handle nexthop objects
      selftests: Fix suppress test in fib_tests.sh
      vrf: Fix IPv6 with qdisc and xfrm
      xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
      vrf: Check skb for XFRM_TRANSFORMED flag

Dmitry Monakhov (1):
      ext4: fix extent_status fragmentation for plain files

Doug Berger (1):
      net: bcmgenet: correct per TX/RX ring statistics

Eric Biggers (1):
      selftests: kmod: fix handling test numbers above 9

Eric Dumazet (3):
      net/mlx4_en: avoid indirect call in TX completion
      sched: etf: do not assume all sockets are full blown
      tcp: cache line align MAX_TCP_HEADER

Eric W. Biederman (1):
      signal: Avoid corrupting si_pid and si_uid in do_notify_parent

Evan Green (1):
      loop: Better discard support for block devices

Florian Fainelli (6):
      pwm: bcm2835: Dynamically allocate base
      net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
      net: dsa: b53: Fix valid setting for MDB entries
      net: dsa: b53: Fix ARL register definitions
      net: dsa: b53: Rework ARL bin logic
      net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL

Franti=C5=A1ek Ku=C4=8Dera (1):
      ALSA: usb-audio: Add Pioneer DJ DJM-250MK2 quirk

Ganesh Goudar (1):
      powerpc/pseries: Fix MCE handling on pseries

Geert Uytterhoeven (2):
      pwm: rcar: Fix late Runtime PM enablement
      pwm: renesas-tpu: Fix late Runtime PM enablement

George Wilson (1):
      tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

Greg Kroah-Hartman (1):
      Linux 5.4.36

Gyeongtaek Lee (1):
      ASoC: dapm: fixup dapm kcontrol widget

Halil Pasic (1):
      virtio-blk: improve virtqueue error to BLK_STS

Hans de Goede (2):
      ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_s=
lot_map()
      ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN MPWIN895CL tablet

Heiner Kallweit (1):
      PCI/ASPM: Allow re-enabling Clock PM

Ian Abbott (1):
      staging: comedi: dt2815: fix writing hi byte of analog output

Ilan Peer (1):
      iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation

Isabel Zhang (1):
      drm/amd/display: Update stream adjust in dc_stream_adjust_vmin_vmax

James Morse (3):
      arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1 #1=
542419
      arm64: Fake the IminLine size on systems affected by Neoverse-N1 #154=
2419
      arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space

James Smart (3):
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login
      scsi: lpfc: Fix crash after handling a pci error
      scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNR=
EG

Jan Kara (1):
      tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_=
PMEM_COMPAT

Jann Horn (2):
      USB: early: Handle AMD's spec-compliant identifiers, too
      vmalloc: fix remap_vmalloc_range() bounds checks

Jarkko Sakkinen (1):
      tpm/tpm_tis: Free IRQ if probing fails

Javed Hasan (1):
      scsi: libfc: If PRLI rejected, move rport to PLOGI state

Jiri Olsa (1):
      perf/core: Disable page faults when getting phys address

Jiri Slaby (1):
      tty: rocket, avoid OOB access

Johannes Berg (4):
      mac80211: populate debugfs only after cfg80211 init
      iwlwifi: pcie: actually release queue memory in TVQM
      iwlwifi: mvm: limit maximum queue appropriately
      iwlwifi: mvm: fix inactive TID removal return value usage

John Haxby (1):
      ipv6: fix restrict IPV6_ADDRFORM operation

Jonathan Cox (1):
      USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsai=
r K70 RGB RAPIDFIRE

Kai Vehmanen (1):
      ASoC: SOF: trace: fix unconditional free in trace release

Kai-Heng Feng (2):
      xhci: Ensure link state is U3 after setting USB_SS_PORT_LS_U3
      xhci: Wait until link state trainsits to U0 after setting USB_SS_PORT=
_LS_U0

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC245

Kazuhiro Fujita (1):
      serial: sh-sci: Make sure status register SCxSR is read in correct se=
quence

Kevin Barnett (2):
      scsi: smartpqi: fix controller lockup observed during force reboot
      scsi: smartpqi: fix problem with unique ID for physical device

Kishon Vijay Abraham I (1):
      dma-direct: fix data truncation in dma_direct_get_required_mask()

Lars Engebretsen (1):
      iio: core: remove extra semi-colon from devm_iio_device_register() ma=
cro

Lars-Peter Clausen (4):
      iio: xilinx-xadc: Fix ADC-B powerdown
      iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
      iio: xilinx-xadc: Fix sequencer configuration for aux channels in sim=
ultaneous mode
      iio: xilinx-xadc: Make sure not exceed maximum samplerate

Lary Gibaud (1):
      iio: st_sensors: rely on odr mask to know if odr can be set

Longpeng (1):
      mm/hugetlb: fix a addressing exception caused by huge_pte_offset

Lucas Stach (1):
      tools/vm: fix cross-compile build

Luis Mendes (1):
      staging: gasket: Fix incongruency in handling of sysfs entries creati=
on

Malcolm Priestley (5):
      staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.
      staging: vt6656: Fix calling conditions of vnt_set_bss_mode
      staging: vt6656: Fix drivers TBTT timing counter.
      staging: vt6656: Fix pairwise key entry save.
      staging: vt6656: Power save stop wake_up_count wrap around.

Marc Zyngier (1):
      net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock ar=
ray

Masahiro Yamada (1):
      lib/raid6/test: fix build on distros whose /bin/sh is not bash

Mathias Nyman (4):
      xhci: Finetune host initiated USB3 rootport link suspend and resume
      xhci: Fix handling halted endpoint even if endpoint ring appears empty
      xhci: prevent bus suspend if a roothub port detected a over-current c=
ondition
      xhci: Don't clear hub TT buffer on ep0 protocol stall

Mauro Carvalho Chehab (1):
      kconfig: qconf: Fix a few alignment issues

Michael Ellerman (1):
      powerpc/kuap: PPC_KUAP_DEBUG should depend on PPC_KUAP

Michal Simek (7):
      Revert "serial: uartps: Fix uartps_major handling"
      Revert "serial: uartps: Use the same dynamic major number for all por=
ts"
      Revert "serial: uartps: Fix error path when alloc failed"
      Revert "serial: uartps: Do not allow use aliases >=3D MAX_UART_INSTAN=
CES"
      Revert "serial: uartps: Change uart ID port allocation"
      Revert "serial: uartps: Move Port ID to device data structure"
      Revert "serial: uartps: Register own uart console and driver structur=
es"

Mika Westerberg (3):
      PCI/PM: Add pcie_wait_for_link_delay()
      PCI: pciehp: Prevent deadlock on disconnect
      PCI/PM: Add missing link delays required by the PCIe spec

Mordechay Goodstein (1):
      iwlwifi: mvm: beacon statistics shouldn't go backwards

Muchun Song (1):
      mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

Murthy Bhat (1):
      scsi: smartpqi: fix call trace in device discovery

Naoki Kiryu (1):
      usb: typec: altmode: Fix typec_altmode_get_partner sometimes returnin=
g an invalid pointer

Nicholas Kazlauskas (1):
      drm/amd/display: Calculate scaling ratios on every medium/full update

Nicholas Piggin (1):
      Revert "powerpc/64: irq_work avoid interrupt when called with hardwar=
e irqs enabled"

Nick Bowler (1):
      nvme: fix compat address handling in several ioctls

Nicolas Pitre (2):
      vt: don't hardcode the mem allocation upper bound
      vt: don't use kmalloc() for the unicode screen buffer

Oliver Neukum (4):
      cdc-acm: close race betrween suspend() and acm_softint
      cdc-acm: introduce a cool down
      UAS: no use logging any details in case of ENODEV
      UAS: fix deadlock in error handling and PM flushing work

Olivier Moysan (1):
      iio: adc: stm32-adc: fix sleep in atomic context

Paul Moore (1):
      audit: check the length of userspace generated audit records

Paulo Alcantara (1):
      cifs: fix uninitialised lease_key in open_shroot()

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Rahul Lakkireddy (1):
      cxgb4: fix large delays in PTP synchronization

Randall Huang (1):
      f2fs: fix to avoid memory leakage in f2fs_listxattr

Sabrina Dubroca (2):
      vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
      geneve: use the correct nlattr array in NL_SET_ERR_MSG_ATTR

Sagi Grimberg (2):
      nvme-tcp: fix possible crash in write_zeroes processing
      nvme: fix deadlock caused by ANA update wrong locking

Santosh Sivaraj (1):
      tools/test/nvdimm: Fix out of tree build

Sean Christopherson (2):
      KVM: s390: Return last valid slot if approx index is out-of-bounds
      KVM: Check validity of resolved slot when searching memslots

Steven Rostedt (VMware) (1):
      tracing/selftests: Turn off timeout setting

Sudip Mukherjee (1):
      coredump: fix null pointer dereference on coredump

Taehee Yoo (3):
      macsec: avoid to set wrong mtu
      macvlan: fix null dereference in macvlan_device_event()
      team: fix hang in team_mode_get()

Takashi Iwai (6):
      ALSA: hda: Remove ASUS ROG Zenith from the blacklist
      ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos
      ALSA: usb-audio: Add connector notifier delegation
      ALSA: usx2y: Fix potential NULL dereference
      ALSA: hda/realtek - Fix unexpected init_amp override
      ALSA: hda/hdmi: Add module option to disable audio component binding

Tero Kristo (1):
      watchdog: reset last_hw_keepalive time at start

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix request completion check

Tianjia Zhang (1):
      tpm: fix wrong return value in tpm_pcr_extend

Tonghao Zhang (1):
      net: openvswitch: ovs_ct_exit to be done under ovs_lock

Udipto Goswami (1):
      usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_re=
set()

Uros Bizjak (1):
      KVM: VMX: Enable machine check support for 32bit targets

Vasily Averin (2):
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index

Vishal Kulkarni (1):
      cxgb4: fix adapter crash due to wrong MC size

Waiman Long (1):
      KEYS: Avoid false positive ENOMEM error on key read

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

Wu Bo (1):
      scsi: iscsi: Report unbind session event when the target has been rem=
oved

Xiyu Yang (4):
      net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
      net/x25: Fix x25_neigh refcnt leak when receiving frame
      ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
      staging: comedi: Fix comedi_device refcnt leak in comedi_open

Xu Yilun (1):
      fpga: dfl: pci: fix return value of cci_pci_sriov_configure

Yan, Zheng (1):
      ceph: don't skip updating wanted caps when cap is stale

Yongqiang Sun (1):
      drm/amd/display: Not doing optimize bandwidth if flip pending.


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6pxY8ACgkQONu9yGCS
aT6N1RAApMBdozDNErbHK4s2THC2XS8VAGtagm/TIIVU+wRXuFXaVQXPP0k4PrnL
ro0Mn3b7DfszgERuMp8LmdJQhFyRn9+zDk/bPpdf9Ovvb7BG1YfgBrrxkNZoJlCv
D/JosbKyh3YcJo26Y6yLc8eni4N95AG1/pYvG7wD4gme5yXv5WeJ3aRfc6yv7a1H
GVoCaG1HwOQ+/ipWsR49NWLtI+I002CXlGyfR7UKPQmNHiRik3xBqHoNlBMMD+fU
/1gsW1Bue9O6KPaPXLGo+Hk3ic6PlIWW0JRWTZtlcMd5qrNxpE+O3oxVNsQi8i9T
V2EKXZ7gzNjB1rmsDldpE5Vv2XCwhNN3OUptti9rbnAhN9oGF9Zo9duXzZJdrlX9
glpRcgXQn6UyTPVH7jLg0JKGYHMe1djfpVCKU0a1Jc6iut5uSvCb9+HD57/mVEeX
Au3qrHsYv4LghXUvuh2b/YP3BqQhn9kC+zz3wtxk5v/GjNgH1VETWTcNMs/kSVzW
Nh0LVe+T76pkXA0qTB7cEqF6NxnDlv7Hm17zDeLjBztavCBz4Zgi6Kv45ejcbXaw
pXoLrT+yJXRFTwjNbeJYyUaQqm6aUip+T1vi6lsDWcwQI1/Ek4Vi8Lb1YIqFDSpg
tZJRmPGxSLxQhelE8h7RLefTip+J05W3f50tqLPTHW0Y5a5MOmk=
=cGF9
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
