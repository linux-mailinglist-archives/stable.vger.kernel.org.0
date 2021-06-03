Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D421E399C00
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 09:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFCHyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 03:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhFCHyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 03:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2AA4613E3;
        Thu,  3 Jun 2021 07:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622706743;
        bh=Z4eCV2IrGUJ8BQdmIyBTfhlhjWaDQa/FQvFQu+HIuqI=;
        h=From:To:Cc:Subject:Date:From;
        b=XkeLXSNZvSFae4oZJbbylTBXQLshq7JRIEHVGL+I8HEr0z6vK1S0DmWMbRoMegFjb
         gPmahhPOYBzF4mUulEMFsbUY1S0C4TkUoGDbEznZkZ1irBmszv2hPMDEc9eYcfwDqV
         iDKhA1iad+fzRR3hNEJhmkSgBbs4wFHCxd79zLtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.193
Date:   Thu,  3 Jun 2021 09:52:16 +0200
Message-Id: <16227067365774@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.193 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/mips/alchemy/board-xxs1500.c                   |    1 
 arch/mips/ralink/of.c                               |    2 
 arch/openrisc/include/asm/barrier.h                 |    9 
 drivers/char/hpet.c                                 |    4 
 drivers/dma/qcom/hidma_mgmt.c                       |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c              |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c             |    1 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c       |   18 +
 drivers/gpu/drm/meson/meson_drv.c                   |    9 
 drivers/i2c/busses/i2c-i801.c                       |    6 
 drivers/i2c/busses/i2c-s3c2410.c                    |    3 
 drivers/iio/adc/ad7793.c                            |    1 
 drivers/iommu/dmar.c                                |    4 
 drivers/isdn/hardware/mISDN/mISDNinfineon.c         |   24 +
 drivers/md/dm-snap.c                                |    2 
 drivers/media/dvb-frontends/sp8870.c                |    4 
 drivers/media/usb/gspca/m5602/m5602_po1030.c        |   10 
 drivers/misc/kgdbts.c                               |    3 
 drivers/misc/lis3lv02d/lis3lv02d.h                  |    1 
 drivers/misc/mei/interrupt.c                        |    3 
 drivers/net/caif/caif_serial.c                      |    1 
 drivers/net/dsa/mt7530.c                            |    8 
 drivers/net/ethernet/broadcom/bnx2.c                |    2 
 drivers/net/ethernet/brocade/bna/bnad.c             |    7 
 drivers/net/ethernet/dec/tulip/de4x5.c              |    4 
 drivers/net/ethernet/dec/tulip/media.c              |    5 
 drivers/net/ethernet/freescale/fec_main.c           |   11 
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c           |    5 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c     |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c      |   16 -
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c     |    4 
 drivers/net/ethernet/mellanox/mlx4/en_tx.c          |    2 
 drivers/net/ethernet/mellanox/mlx4/port.c           |  107 ++++++-
 drivers/net/ethernet/micrel/ksz884x.c               |    3 
 drivers/net/ethernet/microchip/lan743x_main.c       |    6 
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c   |   32 --
 drivers/net/ethernet/sfc/falcon/farch.c             |   29 -
 drivers/net/ethernet/sis/sis900.c                   |    5 
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c   |    2 
 drivers/net/ethernet/ti/davinci_emac.c              |    5 
 drivers/net/ethernet/ti/netcp_core.c                |    2 
 drivers/net/ethernet/ti/tlan.c                      |    4 
 drivers/net/ethernet/via/via-velocity.c             |   13 
 drivers/net/phy/mdio-octeon.c                       |    2 
 drivers/net/phy/mdio-thunder.c                      |    1 
 drivers/net/usb/hso.c                               |    4 
 drivers/net/usb/smsc75xx.c                          |    8 
 drivers/net/wireless/ath/ath10k/htt_rx.c            |   61 +++-
 drivers/net/wireless/marvell/libertas/mesh.c        |   28 -
 drivers/platform/x86/hp-wireless.c                  |    2 
 drivers/platform/x86/hp_accel.c                     |   22 +
 drivers/platform/x86/intel_punit_ipc.c              |    1 
 drivers/scsi/BusLogic.c                             |    6 
 drivers/scsi/BusLogic.h                             |    2 
 drivers/scsi/libsas/sas_port.c                      |    4 
 drivers/spi/spi-gpio.c                              |    8 
 drivers/staging/emxx_udc/emxx_udc.c                 |    4 
 drivers/staging/iio/cdc/ad7746.c                    |    1 
 drivers/staging/mt7621-spi/spi-mt7621.c             |   10 
 drivers/thunderbolt/dma_port.c                      |   11 
 drivers/tty/serial/max310x.c                        |    6 
 drivers/tty/serial/rp2.c                            |   52 +--
 drivers/tty/serial/sh-sci.c                         |    4 
 drivers/usb/core/devio.c                            |   11 
 drivers/usb/core/hub.h                              |    6 
 drivers/usb/dwc3/gadget.c                           |   17 -
 drivers/usb/gadget/udc/renesas_usb3.c               |    5 
 drivers/usb/misc/trancevibrator.c                   |    4 
 drivers/usb/misc/uss720.c                           |    1 
 drivers/usb/serial/ftdi_sio.c                       |    3 
 drivers/usb/serial/ftdi_sio_ids.h                   |    7 
 drivers/usb/serial/option.c                         |    4 
 drivers/usb/serial/pl2303.c                         |    1 
 drivers/usb/serial/pl2303.h                         |    1 
 drivers/usb/serial/ti_usb_3410_5052.c               |    3 
 fs/btrfs/tree-log.c                                 |    2 
 fs/cifs/smb2pdu.c                                   |   13 
 fs/hugetlbfs/inode.c                                |    4 
 fs/nfs/filelayout/filelayout.c                      |    2 
 fs/nfs/nfs4file.c                                   |    2 
 fs/nfs/pagelist.c                                   |   12 
 fs/nfs/pnfs.c                                       |   15 -
 fs/proc/base.c                                      |    4 
 include/linux/bpf_verifier.h                        |    5 
 include/linux/hugetlb.h                             |    2 
 include/net/cfg80211.h                              |    4 
 include/net/nfc/nci_core.h                          |    1 
 kernel/bpf/verifier.c                               |  300 +++++++++++++-------
 mm/hugetlb.c                                        |   10 
 mm/userfaultfd.c                                    |    2 
 mm/vmstat.c                                         |    3 
 net/bluetooth/cmtp/core.c                           |    5 
 net/core/filter.c                                   |    1 
 net/dsa/master.c                                    |    5 
 net/dsa/slave.c                                     |   12 
 net/ipv6/mcast.c                                    |    3 
 net/ipv6/reassembly.c                               |    4 
 net/mac80211/ieee80211_i.h                          |   36 --
 net/mac80211/iface.c                                |   11 
 net/mac80211/key.c                                  |    7 
 net/mac80211/key.h                                  |    2 
 net/mac80211/rx.c                                   |  150 +++++++---
 net/mac80211/sta_info.c                             |    6 
 net/mac80211/sta_info.h                             |   32 ++
 net/mac80211/wpa.c                                  |   13 
 net/nfc/nci/core.c                                  |    1 
 net/nfc/nci/hci.c                                   |    5 
 net/openvswitch/meter.c                             |    8 
 net/sched/sch_dsmark.c                              |    3 
 net/tipc/msg.c                                      |    9 
 net/tipc/socket.c                                   |    5 
 net/wireless/util.c                                 |    7 
 sound/soc/codecs/cs35l33.c                          |    1 
 sound/soc/codecs/cs43130.c                          |   28 -
 tools/perf/pmu-events/jevents.c                     |    2 
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    6 
 tools/perf/util/intel-pt.c                          |    5 
 tools/testing/selftests/bpf/test_verifier.c         |  112 +++++--
 119 files changed, 1049 insertions(+), 518 deletions(-)

