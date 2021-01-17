Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038D82F9296
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbhAQNjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbhAQNja (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:39:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A59E12065E;
        Sun, 17 Jan 2021 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890724;
        bh=W+miSGOSJbaWWivV4wJ1KO2g16NJszSNujiEkVEADJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=Mf+FOm29k4uv6MYzoKMDJ0gSDBJpY9+j1nCqERSm5sXo9DF4ynSq8CtsRxlP0kGb2
         sLdDR0zG/c0mmpIQhDEHdqgN4Xrvly9DuibgWCV9KI7cgFsrV/dS/OIqq/gCJD6LF1
         JjSGyPmlAewxOPKydwgAakdNn5mkfW7lE3w9loqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.252
Date:   Sun, 17 Jan 2021 14:38:40 +0100
Message-Id: <161089072025191@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.252 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/powerpc/include/asm/pgtable.h       |    4 
 block/genhd.c                            |    9 -
 drivers/block/Kconfig                    |    1 
 drivers/cpufreq/powernow-k8.c            |    9 -
 drivers/iommu/intel_irq_remapping.c      |    2 
 drivers/net/wireless/ath/wil6210/Kconfig |    1 
 drivers/spi/spi-pxa2xx.c                 |    3 
 drivers/target/target_core_transport.c   |   24 +++
 drivers/target/target_core_xcopy.c       |  220 +++++++++++++++++++------------
 drivers/target/target_core_xcopy.h       |    1 
 fs/ubifs/io.c                            |   13 +
 include/asm-generic/vmlinux.lds.h        |    5 
 include/target/target_core_base.h        |    4 
 net/core/skbuff.c                        |    6 
 net/ipv4/ip_output.c                     |    2 
 net/ipv4/ip_tunnel.c                     |   10 -
 17 files changed, 208 insertions(+), 108 deletions(-)

Arnd Bergmann (2):
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32

Colin Ian King (1):
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

David Disseldorp (5):
      target: add XCOPY target/segment desc sense codes
      target: bounds check XCOPY segment descriptor list
      target: simplify XCOPY wwn->se_dev lookup helper
      target: use XCOPY segment descriptor CSCD IDs
      scsi: target: Fix XCOPY NAA identifier lookup

Dinghao Liu (1):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc

Florian Westphal (2):
      net: ip: always refragment ip defragmented packets
      net: fix pmtu check in nopmtudisc mode

Greg Kroah-Hartman (1):
      Linux 4.4.252

Lukas Wunner (1):
      spi: pxa2xx: Fix use-after-free on unbind

Mathieu Desnoyers (1):
      powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

Mike Christie (1):
      xcopy: loop over devices using idr helper

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Richard Weinberger (1):
      ubifs: wbuf: Don't leak kernel memory to flash

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

