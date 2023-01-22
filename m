Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32B6676F01
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjAVPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjAVPQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F18022036;
        Sun, 22 Jan 2023 07:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A4A60C57;
        Sun, 22 Jan 2023 15:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5E5C433EF;
        Sun, 22 Jan 2023 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400603;
        bh=8BhTjLePLHkgOd8BDVmcZKL8rNQt5ogymyb7v4ld/Jc=;
        h=From:To:Cc:Subject:Date:From;
        b=ZrCMABCloKqGFPBbGdQbzI5NBEHNSgtBIQoGCXtNNPzlzJYgI0pGUJiM30L8cqEKj
         JRAcQdPV26RrHh9/FE+UKjscMWejvAVnNYMXwbvDf9Uu2H1qTlSgbxqIqmpBmeCpl5
         bVYIv/CFdJm3BEycwfbmPWbN30bznU5g19vbptQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/117] 5.15.90-rc1 review
Date:   Sun, 22 Jan 2023 16:03:10 +0100
Message-Id: <20230122150232.736358800@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.90-rc1
X-KernelTest-Deadline: 2023-01-24T15:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.90 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.90-rc1

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: apr: Make qcom,protection-domain optional again

Eric Dumazet <edumazet@google.com>
    Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Rename deadline_is_seq_writes()

Yang Yingliang <yangyingliang@huawei.com>
    net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

Paolo Abeni <pabeni@redhat.com>
    net/ulp: use consistent error code when blocking ULP

Stefan Metzmacher <metze@samba.org>
    io_uring/net: fix fast_iov assignment in io_setup_async_msg()

Jens Axboe <axboe@kernel.dk>
    io_uring: io_kiocb_update_pos() should not touch file for non -1 offset

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Don't discard .comment

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Masahiro Yamada <masahiroy@kernel.org>
    arch: fix broken BuildID for arm64 and riscv

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Use alignof__(struct {type b;}) instead of offsetof()

YingChi Long <me@inclyc.cn>
    x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: make display pinning more flexible (v2)"

Ard Biesheuvel <ardb@kernel.org>
    efi: rt-wrapper: Add missing include

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Execute runtime services from a dedicated stack

Alon Zahavi <zahavi.alon@gmail.com>
    fs/ntfs3: Fix attr_punch_hole() null pointer derenference

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop experimental flag on aldebaran

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Calculate output_color_space after pixel encoding adjustment

hongao <hongao@uniontech.com>
    drm/amd/display: Fix set scaling doesn's work

Drew Davenport <ddavenport@chromium.org>
    drm/i915/display: Check source height is > 0

Sasa Dragic <sasa.dragic@gmail.com>
    drm/i915: re-disable RC6p on Sandy Bridge

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add meteor lake point M DID

Khazhismel Kumykov <khazhy@chromium.org>
    gsmi: fix null-deref in gsmi_get_variable

Tobias Schramm <t.schramm@manjaro.org>
    serial: atmel: fix incorrect baudrate setup

Lino Sanfilippo <l.sanfilippo@kunbus.com>
    serial: amba-pl011: fix high priority character transmission in rs486 mode

Reinette Chatre <reinette.chatre@intel.com>
    dmaengine: idxd: Let probe fail when workqueue cannot be enabled

Mohan Kumar <mkumard@nvidia.com>
    dmaengine: tegra210-adma: fix global intr clear

Peter Harliman Liem <pliem@maxlinear.com>
    dmaengine: lgm: Move DT parsing after initialization

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: pch_uart: Pass correct sg to dma_unmap_sg()

Heiner Kallweit <hkallweit1@gmail.com>
    dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

Heiner Kallweit <hkallweit1@gmail.com>
    dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation

Juhyung Park <qkrwngud825@gmail.com>
    usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Maciej Żenczykowski <maze@google.com>
    usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Daniel Scally <dan.scally@ideasonboard.com>
    usb: gadget: g_webcam: Send color matching descriptor per frame

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix pin assignment calculation

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Add pin assignment helper

ChiYuan Huang <cy_huang@richtek.com>
    usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: ehci-fsl: Fix module alias

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: remove fetched trb from cache before dequeuing

Michael Adler <michael.adler@siemens.com>
    USB: serial: cp210x: add SCALANCE LPE-9000 device id

Alan Stern <stern@rowland.harvard.edu>
    USB: gadgetfs: Fix race between mounting and unmounting

Gaosheng Cui <cuigaosheng1@huawei.com>
    tty: fix possible null-ptr-defer in spk_ttyio_release

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO buffer

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-dts: change some node hex addresses to lower case

