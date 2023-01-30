Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9459681110
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbjA3OJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbjA3OJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7843B0F3;
        Mon, 30 Jan 2023 06:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4B161083;
        Mon, 30 Jan 2023 14:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC6FC433AE;
        Mon, 30 Jan 2023 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087789;
        bh=hJN/OQhxiK3wl99bBX+csyIXChdhHxqVoM1X+N2PTYA=;
        h=From:To:Cc:Subject:Date:From;
        b=HFu7Bhq5MpLjSGe7BfAR+rM/wXsszX4IqGgMBfPn0m3r/r7ihkcOfVGlxfJGwvJiW
         9iAynZUi3remwU7yOoA8N/hPYG8RsAEHsrhtM7s2l7j2Igc4kLrpT1HrLjdQA7aDm4
         igiVy5CqvvcQQDja0/h+fx7HZa05yZokX/FDpp1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/204] 5.15.91-rc1 review
Date:   Mon, 30 Jan 2023 14:49:25 +0100
Message-Id: <20230130134316.327556078@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.91-rc1
X-KernelTest-Deadline: 2023-02-01T13:43+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.91 release.
There are 204 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.91-rc1

Colin Ian King <colin.i.king@gmail.com>
    perf/x86/amd: fix potential integer overflow on shift of a int

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: unify established states for SCTP paths

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Christoph Hellwig <hch@lst.de>
    block: fix and cleanup bio_check_ro

Chun-Tse Shao <ctshao@google.com>
    kbuild: Allow kernel installation packaging to override pkg-config

Kevin Hao <haokexin@gmail.com>
    cpufreq: governor: Use kobject release() method to free dbs_data

Kevin Hao <haokexin@gmail.com>
    cpufreq: Move to_gov_attr_set() to cpufreq.h

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Ivo Borisov Shopov <ivoshopov@gmail.com>
    tools: gpio: fix -c option of gpio-event-mon

Linus Torvalds <torvalds@linux-foundation.org>
    treewide: fix up files incorrectly marked executable

Jerome Brunet <jbrunet@baylibre.com>
    net: mdio-mux-meson-g12a: force internal PHY off on mux switch

David Christensen <drc@linux.vnet.ibm.com>
    net/tg3: resolve deadlock in tg3_reset_task() during EEH

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: mark socks as dead on unhash, prevent re-add

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix possible hang if RIS2_QFF1 happen

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix lack of register setting after system resumed for Gen3

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables

Dan Carpenter <error27@gmail.com>
    gpio: mxc: Unlock on error path in mxc_flip_edge()

Keith Busch <kbusch@kernel.org>
    nvme: fix passthrough csi check

Liao Chang <liaochang1@huawei.com>
    riscv/kprobe: Fix instruction simulation of JALR

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

Arnd Bergmann <arnd@arndb.de>
    drm/i915/selftest: fix intel_selftest_modify_policy argument types

Paolo Abeni <pabeni@redhat.com>
    net: fix UaF in netns ops registration error path

Eric Dumazet <edumazet@google.com>
    netlink: prevent potential spectre v1 gadgets

Lareine Khawaly <lareine@amazon.com>
    i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Johan Hovold <johan+linaro@kernel.org>
    scsi: ufs: core: Fix devfreq deadlocks

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Fix IRQ name - add PCI and queue number

Manivannan Sadhasivam <mani@kernel.org>
    EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Manivannan Sadhasivam <mani@kernel.org>
    EDAC/device: Respect any driver-supplied workqueue polling value

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Gergely Risko <gergely.risko@gmail.com>
    ipv6: fix reachability confirmation with proxy_ndp

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: Protect trip temperature from concurrent updates

Marc Zyngier <maz@kernel.org>
    KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

Hendrik Borghorst <hborghor@amazon.de>
    KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fail on invalid uid/gid mapping at copy up

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit pdu length size according to connection status

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: downgrade ndr version error message to debug

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: do not sign response to session request for guest login

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add max connections parameter

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add smbd max io size parameter

Chris Morgan <macromorgan@hotmail.com>
    i2c: mv64xxx: Add atomic_xfer method to driver

Chris Morgan <macromorgan@hotmail.com>
    i2c: mv64xxx: Remove shutdown method from driver

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

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: SVM: fix tsc scaling cache logic

Alexey V. Vissarionov <gremlin@altlinux.org>
    scsi: hpsa: Fix allocation size for scsi_host_alloc()

