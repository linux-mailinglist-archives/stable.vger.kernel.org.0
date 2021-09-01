Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11413FD9C0
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhIAM2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhIAM2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DD3F60ED4;
        Wed,  1 Sep 2021 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499266;
        bh=dK5VyNAAGsy592ccoeXQL+rG26jAo3CWunPQFODTsFc=;
        h=From:To:Cc:Subject:Date:From;
        b=pk1UV5cbuV55/0ThSvH4xC7VsAW2xSzJ113+caM/9GnxOkSlgspRRW0hc3V87+hvh
         DVsBBK2KZgXPAoPAcY0z5pMEuxfuUREJypgQ4c+RGKZD/KnAxTcxlnubCgUCSzx4Ml
         ZR4OzjZlepFR7CiC831/Nmq5NQnZGxdw8B7/GT4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/16] 4.9.282-rc1 review
Date:   Wed,  1 Sep 2021 14:26:26 +0200
Message-Id: <20210901122248.920548099@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.282-rc1
X-KernelTest-Deadline: 2021-09-03T12:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.282 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.282-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.282-rc1

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

Neeraj Upadhyay <neeraju@codeaurora.org>
    vringh: Use wiov->used to check for read/write desc order

Parav Pandit <parav@nvidia.com>
    virtio: Improve vq->broken access to avoid any compiler optimization

Maxim Kiselev <bigunclemax@gmail.com>
    net: marvell: fix MVNETA_TX_IN_PRGRS bit number

Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
    ip_gre: add validation for csum_start

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix the max snoop/no-snoop latency for 10M

Tuo Li <islituo@gmail.com>
    IB/hfi1: Fix possible null-pointer dereference in _extend_sdma_tx_descs()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

Zhengjun Zhang <zhangzhengjun@aicrobo.com>
    USB: serial: option: add new VID/PID to support Fibocom FG150

Johan Hovold <johan@kernel.org>
    Revert "USB: serial: ch341: fix character loss at high transfer rates"

Stefan Mätje <stefan.maetje@esd.eu>
    can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

Guenter Roeck <linux@roeck-us.net>
    ARC: Fix CONFIG_STACKDEPOT


-------------

Diffstat:

 Makefile                                    |  4 ++--
 arch/arc/kernel/vmlinux.lds.S               |  2 ++
 arch/x86/kvm/mmu.c                          | 11 ++++++++++-
 drivers/block/floppy.c                      | 27 +++++++++++++--------------
 drivers/infiniband/hw/hfi1/sdma.c           |  9 ++++-----
 drivers/net/can/usb/esd_usb2.c              |  4 ++--
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 14 +++++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 +++
 drivers/net/ethernet/marvell/mvneta.c       |  2 +-
 drivers/tty/vt/vt_ioctl.c                   | 11 +++++++----
 drivers/usb/dwc3/gadget.c                   | 16 ++++++++--------
 drivers/usb/serial/ch341.c                  |  1 -
 drivers/usb/serial/option.c                 |  2 ++
 drivers/vhost/vringh.c                      |  2 +-
 drivers/video/fbdev/core/fbmem.c            |  4 ++++
 drivers/virtio/virtio_ring.c                |  6 ++++--
 net/ipv4/ip_gre.c                           |  2 ++
 net/rds/ib_frmr.c                           |  4 ++--
 18 files changed, 80 insertions(+), 44 deletions(-)


