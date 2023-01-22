Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27889676E4A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjAVPJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjAVPJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:09:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9FC1C30E;
        Sun, 22 Jan 2023 07:08:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 059E7B80B16;
        Sun, 22 Jan 2023 15:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A28C4339B;
        Sun, 22 Jan 2023 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400136;
        bh=vfbYjbXEe+6p8sgz7RmIhxO15z6cBLBuRmna9JhhG8E=;
        h=From:To:Cc:Subject:Date:From;
        b=LA6h9m/k+1nUFfvkXEXZcgW7M4HfJAzdGeKDAprMFZ1AV5RgH18MbRmtROeiBbzQQ
         5pj9k/m7D5xKuTO+PzlQ8qR3y+2l4NirKnqPjY6lpl5alaGoVIvRCR9ctypTyXOOLe
         Tq9hFszLqSaN1Tw3X/ZqjWQ85ycQKgX8ZxkRoz60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 00/55] 5.4.230-rc1 review
Date:   Sun, 22 Jan 2023 16:03:47 +0100
Message-Id: <20230122150222.210885219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.230-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.230-rc1
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

This is the start of the stable review cycle for the 5.4.230 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.230-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.230-rc1

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

YingChi Long <me@inclyc.cn>
    x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

hongao <hongao@uniontech.com>
    drm/amd/display: Fix set scaling doesn's work

Sasa Dragic <sasa.dragic@gmail.com>
    drm/i915: re-disable RC6p on Sandy Bridge

Khazhismel Kumykov <khazhy@chromium.org>
    gsmi: fix null-deref in gsmi_get_variable

Tobias Schramm <t.schramm@manjaro.org>
    serial: atmel: fix incorrect baudrate setup

Mohan Kumar <mkumard@nvidia.com>
    dmaengine: tegra210-adma: fix global intr clear

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: pch_uart: Pass correct sg to dma_unmap_sg()

Heiner Kallweit <hkallweit1@gmail.com>
    dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

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

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: ehci-fsl: Fix module alias

Michael Adler <michael.adler@siemens.com>
    USB: serial: cp210x: add SCALANCE LPE-9000 device id

Alan Stern <stern@rowland.harvard.edu>
    USB: gadgetfs: Fix race between mounting and unmounting

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: do not include page data when checking signature

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

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

Yuchi Yang <yangyuchi66@gmail.com>
    ALSA: hda/realtek - Turn on power early

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Reset twice

Ding Hui <dinghui@sangfor.com.cn>
    efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix general protection fault in nilfs_btree_insert()

Shawn.Shao <shawn.shao@jaguarmicro.com>
    Add exception protection processing for vd in axi_chan_handle_err function

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: let's avoid panic if extent_tree is not created

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    RDMA/srp: Move large values to a new enum for gcc13

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Hao Sun <sunhao.th@gmail.com>
    selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    pNFS/filelayout: Fix coalescing test for single DS


-------------

Diffstat:

 ...ie-phy.yaml => amlogic,g12a-usb3-pcie-phy.yaml} |  6 +-
 Makefile                                           |  4 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |  6 +-
 arch/s390/kernel/vmlinux.lds.S                     |  2 +
 arch/x86/kernel/fpu/init.c                         |  7 +--
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  6 ++
 drivers/dma/tegra210-adma.c                        |  2 +-
 drivers/firmware/efi/runtime-wrappers.c            |  1 +
 drivers/firmware/google/gsmi.c                     |  7 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  4 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |  4 +-
 drivers/gpu/drm/i915/gt/intel_reset.c              | 34 +++++++++--
 drivers/gpu/drm/i915/i915_pci.c                    |  3 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |  8 ++-
 drivers/misc/fastrpc.c                             | 26 +++++----
 drivers/mmc/host/sunxi-mmc.c                       |  8 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  2 +-
 drivers/staging/comedi/drivers/adv_pci1760.c       |  2 +-
 drivers/tty/serial/atmel_serial.c                  |  8 +--
 drivers/tty/serial/pch_uart.c                      |  2 +-
 drivers/usb/core/hub.c                             | 13 +++++
 drivers/usb/core/usb-acpi.c                        | 65 ++++++++++++++++++++++
 drivers/usb/gadget/function/f_ncm.c                |  4 +-
 drivers/usb/gadget/legacy/inode.c                  | 28 +++++++---
 drivers/usb/gadget/legacy/webcam.c                 |  3 +
 drivers/usb/host/ehci-fsl.c                        |  2 +-
 drivers/usb/host/xhci-pci.c                        | 45 +++++++++++++++
 drivers/usb/host/xhci-ring.c                       |  5 +-
 drivers/usb/host/xhci.c                            | 18 +++++-
 drivers/usb/host/xhci.h                            |  5 ++
 drivers/usb/misc/iowarrior.c                       |  2 +-
 drivers/usb/serial/cp210x.c                        |  1 +
 drivers/usb/serial/option.c                        | 17 ++++++
 drivers/usb/storage/uas-detect.h                   | 13 +++++
 drivers/usb/storage/unusual_uas.h                  |  7 ---
 drivers/usb/typec/altmodes/displayport.c           | 22 +++++---
 fs/btrfs/qgroup.c                                  | 25 ++++++---
 fs/cifs/smb2pdu.c                                  | 15 +++--
 fs/f2fs/extent_cache.c                             |  3 +-
 fs/nfs/filelayout/filelayout.c                     |  8 +++
 fs/nilfs2/btree.c                                  | 15 ++++-
 include/asm-generic/vmlinux.lds.h                  |  5 ++
 include/linux/usb.h                                |  3 +
 kernel/sys.c                                       |  2 +
 net/core/ethtool.c                                 |  3 +-
 sound/pci/hda/patch_realtek.c                      | 30 +++++-----
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |  9 +++
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  | 42 ++++++++++++++
 48 files changed, 438 insertions(+), 114 deletions(-)


