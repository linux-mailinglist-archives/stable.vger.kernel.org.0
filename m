Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8747268129A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbjA3OXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbjA3OXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:23:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9A53FF33;
        Mon, 30 Jan 2023 06:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48B68B811D2;
        Mon, 30 Jan 2023 14:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ED6C433EF;
        Mon, 30 Jan 2023 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088460;
        bh=JuLvzdOiWZIqxC9gDPqO0mKtqu2Ghc8nTjOnMbVbokU=;
        h=From:To:Cc:Subject:Date:From;
        b=EZSGfxsnOckrtH60zq6iMDCxLX3NiAFrJY45U/0kUJjc0oFC0mqx42bClemRxwogK
         AKI8r7gjd6QRD+WNdNHTgJM7lft4N1qer7Hvvkg+TA+OaEaCZsOkVPKDt2WhzBTWrW
         mkx6TOfxgg4nfpTtEdVEegYkqNJEcgfgwqrWmBBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/143] 5.10.166-rc1 review
Date:   Mon, 30 Jan 2023 14:50:57 +0100
Message-Id: <20230130134306.862721518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.166-rc1
X-KernelTest-Deadline: 2023-02-01T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.166 release.
There are 143 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.166-rc1

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    clk: Fix pointer casting to prevent oops in devm_clk_release()

Colin Ian King <colin.i.king@gmail.com>
    perf/x86/amd: fix potential integer overflow on shift of a int

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: unify established states for SCTP paths

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Christoph Hellwig <hch@lst.de>
    block: fix and cleanup bio_check_ro

Zheng Yejian <zhengyejian1@huawei.com>
    Revert "selftests/ftrace: Update synthetic event syntax errors"

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted

Karol Herbst <kherbst@redhat.com>
    nouveau: explicitly wait on the fence in nouveau_bo_move_m2mf

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Ivo Borisov Shopov <ivoshopov@gmail.com>
    tools: gpio: fix -c option of gpio-event-mon

Jerome Brunet <jbrunet@baylibre.com>
    net: mdio-mux-meson-g12a: force internal PHY off on mux switch

David Christensen <drc@linux.vnet.ibm.com>
    net/tg3: resolve deadlock in tg3_reset_task() during EEH

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix possible hang if RIS2_QFF1 happen

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fail if no bound addresses can be used for a given scope

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: do not schedule in taprio_reset()

Kuniyuki Iwashima <kuniyu@amazon.com>
    netrom: Fix use-after-free of a listening socket.

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: fix bug in for_each_sctp_chunk

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE

Eric Dumazet <edumazet@google.com>
    ipv4: prevent potential spectre v1 gadget in fib_metrics_match()

Eric Dumazet <edumazet@google.com>
    ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around sk_state

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around dst_portid and dst_group

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->portid

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: Switch to node list walk for overlap detection

Paolo Abeni <pabeni@redhat.com>
    net: fix UaF in netns ops registration error path

Eric Dumazet <edumazet@google.com>
    netlink: prevent potential spectre v1 gadgets

Lareine Khawaly <lareine@amazon.com>
    i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: designware: Use DIV_ROUND_CLOSEST() macro

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    units: Add SI metric prefix definitions

Daniel Lezcano <daniel.lezcano@linaro.org>
    units: Add Watt units

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    EDAC/device: Respect any driver-supplied workqueue polling value

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: Protect trip temperature from concurrent updates

Hendrik Borghorst <hborghor@amazon.de>
    KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

David Howells <dhowells@redhat.com>
    cifs: Fix oops due to uncleared server->smbd_conn in reconnect

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/scripts: Update the instructions for ftrace-bisect.sh

Natalia Petrova <n.petrova@fintech.ru>
    trace_events_hist: add check for return value of 'create_hist_field'

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make sure trace_printk() can output as soon as it can be used

Petr Pavlu <petr.pavlu@suse.com>
    module: Don't wait for GOING modules

Alexey V. Vissarionov <gremlin@altlinux.org>
    scsi: hpsa: Fix allocation size for scsi_host_alloc()

