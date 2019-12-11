Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41FF11AF2B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbfLKPLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfLKPLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20B920663;
        Wed, 11 Dec 2019 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077092;
        bh=Im0FlfPHmFITJa8qBqZ6j7tCo0rzWQphjg6vjmeYqdU=;
        h=From:To:Cc:Subject:Date:From;
        b=caRNPw+idMh9Tki9PALKsw3/w8sQbBNOpAhtPUs/z0Bdw9pinF8P8u54k7YFrboom
         JHhQfjw6HMjJ4Q+0yZrF8TenkL8iHM9DHvIDYnKU4f3O0rTaeaKGYt4u7C4KRGwe+j
         demkOJJ+zkcNTq5xY033FVgIgxiwMKozBOkLrEA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/105] 5.3.16-stable review
Date:   Wed, 11 Dec 2019 16:04:49 +0100
Message-Id: <20191211150221.153659747@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.16-rc1
X-KernelTest-Deadline: 2019-12-13T15:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.16 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.16-rc1

Jann Horn <jannh@google.com>
    binder: Handle start==NULL in binder_update_page_range()

Jann Horn <jannh@google.com>
    binder: Prevent repeated use of ->mmap() via NULL mapping

Jann Horn <jannh@google.com>
    binder: Fix race between mmap() and binder_alloc_print_pages()

Nicolas Pitre <nico@fluxnic.net>
    vcs: prevent write access to vcsu devices

Wei Wang <wvw@google.com>
    thermal: Fix deadlock in thermal thermal_zone_device_check

Jan Kara <jack@suse.cz>
    iomap: Fix pipe page leakage during splicing

Viresh Kumar <viresh.kumar@linaro.org>
    RDMA/qib: Validate ->show()/store() callbacks before calling them

Johan Hovold <johan@kernel.org>
    can: ucan: fix non-atomic allocation in completion handler

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: Fix SPI_CS_HIGH setting when using native and GPIO CS

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: atmel: Fix CS high support

Patrice Chotard <patrice.chotard@st.com>
    spi: stm32-qspi: Fix kernel oops when unbinding driver

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_reportstat

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_report

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ecdh - fix big endian bug in ECC library

Mark Salter <msalter@redhat.com>
    crypto: ccp - fix uninitialized list head

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: geode-aes - switch to skcipher for cbc(aes) fallback

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: af_alg - cast ki_complete ternary op to int

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Grab KVM's srcu lock when setting nested state

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove a spurious export of a static function

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not modify masked bits of shared MSRs

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a new one

Marek Szyprowski <m.szyprowski@samsung.com>
    arm64: dts: exynos: Revert "Remove unneeded address space mapping for soc node"

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i810: Prevent underflow in ioctl

Sean Paul <seanpaul@chromium.org>
    drm: damage_helper: Fix race checking plane->state->fb

Johan Hovold <johan@kernel.org>
    drm/msm: fix memleak on release

Jan Kara <jack@suse.cz>
    jbd2: Fix possible overflow in jbd2_log_space_left()

Tejun Heo <tj@kernel.org>
    kernfs: fix ino wrap-around detection

J. Bruce Fields <bfields@redhat.com>
    nfsd: restore NFSv3 ACL support

Trond Myklebust <trondmy@gmail.com>
    nfsd: Ensure CLONE persists data and metadata changes to the target file

Jouni Hogander <jouni.hogander@unikie.com>
    can: slcan: Fix use-after-free Read in slcan_open

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    tty: vt: keyboard: reject invalid keycodes

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix SMB2 oplock break processing

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Joerg Roedel <jroedel@suse.de>
    x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

Sean Young <sean@mess.org>
    media: rc: mark input device as pointing stick

Navid Emamdoost <navid.emamdoost@gmail.com>
    Input: Fix memory leak in psxpad_spi_probe

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Fix input validation for sysfs.

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add upside-down quirk for Teclast X89 tablet

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Modify stream stripe mask only when needed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda - Add mute led support for HP ProBook 645 G4

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid potential buffer overflows

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Avoid RPC delays when exiting suspend

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure req->submit is copied when req is deferred

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify nlink

Jens Axboe <axboe@kernel.dk>
    io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR

Wen Yang <wenyang@linux.alibaba.com>
    i2c: core: fix use after free in of_i2c_notify

Chuhong Yuan <hslester96@gmail.com>
    net: ep93xx_eth: fix mismatch of request_mem_region in remove

David Howells <dhowells@redhat.com>
    afs: Fix race in commit bulk status fetch

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix ETS bandwidth validation bug

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: reallocate SSU' buffer size when pfc_en changes

Ulrich Hecht <uli+renesas@fpond.eu>
    ravb: implement MTU change while device is up

