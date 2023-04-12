Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E1D6DEDF7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjDLIi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDLIio (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073FD83CF;
        Wed, 12 Apr 2023 01:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AC5062FEE;
        Wed, 12 Apr 2023 08:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31999C433D2;
        Wed, 12 Apr 2023 08:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288563;
        bh=giJj1lEtTYcfsE+p55VnCGgKLIPJxrhfhyB++ty+deI=;
        h=From:To:Cc:Subject:Date:From;
        b=KEFKv/2g0o1HiAgYTaZlQXmJnUCfRJjn4UvHOopeXftrZSOukP20TCqxMd7pQ7I+F
         LOJQy6MJ35c1wpvzbbxdlgH/Hb6qW6fdtKJOolz7EAxJylzi8qocFwVatDpVoO56KG
         uPSDyQmwwIycmgNNbQZIoM5UcO+kTVhbvSrIqA1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/93] 5.15.107-rc1 review
Date:   Wed, 12 Apr 2023 10:33:01 +0200
Message-Id: <20230412082823.045155996@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.107-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.107-rc1
X-KernelTest-Deadline: 2023-04-14T08:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.107 release.
There are 93 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.107-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.107-rc1

Alistair Popple <apopple@nvidia.com>
    mm: take a page reference when removing device exclusive entries

Robert Foss <robert.foss@linaro.org>
    drm/bridge: lt9611: Fix PLL being unable to lock

Rongwei Wang <rongwei.wang@linux.alibaba.com>
    mm/swap: fix swap_info_struct race between swapoff and get_swap_pages()

Zheng Yejian <zhengyejian1@huawei.com>
    ring-buffer: Fix race while reader and writer are on the same page

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/disp: Support more modes by checking with lower bpc

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path

Yafang Shao <laoar.shao@gmail.com>
    mm: vmalloc: avoid warn_alloc noise caused by fatal signal

Jason Montleon <jmontleo@redhat.com>
    ASoC: hdac_hdmi: use set_stream() instead of set_tdm_slots()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Free error logs of tracing instances

Michal Sojka <michal.sojka@cvut.cz>
    can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Christian Brauner <brauner@kernel.org>
    fs: drop peer group ids under namespace lock

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix issue that 'direct->addr' not restored in modify_ftrace_direct()

John Keeping <john@metanate.com>
    ftrace: Mark get_lock_parent_ip() __always_inline

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix the same task check in perf_event_set_output

Thiago Rafael Becker <tbecker@redhat.com>
    cifs: sanitize paths in cifs_update_super_prepath.

Steve French <stfrench@microsoft.com>
    smb3: lower default deferred close timeout to address perf regression

Steve French <stfrench@microsoft.com>
    smb3: allow deferred close timeout to be configurable

Zhong Jinghua <zhongjinghua@huawei.com>
    scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()

Li Zetao <lizetao1@huawei.com>
    scsi: qla2xxx: Fix memory leak in qla2x00_probe_one()

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad7791: fix IRQ flags

Steve Clevenger <scclevenger@os.amperecomputing.com>
    coresight-etm4: Fix for() loop drvdata->nr_addr_cmp range bug

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not access TRCIDR1 for identification

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo X370SNW

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix sysfs interface lifetime

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix Rx on RZ/G2L SCI

Biju Das <biju.das.jz@bp.renesas.com>
    tty: serial: sh-sci: Fix transmit end interrupt handler

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iio: light: cm32181: Unregister second I2C client if present

William Breathitt Gray <william.gray@linaro.org>
    iio: dac: cio-dac: Fix max DAC write value check for 12-bit

Lars-Peter Clausen <lars@metafoo.de>
    iio: adc: ti-ads7950: Set `can_sleep` flag for GPIO chip

Arnd Bergmann <arnd@arndb.de>
    iio: adis16480: select CONFIG_CRC32

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Quectel RM500U-CN modem

Enrico Sau <enrico.sau@gmail.com>
    USB: serial: option: add Telit FE990 compositions

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: Fix configure initial pin assignment

Kees Jan Koster <kjkoster@kjkoster.org>
    USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-S

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fixes error: uninitialized symbol 'len'

D Scott Phillips <scott@os.amperecomputing.com>
    xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu

Wayne Chang <waynec@nvidia.com>
    usb: xhci: tegra: fix sleep in atomic call

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: refactor single builds of *.ko

