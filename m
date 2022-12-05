Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318664331A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiLETeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiLETd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC729365;
        Mon,  5 Dec 2022 11:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9E01B81151;
        Mon,  5 Dec 2022 19:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37066C433C1;
        Mon,  5 Dec 2022 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268540;
        bh=ih0MJcCC0jD0qPnh0qKDI0P7gwPRtblJWbCj0ZVrvcc=;
        h=From:To:Cc:Subject:Date:From;
        b=pGbrNpDAwK1U3b0zUSSbMm4r2yU5566F1PuChQTZgUgzofb3qn8U1Qg8+PaeA/daM
         mKVpKIAgaFqAvIVmBDW3+oLE/dLeYE/8zMAwJ3KAUhGWq9srtovO1zZx4rNT7vUsOe
         E6XkoArrsRfO65udYUZUeb7lI5JcrROHz8KdwLFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/92] 5.10.158-rc1 review
Date:   Mon,  5 Dec 2022 20:09:13 +0100
Message-Id: <20221205190803.464934752@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.158-rc1
X-KernelTest-Deadline: 2022-12-07T19:08+00:00
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

This is the start of the stable review cycle for the 5.10.158 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.158-rc1

Ming Lei <ming.lei@redhat.com>
    block: unhash blkdev part inode when the part is deleted

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    Input: raydium_ts_i2c - fix memory leak in raydium_i2c_send()

Jan Dabros <jsd@semihalf.com>
    char: tpm: Protect tpm_pm_suspend with locks

Conor Dooley <conor.dooley@microchip.com>
    Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: HMAT: Fix initiator registration for single-initiator systems

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: HMAT: remove unnecessary variable initialization

Andrew Lunn <andrew@lunn.ch>
    i2c: imx: Only DMA messages with I2C_M_DMA_SAFE flag set

Yuan Can <yuancan@huawei.com>
    i2c: npcm7xx: Fix error handling in npcm_i2c_init()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Add enumeration check before spec MSRs save/restore setup

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add a feature bit for TSX control MSR support

Fedor Pchelkin <pchelkin@ispras.ru>
    Revert "tty: n_gsm: avoid call of sleeping functions from atomic context"

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix route deletion when nexthop info is not specified

David Ahern <dsahern@kernel.org>
    ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: fix nexthop warning cleanup double ip typo

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: add delete nexthop route warning test

Lee Jones <lee@kernel.org>
    Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled

Helge Deller <deller@gmx.de>
    parisc: Increase FRAME_WARN to 2048 bytes on parisc

Guenter Roeck <linux@roeck-us.net>
    xtensa: increase size of gcc stack frame check

Helge Deller <deller@gmx.de>
    parisc: Increase size of gcc stack frame check

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/vt-d: Fix PCI device refcount leak in has_external_pci()

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: Fix potential division by zero

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix bounds check for _sx controls

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: don't hold uring_lock when calling io_run_task_work*

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free buffers when a used dynamic event is removed

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Never return 0 if not all requests retired

Lee Jones <lee@kernel.org>
    drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix voltage switch delay

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Fix no reset data and command after voltage switch

Sebastian Falbesoner <sebastian.falbesoner@gmail.com>
    mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Fix ambiguous TRIM and DISCARD arg

Ye Bin <yebin10@huawei.com>
    mmc: mmc_test: Fix removal of debugfs file

Goh, Wei Sheng <wei.sheng.goh@intel.com>
    net: stmmac: Set MAC's flow control register to reflect current settings

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Save and restore pins in "direct IRQ" mode

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

ZhangPeng <zhangpeng362@huawei.com>
    nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Tiezhu Yang <yangtiezhu@loongson.cn>
    tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Steven Rostedt (Google) <rostedt@goodmis.org>
    error-injection: Add prompt for function error injection

Jisheng Zhang <jszhang@kernel.org>
    riscv: vdso: fix section overlapping under some conditions

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: DR, Fix uninitialized var warning

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Phil Auld <pauld@redhat.com>
    hwmon: (coretemp) Check for null before removing sysfs attrs

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Zhengchao Shao <shaozhengchao@huawei.com>
    sctp: fix memory leak in sctp_stream_outq_migrate()

Willem de Bruijn <willemb@google.com>
    packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Shigeru Yoshida <syoshida@redhat.com>
    net: tun: Fix use-after-free in tun_detach()

David Howells <dhowells@redhat.com>
    afs: Fix fileserver probe RTT handling