Adrian Hunter (2):
      perf intel-pt: Fix sample instruction bytes
      perf intel-pt: Fix transaction abort handling

Alaa Emad (1):
      media: dvb: Add check on sp8870_readreg return

Alan Stern (1):
      USB: usbfs: Don't WARN about excessively large memory allocations

Alexander Usyskin (1):
      mei: request autosuspend after sending rx flow control

Alexei Starovoitov (1):
      bpf: extend is_branch_taken to registers

Andrey Ignatov (1):
      selftests/bpf: Test narrow loads with off > 0 in test_verifier

Andy Shevchenko (1):
      platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI

Anirudh Rayabharam (1):
      net: fujitsu: fix potential null-ptr-deref

Anna Schumaker (1):
      NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Atul Gopinathan (1):
      serial: max310x: unregister uart driver in case of failure and abort

Aurelien Aptel (1):
      cifs: set server->cipher_type to AES-128-CCM for SMB3.0

Chris Park (1):
      drm/amd/display: Disconnect non-DP with no EDID

Christophe JAILLET (3):
      net: netcp: Fix an error message
      net: mdio: thunder: Fix a double free issue in the .remove function
      net: mdio: octeon: Fix some double free issues

Chunfeng Yun (1):
      usb: core: reduce power-on-good delay time of root hub

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks

