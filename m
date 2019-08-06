Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE18838C5
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfHFSlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFSlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:41:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 713F220C01;
        Tue,  6 Aug 2019 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565116907;
        bh=Y8rOeUIQT1VhBQQvs72EzdeVir4CjttwJHAzvg3kzsA=;
        h=Date:From:To:Cc:Subject:From;
        b=0cQ/+EFe5By94WbNy6ITl/y+sJutU0NnYQxV2ohcG42H494Y796eq2RD7ka/Jqfod
         ML2QPOoWal3erGaqy+BTKKHiaXQUO6Q62Pw1TgMZdz6QSAKmkyMSB7kkT5DIeVqKzb
         Pkr4Lwo+Nw33SsD8RLUWOrxhG/g1msRV57E0D+Js=
Date:   Tue, 6 Aug 2019 20:41:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.188
Message-ID: <20190806184144.GA27426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.188 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 arch/arm/boot/dts/rk3288.dtsi               |    1 
 arch/arm/mach-rpc/dma.c                     |    5 +++-
 arch/mips/lantiq/irq.c                      |    5 ++--
 arch/x86/include/asm/apic.h                 |    2 -
 arch/x86/include/asm/kvm_host.h             |   34 +++++++++++++++-------------
 arch/x86/kernel/apic/apic.c                 |    2 -
 arch/x86/math-emu/fpu_emu.h                 |    2 -
 arch/x86/math-emu/reg_constant.c            |    2 -
 drivers/dma/sh/rcar-dmac.c                  |    2 -
 drivers/net/ethernet/emulex/benet/be_main.c |    6 ++++
 drivers/s390/block/dasd_alias.c             |   22 +++++++++++++-----
 drivers/s390/scsi/zfcp_erp.c                |    7 +++++
 drivers/xen/swiotlb-xen.c                   |    4 +--
 fs/adfs/super.c                             |    5 +++-
 fs/btrfs/volumes.c                          |    3 --
 fs/ceph/super.h                             |    7 ++++-
 fs/coda/psdev.c                             |    5 +++-
 include/linux/acpi.h                        |    5 +++-
 include/linux/coda.h                        |    3 --
 include/linux/coda_psdev.h                  |   11 +++++++++
 include/uapi/linux/coda_psdev.h             |   13 ----------
 ipc/mqueue.c                                |   19 ++++++++-------
 kernel/module.c                             |    6 +---
 mm/cma.c                                    |   13 ++++++++++
 security/selinux/ss/policydb.c              |    6 ++++
 26 files changed, 124 insertions(+), 68 deletions(-)

Andrea Parri (1):
      ceph: fix improper use of smp_mb__before_atomic()

Arnd Bergmann (2):
      ACPI: fix false-positive -Wuninitialized warning
      x86: math-emu: Hide clang warnings for 16-bit overflow

Benjamin Block (1):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

David Sterba (1):
      btrfs: fix minimum number of chunk errors for DUP

Doug Berger (1):
      mm/cma.c: fail if fixed declaration can't be honored

Douglas Anderson (1):
      ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend

Geert Uytterhoeven (1):
      dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Greg Kroah-Hartman (1):
      Linux 4.4.188

Josh Poimboeuf (1):
      x86/kvm: Don't call kvm_spurious_fault() from .fixup

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kees Cook (1):
      ipc/mqueue.c: only perform resource calculation if user valid

Mikko Rapeli (1):
      uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel side headers

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Petr Cvek (1):
      MIPS: lantiq: Fix bitfield masking

Prarit Bhargava (1):
      kernel/module.c: Only return -EEXIST for modules that have finished loading

Qian Cai (1):
      x86/apic: Silence -Wtype-limits compiler warnings

Russell King (2):
      ARM: riscpc: fix DMA
      fs/adfs: super: fix use-after-free bug

Sam Protsenko (1):
      coda: fix build using bare-metal toolchain

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Zhouyang Jia (1):
      coda: add error handling for fget

