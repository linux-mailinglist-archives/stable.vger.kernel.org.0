Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A273147A7C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgAXJd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgAXJd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:33:58 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12EF214AF;
        Fri, 24 Jan 2020 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858436;
        bh=ceoU65gnczC4OUsy8/YVQVLjbhOusLNomcWP3sL5THI=;
        h=From:To:Cc:Subject:Date:From;
        b=aCFdNnUYrQqwhCA0j/AQTjM4DcgjlGHTTVzNX6fN8ntZqlhAXfsmnKjkFziIaYA38
         tuVtjKx/fxH7BWPVs1XQPKmGf5ftwT+hZoQwbr1A2/elgJwxJv+PV8LJtvOw2kfe7Y
         YBc1eTjoLuyhvs+VMRM2WatHRW6hCnU65lCeZZv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/102] 5.4.15-stable review
Date:   Fri, 24 Jan 2020 10:30:01 +0100
Message-Id: <20200124092806.004582306@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.15-rc1
X-KernelTest-Deadline: 2020-01-26T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.15 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.15-rc1

Sumit Garg <sumit.garg@linaro.org>
    optee: Fix multi page dynamic shm pool alloc

Jonas Karlman <jonas@kwiboo.se>
    phy/rockchip: inno-hdmi: round clock rate down to closest 1000 Hz

Arnd Bergmann <arnd@arndb.de>
    gpio: aspeed: avoid return type warning

Jouni Hogander <jouni.hogander@unikie.com>
    net-sysfs: Call dev_hold always in netdev_queue_add_kobject

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix dangling IO buffers after halt/clear

Justin Tee <justin.tee@broadcom.com>
    block: fix memleak of bio integrity data

Wen Yang <wenyang@linux.alibaba.com>
    platform/chrome: wilco_ec: fix use after free issue

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: Fix cleanup on map free for devmap_hash map type

Sam Bobroff <sbobroff@linux.ibm.com>
    drm/radeon: fix bad DMA from INTERRUPT_CNTL2

Chuhong Yuan <hslester96@gmail.com>
    dmaengine: ti: edma: fix missed failure handling

zhengbin <zhengbin13@huawei.com>
    afs: Remove set but not used variables 'before', 'after'

Christoph Hellwig <hch@lst.de>
    dma-direct: don't check swiotlb=force in dma_direct_map_resource

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76u: rely on usb_interface instead of usb_dev

Vincent Guittot <vincent.guittot@linaro.org>
    sched/cpufreq: Move the cfs_rq_util_change() call to cpufreq_update_util()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix another issue with MIC buffer space

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    workqueue: Add RCU annotation for pwq list walk

Jens Wiklander <jens.wiklander@linaro.org>
    tee: optee: fix device enumeration error handling

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix dynamic shm pool allocations

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: core: fix wl1251 sdio quirks

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: sdio: fix wl1251 vendor id

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Fix doorbell ring logic for !CONFIG_64BIT

Hewenliang <hewenliang4@huawei.com>
    kselftests: cgroup: Avoid the reuse of fd after it is deallocated

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: report dma error during probe

Eric Dumazet <edumazet@google.com>
    packet: fix data-race in fanout_flow_is_huge()

Colin Ian King <colin.king@canonical.com>
    rtc: bd70528: fix module alias to autoload module

Kees Cook <keescook@chromium.org>
    selftests: gen_kselftest_tar.sh: Do not clobber kselftest/

Wei Yongjun <weiyongjun1@huawei.com>
    net: axienet: Fix error return code in axienet_probe()

Eric Dumazet <edumazet@google.com>
    net: neigh: use long type to store jiffies delta

Daniel Golle <daniel@makrotopia.org>
    rt2800: remove errornous duplicate condition

Stephen Hemminger <sthemmin@microsoft.com>
    hv_netvsc: flag software created hash value

Tonghao Zhang <xiangxia.m.yue@gmail.com>
    net: openvswitch: don't unlock mutex when changing the user_features fails

Bean Huo <beanhuo@micron.com>
    scsi: ufs: delete redundant function ufshcd_def_desc_sizes()

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: avoid timestamp read on error paths

Madalin Bucur <madalin.bucur@nxp.com>
    dpaa_eth: perform DMA unmapping before read

Dan Carpenter <dan.carpenter@oracle.com>
    rcu: Fix uninitialized variable in nocb_gp_wait()

Andrii Nakryiko <andriin@fb.com>
    libbpf: Don't use kernel-side u32 type in xsk.c

