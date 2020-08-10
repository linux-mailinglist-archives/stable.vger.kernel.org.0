Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA69240A99
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgHJPmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgHJPWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:22:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 616E120734;
        Mon, 10 Aug 2020 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072936;
        bh=B6bozhvUBDJolruNaMWXoKiwZyY4vj4ICpWJvuGbSK4=;
        h=From:To:Cc:Subject:Date:From;
        b=dpH34I8LIW6psrTscqx884hL2cx3IdbiDjzDj4kgjkZwKZKjOrDEuYdEESWnd9yfD
         rgO+9+qBhSFfIubfbo2y+41e14FCNSSDShqL6tfzrzG0PnYxBUAsiVw+gzGaZ/c9EB
         eOg2WaL40V4GLUmIRYsNEp/r511/QqQ+qfI84GrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 00/79] 5.7.15-rc1 review
Date:   Mon, 10 Aug 2020 17:20:19 +0200
Message-Id: <20200810151812.114485777@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.15-rc1
X-KernelTest-Deadline: 2020-08-12T15:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.15 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.15-rc1

Guenter Roeck <linux@roeck-us.net>
    arm64: kaslr: Use standard early random function

Bruno Meneguele <bmeneg@redhat.com>
    ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix bogus sendmsg() return code under pressure

Paolo Abeni <pabeni@redhat.com>
    mptcp: be careful on subflow creation

Jianfeng Wang <jfwang@google.com>
    tcp: apply a floor of 1 for RTT samples from TCP timestamps

Willem de Bruijn <willemb@google.com>
    selftests/net: relax cpu affinity requirement in msg_zerocopy test

Hangbin Liu <liuhangbin@gmail.com>
    Revert "vxlan: fix tos value before xmit"

Peilin Ye <yepeilin.cs@gmail.com>
    openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()

Xin Long <lucien.xin@gmail.com>
    net: thunderx: use spin_lock_bh in nicvf_set_rx_mode_task()

wenxu <wenxu@ucloud.cn>
    net/sched: act_ct: fix miss set mru for ovs after defrag in act_ct

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvpp2: fix memory leak in mvpp2_rx

Stefan Roese <sr@denx.de>
    net: macb: Properly handle phylink on at91sam9x

Lorenzo Bianconi <lorenzo@kernel.org>
    net: gre: recompute gre csum for sctp over gre tunnels

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: clear bridge's private skb space on xmit

Stephen Hemminger <stephen@networkplumber.org>
    hv_netvsc: do not use VF device if link is down

YueHaibing <yuehaibing@huawei.com>
    dpaa2-eth: Fix passing zero to 'PTR_ERR' warning

Vincent Duvert <vincent.ldev@duvert.net>
    appletalk: Fix atalk_proc_init() return path

Jakub Kicinski <kuba@kernel.org>
    devlink: ignore -EOPNOTSUPP errors on dumpit

Herbert Xu <herbert@gondor.apana.org.au>
    rhashtable: Restore RCU marking on rhash_lock_head

Johan Hovold <johan@kernel.org>
    net: lan78xx: replace bogus endpoint lookup

Ido Schimmel <idosch@mellanox.com>
    vxlan: Ensure FDB dump is performed under RCU

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between recvmsg and sendmsg on immediate call failure

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ipv6: Fix nexthop refcnt leak when creating ipv6 route info

Cong Wang <xiyou.wangcong@gmail.com>
    ipv6: fix memory leaks on IPV6_ADDRFORM path

Ido Schimmel <idosch@mellanox.com>
    ipv4: Silence suspicious RCU usage warning

Nicolas Chauvet <kwizart@gmail.com>
    PCI: tegra: Revert tegra124 raw_violation_fixup

Christophe Leroy <christophe.leroy@csgroup.eu>
    Revert "powerpc/kasan: Fix shadow pages allocation failure"

Frank van der Linden <fllinden@amazon.com>
    xattr: break delegations in {set,remove}xattr

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

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ALSA: hda: fix NULL pointer dereference during suspend

René van Dorst <opensource@vdorst.com>
    net: ethernet: mtk_eth_soc: Always call mtk_gmac0_rgmii_adjust() for mt7623

Rustam Kovhaev <rkovhaev@gmail.com>
    usb: hso: check for return value in hso_serial_common_create()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: add sanity check when unregistering

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: slave: improve sanity check when registering

laurent brando <laurent.brando@nxp.com>
    net: mscc: ocelot: fix hardware timestamp dequeue logic

Sam Ravnborg <sam@ravnborg.org>
    drm/drm_fb_helper: fix fbdev with sparc64

Jitao Shi <jitao.shi@mediatek.com>
    drm/panel: Fix auo, kd101n80-45na horizontal noise on edges of panel

Laurentiu Palcu <laurentiu.palcu@nxp.com>
    drm/bridge/adv7511: set the bridge type properly

Kai-Heng Feng <kai.heng.feng@canonical.com>
    nvme-pci: prevent SK hynix PC400 from using Write Zeroes command

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix lockup in io_fail_links()

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: zero-initialise the mode_cmd2 structure

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/fbcon: fix module unload when fbcon init has failed for some reason

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/tu102: wait for core update to complete when assigning windows

Christoph Hellwig <hch@lst.de>
    net/9p: validate fds in p9_fd_open

Peilin Ye <yepeilin.cs@gmail.com>
    bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()

Dmitry Osipenko <digetx@gmail.com>
    gpio: max77620: Fix missing release of interrupt

Johan Hovold <johan@kernel.org>
    leds: 88pm860x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm3533: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: da903x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm36274: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: wm831x-status: fix use-after-free on unbind

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: properly check all write ioctls for permissions

Yunhai Zhang <zhangyunhai@nsfocus.com>
    vgacon: Fix for missing check in scrollback handling

