Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715C1446E17
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhKFNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhKFNmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 09:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62FFF611C0;
        Sat,  6 Nov 2021 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636205990;
        bh=TtfvVKRuI6XKiIt2H+76szdSByaXQUauvuC9gq/G+FU=;
        h=From:To:Cc:Subject:Date:From;
        b=EzCk5uBXkE5eprGPhmvaZH7qOl1BgZiibODT2UAYKKcch/iy+KndqTNGrVJX1tZYI
         /DE10ngoL/Q+irTaHTHBOAO3vPZMRBA1l2nL2WAiaEmS7ycUKktvwkIPZQt4wb7q6+
         ur0XImcGdyU6HJ2dTLCXAXe7eKOkprOaKZRkdrNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.216
Date:   Sat,  6 Nov 2021 14:39:47 +0100
Message-Id: <16362059872106@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.216 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/arc/include/asm/pgtable.h            |    2 +
 arch/arm/include/asm/pgtable-2level.h     |    2 +
 arch/arm/include/asm/pgtable-3level.h     |    2 +
 arch/mips/include/asm/pgtable-32.h        |    3 ++
 arch/powerpc/include/asm/pte-common.h     |    2 +
 arch/riscv/include/asm/pgtable-32.h       |    2 +
 drivers/amba/bus.c                        |    3 --
 drivers/infiniband/hw/qib/qib_user_sdma.c |   34 +++++++++++++++++++++---------
 drivers/media/firewire/firedtv-avc.c      |   14 +++++++++---
 drivers/media/firewire/firedtv-ci.c       |    2 +
 drivers/net/ethernet/sfc/ethtool.c        |   10 +-------
 drivers/scsi/scsi.c                       |    4 ++-
 drivers/scsi/scsi_sysfs.c                 |    9 +++++++
 include/asm-generic/pgtable.h             |   13 +++++++++++
 15 files changed, 78 insertions(+), 26 deletions(-)

Arnd Bergmann (1):
      arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Dan Carpenter (1):
      media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Erik Ekman (1):
      sfc: Fix reading non-legacy supported link modes

Greg Kroah-Hartman (1):
      Linux 4.19.216

Gustavo A. R. Silva (1):
      IB/qib: Use struct_size() helper

Mike Marciniszyn (1):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

