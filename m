Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9835C64A21F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiLLNt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiLLNtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:49:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2042BD8;
        Mon, 12 Dec 2022 05:49:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9AC23CE0F42;
        Mon, 12 Dec 2022 13:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6590C433D2;
        Mon, 12 Dec 2022 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852938;
        bh=BuJk6UyNnNCckqSDUSKJw6gF+0b074c/0qtS4svMH1U=;
        h=From:To:Cc:Subject:Date:From;
        b=njaBzt9/7HUEhLUTtEeD6EijOf0rTsiIgn87WwObCzj57y51ow+5mYF3e7eUMznU+
         MAKisB4WG5WfmEOxi1/cP3l7o9aELAne4DpSbvSHm0qJMetehJiJ/vLfou0bQsNIV1
         SSA6RSd7+YrZd23t7fzHTl8bJFD+w71yAFUgqXrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/49] 4.19.269-rc1 review
Date:   Mon, 12 Dec 2022 14:18:38 +0100
Message-Id: <20221212130913.666185567@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.269-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.269-rc1
X-KernelTest-Deadline: 2022-12-14T13:09+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.269 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.269-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.269-rc1

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Allow REC and TEC to return to zero

Dan Carpenter <error27@gmail.com>
    net: mvneta: Fix an out of bounds check

Eric Dumazet <edumazet@google.com>
    ipv6: avoid use-after-free in ip6_fragment()

Yang Yingliang <yangyingliang@huawei.com>
    net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

Juergen Gross <jgross@suse.com>
    xen/netback: fix build warning

Zhang Changzhong <zhangchangzhong@huawei.com>
    ethernet: aeroflex: fix potential skb leak in greth_init_rings()

YueHaibing <yuehaibing@huawei.com>
    tipc: Fix potential OOB in tipc_link_proto_rcv()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hisi_femac_rx()

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: fix "snps,axi-config" node property parsing

Pankaj Raghav <p.raghav@samsung.com>
    nvme initialize core quirks before calling nvme_init_subsystem

Kees Cook <keescook@chromium.org>
    NFC: nci: Bounds check struct nfc_target arrays

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    i40e: Disallow ip4 and ip6 l4_4_bytes

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix for VF MAC address 0

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix not setting default xps_cpus after reset

Dan Carpenter <error27@gmail.com>
    net: mvneta: Prevent out of bounds read in mvneta_config_rss()

Lin Liu <lin.liu@citrix.com>
    xen-netfront: Fix NULL sring after live migration

Valentina Goncharenko <goncharenko.vp@ispras.ru>
    net: encx24j600: Fix invalid logic in reading of MISTAT register

Valentina Goncharenko <goncharenko.vp@ispras.ru>
    net: encx24j600: Add parentheses to fix precedence

Wei Yongjun <weiyongjun1@huawei.com>
    mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Zhengchao Shao <shaozhengchao@huawei.com>
    selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload

Chen Zhongjin <chenzhongjin@huawei.com>
    Bluetooth: Fix not cleanup led when bt_init fails

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()

Akihiko Odaki <akihiko.odaki@daynix.com>
    igb: Allocate MSI-X vector when testing

Akihiko Odaki <akihiko.odaki@daynix.com>
    e1000e: Fix TX dispatch condition

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    gpio: amd8111: Fix PCI device reference count leak

Hauke Mehrtens <hauke@hauke-m.de>
    ca8210: Fix crash by zero initializing data

Ziyang Xuan <william.xuanziyang@huawei.com>
    ieee802154: cc2520: Fix error return code in cc2520_hw_init()

ZhangPeng <zhangpeng362@huawei.com>
    HID: core: fix shift-out-of-bounds in hid_report_raw_event

Anastasia Belova <abelova@astralinux.ru>
    HID: hid-lg4ff: Add check for empty lbuf

Thomas Huth <thuth@redhat.com>
    KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

