Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FEE38EF0D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhEXPz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234152AbhEXPxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F2861402;
        Mon, 24 May 2021 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870766;
        bh=RmFncrvL5KO4V+WyV9LJUxQk4ayFQgta7DLvgwE7SUM=;
        h=From:To:Cc:Subject:Date:From;
        b=oeO1ZWX7T8QUH++zyscx+XhmH2B3mX/z/h/6asgI9Zf8aXpjqlnvPOYRHmG0sts9P
         3NKes+WdVSxmDjYvkz44WeBamRwCmlW9MiqxSUU8iCZx9fXn2rce5idsfLOFffHG4D
         aKWDkVdnxiFwDXXcdY7plLBv+RNbHirHGpczRU7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/104] 5.10.40-rc1 review
Date:   Mon, 24 May 2021 17:24:55 +0200
Message-Id: <20210524152332.844251980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.40-rc1
X-KernelTest-Deadline: 2021-05-26T15:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.40 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.40-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.40-rc1

Joerg Roedel <jroedel@suse.de>
    x86/boot/compressed/64: Check SEV encryption in the 32-bit boot-path

Francois Gervais <fgervais@distech-controls.com>
    rtc: pcf85063: fallback to parent of_node

Christoph Hellwig <hch@lst.de>
    nvme-multipath: fix double initialization of ANA state

Jan Beulich <jbeulich@suse.com>
    x86/Xen: swap NX determination and GDT setup on BSP

Mike Rapoport <rppt@kernel.org>
    openrisc: mm/init.c: remove unused memblock_region variable in map_ram()

Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>
    drm/i915/gt: Disable HiZ Raw Stall Optimization on broken gen7

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tty: vt: always invoke vc->vc_sw->con_resize callback

Maciej W. Rozycki <macro@orcam.me.uk>
    vt: Fix character height handling with VT_RESIZEX

Maciej W. Rozycki <macro@orcam.me.uk>
    vt_ioctl: Revert VT_RESIZEX parameter handling removal

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Record video mode changes with VT_RESIZEX

Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
    video: hgafb: fix potential NULL pointer dereference

Tom Seewald <tseewald@gmail.com>
    qlcnic: Add null check after calling netdev_alloc_skb

Phillip Potter <phil@philpotter.co.uk>
    leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Darrick J. Wong <djwong@kernel.org>
    ics932s401: fix broken handling of errors when word reading fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rtlwifi: properly check for alloc_workqueue() failure

Phillip Potter <phil@philpotter.co.uk>
    scsi: ufs: handle cleanup correctly on devm_reset_control_get error

Anirudh Rayabharam <mail@anirudhrb.com>
    net: stmicro: handle clk_prepare() failure during init

Du Cheng <ducheng2@gmail.com>
    ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "niu: fix missing checks of niu_pci_eeprom_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "qlcnic: Avoid potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rtlwifi: fix a potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: rcar_drif: fix a memory disclosure"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    cdrom: gdrom: initialize global variable at init time

Atul Gopinathan <atulgopinathan@gmail.com>
    cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "gdrom: fix a memory leak bug"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "scsi: ufs: fix a missing check of devm_reset_control_get"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ecryptfs: replace BUG_ON with error handling code"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: imsttfb: fix potential NULL pointer dereferences"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: stmicro: fix a missing check of clk_prepare"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "video: hgafb: fix potential NULL pointer dereference"

Arnd Bergmann <arnd@arndb.de>
    kcsan: Fix debugfs initcall return type

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix crash with transient storage and zero chunk size

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: fix a crash when an origin has no snapshots

Varad Gautam <varad.gautam@suse.com>
    ipc/mqueue, msg, sem: avoid relying on a stack reference past its expiry

Jan Beulich <jbeulich@suse.com>
    xen-pciback: reconfigure also from backend watch handler

Jan Beulich <jbeulich@suse.com>
    xen-pciback: redo VF placement in the virtual topology

Daniel Beer <dlbeer@gmail.com>
    mmc: sdhci-pci-gli: increase 1.8V regulator wait

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/syscall: Fix ptrace syscall info with scv syscalls

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/syscall: Use pt_regs.trap to distinguish syscall ABI difference between sc and scv syscalls

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: update sdma golden setting for Navi12

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: update gc golden setting for Navi12

Changfeng <Changfeng.Zhu@amd.com>
    drm/amdgpu: disable 3DCGCG on picasso/raven1 to avoid compute hang

Yi Li <liyi@loongson.cn>
    drm/amdgpu: Fix GPU TLB update error when PAGE_SIZE > AMDGPU_PAGE_SIZE

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Forward page-faults which happen during emulation

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Use __put_user()/__get_user() for data accesses

Joerg Roedel <jroedel@suse.de>
    x86/sev-es: Don't return NULL from sev_es_get_ghcb()

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev-es: Invalidate the GHCB after completing VMGEXIT

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible use-after-completion

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"

