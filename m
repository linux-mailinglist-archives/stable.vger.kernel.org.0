Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158642D03CA
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgLFLkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:40:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgLFLkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:40:20 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/32] 4.19.162-rc1 review
Date:   Sun,  6 Dec 2020 12:17:00 +0100
Message-Id: <20201206111555.787862631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.162-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.162-rc1
X-KernelTest-Deadline: 2020-12-08T11:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.162 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.162-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.162-rc1

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/i40iw: Address an mmap handler exploit in i40iw

Vasily Averin <vvs@virtuozzo.com>
    tracing: Remove WARN_ON in start_thread()

Po-Hsu Lin <po-hsu.lin@canonical.com>
    Input: i8042 - add ByteSpeed touchpad to noloop table

Sanjay Govind <sanjay.govind9@gmail.com>
    Input: xpad - support Ardwiino Controllers

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: US16x08: fix value count for level meters

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: net: correct interrupt flags in examples

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix panic during unload reload chtls

Eran Ben Elisha <eranbe@nvidia.com>
    net/mlx5: Fix wrong address reclaim when command interface is down

Wang Hai <wanghai38@huawei.com>
    net: mvpp2: Fix error return code in mvpp2_open()

Dan Carpenter <dan.carpenter@oracle.com>
    chelsio/chtls: fix a double free in chtls_setkey()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: pasemi: fix error return code in pasemi_mac_open()

Zhang Changzhong <zhangchangzhong@huawei.com>
    cxgb3: fix error return code in t3_sge_alloc_qset()

Dan Carpenter <dan.carpenter@oracle.com>
    net/x25: prevent a couple of overflows

Antoine Tenart <atenart@kernel.org>
    net: ip6_gre: set dev->hard_header_len when using header_ops

Eric Dumazet <edumazet@google.com>
    geneve: pull IP header before ECN decapsulation

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Fix TX completion error handling

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Ensure that SCRQ entry reads are correctly ordered

Guillaume Nault <gnault@redhat.com>
    ipv4: Fix tos mask in inet_rtm_getroute()

Antoine Tenart <atenart@kernel.org>
    netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal

Jamie Iles <jamie@nuviainc.com>
    bonding: wait for sysfs kobject destruction before freeing struct slave

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix removing driver while bare-metal VFs pass traffic

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: notify peers when failover and migration happen

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: fix call_netdevice_notifiers in do_reset

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/tls: Protect from calling tls_dev_del for TLS RX twice

Yves-Alexis Perez <corsac@corsac.net>
    usbnet: ipheth: fix connectivity with iOS 14

Jens Axboe <axboe@kernel.dk>
    tun: honor IOCB_NOWAIT flag

Alexander Duyck <alexanderduyck@fb.com>
    tcp: Set INET_ECN_xmit configuration in tcp_reinit_congestion_control

Willem de Bruijn <willemb@google.com>
    sock: set sk_err to ee_errno on dequeue from errq

Anmol Karn <anmol.karan123@gmail.com>
    rose: Fix Null pointer dereference in rose_send_frame()

Vadim Fedorenko <vfedorenko@novek.ru>
    net/tls: missing received data after fast remote close

Julian Wiedmann <jwi@linux.ibm.com>
    net/af_iucv: set correct sk_protocol for child sockets

Wang Hai <wanghai38@huawei.com>
    ipv6: addrlabel: fix possible memory leak in ip6addrlbl_net_init


-------------

Diffstat:

 .../devicetree/bindings/net/nfc/nxp-nci.txt        |  2 +-
 .../devicetree/bindings/net/nfc/pn544.txt          |  2 +-
 Makefile                                           |  4 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  1 +
 drivers/crypto/chelsio/chtls/chtls_hw.c            |  1 +
 drivers/infiniband/hw/i40iw/i40iw_main.c           |  5 --
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          | 36 +++----------
 drivers/input/joystick/xpad.c                      |  2 +
 drivers/input/serio/i8042-x86ia64io.h              |  4 ++
 drivers/net/bonding/bond_main.c                    | 61 +++++++++++++++-------
 drivers/net/bonding/bond_sysfs_slave.c             | 18 +------
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |  1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 | 32 ++++++++++--
 drivers/net/ethernet/intel/i40e/i40e.h             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 22 +++++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 26 +++++----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  1 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 21 +++++++-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |  8 ++-
 drivers/net/geneve.c                               | 20 +++++--
 drivers/net/tun.c                                  | 14 +++--
 drivers/net/usb/ipheth.c                           |  2 +-
 include/net/bonding.h                              |  8 +++
 include/net/tls.h                                  |  6 +++
 kernel/trace/trace_hwlat.c                         |  2 +-
 net/bridge/br_netfilter_hooks.c                    |  7 ++-
 net/core/skbuff.c                                  |  2 +-
 net/ipv4/route.c                                   |  7 +--
 net/ipv4/tcp_cong.c                                |  5 ++
 net/ipv6/addrlabel.c                               | 26 +++++----
 net/ipv6/ip6_gre.c                                 | 16 ++++--
 net/iucv/af_iucv.c                                 |  4 +-
 net/rose/rose_loopback.c                           | 17 ++++--
 net/tls/tls_device.c                               |  5 +-
 net/tls/tls_sw.c                                   |  6 +++
 net/x25/af_x25.c                                   |  6 ++-
 sound/usb/mixer_us16x08.c                          |  2 +-
 37 files changed, 266 insertions(+), 137 deletions(-)