Kishon Vijay Abraham I <kishon@ti.com>
    xhci: Set HCD flag to defer primary roothub registration

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Kees Cook <keescook@chromium.org>
    exit: Use READ_ONCE() for all oops/warn limit reads

Kees Cook <keescook@chromium.org>
    docs: Fix path paste-o for /sys/kernel/warn_count

Kees Cook <keescook@chromium.org>
    panic: Expose "warn_count" to sysfs

Kees Cook <keescook@chromium.org>
    panic: Introduce warn_limit

Kees Cook <keescook@chromium.org>
    panic: Consolidate open-coded panic_on_warn checks

Kees Cook <keescook@chromium.org>
    exit: Allow oops_limit to be disabled

Kees Cook <keescook@chromium.org>
    exit: Expose "oops_count" to sysfs

Jann Horn <jannh@google.com>
    exit: Put an upper limit on how often we can oops

Kees Cook <keescook@chromium.org>
    panic: Separate sysctl logic from CONFIG_SMP

Randy Dunlap <rdunlap@infradead.org>
    ia64: make IA64_MCA_RECOVERY bool instead of tristate

Nathan Chancellor <nathan@kernel.org>
    csky: Fix function name in csky_alignment() and die()

Nathan Chancellor <nathan@kernel.org>
    h8300: Fix build errors from do_exit() to make_task_dead() transition

Nathan Chancellor <nathan@kernel.org>
    hexagon: Fix function name in die()

Eric W. Biederman <ebiederm@xmission.com>
    objtool: Add a missing comma to avoid string concatenation

Eric W. Biederman <ebiederm@xmission.com>
    exit: Add and use make_task_dead.

Tiezhu Yang <yangtiezhu@loongson.cn>
    kasan: no need to unset panic_on_warn in end_report()

Tiezhu Yang <yangtiezhu@loongson.cn>
    ubsan: no need to unset panic_on_warn in ubsan_epilogue()

Tiezhu Yang <yangtiezhu@loongson.cn>
    panic: unset panic_on_warn inside panic()

tangmeng <tangmeng@uniontech.com>
    kernel/panic: move panic sysctls to its own file

Xiaoming Ni <nixiaoming@huawei.com>
    sysctl: add a new register_sysctl_init() interface

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: reiserfs: remove useless new_opts in reiserfs_remount

Deepak Sharma <deepak.sharma@amd.com>
    x86: ACPI: cstate: Optimize C3 entry on AMD CPUs

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

Sasha Levin <sashal@kernel.org>
    Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Mateusz Guzik <mjguzik@gmail.com>
    lockref: stop doing cpu_relax in the cmpxchg loop

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK

Michael Klein <m.klein@mvz-labor-lb.de>
    platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: interrupt: use READ_ONCE() before cmpxchg()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    spi: spidev: remove debug messages that access spidev->spi without locking

Mark Brown <broonie@kernel.org>
    ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets

Mark Brown <broonie@kernel.org>
    ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC

Miles Chen <miles.chen@mediatek.com>
    cpufreq: armada-37xx: stop using 0 as NULL pointer

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/debug: add _ASM_S390_ prefix to header guard

Patrick Thompson <ptf@google.com>
    drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_micfil: Correct the number of steps on SX controls

Max Filippov <jcmvbkbc@gmail.com>
    kcsan: test: don't put the expect array on the stack

Sumit Gupta <sumitg@nvidia.com>
    cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Wenchao Hao <haowenchao@huawei.com>
    scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

David Morley <morleyd@google.com>
    tcp: fix rate_app_limited to default to 1

Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
    net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Chen Zhongjin <chenzhongjin@huawei.com>
    driver core: Fix test_async_probe_init saves device in wrong array

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix WARNING after calling w1_process()

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix deadloop in __w1_remove_master_device()

Jason Xing <kernelxing@tencent.com>
    tcp: avoid the lookup process failing to get sk in ehash table

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix timeout request state check

Liu Shixin <liushixin2@huawei.com>
    dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: betop: check shape of output reports

Eric Dumazet <edumazet@google.com>
    l2tp: prevent lockdep issue in l2tp_tunnel_register()

