Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED6E64B802
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiLMPFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbiLMPFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:05:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE24A1BA;
        Tue, 13 Dec 2022 07:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F8BB81222;
        Tue, 13 Dec 2022 15:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34186C433D2;
        Tue, 13 Dec 2022 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670943911;
        bh=uHFDaDnlRmuH0TSPQDCBhwE0Av9oFHpEfsJGWlKcC/8=;
        h=From:To:Cc:Subject:Date:From;
        b=tU+YRPl3Oefx/1Igc/7EvRubpbiZ5EHoj8LFyAXwNjTGp+Z3GRnVaKfH1kn9XUZYI
         QyBkv8NzEZgYjozvKRXE8S4KeW9mIqNnKs5d0w44fpB9xxzO0cLhAezXSCoZtioKCb
         Kq/EpyhGqnotzQsNlPX7Lnc5Lb92W2uo1Eu94oho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/98] 5.10.159-rc2 review
Date:   Tue, 13 Dec 2022 16:05:08 +0100
Message-Id: <20221213150409.357752716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.159-rc2
X-KernelTest-Deadline: 2022-12-15T15:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.159 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.159-rc2

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Allow REC and TEC to return to zero

Emeel Hakim <ehakim@nvidia.com>
    macsec: add missing attribute validation for offload

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

Xin Long <lucien.xin@gmail.com>
    tipc: call tipc_lxc_xmit without holding node_read_lock

Zhengchao Shao <shaozhengchao@huawei.com>
    net: dsa: sja1105: fix memory leak in sja1105_setup_devlink_regions()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect route flushing when table ID 0 is used

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect route flushing when source address is deleted

YueHaibing <yuehaibing@huawei.com>
    tipc: Fix potential OOB in tipc_link_proto_rcv()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Liu Jian <liujian56@huawei.com>
    net: hisilicon: Fix potential use-after-free in hisi_femac_rx()

Yongqiang Liu <liuyongqiang13@huawei.com>
    net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq

Hangbin Liu <liuhangbin@gmail.com>
    ip_gre: do not report erspan version on GRE interface

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

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    net: dsa: ksz: Check return value

Chen Zhongjin <chenzhongjin@huawei.com>
    Bluetooth: Fix not cleanup led when bt_init fails

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()

Ronak Doshi <doshir@vmware.com>
    vmxnet3: correctly report encapsulated LRO packet

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Get user_ns from in_skb in unix_diag_get_exact().

Guillaume BRUN <the.cheaterman@gmail.com>
    drm: bridge: dw_hdmi: fix preference of RGB modes over YUV420

Akihiko Odaki <akihiko.odaki@daynix.com>
    igb: Allocate MSI-X vector when testing

Akihiko Odaki <akihiko.odaki@daynix.com>
    e1000e: Fix TX dispatch condition

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    gpio: amd8111: Fix PCI device reference count leak

Qiqi Zhang <eddy.zhang@rock-chips.com>
    drm/bridge: ti-sn65dsi86: Fix output polarity setting bug

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark

Hauke Mehrtens <hauke@hauke-m.de>
    ca8210: Fix crash by zero initializing data

Ziyang Xuan <william.xuanziyang@huawei.com>
    ieee802154: cc2520: Fix error return code in cc2520_hw_init()

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: mc146818-lib: fix signedness bug in mc146818_get_time()

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: fix locking in mc146818_set_time

Chris Wilson <chris@chris-wilson.co.uk>
    rtc: cmos: Disable irq around direct invocation of cmos_interrupt()

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page

Oliver Hartkopp <socketcan@hartkopp.net>
    can: af_can: fix NULL pointer dereference in can_rcv_filter

ZhangPeng <zhangpeng362@huawei.com>
    HID: core: fix shift-out-of-bounds in hid_report_raw_event

Anastasia Belova <abelova@astralinux.ru>
    HID: hid-lg4ff: Add check for empty lbuf

Ankit Patel <anpatel@nvidia.com>
    HID: usbhid: Add ALWAYS_POLL quirk for some mice

