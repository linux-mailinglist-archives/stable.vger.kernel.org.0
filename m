Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1F439FF11
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhFHSaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhFHSaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:30:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0717761376;
        Tue,  8 Jun 2021 18:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176911;
        bh=B0X9hapwHINmwlTNtKZF+MfOGvTUI8vNFGBK/PJh1qE=;
        h=From:To:Cc:Subject:Date:From;
        b=NncaI0Dd4pyrfn7VZH5txhBpLl2bfBRI4cJEjcC+5wwb1qvh8r+vcdBpE9OtzgssH
         FJAcf1Dm+IfeKg7XirvmxyDjvzaW5xSFxVWdrMDU+hJ1H1PfXzCTTjDM4Oouvdb2da
         4G4yHxNpw9GRysOLsr+QWi88vyg47Yef8rPCtk1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/23] 4.4.272-rc1 review
Date:   Tue,  8 Jun 2021 20:26:52 +0200
Message-Id: <20210608175926.524658689@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.272-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.272-rc1
X-KernelTest-Deadline: 2021-06-10T17:59+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.272 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.272-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.272-rc1

Jan Beulich <jbeulich@suse.com>
    xen-pciback: redo VF placement in the virtual topology

Michael Weiser <michael.weiser@gmx.de>
    arm64: Remove unimplemented syscall log message

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode

Josef Bacik <josef@toxicpanda.com>
    btrfs: fixup error handling in fixup_inode_link_counts

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

Zhen Lei <thunder.leizhen@huawei.com>
    HID: pidff: fix error return code in hid_pidff_init()

Julian Anastasov <ja@ssi.bg>
    ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service

Max Gurtovoy <mgurtovoy@nvidia.com>
    vfio/platform: fix module_put call in error flow

Zhen Lei <thunder.leizhen@huawei.com>
    vfio/pci: Fix error return code in vfio_ecap_init()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    efi: cper: fix snprintf() use in cper_dimm_err_location()


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/arm64/kernel/traps.c                    |  8 ----
 arch/x86/kvm/svm.c                           |  8 ++--
 drivers/firmware/efi/cper.c                  |  4 +-
 drivers/hid/usbhid/hid-pidff.c               |  1 +
 drivers/vfio/pci/vfio_pci_config.c           |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/xen/xen-pciback/vpci.c               | 14 ++++---
 fs/btrfs/tree-log.c                          | 13 ++++---
 fs/ext4/extents.c                            | 43 ++++++++++++----------
 fs/ocfs2/file.c                              | 55 +++++++++++++++++++++++++---
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
 27 files changed, 165 insertions(+), 78 deletions(-)