Harsh Jain <harsh.jain@amd.com>
    drm/amdgpu: complete gfxoff allow signal during suspend without delay

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

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Remove unused variable

Sasha Levin <sashal@kernel.org>
    Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Thomas Zimmermann <tzimmermann@suse.de>
    drm/i915: Allow switching away via vga-switcheroo if uninitialized

Kees Cook <keescook@chromium.org>
    firmware: coreboot: Check size of table entry and use flex-array

Mateusz Guzik <mjguzik@gmail.com>
    lockref: stop doing cpu_relax in the cmpxchg loop

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK

Michael Klein <m.klein@mvz-labor-lb.de>
    platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Andre Przywara <andre.przywara@arm.com>
    r8152: add vendor/device ID pair for Microsoft Devkit

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

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Add Emerald Rapids

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Emerald Rapids

Alexander Gordeev <agordeev@linux.ibm.com>
    s390: expicitly align _edata and _end symbols on page boundary

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/debug: add _ASM_S390_ prefix to header guard

Patrick Thompson <ptf@google.com>
    drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Hui Wang <hui.wang@canonical.com>
    net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_micfil: Correct the number of steps on SX controls

Konrad Dybcio <konrad.dybcio@linaro.org>
    cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist

Max Filippov <jcmvbkbc@gmail.com>
    kcsan: test: don't put the expect array on the stack

Sumit Gupta <sumitg@nvidia.com>
    cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Wenchao Hao <haowenchao@huawei.com>
    scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

David Morley <morleyd@google.com>
    tcp: fix rate_app_limited to default to 1

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: enable all safety features by default

Viresh Kumar <viresh.kumar@linaro.org>
    thermal: core: call put_device() only after device_register() fails

Dan Carpenter <dan.carpenter@oracle.com>
    thermal/core: fix error code in __thermal_cooling_device_register()

Viresh Kumar <viresh.kumar@linaro.org>
    thermal: Validate new state in cur_state_store()

Daniel Lezcano <daniel.lezcano@linexp.org>
    thermal/core: Rename 'trips' to 'num_trips'

Daniel Lezcano <daniel.lezcano@linexp.org>
    thermal/core: Remove duplicate information when an error occurs

Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
    net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Willem de Bruijn <willemb@google.com>
    selftests/net: toeplitz: fix race on tpacket_v3 block close

Chen Zhongjin <chenzhongjin@huawei.com>
    driver core: Fix test_async_probe_init saves device in wrong array

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix WARNING after calling w1_process()

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix deadloop in __w1_remove_master_device()

Yang Yingliang <yangyingliang@huawei.com>
    device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()

Eric Pilmore <epilmore@gigaio.com>
    ptdma: pt_core_execute_cmd() should use spinlock

Kevin Hao <haokexin@gmail.com>
    octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt

Jason Xing <kernelxing@tencent.com>
    tcp: avoid the lookup process failing to get sk in ehash table

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix timeout request state check

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: fix issues with driver unload

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: phy-can-transceiver: Skip warning if no "max-bitrate"

Liu Shixin <liushixin2@huawei.com>
    dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Paulo Alcantara <pc@cjr.nz>
    cifs: fix potential deadlock in cache_refresh_path()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: betop: check shape of output reports

Eric Dumazet <edumazet@google.com>
    l2tp: prevent lockdep issue in l2tp_tunnel_register()

Jason Wang <jasowang@redhat.com>
    virtio-net: correctly enable callback during start_xmit

Robert Hancock <robert.hancock@calian.com>
    net: macb: fix PTP TX timestamp failure due to packet padding

Koba Ko <koba.ko@canonical.com>
    dmaengine: Fix double increment of client_count in dma_chan_get()

Arnd Bergmann <arnd@arndb.de>
    drm/panfrost: fix GENERIC_ATOMIC64 dependency

Randy Dunlap <rdunlap@infradead.org>
    net: mlx5: eliminate anonymous module_init & module_exit

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT

Caleb Connolly <caleb.connolly@linaro.org>
    net: ipa: disable ipa interrupt during suspend

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait

Jiri Kosina <jkosina@suse.cz>
    HID: revert CHERRY_MOUSE_000C quirk

Jonas Karlman <jonas@kwiboo.se>
    pinctrl: rockchip: fix mux route data for rk3568

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

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

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

Kurt Kanzenbach <kurt@linutronix.de>
    net: stmmac: Fix queue statistics reading

Jonas Karlman <jonas@kwiboo.se>
    pinctrl: rockchip: fix reading pull type on rk3568