Dan Carpenter (5):
      NFS: fix an incorrect limit in filelayout_decode_layout()
      net: dsa: fix a crash if ->get_sset_count() fails
      staging: emxx_udc: fix loop in _nbu2ss_nuke()
      ASoC: cs35l33: fix an error code in probe()
      scsi: libsas: Use _safe() loop in sas_resume_port()

Daniel Borkmann (13):
      bpf, test_verifier: switch bpf_get_stack's 0 s> r8 test
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Refactor and streamline bounds check into helper
      bpf: Move sanitize_val_alu out of op switch
      bpf: Tighten speculative pointer arithmetic mask
      bpf: Update selftests to reflect new error states
      bpf: Fix leakage of uninitialized bpf stack under speculation
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates

Daniele Palmas (1):
      USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011

Dominik Andreas Schorpp (1):
      USB: serial: ftdi_sio: add IDs for IDS GmbH Products

Dongliang Mu (2):
      NFC: nci: fix memory leak in nci_allocate_device
      misc/uss720: fix memory leak in uss720_probe

Du Cheng (1):
      net: caif: remove BUG_ON(dev == NULL) in caif_xmit

Felix Fietkau (1):
      perf jevents: Fix getting maximum number of fds

Francesco Ruggeri (1):
      ipv6: record frag_max_size in atomic fragments in input path

Fugang Duan (1):
      net: fec: fix the potential memory leak in fec_enet_init()

Geert Uytterhoeven (1):
      serial: sh-sci: Fix off-by-one error in FIFO threshold register setting

Greg Kroah-Hartman (5):
      kgdb: fix gcc-11 warnings harder
      libertas: register sysfs groups properly
      ASoC: cs43130: handle errors in cs43130_probe() properly
      media: gspca: properly check for errors in po1030_probe()
      Linux 4.19.193

Hoang Le (1):
      Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Jack Pham (1):
      usb: dwc3: gadget: Enable suspend events

Jean Delvare (1):
      i2c: i801: Don't generate an interrupt on bus reset

Jesse Brandeburg (2):
      ixgbe: fix large MTU request from VF
      drivers/net/ethernet: clean up unused assignments

Jingwen Chen (1):
      drm/amd/amdgpu: fix refcount leak

Johan Hovold (2):
      net: hso: fix control-request directions
      USB: trancevibrator: fix control-request direction

Johannes Berg (5):
      mac80211: drop A-MSDUs on old ciphers
      mac80211: add fragment cache to sta_info
      mac80211: check defrag PN against current frame
      mac80211: prevent attacks on TKIP/WEP as well
      mac80211: do not accept/forward invalid EAPOL frames

John Fastabend (1):
      bpf: Test_verifier, bpf_get_stack return value add <0

Josef Bacik (1):
      btrfs: do not BUG_ON in link_to_fixup_dir

