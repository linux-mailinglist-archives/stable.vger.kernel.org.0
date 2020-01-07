Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED31333B2
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgAGVUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgAGVEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:04:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C4C2081E;
        Tue,  7 Jan 2020 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431046;
        bh=dw1jMjNTgxTU0xVn19VrJvKJBOJNQ6DxPhBJDfv5Ca0=;
        h=From:To:Cc:Subject:Date:From;
        b=M7W5C+lOKskp6E+uf189YdhQV9MmZs+qnjLGwC9uE6LbfRglkwTMGofgIv+AUJCkG
         2PvsuzDqfW+1SXSE1XLMWE5cG44dGnI8WKIVw1rYyFbNrR93q3caBP8UIuqwkpR2pz
         ch0EEFUz8tmcUBHKlnUNWQu7B3MzJsg3OopgZkKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/115] 4.19.94-stable review
Date:   Tue,  7 Jan 2020 21:53:30 +0100
Message-Id: <20200107205240.283674026@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.94-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.94-rc1
X-KernelTest-Deadline: 2020-01-09T20:53+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.94 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.94-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.94-rc1

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/bts: Fix the use of page_private()

SeongJae Park <sjpark@amazon.de>
    xen/blkback: Avoid unmapping unmapped grant pages

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp: fix physical to logical CPU map for SMT

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_tnc_start_commit: Fix OOB in layout_in_gaps

Eric Dumazet <edumazet@google.com>
    net: add annotations on hh->hh_len lockless accesses

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: periodically yield scrub threads to the scheduler

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Discard undersized packets

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Modify byte order for an error message

Taehee Yoo <ap420073@gmail.com>
    net: core: limit nested device depth

Eric Dumazet <edumazet@google.com>
    tcp: annotate tp->rcv_nxt lockless reads

David Howells <dhowells@redhat.com>
    rxrpc: Fix possible NULL pointer access in ICMP handling

Michael Roth <mdroth@linux.vnet.ibm.com>
    KVM: PPC: Book3S HV: use smp_mb() when setting/clearing host_ipi flag

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

Jan Kara <jack@suse.cz>
    bdev: Refresh bdev size for disks without partitioning

Jan Kara <jack@suse.cz>
    bdev: Factor out bdev revalidation into a common helper

Al Viro <viro@zeniv.linux.org.uk>
    fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Leo Yan <leo.yan@linaro.org>
    tty: serial: msm_serial: Fix lockup for sysrq and oops

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power failed warning

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

Yunfeng Ye <yeyunfeng@huawei.com>
    ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: Reset ALPS touchpads on resume

Scott Mayhew <smayhew@redhat.com>
    nfsd4: fix up replay_matches_cache()

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Check NULL governor in available_governors_show

Arnd Bergmann <arnd@arndb.de>
    drm/msm: include linux/sched/task.h

Wen Yang <wenyang@linux.alibaba.com>
    ftrace: Avoid potential division by zero in function profiler

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Revert support for execute-only user mappings

chenqiwu <chenqiwu@xiaomi.com>
    exit: panic before exit_mm() on global init exit

Takashi Iwai <tiwai@suse.de>
    ALSA: firewire-motu: Correct a typo in the clock proc string

Colin Ian King <colin.king@canonical.com>
    ALSA: cs4236: fix error return comparison of an unsigned integer

John Johansen <john.johansen@canonical.com>
    apparmor: fix aa_xattrs_match() may sleep while holding a RCU lock

Sven Schnelle <svens@linux.ibm.com>
    tracing: Fix endianness bug in histogram trigger

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have the histogram compare functions convert to u64 first

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    tracing: Avoid memory leak in process_system_preds()

Prateek Sood <prsood@codeaurora.org>
    tracing: Fix lock inversion in trace_event_enable_tgid_record()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30

Zong Li <zong.li@sifive.com>
    riscv: ftrace: correct the condition logic in function graph tracer

Russell King <rmk+kernel@armlinux.org.uk>
    gpiolib: fix up emulated open drain outputs

Sascha Hauer <s.hauer@pengutronix.de>
    libata: Fix retrieving of active qcs

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: BCM7425 AHCI requires AHCI_HFLAG_DELAY_ENGINE

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Add missing clock management during recovery

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Allow optional reset controller to be used

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Fix AHCI resources management

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

Yang Shi <yang.shi@linux.alibaba.com>
    mm: move_pages: return valid node id in status if the page is already on the target node

Shakeel Butt <shakeelb@google.com>
    memcg: account security cred as well to kmemcg

