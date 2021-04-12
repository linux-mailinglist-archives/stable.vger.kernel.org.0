Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4B935BCFF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbhDLIqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237659AbhDLIqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F7561247;
        Mon, 12 Apr 2021 08:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217142;
        bh=tSHe2ed/XSlL9RWyRn41TYc+HzwZnGwRY5TL9IqcwJw=;
        h=From:To:Cc:Subject:Date:From;
        b=neJAjzQxtPUtAm8+rnQKJrbLCoSJIb51foMUa8AWvyqaEY3Zs1OdvPeC5FZVjjZsJ
         Guk1s4SKLncmp4mqpP1N1lIQIboIW3bZGU40xeAUk0pLWyyx4EOlssZCw1YeP7I0Hz
         8cL4MSm0sSjli2JdT7secKsJw1Kdzj5eCzcdRydM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/111] 5.4.112-rc1 review
Date:   Mon, 12 Apr 2021 10:39:38 +0200
Message-Id: <20210412084004.200986670@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.112-rc1
X-KernelTest-Deadline: 2021-04-14T08:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.112 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.112-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec params for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for del llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for set llsec params

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 add llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: fix nl802154 del llsec key

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: nl-mac: fix check on panid

Pavel Skripkin <paskripkin@gmail.com>
    net: mac802154: Fix general protection fault

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in peak_usb_create_dev

Pavel Skripkin <paskripkin@gmail.com>
    drivers: net: fix memory leak in atusb_probe

Phillip Potter <phil@philpotter.co.uk>
    net: tun: set tun->dev->addr_len during TUNSETLINK processing

Du Cheng <ducheng2@gmail.com>
    cfg80211: remove WARN_ON() in cfg80211_sme_connect

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    net: sched: bump refcount for new action in ACT replace mode

Rafał Miłecki <rafal@milecki.pl>
    dt-bindings: net: ethernet-controller: fix typo in NVMEM

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    clk: socfpga: fix iomem pointer cast on 64-bit

William Roche <william.roche@oracle.com>
    RAS/CEC: Correct ce_add_elem()'s returned values

Leon Romanovsky <leonro@nvidia.com>
    RDMA/addr: Be strict with gid size

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: check for ipv6 address properly while destroying listener

Aya Levin <ayal@nvidia.com>
    net/mlx5: Fix PBMC register mapping

Raed Salem <raeds@nvidia.com>
    net/mlx5: Fix placement of log_max_flow_counter

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: clear VF down state bit before request link status

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix send of uninitialized stack memory in ct limit reply

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()

Adrian Hunter <adrian.hunter@intel.com>
    perf inject: Fix repipe usage

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpcmd: fix inline assembly register clobbering

Zqiang <qiang.zhang@windriver.com>
    workqueue: Move the position of debug_work_activate() in __queue_work()

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in unregister

Lukasz Bartosik <lb@semihalf.com>
    clk: fix invalid usage of list cursor in register

Claudiu Beznea <claudiu.beznea@microchip.com>
    net: macb: restore cmp registers on resume path

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs

Can Guo <cang@codeaurora.org>
    scsi: ufs: core: Fix task management request completion timeout

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Avoid busy-waiting by eliminating tag conflicts

Venkat Gopalakrishnan <venkatg@codeaurora.org>
    scsi: ufs: Fix irq return code

Norman Maurer <norman_maurer@apple.com>
    net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);

Stephen Boyd <swboyd@chromium.org>
    drm/msm: Set drvdata to NULL when msm_drm_init() fails

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix display statistics for veb_tc

Arnd Bergmann <arnd@arndb.de>
    soc/fsl: qbman: fix conflicting alignment attributes

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net/rds: Fix a use after free in rds_message_map_pages

Daniel Jurgens <danielj@mellanox.com>
    net/mlx5: Don't request more than supported EQs

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix ethtool indication of connector type

Bastian Germann <bage@linutronix.de>
    ASoC: sunxi: sun4i-codec: fill ASoC card owner

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Only advertise EEE for supported modes

Yinjun Zhang <yinjun.zhang@corigine.com>
    nfp: flower: ignore duplicate merge hints from FW

Milton Miller <miltonm@us.ibm.com>
    net/ncsi: Avoid channel_monitor hrtimer deadlock

Stefan Riedmueller <s.riedmueller@phytec.de>
    ARM: dts: imx6: pbab01: Set vmmc supply for both SD interfaces

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:tipc: Fix a double free in tipc_sk_mcast_rcv

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: avoid collecting SGE_QBASE regs during traffic

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Handle error code at MAC address change

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE

Oliver Stäbler <oliver.staebler@bytesatwork.ch>
    arm64: dts: imx8mm/q: Fix pad control of SD1_DATA0

