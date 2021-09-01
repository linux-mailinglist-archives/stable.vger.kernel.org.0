Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA283FDA59
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244666AbhIAMcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244691AbhIAMbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4C5F6101B;
        Wed,  1 Sep 2021 12:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499423;
        bh=h4bFY5gKYqE+pU2oso67sqWCRXQaX52C3Yh2lXErikw=;
        h=From:To:Cc:Subject:Date:From;
        b=aDKWPjWMD7iaaP7ey3z5KA3BDAYSv22epOE+AzJanYzJ8LytRJJ5gfh/joMDvqs3h
         hgBdHCu7hsz2jyl1aVmLvZKh8gm6a1kjoSXF4O7VV12Xi66v8WkLWiCwFKDDWMxycA
         l0AlMawYKEV4DJhMWjRuQ7cisDF908pOL/z/2TrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/33] 4.19.206-rc1 review
Date:   Wed,  1 Sep 2021 14:27:49 +0200
Message-Id: <20210901122250.752620302@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.206-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.206-rc1
X-KernelTest-Deadline: 2021-09-03T12:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.206 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.206-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.206-rc1

Peter Collingbourne <pcc@google.com>
    net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Denis Efremov <efremov@linux.com>
    Revert "floppy: reintroduce O_NDELAY fix"

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs

George Kennedy <george.kennedy@oracle.com>
    fbmem: add margin check to fb_check_caps()

Linus Torvalds <torvalds@linux-foundation.org>
    vt_kdsetmode: extend console locking

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: dma_map_sg is entitled to merge entries

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp: power down unused DP links during init

Mark Yacoub <markyacoub@google.com>
    drm: Copy drm_wait_vblank to user before returning

Shai Malin <smalin@marvell.com>
    qed: Fix null-pointer dereference in qed_rdma_create_qp()

Shai Malin <smalin@marvell.com>
    qed: qed ll2 race condition fixes

Neeraj Upadhyay <neeraju@codeaurora.org>
    vringh: Use wiov->used to check for read/write desc order

Parav Pandit <parav@nvidia.com>
    virtio_pci: Support surprise removal of virtio pci device

Parav Pandit <parav@nvidia.com>
    virtio: Improve vq->broken access to avoid any compiler optimization

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    opp: remove WARN when no valid OPPs remain

Jerome Brunet <jbrunet@baylibre.com>
    usb: gadget: u_audio: fix race condition on endpoint stop

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix get wrong pfc_en when query PFC configuration

Maxim Kiselev <bigunclemax@gmail.com>
    net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    ip_gre: add validation for csum_start

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix the max snoop/no-snoop latency for 10M

Tuo Li <islituo@gmail.com>
    IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Stop EP0 transfers during pullup disable

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Zhengjun Zhang <zhangzhengjun@aicrobo.com>
    USB: serial: option: add new VID/PID to support Fibocom FG150

Johan Hovold <johan@kernel.org>
    Revert "USB: serial: ch341: fix character loss at high transfer rates"

Stefan Mätje <stefan.maetje@esd.eu>
    can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Kefeng Wang <wangkefeng.wang@huawei.com>
    once: Fix panic when module unload

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: collect all entries in one cycle

Guenter Roeck <linux@roeck-us.net>
    ARC: Fix CONFIG_STACKDEPOT

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix truncation handling for mod32 dst reg wrt zero

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix 32 bit src register truncation on div/mod

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not use ax register in interpreter on div/mod

Xiaolong Huang <butterflyhuangxx@gmail.com>
    net: qrtr: fix another OOB Read in qrtr_endpoint_post


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arc/kernel/vmlinux.lds.S                      |  2 +
 arch/x86/kvm/mmu.c                                 | 11 +++-
 drivers/block/floppy.c                             | 27 ++++----
 drivers/gpu/drm/drm_ioc32.c                        |  4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c      |  2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h      |  1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c    |  9 +++
 drivers/infiniband/hw/hfi1/sdma.c                  |  9 ++-
 drivers/net/can/usb/esd_usb2.c                     |  4 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 13 +---
 drivers/net/ethernet/intel/e1000e/ich8lan.c        | 14 ++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |  3 +
 drivers/net/ethernet/marvell/mvneta.c              |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          | 20 ++++++
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |  3 +-
 drivers/opp/of.c                                   |  5 +-
 drivers/tty/vt/vt_ioctl.c                          | 11 ++--
 drivers/usb/dwc3/gadget.c                          | 23 ++++---
 drivers/usb/gadget/function/u_audio.c              |  5 +-
 drivers/usb/serial/ch341.c                         |  1 -
 drivers/usb/serial/option.c                        |  2 +
 drivers/vhost/vringh.c                             |  2 +-
 drivers/video/fbdev/core/fbmem.c                   |  4 ++
 drivers/virtio/virtio_pci_common.c                 |  7 +++
 drivers/virtio/virtio_ring.c                       |  6 +-
 include/linux/filter.h                             | 24 ++++++++
 include/linux/netdevice.h                          |  4 ++
 include/linux/once.h                               |  4 +-
 kernel/bpf/core.c                                  | 32 +++++-----
 kernel/bpf/verifier.c                              | 27 ++++----
 lib/once.c                                         | 11 +++-
 net/ipv4/ip_gre.c                                  |  2 +
 net/netfilter/nf_conntrack_core.c                  | 71 +++++++---------------
 net/qrtr/qrtr.c                                    |  2 +-
 net/rds/ib_frmr.c                                  |  4 +-
 net/socket.c                                       |  6 +-
 38 files changed, 228 insertions(+), 157 deletions(-)


