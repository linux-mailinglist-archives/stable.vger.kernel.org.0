Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C87615980
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiKBDNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiKBDMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:12:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B04C2495F;
        Tue,  1 Nov 2022 20:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB4561799;
        Wed,  2 Nov 2022 03:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA673C433C1;
        Wed,  2 Nov 2022 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358731;
        bh=YsNEBjr8xghj1b6HAjT28TIQseAtob4SzfHPm0jcUiI=;
        h=From:To:Cc:Subject:Date:From;
        b=bKsAplml+M2Ub7BHSvvjDE2sieUtvxbTuCQALof8y2CFRsZspkJlohwkvRDWAeUgo
         K5WE1+62N6zrzq8gidFGx7WH5oyiW1bU+phHxbzWTFAS/PEL7xmcxAULpba9PK+LoZ
         TVVA+LBkyH10/D/tJsepbSA4hGM+gxesFtPq0/DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.10 00/91] 5.10.153-rc1 review
Date:   Wed,  2 Nov 2022 03:32:43 +0100
Message-Id: <20221102022055.039689234@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.153-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.153-rc1
X-KernelTest-Deadline: 2022-11-04T02:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.153 release.
There are 91 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.153-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.153-rc1

Lukas Wunner <lukas@wunner.de>
    serial: Deassert Transmit Enable on probe in driver-specific way

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: core: move RS485 configuration tasks from drivers into core

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/kexec: Test page size support with new TGRAN range values

James Morse <james.morse@arm.com>
    arm64/mm: Fix __enable_mmu() for new TGRAN range values

Yu Kuai <yukuai3@huawei.com>
    scsi: sd: Revert "scsi: sd: Remove a local variable"

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: Add AMPERE1 to the Spectre-BHB affected list

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: survive memory pressure without crashing

Suresh Devarakonda <ramad@nvidia.com>
    net/mlx5: Fix crash during sync firmware reset

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

Juergen Borleis <jbe@pengutronix.de>
    net: fec: limit register access on i.MX6UL

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

Eric Dumazet <edumazet@google.com>
    ipv6: ensure sane device mtu in tunnels

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: set num_in/outputs to 0 if not supported

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
    can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

Dongliang Mu <dzm91@hust.edu.cn>
    can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Neal Cardwell <ncardwell@google.com>
    tcp: fix indefinite deferral of RTO with SACK reneging

Lu Wei <luwei32@huawei.com>
    tcp: fix a signed-integer-overflow bug in tcp_add_backlog()

Eric Dumazet <edumazet@google.com>
    tcp: minor optimization in tcp_add_backlog()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Zhengchao Shao <shaozhengchao@huawei.com>
    net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_wait

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_psock

Íñigo Huguet <ihuguet@redhat.com>
    atlantic: fix deadlock at aq_nic_stop

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: add the bit rate quirk for Molex cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix the SFP compliance codes check for DAC cables

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Fix unreliable stack dump with gcov

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix the issue of double release MBOX callback of VF

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix the issue of CMDQ memory leaks

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix memory leak when reading function table

Zhengchao Shao <shaozhengchao@huawei.com>
    net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()

Yang Yingliang <yangyingliang@huawei.com>
    net: netsec: fix error handling in netsec_register_mdio()

Xin Long <lucien.xin@gmail.com>
    tipc: fix a null-ptr-deref in tipc_topsrv_accept

Maxim Levitsky <mlevitsk@redhat.com>
    perf/x86/intel/lbr: Use setup_clear_cpu_cap() instead of clear_cpu_cap()

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile

Randy Dunlap <rdunlap@infradead.org>
    arc: iounmap() arg is volatile

Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
    ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile

Nathan Huckleberry <nhuck@google.com>
    drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Alexander Stein <alexander.stein@ew.tq-group.com>
    media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation

Wei Yongjun <weiyongjun1@huawei.com>
    net: ieee802154: fix error return code in dgram_bind()

Rik van Riel <riel@surriel.com>
    mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Yuanzheng Song <songyuanzheng@huawei.com>
    mm/memory: add non-anonymous page check in the copy_present_page()

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Prevent leaking grants

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: don't ignore kernel unmapping error

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter symbol name match for modules

Christian A. Ehrhardt <lk@c--e.de>
    kernfs: fix use-after-free in __kernfs_remove

William Breathitt Gray <william.gray@linaro.org>
    counter: microchip-tcb-capture: Handle Signal1 read and Synapse

Matthew Ma <mahongwei@zeku.com>
    mmc: core: Fix kernel panic when remove non-standard SDIO card

Brian Norris <briannorris@chromium.org>
    mmc: sdhci_am654: 'select', not 'depends' REGMAP_MMIO

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dp: fix IRQ lifetime

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix memory corruption with too many bridges

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/dsi: fix memory corruption with too many bridges

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Use transport-defined speed mask for supported_speeds

