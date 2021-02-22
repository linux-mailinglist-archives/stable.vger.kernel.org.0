Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DDD32160E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhBVMQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C599964F0F;
        Mon, 22 Feb 2021 12:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996068;
        bh=spWKn0hm/DPzeYGAKd6elDZnR+IUxANvPupIHRfcNC0=;
        h=From:To:Cc:Subject:Date:From;
        b=1YbWkwIjaOgdOmTNt7e8DkLT6gasIIxsWKfqUoGFwTGZESowVBTkDhOAbep69i5XG
         LVURsyd+Ni5ykmIwImQ7VW7klafDyo3QmPMSKnb9JwKaAgtd27u0LMF+a9DNEM3b9o
         DOi7zgz+1jHyjOrx+tG7BxgTHKhUnBWdheJPorTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH 5.10 00/29] 5.10.18-rc1 review
Date:   Mon, 22 Feb 2021 13:12:54 +0100
Message-Id: <20210222121019.444399883@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.18-rc1
X-KernelTest-Deadline: 2021-02-24T12:10+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.18 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.18-rc1

Matwey V. Kornilov <matwey@sai.msu.ru>
    media: pwc: Use correct device for DMA

Filipe Manana <fdmanana@suse.com>
    btrfs: fix crash after non-aligned direct IO write with O_DSYNC

David Sterba <dsterba@suse.com>
    btrfs: fix backport of 2175bf57dc952 in 5.10.13

Trent Piepho <tpiepho@gmail.com>
    Bluetooth: btusb: Always fallback to alt 1 for WBS

Linus Torvalds <torvalds@linux-foundation.org>
    tty: protect tty_write from odd low-level tty disciplines

Jan Beulich <jbeulich@suse.com>
    xen-blkback: fix error handling in xen_blkbk_map()

Jan Beulich <jbeulich@suse.com>
    xen-scsiback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-netback: don't "handle" error by BUG()

Jan Beulich <jbeulich@suse.com>
    xen-blkback: don't "handle" error by BUG()

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen/arm: don't ignore return errors from set_phys_to_machine

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct error checking in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()

Jan Beulich <jbeulich@suse.com>
    Xen/x86: don't bail early from clear_foreign_p2m_mapping()

Yonatan Linik <yonatanlinik@gmail.com>
    net: fix proc_fs init handling in af_packet and tls

Wang Hai <wanghai38@huawei.com>
    net: bridge: Fix a warning when del bridge sysfs

Eelco Chaudron <echaudro@redhat.com>
    net: openvswitch: fix TTL decrement exception action execution

Pablo Neira Ayuso <pablo@netfilter.org>
    net: sched: incorrect Kconfig dependencies on Netfilter modules

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix rdd mcu cmd endianness

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: fix endian issues

wenxu <wenxu@ucloud.cn>
    net/sched: fix miss init the mru in qdisc_skb_cb

Florian Westphal <fw@strlen.de>
    mptcp: skip to next candidate if subflow has unacked data

Loic Poulain <loic.poulain@linaro.org>
    net: qrtr: Fix port ID for control messages

Max Gurtovoy <mgurtovoy@nvidia.com>
    IB/isert: add module param to set sg_tablesize for IO cmd

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: add get_config callback in vdpasim_dev_attr

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: make 'config' generic and usable for any device type

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: store parsed MAC address in a buffer

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim: add struct vdpasim_dev_attr for device attributes

Max Gurtovoy <mgurtovoy@nvidia.com>
    vdpa_sim: remove hard-coded virtq count


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arm/xen/p2m.c                              |  6 +-
 arch/x86/xen/p2m.c                              | 15 ++---
 drivers/block/xen-blkback/blkback.c             | 32 +++++----
 drivers/bluetooth/btusb.c                       | 20 ++----
 drivers/infiniband/ulp/isert/ib_isert.c         | 27 +++++++-
 drivers/infiniband/ulp/isert/ib_isert.h         |  6 ++
 drivers/media/usb/pwc/pwc-if.c                  | 22 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 89 ++++++++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 87 ++++++++++++++++++------
 drivers/net/xen-netback/netback.c               |  4 +-
 drivers/tty/tty_io.c                            |  5 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                | 83 ++++++++++++++++-------
 drivers/xen/gntdev.c                            | 37 +++++-----
 drivers/xen/xen-scsiback.c                      |  4 +-
 fs/btrfs/ctree.h                                |  6 +-
 fs/btrfs/inode.c                                |  6 +-
 include/xen/grant_table.h                       |  1 +
 net/bridge/br.c                                 |  5 +-
 net/core/dev.c                                  |  2 +
 net/mptcp/protocol.c                            |  5 +-
 net/openvswitch/actions.c                       | 15 ++---
 net/packet/af_packet.c                          |  2 +
 net/qrtr/qrtr.c                                 |  2 +-
 net/sched/Kconfig                               |  6 +-
 net/tls/tls_proc.c                              |  3 +
 26 files changed, 337 insertions(+), 157 deletions(-)


