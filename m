Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39F52556
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 09:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfFYHwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 03:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfFYHwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 03:52:31 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A467E2086D;
        Tue, 25 Jun 2019 07:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561449151;
        bh=KTqQnLRVa4Q3dPCtAyvteSl++O7jXIVVu1nc5i9/L14=;
        h=Date:From:To:Cc:Subject:From;
        b=GBRuz3Cv7tz2B4PTDxjWkFJzBBD8wUoLGAyxlvcg2LuHEoueI+ufR2/m4HaSraYvl
         PG4rxJ87/L1zf/c7ehg20D/aeLMW/7wy+dNMamVdxTXmbhTAU8VaQFk+grygg9PMc5
         Jw4/B3GyNUc14mOdas7bmsnZGEobGhgyMYtT+WdQ=
Date:   Tue, 25 Jun 2019 15:51:36 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.56
Message-ID: <20190625075136.GA26211@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.56 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                |    4=20
 arch/arc/boot/dts/hsdk.dts                              |    4=20
 arch/arc/include/asm/cmpxchg.h                          |   14 -
 arch/arc/mm/tlb.c                                       |   13 -
 arch/arm/boot/dts/am57xx-idk-common.dtsi                |    1=20
 arch/arm/boot/dts/dra76x-mmc-iodelay.dtsi               |   40 +--
 arch/arm/mach-imx/cpuidle-imx6sx.c                      |    3=20
 arch/arm64/Makefile                                     |    1=20
 arch/arm64/include/uapi/asm/ptrace.h                    |    8=20
 arch/arm64/kernel/ssbd.c                                |    1=20
 arch/mips/kernel/uprobes.c                              |    3=20
 arch/parisc/math-emu/cnv_float.h                        |    8=20
 arch/powerpc/include/asm/ppc-opcode.h                   |    1=20
 arch/powerpc/mm/mmu_context_book3s64.c                  |   46 ++++
 arch/powerpc/net/bpf_jit.h                              |    2=20
 arch/powerpc/net/bpf_jit_comp64.c                       |    8=20
 arch/riscv/mm/fault.c                                   |   13 +
 arch/s390/include/asm/ap.h                              |   28 +-
 arch/s390/include/asm/jump_label.h                      |   14 -
 arch/sparc/kernel/mdesc.c                               |    2=20
 arch/sparc/kernel/perf_event.c                          |    4=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                |    2=20
 arch/xtensa/kernel/setup.c                              |    3=20
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c          |    3=20
 drivers/dma/sprd-dma.c                                  |    2=20
 drivers/fpga/dfl-afu-dma-region.c                       |    2=20
 drivers/fpga/dfl.c                                      |   16 +
 drivers/gpu/drm/arm/hdlcd_crtc.c                        |   14 -
 drivers/gpu/drm/arm/malidp_drv.c                        |   13 +
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c                     |  146 +++++++++++=
---
 drivers/hwmon/hwmon.c                                   |    2=20
 drivers/hwmon/pmbus/pmbus_core.c                        |   34 ++-
 drivers/iio/temperature/mlx90632.c                      |    9=20
 drivers/infiniband/hw/hfi1/chip.c                       |    1=20
 drivers/infiniband/hw/hfi1/fault.c                      |    5=20
 drivers/infiniband/hw/hfi1/user_exp_rcv.c               |    3=20
 drivers/infiniband/hw/hfi1/verbs.c                      |    2=20
 drivers/infiniband/hw/hfi1/verbs_txreq.c                |    2=20
 drivers/infiniband/hw/hfi1/verbs_txreq.h                |    3=20
 drivers/infiniband/hw/qib/qib_verbs.c                   |    2=20
 drivers/infiniband/sw/rdmavt/mr.c                       |    2=20
 drivers/infiniband/sw/rdmavt/qp.c                       |    3=20
 drivers/input/misc/uinput.c                             |   22 +-
 drivers/input/mouse/synaptics.c                         |    2=20
 drivers/input/touchscreen/silead.c                      |    1=20
 drivers/mmc/core/core.c                                 |    5=20
 drivers/mmc/core/sdio.c                                 |   13 +
 drivers/mmc/core/sdio_io.c                              |   77 +++++++
 drivers/mmc/core/sdio_irq.c                             |    4=20
 drivers/mmc/host/sdhci-pci-o2micro.c                    |    5=20
 drivers/net/can/flexcan.c                               |    2=20
 drivers/net/can/xilinx_can.c                            |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                        |    2=20
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c        |    4=20
 drivers/net/ethernet/mediatek/mtk_eth_soc.c             |   15 -
 drivers/net/ipvlan/ipvlan_main.c                        |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |   11 +
 drivers/nvme/host/core.c                                |    3=20
 drivers/nvme/target/io-cmd-bdev.c                       |    1=20
 drivers/parport/share.c                                 |    2=20
 drivers/s390/net/qeth_l2_main.c                         |    2=20
 drivers/scsi/smartpqi/smartpqi_init.c                   |    6=20
 drivers/scsi/ufs/ufshcd-pltfrm.c                        |   11 -
 drivers/scsi/ufs/ufshcd.c                               |    3=20
 drivers/staging/erofs/erofs_fs.h                        |   13 -
 drivers/staging/erofs/internal.h                        |    2=20
 drivers/staging/erofs/super.c                           |   19 +
 drivers/usb/chipidea/udc.c                              |   20 +
 drivers/usb/host/xhci-ring.c                            |   15 +
 drivers/usb/host/xhci.c                                 |   25 +-
 drivers/usb/host/xhci.h                                 |    9=20
 fs/btrfs/reada.c                                        |    5=20
 fs/cifs/smb2maperror.c                                  |    2=20
 fs/overlayfs/file.c                                     |   96 ++++++---
 fs/overlayfs/inode.c                                    |   60 +++++
 fs/overlayfs/namei.c                                    |    8=20
 fs/overlayfs/overlayfs.h                                |    3=20
 fs/overlayfs/ovl_entry.h                                |    6=20
 fs/overlayfs/super.c                                    |  161 +++++++++++=