Shailend Chand <shailend@google.com>
    gve: Secure enough bytes in the first TX desc for all TCP pkts

Andy Roulin <aroulin@nvidia.com>
    ethtool: reset #lanes when lanes is omitted

Lingyu Liu <lingyu.liu@intel.com>
    ice: Reset FDIR counter in FDIR init stage

Simei Su <simei.su@intel.com>
    ice: fix wrong fallback logic for FDIR

Dai Ngo <dai.ngo@oracle.com>
    NFSD: callback request does not use correct credential for AUTH_SYS

Jeff Layton <jlayton@kernel.org>
    sunrpc: only free unix grouplist after RCU settles

Corinna Vinschen <vinschen@redhat.com>
    net: stmmac: fix up RX flow hash indirection table when setting channels

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe

Dhruva Gole <d-gole@ti.com>
    gpio: davinci: Add irq chip flag to skip set wake

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Clean up display of current_value on Thinkstation

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Fix memory leaks when parsing ThinkStation WMI strings

Armin Wolf <W_Armin@gmx.de>
    platform/x86: think-lmi: Fix memory leak when showing current settings

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv6: Fix an uninit variable access bug in __ip6_make_skb()

Sricharan Ramabadhran <quic_srichara@quicinc.com>
    net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT

Xin Long <lucien.xin@gmail.com>
    sctp: check send stream number after wait_for_sndbuf

Gustav Ekelund <gustaek@axis.com>
    net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit

Jakub Kicinski <kuba@kernel.org>
    net: don't let netpoll invoke NAPI if in xmit context

Eric Dumazet <edumazet@google.com>
    icmp: guard against too small mtu

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: qrtr: Fix a refcount bug in qrtr_recvmsg()

Luca Weiss <luca@z3ntu.xyz>
    net: qrtr: combine nameservice into main module

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: pv: fix external interruption loop not always detected

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sprd: Explicitly set .polarity in .get_state()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: cros-ec: Explicitly set .polarity in .get_state()

Mohammed Gamal <mgamal@redhat.com>
    Drivers: vmbus: Check for channel allocation before looking up relids

Randy Dunlap <rdunlap@infradead.org>
    gpio: GPIO_REGMAP: select REGMAP instead of depending on it

Tonghao Zhang <tong@infragraf.org>
    bpf: hash map, avoid deadlock with suitable hash mask

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix amdgpu_job_free_resources v2

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: Prevent race between late signaled fences and GPU reset.

Matthew Howell <matthew.howell@sealevel.com>
    serial: exar: Add support for Sealevel 7xxxC serial cards

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_exar: derive nr_ports from PCI ID for Acces I/O cards

Daniil Tatianin <d-tatianin@yandex-team.ru>
    iavf/iavf_main: actually log ->src mask when talking about it

Jacob Keller <jacob.e.keller@intel.com>
    iavf: return errno code instead of status code

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472: Split into 2 drivers

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not request 2-level PBLEs for CQ alloc

Brian Foster <bfoster@redhat.com>
    NFSD: pass range end to vfs_fsync_range() instead of count

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix sparse warning

Li Zetao <ocfs2-devel@oss.oracle.com>
    ocfs2: fix memory leak in ocfs2_mount_volume()

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: rewrite error handling of ocfs2_fill_super

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: ocfs2_mount_volume does cleanup job before return error

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing of_node_put() in sifive_ccache_init()

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing free_irq() in error path in sifive_ccache_init()

Yang Yingliang <yangyingliang@huawei.com>
    soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()

Ben Dooks <ben.dooks@sifive.com>
    soc: sifive: ccache: use pr_fmt() to remove CCACHE: prefixes

Ben Dooks <ben.dooks@sifive.com>
    soc: sifive: ccache: reduce printing on init

Zong Li <zong.li@sifive.com>
    soc: sifive: ccache: determine the cache level from dts