Jussi Maki (1):
      bpf: Set mac_len in bpf_skb_change_head

Kai-Heng Feng (1):
      platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Kees Cook (1):
      proc: Check /proc/$pid/attr/ writes against file opener

Krzysztof Kozlowski (1):
      i2c: s3c2410: fix possible NULL pointer deref on read message after write

Lucas Stankus (1):
      staging: iio: cdc: ad7746: avoid overwrite of num_channels

Lukas Wunner (3):
      spi: gpio: Don't leak SPI master in probe error path
      spi: mt7621: Disable clock in probe error path
      spi: mt7621: Don't leak SPI master in probe error path

Mathias Nyman (1):
      thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue

Mathy Vanhoef (4):
      mac80211: assure all fragments are encrypted
      mac80211: prevent mixed key and fragment cache attacks
      mac80211: properly handle A-MSDUs that start with an RFC 1042 header
      cfg80211: mitigate A-MSDU aggregation attacks

Matt Wang (1):
      scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Mike Kravetz (1):
      hugetlbfs: hugetlb_fault_mutex_hash() cleanup

Mikulas Patocka (1):
      dm snapshot: properly fix a crash when an origin has no snapshots

Neil Armstrong (1):
      drm/meson: fix shutdown crash when component not probed

Ovidiu Panait (2):
      bpf: fix up selftests after backports were fixed
      selftests/bpf: add selftest part of "bpf: improve verifier branch analysis"

Pavel Skripkin (1):
      net: usb: fix memory leak in smsc75xx_bind

Peter Zijlstra (1):
      openrisc: Define memory barrier mb

Phillip Potter (2):
      isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io
      dmaengine: qcom_hidma: comment platform_driver_register call

Piotr Krysiuk (1):
      bpf, selftests: Fix up some test_verifier cases for unprivileged

Randy Dunlap (2):
      MIPS: alchemy: xxs1500: add gpio-au1000.h header file
      MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Rolf Eike Beer (1):
      iommu/vt-d: Fix sysfs leak in alloc_iommu()

Sean MacLennan (1):
      USB: serial: ti_usb_3410_5052: add startech.com device id

Shyam Sundar S K (1):
      platform/x86: hp-wireless: add AMD's hardware id to the supported list

Sriram R (1):
      ath10k: Validate first subframe of A-MSDU before processing the list

Stephen Brennan (1):
      mm, vmstat: drop zone->lock in /proc/pagetypeinfo

Steve French (1):
      SMB3: incorrect file id in requests compounded with open

Taehee Yoo (2):
      mld: fix panic in mld_newpack()
      sch_dsmark: fix a NULL deref in qdisc_reset()

Tao Liu (1):
      openvswitch: meter: fix race when getting now_ms.

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Thinh Nguyen (1):
      usb: dwc3: gadget: Properly track pending and queued SG

Tom Seewald (1):
      char: hpet: add checks after calling ioremap

Trond Myklebust (1):
      NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()

Vladimir Oltean (1):
      net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count

Vladyslav Tarasiuk (1):
      net/mlx4: Fix EEPROM dump support

Wen Gong (1):
      mac80211: extend protection against mixed key and fragment cache attacks

Xin Long (1):
      tipc: skb_linearize the head skb when reassembling msgs

Yoshihiro Shimoda (1):
      usb: gadget: udc: renesas_usb3: Fix a race in usb3_start_pipen()

YueHaibing (1):
      iio: adc: ad7793: Add missing error code in ad7793_setup()

Yunsheng Lin (1):
      net: hns3: check the return of skb_checksum_help()

Zhang Xiaoxu (1):
      NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config

Zhen Lei (1):
      net: bnx2: Fix error return code in bnx2_init_board()

Zheyu Ma (1):
      serial: rp2: use 'request_firmware' instead of 'request_firmware_nowait'

Zolton Jheng (1):
      USB: serial: pl2303: add device id for ADLINK ND-6530 GC

xinhui pan (1):
      drm/amdgpu: Fix a use-after-free