Chanho Min <chanho.min@lge.com>
    mm/zsmalloc.c: fix the migrated zspage statistics.

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: check 'transmit_in_progress', not 'transmitting'

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

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add headset Mic no shutup for ALC283

Hui Wang <hui.wang@canonical.com>
    ALSA: usb-audio: set the interface format after resume on Dell WD19

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix set_format altsetting sanity check

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code

Phil Sutter <phil@nwl.cc>
    netfilter: nft_tproxy: Fix port selector on Big Endian

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm: limit to INT_MAX in create_blob ioctl

Christian Brauner <christian.brauner@ubuntu.com>
    taskstats: fix data-race

Brian Foster <bfoster@redhat.com>
    xfs: fix mount failure crash on invalid iclog memory access

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen

Chris Chiu <chiu@endlessm.com>
    ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Bass Speaker and fixed dac for bass speaker

Andy Whitcroft <apw@canonical.com>
    PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Juergen Gross <jgross@suse.com>
    xen/balloon: fix ballooned page accounting without hotplug enabled

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: prevent premature module unload

Maor Gottlieb <maorg@mellanox.com>
    IB/mlx5: Fix steering rule of drop and count

Parav Pandit <parav@mellanox.com>
    IB/mlx4: Follow mirror sequence of device add during device removal

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Avoid SBD overflow condition in irq handler

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    md: raid1: check rdev before reference in raid1_sync_request func

David Howells <dhowells@redhat.com>
    afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP

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
    scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Send Notify ACK after N2N PLOGI

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Configure local loop for N2N target

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Don't call qlt_async_event twice

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Drop superfluous INIT_WORK of del_work

Bo Wu <wubo40@huawei.com>
    scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Steve Wise <larrystevenwise@gmail.com>
    rxe: correctly calculate iCRC for unaligned payloads

Chuhong Yuan <hslester96@gmail.com>
    RDMA/cma: add missed unregister_pernet_subsys in init failure

David Howells <dhowells@redhat.com>
    afs: Fix SELinux setting security label on /afs

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix afs_find_server lookups for ipv4 peers

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Don't fail devfreq_dev_release if not in list

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Set scaling_max_freq to max on OPP notifier error

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Fix devfreq_notifier_call returning errno

Geert Uytterhoeven <geert+renesas@glider.be>
    iio: adc: max9611: Fix too short conversion time delay

David Galiffi <David.Galiffi@amd.com>
    drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dongle

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: add cache flush workaround to gfx8 emit_fence

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: add check before enabling/disabling broadcast mode

James Smart <jsmart2021@gmail.com>
    nvme-fc: fix double-free scenarios on hw queues