+++--
 fs/overlayfs/util.c                                     |   12 +
 include/linux/mmc/host.h                                |    1=20
 include/linux/mmc/sdio_func.h                           |    6=20
 include/net/bluetooth/hci_core.h                        |    3=20
 include/net/cfg80211.h                                  |    3=20
 kernel/trace/trace.c                                    |    6=20
 kernel/trace/trace.h                                    |   18 +
 kernel/trace/trace_kdb.c                                |    6=20
 net/bluetooth/hci_conn.c                                |   10=20
 net/bluetooth/l2cap_core.c                              |   33 ++-
 net/can/af_can.c                                        |    1=20
 net/mac80211/ieee80211_i.h                              |    3=20
 net/mac80211/mlme.c                                     |   12 +
 net/mac80211/rx.c                                       |    2=20
 net/mac80211/tdls.c                                     |   23 ++
 net/mac80211/util.c                                     |    4=20
 net/mac80211/wpa.c                                      |    7=20
 net/wireless/core.c                                     |    8=20
 net/wireless/nl80211.c                                  |   12 -
 scripts/checkstack.pl                                   |    2=20
 security/apparmor/include/policy.h                      |   11 -
 security/apparmor/policy_unpack.c                       |    2=20
 tools/objtool/check.c                                   |   38 +++
 tools/objtool/check.h                                   |    4=20
 tools/objtool/elf.c                                     |    1=20
 tools/objtool/elf.h                                     |    3=20
 tools/testing/selftests/cgroup/test_core.c              |    7=20
 tools/testing/selftests/cgroup/test_memcontrol.c        |    4=20
 tools/testing/selftests/vm/Makefile                     |    2=20
 108 files changed, 1120 insertions(+), 250 deletions(-)

Alex Shi (3):
      kselftest/cgroup: fix unexpected testing failure on test_memcontrol
      kselftest/cgroup: fix unexpected testing failure on test_core
      kselftest/cgroup: fix incorrect test_core skip

Alexander Mikhaylenko (1):
      Input: synaptics - enable SMBus on ThinkPad E480 and E580

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Allan Xavier (1):
      objtool: Support per-function rodata sections

