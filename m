Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340E8133254
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgAGVJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgAGVJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0EA72072A;
        Tue,  7 Jan 2020 21:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431376;
        bh=RjJZF4jJUti91nurhuYEgg0HvWKbhj8q5dVfUjyk164=;
        h=From:To:Cc:Subject:Date:From;
        b=uA2+ge5oExHnf1uvtBr3rllox82q8PauNUP4YO2inOTN+IIRZ68D9RX20AlW7Megm
         WA03MwWZE6pFTDP9h0GThYp9FXLP9p/yoMh60rXNK67F22Zjq2czF84Q1yYTf3yJI5
         jbgAsvNs4QPJtYeytuzTygkFUmo/Q88mIbAius3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/74] 4.14.163-stable review
Date:   Tue,  7 Jan 2020 21:54:25 +0100
Message-Id: <20200107205135.369001641@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.163-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.163-rc1
X-KernelTest-Deadline: 2020-01-09T20:52+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.163 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.163-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.163-rc1

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/bts: Fix the use of page_private()

SeongJae Park <sjpark@amazon.de>
    xen/blkback: Avoid unmapping unmapped grant pages

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp: fix physical to logical CPU map for SMT

Eric Dumazet <edumazet@google.com>
    net: add annotations on hh->hh_len lockless accesses

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power failed warning

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Discard undersized packets

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Modify byte order for an error message

David Howells <dhowells@redhat.com>
    rxrpc: Fix possible NULL pointer access in ICMP handling

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etb10: Do not call smp_processor_id from preemptible

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc-etf: Do not call smp_processor_id from preemptible

Florian Westphal <fw@strlen.de>
    selftests: rtnetlink: add addresses with fixed life time

Daniel Axtens <dja@axtens.net>
    powerpc/pseries/hvconsole: Fix stack overread via udbg

Imre Deak <imre.deak@intel.com>
    drm/mst: Fix MST sideband up-reply failure handling

Chad Dupuis <cdupuis@marvell.com>
    scsi: qedf: Do not retry ELS request if qedf_alloc_cmd fails

Al Viro <viro@zeniv.linux.org.uk>
    fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Leo Yan <leo.yan@linaro.org>
    tty: serial: msm_serial: Fix lockup for sysrq and oops

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: usb: fix memory leak in af9005_identify_state

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove AB8505 USB regulator

Colin Ian King <colin.king@canonical.com>
    media: flexcop-usb: ensure -EIO is returned on error condition

Navid Emamdoost <navid.emamdoost@gmail.com>
    Bluetooth: Fix memory leak in hci_connect_le_scan

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: delete a stray unlock

Oliver Neukum <oneukum@suse.com>
    Bluetooth: btusb: fix PM leak in error case of setup

Michael Haener <michael.haener@siemens.com>
    platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems DMI table

Omar Sandoval <osandov@fb.com>
    xfs: don't check for AG deadlock for realtime files in bunmapi

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Drop superfluous INIT_WORK of del_work

Scott Mayhew <smayhew@redhat.com>
    nfsd4: fix up replay_matches_cache()

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Check NULL governor in available_governors_show

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Revert support for execute-only user mappings

Wen Yang <wenyang@linux.alibaba.com>
    ftrace: Avoid potential division by zero in function profiler

chenqiwu <chenqiwu@xiaomi.com>
    exit: panic before exit_mm() on global init exit

Takashi Iwai <tiwai@suse.de>
    ALSA: firewire-motu: Correct a typo in the clock proc string

Colin Ian King <colin.king@canonical.com>
    ALSA: cs4236: fix error return comparison of an unsigned integer

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have the histogram compare functions convert to u64 first

Prateek Sood <prsood@codeaurora.org>
    tracing: Fix lock inversion in trace_event_enable_tgid_record()

Russell King <rmk+kernel@armlinux.org.uk>
    gpiolib: fix up emulated open drain outputs

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Fix AHCI resources management

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Allow optional reset controller to be used

Florian Fainelli <f.fainelli@gmail.com>
    ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle Persistent Reservations

Lukas Wunner <lukas@wunner.de>
    dmaengine: Fix access to uninitialized dma_slave_caps

Amir Goldstein <amir73il@gmail.com>
    locks: print unsigned ino in /proc/locks

Aleksandr Yashkin <a.yashkin@inango-systems.com>
    pstore/ram: Write new dumps to start of recycled zones

Shakeel Butt <shakeelb@google.com>
    memcg: account security cred as well to kmemcg

Chanho Min <chanho.min@lge.com>
    mm/zsmalloc.c: fix the migrated zspage statistics.

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: avoid decrementing transmit_queue_sz if it is 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: CEC 2.0-only bcast messages were ignored

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pulse8-cec: fix lost cec_transmit_attempt_done() call

Paul Burton <paulburton@kernel.org>
    MIPS: Avoid VDSO ABI breakage due to global register variable

Stefan Mavrodiev <stefan@olimex.com>
    drm/sun4i: hdmi: Remove duplicate cleanup calls

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: limit to INT_MAX in create_blob ioctl

Christian Brauner <christian.brauner@ubuntu.com>
    taskstats: fix data-race

Brian Foster <bfoster@redhat.com>
    xfs: fix mount failure crash on invalid iclog memory access

Andy Whitcroft <apw@canonical.com>
    PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Juergen Gross <jgross@suse.com>
    xen/balloon: fix ballooned page accounting without hotplug enabled

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: prevent premature module unload

Parav Pandit <parav@mellanox.com>
    IB/mlx4: Follow mirror sequence of device add during device removal

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Avoid SBD overflow condition in irq handler

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    md: raid1: check rdev before reference in raid1_sync_request func