Chuhong Yuan <hslester96@gmail.com>
    rsxx: add missed destroy_workqueue calls in remove

Ilya Dryomov <idryomov@gmail.com>
    rbd: silence bogus uninitialized warning in rbd_object_map_update_finish()

Vitaly Kuznetsov <vkuznets@redhat.com>
    selftests: kvm: fix build with glibc >= 2.30

Yunhao Tian <t123yh@outlook.com>
    drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix potential lockdep warning

paulhsia <paulhsia@chromium.org>
    ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/core: Consistently fail fork on allocation failures

Vincent Guittot <vincent.guittot@linaro.org>
    sched/pelt: Fix update of blocked PELT ordering

Peter Zijlstra <peterz@infradead.org>
    sched/core: Avoid spurious lock dependencies

Pan Bian <bianpan2016@163.com>
    Input: cyttsp4_core - fix use after free bug

Junichi Nomura <j-nomura@ce.jp.nec.com>
    block: check bi_size overflow before merge

Xiaodong Xu <stid.smth@gmail.com>
    xfrm: release device reference for invalid state

Stephan Gerhold <stephan@gerhold.net>
    NFC: nxp-nci: Fix NULL pointer dereference after I2C communication error

Chiou, Cooper <cooper.chiou@intel.com>
    ALSA: hda: Add Cometlake-S PCI ID

Al Viro <viro@zeniv.linux.org.uk>
    ecryptfs: fix unlink and rmdir in face of underlying fs modifications

Al Viro <viro@zeniv.linux.org.uk>
    audit_get_nd(): don't unlock parent too early

Al Viro <viro@zeniv.linux.org.uk>
    exportfs_decode_fh(): negative pinned may become positive without the parent locked

Al Viro <viro@zeniv.linux.org.uk>
    cgroup: don't put ERR_PTR() into fc->root

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: pcie: don't consider IV len in A-MSDU

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Correct the value of srq_desc_size

Sirong Wang <wangsirong@huawei.com>
    RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: SGI-IP27: fix exception handler replication

Al Viro <viro@zeniv.linux.org.uk>
    autofs: fix a leak in autofs_expire_indirect()

Guillem Jover <guillem@hadrons.org>
    aio: Fix io_pgetevents() struct __compat_aio_sigset layout

Chuhong Yuan <hslester96@gmail.com>
    serial: ifx6x60: add missed pm_runtime_disable

Fabrice Gasnier <fabrice.gasnier@st.com>
    serial: stm32: fix clearing interrupt error flags

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    serial: serial_core: Perform NULL checks for break_ctl ops

Vincent Whitchurch <vincent.whitchurch@axis.com>
    serial: pl011: Fix DMA ->flush_buffer()

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    tty: serial: msm_serial: Fix flow control

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: u_serial: add missing port entry locking

Dmitry Safonov <0x7f454c46@gmail.com>
    time: Zero the upper 32-bits in __kernel_timespec on 32-bit

Arnd Bergmann <arnd@arndb.de>
    lp: fix sparc64 LPSETTIMEOUT ioctl