Amir Goldstein (4):
      ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
      ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls
      ovl: make i_ino consistent with st_ino in more cases
      ovl: detect overlapping layers

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Andy Strohman (1):
      nl80211: fix station_info pertid memory leak

Anisse Astier (2):
      arm64/sve: <uapi/asm/ptrace.h> should not depend on <uapi/linux/prctl=
=2Eh>
      arm64: ssbd: explicitly depend on <linux/prctl.h>

Anssi Hannula (1):
      can: xilinx_can: use correct bittiming_const for CAN FD core

Arnd Bergmann (1):
      ovl: fix bogus -Wmaybe-unitialized warning

Avri Altman (1):
      scsi: ufs: Check that space was properly alloced in copy_query_respon=
se

Colin Ian King (1):
      dmaengine: dw-axi-dmac: fix null dereference when pointer first is nu=
ll

Crt Mori (1):
      iio: temperature: mlx90632 Relax the compatibility check

Dan Carpenter (1):
      scsi: smartpqi: unlock on error in pqi_submit_raid_request_synchronou=
s()

Daniel Smith (1):
      Input: silead - add MSSL0017 to acpi_device_id

Dave Martin (1):
      arm64: Silence gcc warnings about arch ABI drift

Douglas Anderson (4):
      mmc: core: API to temporarily disable retuning for SDIO CRC errors
      mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
      brcmfmac: sdio: Disable auto-tuning around commands expected to fail
      brcmfmac: sdio: Don't tune while the card is off

Eduardo Valentin (1):
      hwmon: (core) add thermal sensors only if dev->of_node is present

Eric Biggers (1):
      cfg80211: fix memory leak of wiphy device name

Eric Long (1):
      dmaengine: sprd: Fix block length overflow

Fabio Estevam (1):
      ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Faiz Abbas (2):
      ARM: dts: dra76x: Update MMC2_HS200_MANUAL1 iodelay values
      ARM: dts: am57xx-idk: Remove support for voltage switching for SD card

Gao Xiang (1):
      staging: erofs: add requirements field in superblock

Gen Zhang (1):
      mdesc: fix a missing-check bug in get_vdev_port_node_info()

George G. Davis (1):
      scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Greg Kroah-Hartman (1):
      Linux 4.19.56

Guenter Roeck (1):
      xtensa: Fix section mismatch between memblock_reserve and mem_reserve

Harald Freudenberger (1):
      s390/ap: rework assembler functions to use unions for in/out register=
 variables

Helge Deller (1):
      parisc: Fix compiler warnings in float emulation code

Ilya Leoshkevich (1):
      s390/jump_label: Use "jdd" constraint on gcc9

Jaesoo Lee (1):
      nvme: Fix u32 overflow in the number of namespace list calculation

James Morse (1):
      x86/resctrl: Don't stop walking closids when a locksetup group is fou=
nd

Jann Horn (1):
      apparmor: enforce nullbyte at end of tag string

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA

John Johansen (1):
      apparmor: fix PROFILE_MEDIATES for untrusted input

Jose Abreu (2):
      ARC: [plat-hsdk]: Add missing multicast filter bins number to GMAC no=
de
      ARC: [plat-hsdk]: Add missing FIFO size entry in GMAC node

Jouni Malinen (1):
      mac80211: Do not use stack memory with scatterlist for GMAC

Kaike Wan (1):
      IB/hfi1: Validate fault injection opcode user input

Kamenee Arumugam (1):
      IB/hfi1: Validate page aligned for a given virtual address

Linus Torvalds (1):
      gcc-9: silence 'address-of-packed-member' warning

Manikanta Pubbisetty (1):
      {nl,mac}80211: allow 4addr AP operation on crypto controlled devices

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions
      Bluetooth: Fix regression with minimum encryption key size alignment

Mathias Nyman (2):
      xhci: detect USB 3.2 capable host controllers correctly
      usb: xhci: Don't try to recover an endpoint if port is in error state.

Miaohe Lin (1):
      net: ipvlan: Fix ipvlan device tso disabled while NETIF_F_IP_CSUM is =