Tejun Heo <tj@kernel.org>
    memcg: fix possible use-after-free in memcg_write_event_control()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Connor Shu <Connor.Shu@ibm.com>
    rcutorture: Automatically create initrd directory

Juergen Gross <jgross@suse.com>
    xen/netback: don't call kfree_skb() with interrupts disabled

Juergen Gross <jgross@suse.com>
    xen/netback: do some code cleanup

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/netback: Ensure protocol headers don't fall in the non-linear area

Davide Tronchin <davide.tronchin.94@gmail.com>
    net: usb: qmi_wwan: add u-blox 0x1342 composition

Dominique Martinet <asmadeus@codewreck.org>
    9p/xen: check logical size for buffer size

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbcon: Use kzalloc() in fbcon_prepare_logo()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl6030: fix get status of twl6032 regulators

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: soc-pcm: Add NULL check in BE reparenting

Kees Cook <keescook@chromium.org>
    ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event

GUO Zihua <guozihua@huawei.com>
    9p/fd: Use P9_HDRSZ for header size

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation

Tomislav Novak <tnovak@fb.com>
    ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix ir-receiver node names

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm: dts: rockchip: fix node name for hym8563 rtc


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3036-evb.dts                   |   2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts             |   2 +-
 arch/arm/boot/dts/rk3188.dtsi                      |   1 -
 arch/arm/boot/dts/rk3288-evb-act8846.dts           |   2 +-
 arch/arm/boot/dts/rk3288-firefly.dtsi              |   2 +-
 arch/arm/boot/dts/rk3288-miqi.dts                  |   2 +-
 arch/arm/boot/dts/rk3288-rock2-square.dts          |   2 +-
 arch/arm/boot/dts/rk3xxx.dtsi                      |   7 +
 arch/arm/include/asm/perf_event.h                  |   2 +-
 arch/arm/include/asm/pgtable-nommu.h               |   6 -
 arch/arm/include/asm/pgtable.h                     |  16 +-
 arch/arm/mm/nommu.c                                |  19 ++
 arch/s390/kvm/vsie.c                               |   4 +-
 drivers/gpio/gpio-amd8111.c                        |   4 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-lg4ff.c                            |   6 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  20 +-
 drivers/net/can/usb/esd_usb2.c                     |   6 +
 drivers/net/ethernet/aeroflex/greth.c              |   1 +
 drivers/net/ethernet/hisilicon/hisi_femac.c        |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  19 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   2 +
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/ieee802154/cc2520.c                    |   2 +-
 drivers/net/plip/plip.c                            |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/xen-netback/common.h                   |  14 +-
 drivers/net/xen-netback/interface.c                |  22 +-
 drivers/net/xen-netback/netback.c                  | 229 ++++++++++++---------
 drivers/net/xen-netback/rx.c                       |  10 +-
 drivers/net/xen-netfront.c                         |   6 +
 drivers/nvme/host/core.c                           |   8 +-
 drivers/regulator/twl6030-regulator.c              |  15 +-
 drivers/video/fbdev/core/fbcon.c                   |   2 +-
 include/linux/cgroup.h                             |   1 +
 kernel/cgroup/cgroup-internal.h                    |   1 -
 mm/memcontrol.c                                    |  15 +-
 net/9p/trans_fd.c                                  |   6 +-
 net/9p/trans_xen.c                                 |   9 +
 net/bluetooth/6lowpan.c                            |   1 +
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/ipv6/ip6_output.c                              |   5 +
 net/mac802154/iface.c                              |   1 +
 net/nfc/nci/ntf.c                                  |   6 +
 net/tipc/link.c                                    |   4 +-
 sound/core/seq/seq_memory.c                        |  11 +-
 sound/soc/soc-pcm.c                                |   2 +
 tools/testing/selftests/net/rtnetlink.sh           |   2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   8 +
 tools/testing/selftests/rcutorture/bin/mkinitrd.sh |  60 ++++++
 58 files changed, 404 insertions(+), 209 deletions(-)


