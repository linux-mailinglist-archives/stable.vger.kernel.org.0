Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BDA426960
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhJHLg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhJHLeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B933F61250;
        Fri,  8 Oct 2021 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692706;
        bh=oSWRAI7JL3VHDdN9chfLhxKZVg3MZ/AMjIifmxi2cbY=;
        h=From:To:Cc:Subject:Date:From;
        b=CyJ2ESCfpotg9uFR5gccCllqz1ZkL0qWirl7XczbJ1MmKzyPu6bnw9mYtFY6H/nNr
         8P79BVfWVRY3pUhDKDBaJbeDSBopQ2aP9klTi2T9TxNfSmREsNlC+Jj79uf+H6Dmkn
         GwjXKIOvZTDO1UAw922lUIgOsH8ITMiADgaLDtdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/29] 5.10.72-rc1 review
Date:   Fri,  8 Oct 2021 13:27:47 +0200
Message-Id: <20211008112716.914501436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.72-rc1
X-KernelTest-Deadline: 2021-10-10T11:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.72 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.72-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.72-rc1

Kate Hsuan <hpa@redhat.com>
    libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Anand K Mistry <amistry@google.com>
    perf/x86: Reset destroy callback on event init failure

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: restore int_vector in svm_clear_vintr

Fares Mehanna <faresx@amazon.de>
    kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Sergey Senozhatsky <senozhatsky@chromium.org>
    KVM: do not shrink halt_poll_ns below grow_start

Oliver Upton <oupton@google.com>
    selftests: KVM: Align SMCCC call with the spec in steal_time

Changbin Du <changbin.du@intel.com>
    tools/vm/page-types: remove dependency on opt_file for idle page tracking

Steve French <stfrench@microsoft.com>
    smb3: correct smb3 ACL security descriptor

Marc Zyngier <maz@kernel.org>
    irqchip/gic: Work around broken Renesas integration

Wen Xiong <wenxiong@linux.ibm.com>
    scsi: ses: Retry failed Send/Receive Diagnostic commands

Ansuel Smith <ansuelsmth@gmail.com>
    thermal/drivers/tsens: Fix wrong check for tzd in irq handlers

James Smart <jsmart2021@gmail.com>
    nvme-fc: avoid race between time out and tear down

Daniel Wagner <dwagner@suse.de>
    nvme-fc: update hardware queues before using them

Shuah Khan <skhan@linuxfoundation.org>
    selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: be sure to make khdr before other targets

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: fix LBW RR configuration

Yang Yingliang <yangyingliang@huawei.com>
    usb: dwc2: check return value after calling platform_get_resource()

Faizel K B <faizel.kb@dicortech.com>
    usb: testusb: Fix for showing the connection speed

Ming Lei <ming.lei@redhat.com>
    scsi: sd: Free scsi_disk device via put_device()

Dan Carpenter <dan.carpenter@oracle.com>
    ext2: fix sleeping in atomic bugs on error

Linus Torvalds <torvalds@linux-foundation.org>
    sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Jan Beulich <jbeulich@suse.com>
    xen-netback: correct success/error reporting for the SKB-with-fraglist case

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mdio: introduce a shutdown method to mdio device drivers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix mount failure due to past and transient device flush error

Qu Wenruo <wqu@suse.com>
    btrfs: replace BUG_ON() in btrfs_csum_one_bio() with proper error handling

Dai Ngo <dai.ngo@oracle.com>
    nfsd: back channel stuck in SEQ4_STATUS_CB_PATH_DOWN

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Update info for the Chuwi Hi10 Plus (CWI527) tablet

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Chuwi HiBook (CWI514) tablet

Tobias Schramm <t.schramm@manjaro.org>
    spi: rockchip: handle zero length transfers without timing out


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/sparc/lib/iomap.c                             |   2 +
 arch/x86/events/core.c                             |   1 +
 arch/x86/kvm/svm/svm.c                             |   2 +
 arch/x86/kvm/x86.c                                 |   7 ++
 drivers/ata/libata-core.c                          |  34 +++++-
 drivers/irqchip/irq-gic.c                          |  52 +++++++++-
 drivers/misc/habanalabs/gaudi/gaudi_security.c     | 115 ++++++++++++---------
 drivers/net/phy/mdio_device.c                      |  11 ++
 drivers/net/xen-netback/netback.c                  |   2 +-
 drivers/nvme/host/fc.c                             |  18 ++--
 drivers/platform/x86/touchscreen_dmi.c             |  54 +++++++++-
 drivers/scsi/sd.c                                  |   9 +-
 drivers/scsi/ses.c                                 |  22 +++-
 drivers/spi/spi-rockchip.c                         |   6 ++
 drivers/thermal/qcom/tsens.c                       |   4 +-
 drivers/usb/dwc2/hcd.c                             |   4 +
 fs/btrfs/file-item.c                               |  13 ++-
 fs/btrfs/volumes.c                                 |  13 +++
 fs/cifs/smb2pdu.c                                  |   4 +-
 fs/ext2/balloc.c                                   |  14 ++-
 fs/nfsd/nfs4state.c                                |  16 ++-
 include/linux/libata.h                             |   1 +
 include/linux/mdio.h                               |   3 +
 tools/testing/selftests/kvm/steal_time.c           |   4 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   3 +-
 tools/testing/selftests/lib.mk                     |   1 +
 tools/usb/testusb.c                                |  14 +--
 tools/vm/page-types.c                              |   2 +-
 virt/kvm/kvm_main.c                                |   6 +-
 30 files changed, 340 insertions(+), 101 deletions(-)