Anirudh Rayabharam <mail@anirudhrb.com>
    rapidio: handle create_workqueue() failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    uio_hv_generic: Fix a memory leak in error handling paths

Elia Devito <eliadevito@gmail.com>
    ALSA: hda/realtek: Add fixup for HP Spectre x360 15-df0xxx

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add fixup for HP OMEN laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix silent headphone output on ASUS UX430UA

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: Add some CLOVE SSIDs of ALC293

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: reset eapd coeff to default value for alc287

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix check for the size of isochronous packet payload

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: sb8: add a check for request_region"

Daniel Cordova A <danesc87@gmail.com>
    ALSA: hda: fixup headset for ASUS GU502 laptop

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate MS endpoint descriptors

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix calculation for size of IR context payload

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix racy initialization of LINE6 MIDI

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix amdtp_packet tracepoints event for packet_index field

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0: Don't update period unless prepared

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency

Hsin-Yi Wang <hsinyi@chromium.org>
    misc: eeprom: at24: check suspend status before disable regulator

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix memory leak in smb2_copychunk_range

Josef Bacik <josef@toxicpanda.com>
    btrfs: avoid RCU stalls while running delayed iputs

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc: Fix early setup to make early_ioremap() work

Zqiang <qiang.zhang@windriver.com>
    locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal

Leo Yan <leo.yan@linaro.org>
    locking/lockdep: Correct calling tracepoints

Like Xu <like.xu@linux.intel.com>
    perf/x86: Avoid touching LBR_TOS MSR for Arch LBR

Daniel Wagner <dwagner@suse.de>
    nvmet: seset ns->file when open fails

Oleg Nesterov <oleg@redhat.com>
    ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries: Fix hcall tracing recursion in pv queued spinlocks

Yang Yingliang <yangyingliang@huawei.com>
    tools/testing/selftests/exec: fix link error

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/uverbs: Fix a NULL vs IS_ERR() bug

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix query DCT via DEVX

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel_int0002_vgpio: Only call enable_irq_wake() when using s2idle

Liming Sun <limings@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: Fix a memory barrier issue

James Smart <jsmart2021@gmail.com>
    nvme-fc: clear q_live at beginning of association teardown

Keith Busch <kbusch@kernel.org>
    nvme-tcp: rerun io_work if req_list is not empty

Wu Bo <wubo40@huawei.com>
    nvme-loop: fix memory leak in nvme_loop_create_ctrl()

Wu Bo <wubo40@huawei.com>
    nvmet: fix memory leak in nvmet_alloc_ctrl()

Amit <amit.engel@dell.com>
    nvmet: remove unused ctrl->cqs

Shay Drory <shayd@nvidia.com>
    RDMA/core: Don't access cm_id after its destruction

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Recover from fatal event in dual port mode

Zhen Lei <thunder.leizhen@huawei.com>
    scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Javed Hasan <jhasan@marvell.com>
    scsi: qedf: Add pointer checks in qedf_update_link_speed()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Increase the usable queue depth

Leon Romanovsky <leon@kernel.org>
    RDMA/rxe: Clear all QP fields if creation failed

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Prevent divide-by-zero error triggered by the user

Leon Romanovsky <leon@kernel.org>
    RDMA/siw: Release xarray entry

Leon Romanovsky <leon@kernel.org>
    RDMA/siw: Properly check send and receive CQ pointers

Rijo Thomas <Rijo-john.Thomas@amd.com>
    tee: amdtee: unload TA only when its refcount becomes 0

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    openrisc: Fix a memory leak

Dan Carpenter <dan.carpenter@oracle.com>
    firmware: arm_scpi: Prevent the ternary sign expansion bug


-------------

