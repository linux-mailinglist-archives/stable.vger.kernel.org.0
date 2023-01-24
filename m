Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AF76790D8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 07:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjAXG2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 01:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjAXG2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 01:28:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE5F3D096;
        Mon, 23 Jan 2023 22:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55E14611F0;
        Tue, 24 Jan 2023 06:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAF3C433EF;
        Tue, 24 Jan 2023 06:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674541724;
        bh=Zt1M4OK9UbdBDfqk3+xClLX1GrdOU/EKpN4EOn0mIQ4=;
        h=From:To:Cc:Subject:Date:From;
        b=nXLj8XOQYX2g6OpUpQtAsWX+9iEjp7pyzOW3rco5jGqmTwsnL56NvN6w+rxAooJkp
         GtnUFAmhD9spHrRwY8R5ieJysvPapKSpfKSERYlzvFm0hljjaI7zWe8vXFNEVGGFvV
         nQJH6suoxk2jKPZ6zNBR5ESRXZMxLW4tMG//wEZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.230
Date:   Tue, 24 Jan 2023 07:28:37 +0100
Message-Id: <167454171811113@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.230 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml       |   57 ++++++++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |   57 --------
 Makefile                                                                    |    2 
 arch/x86/kernel/fpu/init.c                                                  |    7 -
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                              |    6 
 drivers/dma/tegra210-adma.c                                                 |    2 
 drivers/firmware/efi/runtime-wrappers.c                                     |    1 
 drivers/firmware/google/gsmi.c                                              |    7 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                           |    4 
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c                       |    4 
 drivers/gpu/drm/i915/gt/intel_reset.c                                       |   34 ++++-
 drivers/gpu/drm/i915/i915_pci.c                                             |    3 
 drivers/infiniband/ulp/srp/ib_srp.h                                         |    8 -
 drivers/misc/fastrpc.c                                                      |   26 ++--
 drivers/mmc/host/sunxi-mmc.c                                                |    8 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c                     |    2 
 drivers/staging/comedi/drivers/adv_pci1760.c                                |    2 
 drivers/tty/serial/atmel_serial.c                                           |    8 -
 drivers/tty/serial/pch_uart.c                                               |    2 
 drivers/usb/core/hub.c                                                      |   13 ++
 drivers/usb/core/usb-acpi.c                                                 |   65 ++++++++++
 drivers/usb/gadget/function/f_ncm.c                                         |    4 
 drivers/usb/gadget/legacy/inode.c                                           |   28 +++-
 drivers/usb/gadget/legacy/webcam.c                                          |    3 
 drivers/usb/host/ehci-fsl.c                                                 |    2 
 drivers/usb/host/xhci-pci.c                                                 |   45 ++++++
 drivers/usb/host/xhci-ring.c                                                |    5 
 drivers/usb/host/xhci.c                                                     |   18 ++
 drivers/usb/host/xhci.h                                                     |    5 
 drivers/usb/misc/iowarrior.c                                                |    2 
 drivers/usb/serial/cp210x.c                                                 |    1 
 drivers/usb/serial/option.c                                                 |   17 ++
 drivers/usb/storage/uas-detect.h                                            |   13 ++
 drivers/usb/storage/unusual_uas.h                                           |    7 -
 drivers/usb/typec/altmodes/displayport.c                                    |   22 ++-
 fs/btrfs/qgroup.c                                                           |   25 ++-
 fs/cifs/smb2pdu.c                                                           |   15 +-
 fs/f2fs/extent_cache.c                                                      |    3 
 fs/nfs/filelayout/filelayout.c                                              |    8 +
 fs/nilfs2/btree.c                                                           |   15 +-
 include/linux/usb.h                                                         |    3 
 kernel/sys.c                                                                |    2 
 mm/khugepaged.c                                                             |   14 --
 net/core/ethtool.c                                                          |    3 
 sound/pci/hda/patch_realtek.c                                               |   30 ++--
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c                 |    9 +
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c                 |   42 ++++++
 47 files changed, 485 insertions(+), 174 deletions(-)

Abel Vesa (1):
      misc: fastrpc: Don't remove map on creater_process and device_release

Alan Stern (1):
      USB: gadgetfs: Fix race between mounting and unmounting

Alexander Stein (1):
      usb: host: ehci-fsl: Fix module alias

Ali Mirghasemi (1):
      USB: serial: option: add Quectel EC200U modem

Arend van Spriel (1):
      wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Chris Wilson (1):
      drm/i915/gt: Reset twice

Daniel Scally (1):
      usb: gadget: g_webcam: Send color matching descriptor per frame

Daniil Tatianin (1):
      net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Ding Hui (1):
      efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Duke Xin(辛安文) (5):
      USB: serial: option: add Quectel EM05-G (GR) modem
      USB: serial: option: add Quectel EM05-G (CS) modem
      USB: serial: option: add Quectel EM05-G (RS) modem
      USB: serial: option: add Quectel EM05CN (SG) modem
      USB: serial: option: add Quectel EM05CN modem

Enzo Matsumiya (1):
      cifs: do not include page data when checking signature

Filipe Manana (1):
      btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Flavio Suligoi (1):
      usb: core: hub: disable autosuspend for TI TUSB8041

Greg Kroah-Hartman (3):
      prlimit: do_prlimit needs to have a speculation check
      USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
      Linux 5.4.230

Hao Sun (1):
      selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Heiner Kallweit (1):
      dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

Hugh Dickins (1):
      mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma

Ian Abbott (1):
      comedi: adv_pci1760: Fix PWM instruction handling

Ilpo Järvinen (1):
      serial: pch_uart: Pass correct sg to dma_unmap_sg()

Jaegeuk Kim (1):
      f2fs: let's avoid panic if extent_tree is not created

Jimmy Hu (1):
      usb: xhci: Check endpoint is valid before dereferencing it

Jiri Slaby (SUSE) (1):
      RDMA/srp: Move large values to a new enum for gcc13

Joshua Ashton (1):
      drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

Juhyung Park (1):
      usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Khazhismel Kumykov (1):
      gsmi: fix null-deref in gsmi_get_variable

Maciej Żenczykowski (1):
      usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Mathias Nyman (5):
      xhci: Fix null pointer dereference when host dies
      xhci: Add update_hub_device override for PCI xHCI hosts
      xhci: Add a flag to disable USB3 lpm on a xhci root port level.
      usb: acpi: add helper to check port lpm capability using acpi _DSM
      xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables

Michael Adler (1):
      USB: serial: cp210x: add SCALANCE LPE-9000 device id

Mohan Kumar (1):
      dmaengine: tegra210-adma: fix global intr clear

Ola Jeppsson (1):
      misc: fastrpc: Fix use-after-free race condition for maps

Olga Kornievskaia (1):
      pNFS/filelayout: Fix coalescing test for single DS

Prashant Malani (2):
      usb: typec: altmodes/displayport: Add pin assignment helper
      usb: typec: altmodes/displayport: Fix pin assignment calculation

Ricardo Ribalda (1):
      xhci-pci: set the dma max_seg_size

Ryusuke Konishi (1):
      nilfs2: fix general protection fault in nilfs_btree_insert()

Samuel Holland (1):
      mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Sasa Dragic (1):
      drm/i915: re-disable RC6p on Sandy Bridge

Shawn.Shao (1):
      Add exception protection processing for vd in axi_chan_handle_err function

Tobias Schramm (1):
      serial: atmel: fix incorrect baudrate setup

YingChi Long (1):
      x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Yuchi Yang (1):
      ALSA: hda/realtek - Turn on power early

hongao (1):
      drm/amd/display: Fix set scaling doesn's work

