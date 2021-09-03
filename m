Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1883FFC8C
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348579AbhICJCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348592AbhICJCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8029C610CF;
        Fri,  3 Sep 2021 09:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659684;
        bh=D3G0HkvgsclfFfETC+gNIhsBAZpDZKjSb2Ff/Lalo5g=;
        h=From:To:Cc:Subject:Date:From;
        b=V7+5AE56lVVQkg/gTCkdgQGW+JTHrPyTmxKHWnNKdhJG/7vLMQYfZjtU+25jqS4/r
         Wc3VuBE72WNVWCyYkCIJDybkWcnkZidDGMy/jrccLEbGN3GDS5x4w8SIUMH/t/WVDS
         z87FykT5396mcOTAzJkgLVC5Uu7jF1bLLHMLj+3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.246
Date:   Fri,  3 Sep 2021 11:01:18 +0200
Message-Id: <1630659678123129@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.246 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virtual/kvm/mmu.txt               |    4 +--
 Makefile                                        |    2 -
 arch/arc/kernel/vmlinux.lds.S                   |    2 +
 arch/x86/kvm/mmu.c                              |   11 ++++++++-
 arch/x86/kvm/paging_tmpl.h                      |   14 ++++++++----
 drivers/base/power/opp/of.c                     |    5 ++--
 drivers/block/floppy.c                          |   27 +++++++++++-------------
 drivers/gpu/drm/drm_ioc32.c                     |    4 ---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c   |    2 -
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h   |    1 
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c |    9 ++++++++
 drivers/infiniband/hw/hfi1/sdma.c               |    9 +++-----
 drivers/net/can/usb/esd_usb2.c                  |    4 +--
 drivers/net/ethernet/apm/xgene-v2/main.c        |    4 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c     |   14 +++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h     |    3 ++
 drivers/net/ethernet/marvell/mvneta.c           |    2 -
 drivers/tty/vt/vt_ioctl.c                       |   11 ++++++---
 drivers/usb/dwc3/gadget.c                       |   23 +++++++++-----------
 drivers/usb/gadget/function/u_audio.c           |    5 +---
 drivers/usb/serial/ch341.c                      |    1 
 drivers/usb/serial/option.c                     |    2 +
 drivers/vhost/vringh.c                          |    2 -
 drivers/video/fbdev/core/fbmem.c                |    4 +++
 drivers/virtio/virtio_ring.c                    |    6 +++--
 net/ipv4/ip_gre.c                               |    2 +
 net/rds/ib_frmr.c                               |    4 +--
 27 files changed, 113 insertions(+), 64 deletions(-)

Ben Skeggs (1):
      drm/nouveau/disp: power down unused DP links during init

Christophe JAILLET (1):
      xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

George Kennedy (1):
      fbmem: add margin check to fb_check_caps()

Gerd Rausch (1):
      net/rds: dma_map_sg is entitled to merge entries

Greg Kroah-Hartman (1):
      Linux 4.14.246

Guenter Roeck (1):
      ARC: Fix CONFIG_STACKDEPOT

Jerome Brunet (1):
      usb: gadget: u_audio: fix race condition on endpoint stop

Johan Hovold (1):
      Revert "USB: serial: ch341: fix character loss at high transfer rates"

Lai Jiangshan (1):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Linus Torvalds (1):
      vt_kdsetmode: extend console locking

Mark Yacoub (1):
      drm: Copy drm_wait_vblank to user before returning

Maxim Kiselev (1):
      net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Michał Mirosław (1):
      opp: remove WARN when no valid OPPs remain

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (1):
      virtio: Improve vq->broken access to avoid any compiler optimization

Sasha Neftin (1):
      e1000e: Fix the max snoop/no-snoop latency for 10M

Sean Christopherson (1):
      KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs

Shreyansh Chouhan (1):
      ip_gre: add validation for csum_start

Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Tuo Li (1):
      IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Wesley Cheng (1):
      usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Zhengjun Zhang (1):
      USB: serial: option: add new VID/PID to support Fibocom FG150

