Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA36D469BC9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346901AbhLFPSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359016AbhLFPQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F717C08EC97;
        Mon,  6 Dec 2021 07:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B62661310;
        Mon,  6 Dec 2021 15:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C640C341C2;
        Mon,  6 Dec 2021 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803395;
        bh=+6kaUhPsWv0HGun56SciAeWDY1iCSsv+lqkPdVxls6I=;
        h=From:To:Cc:Subject:Date:From;
        b=m1B+CrhFkQbRSy1U9keHvxWgkdp42CEbuL8LMUEpFLt0grbVw/9DIQXDqFE1PQC1G
         /EAILbNZ0nt4ErRqt9HxBFOLDfW9HrcQwh1gq9wgdNTloxFWGisaQHXRlfQ90II/6C
         wpcFAORLHQMvYxZS3GFBOMKP9OaDDGHwIPMadlmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/48] 4.19.220-rc1 review
Date:   Mon,  6 Dec 2021 15:56:17 +0100
Message-Id: <20211206145548.859182340@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.220-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.220-rc1
X-KernelTest-Deadline: 2021-12-08T14:55+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.220 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.220-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.220-rc1

Wei Yongjun <weiyongjun1@huawei.com>
    ipmi: msghandler: Make symbol 'remove_work_wq' static

Helge Deller <deller@gmx.de>
    parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Joerg Roedel <jroedel@suse.de>
    x86/64/mm: Map all kernel memory into trampoline_pgd

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Ole Ernst <olebowle@gmx.com>
    USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

Helge Deller <deller@gmx.de>
    parisc: Fix KBUILD_IMAGE for self-extracting kernel

Rob Clark <robdclark@chromium.org>
    drm/msm: Do hw_init() before capturing GPU state

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Keep smc_close_final rc during active close

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Eric Dumazet <edumazet@google.com>
    net: annotate data-races on txq->xmit_lock_owner

Sven Schuchmann <schuchmann@schleissheimer.de>
    net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Zhou Qingyang <zhou1615@umn.edu>
    net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

Benjamin Poirier <bpoirier@nvidia.com>
    net: mpls: Fix notifications when deleting a device

Zhou Qingyang <zhou1615@umn.edu>
    net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

Randy Dunlap <rdunlap@infradead.org>
    natsemi: xtensa: fix section mismatch warnings

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: stop dma transfer in case of NACK

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: recover the bus on access timeout

Linus Torvalds <torvalds@linux-foundation.org>
    fget: check that the fd still exists after getting a ref to it

Jens Axboe <axboe@kernel.dk>
    fs: add fget_many() and fput_many()

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    ipmi: Move remove_work to dedicated workqueue

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Limit max data_size of the kretprobe instances

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Ian Rogers <irogers@google.com>
    perf hist: Fix memory leak of a perf_hpp_fmt

Teng Qi <starmiku1207184332@gmail.com>
    net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

zhangyue <zhangyue1@kylinos.cn>
    net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Teng Qi <starmiku1207184332@gmail.com>
    ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()

Mario Limonciello <mario.limonciello@amd.com>
    ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Unblock session then wake up error handler

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal: core: Reset previous low and high trip during thermal zone init

Wang Yugui <wangyugui@e16-tech.com>
    btrfs: check-integrity: fix a warning on write caching disabled disk

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid using memblock_enforce_memory_limit

Slark Xiao <slark_xiao@163.com>
    platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

liuguoqiang <liuguoqiang@uniontech.com>
    net: return correct error code

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix length of holes reported at end-of-file

Geert Uytterhoeven <geert+renesas@glider.be>
    of: clk: Make <linux/of_clk.h> self-contained

Benjamin Coddington <bcodding@redhat.com>
    NFSv42: Fix pagecache invalidation after COPY/CLONE

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    shm: extend forced shm destroy to support objects from several IPC nses


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/parisc/Makefile                               |   5 +
 arch/parisc/install.sh                             |   1 +
 arch/parisc/kernel/time.c                          |  24 +--
 arch/s390/kernel/setup.c                           |   3 -
 arch/x86/realmode/init.c                           |  12 +-
 drivers/ata/ahci.c                                 |   1 +
 drivers/ata/sata_fsl.c                             |  20 ++-
 drivers/char/ipmi/ipmi_msghandler.c                |  13 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   1 +
 drivers/i2c/busses/i2c-stm32f7.c                   |  11 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  10 ++
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 ++--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/usb/lan78xx.c                          |   2 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/platform/x86/thinkpad_acpi.c               |  12 --
 drivers/scsi/scsi_transport_iscsi.c                |   6 +-
 drivers/thermal/thermal_core.c                     |   2 +
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/tty/serial/msm_serial.c                    |   3 +
 drivers/tty/serial/serial_core.c                   |  13 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  21 ++-
 drivers/usb/typec/tcpm.c                           |   4 -
 drivers/video/console/vgacon.c                     |  14 +-
 fs/btrfs/disk-io.c                                 |  14 +-
 fs/file.c                                          |  19 ++-
 fs/file_table.c                                    |   9 +-
 fs/gfs2/bmap.c                                     |   2 +-
 fs/nfs/nfs42proc.c                                 |   5 +-
 include/linux/file.h                               |   2 +
 include/linux/fs.h                                 |   4 +-
 include/linux/ipc_namespace.h                      |  15 ++
 include/linux/kprobes.h                            |   2 +
 include/linux/netdevice.h                          |  19 ++-
 include/linux/of_clk.h                             |   3 +
 include/linux/sched/task.h                         |   2 +-
 include/linux/siphash.h                            |  14 +-
 ipc/shm.c                                          | 189 ++++++++++++++++-----
 kernel/kprobes.c                                   |   3 +
 lib/siphash.c                                      |  12 +-
 net/core/dev.c                                     |   5 +-
 net/ipv4/devinet.c                                 |   2 +-
 net/mpls/af_mpls.c                                 |  68 ++++++--
 net/rds/tcp.c                                      |   2 +-
 net/rxrpc/peer_object.c                            |  14 +-
 net/smc/smc_close.c                                |   8 +-
 tools/perf/ui/hist.c                               |  28 +--
 tools/perf/util/hist.h                             |   1 -
 53 files changed, 481 insertions(+), 208 deletions(-)