Miquel Raynal <miquel.raynal@bootlin.com>
    mac802154: Fix LQI recording

Bernd Edlinger <bernd.edlinger@hotmail.de>
    exec: Copy oldsighand->action under spin-lock

Li Zetao <lizetao1@huawei.com>
    fs/binfmt_elf: Fix memory leak in load_elf_binary()

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix several use-after-free bugs

Cosmin Tanislav <cosmin.tanislav@analog.com>
    iio: temperature: ltc2983: allocate iio channels once

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: tsl2583: Fix module unloading

Matti Vaittinen <mazziesaccount@gmail.com>
    tools: iio: iio_utils: fix digit calculation

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Remove device endpoints from bandwidth list when freeing the device

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add quirk to reset host back to default state at shutdown

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
    ALSA: rme9652: use explicitly signed char

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
 arch/arm64/include/asm/cpufeature.h                |   9 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/sysreg.h                    |  36 +++++---
 arch/arm64/kernel/head.S                           |   6 +-
 arch/arm64/kernel/proton-pack.c                    |   6 ++
 arch/arm64/kvm/reset.c                             |  10 ++-
 arch/s390/include/asm/futex.h                      |   3 +-
 arch/s390/pci/pci_mmio.c                           |   8 +-
 arch/x86/events/intel/lbr.c                        |   2 +-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 drivers/base/power/domain.c                        |   4 +
 drivers/counter/microchip-tcb-capture.c            |  18 +++-
 drivers/firmware/efi/libstub/arm64-stub.c          |   2 +-
 .../gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c    |   5 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   2 +-
 drivers/gpu/drm/msm/dsi/dsi.c                      |   6 ++
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   5 ++
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iio/temperature/ltc2983.c                  |  13 ++-
 drivers/media/test-drivers/vivid/vivid-core.c      |  38 +++++++-
 drivers/media/test-drivers/vivid/vivid-core.h      |   2 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  27 ++++--
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 +++
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/mmc/host/Kconfig                           |   3 +-
 drivers/mtd/nand/raw/marvell_nand.c                |   2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   6 +-
 drivers/net/can/spi/mcp251x.c                      |   5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  17 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |  96 +++++++++++++++-----
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |   5 ++
 drivers/net/ethernet/freescale/fec_main.c          |  46 +++++++++-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c  |  18 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |   1 -
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 ++++++---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   6 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/scsi/qla2xxx/qla_attr.c                    |  28 +++++-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/tty/serial/8250/8250_omap.c                |   3 +
 drivers/tty/serial/8250/8250_pci.c                 |   9 +-
 drivers/tty/serial/8250/8250_port.c                |  12 +--
 drivers/tty/serial/fsl_lpuart.c                    |   8 +-
 drivers/tty/serial/imx.c                           |   8 +-
 drivers/tty/serial/serial_core.c                   |  61 ++++++++++---
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/gadget.c                          |   8 +-
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
 drivers/usb/host/xhci-mem.c                        |  20 +++--
 drivers/usb/host/xhci-pci.c                        |  12 ++-
 drivers/usb/host/xhci.c                            |  10 ++-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/video/fbdev/smscufx.c                      |  55 ++++++------
 drivers/xen/gntdev.c                               |  30 +++++--
 fs/binfmt_elf.c                                    |   3 +-
 fs/exec.c                                          |   4 +-
 fs/kernfs/dir.c                                    |   5 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/media/v4l2-common.h                        |   3 +-
 include/uapi/linux/videodev2.h                     |   3 +-
 kernel/power/hibernate.c                           |   2 +-
 mm/hugetlb.c                                       |   2 +-
 mm/memory.c                                        |  11 +++
 net/can/j1939/transport.c                          |   4 +-
 net/core/net_namespace.c                           |   7 ++
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_ipv4.c                                |   7 +-
 net/ipv6/ip6_gre.c                                 |  12 +--
 net/ipv6/ip6_tunnel.c                              |  11 +--
 net/ipv6/sit.c                                     |   8 +-
 net/kcm/kcmsock.c                                  |  23 +++--
 net/mac802154/rx.c                                 |   5 +-
 net/openvswitch/datapath.c                         |   3 +-
 net/tipc/topsrv.c                                  |  16 +++-
 sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
 sound/pci/ac97/ac97_codec.c                        |   1 +
 sound/pci/au88x0/au88x0.h                          |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/pci/rme9652/hdsp.c                           |  26 +++---
 sound/pci/rme9652/rme9652.c                        |  22 ++---
 sound/soc/qcom/lpass-cpu.c                         |  10 +++
 sound/synth/emux/emux.c                            |   7 +-
 tools/iio/iio_utils.c                              |   4 +
 tools/perf/util/auxtrace.c                         |  10 ++-
 103 files changed, 805 insertions(+), 337 deletions(-)


