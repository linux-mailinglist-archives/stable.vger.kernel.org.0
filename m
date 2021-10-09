Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15250427A8F
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhJIN2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233191AbhJIN2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF8060F5A;
        Sat,  9 Oct 2021 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633785993;
        bh=xGp6Ttvkiy+vYXs54RPXfWHnKUjpof9M9US17jVbHcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JuMWpmlM5WSSyJ+V/XIzlyBjrsGTmn2nbU5JE/qepd291jQFN3/B7pkCsFLIzU+RW
         t8++p/Rp9tynKqp5/0E/NXx0HDx0XaU6Gu7a4GD47ltBc0kvABMZzRz++HkWiTXZ88
         7aR1HNiuqsR+Aawq3IfvoHmrlCEPesilLEkYLutk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.152
Date:   Sat,  9 Oct 2021 15:26:28 +0200
Message-Id: <1633785989129248@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.152 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 -
 arch/sparc/lib/iomap.c                                 |    2 +
 arch/x86/events/core.c                                 |    1 
 arch/x86/kvm/x86.c                                     |    7 +++
 drivers/ata/libata-core.c                              |   34 ++++++++++++++++-
 drivers/net/phy/mdio_device.c                          |   11 +++++
 drivers/net/xen-netback/netback.c                      |    2 -
 drivers/scsi/sd.c                                      |    9 ++--
 drivers/scsi/ses.c                                     |   22 +++++++++--
 drivers/usb/dwc2/hcd.c                                 |    4 ++
 fs/ext2/balloc.c                                       |   14 +++----
 fs/nfsd/nfscache.c                                     |   12 ++----
 include/linux/libata.h                                 |    1 
 include/linux/mdio.h                                   |    3 +
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c |    3 +
 tools/testing/selftests/lib.mk                         |    1 
 tools/usb/testusb.c                                    |   14 ++++---
 tools/vm/page-types.c                                  |    2 -
 virt/kvm/kvm_main.c                                    |    6 ++-
 19 files changed, 113 insertions(+), 37 deletions(-)

Anand K Mistry (1):
      perf/x86: Reset destroy callback on event init failure

Changbin Du (1):
      tools/vm/page-types: remove dependency on opt_file for idle page tracking

Dan Carpenter (1):
      ext2: fix sleeping in atomic bugs on error

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Fares Mehanna (1):
      kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Greg Kroah-Hartman (1):
      Linux 5.4.152

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Li Zhijian (1):
      selftests: be sure to make khdr before other targets

Linus Torvalds (1):
      sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

Rik van Riel (1):
      silence nfscache allocation warnings with kvzalloc

Sergey Senozhatsky (1):
      KVM: do not shrink halt_poll_ns below grow_start

Shuah Khan (1):
      selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn

Vladimir Oltean (1):
      net: mdio: introduce a shutdown method to mdio device drivers

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Yang Yingliang (1):
      usb: dwc2: check return value after calling platform_get_resource()

