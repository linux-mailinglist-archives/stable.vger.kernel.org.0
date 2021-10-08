Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A74269A5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhJHLjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242499AbhJHLiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DA1D6141B;
        Fri,  8 Oct 2021 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692775;
        bh=1EVSVYLTTHr5RQcVO0/7IF3RTbz9aoGp4njdlBFctlI=;
        h=From:To:Cc:Subject:Date:From;
        b=cflk4vDz4Lwnk5Kj0kN+NDAXDJz1GIba+Z5I6Dpjlo9yGYlaIhZnt2ka+D1LC9JSd
         BrRrjZiRSdl9tLwKSGPygCBH9RLwOZOwuIzPmLrFPLvjL04BQSKvWcyERhUhnee/hD
         enrsAe+ZEQooHGBWYHZK4Au1wxRxEwSXgUE/rsfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/48] 5.14.11-rc1 review
Date:   Fri,  8 Oct 2021 13:27:36 +0200
Message-Id: <20211008112720.008415452@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.11-rc1
X-KernelTest-Deadline: 2021-10-10T11:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.11 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.11-rc1

Fabio Estevam <festevam@gmail.com>
    Revert "ARM: imx6q: drop of_platform_default_populate() from init_machine"

Soeren Moch <smoch@web.de>
    Revert "brcmfmac: use ISO3166 country code and 0 rev as fallback"

Kate Hsuan <hpa@redhat.com>
    libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Anand K Mistry <amistry@google.com>
    perf/x86: Reset destroy callback on event init failure

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: restore int_vector in svm_clear_vintr

Fares Mehanna <faresx@amazon.de>
    kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: reset pdptrs_from_userspace when exiting smm

Sergey Senozhatsky <senozhatsky@chromium.org>
    KVM: do not shrink halt_poll_ns below grow_start

Oliver Upton <oupton@google.com>
    selftests: KVM: Align SMCCC call with the spec in steal_time

Nathan Chancellor <nathan@kernel.org>
    kasan: always respect CONFIG_KASAN_STACK

Changbin Du <changbin.du@intel.com>
    tools/vm/page-types: remove dependency on opt_file for idle page tracking

Ming Lei <ming.lei@redhat.com>
    block: don't call rq_qos_ops->done_bio if the bio isn't tracked

Jens Axboe <axboe@kernel.dk>
    io_uring: allow conditional reschedule for intensive iterators

Numfor Mbiziwo-Tiapo <nums@google.com>
    x86/insn, tools/x86: Fix undefined behavior due to potential unaligned accesses

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

Jan Beulich <jbeulich@suse.com>
    swiotlb-xen: ensure to issue well-formed XENMEM_exchange requests

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: don't ignore kernel unmapping error

Shuah Khan <skhan@linuxfoundation.org>
    selftests: kvm: fix get_run_delay() ignoring fscanf() return warn

Shuah Khan <skhan@linuxfoundation.org>
    selftests: kvm: move get_run_delay() into lib/test_util

Shuah Khan <skhan@linuxfoundation.org>
    selftests:kvm: fix get_trans_hugepagesz() ignoring fscanf() return warn

Shuah Khan <skhan@linuxfoundation.org>
    selftests:kvm: fix get_warnings_count() ignoring fscanf() return warn

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: be sure to make khdr before other targets

Oded Gabbay <ogabbay@kernel.org>
    habanalabs/gaudi: fix LBW RR configuration

Ofir Bitton <obitton@habana.ai>
    habanalabs: fail collective wait when not supported

Omer Shpigelman <oshpigelman@habana.ai>
    habanalabs/gaudi: use direct MSI in single mode

Yang Yingliang <yangyingliang@huawei.com>
    usb: dwc2: check return value after calling platform_get_resource()

Faizel K B <faizel.kb@dicortech.com>
    usb: testusb: Fix for showing the connection speed

James Smart <jsmart2021@gmail.com>
    scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()

Ming Lei <ming.lei@redhat.com>
    scsi: sd: Free scsi_disk device via put_device()

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: fix svm_migrate_fini warning

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: handle svm migrate init error

Dan Carpenter <dan.carpenter@oracle.com>
    ext2: fix sleeping in atomic bugs on error

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    platform/x86: gigabyte-wmi: add support for B550I Aorus Pro AX

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

David Howells <dhowells@redhat.com>
    afs: Add missing vnode validation checks

Tobias Schramm <t.schramm@manjaro.org>
    spi: rockchip: handle zero length transfers without timing out


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-imx/mach-imx6q.c                     |   3 +
 arch/sparc/lib/iomap.c                             |   2 +
 arch/x86/events/core.c                             |   1 +
 arch/x86/kvm/svm/svm.c                             |   2 +
 arch/x86/kvm/x86.c                                 |  14 +++
 arch/x86/lib/insn.c                                |   4 +-
 block/bio.c                                        |   2 +-
 drivers/ata/libata-core.c                          |  34 +++++-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   1 -
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  16 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h           |   5 -
 drivers/irqchip/irq-gic.c                          |  52 +++++++++-
 .../misc/habanalabs/common/command_submission.c    |   9 ++
 drivers/misc/habanalabs/gaudi/gaudi.c              |   9 +-
 drivers/misc/habanalabs/gaudi/gaudi_security.c     | 115 ++++++++++++---------
 .../habanalabs/include/gaudi/asic_reg/gaudi_regs.h |   2 +
 drivers/net/phy/mdio_device.c                      |  11 ++
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  17 ++-
 drivers/net/xen-netback/netback.c                  |   2 +-
 drivers/nvme/host/fc.c                             |  18 ++--
 drivers/platform/x86/gigabyte-wmi.c                |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |  54 +++++++++-
 drivers/scsi/elx/efct/efct_lio.c                   |   4 +-
 drivers/scsi/sd.c                                  |   9 +-
 drivers/scsi/ses.c                                 |  22 +++-
 drivers/spi/spi-rockchip.c                         |   6 ++
 drivers/thermal/qcom/tsens.c                       |   4 +-
 drivers/usb/dwc2/hcd.c                             |   4 +
 drivers/xen/gntdev.c                               |   8 ++
 drivers/xen/swiotlb-xen.c                          |   7 +-
 fs/afs/dir.c                                       |  11 ++
 fs/afs/file.c                                      |  16 ++-
 fs/afs/write.c                                     |  17 ++-
 fs/btrfs/file-item.c                               |  13 ++-
 fs/btrfs/volumes.c                                 |  13 +++
 fs/cifs/smb2pdu.c                                  |   4 +-
 fs/ext2/balloc.c                                   |  14 ++-
 fs/io_uring.c                                      |   8 +-
 fs/nfsd/nfs4state.c                                |  16 ++-
 include/linux/libata.h                             |   1 +
 include/linux/mdio.h                               |   3 +
 scripts/Makefile.kasan                             |   3 +-
 tools/arch/x86/lib/insn.c                          |   4 +-
 tools/testing/selftests/kvm/include/test_util.h    |   3 +
 tools/testing/selftests/kvm/lib/test_util.c        |  22 +++-
 tools/testing/selftests/kvm/steal_time.c           |  20 +---
 .../selftests/kvm/x86_64/mmio_warning_test.c       |   3 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  15 ---
 tools/testing/selftests/lib.mk                     |   1 +
 tools/usb/testusb.c                                |  14 +--
 tools/vm/page-types.c                              |   2 +-
 virt/kvm/kvm_main.c                                |   6 +-
 53 files changed, 473 insertions(+), 178 deletions(-)


