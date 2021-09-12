Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902F4407DA2
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhILN2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235865AbhILN1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Sep 2021 09:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B7060F3A;
        Sun, 12 Sep 2021 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631453201;
        bh=WfRi99wp+O9tWslxvp6xDi8Mjk2DFrBJ7qj2yQo5x8c=;
        h=From:To:Cc:Subject:Date:From;
        b=FXQKAybJr2D/OCSlc5CvLjms0FwM6pgWIpXP+5+Ayc3QGVle7/FudqlQldI4q0wOO
         fQHhOYIixTVucB61vJLIDWqYaMyt3LczQ7Ir2dij6rlYKZRfzyHY4K0+OozZAJU3lx
         p5tv+yvRdIugQzQdHnsw6gB2BvbenkFYFzadKW54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.3
Date:   Sun, 12 Sep 2021 15:26:32 +0200
Message-Id: <16314531927389@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.3 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/x86/kernel/reboot.c                  |    3 -
 drivers/bluetooth/btusb.c                 |   59 +++++++++++++-----------
 drivers/cxl/acpi.c                        |   12 +++-
 drivers/cxl/pci.c                         |    6 +-
 drivers/firmware/dmi-id.c                 |    6 ++
 drivers/net/can/c_can/c_can_ethtool.c     |    4 -
 drivers/net/ethernet/realtek/r8169_main.c |    1 
 drivers/pci/quirks.c                      |   12 ++--
 drivers/staging/mt7621-pci/pci-mt7621.c   |   13 ++++-
 drivers/usb/cdns3/cdnsp-mem.c             |    2 
 drivers/usb/gadget/udc/tegra-xudc.c       |    4 -
 drivers/usb/host/xhci-debugfs.c           |   14 ++++-
 drivers/usb/host/xhci-mtk-sch.c           |   10 ++--
 drivers/usb/host/xhci-rcar.c              |    7 ++
 drivers/usb/host/xhci-ring.c              |   43 +++++++++++------
 drivers/usb/host/xhci-trace.h             |   26 ++++++----
 drivers/usb/host/xhci.h                   |   73 ++++++++++++++----------------
 drivers/usb/mtu3/mtu3_core.c              |    4 +
 drivers/usb/mtu3/mtu3_gadget.c            |    6 --
 net/ipv4/igmp.c                           |    2 
 sound/usb/quirks.c                        |    1 
 22 files changed, 184 insertions(+), 126 deletions(-)

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Alison Schofield (1):
      cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports

Chunfeng Yun (6):
      usb: xhci-mtk: fix issue of out-of-bounds array access
      usb: cdnsp: fix the wrong mult value for HS isoc or intr
      usb: gadget: tegra-xudc: fix the wrong mult value for HS isoc or intr
      usb: mtu3: restore HS function when set SS/SSP
      usb: mtu3: use @mult for HS isoc or intr
      usb: mtu3: fix the wrong HS mult value

Dan Williams (1):
      cxl/pci: Fix lockdown level

Greg Kroah-Hartman (1):
      Linux 5.14.3

Hans de Goede (1):
      firmware: dmi: Move product_sku info to the end of the modalias

Hayes Wang (1):
      Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Ismael Ferreras Morezuelas (1):
      Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic

Larry Finger (1):
      Bluetooth: Add additional Bluetooth part for Realtek 8852AE

Li Qiang (Johnny Li) (1):
      cxl/pci: Fix debug message in cxl_probe_regs()

Liu Jian (1):
      igmp: Add ip_mc_list lock in ip_check_mc_rcu

Marek Behún (1):
      PCI: Call Max Payload Size-related fixup quirks early

Mathias Nyman (3):
      xhci: fix even more unsafe memory usage in xhci tracing
      xhci: fix unsafe memory usage in xhci tracing
      xhci: Fix failure to give back some cached cancelled URBs.

Paul Gortmaker (1):
      x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Sergio Paracuellos (1):
      staging: mt7621-pci: fix hang when nothing is connected to pcie ports

Tong Zhang (1):
      can: c_can: fix null-ptr-deref on ioctl()

Yoshihiro Shimoda (1):
      usb: host: xhci-rcar: Don't reload firmware after the completion

