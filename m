Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03544267A61
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgILMqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgILMmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:42:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED3A221E3;
        Sat, 12 Sep 2020 12:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914563;
        bh=3toW6fohS9QiQ6UOZTFuxjm57I2ZERlcrKB993SVHx0=;
        h=From:To:Cc:Subject:Date:From;
        b=cead+GK8x8LajLoovyaomLuBL6kg3JVDFycF1k4RNJtldPyrzUmwCMkyhxC1VGoRb
         OgOxj/5baDHpcP0B5nfDtfCKLqnj4rp+G22fawXXvBzXcvWXsdOz6dhUaqwt98jgmH
         fB1Q8Fa1gCCJVfKfst8dgduy5rtz3MPL9yNU6huw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.198
Date:   Sat, 12 Sep 2020 14:42:43 +0200
Message-Id: <159991456318732@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.198 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 block/blk-core.c                          |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 
 drivers/net/usb/dm9601.c                  |    4 
 drivers/vfio/pci/vfio_pci.c               |  352 +++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_config.c        |   51 +++-
 drivers/vfio/pci/vfio_pci_intrs.c         |   14 +
 drivers/vfio/pci/vfio_pci_private.h       |   16 +
 drivers/vfio/pci/vfio_pci_rdwr.c          |   29 +-
 drivers/vfio/vfio_iommu_type1.c           |   36 ++-
 net/core/dev.c                            |    3 
 net/core/netpoll.c                        |    2 
 net/netlabel/netlabel_domainhash.c        |   59 ++---
 net/sctp/socket.c                         |   16 -
 net/tipc/socket.c                         |    9 
 sound/firewire/tascam/tascam.c            |   30 ++
 16 files changed, 538 insertions(+), 96 deletions(-)

Alex Williamson (4):
      vfio/type1: Support faulting PFNMAP vmas
      vfio-pci: Fault mmaps to enable vma tracking
      vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
      vfio/pci: Fix SR-IOV VF handling with MMIO blocking

Greg Kroah-Hartman (1):
      Linux 4.14.198

Jakub Kicinski (2):
      bnxt: don't enable NAPI until rings are ready
      net: disable netpoll on fresh napis

Jens Axboe (1):
      block: ensure bdi->io_pages is always initialized

Kamil Lorenc (1):
      net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore (1):
      netlabel: fix problems with mapping removal

Takashi Sakamoto (1):
      ALSA; firewire-tascam: exclude Tascam FE-8 from detection

Tetsuo Handa (1):
      tipc: fix shutdown() of connectionless socket

Xin Long (1):
      sctp: not disable bh in the whole sctp_get_port_local()

