Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD14F574B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388436AbfKHTUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389416AbfKHTAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF2321D82;
        Fri,  8 Nov 2019 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239461;
        bh=8lZ3DGMZ2MiEbV4PLLnVQGbN1zRE7i727G3iuOzqn+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=XeVpw16KzGKA2ifuUA56gdCU4ofjnjbYp0L8XoWWpiZqBY9PQmMZH7pxNGrqq8fUd
         D+nLdQW40RtOK4CtalxKx9HhNBtHaHkFJyqz/lAtypr1Rs+h4vQ5h5reyFH8JYlnGM
         ZKR3HL80Ggnn1qidg9YUdLoRJ/a7WKCpYTJbBA6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/62] 4.14.153-stable review
Date:   Fri,  8 Nov 2019 19:49:48 +0100
Message-Id: <20191108174719.228826381@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.153-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.153-rc1
X-KernelTest-Deadline: 2019-11-10T17:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.153 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.153-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.153-rc1

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Fix compile error on tlbie_test due to newer gcc

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: Add test case for tlbie vs mtpidr ordering issue

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm: Fixup tlbie vs mtpidr/mtlpidr ordering issue on POWER9

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/mm: Don't do tlbie fixup for some hardware revisions

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/mm: Fixup tlbie vs store ordering issue on POWER9

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix a race when using several adcs with dma and irq

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: move registers definitions

Jan Kiszka <jan.kiszka@siemens.com>
    platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to critclk_systems DMI table

Seth Forshee <seth.forshee@canonical.com>
    kbuild: add -fcf-protection=none when using retpoline flags

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: use -fmacro-prefix-map to make __FILE__ a relative path

Peter Zijlstra <peterz@infradead.org>
    sched/wake_q: Fix wakeup ordering for wake_q

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    dmaengine: qcom: bam_dma: Fix resource leak

Eric Dumazet <edumazet@google.com>
    net/flow_dissector: switch to siphash

Eric Dumazet <edumazet@google.com>
    inet: stop leaking jiffies on the wire

Xin Long <lucien.xin@gmail.com>
    erspan: fix the tun_info options_len check for erspan

Xin Long <lucien.xin@gmail.com>
    vxlan: check tun_info options_len properly

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in busy poll contexts

Eric Dumazet <edumazet@google.com>
    net: use skb_queue_empty_lockless() in poll() handlers

Eric Dumazet <edumazet@google.com>
    udp: use skb_queue_empty_lockless()

Eric Dumazet <edumazet@google.com>
    net: add skb_queue_empty_lockless()

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reset 40nm EPHY on energy detect

Vivien Didelot <vivien.didelot@gmail.com>
    net: dsa: fix switch tree list

Kazutoshi Noguchi <noguchi.kazutosi@gmail.com>
    r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Andrew Lunn <andrew@lunn.ch>
    net: usb: lan78xx: Connect PHY before registering MAC

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Do not clear existing mirrored port mask

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Eric Dumazet <edumazet@google.com>
    net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

Eric Dumazet <edumazet@google.com>
    udp: fix data-race in udp_set_dev_scratch()

Wei Wang <weiwan@google.com>
    selftests: net: reuseport_dualstack: fix uninitalized parameter

zhanglin <zhang.lin16@zte.com.cn>
    net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

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
    dccp: do not leak jiffies on the wire

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: fix panic when attaching to ULD fail

Josef Bacik <josef@toxicpanda.com>
    nbd: handle racing with error'ed out commands

Dave Wysochanski <dwysocha@redhat.com>
    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: remove warning when compiling with W=1

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: bmips: mark exception vectors as char arrays

Navid Emamdoost <navid.emamdoost@gmail.com>
    of: unittest: fix memory leak in unittest_data_add

afzal mohammed <afzal.mohd.ma@gmail.com>
    ARM: 8926/1: v7m: remove register save to stack before svc

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: core: Do not overwrite CDB byte 1

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Yunfeng Ye <yeyunfeng@huawei.com>
    perf kmem: Fix memory leak in compact_gfp_flags()

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