Robert Hancock <robert.hancock@calian.com>
    net: macb: fix PTP TX timestamp failure due to packet padding

Koba Ko <koba.ko@canonical.com>
    dmaengine: Fix double increment of client_count in dma_chan_get()

Arnd Bergmann <arnd@arndb.de>
    drm/panfrost: fix GENERIC_ATOMIC64 dependency

Randy Dunlap <rdunlap@infradead.org>
    net: mlx5: eliminate anonymous module_init & module_exit

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait

Jiri Kosina <jkosina@suse.cz>
    HID: revert CHERRY_MOUSE_000C quirk

Heiner Kallweit <hkallweit1@gmail.com>
    net: stmmac: fix invalid call to mdiobus_get_phy()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: check empty report_list in bigben_probe()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: check empty report_list in hid_validate_values()

Heiner Kallweit <hkallweit1@gmail.com>
    net: mdio: validate parameter addr in mdiobus_get_phy()

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: sr9700: Handle negative len

Cong Wang <cong.wang@bytedance.com>
    l2tp: close all race conditions in l2tp_tunnel_register()

Cong Wang <cong.wang@bytedance.com>
    l2tp: convert l2tp_tunnel_list to idr

Jakub Sitnicki <jakub@cloudflare.com>
    l2tp: Don't sleep and disable BH under writer-side sk_callback_lock

Jakub Sitnicki <jakub@cloudflare.com>
    l2tp: Serialize access to sk_user_data with sk_callback_lock

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: fix possible use-after-free

Szymon Heidrich <szymon.heidrich@gmail.com>
    wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

Marek Vasut <marex@denx.de>
    gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Esina Ekaterina <eesina@astralinux.ru>
    net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    net: nfc: Fix use-after-free in local_cleanup()

Shang XiaoJing <shangxiaojing@huawei.com>
    phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Luis Gerhorst <gerhorst@cs.fau.de>
    bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Delay AN timeout during KR training

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60

Randy Dunlap <rdunlap@infradead.org>
    phy: ti: fix Kconfig warning and operator precedence

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()

Alexander Potapenko <glider@google.com>
    affs: initialize fsdata in affs_truncate()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Remove user expected buffer invalidate race

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Immediately remove invalid memory from hardware

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Fix expected receive setup error exit issues

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Reserve user expected TIDs

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Reject a zero-length user expected buffer

Yonatan Nachum <ynachum@amazon.com>
    RDMA/core: Fix ib block iterator counter overflow

Masahiro Yamada <masahiroy@kernel.org>
    tomoyo: fix broken dependency on *.conf.default

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden shared memory access in fetch_notification

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden shared memory access in fetch_response