Daniel Baluta <daniel.baluta@nxp.com>
    firmware: imx: Remove call to devm_of_platform_populate

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    power: supply: bd70528: Add MODULE_ALIAS to allow module auto loading

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu/vi: silence an uninitialized variable warning

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    regulator: bd70528: Add MODULE_ALIAS to allow module auto loading

Ondrej Jirman <megous@megous.com>
    pwm: sun4i: Fix incorrect calculation of duty_cycle/period

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: platform: Unregister stale platform devices

Ilias Apalodimas <ilias.apalodimas@linaro.org>
    net: netsec: Correct dma sync for XDP_TX frames

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: rcar_lvds: Fix color mismatches on R-Car H2 ES2.0 and later

Kefeng Wang <wangkefeng.wang@huawei.com>
    PCI: mobiveil: Fix csr_read()/write() build issue

Sakari Ailus <sakari.ailus@linux.intel.com>
    software node: Get reference to parent swnode in get_parent op

Douglas Anderson <dianders@chromium.org>
    drm/rockchip: Round up _before_ giving to the clock framework

Ioana Radulescu <ruxandra.radulescu@nxp.com>
    dpaa2-eth: Fix minor bug in ethtool stats reporting

Tony Lindgren <tony@atomide.com>
    hwrng: omap3-rom - Fix missing clock by probing with device tree

yu kuai <yukuai3@huawei.com>
    drm/amdgpu: remove excess function parameter description

Dan Carpenter <dan.carpenter@oracle.com>
    drm: panel-lvds: Potential Oops in probe error handling

Steven Price <steven.price@arm.com>
    drm/panfrost: Add missing check for pfdev->regulator

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: fix error handling when setup efuse info

Yan-Hsuan Chuang <yhchuang@realtek.com>
    rtw88: fix beaconing mode rsvd_page memory violation issue

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: No need to call gpiochip_remove_pin_ranges() twice

Peter Zijlstra <peterz@infradead.org>
    sched/core: Further clarify sched_class::set_next_task()

Navid Emamdoost <navid.emamdoost@gmail.com>
    ipmi: Fix memory leak in __ipmi_bmc_register

Shuiqing Li <shuiqing.li@unisoc.com>
    watchdog: sprd: Fix the incorrect pointer getting from driver data

Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
    soc: aspeed: Fix snoop_file_poll()'s return type

Geert Uytterhoeven <geert+renesas@glider.be>
    soc: renesas: Add missing check for non-zero product register address

Stephen Boyd <swboyd@chromium.org>
    soc: qcom: llcc: Name regmaps to avoid collisions

Thierry Reding <treding@nvidia.com>
    soc/tegra: pmc: Fix crashes for hierarchical interrupts

Jean-Jacques Hiblot <jjhiblot@ti.com>
    leds: tlc591xx: update the maximum brightness

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf map: No need to adjust the long name of modules

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - fix big endian issues

Christian Lamparter <chunkeey@gmail.com>
    crypto: amcc - restore CRYPTO_AES dependency

Patrick Steinhardt <ps@pks.im>
    nfsd: depend on CRYPTO_MD5 for legacy client tracking

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/pkey: fix memory leak within _copy_apqns_from_user()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: fix stack leakage

Lorenzo Bianconi <lorenzo@kernel.org>
    mt7601u: fix bbp version check in mt7601u_wait_bbp_ready

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt76u: fix endpoint definition order

Grygorii Strashko <grygorii.strashko@ti.com>
    phy: ti: gmii-sel: fix mac tx internal delay for rgmii-rxid

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: broadcom: Fix RGMII delays configuration for BCM54210E

Wei Yongjun <weiyongjun1@huawei.com>
    phy: lantiq: vrx200-pcie: fix error return code in ltq_vrx200_pcie_phy_power_on()

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Fix free peer_flow when refcount is 0

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix wrong timeout input for tipc_wait_for_cond()

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix wrong socket reference counter after tipc_sk_timeout() returns

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix potential memory leak in __tipc_sendmsg()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: update mon's self addr when node addr generated

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: reduce sensitive to retransmit failures

Ard Biesheuvel <ardb@kernel.org>
    powerpc/archrandom: fix arch_get_random_seed_int()

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: Fix boot failure with RELOCATABLE && FSL_BOOKE

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: Enable support for ibm,drc-info property

Geert Uytterhoeven <geert+renesas@glider.be>
    powerpc/security: Fix debugfs data leak on 32-bit

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix backchannel latency metrics

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svcauth_gss_proxy_init()

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    mfd: intel-lpss: Add default I2C device properties for Gemini Lake

