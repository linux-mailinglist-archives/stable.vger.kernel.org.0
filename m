Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A11399C04
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 09:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFCHyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 03:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhFCHyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 03:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A900613AA;
        Thu,  3 Jun 2021 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622706731;
        bh=OiuT3TBFcy8Bj3/lkUJSyxXXMd57IBqOHYKO7uY5kF4=;
        h=From:To:Cc:Subject:Date:From;
        b=xSAPK/AIxa8yTT+SzFrqYQcji4Dx3i7KMsunrQt6NO7zJ2tJ9pTQpHuBKgp/0DXr/
         CqrwVXcH2uFyPG6fXsS5rpgCml7+fnLHo4YhObiC3FMPSBM+bEL9FLU8IDIx7oKxxE
         W0RUKeuwBlbWmvBdWCSR8rOvBBpp6K0qLMB7b6lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.271
Date:   Thu,  3 Jun 2021 09:52:04 +0200
Message-Id: <1622706724174140@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.271 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/sphinx/parse-headers.pl                          |    2 
 Documentation/target/tcm_mod_builder.py                        |    2 
 Documentation/trace/postprocess/decode_msr.py                  |    2 
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl |    2 
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    |    2 
 Makefile                                                       |    2 
 arch/ia64/scripts/unwcheck.py                                  |    2 
 arch/mips/alchemy/board-xxs1500.c                              |    1 
 arch/mips/ralink/of.c                                          |    2 
 arch/openrisc/include/asm/barrier.h                            |    9 
 drivers/char/hpet.c                                            |    4 
 drivers/dma/qcom/hidma_mgmt.c                                  |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                        |    1 
 drivers/i2c/busses/i2c-i801.c                                  |    6 
 drivers/i2c/busses/i2c-s3c2410.c                               |    3 
 drivers/iio/adc/ad7793.c                                       |    1 
 drivers/isdn/hardware/mISDN/mISDNinfineon.c                    |   24 +
 drivers/md/dm-snap.c                                           |    2 
 drivers/media/dvb-frontends/sp8870.c                           |    4 
 drivers/media/usb/gspca/m5602/m5602_po1030.c                   |   10 
 drivers/misc/kgdbts.c                                          |    3 
 drivers/misc/lis3lv02d/lis3lv02d.h                             |    1 
 drivers/misc/mei/interrupt.c                                   |    3 
 drivers/net/caif/caif_serial.c                                 |    1 
 drivers/net/ethernet/broadcom/bnx2.c                           |    2 
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c                      |    5 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                |    4 
 drivers/net/ethernet/mellanox/mlx4/port.c                      |  107 ++++++-
 drivers/net/ethernet/ti/netcp_core.c                           |    2 
 drivers/net/phy/mdio-octeon.c                                  |    2 
 drivers/net/phy/mdio-thunder.c                                 |    1 
 drivers/net/usb/hso.c                                          |    4 
 drivers/net/usb/smsc75xx.c                                     |    8 
 drivers/net/wireless/ath/ath10k/htt_rx.c                       |   61 +++-
 drivers/net/wireless/marvell/libertas/mesh.c                   |   28 -
 drivers/platform/x86/hp_accel.c                                |   22 +
 drivers/platform/x86/intel_punit_ipc.c                         |    1 
 drivers/scsi/BusLogic.c                                        |    6 
 drivers/scsi/BusLogic.h                                        |    2 
 drivers/scsi/libsas/sas_port.c                                 |    4 
 drivers/spi/spi.c                                              |    9 
 drivers/staging/emxx_udc/emxx_udc.c                            |    4 
 drivers/staging/iio/cdc/ad7746.c                               |    1 
 drivers/tty/serial/max310x.c                                   |    6 
 drivers/tty/serial/rp2.c                                       |   52 +--
 drivers/usb/core/hub.h                                         |    6 
 drivers/usb/misc/trancevibrator.c                              |    4 
 drivers/usb/misc/uss720.c                                      |    1 
 drivers/usb/serial/ftdi_sio.c                                  |    3 
 drivers/usb/serial/ftdi_sio_ids.h                              |    7 
 drivers/usb/serial/option.c                                    |    4 
 drivers/usb/serial/pl2303.c                                    |    1 
 drivers/usb/serial/pl2303.h                                    |    1 
 drivers/usb/serial/ti_usb_3410_5052.c                          |    3 
 fs/btrfs/tree-log.c                                            |    2 
 fs/hugetlbfs/inode.c                                           |    4 
 fs/nfs/filelayout/filelayout.c                                 |    2 
 fs/nfs/nfs4file.c                                              |    2 
 fs/nfs/pagelist.c                                              |   12 
 fs/nfs/pnfs.c                                                  |   17 -
 fs/proc/base.c                                                 |    4 
 include/linux/hugetlb.h                                        |    2 
 include/linux/netfilter/x_tables.h                             |    2 
 include/linux/spi/spi.h                                        |    3 
 include/net/cfg80211.h                                         |    5 
 include/net/nfc/nci_core.h                                     |    1 
 mm/hugetlb.c                                                   |    8 
 mm/vmstat.c                                                    |    3 
 net/bluetooth/cmtp/core.c                                      |    5 
 net/ipv6/mcast.c                                               |    3 
 net/mac80211/ieee80211_i.h                                     |   36 --
 net/mac80211/iface.c                                           |    9 
 net/mac80211/key.c                                             |    7 
 net/mac80211/key.h                                             |    2 
 net/mac80211/rx.c                                              |  151 +++++++---
 net/mac80211/sta_info.c                                        |    4 
 net/mac80211/sta_info.h                                        |   31 ++
 net/mac80211/wpa.c                                             |   12 
 net/netfilter/x_tables.c                                       |    3 
 net/nfc/nci/core.c                                             |    1 
 net/nfc/nci/hci.c                                              |    5 
 net/sched/sch_dsmark.c                                         |    3 
 net/tipc/msg.c                                                 |    9 
 net/tipc/socket.c                                              |    5 
 net/wireless/util.c                                            |    8 
 scripts/analyze_suspend.py                                     |    2 
 scripts/bloat-o-meter                                          |    2 
 scripts/bootgraph.pl                                           |    2 
 scripts/checkincludes.pl                                       |    2 
 scripts/checkstack.pl                                          |    2 
 scripts/config                                                 |    2 
 scripts/diffconfig                                             |    2 
 scripts/dtc/dt_to_config                                       |    2 
 scripts/extract_xc3028.pl                                      |    2 
 scripts/get_dvb_firmware                                       |    2 
 scripts/markup_oops.pl                                         |    2 
 scripts/profile2linkerlist.pl                                  |    2 
 scripts/show_delta                                             |    2 
 scripts/stackdelta                                             |    2 
 scripts/tracing/draw_functrace.py                              |    2 
 sound/soc/codecs/cs35l33.c                                     |    1 
 tools/kvm/kvm_stat/kvm_stat                                    |    2 
 tools/perf/pmu-events/jevents.c                                |    2 
 tools/perf/python/tracepoint.py                                |    2 
 tools/perf/python/twatch.py                                    |    2 
 tools/perf/scripts/python/sched-migration.py                   |    2 
 tools/perf/util/setup.py                                       |    2 
 tools/testing/ktest/compare-ktest-sample.pl                    |    2 
 108 files changed, 609 insertions(+), 261 deletions(-)

