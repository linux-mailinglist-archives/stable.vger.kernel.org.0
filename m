Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27B65EA53E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbiIZL7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiIZL6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7386C7AC09;
        Mon, 26 Sep 2022 03:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2EA1B80920;
        Mon, 26 Sep 2022 10:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86AEC433C1;
        Mon, 26 Sep 2022 10:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188989;
        bh=FbNbEnMhyXEU4Rq4+p7Hq4mUXgr79xiQ55GULbWlWPE=;
        h=From:To:Cc:Subject:Date:From;
        b=RRzdC+q/9ClZWcukKkzWtz72jQDUiZwEK2nJEkfmldEjEKHxt+CvP2jEPkLonLyxt
         PCdj9cCbhQTGK3kJ7zc6FGThYl/YxGu4yj9QsDw3S5bci1rI3CaYqsPM1idUKdHU43
         s71mGtuH7XrYoauqEGHUyxpl0JORwa4o46XXPz9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 000/207] 5.19.12-rc1 review
Date:   Mon, 26 Sep 2022 12:09:49 +0200
Message-Id: <20220926100806.522017616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.12-rc1
X-KernelTest-Deadline: 2022-09-28T10:08+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.19.12 release.
There are 207 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.12-rc1

Christoph Hellwig <hch@lst.de>
    Revert "block: freeze the queue earlier in del_gendisk"

Jan Kara <jack@suse.cz>
    ext4: use buckets for cr 1 block scan instead of rbtree

Jan Kara <jack@suse.cz>
    ext4: use locality group preallocation for small closed files

Jan Kara <jack@suse.cz>
    ext4: make directory inode spreading reflect flexbg size

Jan Kara <jack@suse.cz>
    ext4: avoid unnecessary spreading of allocations among groups

Jan Kara <jack@suse.cz>
    ext4: make mballoc try target group first even with mb_optimize_scan

Theodore Ts'o <tytso@mit.edu>
    ext4: limit the number of retries after discarding preallocations blocks

Luís Henriques <lhenriques@suse.de>
    ext4: fix bug in extents parsing when eh_entries == 0 and eh_depth > 0

Dan Williams <dan.j.williams@intel.com>
    devdax: Fix soft-reservation memory description

Nick Desaulniers <ndesaulniers@google.com>
    Makefile.debug: re-enable debug info for .S files

Nick Desaulniers <ndesaulniers@google.com>
    Makefile.debug: set -g unconditional on CONFIG_DEBUG_INFO_SPLIT

Masahiro Yamada <masahiroy@kernel.org>
    certs: make system keyring depend on built-in x509 parser

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't register a dirty callback for non-atomic

Dan Carpenter <dan.carpenter@oracle.com>
    i2c: mux: harden i2c_mux_alloc() against integer overflows

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: Fix frequency calculation

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()

Asmaa Mnebhi <asmaa@nvidia.com>
    i2c: mlxbf: incorrect base address passed during io write

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    workqueue: don't skip lockdep work dependency in cancel_work_sync()

Li Jinlin <lijinlin3@huawei.com>
    fsdax: Fix infinite loop in dax_iomap_rw()

Jane Chu <jane.chu@oracle.com>
    pmem: fix a name collision

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: Make the irqchip immutable

Nathan Huckleberry <nhuck@google.com>
    drm/rockchip: Fix return type of cdn_dp_connector_mode_valid

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack usage

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Reduce number of arguments of dml31's CalculateFlipSchedule()

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Reduce number of arguments of dml31's CalculateWatermarksAndDRAMSpeedChangeSupport()

Yao Wang1 <Yao.Wang1@amd.com>
    drm/amd/display: Limit user regamma to a valid value

Candice Li <candice.li@amd.com>
    drm/amdgpu: Skip reset error status for psp v13_0_0

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add HDP remap functionality to nbio 7.7

Yang Wang <KevinYang.Wang@amd.com>
    drm/amdgpu: change the alignment size of TMR BO to 1M

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amdgpu: use dirty framebuffer helper

Guchun Chen <guchun.chen@amd.com>
    drm/amd/pm: disable BACO entry/exit completely on several sienna cichlid cards

Linus Walleij <linus.walleij@linaro.org>
    gpio: ixp4xx: Make irqchip immutable