Alain Volmat <alain.volmat@st.com>
    i2c: i2c-stm32f7: fix 10-bits check in slave free id search loop

Alain Volmat <alain.volmat@st.com>
    i2c: stm32f7: rework slave_id allocation

Jan Kara <jack@suse.cz>
    xfs: Sanity check flags of Q_XQUOTARM call

Markus Elfring <elfring@users.sourceforge.net>
    ARM: OMAP2+: Add missing put_device() call in omapdss_init_of()

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-37xx-devkit-28: Reference new DRM panel

Jesper Dangaard Brouer <brouer@redhat.com>
    samples/bpf: Fix broken xdp_rxq_info due to map order assumptions

Daniel T. Lee <danieltimlee@gmail.com>
    samples: bpf: update map definition to new syntax BTF-defined map

Stanislav Fomichev <sdf@google.com>
    bpf: Force .BTF section start to zero when dumping from vmlinux

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix call relocation offset calculation bug

Andrii Nakryiko <andriin@fb.com>
    libbpf: Make btf__resolve_size logic always check size error condition

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix another potential overflow issue in bpf_prog_linfo

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix potential overflow issue

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix memory leak/double free issue

Magnus Karlsson <magnus.karlsson@intel.com>
    libbpf: Fix compatibility for kernels without need_wakeup

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Fix pid leak with banned clients


-------------