Diffstat:

 Documentation/powerpc/syscall64-abi.rst            |  10 ++
 Makefile                                           |   4 +-
 arch/openrisc/kernel/setup.c                       |   2 +
 arch/openrisc/mm/init.c                            |   3 +-
 arch/powerpc/include/asm/hvcall.h                  |   3 +
 arch/powerpc/include/asm/paravirt.h                |  22 +++-
 arch/powerpc/include/asm/ptrace.h                  |  45 ++++---
 arch/powerpc/include/asm/syscall.h                 |  42 ++++---
 arch/powerpc/kernel/setup_64.c                     |   4 +-
 arch/powerpc/platforms/pseries/hvCall.S            |  10 ++
 arch/powerpc/platforms/pseries/lpar.c              |   3 +-
 arch/x86/boot/compressed/head_64.S                 |  85 +++++++++++++
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/kernel/sev-es-shared.c                    |   1 +
 arch/x86/kernel/sev-es.c                           | 136 +++++++++++++--------
 arch/x86/xen/enlighten_pv.c                        |   8 +-
 drivers/cdrom/gdrom.c                              |  13 +-
 drivers/firmware/arm_scpi.c                        |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   4 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 -
 drivers/gpu/drm/i915/gt/gen7_renderclear.c         |   5 +-
 drivers/hwmon/lm80.c                               |  11 +-
 drivers/infiniband/core/cma.c                      |   5 +-
 drivers/infiniband/core/uverbs_std_types_device.c  |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   6 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   7 ++
 drivers/infiniband/sw/siw/siw_verbs.c              |  11 +-
 drivers/leds/leds-lp5523.c                         |   2 +-
 drivers/md/dm-snap.c                               |   6 +-
 drivers/media/platform/rcar_drif.c                 |   1 -
 drivers/misc/eeprom/at24.c                         |   6 +-
 drivers/misc/ics932s401.c                          |   2 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |   7 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   8 +-
 drivers/net/ethernet/sun/niu.c                     |  32 +++--
 drivers/net/wireless/realtek/rtlwifi/base.c        |  18 +--
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/fc.c                             |  12 ++
 drivers/nvme/host/multipath.c                      |  55 +++++----
 drivers/nvme/host/nvme.h                           |   8 +-
 drivers/nvme/host/tcp.c                            |   5 +-
 drivers/nvme/target/core.c                         |  15 +--
 drivers/nvme/target/io-cmd-file.c                  |   8 +-
 drivers/nvme/target/loop.c                         |   4 +-
 drivers/nvme/target/nvmet.h                        |   1 -
 drivers/platform/mellanox/mlxbf-tmfifo.c           |  11 +-
 drivers/platform/x86/Kconfig                       |   2 +-
 drivers/platform/x86/dell-smbios-wmi.c             |   3 +-
 drivers/platform/x86/intel_int0002_vgpio.c         |  80 ++++++++----
 drivers/rapidio/rio_cm.c                           |  17 ++-
 drivers/rtc/rtc-pcf85063.c                         |   7 +-
 drivers/scsi/qedf/qedf_main.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |   3 +-
 drivers/scsi/ufs/ufs-hisi.c                        |  15 ++-
 drivers/scsi/ufs/ufshcd.c                          |   5 +-
 drivers/tee/amdtee/amdtee_private.h                |  13 ++
 drivers/tee/amdtee/call.c                          |  94 ++++++++++++--
 drivers/tee/amdtee/core.c                          |  15 ++-
 drivers/tty/serial/mvebu-uart.c                    |   3 -
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/tty/vt/vt_ioctl.c                          |  57 +++++++--
 drivers/uio/uio_hv_generic.c                       |   8 +-
 drivers/video/console/vgacon.c                     |  56 +++++----
 drivers/video/fbdev/core/fbcon.c                   |   2 +-
 drivers/video/fbdev/hgafb.c                        |  21 ++--
 drivers/video/fbdev/imsttfb.c                      |   5 -
 drivers/xen/xen-pciback/vpci.c                     |  14 ++-
 drivers/xen/xen-pciback/xenbus.c                   |  22 +++-
 fs/btrfs/inode.c                                   |   1 +
 fs/cifs/smb2ops.c                                  |   2 +
 fs/ecryptfs/crypto.c                               |   6 +-
 include/linux/console_struct.h                     |   1 +
 ipc/mqueue.c                                       |   6 +-
 ipc/msg.c                                          |   6 +-
 ipc/sem.c                                          |   6 +-
 kernel/kcsan/debugfs.c                             |   3 +-
 kernel/locking/lockdep.c                           |   4 +-
 kernel/locking/mutex-debug.c                       |   4 +-
 kernel/locking/mutex-debug.h                       |   2 +-
 kernel/locking/mutex.c                             |  18 ++-
 kernel/locking/mutex.h                             |   4 +-
 kernel/ptrace.c                                    |  18 ++-
 sound/firewire/Kconfig                             |   4 +-
 sound/firewire/amdtp-stream-trace.h                |   6 +-
 sound/firewire/amdtp-stream.c                      |  42 ++++---
 sound/firewire/bebob/bebob.c                       |   2 +-
 sound/firewire/dice/dice-alesis.c                  |   2 +-
 sound/firewire/dice/dice-tcelectronic.c            |   4 +-
 sound/firewire/oxfw/oxfw.c                         |   1 -
 sound/isa/sb/sb8.c                                 |   4 -
 sound/pci/hda/patch_realtek.c                      | 135 +++++++++++++++++++-
 sound/pci/intel8x0.c                               |   7 ++
 sound/usb/line6/driver.c                           |   4 +
 sound/usb/line6/pod.c                              |   5 -
 sound/usb/line6/variax.c                           |   6 -
 sound/usb/midi.c                                   |   4 +
 tools/testing/selftests/exec/Makefile              |   6 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  27 ++--
 103 files changed, 1035 insertions(+), 434 deletions(-)