Miaoqian Lin <linmq006@gmail.com>
    EDAC/highbank: Fix memory leak in highbank_mc_probe()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    ARM: imx: add missing of_node_put()

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx7d-pico: Use 'clock-frequency'

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6ul-pico-dwarf: Use 'clock-frequency'

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    clk: Provide new devm_clk helpers for prepared and enabled clocks

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    clk: generalize devm_clk_get() a bit


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-oops_count  |   6 +
 Documentation/ABI/testing/sysfs-kernel-warn_count  |   6 +
 Documentation/admin-guide/sysctl/kernel.rst        |  19 ++
 Makefile                                           |   4 +-
 arch/alpha/kernel/traps.c                          |   6 +-
 arch/alpha/mm/fault.c                              |   2 +-
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi              |   1 -
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts            |   2 +-
 arch/arm/boot/dts/imx7d-pico-dwarf.dts             |   4 +-
 arch/arm/boot/dts/imx7d-pico-nymph.dts             |   4 +-
 arch/arm/boot/dts/sam9x60.dtsi                     |   2 +-
 arch/arm/kernel/traps.c                            |   2 +-
 arch/arm/mach-imx/cpu-imx25.c                      |   1 +
 arch/arm/mach-imx/cpu-imx27.c                      |   1 +
 arch/arm/mach-imx/cpu-imx31.c                      |   1 +
 arch/arm/mach-imx/cpu-imx35.c                      |   1 +
 arch/arm/mach-imx/cpu-imx5.c                       |   1 +
 arch/arm/mm/fault.c                                |   2 +-
 arch/arm/mm/nommu.c                                |   2 +-
 .../dts/freescale/imx8mm-beacon-baseboard.dtsi     |   4 +-
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/mm/fault.c                              |   2 +-
 arch/csky/abiv1/alignment.c                        |   2 +-
 arch/csky/kernel/traps.c                           |   2 +-
 arch/h8300/kernel/traps.c                          |   3 +-
 arch/h8300/mm/fault.c                              |   2 +-
 arch/hexagon/kernel/traps.c                        |   2 +-
 arch/ia64/Kconfig                                  |   2 +-
 arch/ia64/kernel/mca_drv.c                         |   2 +-
 arch/ia64/kernel/traps.c                           |   2 +-
 arch/ia64/mm/fault.c                               |   2 +-
 arch/m68k/kernel/traps.c                           |   2 +-
 arch/m68k/mm/fault.c                               |   2 +-
 arch/microblaze/kernel/exceptions.c                |   4 +-
 arch/mips/kernel/traps.c                           |   2 +-
 arch/nds32/kernel/fpu.c                            |   2 +-
 arch/nds32/kernel/traps.c                          |   8 +-
 arch/nios2/kernel/traps.c                          |   4 +-
 arch/openrisc/kernel/traps.c                       |   2 +-
 arch/parisc/kernel/traps.c                         |   2 +-
 arch/powerpc/kernel/traps.c                        |   2 +-
 arch/riscv/kernel/traps.c                          |   2 +-
 arch/riscv/mm/fault.c                              |   2 +-
 arch/s390/include/asm/debug.h                      |   6 +-
 arch/s390/kernel/dumpstack.c                       |   2 +-
 arch/s390/kernel/nmi.c                             |   2 +-
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/sh/kernel/traps.c                             |   2 +-
 arch/sparc/kernel/traps_32.c                       |   4 +-
 arch/sparc/kernel/traps_64.c                       |   4 +-
 arch/x86/entry/entry_32.S                          |   6 +-
 arch/x86/entry/entry_64.S                          |   6 +-
 arch/x86/events/amd/core.c                         |   2 +-
 arch/x86/kernel/acpi/cstate.c                      |  15 +
 arch/x86/kernel/dumpstack.c                        |   4 +-
 arch/x86/kernel/i8259.c                            |   1 +
 arch/x86/kernel/irqinit.c                          |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  21 +-
 arch/xtensa/kernel/traps.c                         |   2 +-
 block/blk-core.c                                   |   4 +-
 drivers/base/test/test_async_driver_probe.c        |   2 +-
 drivers/clk/clk-devres.c                           |  91 +++++-
 drivers/cpufreq/armada-37xx-cpufreq.c              |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/dma/dmaengine.c                            |   7 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   4 +-
 drivers/edac/edac_device.c                         |  15 +-
 drivers/edac/highbank_mc_edac.c                    |   7 +-
 drivers/edac/qcom_edac.c                           |   5 +-
 drivers/firmware/arm_scmi/shmem.c                  |   9 +-
 drivers/gpio/gpio-mxc.c                            |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   9 +
 drivers/gpu/drm/panfrost/Kconfig                   |   3 +-
 drivers/hid/hid-betopff.c                          |  17 +-
 drivers/hid/hid-bigbenff.c                         |   5 +
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-quirks.c                           |   1 -
 drivers/hid/intel-ish-hid/ishtp/dma-if.c           |  10 +
 drivers/i2c/busses/i2c-designware-common.c         |  11 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   5 +-
 drivers/infiniband/core/verbs.c                    |   7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          | 200 +++++++++----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h          |   3 +
 drivers/input/mouse/synaptics.c                    |   1 -
 drivers/memory/atmel-sdramc.c                      |   6 +-
 drivers/memory/mvebu-devbus.c                      |   3 +-
 drivers/net/dsa/microchip/ksz9477.c                |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  23 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  24 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   2 +
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/cadence/macb_main.c           |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 drivers/net/mdio/mdio-mux-meson-g12a.c             |  23 +-
 drivers/net/phy/mdio_bus.c                         |   7 +-
 drivers/net/usb/sr9700.c                           |   2 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   6 +-
 drivers/net/wireless/rndis_wlan.c                  |  19 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |   4 +-
 drivers/phy/ti/Kconfig                             |   4 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |  25 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   2 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  50 +++-
 drivers/soc/qcom/cpr.c                             |   6 +-
 drivers/spi/spidev.c                               |   2 -
 .../intel/int340x_thermal/int340x_thermal_zone.c   |  28 +-
 .../intel/int340x_thermal/int340x_thermal_zone.h   |   1 +
 drivers/usb/gadget/function/f_fs.c                 |   7 +
 drivers/usb/host/xhci.c                            |   2 +
 drivers/w1/w1.c                                    |   6 +-
 drivers/w1/w1_int.c                                |   5 +-
 fs/affs/file.c                                     |   2 +-
 fs/cifs/smbdirect.c                                |   1 +
 fs/nfsd/netns.h                                    |   6 +-
 fs/nfsd/nfs4state.c                                |   8 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/nfsd/nfsd.h                                     |   3 +-
 fs/nfsd/nfssvc.c                                   |  35 ++-
 fs/proc/proc_sysctl.c                              |  33 ++
 fs/reiserfs/super.c                                |   6 -
 include/linux/clk.h                                | 109 +++++++
 include/linux/kernel.h                             |   7 +-
 include/linux/sched/task.h                         |   1 +
 include/linux/sysctl.h                             |   3 +
 include/linux/units.h                              |  20 ++
 include/net/sch_generic.h                          |   7 +
 include/net/sock.h                                 |   2 +-
 include/scsi/scsi_transport_iscsi.h                |   9 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   2 +-
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   2 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/exit.c                                      |  72 +++++
 kernel/kcsan/kcsan-test.c                          |   7 +-
 kernel/kcsan/report.c                              |   4 +-
 kernel/module.c                                    |  26 +-
 kernel/panic.c                                     |  90 +++++-
 kernel/sched/core.c                                |   3 +-
 kernel/sysctl.c                                    |  11 -
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace.h                               |   1 +
 kernel/trace/trace_events_hist.c                   |   2 +
 kernel/trace/trace_output.c                        |   3 +-
 lib/lockref.c                                      |   1 -
 lib/nlattr.c                                       |   3 +
 lib/ubsan.c                                        |  11 +-
 mm/kasan/report.c                                  |  12 +-
 net/bluetooth/hci_core.c                           |   1 +
 net/core/net_namespace.c                           |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +
 net/ipv4/inet_hashtables.c                         |  17 +-
 net/ipv4/inet_timewait_sock.c                      |   8 +-
 net/ipv4/metrics.c                                 |   2 +
 net/ipv4/tcp.c                                     |   2 +
 net/l2tp/l2tp_core.c                               | 116 +++----
 net/netfilter/nf_conntrack_proto_sctp.c            | 122 ++++----
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +
 net/netfilter/nf_conntrack_standalone.c            |   8 -
 net/netfilter/nft_set_rbtree.c                     | 332 +++++++++++++--------
 net/netlink/af_netlink.c                           |  38 ++-
 net/netrom/nr_timer.c                              |   1 +
 net/nfc/llcp_core.c                                |   1 +
 net/sched/sch_taprio.c                             |   2 +
 net/sctp/bind_addr.c                               |   6 +
 scripts/tracing/ftrace-bisect.sh                   |  34 ++-
 security/tomoyo/Makefile                           |   2 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/fsl/fsl_micfil.c                         |  16 +-
 sound/soc/fsl/fsl_ssi.c                            |   4 +-
 tools/gpio/gpio-event-mon.c                        |   1 +
 tools/objtool/check.c                              |   3 +-
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 -
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 ---
 .../trigger-synthetic_event_syntax_errors.tc       |  35 +--
 180 files changed, 1532 insertions(+), 767 deletions(-)


