Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1070D427A97
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhJIN2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233833AbhJIN2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4EF60F6C;
        Sat,  9 Oct 2021 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633786009;
        bh=YjFgpJu0mWND9b2akz7rCombRx/6P6spnsjA1DBBoDg=;
        h=From:To:Cc:Subject:Date:From;
        b=w6pviesl6dODB13qQpCM8rIOu/SQ2wiFiYMUKDUW7df6wYzEso8wLjT7G6rYj0hXe
         ibre1HacgmFKyWA0bkNwP/feL/sSEjDfGDgPL++Kjs0sk8ljWaOsVOVObMu1k97s7B
         NSe4s8EsSGuKXKiHcLCC8pfOjxUf0nfC1A7kzoiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.11
Date:   Sat,  9 Oct 2021 15:26:41 +0200
Message-Id: <163378600110591@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.11 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm/mach-imx/mach-imx6q.c                              |    3 
 arch/sparc/lib/iomap.c                                      |    2 
 arch/x86/events/core.c                                      |    1 
 arch/x86/kvm/svm/svm.c                                      |    2 
 arch/x86/kvm/x86.c                                          |   14 +
 arch/x86/lib/insn.c                                         |    4 
 block/bio.c                                                 |    2 
 drivers/ata/libata-core.c                                   |   34 +++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c                     |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c                    |   16 -
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h                    |    5 
 drivers/irqchip/irq-gic.c                                   |   52 +++++
 drivers/misc/habanalabs/common/command_submission.c         |    9 
 drivers/misc/habanalabs/gaudi/gaudi.c                       |    9 
 drivers/misc/habanalabs/gaudi/gaudi_security.c              |  115 ++++++------
 drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h |    2 
 drivers/net/phy/mdio_device.c                               |   11 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 -
 drivers/net/xen-netback/netback.c                           |    2 
 drivers/nvme/host/fc.c                                      |   18 +
 drivers/platform/x86/gigabyte-wmi.c                         |    1 
 drivers/platform/x86/touchscreen_dmi.c                      |   54 +++++
 drivers/scsi/elx/efct/efct_lio.c                            |    4 
 drivers/scsi/sd.c                                           |    9 
 drivers/scsi/ses.c                                          |   22 +-
 drivers/spi/spi-rockchip.c                                  |    6 
 drivers/thermal/qcom/tsens.c                                |    4 
 drivers/usb/dwc2/hcd.c                                      |    4 
 drivers/xen/gntdev.c                                        |    8 
 drivers/xen/swiotlb-xen.c                                   |    7 
 fs/afs/dir.c                                                |   11 +
 fs/afs/file.c                                               |   16 +
 fs/afs/write.c                                              |   17 +
 fs/btrfs/file-item.c                                        |   13 +
 fs/btrfs/volumes.c                                          |   13 +
 fs/cifs/smb2pdu.c                                           |    4 
 fs/ext2/balloc.c                                            |   14 -
 fs/io_uring.c                                               |    8 
 fs/nfsd/nfs4state.c                                         |   16 +
 include/linux/libata.h                                      |    1 
 include/linux/mdio.h                                        |    3 
 scripts/Makefile.kasan                                      |    3 
 tools/arch/x86/lib/insn.c                                   |    4 
 tools/testing/selftests/kvm/include/test_util.h             |    3 
 tools/testing/selftests/kvm/lib/test_util.c                 |   22 ++
 tools/testing/selftests/kvm/steal_time.c                    |   20 --
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c      |    3 
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c        |   15 -
 tools/testing/selftests/lib.mk                              |    1 
 tools/usb/testusb.c                                         |   14 -
 tools/vm/page-types.c                                       |    2 
 virt/kvm/kvm_main.c                                         |    6 
 53 files changed, 472 insertions(+), 177 deletions(-)

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

David Howells (1):
      afs: Add missing vnode validation checks

Fabio Estevam (1):
      Revert "ARM: imx6q: drop of_platform_default_populate() from init_machine"

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Fares Mehanna (1):
      kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Filipe Manana (1):
      btrfs: fix mount failure due to past and transient device flush error

Greg Kroah-Hartman (1):
      Linux 5.14.11

Hans de Goede (2):
      platform/x86: touchscreen_dmi: Add info for the Chuwi HiBook (CWI514) tablet
      platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet

James Smart (2):
      scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()
      nvme-fc: avoid race between time out and tear down

Jan Beulich (3):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case
      Xen/gntdev: don't ignore kernel unmapping error
      swiotlb-xen: ensure to issue well-formed XENMEM_exchange requests

Jens Axboe (1):
      io_uring: allow conditional reschedule for intensive iterators

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Li Zhijian (1):
      selftests: be sure to make khdr before other targets

Linus Torvalds (1):
      sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Marc Zyngier (1):
      irqchip/gic: Work around broken Renesas integration

Maxim Levitsky (2):
      KVM: x86: reset pdptrs_from_userspace when exiting smm
      KVM: x86: nSVM: restore int_vector in svm_clear_vintr

Ming Lei (2):
      scsi: sd: Free scsi_disk device via put_device()
      block: don't call rq_qos_ops->done_bio if the bio isn't tracked

Nathan Chancellor (1):
      kasan: always respect CONFIG_KASAN_STACK

Numfor Mbiziwo-Tiapo (1):
      x86/insn, tools/x86: Fix undefined behavior due to potential unaligned accesses

Oded Gabbay (1):
      habanalabs/gaudi: fix LBW RR configuration

Ofir Bitton (1):
      habanalabs: fail collective wait when not supported

Oliver Upton (1):
      selftests: KVM: Align SMCCC call with the spec in steal_time

Omer Shpigelman (1):
      habanalabs/gaudi: use direct MSI in single mode

Philip Yang (2):
      drm/amdkfd: handle svm migrate init error
      drm/amdkfd: fix svm_migrate_fini warning

Qu Wenruo (1):
      btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error handling

Sergey Senozhatsky (1):
      KVM: do not shrink halt_poll_ns below grow_start

Shuah Khan (4):
      selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn
      selftests:kvm: fix get_trans_hugepagesz() ignoring fscanf() return warn
      selftests: kvm: move get_run_delay() into lib/test_util
      selftests: kvm: fix get_run_delay() ignoring fscanf() return warn

Soeren Moch (1):
      Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"

Steve French (1):
      smb3: correct smb3 ACL security descriptor

Tobias Jakobi (1):
      platform/x86: gigabyte-wmi: add support for B550I Aorus Pro AX

Tobias Schramm (1):
      spi: rockchip: handle zero length transfers without timing out

Vladimir Oltean (1):
      net: mdio: introduce a shutdown method to mdio device drivers

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Yang Yingliang (1):
      usb: dwc2: check return value after calling platform_get_resource()