Hans de Goede <hdegoede@redhat.com>
    drm/gma500: Fix (vblank) IRQs not working after suspend/resume

Hans de Goede <hdegoede@redhat.com>
    drm/gma500: Fix WARN_ON(lock->magic != lock) error

Hans de Goede <hdegoede@redhat.com>
    drm/gma500: Fix BUG: sleeping function called from invalid context errors

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Rafael Mendonca <rafaelmendsr@gmail.com>
    block: Do not call blk_put_queue() if gendisk allocation fails

Christoph Hellwig <hch@lst.de>
    block: call blk_mq_exit_queue from disk_release for never added disks

Christoph Hellwig <hch@lst.de>
    blk-mq: fix error handling in __blk_mq_alloc_disk

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Fix handling of enable_psr parameter

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Pali Rohár <pali@kernel.org>
    phy: marvell: phy-mvebu-a3700-comphy: Remove broken reset support

Ming Lei <ming.lei@redhat.com>
    cgroup: cgroup_get_from_id() must check the looked-up kn is a directory

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: Create uart_xmit_advance()

Lukas Wunner <lukas@wunner.de>
    serial: fsl_lpuart: Reset prior to registration

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that cached task references are always put on exit

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: add shebang for sch_red.sh

Jakub Kicinski <kuba@kernel.org>
    bnxt: prevent skb UAF after handing over to PTP worker

Hangyu Hua <hbh25y@gmail.com>
    net: sched: fix possible refcount leak in tc_new_tfilter()

Sean Anderson <seanga2@gmail.com>
    net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Jonathan Toppins <jtoppins@redhat.com>
    bonding: fix NULL deref in bond_rr_gen_slave_id

Michael Walle <michael@walle.cc>
    net: phy: micrel: fix shared interrupt on LAN8814

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Stop the CLC flow if no link to map buffers on

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: dsi: Move mtk_dsi_stop() call back to mtk_dsi_poweroff()

Namhyung Kim <namhyung@kernel.org>
    perf tools: Honor namespace when synthesizing build-ids

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Do not check /proc/modules is unchanged

Lieven Hey <lieven.hey@kdab.com>
    perf jit: Include program header in ELF files

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix cpu map index in bperf cgroup code

Namhyung Kim <namhyung@kernel.org>
    perf stat: Fix BPF program section name

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix race dev->can.state condition

Dongliang Mu <mudongliangabcd@gmail.com>
    gpio: tqmx86: fix uninitialized variable girq

Geert Uytterhoeven <geert+renesas@glider.be>
    net: sh_eth: Fix PHY state warning splat during system resume

Geert Uytterhoeven <geert+renesas@glider.be>
    net: ravb: Fix PHY state warning splat during system resume

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix memory leak when blob is malformed

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()

Mateusz Palczewski <mateusz.palczewski@intel.com>
    ice: Fix interface being down after reset with link-down-on-close flag on

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: config netdev tc before setting queues number

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid disabling offload when it was never enabled

Ido Schimmel <idosch@nvidia.com>
    ipv6: Fix crash when IPv6 is administratively disabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: deny offload of tc-based TSN features on VF interfaces

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: move enetc_set_psfp() out of the common enetc_set_features()

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: netlink: avoid variable-sized memcpy on sockaddr

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: ratelimiter: disable timings test by default

Íñigo Huguet <ihuguet@redhat.com>
    sfc/siena: fix null pointer dereference in efx_hard_start_xmit

Íñigo Huguet <ihuguet@redhat.com>
    sfc/siena: fix TX channel offset when using legacy interrupts

Alex Elder <elder@linaro.org>
    net: ipa: properly limit modem routing table use

Liang He <windhl@126.com>
    of: mdio: Add of_node_put() when breaking out of for_each_xx

Randy Dunlap <rdunlap@infradead.org>
    drm/hisilicon: Add depends on MMU

Shailend Chand <shailend@google.com>
    gve: Fix GFP flags when allocing pages

Vadim Fedorenko <vfedorenko@novek.ru>
    bnxt_en: fix flags to check for supported fw version

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix null pointer dereference in efx_hard_start_xmit

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix TX channel offset when using legacy interrupts

Ido Schimmel <idosch@nvidia.com>
    netdevsim: Fix hwstats debugfs file permissions

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix set max_tx_rate when it is lower than 1 Mbps

