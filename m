Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384416159F7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiKBDWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKBDVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FE25C72;
        Tue,  1 Nov 2022 20:21:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CB061729;
        Wed,  2 Nov 2022 03:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C30C433C1;
        Wed,  2 Nov 2022 03:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359295;
        bh=OYzpxmX0dk5QIF/zWcNloYxs3KNUb9iY8g+TtXuxYDc=;
        h=From:To:Cc:Subject:Date:From;
        b=gWPejywZQEFwBf1/1HXMHtzLGh0WimDno6ii0Awaidy68EX3C+FpO2iAXKFl/iHrF
         2RhRQ5TZkhi8tI+i06MvLV4Szl+XFq6FLzOB5cpNd/EnxWC3aMf89koBm3aR0nDs6A
         //ilFRG9G+t335VDE0DLTez7NjwAFRrH7RgiIR0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.4 00/64] 5.4.223-rc1 review
Date:   Wed,  2 Nov 2022 03:33:26 +0100
Message-Id: <20221102022051.821538553@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.223-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.223-rc1
X-KernelTest-Deadline: 2022-11-04T02:20+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.223 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.223-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.223-rc1

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: survive memory pressure without crashing

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5: Fix possible use-after-free in async command interface

Hyong Youb Kim <hyonkim@cisco.com>
    net/mlx5e: Do not increment ESN when updating IPsec ESN state

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    nh: fix scope used to find saddr when adding non gw nh

Yang Yingliang <yangyingliang@huawei.com>
    net: ehea: fix possible memory leak in ehea_register_port()

Aaron Conole <aconole@redhat.com>
    openvswitch: switch from WARN to pr_warn

Takashi Iwai <tiwai@suse.de>
    ALSA: aoa: Fix I2S device accounting

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()

Sudeep Holla <sudeep.holla@arm.com>
    PM: domains: Fix handling of unavailable/disabled idle states

Yang Yingliang <yangyingliang@huawei.com>
    net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix flow-type by setting GL_HASH_INSET registers

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix VF hang when reset is triggered on another VF

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix ethtool rx-flow-hash setting for X722

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings: add sanity checks for blanking values

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: dev->bitmap_cap wasn't freed in all cases

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: s_fbuf: add more sanity checks

Mario Limonciello <mario.limonciello@amd.com>
    PM: hibernate: Allow hybrid sleep to work with s2idle

Dongliang Mu <dzm91@hust.edu.cn>
    can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Neal Cardwell <ncardwell@google.com>
    tcp: fix indefinite deferral of RTO with SACK reneging

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao <shaozhengchao@huawei.com>
    net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_wait

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_psock

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: add the bit rate quirk for Molex cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix the SFP compliance codes check for DAC cables

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Fix unreliable stack dump with gcov

Yang Yingliang <yangyingliang@huawei.com>
    net: netsec: fix error handling in netsec_register_mdio()

Xin Long <lucien.xin@gmail.com>
    tipc: fix a null-ptr-deref in tipc_topsrv_accept

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()

Randy Dunlap <rdunlap@infradead.org>
    arc: iounmap() arg is volatile

Nathan Huckleberry <nhuck@google.com>
    drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Alexander Stein <alexander.stein@ew.tq-group.com>
    media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Wei Yongjun <weiyongjun1@huawei.com>
    net: ieee802154: fix error return code in dgram_bind()

Rik van Riel <riel@surriel.com>
    mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Chen Zhou <chenzhou10@huawei.com>
    cgroup-v1: add disabled controller check in cgroup1_parse_param()

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Prevent leaking grants

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: don't ignore kernel unmapping error

Chandan Babu R <chandan.babu@oracle.com>
    xfs: force the log after remapping a synchronous-writes file

Chandan Babu R <chandan.babu@oracle.com>
    xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush

Chandan Babu R <chandan.babu@oracle.com>
    xfs: finish dfops on every insert range shift iteration

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter symbol name match for modules

Christian A. Ehrhardt <lk@c--e.de>
    kernfs: fix use-after-free in __kernfs_remove

Matthew Ma <mahongwei@zeku.com>
    mmc: core: Fix kernel panic when remove non-standard SDIO card

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dsi: fix memory corruption with too many bridges

Miquel Raynal <miquel.raynal@bootlin.com>
    mac802154: Fix LQI recording

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix several use-after-free bugs

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: tsl2583: Fix module unloading

Matti Vaittinen <mazziesaccount@gmail.com>
    tools: iio: iio_utils: fix digit calculation

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Remove device endpoints from bandwidth list when freeing the device

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    mtd: rawnand: marvell: Use correct logic for nand-keep-config

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Justin Chen <justinpopo6@gmail.com>
    usb: bdc: change state when port disconnected

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't set IMI for no_interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Stop processing more requests on IMI

Hannu Hartikainen <hannu@hrtk.in>
    USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: au88x0: use explicitly signed char

Steven Rostedt (Google) <rostedt@goodmis.org>
    ALSA: Use del_timer_sync() before freeing timer

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb: Fix possible completions during init_completion

Yang Yingliang <yangyingliang@huawei.com>
    can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/io.h                          |   2 +-
 arch/arc/mm/ioremap.c                              |   2 +-
 arch/s390/include/asm/futex.h                      |   3 +-
 arch/s390/pci/pci_mmio.c                           |   8 +-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 drivers/base/power/domain.c                        |   4 +
 .../gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c    |   5 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 ++
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   5 ++
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/media/platform/vivid/vivid-core.c          |  22 +++++
 drivers/media/platform/vivid/vivid-core.h          |   2 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |  27 ++++--
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 +++
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/mtd/nand/raw/marvell_nand.c                |   2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  17 ++--
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 ++
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 ++++++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
 drivers/usb/host/xhci-mem.c                        |  20 +++--
 drivers/usb/host/xhci-pci.c                        |   8 +-
 drivers/video/fbdev/smscufx.c                      |  55 ++++++------
 drivers/xen/gntdev.c                               |  30 +++++--
 fs/kernfs/dir.c                                    |   5 +-
 fs/xfs/xfs_bmap_util.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |  17 +++-
 fs/xfs/xfs_qm.c                                    |   1 +
 include/linux/mlx5/driver.h                        |   2 +-
 include/media/v4l2-common.h                        |   3 +-
 include/uapi/linux/videodev2.h                     |   3 +-
 kernel/cgroup/cgroup-v1.c                          |   3 +
 kernel/power/hibernate.c                           |   2 +-
 mm/hugetlb.c                                       |   2 +-
 net/can/j1939/transport.c                          |   4 +-
 net/core/net_namespace.c                           |   7 ++
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/kcm/kcmsock.c                                  |  23 +++--
 net/mac802154/rx.c                                 |   5 +-
 net/openvswitch/datapath.c                         |   3 +-
 net/tipc/topsrv.c                                  |  16 +++-
 sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
 sound/pci/ac97/ac97_codec.c                        |   1 +
 sound/pci/au88x0/au88x0.h                          |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/synth/emux/emux.c                            |   7 +-
 tools/iio/iio_utils.c                              |   4 +
 tools/perf/util/auxtrace.c                         |  10 ++-
 66 files changed, 423 insertions(+), 176 deletions(-)