Diffstat:

 .../devicetree/bindings/rng/omap3_rom_rng.txt      |  27 +++++
 Makefile                                           |   4 +-
 .../boot/dts/logicpd-torpedo-37xx-devkit-28.dts    |  20 +---
 arch/arm/boot/dts/omap3-n900.dts                   |   6 ++
 arch/arm/mach-omap2/display.c                      |   1 +
 arch/arm/mach-omap2/pdata-quirks.c                 |  12 +--
 arch/powerpc/include/asm/archrandom.h              |   2 +-
 arch/powerpc/include/asm/security_features.h       |   8 +-
 arch/powerpc/kernel/head_fsl_booke.S               |   6 +-
 arch/powerpc/kernel/prom_init.c                    |   2 +-
 arch/powerpc/kernel/security.c                     |   4 +-
 block/bio-integrity.c                              |   2 +-
 block/bio.c                                        |   3 +
 block/blk.h                                        |   4 +
 drivers/acpi/acpi_platform.c                       |  43 ++++++++
 drivers/acpi/scan.c                                |   1 +
 drivers/base/swnode.c                              |   5 +-
 drivers/char/hw_random/omap3-rom-rng.c             |  17 ++-
 drivers/char/ipmi/ipmi_msghandler.c                |   5 +-
 drivers/crypto/Kconfig                             |   1 +
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  21 ++--
 drivers/dma/ti/edma.c                              |   6 +-
 drivers/firmware/arm_scmi/perf.c                   |   2 +-
 drivers/firmware/imx/imx-dsp.c                     |   2 +-
 drivers/gpio/gpiolib-of.c                          |   5 +-
 drivers/gpio/gpiolib.c                             |   3 +-
 drivers/gpio/sgpio-aspeed.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   2 -
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c      |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   3 +-
 drivers/gpu/drm/panel/panel-lvds.c                 |  21 +---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |   6 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/gpu/drm/rcar-du/rcar_lvds.c                |  28 +++--
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |  37 ++++++-
 drivers/i2c/busses/i2c-stm32.c                     |  16 +--
 drivers/i2c/busses/i2c-stm32f7.c                   |  13 ++-
 drivers/leds/leds-tlc591xx.c                       |   7 +-
 drivers/mfd/intel-lpss-pci.c                       |  28 +++--
 drivers/mmc/core/quirks.h                          |   7 ++
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  47 ++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   7 +-
 drivers/net/ethernet/socionext/netsec.c            |   4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   4 -
 drivers/net/hyperv/netvsc_drv.c                    |   7 +-
 drivers/net/phy/broadcom.c                         |  11 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  12 ++-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   5 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  52 +++++++--
 drivers/net/wireless/realtek/rtw88/main.c          |  11 +-
 drivers/pci/controller/pcie-mobiveil.c             | 119 +++++++++++----------
 drivers/phy/lantiq/phy-lantiq-vrx200-pcie.c        |   3 +-
 drivers/phy/rockchip/phy-rockchip-inno-hdmi.c      |   4 +
 drivers/phy/ti/phy-gmii-sel.c                      |   2 +-
 drivers/platform/chrome/wilco_ec/telemetry.c       |   2 +-
 drivers/power/supply/bd70528-charger.c             |   1 +
 drivers/pwm/pwm-sun4i.c                            |   4 +-
 drivers/regulator/bd70528-regulator.c              |   1 +
 drivers/rtc/rtc-bd70528.c                          |   2 +-
 drivers/s390/crypto/pkey_api.c                     |   4 +-
 drivers/s390/net/qeth_core.h                       |   3 +
 drivers/s390/net/qeth_core_main.c                  |  71 ++++++++----
 drivers/s390/net/qeth_core_mpc.h                   |  14 ---
 drivers/s390/net/qeth_l2_main.c                    |  12 +--
 drivers/s390/net/qeth_l3_main.c                    |  13 +--
 drivers/scsi/ufs/ufshcd.c                          |  15 +--
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   4 +-
 drivers/soc/qcom/llcc-slice.c                      |   3 +-
 drivers/soc/renesas/renesas-soc.c                  |   2 +-
 drivers/soc/tegra/pmc.c                            |  28 ++++-
 drivers/tee/optee/call.c                           |   7 ++
 drivers/tee/optee/core.c                           |  20 ++--
 drivers/tee/optee/shm_pool.c                       |  25 ++++-
 drivers/watchdog/sprd_wdt.c                        |   6 +-
 fs/afs/dir_edit.c                                  |  12 +--
 fs/nfsd/Kconfig                                    |   1 +
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/linux/mmc/sdio_ids.h                       |   2 +
 kernel/bpf/devmap.c                                |  74 ++++++++-----
 kernel/dma/direct.c                                |   2 +-
 kernel/rcu/tree_plugin.h                           |   2 +-
 kernel/sched/deadline.c                            |   7 +-
 kernel/sched/fair.c                                | 113 ++++++++++---------
 kernel/sched/idle.c                                |   4 +-
 kernel/sched/rt.c                                  |   7 +-
 kernel/sched/sched.h                               |   4 +-
 kernel/sched/stop_task.c                           |   4 +-
 kernel/workqueue.c                                 |   3 +-
 net/core/neighbour.c                               |   4 +-
 net/core/net-sysfs.c                               |   7 +-
 net/openvswitch/datapath.c                         |   2 +-
 net/packet/af_packet.c                             |  12 ++-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  84 +++++++++++----
 net/sunrpc/xdr.c                                   |  11 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |   1 +
 net/sunrpc/xprtsock.c                              |   3 +-
 net/tipc/link.c                                    |   2 +-
 net/tipc/monitor.c                                 |  15 +++
 net/tipc/monitor.h                                 |   1 +
 net/tipc/net.c                                     |   2 +
 net/tipc/socket.c                                  |   7 +-
 samples/bpf/sockex1_kern.c                         |  12 +--
 samples/bpf/sockex2_kern.c                         |  12 +--
 samples/bpf/xdp1_kern.c                            |  12 +--
 samples/bpf/xdp2_kern.c                            |  12 +--
 samples/bpf/xdp_adjust_tail_kern.c                 |  12 +--
 samples/bpf/xdp_fwd_kern.c                         |  13 ++-
 samples/bpf/xdp_redirect_cpu_kern.c                | 108 +++++++++----------
 samples/bpf/xdp_redirect_kern.c                    |  24 ++---
 samples/bpf/xdp_redirect_map_kern.c                |  24 ++---
 samples/bpf/xdp_router_ipv4_kern.c                 |  64 +++++------
 samples/bpf/xdp_rxq_info_kern.c                    |  37 +++----
 samples/bpf/xdp_rxq_info_user.c                    |   6 +-
 samples/bpf/xdp_tx_iptunnel_kern.c                 |  26 ++---
 scripts/link-vmlinux.sh                            |   5 +-
 tools/lib/bpf/bpf.c                                |   2 +-
 tools/lib/bpf/bpf_prog_linfo.c                     |  14 +--
 tools/lib/bpf/btf.c                                |   3 +-
 tools/lib/bpf/libbpf.c                             |  10 +-
 tools/lib/bpf/xsk.c                                |  83 +++++++++++---
 tools/perf/util/machine.c                          |  27 +----
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   4 +-
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   4 +-
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |   4 +-
 tools/testing/selftests/cgroup/test_freezer.c      |   1 +
 tools/testing/selftests/gen_kselftest_tar.sh       |  21 ++--
 tools/testing/selftests/kselftest_install.sh       |  24 ++---
 135 files changed, 1150 insertions(+), 739 deletions(-)


