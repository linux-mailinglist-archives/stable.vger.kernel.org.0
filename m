Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0178427A93
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbhJIN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233751AbhJIN2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7C460F8F;
        Sat,  9 Oct 2021 13:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633786000;
        bh=30EDtQAHRgPkINiK61zMM4SbneVZKIUfajHCVMWD6XI=;
        h=From:To:Cc:Subject:Date:From;
        b=0WF/HNjazymeI9n79CkXxFH0lvIE+3h+BjyfHWaJ4qvZpCTxr9SUoqM0GgdR2v9Hg
         rRmXuOseONB8gKG2zUb+4gJTgEP/lp6jQUYfURfqchlhZn45yLqj31mvd+YxYH7FSH
         nidww8GcaeEihBFJ4ET9j+oXNQgpIFmsDwM9U9P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.72
Date:   Sat,  9 Oct 2021 15:26:33 +0200
Message-Id: <163378599471216@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.72 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/sparc/lib/iomap.c                                 |    2 
 arch/x86/events/core.c                                 |    1 
 arch/x86/kvm/svm/svm.c                                 |    2 
 arch/x86/kvm/x86.c                                     |    7 +
 drivers/ata/libata-core.c                              |   34 ++++-
 drivers/irqchip/irq-gic.c                              |   52 +++++++
 drivers/misc/habanalabs/gaudi/gaudi_security.c         |  115 +++++++++--------
 drivers/net/phy/mdio_device.c                          |   11 +
 drivers/net/xen-netback/netback.c                      |    2 
 drivers/nvme/host/fc.c                                 |   18 +-
 drivers/platform/x86/touchscreen_dmi.c                 |   54 +++++++
 drivers/scsi/sd.c                                      |    9 -
 drivers/scsi/ses.c                                     |   22 ++-
 drivers/spi/spi-rockchip.c                             |    6 
 drivers/thermal/qcom/tsens.c                           |    4 
 drivers/usb/dwc2/hcd.c                                 |    4 
 fs/btrfs/file-item.c                                   |   13 +
 fs/btrfs/volumes.c                                     |   13 +
 fs/cifs/smb2pdu.c                                      |    4 
 fs/ext2/balloc.c                                       |   14 --
 fs/nfsd/nfs4state.c                                    |   16 +-
 include/linux/libata.h                                 |    1 
 include/linux/mdio.h                                   |    3 
 tools/testing/selftests/kvm/steal_time.c               |    4 
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c |    3 
 tools/testing/selftests/lib.mk                         |    1 
 tools/usb/testusb.c                                    |   14 +-
 tools/vm/page-types.c                                  |    2 
 virt/kvm/kvm_main.c                                    |    6 
 30 files changed, 339 insertions(+), 100 deletions(-)

Anand K Mistry (1):
      perf/x86: Reset destroy callback on event init failure

Ansuel Smith (1):
      thermal/drivers/tsens: Fix wrong check for tzd in irq handlers

Changbin Du (1):
      tools/vm/page-types: remove dependency on opt_file for idle page tracking

Dai Ngo (1):
      nfsd: back channel stuck in SEQ4_STATUS_CB_PATH_DOWN

Dan Carpenter (1):
      ext2: fix sleeping in atomic bugs on error

Daniel Wagner (1):
      nvme-fc: update hardware queues before using them

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Fares Mehanna (1):
      kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Filipe Manana (1):
      btrfs: fix mount failure due to past and transient device flush error

Greg Kroah-Hartman (1):
      Linux 5.10.72

Hans de Goede (2):
      platform/x86: touchscreen_dmi: Add info for the Chuwi HiBook (CWI514) tablet
      platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet

James Smart (1):
      nvme-fc: avoid race between time out and tear down

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Li Zhijian (1):
      selftests: be sure to make khdr before other targets

Linus Torvalds (1):
      sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Marc Zyngier (1):
      irqchip/gic: Work around broken Renesas integration

Maxim Levitsky (1):
      KVM: x86: nSVM: restore int_vector in svm_clear_vintr

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

Oded Gabbay (1):
      habanalabs/gaudi: fix LBW RR configuration

Oliver Upton (1):
      selftests: KVM: Align SMCCC call with the spec in steal_time

Qu Wenruo (1):
      btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error handling

Sergey Senozhatsky (1):
      KVM: do not shrink halt_poll_ns below grow_start

Shuah Khan (1):
      selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn

Steve French (1):
      smb3: correct smb3 ACL security descriptor

Tobias Schramm (1):
      spi: rockchip: handle zero length transfers without timing out

Vladimir Oltean (1):
      net: mdio: introduce a shutdown method to mdio device drivers

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Yang Yingliang (1):
      usb: dwc2: check return value after calling platform_get_resource()

