Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B42DF5560
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390408AbfKHTCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390384AbfKHTCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25DFD21D82;
        Fri,  8 Nov 2019 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239720;
        bh=ozf1xCqasfPAZYvCDhwbg5A4F0xrJR/DD5CAehBn3+A=;
        h=From:To:Cc:Subject:Date:From;
        b=cl+VwB6LqYw6VLcLMTTmDngrW+cmAzKz8K9r2UWF9EBNYgEOUKgN1E+kVDWF8UY4F
         ntSP9lAIvTLXE/jI43heA31YXSwYq7opxnpgY/fnsIufHpDL9eAzb6eAlxpWW+laSI
         PMhzG6J4pyabi5mDxbFqNDf/dHyCPFTqtEd36twY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/79] 4.19.83-stable review
Date:   Fri,  8 Nov 2019 19:49:40 +0100
Message-Id: <20191108174745.495640141@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.83-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.83-rc1
X-KernelTest-Deadline: 2019-11-10T17:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.83 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.83-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.83-rc1

Roger Quadros <rogerq@ti.com>
    usb: gadget: udc: core: Fix segfault if udc_bind_to_driver() for pending driver fails

Suman Anna <s-anna@ti.com>
    arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: pcm3168a: The codec does not support S32_LE

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9

Jan Kiszka <jan.kiszka@siemens.com>
    platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_systems DMI table

Maxim Mikityanskiy <maxtram95@gmail.com>
    wireless: Skip directory when generating certificates

Eric Dumazet <edumazet@google.com>
    net/flow_dissector: switch to siphash

Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
    r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Vivien Didelot <vivien.didelot@gmail.com>
    net: dsa: fix switch tree list

Andrew Lunn <andrew@lunn.ch>
    net: usb: lan78xx: Connect PHY before registering MAC

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reset 40nm EPHY on energy detect

Doug Berger <opendmb@gmail.com>
    net: phy: bcm7xxx: define soft_reset for 40nm EPHY

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: don't set phydev->link from MAC

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Do not clear existing mirrored port mask

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix ethtool self test: link speed

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix wrong PHY ID issue with RTL8168dp

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Paolo Abeni <pabeni@redhat.com>
    selftests: fib_tests: add more tests for metric update

Paolo Abeni <pabeni@redhat.com>
    ipv4: fix route update on metric change.

Eric Dumazet <edumazet@google.com>
    net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in busy poll contexts

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in poll() handlers

Eric Dumazet <edumazet@google.com>
    udp: use skb_queue_empty_lockless()

Eric Dumazet <edumazet@google.com>
    net: add skb_queue_empty_lockless()

Xin Long <lucien.xin@gmail.com>
    vxlan: check tun_info options_len properly

Eric Dumazet <edumazet@google.com>
    udp: fix data-race in udp_set_dev_scratch()

Wei Wang <weiwan@google.com>
    selftests: net: reuseport_dualstack: fix uninitalized parameter

zhanglin <zhang.lin16@zte.com.cn>
    net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

Daniel Wagner <dwagner@suse.de>
    net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()

Guillaume Nault <gnault@redhat.com>
    netns: fix GFP flags in rtnl_net_notifyid()

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix ping latency when deal with high throughput

Tejun Heo <tj@kernel.org>
    net: fix sk_page_frag() recursion from memory reclaim

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix IMP setup for port different than 8

Eric Dumazet <edumazet@google.com>
    net: annotate lockless accesses to sk->sk_napi_id

Eric Dumazet <edumazet@google.com>
    net: annotate accesses to sk->sk_incoming_cpu

Eric Dumazet <edumazet@google.com>
    inet: stop leaking jiffies on the wire

Xin Long <lucien.xin@gmail.com>
    erspan: fix the tun_info options_len check for erspan

Eric Dumazet <edumazet@google.com>
    dccp: do not leak jiffies on the wire

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: fix panic when attaching to ULD fail

Josef Bacik <josef@toxicpanda.com>
    nbd: handle racing with error'ed out commands

Josef Bacik <josef@toxicpanda.com>
    nbd: protect cmd->status with cmd->lock

Dave Wysochanski <dwysocha@redhat.com>
    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: remove warning when compiling with W=1

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix a race in slave mode with arbitration loss irq

Fabrice Gasnier <fabrice.gasnier@st.com>
    i2c: stm32f7: fix first byte to send in slave mode

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v3-its: Use the exact ITSList for VMOVP

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: bmips: mark exception vectors as char arrays

Navid Emamdoost <navid.emamdoost@gmail.com>
    of: unittest: fix memory leak in unittest_data_add

afzal mohammed <afzal.mohd.ma@gmail.com>
    ARM: 8926/1: v7m: remove register save to stack before svc

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    tracing: Fix "gfp_t" format for synthetic events

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: core: Do not overwrite CDB byte 1

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix potential VM faults

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Yunfeng Ye <yeyunfeng@huawei.com>
    perf kmem: Fix memory leak in compact_gfp_flags()

Colin Ian King <colin.king@canonical.com>
    8250-men-mcb: fix error checking when get_num_ports returns -ENODEV

Yunfeng Ye <yeyunfeng@huawei.com>
    perf c2c: Fix memory leak in build_cl_output()

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx7s: Correct GPT's ipg clock source

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: sni_53c710: fix compilation error

Hannes Reinecke <hare@suse.com>
    scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions

Allen Pais <allen.pais@oracle.com>
    scsi: qla2xxx: fix a potential NULL pointer dereference

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: mm: fix alignment handler faults under memory pressure

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Robin Murphy <robin.murphy@arm.com>
    ASoc: rockchip: i2s: Fix RPM imbalance