Michal Jaron <michalx.jaron@intel.com>
    i40e: Fix VF set max MTU size

Michal Jaron <michalx.jaron@intel.com>
    iavf: Fix set max MTU size with port VLAN and jumbo frames

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: clear MDIO gateway lock after read

Norbert Zulinski <norbertx.zulinski@intel.com>
    iavf: Fix bad page state

Christian Lamparter <chunkeey@gmail.com>
    um: fix default console kernel parameter

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    MIPS: Loongson32: Fix PHY-mode being left unspecified

Randy Dunlap <rdunlap@infradead.org>
    MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Feng Tang <feng.tang@intel.com>
    mm/slab_common: fix possible double free of kmem_cache

Heiko Schocher <hs@denx.de>
    drm/panel: simple: Fix innolux_g121i1_l01 bus_format

Benjamin Poirier <bpoirier@nvidia.com>
    net: team: Unsync device addresses on ndo_stop

Benjamin Poirier <bpoirier@nvidia.com>
    net: bonding: Unsync device addresses on ndo_stop

Benjamin Poirier <bpoirier@nvidia.com>
    net: bonding: Share lacpdu_mcast_addr definition

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix return value check of dma_get_required_mask()

Rafael Mendonca <rafaelmendsr@gmail.com>
    scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw74xx: fix port/phy validation

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: phy: aquantia: wait for the suspend/resume operations to finish

Horatiu Vultur <horatiu.vultur@microchip.com>
    ARM: dts: lan966x: Fix the interrupt number for internal PHYs

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw74xx: fix ksz9477 cpu port

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw74xx: fix CAN STBY polarity

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    drm/mediatek: Fix wrong dither settings

Fabio Estevam <festevam@denx.de>
    arm64: dts: tqma8mqml: Include phy-imx8-pcie.h header

Toke Høiland-Jørgensen <toke@redhat.com>
    wifi: iwlwifi: Mark IWLMEI as broken

Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>
    net: core: fix flow symmetric hash

Lu Wei <luwei32@huawei.com>
    ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Brett Creeley <brett.creeley@intel.com>
    iavf: Fix cached head and tail value for iavf_get_tx_pending

Ding Hui <dinghui@sangfor.com.cn>
    ice: Fix crash by keep old cfg when update TCs more than queues

Dave Ertman <david.m.ertman@intel.com>
    ice: Don't double unplug aux on peer initiated reset

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()

David Leadbeater <dgl@dgl.cx>
    netfilter: nf_conntrack_irc: Tighten matching on DCC message

Igor Ryzhov <iryzhov@nfware.com>
    netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Philippe Schenker <philippe.schenker@toradex.com>
    arm64: dts: imx8mm-verdin: extend pmic voltages

Fabio Estevam <festevam@denx.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from rk3566-quartz64-a

Fabio Estevam <festevam@denx.de>
    arm64: dts: rockchip: Remove 'enable-active-low' from rk3399-puma

Michael Riesch <michael.riesch@wolfvision.net>
    arm64: dts: rockchip: fix property for usb2 phy supply on rk3568-evb1-v10

Michael Riesch <michael.riesch@wolfvision.net>
    arm64: dts: rockchip: fix property for usb2 phy supply on rock-3a

Liang He <windhl@126.com>
    dmaengine: ti: k3-udma-private: Fix refcount leak bug in of_xudma_dev_get()

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8ulp: add #reset-cells for pcc

Marco Felsch <m.felsch@pengutronix.de>
    arm64: dts: imx8mn: remove GPU power domain reset

zain wang <wzz@rock-chips.com>
    arm64: dts: rockchip: Set RK3399-Gru PCLK_EDP to 24 MHz

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Reverse CPLD_Dn GPIO label mapping on MX8Menlo

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: dsi: Add atomic {destroy,duplicate}_state, reset callbacks

Jagan Teki <jagan@amarulasolutions.com>
    arm64: dts: rockchip: Fix typo in lisense text for PX30.Core

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Pull up wlan wake# on Gru-Bob

Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
    arm64: dts: rockchip: Lower sd speed on quartz64-b

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix the asynchronous reset requests

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden accesses to the reset domains

Shigeru Yoshida <syoshida@redhat.com>
    batman-adv: Fix hang up with small MTU hard-interface