Rob Clark <robdclark@chromium.org>
    drm/shmem-helper: Avoid vm_open error paths

Rob Clark <robdclark@chromium.org>
    drm/shmem-helper: Remove errant put in error path

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Don't use screen objects when SEV is active

Thomas Huth <thuth@redhat.com>
    KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix crash when replugging CSR fake controllers

Ismael Ferreras Morezuelas <swyterzone@gmail.com>
    Bluetooth: btusb: Add debug message for CSR controllers

John Starks <jostarks@microsoft.com>
    mm/gup: fix gup_pud_range() for dax

Tejun Heo <tj@kernel.org>
    memcg: fix possible use-after-free in memcg_write_event_control()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Francesco Dolcini <francesco.dolcini@toradex.com>
    Revert "ARM: dts: imx7: Fix NAND controller size-cells"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videobuf2-core: take mmap_lock in vb2_get_unmapped_area()

Juergen Gross <jgross@suse.com>
    xen/netback: don't call kfree_skb() with interrupts disabled

Juergen Gross <jgross@suse.com>
    xen/netback: do some code cleanup

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/netback: Ensure protocol headers don't fall in the non-linear area

Thomas Gleixner <tglx@linutronix.de>
    rtc: mc146818: Reduce spinlock section in mc146818_set_time()

Xiaofei Tan <tanxiaofei@huawei.com>
    rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: avoid UIP when reading alarm time

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: avoid UIP when writing alarm time

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: extract mc146818_avoid_UIP

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: fix RTC presence check

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: Check return value from mc146818_get_time()

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: change return values of mc146818_get_time()

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: remove stale REVISIT comments

Thomas Gleixner <tglx@linutronix.de>
    rtc: mc146818: Dont test for bit 0-5 in Register D

Thomas Gleixner <tglx@linutronix.de>
    rtc: mc146818: Detect and handle broken RTCs

Thomas Gleixner <tglx@linutronix.de>
    rtc: mc146818: Prevent reading garbage

Jann Horn <jannh@google.com>
    mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths

Jann Horn <jannh@google.com>
    mm/khugepaged: fix GUP-fast interaction by sending IPI

Jann Horn <jannh@google.com>
    mm/khugepaged: take the right locks for page table retraction

Davide Tronchin <davide.tronchin.94@gmail.com>
    net: usb: qmi_wwan: add u-blox 0x1342 composition

Dominique Martinet <asmadeus@codewreck.org>
    9p/xen: check logical size for buffer size

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Disable GUSB2PHYCFG.SUSPHY for End Transfer

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbcon: Use kzalloc() in fbcon_prepare_logo()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl6030: fix get status of twl6032 regulators

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: soc-pcm: Add NULL check in BE reparenting

Filipe Manana <fdmanana@suse.com>
    btrfs: send: avoid unaligned encoded writes when attempting to clone range

Kees Cook <keescook@chromium.org>
    ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event

Konrad Dybcio <konrad.dybcio@linaro.org>
    regulator: slg51000: Wait after asserting CS pin

GUO Zihua <guozihua@huawei.com>
    9p/fd: Use P9_HDRSZ for header size

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188

Chancel Liu <chancel.liu@nxp.com>
    ASoC: wm8962: Wait for updated value of WM8962_CLOCKING1 register

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation

Tomislav Novak <tnovak@fb.com>
    ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: rk3188: fix lcdc1-rgb24 node name