Sebastian Reichel <sebastian.reichel@collabora.com>
    pinctrl/rockchip: add error handling for pull/drive register getters

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl/rockchip: Use temporary variable for struct device

Szymon Heidrich <szymon.heidrich@gmail.com>
    wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

Marek Vasut <marex@denx.de>
    gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Marek Vasut <marex@denx.de>
    gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock

Schspa Shi <schspa@gmail.com>
    gpio: use raw spinlock for gpio chip shadowed data

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

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

Xingyuan Mo <hdthky0@gmail.com>
    NFSD: fix use-after-free in nfsd4_ssc_setup_dul()

Randy Dunlap <rdunlap@infradead.org>
    phy: ti: fix Kconfig warning and operator precedence

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8992-libra: Fix the memory map

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8992-libra: Add CPU regulators

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8992: Don't use sfpb mutex

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

Hui Tang <tanghui20@huawei.com>
    reset: uniphier-glue: Fix possible null-ptr-deref

Philipp Zabel <p.zabel@pengutronix.de>
    reset: uniphier-glue: Use reset_control_bulk API

Miaoqian Lin <linmq006@gmail.com>
    soc: imx8m: Fix incorrect check for of_clk_get_by_name()

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity

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

Fabio Estevam <festevam@denx.de>
    arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property

Jayesh Choudhary <j-choudhary@ti.com>
    dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()