Will Deacon <will@kernel.org>
    vmlinux.lds.h: CFI: Reduce alignment of jump-table to function alignment

Sergey Shtylyov <s.shtylyov@omp.ru>
    arm64: topology: fix possible overflow in amu_fie_setup()

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    perf/arm-cmn: Add more bits to child node address offset field

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inject #UD on emulated XSETBV if XSAVES isn't enabled

Dr. David Alan Gilbert <dgilbert@redhat.com>
    KVM: x86: Always enable legacy FP/SSE in allowed user XFEATURES

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reinstate kvm_vcpu_arch.guest_supported_xcr0

Maurizio Lombardi <mlombard@redhat.com>
    mm: slub: fix flush_cpu_slab()/__free_slab() invocations in task context.

Chao Yu <chao.yu@oppo.com>
    mm/slub: fix to return errno if kmalloc() fails

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Add rmb after checking owner bits

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_mailbox_read() fix return value for drop = true

Peter Collingbourne <pcc@google.com>
    kasan: call kasan_malloc() from __kmalloc_*track_caller()

Juergen Gross <jgross@suse.com>
    xen/xenbus: fix xenbus_setup_ring()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Really move i915_gem_context.link under ref protection

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gem: Flush contexts on driver release

Randy Dunlap <rdunlap@infradead.org>
    riscv: fix RISCV_ISA_SVPBMT kconfig dependency warning

Al Viro <viro@zeniv.linux.org.uk>
    riscv: fix a nasty sigreturn bug...

Meng Li <Meng.Li@windriver.com>
    gpiolib: cdev: Set lineevent_state::irq after IRQ register successfully

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: mockup: Fix potential resource leakage when register a chip

Bartosz Golaszewski <brgl@bgdev.pl>
    gpio: mockup: fix NULL pointer dereference when removing debugfs

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix reading current per-tid starting sequence number for aggregation

Ard Biesheuvel <ardb@kernel.org>
    efi: libstub: check Shim mode using MokSBStateRT

Ard Biesheuvel <ardb@kernel.org>
    efi: x86: Wipe setup_data on pure EFI boot

Gil Fine <gil.fine@intel.com>
    thunderbolt: Add support for Intel Maple Ridge single port controller

William Wu <william.wu@rock-chips.com>
    usb: dwc3: core: leave default DMA if the controller does not support 64-bit DMA

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix endpoint type check

Adrian Hunter <adrian.hunter@intel.com>
    libperf evlist: Fix polling of system-wide events

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: wait for extent buffer IOs before finishing a zone

Filipe Manana <fdmanana@suse.com>
    btrfs: fix hang during unmount when stopping a space reclaim worker

Filipe Manana <fdmanana@suse.com>
    btrfs: fix hang during unmount when stopping block group reclaim worker

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix overflow for large capacity partition

Yi Liu <yi.l.liu@intel.com>
    iommu/vt-d: Check correct capability for sagaw determination

Daniel Houldsworth <dhould3@gmail.com>
    ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5530 laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS GA503R laptop

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add pincfg for ASUS G513 HP jack

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-arrange quirk table entries

Callum Osmotherly <callum.osmotherly@gmail.com>
    ALSA: hda/realtek: Enable 4-speaker output Dell Precision 5570 laptop

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek: Add quirk for Huawei WRT-WX9

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: add Intel 5 Series / 3400 PCI DID

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Fix Nvidia dp infoframe

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix hang at HD-audio codec unbinding due to refcount saturation

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: set depop delay for tegra

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix double-free at snd_card_new()

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: usb-audio: Split endpoint setups for hw_params and prepare"

jerry meng <jerry-meng@foxmail.com>
    USB: serial: option: add Quectel RM520N

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 0x0203 composition

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix RST error in hub.c

Phil Auld <pauld@redhat.com>
    drivers/base: Fix unsigned comparison to -1 in CPUMAP_FILE_MAX_BYTES

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a use-after-free

Christoph Hellwig <hch@lst.de>
    block: simplify disk shutdown

Christoph Hellwig <hch@lst.de>
    block: stop setting the nomerges flags in blk_cleanup_queue

Christoph Hellwig <hch@lst.de>
    block: remove QUEUE_FLAG_DEAD