Alaa Emad (1):
      media: dvb: Add check on sp8870_readreg return

Alexander Usyskin (1):
      mei: request autosuspend after sending rx flow control

Andy Shevchenko (2):
      scripts: switch explicitly to Python 3
      platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI

Anirudh Rayabharam (1):
      net: fujitsu: fix potential null-ptr-deref

Anna Schumaker (1):
      NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Atul Gopinathan (1):
      serial: max310x: unregister uart driver in case of failure and abort

Christophe JAILLET (3):
      net: netcp: Fix an error message
      net: mdio: thunder: Fix a double free issue in the .remove function
      net: mdio: octeon: Fix some double free issues

Chunfeng Yun (1):
      usb: core: reduce power-on-good delay time of root hub

Dan Carpenter (4):
      NFS: fix an incorrect limit in filelayout_decode_layout()
      staging: emxx_udc: fix loop in _nbu2ss_nuke()
      ASoC: cs35l33: fix an error code in probe()
      scsi: libsas: Use _safe() loop in sas_resume_port()

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

Finn Behrens (1):
      tweewide: Fix most Shebang lines

Greg Kroah-Hartman (4):
      kgdb: fix gcc-11 warnings harder
      libertas: register sysfs groups properly
      media: gspca: properly check for errors in po1030_probe()
      Linux 4.9.271

Hoang Le (1):
      Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Jean Delvare (1):
      i2c: i801: Don't generate an interrupt on bus reset

Johan Hovold (2):
      net: hso: fix control-request directions
      USB: trancevibrator: fix control-request direction

Johannes Berg (5):
      mac80211: drop A-MSDUs on old ciphers
      mac80211: add fragment cache to sta_info
      mac80211: check defrag PN against current frame
      mac80211: prevent attacks on TKIP/WEP as well
      mac80211: do not accept/forward invalid EAPOL frames

Josef Bacik (1):
      btrfs: do not BUG_ON in link_to_fixup_dir

Kai-Heng Feng (1):
      platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Kees Cook (1):
      proc: Check /proc/$pid/attr/ writes against file opener

Krzysztof Kozlowski (1):
      i2c: s3c2410: fix possible NULL pointer deref on read message after write

Lucas Stankus (1):
      staging: iio: cdc: ad7746: avoid overwrite of num_channels

Mark Tomlinson (1):
      netfilter: x_tables: Use correct memory barriers.

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

Pavel Skripkin (1):
      net: usb: fix memory leak in smsc75xx_bind

Peter Zijlstra (1):
      openrisc: Define memory barrier mb

Phillip Potter (2):
      isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io
      dmaengine: qcom_hidma: comment platform_driver_register call

Randy Dunlap (2):
      MIPS: alchemy: xxs1500: add gpio-au1000.h header file
      MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Sean MacLennan (1):
      USB: serial: ti_usb_3410_5052: add startech.com device id

Sriram R (1):
      ath10k: Validate first subframe of A-MSDU before processing the list

Stephen Brennan (1):
      mm, vmstat: drop zone->lock in /proc/pagetypeinfo

Taehee Yoo (2):
      mld: fix panic in mld_newpack()
      sch_dsmark: fix a NULL deref in qdisc_reset()

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Tom Seewald (1):
      char: hpet: add checks after calling ioremap

Trond Myklebust (1):
      NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()

Vladyslav Tarasiuk (1):
      net/mlx4: Fix EEPROM dump support

Wen Gong (1):
      mac80211: extend protection against mixed key and fragment cache attacks

William A. Kennington III (1):
      spi: Fix use-after-free with devm_spi_alloc_*

Xin Long (1):
      tipc: skb_linearize the head skb when reassembling msgs

YueHaibing (1):
      iio: adc: ad7793: Add missing error code in ad7793_setup()

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

