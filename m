Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18D4240937
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgHJPaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbgHJPaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2642C22D73;
        Mon, 10 Aug 2020 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073410;
        bh=kRby6Wd5pGtjm/nZE2vnJEhqlp7JL/8/tUwjfO6Cnbo=;
        h=From:To:Cc:Subject:Date:From;
        b=GdKoyxakdP1pSwoRrLnKJouUJ5C0kundviqBhSdqSXAfKsgpD5Nc9vKSpHZXwKlws
         Y1SpS+0aEQZPwfPkrGOT7UIrJw+jdpDn3tfgTjZotrAaJ9M+0vjD3PWLQ4MQNvt6D6
         l5u2NpfvVpO7Dq0I9IuL5aJ4Y3LcpC9mi39fz+74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/48] 4.19.139-rc1 review
Date:   Mon, 10 Aug 2020 17:21:22 +0200
Message-Id: <20200810151804.199494191@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.139-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.139-rc1
X-KernelTest-Deadline: 2020-08-12T15:18+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.139 release.
There are 48 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.139-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.139-rc1

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

Martyna Szapar <martyna.szapar@intel.com>
    i40e: Memory leak in i40e_config_iwarp_qvlist

Martyna Szapar <martyna.szapar@intel.com>
    i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c

Grzegorz Siwik <grzegorz.siwik@intel.com>
    i40e: Wrong truncation from u16 to u8

Sergey Nemov <sergey.nemov@intel.com>
    i40e: add num_vectors checker in iwarp handler

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Willem de Bruijn <willemb@google.com>
    selftests/net: relax cpu affinity requirement in msg_zerocopy test

Hangbin Liu <liuhangbin@gmail.com>
    Revert "vxlan: fix tos value before xmit"

Peilin Ye <yepeilin.cs@gmail.com>
    openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Xin Long <lucien.xin@gmail.com>
    net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: gre: recompute gre csum for sctp over gre tunnels

Stephen Hemminger <stephen@networkplumber.org>
    hv_netvsc: do not use VF device if link is down

Johan Hovold <johan@kernel.org>
    net: lan78xx: replace bogus endpoint lookup

Ido Schimmel <idosch@mellanox.com>
    vxlan: Ensure FDB dump is performed under RCU

Landen Chao <landen.chao@mediatek.com>
    net: ethernet: mtk_eth_soc: fix MTU warnings

Cong Wang <xiyou.wangcong@gmail.com>
    ipv6: fix memory leaks on IPV6_ADDRFORM path

Ido Schimmel <idosch@mellanox.com>
    ipv4: Silence suspicious RCU usage warning

Frank van der Linden <fllinden@amazon.com>
    xattr: break delegations in {set,remove}xattr

Dexuan Cui <decui@microsoft.com>
    Drivers: hv: vmbus: Ignore CHANNELMSG_TL_CONNECT_RESULT(23)

Philippe Duplessis-Guindon <pduplessis@efficios.com>
    tools lib traceevent: Fix memory leak in process_dynamic_array_len

Xin Xiong <xiongx18@fudan.edu.cn>
    atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent

Francesco Ruggeri <fruggeri@arista.com>
    igb: reinit_locked() should be called with rtnl_lock

Julian Squires <julian@cipht.net>
    cfg80211: check vendor command doit pointer before use

Qiushi Wu <wu000273@umn.edu>
    firmware: Fix a reference count leak.

Rustam Kovhaev <rkovhaev@gmail.com>
    usb: hso: check for return value in hso_serial_common_create()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: add sanity check when unregistering

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: improve sanity check when registering

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason

Christoph Hellwig <hch@lst.de>
    net/9p: validate fds in p9_fd_open

Johan Hovold <johan@kernel.org>
    leds: 88pm860x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm3533: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: da903x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: wm831x-status: fix use-after-free on unbind

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: properly check all write ioctls for permissions

Yunhai Zhang <zhangyunhai@nsfocus.com>
    vgacon: Fix for missing check in scrollback handling

Jann Horn <jannh@google.com>
    binder: Prevent context manager from incrementing ref 0

Adam Ford <aford173@gmail.com>
    omapfb: dss: Fix max fclk divider for omap36xx

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

Hui Wang <hui.wang@canonical.com>
    Revert "ALSA: hda: call runtime_allow() for all hda controllers"

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1142 DMA addressing

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: define IDs for various ASMedia host controllers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: iowarrior: fix up report size handling for some devices

Erik Ekman <erik@kryo.se>
    USB: serial: qcserial: add EM7305 QDL product ID


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/android/binder.c                           |  15 ++-
 drivers/atm/atmtcp.c                               |  10 +-
 drivers/firmware/qemu_fw_cfg.c                     |   7 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   3 +-
 drivers/hv/channel_mgmt.c                          |  21 ++--
 drivers/hv/vmbus_drv.c                             |   4 +
 drivers/i2c/i2c-core-slave.c                       |   7 +-
 drivers/leds/leds-88pm860x.c                       |  14 ++-
 drivers/leds/leds-da903x.c                         |  14 ++-
 drivers/leds/leds-lm3533.c                         |  12 ++-
 drivers/leds/leds-wm831x-status.c                  |  14 ++-
 drivers/mtd/mtdchar.c                              |  56 ++++++++--
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  51 ++++++---
 drivers/net/ethernet/intel/igb/igb_main.c          |   9 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +
 drivers/net/hyperv/netvsc_drv.c                    |   7 +-
 drivers/net/usb/hso.c                              |   5 +-
 drivers/net/usb/lan78xx.c                          | 117 ++++++---------------
 drivers/net/vxlan.c                                |  10 +-
 drivers/staging/android/ashmem.c                   |  12 +++
 drivers/usb/host/xhci-pci.c                        |  10 +-
 drivers/usb/misc/iowarrior.c                       |  35 ++++--
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/video/console/vgacon.c                     |   4 +
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |   2 +-
 fs/xattr.c                                         |  84 +++++++++++++--
 include/linux/hyperv.h                             |   2 +
 include/linux/xattr.h                              |   2 +
 include/net/addrconf.h                             |   1 +
 net/9p/trans_fd.c                                  |  24 +++--
 net/bluetooth/hci_event.c                          |  11 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/gre_offload.c                             |  13 ++-
 net/ipv6/anycast.c                                 |  17 ++-
 net/ipv6/ipv6_sockglue.c                           |   1 +
 net/openvswitch/conntrack.c                        |  38 +++----
 net/rxrpc/call_object.c                            |  27 +++--
 net/rxrpc/conn_object.c                            |   8 +-
 net/rxrpc/recvmsg.c                                |   2 +-
 net/rxrpc/sendmsg.c                                |   3 +
 net/wireless/nl80211.c                             |   6 +-
 security/smack/smackfs.c                           |  13 ++-
 sound/core/seq/oss/seq_oss.c                       |   8 +-
 sound/pci/hda/hda_intel.c                          |   1 -
 tools/lib/traceevent/event-parse.c                 |   1 +
 tools/testing/selftests/net/msg_zerocopy.c         |   5 +-
 48 files changed, 488 insertions(+), 231 deletions(-)