Jens Axboe <axboe@kernel.dk>
    net: make socket read/write_iter() honor IOCB_NOWAIT

EJ Hsu <ejh@nvidia.com>
    usb: gadget: fix wrong endpoint desc

Hans de Goede <hdegoede@redhat.com>
    drm/nouveau: Move the declaration of struct nouveau_conn_atom up a bit

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: stop discovering if oob mode is disconnected

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: iscsi: qla4xxx: fix double free in probe

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Don't call qlt_async_event twice

Bo Wu <wubo40@huawei.com>
    scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Steve Wise <larrystevenwise@gmail.com>
    rxe: correctly calculate iCRC for unaligned payloads

Chuhong Yuan <hslester96@gmail.com>
    RDMA/cma: add missed unregister_pernet_subsys in init failure

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Don't fail devfreq_dev_release if not in list

Geert Uytterhoeven <geert+renesas@glider.be>
    iio: adc: max9611: Fix too short conversion time delay

James Smart <jsmart2021@gmail.com>
    nvme_fc: add module to ops template to allow module references


-------------

Diffstat:

 .../bindings/clock/renesas,rcar-usb2-clock-sel.txt |   2 +-
 Makefile                                           |   4 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |   4 +-
 arch/arm64/include/asm/pgtable-prot.h              |   5 +-
 arch/arm64/include/asm/pgtable.h                   |  10 +-
 arch/arm64/mm/fault.c                              |   2 +-
 arch/mips/include/asm/thread_info.h                |  20 +++-
 arch/powerpc/platforms/pseries/hvconsole.c         |   2 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  22 ++--
 arch/s390/kernel/smp.c                             |  80 ++++++++++-----
 arch/x86/events/intel/bts.c                        |  16 ++-
 block/compat_ioctl.c                               |  11 ++
 drivers/ata/ahci_brcm.c                            | 112 +++++++++++++++------
 drivers/ata/libahci_platform.c                     |   6 +-
 drivers/block/xen-blkback/blkback.c                |   2 +
 drivers/block/xen-blkback/xenbus.c                 |  10 ++
 drivers/bluetooth/btusb.c                          |   3 +-
 drivers/devfreq/devfreq.c                          |   8 +-
 drivers/firewire/net.c                             |   6 +-
 drivers/gpio/gpiolib.c                             |   8 ++
 drivers/gpu/drm/drm_dp_mst_topology.c              |   6 +-
 drivers/gpu/drm/drm_property.c                     |   2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h        | 110 ++++++++++----------
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   2 -
 drivers/hwtracing/coresight/coresight-etb10.c      |   4 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   4 +-
 drivers/iio/adc/max9611.c                          |  16 +--
 drivers/infiniband/core/cma.c                      |   1 +
 drivers/infiniband/hw/mlx4/main.c                  |   9 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   6 ++
 drivers/infiniband/sw/rxe/rxe_resp.c               |   7 ++
 drivers/md/raid1.c                                 |   2 +-
 drivers/media/cec/cec-adap.c                       |  20 +++-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |   5 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |  17 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  23 ++++-
 drivers/nvme/host/fc.c                             |  14 ++-
 drivers/nvme/target/fcloop.c                       |   1 +
 drivers/platform/x86/pmc_atom.c                    |   8 ++
 drivers/regulator/ab8500.c                         |  17 ----
 drivers/scsi/libsas/sas_discover.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  15 +--
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +
 drivers/scsi/qedf/qedf_els.c                       |  16 +--
 drivers/scsi/qla2xxx/qla_isr.c                     |   4 -
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   1 -
 drivers/scsi/qla4xxx/ql4_os.c                      |   1 -
 drivers/tty/hvc/hvc_vio.c                          |  16 ++-
 drivers/tty/serial/msm_serial.c                    |  13 ++-
 drivers/usb/gadget/function/f_ecm.c                |   6 +-
 drivers/usb/gadget/function/f_rndis.c              |   1 +
 drivers/xen/balloon.c                              |   3 +-
 fs/compat_ioctl.c                                  |   3 +-
 fs/locks.c                                         |   2 +-
 fs/nfsd/nfs4state.c                                |  15 ++-
 fs/pstore/ram.c                                    |  11 ++
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/linux/ahci_platform.h                      |   2 +
 include/linux/dmaengine.h                          |   5 +-
 include/linux/nvme-fc-driver.h                     |   4 +
 include/linux/regulator/ab8500.h                   |   1 -
 include/net/neighbour.h                            |   2 +-
 kernel/cred.c                                      |   6 +-
 kernel/exit.c                                      |  12 ++-
 kernel/power/snapshot.c                            |   9 +-
 kernel/taskstats.c                                 |  30 ++++--
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace.c                               |   8 ++
 kernel/trace/trace_events.c                        |   8 +-
 kernel/trace/tracing_map.c                         |   4 +-
 mm/mmap.c                                          |   6 --
 mm/zsmalloc.c                                      |   5 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/core/neighbour.c                               |   4 +-
 net/ethernet/eth.c                                 |   7 +-
 net/rxrpc/peer_event.c                             |   3 +
 net/socket.c                                       |   4 +-
 sound/firewire/motu/motu-proc.c                    |   2 +-
 sound/isa/cs423x/cs4236.c                          |   3 +-
 sound/pci/ice1712/ice1724.c                        |   9 +-
 tools/testing/selftests/net/rtnetlink.sh           |  21 ++++
 86 files changed, 610 insertions(+), 295 deletions(-)