Antony Antony <antony.antony@secunet.com>
    xfrm: fix XFRMA_LASTUSED comment

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: add quirks for Lenovo OneLink+ Dock"

Steve French <stfrench@microsoft.com>
    smb3: use filemap_write_and_wait_range instead of filemap_write_and_wait

Piyush Mehta <piyush.mehta@amd.com>
    usb: gadget: udc-xilinx: replace memcpy with memcpy_toio

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    usb: add quirks for Lenovo OneLink+ Dock

David Howells <dhowells@redhat.com>
    smb3: fix temporary data corruption in insert range

Steve French <stfrench@microsoft.com>
    smb3: fix temporary data corruption in collapse range

David Howells <dhowells@redhat.com>
    smb3: Move the flush out of smb2_copychunk_range() into its callers

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dsi: filter invalid backlight and CABC ports

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Split VBT data into per-panel vs. global parts

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Split VBT parsing to global vs. panel specific parts

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/bios: Split parse_driver_features() into two parts

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/pps: Split pps_init_delays() into distinct parts

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Extract intel_edp_fixup_vbt_bpp()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/lan966x.dtsi                     |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts  |  10 +-
 .../boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts |   1 -
 .../arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi |   1 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  10 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   1 -
 .../boot/dts/freescale/imx8mp-venice-gw74xx.dts    |  12 +-
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi         |   3 +
 .../boot/dts/rockchip/px30-engicam-px30-core.dtsi  |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-gru-bob.dts    |   5 +
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |   9 +
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   1 -
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts |   1 -
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts   |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts    |   2 +-
 arch/arm64/kernel/topology.c                       |   2 +-
 arch/mips/lantiq/clk.c                             |   1 +
 arch/mips/loongson32/common/platform.c             |  16 +-
 arch/riscv/Kconfig                                 |   1 +
 arch/riscv/kernel/signal.c                         |   2 +
 arch/um/kernel/um_arch.c                           |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kvm/cpuid.c                               |  11 +-
 arch/x86/kvm/emulate.c                             |   3 +
 arch/x86/kvm/x86.c                                 |  10 +-
 block/blk-core.c                                   |  43 ---
 block/blk-mq-debugfs.c                             |   8 +-
 block/blk-mq.c                                     |  43 ++-
 block/blk-sysfs.c                                  |   5 -
 block/blk.h                                        |   3 +
 block/bsg-lib.c                                    |   4 +-
 block/genhd.c                                      |  45 ++-
 certs/Kconfig                                      |   2 +-
 drivers/block/ataflop.c                            |   1 -
 drivers/block/loop.c                               |   1 -
 drivers/block/mtip32xx/mtip32xx.c                  |   2 -
 drivers/block/rnbd/rnbd-clt.c                      |   2 +-
 drivers/block/sx8.c                                |   4 +-
 drivers/block/virtio_blk.c                         |   1 -
 drivers/block/z2ram.c                              |   1 -
 drivers/cdrom/gdrom.c                              |   1 -
 drivers/dax/hmem/device.c                          |   1 +
 drivers/dma/ti/k3-udma-private.c                   |   6 +-
 drivers/firmware/arm_scmi/reset.c                  |  10 +-
 drivers/firmware/efi/libstub/secureboot.c          |   8 +-
 drivers/firmware/efi/libstub/x86-stub.c            |   7 +
 drivers/gpio/gpio-ixp4xx.c                         |  17 +-
 drivers/gpio/gpio-mockup.c                         |   6 +-
 drivers/gpio/gpio-mt7621.c                         |  21 +-
 drivers/gpio/gpio-tqmx86.c                         |   4 +-
 drivers/gpio/gpiolib-cdev.c                        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c             |   9 +
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |   3 +-
 .../amd/display/dc/dml/dcn31/display_mode_vba_31.c | 420 +++++----------------
 .../drm/amd/display/modules/color/color_gamma.c    |   4 +
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  11 +
 drivers/gpu/drm/gma500/cdv_device.c                |   4 +-
 drivers/gpu/drm/gma500/gem.c                       |   4 +-
 drivers/gpu/drm/gma500/gma_display.c               |  11 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |   5 +-
 drivers/gpu/drm/gma500/power.c                     |   8 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   2 +-
 drivers/gpu/drm/gma500/psb_drv.h                   |   5 +-
 drivers/gpu/drm/gma500/psb_irq.c                   |  15 +-
 drivers/gpu/drm/gma500/psb_irq.h                   |   2 +-
 drivers/gpu/drm/hisilicon/hibmc/Kconfig            |   1 +
 drivers/gpu/drm/i915/display/g4x_dp.c              |  22 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |  18 +-
 drivers/gpu/drm/i915/display/intel_backlight.c     |  23 +-
 drivers/gpu/drm/i915/display/intel_bios.c          | 384 ++++++++++---------
 drivers/gpu/drm/i915/display/intel_bios.h          |   4 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |  22 +-
 drivers/gpu/drm/i915/display/intel_ddi_buf_trans.c |   9 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |  69 ++++
 drivers/gpu/drm/i915/display/intel_dp.c            |  40 +-
 drivers/gpu/drm/i915/display/intel_dp.h            |   2 +
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |   6 +-
 drivers/gpu/drm/i915/display/intel_drrs.c          |   3 -
 drivers/gpu/drm/i915/display/intel_dsi.c           |   2 +-
 .../gpu/drm/i915/display/intel_dsi_dcs_backlight.c |   9 +-
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |  56 +--
 drivers/gpu/drm/i915/display/intel_lvds.c          |   6 +-
 drivers/gpu/drm/i915/display/intel_panel.c         |  13 +-
 drivers/gpu/drm/i915/display/intel_pps.c           |  70 +++-
 drivers/gpu/drm/i915/display/intel_psr.c           |  35 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c          |   3 +
 drivers/gpu/drm/i915/display/vlv_dsi.c             |  21 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |   8 +-
 drivers/gpu/drm/i915/i915_drv.h                    |  63 ----
 drivers/gpu/drm/i915/i915_gem.c                    |   3 +-
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c        |   2 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |  24 +-
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   5 +-
 drivers/hv/vmbus_drv.c                             |  10 +-
 drivers/i2c/busses/i2c-imx.c                       |   2 +-
 drivers/i2c/busses/i2c-mlxbf.c                     |  68 ++--
 drivers/i2c/i2c-mux.c                              |   5 +-
 drivers/iommu/intel/iommu.c                        |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/memstick/core/ms_block.c                   |   1 -
 drivers/memstick/core/mspro_block.c                |   1 -
 drivers/mmc/core/block.c                           |   1 -
 drivers/mmc/core/queue.c                           |   1 -
 drivers/net/bonding/bond_3ad.c                     |   5 +-
 drivers/net/bonding/bond_main.c                    |  72 ++--
 drivers/net/can/flexcan/flexcan-core.c             |  10 +-
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/freescale/enetc/Makefile      |   1 -
 drivers/net/ethernet/freescale/enetc/enetc.c       |  53 +--
 drivers/net/ethernet/freescale/enetc/enetc.h       |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  32 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  23 ++
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |  17 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  32 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  20 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   7 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  42 ++-
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   5 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |   6 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |  10 +
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +
 drivers/net/ethernet/renesas/sh_eth.c              |   2 +
 drivers/net/ethernet/sfc/efx_channels.c            |   2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |   2 +-
 drivers/net/ethernet/sfc/siena/tx.c                |   2 +-
 drivers/net/ethernet/sfc/tx.c                      |   2 +-
 drivers/net/ethernet/sun/sunhme.c                  |   4 +-
 drivers/net/ipa/ipa_qmi.c                          |   8 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |   8 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |  37 +-
 drivers/net/ipa/ipa_table.c                        |   2 -
 drivers/net/ipa/ipa_table.h                        |   3 +
 drivers/net/ipvlan/ipvlan_core.c                   |   6 +-
 drivers/net/mdio/of_mdio.c                         |   1 +
 drivers/net/netdevsim/hwstats.c                    |   6 +-
 drivers/net/phy/aquantia_main.c                    |  53 ++-
 drivers/net/phy/micrel.c                           |  18 +-
 drivers/net/team/team.c                            |  24 +-
 drivers/net/wireguard/netlink.c                    |  13 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |  25 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   2 +-
 drivers/nvdimm/pmem.c                              |   6 +-
 drivers/nvme/host/apple.c                          |   2 +-
 drivers/nvme/host/core.c                           |   1 -
 drivers/nvme/host/fc.c                             |  12 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/rdma.c                           |  12 +-
 drivers/nvme/host/tcp.c                            |  12 +-
 drivers/nvme/target/loop.c                         |  12 +-
 drivers/perf/arm-cmn.c                             |   2 +-
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c       |  87 +----
 drivers/s390/block/dasd.c                          |   2 +-
 drivers/s390/block/dasd_alias.c                    |   9 +-
 drivers/s390/block/dasd_genhd.c                    |   4 +-
 drivers/scsi/hosts.c                               |  16 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   4 +-
 drivers/scsi/scsi_lib.c                            |  12 +-
 drivers/scsi/scsi_priv.h                           |   2 +-
 drivers/scsi/scsi_scan.c                           |   1 +
 drivers/scsi/scsi_sysfs.c                          |   3 +-
 drivers/scsi/sd.c                                  |   4 +-
 drivers/scsi/sr.c                                  |   4 +-
 drivers/thunderbolt/icm.c                          |   1 +
 drivers/thunderbolt/nhi.h                          |   1 +
 drivers/tty/serial/fsl_lpuart.c                    |   9 +-
 drivers/tty/serial/serial-tegra.c                  |   5 +-
 drivers/tty/serial/tegra-tcu.c                     |   2 +-
 drivers/ufs/core/ufshcd.c                          |   4 +-
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc3/core.c                            |  13 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/xen/xenbus/xenbus_client.c                 |   9 +-
 fs/btrfs/disk-io.c                                 |  42 ++-
 fs/btrfs/zoned.c                                   |  40 +-
 fs/cifs/cifsfs.c                                   |   6 +
 fs/cifs/smb2ops.c                                  |  69 ++--
 fs/dax.c                                           |   3 +
 fs/exfat/fatent.c                                  |   3 +-
 fs/ext4/ext4.h                                     |  10 +-
 fs/ext4/extents.c                                  |   4 +
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/mballoc.c                                  | 318 +++++++---------
 fs/ext4/mballoc.h                                  |   1 -
 include/asm-generic/vmlinux.lds.h                  |   3 +-
 include/linux/blk-mq.h                             |   3 +
 include/linux/blkdev.h                             |   6 +-
 include/linux/cpumask.h                            |   5 +-
 include/linux/serial_core.h                        |  17 +
 include/net/bond_3ad.h                             |   2 -
 include/net/bonding.h                              |   3 +
 include/scsi/scsi_host.h                           |   2 +
 include/uapi/linux/xfrm.h                          |   2 +-
 io_uring/io_uring.c                                |   3 +
 kernel/cgroup/cgroup.c                             |   5 +-
 kernel/workqueue.c                                 |   6 +-
 lib/Kconfig.debug                                  |   4 +-
 mm/slab_common.c                                   |   5 +-
 mm/slub.c                                          |  18 +-
 net/batman-adv/hard-interface.c                    |   4 +
 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/core/flow_dissector.c                          |   5 +-
 net/ipv6/af_inet6.c                                |   4 +-
 net/netfilter/nf_conntrack_ftp.c                   |   6 +-
 net/netfilter/nf_conntrack_irc.c                   |  34 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nfnetlink_osf.c                      |   4 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/sch_taprio.c                             |  18 +-
 net/smc/smc_core.c                                 |   5 +-
 scripts/Makefile.debug                             |  21 +-
 sound/core/init.c                                  |  10 +-
 sound/pci/hda/hda_bind.c                           |   4 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                         |  24 +-
 sound/pci/hda/patch_realtek.c                      |  33 +-
 sound/usb/endpoint.c                               |  23 +-
 sound/usb/endpoint.h                               |   6 +-
 sound/usb/pcm.c                                    |  14 +-
 tools/lib/perf/evlist.c                            |   5 +-
 tools/perf/util/bpf_counter_cgroup.c               |   4 +-
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c        |   2 +-
 tools/perf/util/genelf.c                           |  14 +
 tools/perf/util/genelf.h                           |   4 +
 tools/perf/util/symbol-elf.c                       |   7 +-
 tools/perf/util/synthetic-events.c                 |  17 +-
 tools/testing/selftests/net/forwarding/sch_red.sh  |   1 +
 241 files changed, 2013 insertions(+), 1656 deletions(-)


