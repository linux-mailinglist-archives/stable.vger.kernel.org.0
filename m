Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6EF446E24
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhKFNnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhKFNnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 09:43:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B12B761215;
        Sat,  6 Nov 2021 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636206026;
        bh=N3oPOy4sdxI1qch2cB9tzqRE0rjSrJ0+/Va4hF6bZoE=;
        h=From:To:Cc:Subject:Date:From;
        b=BBjq/YrP1X1ibh9tCg660jIi8hxhpZWlbTNLxgGSQwhJjt9NUUQxmw/nr/owxytLj
         0EE4sy1VQ9jRAmlkDfkl9u5ZsmE+0KXxfPNlpuhcOf+YCQzYHBZoPvJfvNAnu+Hnwc
         3WHSXP8DUM8/xa5fcvStbEjHUVUwgDSna62bzcsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.17
Date:   Sat,  6 Nov 2021 14:40:11 +0100
Message-Id: <16362060125225@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.17 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 drivers/amba/bus.c                                        |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                       |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c               |   80 --------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h               |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                |    8 -
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                   |    3 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    3 
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c      |    4 
 drivers/gpu/drm/i915/i915_reg.h                           |    8 -
 drivers/gpu/drm/i915/intel_dram.c                         |   30 -----
 drivers/media/firewire/firedtv-avc.c                      |   14 +-
 drivers/media/firewire/firedtv-ci.c                       |    2 
 drivers/net/ethernet/sfc/ethtool_common.c                 |   10 -
 drivers/net/vrf.c                                         |    4 
 drivers/net/wireless/ath/wcn36xx/main.c                   |   10 -
 drivers/net/wireless/ath/wcn36xx/pmc.c                    |    5 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                |    1 
 drivers/scsi/scsi.c                                       |    4 
 drivers/scsi/scsi_sysfs.c                                 |    9 +
 drivers/soc/imx/gpcv2.c                                   |    4 
 drivers/usb/core/hcd.c                                    |   29 +----
 drivers/usb/host/xhci.c                                   |    1 
 include/linux/usb/hcd.h                                   |    2 
 sound/usb/mixer_maps.c                                    |    8 +
 25 files changed, 52 insertions(+), 199 deletions(-)

Anson Jacob (1):
      drm/amd/display: Revert "Directly retrain link from debugfs"

Bryan O'Donoghue (1):
      Revert "wcn36xx: Disable bmps when encryption is disabled"

Christian König (1):
      drm/amdgpu: revert "Add autodump debugfs node for gpu reset v8"

Dan Carpenter (1):
      media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Erik Ekman (1):
      sfc: Fix reading non-legacy supported link modes

Eugene Crosser (1):
      vrf: Revert "Reset skb conntrack connection..."

Greg Kroah-Hartman (3):
      Revert "xhci: Set HCD flag to defer primary roothub registration"
      Revert "usb: core: hcd: Add support for deferring roothub registration"
      Linux 5.14.17

José Roberto de Souza (1):
      drm/i915: Remove memory frequency calculation

Lucas Stach (1):
      Revert "soc: imx: gpcv2: move reset assert after requesting domain power up"

Matthew Brost (1):
      Revert "drm/i915/gt: Propagate change in error status to children on unhold"

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Takashi Iwai (2):
      ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
      ALSA: usb-audio: Add Audient iD14 to mixer map quirk table

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Yifan Zhang (1):
      drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