Stuart Henderson <stuarth@opensource.cirrus.com>
    ASoC: wm_adsp: Don't generate kcontrols without READ flags

Yizhuo <yzhai003@ucr.edu>
    regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized

Jaska Uimonen <jaska.uimonen@intel.com>
    ASoC: rt5682: add NULL handler to set_jack function

Axel Lin <axel.lin@ingics.com>
    regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    arm64: dts: Fix gpio to pinmux mapping

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: sopine-baseboard: Add PHY regulator delay

Jernej Skrabec <jernej.skrabec@siol.net>
    arm64: dts: allwinner: a64: pine64-plus: Add PHY regulator delay

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Do not register inapplicable controls for WM1811

Marco Felsch <m.felsch@pengutronix.de>
    regulator: of: fix suspend-min/max-voltage parsing

Seth Forshee <seth.forshee@canonical.com>
    kbuild: add -fcf-protection=none when using retpoline flags


-------------

Diffstat:

 Makefile                                           |  10 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   8 +-
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |   4 +
 arch/arm/mach-davinci/dm365.c                      |   4 +-
 arch/arm/mm/alignment.c                            |  44 +-
 arch/arm/mm/proc-v7m.S                             |   1 -
 .../boot/dts/allwinner/sun50i-a64-pine64-plus.dts  |   9 +
 .../dts/allwinner/sun50i-a64-sopine-baseboard.dts  |   6 +
 .../dts/broadcom/stingray/stingray-pinctrl.dtsi    |   5 +-
 .../arm64/boot/dts/broadcom/stingray/stingray.dtsi |   3 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   2 +-
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 arch/powerpc/include/asm/cputable.h                |   3 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   2 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |  42 +-
 arch/powerpc/mm/hash_native_64.c                   |  29 +-
 arch/powerpc/mm/tlb-radix.c                        |  80 ++-
 drivers/block/nbd.c                                |  18 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  21 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  21 +-
 drivers/isdn/capi/capi.c                           |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   1 -
 drivers/net/dsa/bcm_sf2.c                          |  36 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  13 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |  29 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  25 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  15 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |  15 +-
 drivers/net/ethernet/realtek/r8169.c               |   4 +
 drivers/net/phy/bcm7xxx.c                          |   1 +
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/lan78xx.c                          |  17 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vxlan.c                                |   6 +-
 drivers/of/unittest.c                              |   1 +
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c              |   4 +-
 drivers/platform/x86/pmc_atom.c                    |   7 +
 drivers/regulator/of_regulator.c                   |   8 +-
 drivers/regulator/pfuze100-regulator.c             |   8 +-
 drivers/regulator/ti-abb-regulator.c               |  26 +-
 drivers/scsi/Kconfig                               |   2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  21 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/scsi/sni_53c710.c                          |   4 +-
 drivers/target/target_core_device.c                |  21 -
 drivers/tty/serial/8250/8250_men_mcb.c             |   8 +-
 drivers/usb/gadget/udc/core.c                      |   2 +-
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/cifsproto.h                                |   1 +
 fs/cifs/file.c                                     |  23 +-
 fs/cifs/smb2file.c                                 |   2 +-
 include/linux/gfp.h                                |  23 +
 include/linux/skbuff.h                             |  36 +-
 include/net/busy_poll.h                            |   6 +-
 include/net/flow_dissector.h                       |   3 +-
 include/net/fq.h                                   |   2 +-
 include/net/fq_impl.h                              |   4 +-
 include/net/net_namespace.h                        |   2 +-
 include/net/sock.h                                 |  15 +-
 kernel/trace/trace_events_hist.c                   |   2 +
 net/atm/common.c                                   |   2 +-
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/caif/caif_socket.c                             |   2 +-
 net/core/datagram.c                                |   8 +-
 net/core/dev.c                                     |   2 +-
 net/core/ethtool.c                                 |   4 +-
 net/core/flow_dissector.c                          |  38 +-
 net/core/net_namespace.c                           |  17 +-
 net/core/rtnetlink.c                               |  14 +-
 net/core/sock.c                                    |   6 +-
 net/dccp/ipv4.c                                    |   4 +-
 net/decnet/af_decnet.c                             |   2 +-
 net/dsa/dsa2.c                                     |   2 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/udp.c                                     |  29 +-
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/udp.c                                     |   2 +-
 net/nfc/llcp_sock.c                                |   4 +-
 net/openvswitch/datapath.c                         |  20 +-
 net/phonet/socket.c                                |   4 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/sched/sch_sfq.c                                |  14 +-
 net/sctp/socket.c                                  |   8 +-
 net/tipc/socket.c                                  |   4 +-
 net/unix/af_unix.c                                 |   6 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 net/wireless/Makefile                              |   1 +
 sound/soc/codecs/pcm3168a.c                        |   3 +-
 sound/soc/codecs/rt5682.c                          |  12 +-
 sound/soc/codecs/wm8994.c                          |  43 +-
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/rockchip/rockchip_i2s.c                  |   2 +-
 tools/perf/builtin-c2c.c                           |  14 +-
 tools/perf/builtin-kmem.c                          |   1 +
 tools/testing/selftests/net/fib_tests.sh           |  21 +
 tools/testing/selftests/net/reuseport_dualstack.c  |   3 +-
 tools/testing/selftests/powerpc/mm/Makefile        |   2 +
 tools/testing/selftests/powerpc/mm/tlbie_test.c    | 734 +++++++++++++++++++++
 112 files changed, 1480 insertions(+), 400 deletions(-)