Ashish Mhetre <amhetre@nvidia.com>
    memory: tegra: Remove clients SID override programming


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-oops_count  |   6 +
 Documentation/ABI/testing/sysfs-kernel-warn_count  |   6 +
 Documentation/admin-guide/sysctl/kernel.rst        |  19 ++
 Makefile                                           |   7 +-
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
 .../boot/dts/freescale/imx8mm-venice-gw7901.dts    |   1 +
 .../boot/dts/freescale/imx8mp-phycore-som.dtsi     |  10 -
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts  |  90 +++++-
 arch/arm64/boot/dts/qcom/msm8992.dtsi              |   4 -
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  25 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |   8 +-
 arch/arm64/kvm/vgic/vgic.h                         |   1 +
 arch/arm64/mm/fault.c                              |   2 +-
 arch/csky/abiv1/alignment.c                        |   2 +-
 arch/csky/kernel/traps.c                           |   2 +-
 arch/csky/mm/fault.c                               |   2 +-
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
 arch/powerpc/kernel/traps.c                        |   8 +-
 arch/riscv/kernel/probes/simulate-insn.c           |   4 +-
 arch/riscv/kernel/traps.c                          |   2 +-
 arch/riscv/mm/fault.c                              |   2 +-
 arch/s390/include/asm/debug.h                      |   6 +-
 arch/s390/kernel/dumpstack.c                       |   2 +-
 arch/s390/kernel/nmi.c                             |   2 +-
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/sh/kernel/traps.c                             |   2 +-
 arch/sparc/kernel/traps_32.c                       |   4 +-
 arch/sparc/kernel/traps_64.c                       |   4 +-
 arch/x86/entry/entry_32.S                          |   6 +-
 arch/x86/entry/entry_64.S                          |   6 +-
 arch/x86/events/amd/core.c                         |   2 +-
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/events/msr.c                              |   1 +
 arch/x86/kernel/acpi/cstate.c                      |  15 +
 arch/x86/kernel/dumpstack.c                        |   4 +-
 arch/x86/kernel/i8259.c                            |   1 +
 arch/x86/kernel/irqinit.c                          |   4 +-
 arch/x86/kvm/svm/svm.c                             |  34 ++-
 arch/x86/kvm/svm/svm.h                             |   1 +
 arch/x86/kvm/vmx/vmx.c                             |  21 +-
 arch/xtensa/kernel/traps.c                         |   2 +-
 block/blk-core.c                                   |   8 +-
 drivers/base/property.c                            |  18 +-
 drivers/base/test/test_async_driver_probe.c        |   2 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   2 +
 drivers/cpufreq/cpufreq_governor.c                 |  20 +-
 drivers/cpufreq/cpufreq_governor.h                 |   1 +
 drivers/cpufreq/cpufreq_governor_attr_set.c        |   5 -
 drivers/dma/dmaengine.c                            |   7 +-
 drivers/dma/ptdma/ptdma-dev.c                      |   7 +-
 drivers/dma/ptdma/ptdma.h                          |   2 +-
 drivers/dma/ti/k3-udma.c                           |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   4 +-
 drivers/edac/edac_device.c                         |  15 +-
 drivers/edac/highbank_mc_edac.c                    |   7 +-
 drivers/edac/qcom_edac.c                           |   5 +-
 drivers/firmware/arm_scmi/shmem.c                  |   9 +-
 drivers/firmware/google/coreboot_table.c           |   9 +-
 drivers/firmware/google/coreboot_table.h           |   1 +
 drivers/gpio/gpio-amdpt.c                          |  10 +-
 drivers/gpio/gpio-brcmstb.c                        |  12 +-
 drivers/gpio/gpio-cadence.c                        |  12 +-
 drivers/gpio/gpio-dwapb.c                          |  36 +--
 drivers/gpio/gpio-grgpio.c                         |  30 +-
 drivers/gpio/gpio-hlwd.c                           |  18 +-
 drivers/gpio/gpio-idt3243x.c                       |  12 +-
 drivers/gpio/gpio-ixp4xx.c                         |   4 +-
 drivers/gpio/gpio-loongson1.c                      |   8 +-
 drivers/gpio/gpio-menz127.c                        |   8 +-
 drivers/gpio/gpio-mlxbf2.c                         |   6 +-
 drivers/gpio/gpio-mmio.c                           |  22 +-
 drivers/gpio/gpio-mxc.c                            |  16 +-
 drivers/gpio/gpio-sifive.c                         |  12 +-
 drivers/gpio/gpio-tb10x.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  10 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 -
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   1 -
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/i915/i915_drv.c                    |   5 +-
 drivers/gpu/drm/i915/i915_switcheroo.c             |   6 +-
 .../drm/i915/selftests/intel_scheduler_helpers.c   |   3 +-
 drivers/gpu/drm/panfrost/Kconfig                   |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h          |   0
 drivers/hid/hid-betopff.c                          |  17 +-
 drivers/hid/hid-bigbenff.c                         |   5 +
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-quirks.c                           |   1 -
 drivers/hid/intel-ish-hid/ishtp/dma-if.c           |  10 +
 drivers/i2c/busses/i2c-designware-common.c         |   9 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |  61 +++-
 drivers/infiniband/core/verbs.c                    |   7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          | 200 +++++++++----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h          |   3 +
 drivers/input/mouse/synaptics.c                    |   1 -
 drivers/memory/atmel-sdramc.c                      |   6 +-
 drivers/memory/mvebu-devbus.c                      |   3 +-
 drivers/memory/tegra/tegra186.c                    |  36 ---
 drivers/net/dsa/microchip/ksz9477.c                |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  23 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  24 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   2 +
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/cadence/macb_main.c           |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/microsoft/mana/gdma.h         |   3 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   9 +-
 drivers/net/ethernet/renesas/ravb.h                |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  36 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |  14 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 drivers/net/ipa/ipa_interrupt.c                    |  10 +
 drivers/net/ipa/ipa_interrupt.h                    |  16 +
 drivers/net/ipa/ipa_power.c                        |  17 ++
 drivers/net/mdio/mdio-mux-meson-g12a.c             |  23 +-
 drivers/net/phy/mdio_bus.c                         |   7 +-
 drivers/net/usb/cdc_ether.c                        |   6 +
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/usb/sr9700.c                           |   2 +-
 drivers/net/virtio_net.c                           |   6 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   6 +-
 drivers/net/wireless/rndis_wlan.c                  |  19 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/phy/phy-can-transceiver.c                  |   5 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |   4 +-
 drivers/phy/ti/Kconfig                             |   4 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c          |   8 +-
 drivers/pinctrl/pinctrl-rockchip.c                 | 315 ++++++++++---------
 drivers/pinctrl/pinctrl-rockchip.h                 |   4 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |  25 ++
 drivers/reset/reset-uniphier-glue.c                |  37 +--
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   2 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  50 +++-
 drivers/scsi/ufs/ufshcd.c                          |  26 +-
 drivers/scsi/ufs/ufshcd.h                          |   2 +
 drivers/soc/imx/soc-imx8m.c                        |   4 +-
 drivers/soc/qcom/cpr.c                             |   6 +-
 drivers/spi/spidev.c                               |   2 -
 drivers/thermal/gov_fair_share.c                   |  10 +-
 drivers/thermal/gov_power_allocator.c              |   4 +-
 .../intel/int340x_thermal/int340x_thermal_zone.c   |  28 +-
 .../intel/int340x_thermal/int340x_thermal_zone.h   |   1 +
 drivers/thermal/tegra/tegra30-tsensor.c            |   2 +-
 drivers/thermal/thermal_core.c                     |  53 ++--
 drivers/thermal/thermal_helpers.c                  |   4 +-
 drivers/thermal/thermal_netlink.c                  |   2 +-
 drivers/thermal/thermal_sysfs.c                    |  33 +-
 drivers/usb/gadget/function/f_fs.c                 |   7 +
 drivers/w1/w1.c                                    |   6 +-
 drivers/w1/w1_int.c                                |   5 +-
 fs/affs/file.c                                     |   2 +-
 fs/cifs/dfs_cache.c                                |  42 +--
 fs/cifs/smbdirect.c                                |   1 +
 fs/ksmbd/connection.c                              |  17 +-
 fs/ksmbd/ksmbd_netlink.h                           |   4 +-
 fs/ksmbd/ndr.c                                     |   8 +-
 fs/ksmbd/server.h                                  |   1 +
 fs/ksmbd/smb2pdu.c                                 |   2 +
 fs/ksmbd/smb2pdu.h                                 |   5 +-
 fs/ksmbd/transport_ipc.c                           |   6 +
 fs/ksmbd/transport_rdma.c                          |   8 +-
 fs/ksmbd/transport_rdma.h                          |   6 +
 fs/ksmbd/transport_tcp.c                           |  17 +-
 fs/nfsd/nfs4proc.c                                 |   1 +
 fs/overlayfs/copy_up.c                             |   4 +
 fs/proc/proc_sysctl.c                              |  33 ++
 fs/reiserfs/super.c                                |   6 -
 include/linux/cpufreq.h                            |   5 +
 include/linux/gpio/driver.h                        |   2 +-
 include/linux/panic.h                              |   7 +-
 include/linux/sched/task.h                         |   1 +
 include/linux/sysctl.h                             |   3 +
 include/linux/thermal.h                            |   5 +-
 include/net/sch_generic.h                          |   7 +
 include/net/sock.h                                 |   2 +-
 include/scsi/scsi_transport_iscsi.h                |   9 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   2 +-
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   2 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/exit.c                                      |  72 +++++
 kernel/kcsan/kcsan_test.c                          |   7 +-
 kernel/kcsan/report.c                              |   3 +-
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
 mm/kfence/report.c                                 |   3 +-
 net/bluetooth/hci_core.c                           |   1 +
 net/bluetooth/rfcomm/sock.c                        |   7 +-
 net/core/net_namespace.c                           |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +
 net/ipv4/inet_hashtables.c                         |  17 +-
 net/ipv4/inet_timewait_sock.c                      |   8 +-
 net/ipv4/metrics.c                                 |   2 +
 net/ipv4/tcp.c                                     |   2 +
 net/ipv6/ip6_output.c                              |  15 +-
 net/l2tp/l2tp_core.c                               | 116 +++----
 net/mctp/af_mctp.c                                 |   1 +
 net/mctp/route.c                                   |   6 +
 net/netfilter/nf_conntrack_proto_sctp.c            | 122 ++++----
 net/netfilter/nf_conntrack_standalone.c            |   8 -
 net/netfilter/nft_set_rbtree.c                     | 332 +++++++++++++--------
 net/netlink/af_netlink.c                           |  38 ++-
 net/netrom/nr_timer.c                              |   1 +
 net/nfc/llcp_core.c                                |   1 +
 net/sched/sch_htb.c                                |  27 +-
 net/sched/sch_taprio.c                             |   2 +
 net/sctp/bind_addr.c                               |   6 +
 scripts/Makefile                                   |   4 +-
 scripts/dtc/Makefile                               |   6 +-
 scripts/kconfig/gconf-cfg.sh                       |  12 +-
 scripts/kconfig/mconf-cfg.sh                       |  16 +-
 scripts/kconfig/nconf-cfg.sh                       |  16 +-
 scripts/kconfig/qconf-cfg.sh                       |  14 +-
 scripts/tracing/ftrace-bisect.sh                   |  34 ++-
 security/tomoyo/Makefile                           |   2 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/fsl/fsl_micfil.c                         |  16 +-
 sound/soc/fsl/fsl_ssi.c                            |   4 +-
 tools/gpio/gpio-event-mon.c                        |   1 +
 tools/objtool/Makefile                             |   4 +-
 tools/objtool/check.c                              |   3 +-
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 -
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 ---
 tools/testing/selftests/net/toeplitz.c             |  12 +-
 274 files changed, 2175 insertions(+), 1322 deletions(-)