Axel Lin <axel.lin@ingics.com>
    regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    arm64: dts: Fix gpio to pinmux mapping


-------------

Diffstat:

 Makefile                                           |  13 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   8 +-
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |   4 +
 arch/arm/mach-davinci/dm365.c                      |   4 +-
 arch/arm/mm/alignment.c                            |  44 +-
 arch/arm/mm/proc-v7m.S                             |   1 -
 .../dts/broadcom/stingray/stingray-pinctrl.dtsi    |   5 +-
 .../arm64/boot/dts/broadcom/stingray/stingray.dtsi |   3 +-
 arch/mips/bcm63xx/prom.c                           |   2 +-
 arch/mips/include/asm/bmips.h                      |  10 +-
 arch/mips/kernel/smp-bmips.c                       |   8 +-
 arch/powerpc/include/asm/cputable.h                |   5 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |  32 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   3 +
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |  33 +
 arch/powerpc/mm/hash_native_64.c                   |  38 +-
 arch/powerpc/mm/pgtable_64.c                       |   1 +
 arch/powerpc/mm/tlb-radix.c                        |  94 ++-
 drivers/block/nbd.c                                |   6 +
 drivers/dma/qcom/bam_dma.c                         |  14 +
 drivers/i2c/busses/i2c-stm32f7.c                   |   2 +-
 drivers/iio/adc/stm32-adc-core.c                   |  70 +-
 drivers/iio/adc/stm32-adc-core.h                   | 135 ++++
 drivers/iio/adc/stm32-adc.c                        | 107 ---
 drivers/isdn/capi/capi.c                           |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   1 -
 drivers/net/dsa/bcm_sf2.c                          |  36 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |  29 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  25 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  15 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/lan78xx.c                          |  12 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vxlan.c                                |   5 +-
 drivers/of/unittest.c                              |   1 +
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c              |   4 +-
 drivers/platform/x86/pmc_atom.c                    |   7 +
 drivers/regulator/pfuze100-regulator.c             |   8 +-
 drivers/regulator/ti-abb-regulator.c               |  26 +-
 drivers/scsi/Kconfig                               |   2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |  21 +-
 drivers/scsi/sni_53c710.c                          |   4 +-
 drivers/target/target_core_device.c                |  21 -
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
 include/net/sock.h                                 |  15 +-
 kernel/sched/core.c                                |   7 +-
 net/atm/common.c                                   |   2 +-
 net/bluetooth/af_bluetooth.c                       |   4 +-
 net/caif/caif_socket.c                             |   2 +-
 net/core/datagram.c                                |   8 +-
 net/core/ethtool.c                                 |   4 +-
 net/core/flow_dissector.c                          |  48 +-
 net/core/sock.c                                    |   6 +-
 net/dccp/ipv4.c                                    |   4 +-
 net/dsa/dsa2.c                                     |   2 +-
 net/ipv4/datagram.c                                |   2 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_gre.c                                  |   3 +
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/udp.c                                     |  29 +-
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/udp.c                                     |   2 +-
 net/nfc/llcp_sock.c                                |   4 +-
 net/phonet/socket.c                                |   4 +-
 net/sched/sch_hhf.c                                |   8 +-
 net/sched/sch_sfb.c                                |  13 +-
 net/sched/sch_sfq.c                                |  14 +-
 net/sctp/socket.c                                  |   8 +-
 net/tipc/socket.c                                  |   4 +-
 net/unix/af_unix.c                                 |   6 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/rockchip/rockchip_i2s.c                  |   2 +-
 tools/perf/builtin-c2c.c                           |  14 +-
 tools/perf/builtin-kmem.c                          |   1 +
 tools/testing/selftests/net/reuseport_dualstack.c  |   3 +-
 tools/testing/selftests/powerpc/mm/Makefile        |   2 +
 tools/testing/selftests/powerpc/mm/tlbie_test.c    | 734 +++++++++++++++++++++
 91 files changed, 1557 insertions(+), 445 deletions(-)


