Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7DF46CEFC
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhLHIcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51692 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244808AbhLHIbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:31:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F59EB81FF0;
        Wed,  8 Dec 2021 08:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D2FC00446;
        Wed,  8 Dec 2021 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952098;
        bh=OuqCdoh7blwEYLLQNsoXSrOXFckRMQv6XiRG72g+04g=;
        h=From:To:Cc:Subject:Date:From;
        b=eRB/y0gaKJu4cwFk4EL79w2091+e/7jm2YxEpjtsocUKDiS9VackubsKyTQgidS1c
         D3ov/PdhScbFWsmTCOv2ZOhnHhrQtZki83h2nwu+jsrqZUymD6GASGb3k8/Yy6vRMm
         MzaK4nPzLi9Va43UgZw/ydhv+MAGr+FGWdy545BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.220
Date:   Wed,  8 Dec 2021 09:28:01 +0100
Message-Id: <1638952082246118@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.220 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 arch/parisc/Makefile                                         |    5 
 arch/parisc/install.sh                                       |    1 
 arch/parisc/kernel/time.c                                    |   24 -
 arch/s390/kernel/setup.c                                     |    3 
 arch/x86/realmode/init.c                                     |   12 
 drivers/ata/ahci.c                                           |    1 
 drivers/ata/sata_fsl.c                                       |   20 -
 drivers/char/ipmi/ipmi_msghandler.c                          |   13 
 drivers/gpu/drm/msm/msm_debugfs.c                            |    1 
 drivers/i2c/busses/i2c-stm32f7.c                             |   11 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c |   10 
 drivers/net/ethernet/dec/tulip/de4x5.c                       |   34 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c           |    4 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c               |    9 
 drivers/net/ethernet/natsemi/xtsonic.c                       |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c          |   10 
 drivers/net/usb/lan78xx.c                                    |    2 
 drivers/net/vrf.c                                            |    2 
 drivers/platform/x86/thinkpad_acpi.c                         |   12 
 drivers/scsi/scsi_transport_iscsi.c                          |    6 
 drivers/thermal/thermal_core.c                               |    2 
 drivers/tty/serial/amba-pl011.c                              |    1 
 drivers/tty/serial/msm_serial.c                              |    3 
 drivers/tty/serial/serial_core.c                             |   13 
 drivers/usb/core/quirks.c                                    |    3 
 drivers/usb/host/xhci-ring.c                                 |   21 -
 drivers/usb/typec/tcpm.c                                     |    4 
 drivers/video/console/vgacon.c                               |   14 
 fs/btrfs/disk-io.c                                           |   14 
 fs/file.c                                                    |   19 -
 fs/file_table.c                                              |    9 
 fs/gfs2/bmap.c                                               |    2 
 fs/nfs/nfs42proc.c                                           |    5 
 include/linux/file.h                                         |    2 
 include/linux/fs.h                                           |    4 
 include/linux/ipc_namespace.h                                |   15 
 include/linux/kprobes.h                                      |    2 
 include/linux/netdevice.h                                    |   19 -
 include/linux/of_clk.h                                       |    3 
 include/linux/sched/task.h                                   |    2 
 include/linux/siphash.h                                      |   14 
 ipc/shm.c                                                    |  189 ++++++++---
 kernel/kprobes.c                                             |    3 
 lib/siphash.c                                                |   12 
 net/core/dev.c                                               |    5 
 net/ipv4/devinet.c                                           |    2 
 net/mpls/af_mpls.c                                           |   68 +++
 net/rds/tcp.c                                                |    2 
 net/rxrpc/peer_object.c                                      |   14 
 net/smc/smc_close.c                                          |    8 
 tools/perf/ui/hist.c                                         |   28 -
 tools/perf/util/hist.h                                       |    1 
 53 files changed, 480 insertions(+), 207 deletions(-)

Alain Volmat (2):
      i2c: stm32f7: recover the bus on access timeout
      i2c: stm32f7: stop dma transfer in case of NACK

Alexander Mikhalitsyn (1):
      shm: extend forced shm destroy to support objects from several IPC nses

Andreas Gruenbacher (1):
      gfs2: Fix length of holes reported at end-of-file

Arnd Bergmann (1):
      siphash: use _unaligned version by default

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Baokun Li (2):
      sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
      sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Benjamin Coddington (1):
      NFSv42: Fix pagecache invalidation after COPY/CLONE

Benjamin Poirier (1):
      net: mpls: Fix notifications when deleting a device

Eiichi Tsukata (1):
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eric Dumazet (1):
      net: annotate data-races on txq->xmit_lock_owner

Geert Uytterhoeven (1):
      of: clk: Make <linux/of_clk.h> self-contained

Greg Kroah-Hartman (1):
      Linux 4.19.220

Helge Deller (3):
      parisc: Fix KBUILD_IMAGE for self-extracting kernel
      parisc: Fix "make install" on newer debian releases
      parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Ian Rogers (1):
      perf hist: Fix memory leak of a perf_hpp_fmt

Ioanna Alifieraki (1):
      ipmi: Move remove_work to dedicated workqueue

Jens Axboe (1):
      fs: add fget_many() and fput_many()

Joerg Roedel (1):
      x86/64/mm: Map all kernel memory into trampoline_pgd

Johan Hovold (1):
      serial: core: fix transmit-buffer reset and memleak

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Manaf Meethalavalappu Pallikunhi (1):
      thermal: core: Reset previous low and high trip during thermal zone init

Mario Limonciello (1):
      ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (1):
      xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Ole Ernst (1):
      USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Rob Clark (1):
      drm/msm: Do hw_init() before capturing GPU state

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Sven Eckelmann (1):
      tty: serial: msm_serial: Deactivate RX DMA for polling support

Sven Schuchmann (1):
      net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Teng Qi (2):
      ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Tony Lu (1):
      net/smc: Keep smc_close_final rc during active close

Vasily Gorbik (1):
      s390/setup: avoid using memblock_enforce_memory_limit

Wang Yugui (1):
      btrfs: check-integrity: fix a warning on write caching disabled disk

Wei Yongjun (1):
      ipmi: msghandler: Make symbol 'remove_work_wq' static

William Kucharski (1):
      net/rds: correct socket tunable error in rds_tcp_tune()

Zekun Shen (1):
      atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Zhou Qingyang (2):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
      net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

liuguoqiang (1):
      net: return correct error code

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