YueHaibing <yuehaibing@huawei.com>
    net: hsr: Fix potential use-after-free

Xin Long <lucien.xin@gmail.com>
    tipc: re-fetch skb cb after tipc_msg_validate

Jerry Ray <jerry.ray@microchip.com>
    dsa: lan9303: Correct stat name

Yuri Karpov <YKarpov@ispras.ru>
    net: ethernet: nixge: fix NULL dereference

Wang Hai <wanghai38@huawei.com>
    net/9p: Fix a potential socket leak in p9_socket_open

Yuan Can <yuancan@huawei.com>
    net: net_netdev: Fix error handling in ntb_netdev_init_module()

Yang Yingliang <yangyingliang@huawei.com>
    net: phy: fix null-ptr-deref while probe() failed

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't allow multi-BSSID in S1G

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix buffer overflow in elem comparison

Izabela Bakollari <ibakolla@redhat.com>
    aquantia: Do not purge addresses when setting the number of rings

Duoming Zhou <duoming@zju.edu.cn>
    qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: cc770: cc770_isa_probe(): add missing free_cc770dev()

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix use-after-free when reverting termination table

YueHaibing <yuehaibing@huawei.com>
    net/mlx5: Fix uninitialized variable bug in outlen_write()

Wang Hai <wanghai38@huawei.com>
    e100: Fix possible use after free in e100_xmit_prepare

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    e100: switch from 'pci_' to 'dma_' API

Yuan Can <yuancan@huawei.com>
    iavf: Fix error handling in iavf_init_module()

Minghao Chi <chi.minghao@zte.com.cn>
    iavf: remove redundant ret variable

Yuan Can <yuancan@huawei.com>
    fm10k: Fix error handling in fm10k_init_module()

Shang XiaoJing <shangxiaojing@huawei.com>
    i40e: Fix error handling in i40e_init_module()

Shang XiaoJing <shangxiaojing@huawei.com>
    ixgbevf: Fix resource leak in ixgbevf_init_module()

Yang Yingliang <yangyingliang@huawei.com>
    of: property: decrement node refcount in of_fwnode_get_reference_args()

Xu Kuohai <xukuohai@huawei.com>
    bpf: Do not copy spin lock field from user in bpf_selem_alloc

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (i5500_temp) fix missing pci_disable_device()

Ninad Malwade <nmalwade@nvidia.com>
    hwmon: (ina3221) Fix shunt sum critical calculation

Derek Nguyen <derek.nguyen@collins.com>
    hwmon: (ltc2947) fix temperature scaling

Hou Tao <houtao1@huawei.com>
    libbpf: Handle size overflow for ringbuf mmap

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: at91: rm9200: fix usb device clock id

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    scripts/faddr2line: Fix regression in name resolution on ppc64le

Hou Tao <houtao1@huawei.com>
    bpf, perf: Use subprog name when reporting subprog ksymbol

Paul Gazzillo <paul@pgazz.com>
    iio: light: rpr0521: add missing Kconfig dependencies

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw

Wei Yongjun <weiyongjun1@huawei.com>
    iio: health: afe4403: Fix oob read in afe4403_read_raw

ChenXiaoSong <chenxiaosong2@huawei.com>
    btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"

Claudio Suarez <cssk@net-c.es>
    drm/amdgpu: update drm_display_info correctly when the edid is read

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Lyude Paul <lyude@redhat.com>
    drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code

Nikolay Borisov <nborisov@suse.com>
    btrfs: move QUOTA_ENABLED check to rescan_should_stop from btrfs_qgroup_rescan_worker

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying inodes to userspace

