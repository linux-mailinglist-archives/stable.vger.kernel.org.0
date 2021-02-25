Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FDF324D63
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhBYJ7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235607AbhBYJ4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:56:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5087964F10;
        Thu, 25 Feb 2021 09:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246873;
        bh=f/tX6EFH6nEyy2X0fMxIgqpM2ysFjlf3JoQu3ia94G0=;
        h=From:To:Cc:Subject:Date:From;
        b=YNUlMpNZJJvy02zYN54jCAqYDJJpokfplqizzwxfGHOqSTnDlL426XMd/L0as+hce
         ZUAzWSM1E1eyHOmiqoSNjGgFyAxivnQrJXi8GsgQm9A3nk02gCY5iCHUGkwXhyEXX0
         Pt8Ji+8eVLFdqhK2O/+dNX4DXRTJyXK+Bpiu/BC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/23] 5.10.19-rc1 review
Date:   Thu, 25 Feb 2021 10:53:31 +0100
Message-Id: <20210225092516.531932232@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.19-rc1
X-KernelTest-Deadline: 2021-02-27T09:25+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.19 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.19-rc1

Rong Chen <rong.a.chen@intel.com>
    scripts/recordmcount.pl: support big endian for ARCH sh

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix CONFIG_TRIM_UNUSED_KSYMS build for ppc64

Shyam Prasad N <sprasad@microsoft.com>
    cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

Raju Rangoju <rajur@chelsio.com>
    cxgb4: Add new T6 PCI device id 0x6092

Christoph Schemmel <christoph.schemmel@gmail.com>
    NET: usb: qmi_wwan: Adding support for Cinterion MV31

Quanyang Wang <quanyang.wang@windriver.com>
    drm/xlnx: fix kmemleak by sending vblank_event in atomic_disable

Sean Christopherson <seanjc@google.com>
    KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Paolo Bonzini <pbonzini@redhat.com>
    mm: provide a saner PTE walking API for modules

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not assume PTE is writable after follow_pfn

Christoph Hellwig <hch@lst.de>
    mm: simplify follow_pte{,pmd}

Christoph Hellwig <hch@lst.de>
    mm: unexport follow_pte_pmd

Sean Christopherson <seanjc@google.com>
    KVM: x86: Zap the oldest MMU pages, not the newest

Thomas Hebb <tommyhebb@gmail.com>
    hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist

Sameer Pujar <spujar@nvidia.com>
    arm64: tegra: Add power-domain for Tegra210 HDA

Hui Wang <hui.wang@canonical.com>
    Bluetooth: btusb: Some Qualcomm Bluetooth adapters stop working

Rustam Kovhaev <rkovhaev@gmail.com>
    ntfs: check for valid standard information attribute

Luis Henriques <lhenriques@suse.de>
    ceph: downgrade warning from mdsmap decode to debug

Stefan Ursella <stefan.ursella@wolfvision.net>
    usb: quirks: add quirk to start video capture on ELMO L-12F document camera reliable

Johan Hovold <johan@kernel.org>
    USB: quirks: sort quirk entries

Christoph Hellwig <hch@lst.de>
    nvme-rdma: Use ibdev_to_node instead of dereferencing ->dma_device

Christoph Hellwig <hch@lst.de>
    RDMA: Lift ibdev_to_node from rds to common code

Will McVicker <willmcvicker@google.com>
    HID: make arrays usage and value to be the same

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix truncation handling for mod32 dst reg wrt zero


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |  1 +
 arch/x86/kvm/mmu/mmu.c                             |  2 +-
 drivers/bluetooth/btusb.c                          |  7 +++
 drivers/gpu/drm/xlnx/zynqmp_disp.c                 | 15 +++---
 drivers/hid/hid-core.c                             |  6 +--
 drivers/hwmon/dell-smm-hwmon.c                     |  7 +++
 drivers/net/ethernet/chelsio/cxgb4/t4_pci_id_tbl.h |  1 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/nvme/host/rdma.c                           |  2 +-
 drivers/usb/core/quirks.c                          |  9 ++--
 fs/ceph/mdsmap.c                                   |  4 +-
 fs/cifs/connect.c                                  |  1 +
 fs/dax.c                                           | 10 ++--
 fs/ntfs/inode.c                                    |  6 +++
 include/linux/mm.h                                 |  8 +--
 include/rdma/ib_verbs.h                            | 13 +++++
 kernel/bpf/verifier.c                              | 10 ++--
 mm/memory.c                                        | 57 ++++++++++++----------
 net/rds/ib.h                                       |  7 ---
 scripts/gen_autoksyms.sh                           |  3 ++
 scripts/recordmcount.pl                            |  6 ++-
 virt/kvm/kvm_main.c                                | 17 +++++--
 23 files changed, 127 insertions(+), 70 deletions(-)