Paul Moore <paul@paul-moore.com>
    bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: dts: sifive: fu740: fix size of pcie 32bit memory

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use correct function to calculate maximum USB3 link rate

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: do not include page data when checking signature

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Filipe Manana <fdmanana@suse.com>
    btrfs: do not abort transaction on failure to write log tree when syncing log

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Ard Biesheuvel <ardb@kernel.org>
    ACPI: PRM: Check whether EFI runtime is available

Ian Abbott <abbotti@mev.co.uk>
    comedi: adv_pci1760: Fix PWM instruction handling

Flavio Suligoi <f.suligoi@asem.it>
    usb: core: hub: disable autosuspend for TI TUSB8041

Ola Jeppsson <ola@snap.com>
    misc: fastrpc: Fix use-after-free race condition for maps

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Don't remove map on creater_process and device_release

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100

Arnd Bergmann <arnd@arndb.de>
    staging: vchiq_arm: fix enum vchiq_status return types

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN (SG) modem

Ali Mirghasemi <ali.mirghasemi1376@gmail.com>
    USB: serial: option: add Quectel EC200U modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (RS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (CS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (GR) modem

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    prlimit: do_prlimit needs to have a speculation check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: acpi: add helper to check port lpm capability using acpi _DSM

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add a flag to disable USB3 lpm on a xhci root port level.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add update_hub_device override for PCI xHCI hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix null pointer dereference when host dies

Jimmy Hu <hhhuuu@google.com>
    usb: xhci: Check endpoint is valid before dereferencing it

Ricardo Ribalda <ribalda@chromium.org>
    xhci-pci: set the dma max_seg_size

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: defer fsnotify calls to task context

Dylan Yudaken <dylany@fb.com>
    io_uring: do not recalculate ppos unnecessarily

Dylan Yudaken <dylany@fb.com>
    io_uring: update kiocb->ki_pos at execution time

Dylan Yudaken <dylany@fb.com>
    io_uring: remove duplicated calls to io_kiocb_ppos

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that cached task references are always put on exit

Dylan Yudaken <dylany@meta.com>
    io_uring: fix async accept on O_NONBLOCK sockets

Jens Axboe <axboe@kernel.dk>
    io_uring: allow re-poll if we made progress

Jens Axboe <axboe@kernel.dk>
    io_uring: support MSG_WAITALL for IORING_OP_SEND(MSG)

Jens Axboe <axboe@kernel.dk>
    io_uring: add flag for disabling provided buffer recycling

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: improve send/recv error handling

Jens Axboe <axboe@kernel.dk>
    io_uring: pass in EPOLL_URING_WAKE for eventfd signaling and wakeups

Jens Axboe <axboe@kernel.dk>
    eventfd: provide a eventfd_signal_mask() helper

Jens Axboe <axboe@kernel.dk>
    eventpoll: add EPOLL_URING_WAKE poll wakeup flag

Jens Axboe <axboe@kernel.dk>
    io_uring: don't gate task_work run on TIF_NOTIFY_SIGNAL

James Houghton <jthoughton@google.com>
    hugetlb: unshare some PMDs when splitting VMAs

Sasha Levin <sashal@kernel.org>
    drm/amd: Delay removal of the firmware framebuffer

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: disable runtime pm on several sienna cichlid cards(v2)

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for a HP platform

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Ding Hui <dinghui@sangfor.com.cn>
    efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix general protection fault in nilfs_btree_insert()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Detect append writes at invalid locations

Shawn.Shao <shawn.shao@jaguarmicro.com>
    Add exception protection processing for vd in axi_chan_handle_err function

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: mac80211: sdata can be NULL during AMPDU start

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    Bluetooth: hci_qca: Fix driver shutdown on closed serdev

Arnd Bergmann <arnd@arndb.de>
    fbdev: omapfb: avoid stack overflow warning

Chris Wilson <chris@chris-wilson.co.uk>
    perf/x86/rapl: Treat Tigerlake like Icelake

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: let's avoid panic if extent_tree is not created

Mikulas Patocka <mpatocka@redhat.com>
    x86/asm: Fix an assembler warning with current binutils

Qu Wenruo <wqu@suse.com>
    btrfs: always report error in run_one_delayed_ref()

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    RDMA/srp: Move large values to a new enum for gcc13

Chunhao Lin <hau@realtek.com>
    r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    vduse: Validate vq_num in vduse_validate_config()

Angus Chen <angus.chen@jaguarmicro.com>
    virtio_pci: modify ENOENT to EINVAL

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    tools/virtio: initialize spinlocks in vring_test.c

Hao Sun <sunhao.th@gmail.com>
    selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    pNFS/filelayout: Fix coalescing test for single DS

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix trace event name typo for FLUSH_DELAYED_REFS


-------------

Diffstat:

 ...2a-usb2-phy.yaml => amlogic,g12a-usb2-phy.yaml} |   8 +-
 ...ie-phy.yaml => amlogic,g12a-usb3-pcie-phy.yaml} |   6 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/efi.h                       |   3 +
 arch/arm64/kernel/efi-rt-wrapper.S                 |  14 +-
 arch/arm64/kernel/efi.c                            |  27 +++
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 +-
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi         |   2 +-
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/x86/events/rapl.c                             |   2 +
 arch/x86/kernel/fpu/init.c                         |   7 +-
 arch/x86/lib/iomap_copy_64.S                       |   2 +-
 block/mq-deadline.c                                |   4 +-
 drivers/accessibility/speakup/spk_ttyio.c          |   3 +
 drivers/acpi/prmt.c                                |  10 +
 drivers/bluetooth/hci_qca.c                        |   7 +
 drivers/comedi/drivers/adv_pci1760.c               |   2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   6 +
 drivers/dma/idxd/device.c                          |   3 +-
 drivers/dma/lgm/lgm-dma.c                          |  10 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/firmware/efi/runtime-wrappers.c            |   1 +
 drivers/firmware/google/gsmi.c                     |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  14 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   4 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   2 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   3 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |   8 +-
 drivers/misc/fastrpc.c                             |  26 +--
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  22 +-
 drivers/mmc/host/sunxi-mmc.c                       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  44 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/soc/qcom/apr.c                             |   3 +-
 drivers/staging/mt7621-dts/mt7621.dtsi             |  12 +-
 .../include/linux/raspberrypi/vchiq.h              |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.h  |   4 +-
 drivers/thunderbolt/tunnel.c                       |   2 +-
 drivers/tty/serial/amba-pl011.c                    |   8 +-
 drivers/tty/serial/atmel_serial.c                  |   8 +-
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/tty/serial/qcom_geni_serial.c              |  18 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |  12 ++
 drivers/usb/core/hub.c                             |  13 ++
 drivers/usb/core/usb-acpi.c                        |  65 ++++++
 drivers/usb/gadget/function/f_ncm.c                |   4 +-
 drivers/usb/gadget/legacy/inode.c                  |  28 ++-
 drivers/usb/gadget/legacy/webcam.c                 |   3 +
 drivers/usb/host/ehci-fsl.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |  45 +++++
 drivers/usb/host/xhci-ring.c                       |   5 +-
 drivers/usb/host/xhci.c                            |  18 +-
 drivers/usb/host/xhci.h                            |   5 +
 drivers/usb/misc/iowarrior.c                       |   2 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |  17 ++
 drivers/usb/storage/uas-detect.h                   |  13 ++
 drivers/usb/storage/unusual_uas.h                  |   7 -
 drivers/usb/typec/altmodes/displayport.c           |  22 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   7 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   3 +
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |  28 ++-
 drivers/virtio/virtio_pci_modern.c                 |   2 +-
 fs/btrfs/disk-io.c                                 |   9 +-
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/qgroup.c                                  |  25 ++-
 fs/btrfs/tree-log.c                                |   2 -
 fs/cifs/smb2pdu.c                                  |  15 +-
 fs/eventfd.c                                       |  37 ++--
 fs/eventpoll.c                                     |  18 +-
 fs/f2fs/extent_cache.c                             |   3 +-
 fs/nfs/filelayout/filelayout.c                     |   8 +
 fs/nilfs2/btree.c                                  |  15 +-
 fs/ntfs3/attrib.c                                  |   2 +-
 fs/zonefs/super.c                                  |  22 ++
 include/asm-generic/vmlinux.lds.h                  |   5 +
 include/linux/eventfd.h                            |   7 +
 include/linux/usb.h                                |   3 +
 include/trace/events/btrfs.h                       |   2 +-
 include/trace/trace_events.h                       |   2 +-
 include/uapi/linux/eventpoll.h                     |   6 +
 io_uring/io-wq.c                                   |   2 +-
 io_uring/io_uring.c                                | 223 +++++++++++++++------
 kernel/bpf/offload.c                               |   3 -
 kernel/bpf/syscall.c                               |   6 +-
 kernel/sys.c                                       |   2 +
 mm/hugetlb.c                                       |  44 +++-
 net/ethtool/ioctl.c                                |   3 +-
 net/ipv4/tcp_ulp.c                                 |   2 +-
 net/mac80211/agg-tx.c                              |   6 +-
 net/mac80211/driver-ops.c                          |   3 +
 net/mac80211/iface.c                               |   1 -
 sound/pci/hda/patch_realtek.c                      |   3 +
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 +
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 ++++
 tools/virtio/vringh_test.c                         |   2 +
 103 files changed, 914 insertions(+), 295 deletions(-)