David Sterba <dsterba@suse.com>
    btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/at91rm9200.dtsi                  |  2 +-
 arch/riscv/kernel/vdso/Makefile                    |  1 +
 arch/x86/include/asm/cpufeatures.h                 |  1 +
 arch/x86/include/asm/nospec-branch.h               |  2 +-
 arch/x86/kernel/cpu/bugs.c                         | 21 +++--
 arch/x86/kernel/cpu/tsx.c                          | 33 ++++----
 arch/x86/kernel/process.c                          |  2 +-
 arch/x86/power/cpu.c                               | 23 ++++--
 block/partitions/core.c                            |  7 ++
 drivers/acpi/numa/hmat.c                           | 27 ++++--
 drivers/char/tpm/tpm-interface.c                   |  5 +-
 drivers/clk/at91/at91rm9200.c                      |  2 +-
 drivers/clocksource/timer-riscv.c                  |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  4 +-
 drivers/gpu/drm/amd/display/Kconfig                |  7 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  3 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  2 +-
 drivers/gpu/drm/i915/gt/intel_gt_requests.c        |  2 +-
 drivers/hwmon/coretemp.c                           |  9 +-
 drivers/hwmon/i5500_temp.c                         |  2 +-
 drivers/hwmon/ibmpex.c                             |  1 +
 drivers/hwmon/ina3221.c                            |  4 +-
 drivers/hwmon/ltc2947-core.c                       |  2 +-
 drivers/i2c/busses/i2c-imx.c                       |  6 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   | 11 ++-
 drivers/iio/health/afe4403.c                       |  5 +-
 drivers/iio/health/afe4404.c                       | 12 +--
 drivers/iio/light/Kconfig                          |  2 +
 drivers/input/touchscreen/raydium_i2c_ts.c         |  4 +-
 drivers/iommu/intel/dmar.c                         |  1 +
 drivers/iommu/intel/iommu.c                        |  4 +-
 drivers/mmc/core/core.c                            |  9 +-
 drivers/mmc/core/mmc_test.c                        |  3 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  2 +-
 drivers/mmc/host/sdhci-sprd.c                      |  4 +-
 drivers/mmc/host/sdhci.c                           | 61 ++++++++++++--
 drivers/mmc/host/sdhci.h                           |  2 +
 drivers/net/can/cc770/cc770_isa.c                  | 10 ++-
 drivers/net/can/sja1000/sja1000_isa.c              | 10 ++-
 drivers/net/dsa/lan9303-core.c                     |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |  4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.h   |  2 +
 drivers/net/ethernet/intel/e100.c                  | 95 +++++++++++-----------
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      | 10 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 11 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  8 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  | 10 ++-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  4 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  2 +
 .../mellanox/mlx5/core/steering/dr_table.c         |  5 +-
 drivers/net/ethernet/ni/nixge.c                    | 29 +++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 12 ++-
 drivers/net/ntb_netdev.c                           |  9 +-
 drivers/net/phy/phy_device.c                       |  1 +
 drivers/net/tun.c                                  |  4 +-
 drivers/of/property.c                              |  4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              | 27 +++++-
 drivers/pinctrl/pinctrl-single.c                   |  2 +-
 drivers/spi/spi-imx.c                              |  3 +-
 drivers/tty/n_gsm.c                                | 39 +++++----
 fs/afs/fs_probe.c                                  |  4 +-
 fs/btrfs/backref.c                                 | 25 +++++-
 fs/btrfs/backref.h                                 |  3 +-
 fs/btrfs/ioctl.c                                   | 38 ++-------
 fs/btrfs/qgroup.c                                  | 22 ++---
 fs/io_uring.c                                      | 82 ++++++++++++++-----
 fs/nilfs2/dat.c                                    |  7 ++
 include/linux/license.h                            |  2 +
 include/linux/mmc/mmc.h                            |  2 +-
 include/net/sctp/stream_sched.h                    |  2 +
 kernel/bpf/bpf_local_storage.c                     |  2 +-
 kernel/events/core.c                               |  2 +-
 kernel/trace/trace_dynevent.c                      |  2 +
 kernel/trace/trace_events.c                        | 11 ++-
 lib/Kconfig.debug                                  | 14 +++-
 net/9p/trans_fd.c                                  |  4 +-
 net/hsr/hsr_forward.c                              |  5 +-
 net/ipv4/fib_semantics.c                           | 10 ++-
 net/mac80211/airtime.c                             |  3 +
 net/packet/af_packet.c                             |  6 +-
 net/sctp/stream.c                                  | 25 ++++--
 net/sctp/stream_sched.c                            |  5 ++
 net/sctp/stream_sched_prio.c                       | 19 +++++
 net/sctp/stream_sched_rr.c                         |  5 ++
 net/tipc/crypto.c                                  |  3 +
 net/wireless/scan.c                                | 10 ++-
 scripts/faddr2line                                 |  7 +-
 sound/soc/soc-ops.c                                |  2 +-
 tools/lib/bpf/ringbuf.c                            | 12 ++-
 tools/testing/selftests/net/fib_nexthops.sh        | 30 +++++++
 tools/vm/slabinfo-gnuplot.sh                       |  4 +-
 96 files changed, 672 insertions(+), 305 deletions(-)