Kees Cook <keescook@chromium.org>
    lkdtm/heap: Avoid edge and middle of slabs

Matthias Maennich <maennich@google.com>
    scripts: add dummy report mode to add_namespace.cocci

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

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

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: rtl8712: handle firmware load failure

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Fix AE-5 microphone selection commands.

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Add new quirk ID for Recon3D.

Huacai Chen <chenhc@lemote.com>
    ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops

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

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix and simplify setup_xfer_req variant operation


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm64/kernel/kaslr.c                        |  12 +--
 arch/powerpc/include/asm/kasan.h                 |   2 +
 arch/powerpc/mm/init_32.c                        |   2 +
 arch/powerpc/mm/kasan/kasan_init_32.c            |   4 +-
 drivers/android/binder.c                         |  15 ++-
 drivers/atm/atmtcp.c                             |  10 +-
 drivers/firmware/qemu_fw_cfg.c                   |   7 +-
 drivers/gpio/gpio-max77620.c                     |   5 +-
 drivers/gpu/drm/bochs/bochs_kms.c                |   1 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c     |   1 +
 drivers/gpu/drm/drm_fb_helper.c                  |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c          |   2 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c          |   3 +-
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c   |   6 +-
 drivers/i2c/i2c-core-slave.c                     |   7 +-
 drivers/leds/leds-88pm860x.c                     |  14 ++-
 drivers/leds/leds-da903x.c                       |  14 ++-
 drivers/leds/leds-lm3533.c                       |  12 ++-
 drivers/leds/leds-lm36274.c                      |  15 ++-
 drivers/leds/leds-wm831x-status.c                |  14 ++-
 drivers/misc/lkdtm/heap.c                        |   9 +-
 drivers/mtd/mtdchar.c                            |  56 +++++++++--
 drivers/net/ethernet/cadence/macb_main.c         |  11 ++-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c        |   9 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c      |  19 +++-
 drivers/net/ethernet/mscc/ocelot.c               |  10 +-
 drivers/net/hyperv/netvsc_drv.c                  |   7 +-
 drivers/net/usb/hso.c                            |   5 +-
 drivers/net/usb/lan78xx.c                        | 117 ++++++-----------------
 drivers/net/vxlan.c                              |  10 +-
 drivers/nvme/host/pci.c                          |   2 +
 drivers/pci/controller/pci-tegra.c               |  32 -------
 drivers/scsi/ufs/ufshcd.c                        |   9 +-
 drivers/staging/android/ashmem.c                 |  12 +++
 drivers/staging/rtl8188eu/core/rtw_mlme.c        |   4 +-
 drivers/staging/rtl8712/hal_init.c               |   3 +-
 drivers/staging/rtl8712/usb_intf.c               |  11 ++-
 drivers/usb/host/xhci-pci.c                      |  10 +-
 drivers/usb/misc/iowarrior.c                     |  35 +++++--
 drivers/usb/serial/qcserial.c                    |   1 +
 drivers/video/console/vgacon.c                   |   4 +
 drivers/video/fbdev/omap2/omapfb/dss/dss.c       |   2 +-
 fs/io_uring.c                                    |   3 +-
 fs/xattr.c                                       |  84 ++++++++++++++--
 include/drm/drm_mode_config.h                    |  12 +++
 include/linux/rhashtable.h                       |  56 +++++------
 include/linux/skbuff.h                           |   1 +
 include/linux/xattr.h                            |   2 +
 include/net/addrconf.h                           |   1 +
 include/net/sch_generic.h                        |   3 +-
 kernel/bpf/btf.c                                 |   5 +
 lib/rhashtable.c                                 |  35 ++++---
 net/9p/trans_fd.c                                |  24 +++--
 net/appletalk/atalk_proc.c                       |   2 +
 net/bluetooth/hci_event.c                        |  11 ++-
 net/bridge/br_device.c                           |   2 +
 net/core/devlink.c                               |  24 +++--
 net/ipv4/fib_trie.c                              |   2 +-
 net/ipv4/gre_offload.c                           |  13 ++-
 net/ipv4/tcp_input.c                             |   2 +
 net/ipv6/anycast.c                               |  17 +++-
 net/ipv6/ipv6_sockglue.c                         |   1 +
 net/ipv6/route.c                                 |   8 +-
 net/mptcp/protocol.c                             |   3 +-
 net/mptcp/subflow.c                              |   6 ++
 net/openvswitch/conntrack.c                      |  38 ++++----
 net/openvswitch/flow.c                           |   1 +
 net/rxrpc/call_object.c                          |  27 ++++--
 net/rxrpc/conn_object.c                          |   8 +-
 net/rxrpc/recvmsg.c                              |   2 +-
 net/rxrpc/sendmsg.c                              |   3 +
 net/sched/act_ct.c                               |   8 +-
 net/sched/cls_api.c                              |   1 +
 net/wireless/nl80211.c                           |   6 +-
 scripts/coccinelle/misc/add_namespace.cocci      |   8 +-
 scripts/nsdeps                                   |   2 +-
 security/integrity/ima/Kconfig                   |   2 +-
 security/integrity/ima/ima_appraise.c            |   6 ++
 security/smack/smackfs.c                         |  13 ++-
 sound/core/seq/oss/seq_oss.c                     |   8 +-
 sound/pci/hda/hda_codec.c                        |   8 ++
 sound/pci/hda/hda_intel.c                        |   1 -
 sound/pci/hda/patch_ca0132.c                     |  12 ++-
 sound/pci/hda/patch_realtek.c                    | 114 ++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c               |   1 +
 tools/testing/selftests/net/msg_zerocopy.c       |   5 +-
 90 files changed, 778 insertions(+), 358 deletions(-)