Johan Jonker <jbx6244@gmail.com>
    arm64: dts: rockchip: fix ir-receiver node names

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: fix ir-receiver node names

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm: dts: rockchip: fix node name for hym8563 rtc

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/rtc.c                            |   7 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   4 +-
 arch/arm/boot/dts/rk3036-evb.dts                   |   2 +-
 arch/arm/boot/dts/rk3188-radxarock.dts             |   2 +-
 arch/arm/boot/dts/rk3188.dtsi                      |   3 +-
 arch/arm/boot/dts/rk3288-evb-act8846.dts           |   2 +-
 arch/arm/boot/dts/rk3288-firefly.dtsi              |   2 +-
 arch/arm/boot/dts/rk3288-miqi.dts                  |   2 +-
 arch/arm/boot/dts/rk3288-rock2-square.dts          |   2 +-
 arch/arm/boot/dts/rk3xxx.dtsi                      |   7 +
 arch/arm/include/asm/perf_event.h                  |   2 +-
 arch/arm/include/asm/pgtable-nommu.h               |   6 -
 arch/arm/include/asm/pgtable.h                     |  16 +-
 arch/arm/mm/nommu.c                                |  19 ++
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |   1 -
 arch/s390/kvm/vsie.c                               |   4 +-
 arch/x86/kernel/hpet.c                             |   8 +-
 drivers/base/power/trace.c                         |   6 +-
 drivers/bluetooth/btusb.c                          |   5 +
 drivers/gpio/gpio-amd8111.c                        |   4 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   6 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  18 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |   4 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-lg4ff.c                            |   6 +
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/media/common/videobuf2/videobuf2-core.c    | 102 ++++++---
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  20 +-
 drivers/net/can/usb/esd_usb2.c                     |   6 +
 drivers/net/dsa/sja1105/sja1105_devlink.c          |   2 +
 drivers/net/ethernet/aeroflex/greth.c              |   1 +
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   4 +-
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
 drivers/net/macsec.c                               |   1 +
 drivers/net/plip/plip.c                            |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  11 +-
 drivers/net/xen-netback/common.h                   |  14 +-
 drivers/net/xen-netback/interface.c                |  22 +-
 drivers/net/xen-netback/netback.c                  | 229 ++++++++++++---------
 drivers/net/xen-netback/rx.c                       |  10 +-
 drivers/net/xen-netfront.c                         |   6 +
 drivers/nvme/host/core.c                           |   8 +-
 drivers/regulator/slg51000-regulator.c             |   2 +
 drivers/regulator/twl6030-regulator.c              |  15 +-
 drivers/rtc/rtc-cmos.c                             | 209 ++++++++++++-------
 drivers/rtc/rtc-mc146818-lib.c                     | 169 ++++++++++++---
 drivers/usb/dwc3/gadget.c                          |   3 +-
 drivers/video/fbdev/core/fbcon.c                   |   2 +-
 fs/btrfs/send.c                                    |  24 ++-
 include/asm-generic/tlb.h                          |   4 +
 include/linux/cgroup.h                             |   1 +
 include/linux/hugetlb.h                            |   8 +-
 include/linux/mc146818rtc.h                        |   6 +-
 kernel/cgroup/cgroup-internal.h                    |   1 -
 mm/gup.c                                           |  16 +-
 mm/hugetlb.c                                       |  27 ++-
 mm/khugepaged.c                                    |  47 ++++-
 mm/memcontrol.c                                    |  15 +-
 mm/mmu_gather.c                                    |   4 +-
 net/9p/trans_fd.c                                  |   6 +-
 net/9p/trans_xen.c                                 |   9 +
 net/bluetooth/6lowpan.c                            |   1 +
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/bluetooth/hci_core.c                           |   3 +-
 net/can/af_can.c                                   |   4 +-
 net/dsa/tag_ksz.c                                  |   3 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/fib_semantics.c                           |   1 +
 net/ipv4/ip_gre.c                                  |  48 +++--
 net/ipv6/ip6_output.c                              |   5 +
 net/mac802154/iface.c                              |   1 +
 net/netfilter/nf_conntrack_netlink.c               |  19 +-
 net/netfilter/nft_set_pipapo.c                     |   5 +-
 net/nfc/nci/ntf.c                                  |   6 +
 net/tipc/link.c                                    |   4 +-
 net/tipc/node.c                                    |  12 +-
 net/unix/diag.c                                    |  20 +-
 sound/core/seq/seq_memory.c                        |  11 +-
 sound/soc/codecs/wm8962.c                          |   8 +
 sound/soc/soc-pcm.c                                |   2 +
 tools/testing/selftests/net/fib_tests.sh           |  37 ++++
 tools/testing/selftests/net/rtnetlink.sh           |   2 +-
 98 files changed, 982 insertions(+), 438 deletions(-)