Tuowen Zhao <ztuowen@gmail.com>
    sparc64: implement ioremap_uc

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQLite

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Navid Emamdoost <navid.emamdoost@gmail.com>
    rsi: release skb if rsi_prepare_beacon fails


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         |  6 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |  6 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |  2 +-
 arch/mips/sgi-ip27/Kconfig                         |  7 ---
 arch/mips/sgi-ip27/ip27-init.c                     | 21 ++-----
 arch/mips/sgi-ip27/ip27-memory.c                   |  4 --
 arch/powerpc/kvm/book3s_xive.c                     | 11 ++--
 arch/powerpc/kvm/book3s_xive_native.c              | 46 +++++++++------
 arch/sparc/include/asm/io_64.h                     |  1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  4 --
 arch/x86/kvm/vmx/nested.c                          | 10 ++++
 arch/x86/kvm/vmx/vmx.c                             | 10 +++-
 arch/x86/kvm/x86.c                                 | 17 ++++--
 arch/x86/mm/fault.c                                |  2 +-
 arch/x86/pci/fixup.c                               | 11 ++++
 block/bio.c                                        |  2 +-
 crypto/af_alg.c                                    |  2 +-
 crypto/crypto_user_base.c                          |  4 +-
 crypto/crypto_user_stat.c                          |  4 +-
 crypto/ecc.c                                       |  3 +-
 drivers/android/binder_alloc.c                     | 41 ++++++++------
 drivers/block/rbd.c                                |  2 +-
 drivers/block/rsxx/core.c                          |  2 +
 drivers/char/lp.c                                  |  4 ++
 drivers/crypto/amcc/crypto4xx_core.c               |  6 +-
 drivers/crypto/atmel-aes.c                         | 53 ++++++++++--------
 drivers/crypto/ccp/ccp-dmaengine.c                 |  1 +
 drivers/crypto/geode-aes.c                         | 57 +++++++++++--------
 drivers/crypto/geode-aes.h                         |  2 +-
 drivers/gpu/drm/drm_damage_helper.c                |  8 ++-
 drivers/gpu/drm/i810/i810_dma.c                    |  4 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |  6 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  2 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    | 21 ++++---
 drivers/i2c/i2c-core-of.c                          |  4 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |  2 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              |  6 ++
 drivers/input/joystick/psxpad-spi.c                |  2 +-
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/input/rmi4/rmi_f34v7.c                     |  3 +
 drivers/input/rmi4/rmi_smbus.c                     |  2 -
 drivers/input/touchscreen/cyttsp4_core.c           |  7 ---
 drivers/input/touchscreen/goodix.c                 |  9 +++
 drivers/media/rc/rc-main.c                         |  1 +
 drivers/net/can/slcan.c                            |  1 +
 drivers/net/can/usb/ucan.c                         |  2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |  5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 19 ++++++-
 drivers/net/ethernet/renesas/ravb.h                |  3 +-
 drivers/net/ethernet/renesas/ravb_main.c           | 26 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 20 +++----
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |  1 +
 drivers/nfc/nxp-nci/i2c.c                          |  6 +-
 drivers/spi/spi-atmel.c                            |  6 +-
 drivers/spi/spi-fsl-qspi.c                         | 38 +++++++++++--
 drivers/spi/spi-stm32-qspi.c                       |  3 +-
 drivers/spi/spi.c                                  | 19 ++++---
 drivers/thermal/thermal_core.c                     |  4 +-
 drivers/tty/serial/amba-pl011.c                    |  6 +-
 drivers/tty/serial/fsl_lpuart.c                    |  4 +-
 drivers/tty/serial/ifx6x60.c                       |  3 +
 drivers/tty/serial/msm_serial.c                    |  6 +-
 drivers/tty/serial/serial_core.c                   |  2 +-
 drivers/tty/serial/stm32-usart.c                   |  6 +-
 drivers/tty/vt/keyboard.c                          |  2 +-
 drivers/tty/vt/vc_screen.c                         |  3 +
 drivers/usb/gadget/function/u_serial.c             |  2 +
 fs/afs/dir.c                                       |  7 ++-
 fs/aio.c                                           | 10 ++--
 fs/autofs/expire.c                                 |  5 +-
 fs/cifs/file.c                                     |  7 ++-
 fs/cifs/smb2misc.c                                 |  7 +--
 fs/ecryptfs/inode.c                                | 65 +++++++++++++---------
 fs/exportfs/expfs.c                                | 31 +++++++----
 fs/fuse/dir.c                                      | 25 ++++++---
 fs/fuse/fuse_i.h                                   |  2 +
 fs/fuse/readdir.c                                  |  2 +-
 fs/io_uring.c                                      |  9 ++-
 fs/iomap/direct-io.c                               |  9 ++-
 fs/kernfs/dir.c                                    |  5 +-
 fs/nfsd/nfs4proc.c                                 |  3 +-
 fs/nfsd/nfssvc.c                                   |  3 +-
 fs/nfsd/vfs.c                                      |  8 ++-
 fs/nfsd/vfs.h                                      |  2 +-
 include/linux/jbd2.h                               |  4 +-
 include/linux/kernfs.h                             |  1 +
 include/sound/hdaudio.h                            |  1 +
 kernel/audit_watch.c                               |  2 +-
 kernel/cgroup/cgroup.c                             |  5 +-
 kernel/events/core.c                               |  2 +-
 kernel/sched/core.c                                |  3 +-
 kernel/sched/fair.c                                | 29 +++++++---
 kernel/time/time.c                                 |  3 +-
 net/sunrpc/sched.c                                 |  2 +-
 net/xfrm/xfrm_input.c                              |  3 +
 sound/core/oss/linear.c                            |  2 +
 sound/core/oss/mulaw.c                             |  2 +
 sound/core/oss/route.c                             |  2 +
 sound/core/pcm_lib.c                               |  8 ++-
 sound/hda/hdac_stream.c                            | 19 ++++---
 sound/pci/hda/hda_intel.c                          |  3 +
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/pci/hda/patch_hdmi.c                         |  5 ++
 sound/pci/hda/patch_realtek.c                      | 18 +++++-
 tools/perf/scripts/python/exported-sql-viewer.py   | 10 +++-
 tools/testing/selftests/kvm/lib/assert.c           |  4 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  6 +-
 109 files changed, 597 insertions(+), 350 deletions(-)