Eric Dumazet <edumazet@google.com>
    sch_red: fix off-by-one checks in red_check_params()

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    amd-xgbe: Update DMA coherency values

Al Viro <viro@zeniv.linux.org.uk>
    hostfs: fix memory handling in follow_link()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hostfs: Use kasprintf() instead of fixed buffer formatting

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix kernel oops when i40e driver removes VF's

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Added Asym_Pause to supported link modes

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix NULL pointer dereference on policy lookup

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Fix wrong bclk and lrclk with pll enabled for some chips

Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
    ASoC: SOF: Intel: HDA: fix core status verification

Payal Kshirsagar <payalskshirsagar1234@gmail.com>
    ASoC: SOF: Intel: hda: remove unnecessary parentheses

Xin Long <lucien.xin@gmail.com>
    esp: delete NETIF_F_SCTP_CRC bit from features for esp offload

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: xfrm: Localize sequence counter per network namespace

Geert Uytterhoeven <geert+renesas@glider.be>
    regulator: bd9571mwv: Fix AVS and DVFS voltage range

Eyal Birger <eyal.birger@gmail.com>
    xfrm: interface: fix ipv4 pmtu check to honor ip header df

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Don't use PHY auto polling

Eric Dumazet <edumazet@google.com>
    virtio_net: Do not pull payload in skb->head

Yuya Kusakabe <yuya.kusakabe@gmail.com>
    virtio_net: Add XDP meta data support

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: turn recovery error on init to debug

Shuah Khan <skhan@linuxfoundation.org>
    usbip: synchronize event handler with sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: vudc synchronize sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: stub-dev synchronize sysfs code paths

Shuah Khan <skhan@linuxfoundation.org>
    usbip: add sysfs_lock to synchronize sysfs code paths

Paolo Abeni <pabeni@redhat.com>
    net: let skb_orphan_partial wake-up waiters.

Maciej Żenczykowski <maze@google.com>
    net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()

Kurt Kanzenbach <kurt@linutronix.de>
    net: hsr: Reset MAC header for Tx path

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix TXQ AC confusion

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    net: sched: sch_teql: fix null-pointer dereference

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse error: 'vsi->netdev' could be null

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    i40e: Fix sparse warning: missing error code 'err'

Eric Dumazet <edumazet@google.com>
    net: ensure mac header is set in virtio_net_hdr_to_skb()

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix sk->prot unhash op reset

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ethernet/netronome/nfp: Fix a use after free in nfp_bpf_ctrl_msg_rx

Anirudh Rayabharam <mail@anirudhrb.com>
    net: hso: fix null-ptr-deref during tty device unregistration

Robert Malz <robertx.malz@intel.com>
    ice: Cleanup fltr list in case of allocation issues

Jacek Bułatek <jacekx.bulatek@intel.com>
    ice: Fix for dereference of NULL pointer

Fabio Pricoco <fabio.pricoco@intel.com>
    ice: Increase control queue timeout

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field

Marek Behún <kabel@kernel.org>
    ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin

Gao Xiang <hsiangkao@redhat.com>
    parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers

Helge Deller <deller@gmx.de>
    parisc: parisc-agp requires SBA IOMMU driver

Jack Qiu <jack.qiu@huawei.com>
    fs: direct-io: fix missing sdio->boundary

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: fix deadlock between setattr and dio_end_io_write

Mike Rapoport <rppt@linux.ibm.com>
    nds32: flush_dcache_page: use page_mapping_file to avoid races with swapoff

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix user_stack_pointer() for ptrace()

Nick Desaulniers <ndesaulniers@google.com>
    gcov: re-fix clang-11+ support

Takashi Iwai <tiwai@suse.de>
    drm/i915: Fix invalid access to ACPI _DSM objects

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock

Muhammad Usama Anjum <musamaanjum@gmail.com>
    net: ipv6: check for validity before dereferencing cfg->fc_nlinfo.nlh

Luca Fancellu <luca.fancellu@arm.com>
    xen/evtchn: Change irq_info lock to raw_spinlock_t

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: Avoid endless loops caused by repeated llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix memory leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_connect()

Xiaoming Ni <nixiaoming@huawei.com>
    nfc: fix refcount leak in llcp_sock_bind()

Hans de Goede <hdegoede@redhat.com>
    ASoC: intel: atom: Stop advertising non working S24LE support

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix speaker amp setup on Acer Aspire E1

Jonas Holmberg <jonashg@axis.com>
    ALSA: aloop: Fix initialization of controls

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register


-------------