Greentime Hu <greentime.hu@sifive.com>
    soc: sifive: ccache: Rename SiFive L2 cache to Composable cache.


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,scif.yaml   |   4 +-
 Makefile                                           |  20 +-
 arch/s390/kvm/intercept.c                          |  32 ++-
 drivers/edac/Kconfig                               |   2 +-
 drivers/edac/sifive_edac.c                         |  12 +-
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-davinci.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  18 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   1 +
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   1 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  32 +++
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   8 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   1 +
 drivers/hv/connection.c                            |   4 +
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  24 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |  20 +-
 drivers/iio/adc/ad7791.c                           |   2 +-
 drivers/iio/adc/ti-ads7950.c                       |   1 +
 drivers/iio/dac/cio-dac.c                          |   4 +-
 drivers/iio/imu/Kconfig                            |   1 +
 drivers/iio/light/cm32181.c                        |  12 +
 drivers/infiniband/hw/irdma/verbs.c                |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/global2.c                |  20 ++
 drivers/net/dsa/mv88e6xxx/global2.h                |   1 +
 drivers/net/ethernet/google/gve/gve.h              |   2 +
 drivers/net/ethernet/google/gve/gve_tx.c           |  12 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  22 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |  23 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   6 +-
 drivers/platform/x86/intel/int3472/Makefile        |   9 +-
 ...472_clk_and_regulator.c => clk_and_regulator.c} |   5 +-
 drivers/platform/x86/intel/int3472/common.c        |  54 +++++
 .../{intel_skl_int3472_common.h => common.h}       |   3 -
 .../{intel_skl_int3472_discrete.c => discrete.c}   |  32 ++-
 .../x86/intel/int3472/intel_skl_int3472_common.c   | 106 --------
 .../{intel_skl_int3472_tps68470.c => tps68470.c}   |  23 +-
 drivers/platform/x86/think-lmi.c                   |  20 +-
 drivers/pwm/pwm-cros-ec.c                          |   1 +
 drivers/pwm/pwm-sprd.c                             |   1 +
 drivers/scsi/iscsi_tcp.c                           |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   1 +
 drivers/soc/sifive/Kconfig                         |   6 +-
 drivers/soc/sifive/Makefile                        |   2 +-
 drivers/soc/sifive/sifive_ccache.c                 | 266 +++++++++++++++++++++
 drivers/soc/sifive/sifive_l2_cache.c               | 237 ------------------
 drivers/tty/serial/8250/8250_exar.c                |  51 ++--
 drivers/tty/serial/fsl_lpuart.c                    |   8 +-
 drivers/tty/serial/sh-sci.c                        |  10 +-
 drivers/usb/cdns3/cdnsp-ep0.c                      |   3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/host/xhci-tegra.c                      |   6 +-
 drivers/usb/host/xhci.c                            |   6 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |  10 +
 drivers/usb/typec/altmodes/displayport.c           |   6 +-
 fs/cifs/cifsfs.c                                   |   1 +
 fs/cifs/connect.c                                  |   2 +
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/fs_context.c                               |  22 +-
 fs/cifs/fs_context.h                               |  11 +
 fs/cifs/misc.c                                     |   2 +-
 fs/ksmbd/connection.c                              |   5 +-
 fs/namespace.c                                     |   2 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/nfs4xdr.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   3 +-
 fs/nilfs2/super.c                                  |   2 +
 fs/nilfs2/the_nilfs.c                              |  12 +-
 fs/ocfs2/journal.c                                 |   2 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/super.c                                   | 105 ++++----
 include/linux/ftrace.h                             |   2 +-
 include/soc/sifive/sifive_ccache.h                 |  16 ++
 include/soc/sifive/sifive_l2_cache.h               |  16 --
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/events/core.c                               |   2 +-
 kernel/trace/ftrace.c                              |  15 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace.c                               |   1 +
 mm/memory.c                                        |  16 +-
 mm/swapfile.c                                      |   3 +-
 mm/vmalloc.c                                       |   8 +-
 net/can/isotp.c                                    |  17 +-
 net/can/j1939/transport.c                          |   5 +-
 net/core/netpoll.c                                 |  19 +-
 net/ethtool/linkmodes.c                            |   7 +-
 net/ipv4/icmp.c                                    |   5 +
 net/ipv6/ip6_output.c                              |   7 +-
 net/mac80211/sta_info.c                            |   3 +-
 net/qrtr/Makefile                                  |   3 +-
 net/qrtr/{qrtr.c => af_qrtr.c}                     |   2 +
 net/qrtr/ns.c                                      |  15 +-
 net/sctp/socket.c                                  |   4 +
 net/sunrpc/svcauth_unix.c                          |  17 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/hdac_hdmi.c                       |  17 +-
 101 files changed, 968 insertions(+), 639 deletions(-)


