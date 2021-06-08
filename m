Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0615739FF60
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhFHSct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhFHSb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D11B613BE;
        Tue,  8 Jun 2021 18:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176988;
        bh=KLRXFxylbyT+4ry5QZovAnoBhLfoTIhK7A3Zrg0Nvt4=;
        h=From:To:Cc:Subject:Date:From;
        b=yPGUVTKLFG1J9IZ7V2gjl71fqDWggmV+6+UZ/9E5l72RTT9qxYZvI7AleSwLWMAOQ
         v1yeqbMky8/HzMdib2Y6CzvIGByuuaQaAQZlAhSx3wAqmP3ypY636D8EFrdRr6wAKk
         pFI45lN+S1SspvmZmZzoBvM+C4/SiQN4zMS7A7fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/29] 4.9.272-rc1 review
Date:   Tue,  8 Jun 2021 20:26:54 +0200
Message-Id: <20210608175927.821075974@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.272-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.272-rc1
X-KernelTest-Deadline: 2021-06-10T17:59+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.272 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.272-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.272-rc1

Jan Beulich <jbeulich@suse.com>
    xen-pciback: redo VF placement in the virtual topology

Michael Weiser <michael.weiser@gmx.de>
    arm64: Remove unimplemented syscall log message

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Remove the setting of dev_port.

Josef Bacik <josef@toxicpanda.com>
    btrfs: fixup error handling in fixup_inode_link_counts

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in btrfs_del_csums

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix data corruption by fallocate

Mark Rutland <mark.rutland@arm.com>
    pid: take a reference when initializing `cad_pid`

Ye Bin <yebin10@huawei.com>
    ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix master timer notification

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in cfusbl_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: fix memory leak in caif_device_notify

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: add proper error handling

Pavel Skripkin <paskripkin@gmail.com>
    net: caif: added cfserl_release function

Lin Ma <linma@zju.edu.cn>
    Bluetooth: use correct lock to prevent UAF of hdev object

Lin Ma <linma@zju.edu.cn>
    Bluetooth: fix the erroneous flush_work() order

Wei Yongjun <weiyongjun1@huawei.com>
    ieee802154: fix error return code in ieee802154_llsec_getparams()

Zhen Lei <thunder.leizhen@huawei.com>
    ieee802154: fix error return code in ieee802154_add_iface()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

Arnd Bergmann <arnd@arndb.de>
    HID: i2c-hid: fix format string mismatch

Zhen Lei <thunder.leizhen@huawei.com>
    HID: pidff: fix error return code in hid_pidff_init()

Julian Anastasov <ja@ssi.bg>
    ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Max Gurtovoy <mgurtovoy@nvidia.com>
    vfio/platform: fix module_put call in error flow

Randy Dunlap <rdunlap@infradead.org>
    vfio/pci: zap_vma_ptes() needs MMU

Zhen Lei <thunder.leizhen@huawei.com>
    vfio/pci: Fix error return code in vfio_ecap_init()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    efi: cper: fix snprintf() use in cper_dimm_err_location()

Heiner Kallweit <hkallweit1@gmail.com>
    efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared

Grant Grundler <grundler@chromium.org>
    net: usb: cdc_ncm: don't spew notifications


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/arm64/kernel/traps.c                    |  8 ----
 arch/x86/kvm/svm.c                           |  8 ++--
 drivers/firmware/efi/cper.c                  |  4 +-
 drivers/firmware/efi/memattr.c               |  5 ---
 drivers/hid/i2c-hid/i2c-hid-core.c           |  4 +-
 drivers/hid/usbhid/hid-pidff.c               |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    |  1 -
 drivers/net/usb/cdc_ncm.c                    | 12 +++++-
 drivers/vfio/pci/Kconfig                     |  1 +
 drivers/vfio/pci/vfio_pci_config.c           |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/xen/xen-pciback/vpci.c               | 14 ++++---
 fs/btrfs/file-item.c                         | 10 ++---
 fs/btrfs/tree-log.c                          | 13 ++++---
 fs/ext4/extents.c                            | 43 ++++++++++++----------
 fs/ocfs2/file.c                              | 55 +++++++++++++++++++++++++---
 include/linux/usb/usbnet.h                   |  2 +
 include/net/caif/caif_dev.h                  |  2 +-
 include/net/caif/cfcnfg.h                    |  2 +-
 include/net/caif/cfserl.h                    |  1 +
 init/main.c                                  |  2 +-
 net/bluetooth/hci_core.c                     |  7 +++-
 net/bluetooth/hci_sock.c                     |  4 +-
 net/caif/caif_dev.c                          | 13 +++++--
 net/caif/caif_usb.c                          | 14 ++++++-
 net/caif/cfcnfg.c                            | 16 +++++---
 net/caif/cfserl.c                            |  5 +++
 net/ieee802154/nl-mac.c                      |  4 +-
 net/ieee802154/nl-phy.c                      |  4 +-
 net/netfilter/ipvs/ip_vs_ctl.c               |  2 +-
 net/netfilter/nfnetlink_cthelper.c           |  8 +++-
 net/nfc/llcp_sock.c                          |  2 +
 sound/core/timer.c                           |  3 +-
 34 files changed, 186 insertions(+), 92 deletions(-)