Diffstat:

 .../bindings/net/ethernet-controller.yaml          |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |   1 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |   2 +
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq-pinfunc.h     |   2 +-
 arch/ia64/include/asm/ptrace.h                     |   8 +-
 arch/nds32/mm/cacheflush.c                         |   2 +-
 arch/parisc/include/asm/cmpxchg.h                  |   2 +-
 arch/s390/kernel/cpcmd.c                           |   6 +-
 drivers/char/agp/Kconfig                           |   2 +-
 drivers/clk/clk.c                                  |  47 ++-
 drivers/clk/socfpga/clk-gate.c                     |   2 +-
 drivers/counter/stm32-timer-cnt.c                  |  12 +-
 drivers/gpu/drm/i915/display/intel_acpi.c          |  22 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/i2c/i2c-core-base.c                        |   7 +-
 drivers/infiniband/core/addr.c                     |   4 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   6 +-
 drivers/net/dsa/lantiq_gswip.c                     | 196 ++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   6 +-
 drivers/net/ethernet/cadence/macb_main.c           |   7 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  23 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |   6 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  53 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   9 +
 drivers/net/ethernet/intel/ice/ice_controlq.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  13 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   8 +
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  16 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  48 ++-
 drivers/net/ieee802154/atusb.c                     |   1 +
 drivers/net/phy/bcm-phy-lib.c                      |  13 +-
 drivers/net/tun.c                                  |  48 +++
 drivers/net/usb/hso.c                              |  33 +-
 drivers/net/virtio_net.c                           |  62 ++--
 drivers/ras/cec.c                                  |  15 +-
 drivers/regulator/bd9571mwv-regulator.c            |   4 +-
 drivers/scsi/ufs/ufshcd.c                          | 398 ++++++++++++---------
 drivers/scsi/ufs/ufshcd.h                          |  18 +-
 drivers/scsi/ufs/ufshci.h                          |   2 +-
 drivers/soc/fsl/qbman/qman.c                       |   2 +-
 drivers/usb/usbip/stub_dev.c                       |  11 +-
 drivers/usb/usbip/usbip_common.h                   |   3 +
 drivers/usb/usbip/usbip_event.c                    |   2 +
 drivers/usb/usbip/vhci_hcd.c                       |   1 +
 drivers/usb/usbip/vhci_sysfs.c                     |  30 +-
 drivers/usb/usbip/vudc_dev.c                       |   1 +
 drivers/usb/usbip/vudc_sysfs.c                     |   5 +
 drivers/xen/events/events_base.c                   |  10 +-
 drivers/xen/events/events_internal.h               |   2 +-
 fs/cifs/connect.c                                  |   1 -
 fs/direct-io.c                                     |   5 +-
 fs/hostfs/hostfs_kern.c                            |  19 +-
 fs/ocfs2/aops.c                                    |  11 +-
 fs/ocfs2/file.c                                    |   8 +-
 include/linux/mlx5/mlx5_ifc.h                      |   8 +-
 include/linux/skmsg.h                              |   8 +-
 include/linux/virtio_net.h                         |  16 +-
 include/net/netns/xfrm.h                           |   4 +-
 include/net/red.h                                  |   4 +-
 include/net/sock.h                                 |   9 +
 include/net/xfrm.h                                 |   2 +-
 kernel/gcov/clang.c                                |  29 +-
 kernel/workqueue.c                                 |   2 +-
 net/batman-adv/translation-table.c                 |   2 +
 net/can/bcm.c                                      |  10 +-
 net/can/raw.c                                      |  14 +-
 net/core/sock.c                                    |  12 +-
 net/hsr/hsr_device.c                               |   1 +
 net/hsr/hsr_forward.c                              |   6 -
 net/ieee802154/nl-mac.c                            |   7 +-
 net/ieee802154/nl802154.c                          |  23 +-
 net/ipv4/esp4_offload.c                            |   6 +-
 net/ipv4/udp.c                                     |   4 +
 net/ipv6/esp6_offload.c                            |   6 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |   8 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac802154/llsec.c                              |   2 +-
 net/ncsi/ncsi-manage.c                             |  20 +-
 net/nfc/llcp_sock.c                                |  10 +
 net/openvswitch/conntrack.c                        |  14 +-
 net/rds/message.c                                  |   3 +-
 net/sched/act_api.c                                |   3 +
 net/sched/sch_teql.c                               |   3 +
 net/sctp/ipv6.c                                    |   7 +-
 net/tipc/socket.c                                  |   2 +-
 net/wireless/sme.c                                 |   2 +-
 net/xfrm/xfrm_interface.c                          |   3 +
 net/xfrm/xfrm_state.c                              |  10 +-
 sound/drivers/aloop.c                              |  11 +-
 sound/pci/hda/patch_realtek.c                      |  16 +
 sound/soc/codecs/wm8960.c                          |   8 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   6 +-
 sound/soc/sof/intel/hda-dsp.c                      |  15 +-
 sound/soc/sunxi/sun4i-codec.c                      |   5 +
 tools/perf/builtin-inject.c                        |   2 +-
 106 files changed, 1104 insertions(+), 511 deletions(-)