set

Michael Ellerman (1):
      powerpc/mm/64s/hash: Reallocate context ids on fork

Miguel Ojeda (1):
      tracing: Silence GCC 9 array bounds warning

Mike Marciniszyn (4):
      IB/hfi1: Silence txreq allocation warnings
      IB/rdmavt: Fix alloc_qpn() WARN_ON()
      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
      IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value

Miklos Szeredi (1):
      ovl: don't fail with disconnected lower NFS

Minwoo Im (1):
      nvmet: fix data_len to 0 for bdev-backed write_zeroes

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

Naresh Kamboju (1):
      selftests: vm: install test_vmalloc.sh for run_vmtests

Naveen N. Rao (1):
      powerpc/bpf: use unsigned division instruction for 64-bit operations

Nikita Yushchenko (1):
      net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

Peter Chen (1):
      usb: chipidea: udc: workaround for endpoint conflict issue

Raul E Rangel (1):
      mmc: sdhci: sdhci-pci-o2micro: Correctly set bus width when tuning

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Robin Murphy (2):
      drm/arm/hdlcd: Actually validate CRTC modes
      drm/arm/hdlcd: Allow a bit of clock tolerance

Scott Wood (2):
      fpga: dfl: afu: Pass the correct device to dma_mapping_error()
      fpga: dfl: Add lockdep classes for pdata->lock

Sean Wang (2):
      net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported
      net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFF=
SET is enabled

ShihPo Hung (1):
      riscv: mm: synchronize MMU after pte change

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever

Steve French (1):
      SMB3: retry on STATUS_INSUFFICIENT_RESOURCES instead of failing write

Thomas Hellstrom (1):
      drm/vmwgfx: Use the backdoor port if the HB port is not available

Ulf Hansson (1):
      mmc: core: Prevent processing SDIO IRQs when the card is suspended

Vineet Gupta (1):
      ARC: fix build warnings

Wen He (1):
      drm/arm/mali-dp: Add a loop around the second set CVAL and try 5 times

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

Yonglong Liu (1):
      net: hns: Fix loopback test failed at copper ports

Young Xiao (1):
      sparc: perf: fix updated event period in response to PERF_EVENT_IOC_P=
ERIOD

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

YueHaibing (2):
      parport: Fix mem leak in parport_register_dev_model
      MIPS: uprobes: remove set but not used variable 'epc'


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0R0ogACgkQONu9yGCS
aT5xhBAAgs81og9CkqO6wyh0tGLnzUP+XBCbbiowfViu1rNLqurRyCJXKqNjQJlK
oew0Xu/l1+5BbHi8T001DoAJGkwvbl3ODwZXXS12Fy2n9V33J17Nz9qej4tuz8Ha
dW0U9V5ojTD5S9JhGziucSNkW76rY/MEoPTps092Vo+K86v7CRP8bnGeVTgL2Ifn
Goh/cK/4+y+6gVSZUqWzMKAE2SedLwp1ZrewbhSYN5L4yaYwtqX8YzcuAXNHgKp5
06AWc0EAbDlucBAVov3A8i0mIlIUf2OPnkLE2QNptqUWx10X2LRYav5SunQs5cUB
jqWAM1nVDeT4fnb9NnQnPm2krvGHDP20Zk7/ru4UiIF5aNpxEvL/ywfpXh9elXzG
fGB2fkOubwB+nd3QANh5zmtR61in+GpzvI3z0bo0XFZrFCHXx4VREOj0E28ScpZG
UB4A3cWI60/kzsuV89uz8GSaTHtlbX8dpV3hOZZ1gPnxDkBtSnJO0ObnOunrowfc
uEsd7/6vUK1gRADC+NufJqr4enveZH91nO2STh8zNHqXXA0YjMyYhy/w9D0Zu2oH
smXx2uVXZarlc+8If2PW87kmcI/62VgvoiTdelcAJvr/Bmwn6UUPr+xNMe1hc9YA
RV/1ILUxScfVkkT24jaLElzv8S7HEYgYOlsFBiw3EgZFEUt5mfE=
=f11c
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