James Smart <jsmart2021@gmail.com>
    nvme_fc: add module to ops template to allow module references


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 .../bindings/clock/renesas,rcar-usb2-clock-sel.txt |   2 +-
 Makefile                                           |   4 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |   4 +-
 arch/arm64/include/asm/pgtable-prot.h              |   5 +-
 arch/arm64/include/asm/pgtable.h                   |  10 +-
 arch/arm64/mm/fault.c                              |   2 +-
 arch/mips/include/asm/thread_info.h                |  20 +-
 arch/powerpc/include/asm/kvm_ppc.h                 | 100 +++++++-
 arch/powerpc/kernel/dbell.c                        |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c               |   2 +-
 arch/powerpc/platforms/powernv/smp.c               |   2 +-
 arch/powerpc/platforms/pseries/hvconsole.c         |   2 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   6 +-
 arch/powerpc/sysdev/xics/icp-opal.c                |   6 +-
 arch/riscv/kernel/ftrace.c                         |   2 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  22 +-
 arch/s390/kernel/smp.c                             |  80 ++++--
 arch/x86/events/intel/bts.c                        |  16 +-
 block/compat_ioctl.c                               |  11 +
 drivers/acpi/sysfs.c                               |   6 +-
 drivers/ata/ahci_brcm.c                            | 140 ++++++++---
 drivers/ata/libahci_platform.c                     |   6 +-
 drivers/ata/libata-core.c                          |  24 ++
 drivers/ata/sata_fsl.c                             |   2 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/block/xen-blkback/blkback.c                |   2 +
 drivers/block/xen-blkback/xenbus.c                 |  10 +
 drivers/bluetooth/btusb.c                          |   3 +-
 drivers/devfreq/devfreq.c                          |  30 +--
 drivers/firewire/net.c                             |   6 +-
 drivers/gpio/gpiolib.c                             |   8 +
 drivers/gpu/drm/amd/amdgpu/df_v3_6.c               |  38 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |  22 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   6 +-
 drivers/gpu/drm/drm_property.c                     |   2 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   1 +
 drivers/gpu/drm/nouveau/nouveau_connector.h        | 110 ++++-----
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   2 -
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  12 +-
 drivers/hwtracing/coresight/coresight-etb10.c      |   4 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   4 +-
 drivers/iio/adc/max9611.c                          |  16 +-
 drivers/infiniband/core/cma.c                      |   1 +
 drivers/infiniband/hw/mlx4/main.c                  |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |  13 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   6 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |   7 +
 drivers/md/raid1.c                                 |   2 +-
 drivers/media/cec/cec-adap.c                       |  40 ++-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |   5 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |  17 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  23 +-
 drivers/nvme/host/fc.c                             |  32 ++-
 drivers/nvme/target/fcloop.c                       |   1 +
 drivers/platform/x86/pmc_atom.c                    |   8 +
 drivers/regulator/ab8500.c                         |  17 --
 drivers/scsi/libsas/sas_discover.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  15 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +
 drivers/scsi/qedf/qedf_els.c                       |  16 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  10 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   4 -
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   1 -
 drivers/tty/hvc/hvc_vio.c                          |  16 +-
 drivers/tty/serial/msm_serial.c                    |  13 +-
 drivers/usb/gadget/function/f_ecm.c                |   6 +-
 drivers/usb/gadget/function/f_rndis.c              |   1 +
 drivers/xen/balloon.c                              |   3 +-
 fs/afs/dynroot.c                                   |   3 +
 fs/afs/server.c                                    |  21 +-
 fs/afs/super.c                                     |   1 -
 fs/block_dev.c                                     |  37 +--
 fs/compat_ioctl.c                                  |   3 +-
 fs/locks.c                                         |   2 +-
 fs/nfsd/nfs4state.c                                |  15 +-
 fs/pstore/ram.c                                    |  11 +
 fs/ubifs/tnc_commit.c                              |  34 ++-
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/scrub/common.h                              |   9 +-
 fs/xfs/xfs_log.c                                   |   2 +
 include/linux/ahci_platform.h                      |   2 +
 include/linux/dmaengine.h                          |   5 +-
 include/linux/libata.h                             |   1 +
 include/linux/netdevice.h                          |   4 +
 include/linux/nvme-fc-driver.h                     |   4 +
 include/linux/regulator/ab8500.h                   |   1 -
 include/net/neighbour.h                            |   2 +-
 kernel/cred.c                                      |   6 +-
 kernel/exit.c                                      |  12 +-
 kernel/power/snapshot.c                            |   9 +-
 kernel/taskstats.c                                 |  30 ++-
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace.c                               |   8 +
 kernel/trace/trace_events.c                        |   8 +-
 kernel/trace/trace_events_filter.c                 |   2 +-
 kernel/trace/trace_events_hist.c                   |  21 +-
 kernel/trace/tracing_map.c                         |   4 +-
 mm/migrate.c                                       |  23 +-
 mm/mmap.c                                          |   6 -
 mm/zsmalloc.c                                      |   5 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/core/dev.c                                     | 272 +++++++++++++++++----
 net/core/neighbour.c                               |   4 +-
 net/ethernet/eth.c                                 |   7 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_diag.c                                |   2 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_ipv4.c                                |   3 +-
 net/ipv4/tcp_minisocks.c                           |   7 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/netfilter/nft_tproxy.c                         |   4 +-
 net/rxrpc/peer_event.c                             |   3 +
 net/socket.c                                       |   4 +-
 security/apparmor/apparmorfs.c                     |   2 +-
 security/apparmor/domain.c                         |  82 ++++---
 security/apparmor/policy.c                         |   4 +-
 sound/firewire/motu/motu-proc.c                    |   2 +-
 sound/isa/cs423x/cs4236.c                          |   3 +-
 sound/pci/hda/patch_realtek.c                      |  61 ++++-
 sound/pci/ice1712/ice1724.c                        |   9 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/pcm.c                                    |  25 +-
 sound/usb/quirks-table.h                           |   3 +-
 sound/usb/quirks.c                                 |  11 +
 sound/usb/usbaudio.h                               |   3 +-
 tools/testing/selftests/net/rtnetlink.sh           |  21 ++
 tools/testing/selftests/rseq/param_test.c          |  18 +-
 137 files changed, 1371 insertions(+), 559 deletions(-)


