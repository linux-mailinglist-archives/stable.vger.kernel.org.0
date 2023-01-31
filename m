Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182C1682599
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 08:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjAaHe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 02:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjAaHeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 02:34:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4751E30EAB;
        Mon, 30 Jan 2023 23:34:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EAC613EA;
        Tue, 31 Jan 2023 07:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506B0C433D2;
        Tue, 31 Jan 2023 07:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675150452;
        bh=Mr0wbgaG4as4Z9ZQdLPGB1BOIHUCTAfePJzuMQmEdc8=;
        h=From:To:Cc:Subject:Date:From;
        b=d2GTRBvJNXcLsSkyZKp3WHbiQULvHoqz3eoAvKw7f+xQIuizZecuhiVrvuDhjSZ63
         a2QYpR1aDdlCqTUrp3GfT2Tq11yY2MzneYw9QJMKN8RbCqUq/LEfrGOzrC792GpgFH
         nNBiBKZURk0orK6fZJq/u70a2KZVPuAk9Fu3VFIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/306] 6.1.9-rc3 review
Date:   Tue, 31 Jan 2023 08:34:09 +0100
Message-Id: <20230131072621.746783417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.9-rc3
X-KernelTest-Deadline: 2023-02-02T07:26+00:00
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

This is the start of the stable review cycle for the 6.1.9 release.
There are 306 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.9-rc3

Dave Airlie <airlied@redhat.com>
    amdgpu: fix build on non-DCN platforms.

Colin Ian King <colin.i.king@gmail.com>
    perf/x86/amd: fix potential integer overflow on shift of a int

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: unify established states for SCTP paths

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    dt-bindings: i2c: renesas,rzv2m: Fix SoC specific string

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Conor Dooley <conor.dooley@microchip.com>
    dt-bindings: riscv: fix single letter canonical order

Conor Dooley <conor.dooley@microchip.com>
    dt-bindings: riscv: fix underscore requirement for multi-letter extensions

Juergen Gross <jgross@suse.com>
    acpi: Fix suspend with Xen PV

Nikunj A Dadhania <nikunj@amd.com>
    x86/sev: Add SEV-SNP guest feature negotiation support

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Vlastimil Babka <vbabka@suse.cz>
    Revert "mm/compaction: fix set skip in fast_find_migrateblock"

Linus Torvalds <torvalds@linux-foundation.org>
    Fix up more non-executable files marked executable

Ivo Borisov Shopov <ivoshopov@gmail.com>
    tools: gpio: fix -c option of gpio-event-mon

Linus Torvalds <torvalds@linux-foundation.org>
    treewide: fix up files incorrectly marked executable

Ming Lei <ming.lei@redhat.com>
    block: ublk: move ublk_chr_class destroying after devices are removed

Robin Murphy <robin.murphy@arm.com>
    Partially revert "perf/arm-cmn: Optimise DTC counter accesses"

Jerome Brunet <jbrunet@baylibre.com>
    net: mdio-mux-meson-g12a: force internal PHY off on mux switch

Gerhard Engleder <gerhard@engleder-embedded.com>
    tsnep: Fix TX queue stop/wake for multiple queues

David Christensen <drc@linux.vnet.ibm.com>
    net/tg3: resolve deadlock in tg3_reset_task() during EEH

Ley Foon Tan <leyfoon.tan@starfivetech.com>
    riscv: Move call to init_cpu_topology() to later initialization stage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: mark socks as dead on unhash, prevent re-add

Paolo Abeni <pabeni@redhat.com>
    net: mctp: hold key reference when looking up a general key

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: move expiry timer delete to unhash

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: add an explicit reference from a mctp_sk_key to sock

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix possible hang if RIS2_QFF1 happen

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix lack of register setting after system resumed for Gen3

Nikita Shubin <nikita.shubin@maquefel.me>
    gpio: ep93xx: Fix port F hwirq numbers in handler

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

Chuang Wang <nashuiliang@gmail.com>
    tracing/osnoise: Use built-in RCU list checking

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Fix apple gmux detection

Hans de Goede <hdegoede@redhat.com>
    platform/x86: apple-gmux: Add apple_gmux_detect() helper

Hans de Goede <hdegoede@redhat.com>
    platform/x86: apple-gmux: Move port defines to apple-gmux.h

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Fix kbd_dock_devid tablet-switch reporting

Kuniyuki Iwashima <kuniyu@amazon.com>
    netrom: Fix use-after-free of a listening socket.

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE

Alexandru Tachici <alexandru.tachici@analog.com>
    net: ethernet: adi: adin1110: Fix multicast offloading

Ahmad Fatoum <a.fatoum@pengutronix.de>
    net: dsa: microchip: fix probe of I2C-connected KSZ8563

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

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for Asus U46E

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for HP EliteBook 8460p

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for HP Pavilion g6-1d80nr

Arnd Bergmann <arnd@arndb.de>
    drm/i915/selftest: fix intel_selftest_modify_policy argument types

Ross Lagerwall <ross.lagerwall@citrix.com>
    nvme-fc: fix initialization order

Christoph Hellwig <hch@lst.de>
    nvme: consolidate setting the tagset flags

Christoph Hellwig <hch@lst.de>
    nvme: simplify transport specific device attribute handling

Wei Fang <wei.fang@nxp.com>
    net: fec: Use page_pool_put_full_page when freeing rx buffers

Paolo Abeni <pabeni@redhat.com>
    net: fix UaF in netns ops registration error path

Eric Dumazet <edumazet@google.com>
    netlink: prevent potential spectre v1 gadgets

Stefan Assmann <sassmann@kpanic.de>
    iavf: schedule watchdog immediately when changing primary MAC

Michal Schmidt <mschmidt@redhat.com>
    iavf: fix temporary deadlock and failure to set MAC address

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Fix a memory leak with reused mmap_offset

Nirmoy Das <nirmoy.das@intel.com>
    drm/drm_vma_manager: Add drm_vma_node_allow_once()

Richard Fitzgerald <rf@opensource.cirrus.com>
    i2c: designware: Fix unbalanced suspended flag

Lareine Khawaly <lareine@amazon.com>
    i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Dylan Yudaken <dylany@meta.com>
    io_uring: always prep_async for drain requests

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Fix IRQ name - add PCI and queue number

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: inline __io_req_complete_put()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: remove io_req_tw_post_queue

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: use io_req_task_complete() in timeout

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: hold locks for io_req_complete_failed

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: inline __io_req_complete_post()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: inline io_req_task_work_add()

Wayne Lin <Wayne.Lin@amd.com>
    drm/amdgpu/display/mst: update mst_mgr relevant variable when long HPD

Wayne Lin <Wayne.Lin@amd.com>
    drm/amdgpu/display/mst: limit payload to be updated one by one

Lyude Paul <lyude@redhat.com>
    drm/amdgpu/display/mst: Fix mst_state->pbn_div and slot count assignments

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdgpu: remove unconditional trap enable on add gfx11 queues

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add missing AllowIHInterrupt message mapping for SMU13.0.0

Wayne Lin <Wayne.Lin@amd.com>
    drm/display/dp_mst: Correct the kref of port.

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Fix profile modes on Intel platforms

Manivannan Sadhasivam <mani@kernel.org>
    EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Manivannan Sadhasivam <mani@kernel.org>
    EDAC/device: Respect any driver-supplied workqueue polling value

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Gergely Risko <gergely.risko@gmail.com>
    ipv6: fix reachability confirmation with proxy_ndp

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    regulator: dt-bindings: samsung,s2mps14: add lost samsung,ext-control-gpios

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: Protect trip temperature from concurrent updates

Masahiro Yamada <masahiroy@kernel.org>
    riscv: fix -Wundef warning for CONFIG_RISCV_BOOT_SPINWAIT

Johan Hovold <johan+linaro@kernel.org>
    scsi: ufs: core: Fix devfreq deadlocks

Marc Zyngier <maz@kernel.org>
    KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

Hendrik Borghorst <hborghor@amazon.de>
    KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Jens Axboe <axboe@kernel.dk>
    io_uring/net: cache provided buffer group value for multishot receives

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fail on invalid uid/gid mapping at copy up

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix tmpfile leak

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit pdu length size according to connection status

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: downgrade ndr version error message to debug

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: do not sign response to session request for guest login

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add max connections parameter

David Howells <dhowells@redhat.com>
    cifs: Fix oops due to uncleared server->smbd_conn in reconnect

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/scripts: Update the instructions for ftrace-bisect.sh

Natalia Petrova <n.petrova@fintech.ru>
    trace_events_hist: add check for return value of 'create_hist_field'

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make sure trace_printk() can output as soon as it can be used

Mark Rutland <mark.rutland@arm.com>
    ftrace: Export ftrace_free_filter() to modules

Petr Pavlu <petr.pavlu@suse.com>
    module: Don't wait for GOING modules

Jeff Layton <jlayton@kernel.org>
    nfsd: don't free files unconditionally in __nfsd_file_cache_purge

Yi Liu <yi.l.liu@intel.com>
    kvm/vfio: Fix potential deadlock on vfio group_lock

Alexey V. Vissarionov <gremlin@altlinux.org>
    scsi: hpsa: Fix allocation size for scsi_host_alloc()

Niklas Schnelle <schnelle@linux.ibm.com>
    vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

Qais Yousef <qyousef@layalina.io>
    sched/uclamp: Fix a uninitialized variable warnings

Pierre Gondois <pierre.gondois@arm.com>
    sched/fair: Check if prev_cpu has highest spare cap in feec()

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: mac80211: Fix iTXQ AMPDU fragmentation handling

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: mac80211: Proper mark iTXQs for resumption

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/msg_ring: fix remote queue to disabled ring

Harsh Jain <harsh.jain@amd.com>
    drm/amdgpu: complete gfxoff allow signal during suspend without delay

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Allow alternate fixed modes always for eDP

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Allow panel fixed modes to have differing sync polarities

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Account for the EFI runtime stack in stack unwinder

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Avoid workqueue to check whether EFI runtime is live

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Recover from synchronous exceptions occurring in firmware

Sasha Levin <sashal@kernel.org>
    Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: enable metadata over-commit for non-ZNS setup

Kees Cook <keescook@chromium.org>
    firmware: coreboot: Check size of table entry and use flex-array

Peter Foley <pefoley2@pefoley.com>
    ata: pata_cs5535: Don't build on UML

Mateusz Guzik <mjguzik@gmail.com>
    lockref: stop doing cpu_relax in the cmpxchg loop

Henning Schild <henning.schild@siemens.com>
    platform/x86: simatic-ipc: add another model

Henning Schild <henning.schild@siemens.com>
    platform/x86: simatic-ipc: correct name of a model

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: asus-wmi: Ignore fan on E410MA

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: asus-wmi: Add quirk wmi_ignore_fan

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: asus-nb-wmi: Add alternate mapping for KEY_CAMERA

Michael Klein <m.klein@mvz-labor-lb.de>
    platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Andre Przywara <andre.przywara@arm.com>
    r8152: add vendor/device ID pair for Microsoft Devkit

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Use abort task set to reset SAS disks when discovered

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: interrupt: use READ_ONCE() before cmpxchg()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    spi: spidev: remove debug messages that access spidev->spi without locking

Paulo Alcantara <pc@cjr.nz>
    cifs: fix potential memory leaks in session setup

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: Fix NULL pointer error for GC 11.0.1 on mGPU

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: Add sync after creating vram bo

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA

Mark Brown <broonie@kernel.org>
    ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets

Mark Brown <broonie@kernel.org>
    ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC

Miles Chen <miles.chen@mediatek.com>
    cpufreq: armada-37xx: stop using 0 as NULL pointer

Willy Tarreau <w@1wt.eu>
    tools/nolibc: prevent gcc from making memset() loop over itself

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix missing includes causing build issues at -O0

Warner Losh <imp@bsdimp.com>
    tools/nolibc: Fix S_ISxxx macros

Sven Schnelle <svens@linux.ibm.com>
    nolibc: fix fd_set type

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Add Emerald Rapids

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Emerald Rapids

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Meteor Lake support

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/cstate: Add Meteor Lake support

Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>
    xen/pvcalls: free active map buffer on pvcalls_front_free_map

Alexander Gordeev <agordeev@linux.ibm.com>
    s390: expicitly align _edata and _end symbols on page boundary

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/debug: add _ASM_S390_ prefix to header guard

Patrick Thompson <ptf@google.com>
    drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Hui Wang <hui.wang@canonical.com>
    net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Avoid gx gbit halt during rpm suspend

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_micfil: Correct the number of steps on SX controls

Konrad Dybcio <konrad.dybcio@linaro.org>
    cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist

Max Filippov <jcmvbkbc@gmail.com>
    kcsan: test: don't put the expect array on the stack

Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>
    ASoC: support machine driver with max98360

Aniol Martí <aniol@aniolmarti.cat>
    ASoC: amd: yc: Add ASUS M5402RA into DMI table

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    ASoC: mediatek: mt8186: Add machine support for max98357a

tongjian <tongjian@huaqin.corp-partner.google.com>
    ASoC: mediatek: mt8186: support rt5682s_max98360

Sumit Gupta <sumitg@nvidia.com>
    cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Pierre Gondois <pierre.gondois@arm.com>
    cpufreq: CPPC: Add u64 casts to avoid overflowing

Witold Sadowski <wsadowski@marvell.com>
    spi: cadence: Fix busy cycles calculation

Wim Van Boven <wimvanboven@gmail.com>
    ASoC: amd: yc: Add Razer Blade 14 2022 into DMI table

Curtis Malainey <cujomalainey@chromium.org>
    ASoC: SOF: Add FW state to debugfs

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: pm: Always tear down pipelines before DSP suspend

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: pm: Set target state earlier

Wenchao Hao <haowenchao@huawei.com>
    scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

David Morley <morleyd@google.com>
    tcp: fix rate_app_limited to default to 1

Kees Cook <keescook@chromium.org>
    bnxt: Do not read past the end of test names

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: enable all safety features by default

Viresh Kumar <viresh.kumar@linaro.org>
    thermal: core: call put_device() only after device_register() fails

Dan Carpenter <error27@gmail.com>
    thermal/core: fix error code in __thermal_cooling_device_register()

Viresh Kumar <viresh.kumar@linaro.org>
    thermal: Validate new state in cur_state_store()

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

Arnd Bergmann <arnd@arndb.de>
    usb: dwc3: fix extcon dependency

Jason Xing <kernelxing@tencent.com>
    tcp: avoid the lookup process failing to get sk in ehash table

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix timeout request state check

Jakub Kicinski <kuba@kernel.org>
    net: sched: gred: prevent races when adding offloads to stats

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: fix issues with driver unload

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: phy-can-transceiver: Skip warning if no "max-bitrate"

Akhil R <akhilrajeev@nvidia.com>
    dmaengine: tegra: Fix memory leak in terminate_all()

Liu Shixin <liushixin2@huawei.com>
    dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Paulo Alcantara <pc@cjr.nz>
    cifs: fix potential deadlock in cache_refresh_path()

Chris Wilson <chris.p.wilson@linux.intel.com>
    drm/i915/selftests: Unwind hugepages to drop wakeref on error

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

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Fix switchdev mode after devlink reload

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Set decap action based on attr for sample

Maor Dickman <maord@nvidia.com>
    net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Avoid false lock dependency warning on tc_ht even more

Caleb Connolly <caleb.connolly@linaro.org>
    net: ipa: disable ipa interrupt during suspend

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix Invalid wait context

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix possible circular locking dependency

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Avoid circular locking dependency

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: hci_conn: Fix memory leaks

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Bluetooth: Fix a buffer overflow in mgmt_mesh_add()

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: handle tcp challenge acks during connection reuse

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait

Jack Pham <quic_jackp@quicinc.com>
    usb: ucsi: Ensure connector delayed work items are flushed

Guoqing Jiang <guoqing.jiang@linux.dev>
    block/rnbd-clt: fix wrong max ID in ida_alloc_max

Jiri Kosina <jkosina@suse.cz>
    HID: revert CHERRY_MOUSE_000C quirk

Patrice Chotard <patrice.chotard@foss.st.com>
    ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp151a-prtt1l

Patrice Chotard <patrice.chotard@foss.st.com>
    ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp157c-emstamp-argon

Patrice Chotard <patrice.chotard@foss.st.com>
    ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp15xx-dhcom-som

Patrice Chotard <patrice.chotard@foss.st.com>
    ARM: dts: stm32: Fix qspi pinctrl phandle for stm32mp15xx-dhcor-som

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

Cong Wang <cong.wang@bytedance.com>
    l2tp: close all race conditions in l2tp_tunnel_register()

Cong Wang <cong.wang@bytedance.com>
    l2tp: convert l2tp_tunnel_list to idr

Eric Dumazet <edumazet@google.com>
    net/sched: sch_taprio: fix possible use-after-free

Kurt Kanzenbach <kurt@linutronix.de>
    net: stmmac: Fix queue statistics reading

Jonas Karlman <jonas@kwiboo.se>
    pinctrl: rockchip: fix reading pull type on rk3568

Szymon Heidrich <szymon.heidrich@gmail.com>
    wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

Marek Vasut <marex@denx.de>
    gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Marek Vasut <marex@denx.de>
    gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb

Clément Léger <clement.leger@bootlin.com>
    net: lan966x: add missing fwnode_handle_put() for ports node

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

Esina Ekaterina <eesina@astralinux.ru>
    net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    net: nfc: Fix use-after-free in local_cleanup()

Shang XiaoJing <shangxiaojing@huawei.com>
    phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: bo: Fix unused variable warning

Luis Gerhorst <gerhorst@cs.fau.de>
    bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Delay AN timeout during KR training

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent

Tonghao Zhang <tong@infragraf.org>
    bpf: hash map, avoid deadlock with suitable hash mask

Shang XiaoJing <shangxiaojing@huawei.com>
    phy: usb: sunplus: Fix potential null-ptr-deref in sp_usb_phy_probe()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: bo: Fix drmm_mutex_init memory hog

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60

Xingyuan Mo <hdthky0@gmail.com>
    NFSD: fix use-after-free in nfsd4_ssc_setup_dul()

Rob Clark <robdclark@chromium.org>
    drm/msm/gpu: Fix potential double-free

Randy Dunlap <rdunlap@infradead.org>
    phy: ti: fix Kconfig warning and operator precedence

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix 'make modules' error when CONFIG_DEBUG_INFO_BTF_MODULES=y

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: export top-level LDFLAGS_vmlinux only to scripts/Makefile.vmlinux

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8992-libra: Fix the memory map

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

Chris Packham <chris.packham@alliedtelesis.co.nz>
    arm64: dts: marvell: AC5/AC5X: Fix address for UART1

Gao Xiang <xiang@kernel.org>
    erofs: fix kvcalloc() misuse with __GFP_NOFAIL

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    RDMA/rxe: Prevent faulty rkey generation

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    RDMA/rxe: Fix inaccurate constants in rxe_type_info

Masahiro Yamada <masahiroy@kernel.org>
    tomoyo: fix broken dependency on *.conf.default

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Fix warning unwind goto

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: msm8996: Fix regmap max_register values

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: msm8996: Provide UFS clocks to A2NoC

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix virtio channels cleanup on shutdown

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden shared memory access in fetch_notification

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden shared memory access in fetch_response

Miaoqian Lin <linmq006@gmail.com>
    EDAC/highbank: Fix memory leak in highbank_mc_probe()

Hui Tang <tanghui20@huawei.com>
    reset: uniphier-glue: Fix possible null-ptr-deref

Randy Dunlap <rdunlap@infradead.org>
    reset: ti-sci: honor TI_SCI_PROTOCOL setting when not COMPILE_TEST

Miaoqian Lin <linmq006@gmail.com>
    soc: imx8m: Fix incorrect check for of_clk_get_by_name()

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Marco Felsch <m.felsch@pengutronix.de>
    arm64: dts: imx8mp-evk: pcie0-refclk cosmetic cleanup

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix power-domain typo

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp: Fix missing GPC Interrupt

Lucas Stach <l.stach@pengutronix.de>
    soc: imx: imx8mp-blk-ctrl: don't set power device name

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    ARM: imx: add missing of_node_put()

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: imx93-11x11-evk: correct clock and strobe pad setting

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: verdin-imx8mm: fix dev board audio playback

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: verdin-imx8mm: fix dahlia audio playback

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx7d-pico: Use 'clock-frequency'

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6ul-pico-dwarf: Use 'clock-frequency'

Fabio Estevam <festevam@denx.de>
    arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property

Lucas Stach <l.stach@pengutronix.de>
    soc: imx: imx8mp-blk-ctrl: enable global pixclk with HDMI_TX_PHY PD

Jayesh Choudhary <j-choudhary@ti.com>
    dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG

Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
    dmaengine: qcom: gpi: Set link_rx bit on GO TRE for rx operation

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix primary USB-DP PHY reset

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()

Ashish Mhetre <amhetre@nvidia.com>
    memory: tegra: Remove clients SID override programming


-------------

Diffstat:

 .../devicetree/bindings/i2c/renesas,rzv2m.yaml     |   4 +-
 .../bindings/regulator/samsung,s2mps14.yaml        |  21 +-
 Documentation/devicetree/bindings/riscv/cpus.yaml  |   2 +-
 .../devicetree/bindings/sound/everest,es8326.yaml  |   0
 Documentation/x86/amd-memory-encryption.rst        |  36 +++
 Makefile                                           |  19 +-
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi              |   1 -
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts            |   2 +-
 arch/arm/boot/dts/imx7d-pico-dwarf.dts             |   4 +-
 arch/arm/boot/dts/imx7d-pico-nymph.dts             |   4 +-
 arch/arm/boot/dts/sam9x60.dtsi                     |   2 +-
 arch/arm/boot/dts/stm32mp151a-prtt1l.dtsi          |   8 +-
 arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi   |   8 +-
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi       |   8 +-
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       |   8 +-
 arch/arm/mach-imx/cpu-imx25.c                      |   1 +
 arch/arm/mach-imx/cpu-imx27.c                      |   1 +
 arch/arm/mach-imx/cpu-imx31.c                      |   1 +
 arch/arm/mach-imx/cpu-imx35.c                      |   1 +
 arch/arm/mach-imx/cpu-imx5.c                       |   1 +
 arch/arm/mm/nommu.c                                |   2 +-
 .../dts/freescale/imx8mm-beacon-baseboard.dtsi     |   4 +-
 .../boot/dts/freescale/imx8mm-venice-gw7901.dts    |   1 +
 .../boot/dts/freescale/imx8mm-verdin-dahlia.dtsi   |   1 +
 .../boot/dts/freescale/imx8mm-verdin-dev.dtsi      |   1 +
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |   4 +-
 .../boot/dts/freescale/imx8mp-phycore-som.dtsi     |  10 -
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   3 +-
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts  |   6 +-
 arch/arm64/boot/dts/marvell/ac5-98dx25xx.dtsi      |   2 +-
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts  |  77 +++--
 arch/arm64/boot/dts/qcom/msm8992.dtsi              |   4 -
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   2 +-
 arch/arm64/include/asm/efi.h                       |  17 ++
 arch/arm64/include/asm/stacktrace.h                |  15 +
 arch/arm64/kernel/efi-rt-wrapper.S                 |  38 ++-
 arch/arm64/kernel/efi.c                            |  23 ++
 arch/arm64/kernel/stacktrace.c                     |  12 +
 arch/arm64/kvm/vgic/vgic-v3.c                      |  25 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |   8 +-
 arch/arm64/kvm/vgic/vgic.h                         |   1 +
 arch/arm64/mm/fault.c                              |   4 +
 arch/riscv/kernel/head.S                           |   2 +-
 arch/riscv/kernel/probes/simulate-insn.c           |   4 +-
 arch/riscv/kernel/smpboot.c                        |   3 +-
 arch/s390/include/asm/debug.h                      |   6 +-
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/s390/kvm/interrupt.c                          |  12 +-
 arch/x86/boot/compressed/ident_map_64.c            |   6 +
 arch/x86/boot/compressed/misc.h                    |   2 +
 arch/x86/boot/compressed/sev.c                     |  70 +++++
 arch/x86/events/amd/core.c                         |   2 +-
 arch/x86/events/intel/cstate.c                     |  21 +-
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/events/msr.c                              |   3 +
 arch/x86/include/asm/acpi.h                        |   8 +
 arch/x86/include/asm/msr-index.h                   |  20 ++
 arch/x86/include/uapi/asm/svm.h                    |   6 +
 arch/x86/kernel/i8259.c                            |   1 +
 arch/x86/kernel/irqinit.c                          |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  21 +-
 drivers/acpi/resource.c                            |   7 +
 drivers/acpi/sleep.c                               |   6 +-
 drivers/acpi/video_detect.c                        |  49 +--
 drivers/ata/Kconfig                                |   1 +
 drivers/base/property.c                            |  18 +-
 drivers/base/test/test_async_driver_probe.c        |   2 +-
 drivers/block/rnbd/rnbd-clt.c                      |   2 +-
 drivers/block/ublk_drv.c                           |   7 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |   2 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  11 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   2 +
 drivers/dma/dmaengine.c                            |   7 +-
 drivers/dma/ptdma/ptdma-dev.c                      |   7 +-
 drivers/dma/ptdma/ptdma.h                          |   2 +-
 drivers/dma/qcom/gpi.c                             |   1 +
 drivers/dma/tegra186-gpc-dma.c                     |   1 +
 drivers/dma/ti/k3-udma.c                           |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   4 +-
 drivers/edac/edac_device.c                         |  15 +-
 drivers/edac/highbank_mc_edac.c                    |   7 +-
 drivers/edac/qcom_edac.c                           |   5 +-
 drivers/firmware/arm_scmi/shmem.c                  |   9 +-
 drivers/firmware/arm_scmi/virtio.c                 |   7 +-
 drivers/firmware/efi/runtime-wrappers.c            |   1 +
 drivers/firmware/google/coreboot_table.c           |   9 +-
 drivers/firmware/google/coreboot_table.h           |   1 +
 drivers/gpio/gpio-ep93xx.c                         |   2 +-
 drivers/gpio/gpio-mxc.c                            |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   1 -
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   9 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  28 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  51 +++-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 -
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  14 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   1 +
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   4 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/drm_vma_manager.c                  |  76 +++--
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +-
 drivers/gpu/drm/i915/display/intel_panel.c         |   7 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c    |   8 +-
 .../drm/i915/selftests/intel_scheduler_helpers.c   |   3 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  15 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   7 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |   1 +
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   4 +
 drivers/gpu/drm/msm/msm_gpu.c                      |   2 +
 drivers/gpu/drm/msm/msm_gpu.h                      |  12 +-
 drivers/gpu/drm/panfrost/Kconfig                   |   3 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h          |   0
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   2 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |   2 +-
 drivers/hid/hid-betopff.c                          |  17 +-
 drivers/hid/hid-bigbenff.c                         |   5 +
 drivers/hid/hid-core.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   1 -
 drivers/hid/hid-quirks.c                           |   1 -
 drivers/hid/intel-ish-hid/ishtp/dma-if.c           |  10 +
 drivers/i2c/busses/i2c-designware-common.c         |   9 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |  20 +-
 drivers/infiniband/core/verbs.c                    |   7 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          | 200 +++++++++----
 drivers/infiniband/hw/hfi1/user_exp_rcv.h          |   3 +
 drivers/infiniband/sw/rxe/rxe_param.h              |  10 +-
 drivers/infiniband/sw/rxe/rxe_pool.c               |  22 +-
 drivers/input/mouse/synaptics.c                    |   1 -
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/interconnect/qcom/msm8996.c                |  19 +-
 drivers/memory/atmel-sdramc.c                      |   6 +-
 drivers/memory/mvebu-devbus.c                      |   3 +-
 drivers/memory/tegra/tegra186.c                    |  36 ---
 drivers/net/dsa/microchip/ksz9477.c                |   4 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |   2 +-
 drivers/net/ethernet/adi/adin1110.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  23 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  24 ++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |   9 +-
 drivers/net/ethernet/broadcom/tg3.c                |   8 +-
 drivers/net/ethernet/cadence/macb_main.c           |   9 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  15 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  86 +++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/qos.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/qos.h      |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  13 +-
 drivers/net/ethernet/microsoft/mana/gdma.h         |   3 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   9 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  10 +-
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
 drivers/nvme/host/core.c                           |  25 +-
 drivers/nvme/host/fc.c                             |  20 +-
 drivers/nvme/host/nvme.h                           |  11 +-
 drivers/nvme/host/pci.c                            |  25 +-
 drivers/nvme/host/rdma.c                           |   3 +-
 drivers/nvme/host/tcp.c                            |   5 +-
 drivers/nvme/target/loop.c                         |   4 +-
 drivers/perf/arm-cmn.c                             |   7 +-
 drivers/phy/phy-can-transceiver.c                  |   5 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |   4 +-
 drivers/phy/sunplus/phy-sunplus-usb2.c             |   3 +
 drivers/phy/ti/Kconfig                             |   4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  31 +-
 drivers/platform/x86/apple-gmux.c                  |  93 ++----
 drivers/platform/x86/asus-nb-wmi.c                 |  15 +
 drivers/platform/x86/asus-wmi.c                    |  21 +-
 drivers/platform/x86/asus-wmi.h                    |   1 +
 drivers/platform/x86/simatic-ipc.c                 |   3 +-
 drivers/platform/x86/thinkpad_acpi.c               |  11 +-
 drivers/platform/x86/touchscreen_dmi.c             |  25 ++
 drivers/reset/Kconfig                              |   2 +-
 drivers/reset/reset-uniphier-glue.c                |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  50 +++-
 drivers/soc/imx/imx8mp-blk-ctrl.c                  |   7 +-
 drivers/soc/imx/soc-imx8m.c                        |   4 +-
 drivers/soc/qcom/cpr.c                             |   6 +-
 drivers/spi/spi-cadence-xspi.c                     |   5 +-
 drivers/spi/spidev.c                               |   2 -
 drivers/thermal/gov_fair_share.c                   |   6 +-
 .../intel/int340x_thermal/int340x_thermal_zone.c   |  28 +-
 .../intel/int340x_thermal/int340x_thermal_zone.h   |   1 +
 drivers/thermal/thermal_core.c                     |  25 +-
 drivers/thermal/thermal_sysfs.c                    |  11 +-
 drivers/ufs/core/ufshcd.c                          |  29 +-
 drivers/usb/dwc3/Kconfig                           |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |   7 +
 drivers/usb/typec/ucsi/ucsi.c                      |  24 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   1 +
 drivers/vfio/vfio_iommu_type1.c                    |  31 +-
 drivers/w1/w1.c                                    |   6 +-
 drivers/w1/w1_int.c                                |   5 +-
 drivers/xen/pvcalls-front.c                        |   4 +-
 fs/affs/file.c                                     |   2 +-
 fs/btrfs/ctree.h                                   |   6 +
 fs/btrfs/space-info.c                              |   3 +-
 fs/btrfs/zoned.c                                   |   2 +
 fs/cifs/cifsencrypt.c                              |   1 +
 fs/cifs/dfs_cache.c                                |  42 +--
 fs/cifs/sess.c                                     |   2 +
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/cifs/smbdirect.c                                |   1 +
 fs/erofs/zdata.c                                   |  12 +-
 fs/ksmbd/connection.c                              |  17 +-
 fs/ksmbd/ksmbd_netlink.h                           |   3 +-
 fs/ksmbd/ndr.c                                     |   8 +-
 fs/ksmbd/server.h                                  |   1 +
 fs/ksmbd/smb2pdu.c                                 |   2 +
 fs/ksmbd/smb2pdu.h                                 |   5 +-
 fs/ksmbd/transport_ipc.c                           |   3 +
 fs/ksmbd/transport_tcp.c                           |  17 +-
 fs/nfsd/filecache.c                                |  61 ++--
 fs/nfsd/nfs4proc.c                                 |   1 +
 fs/overlayfs/copy_up.c                             |   6 +-
 include/drm/drm_vma_manager.h                      |   1 +
 include/linux/apple-gmux.h                         | 109 ++++++-
 include/linux/platform_data/x86/simatic-ipc.h      |   3 +-
 include/linux/thermal.h                            |   1 +
 include/net/mac80211.h                             |   4 -
 include/net/sch_generic.h                          |   7 +
 include/scsi/scsi_transport_iscsi.h                |   9 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   2 +-
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   2 +-
 include/ufs/ufshcd.h                               |   2 +
 io_uring/io_uring.c                                |  68 ++---
 io_uring/io_uring.h                                |  16 +-
 io_uring/msg_ring.c                                |   4 +
 io_uring/net.c                                     |  11 +
 io_uring/timeout.c                                 |  10 +-
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/verifier.c                              |   4 +-
 kernel/kcsan/kcsan_test.c                          |   7 +-
 kernel/module/main.c                               |  26 +-
 kernel/sched/fair.c                                |  48 ++-
 kernel/trace/ftrace.c                              |  23 +-
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace.h                               |   1 +
 kernel/trace/trace_events_hist.c                   |   2 +
 kernel/trace/trace_osnoise.c                       |   5 +-
 kernel/trace/trace_output.c                        |   3 +-
 lib/lockref.c                                      |   1 -
 lib/nlattr.c                                       |   3 +
 mm/compaction.c                                    |   1 +
 net/bluetooth/hci_conn.c                           |  18 +-
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/hci_sync.c                           |  14 +-
 net/bluetooth/iso.c                                | 110 +++----
 net/bluetooth/mgmt_util.h                          |   2 +-
 net/bluetooth/rfcomm/sock.c                        |   7 +-
 net/core/net_namespace.c                           |   2 +-
 net/ipv4/fib_semantics.c                           |   2 +
 net/ipv4/inet_hashtables.c                         |  17 +-
 net/ipv4/inet_timewait_sock.c                      |   8 +-
 net/ipv4/metrics.c                                 |   2 +
 net/ipv4/tcp.c                                     |   2 +
 net/ipv6/ip6_output.c                              |  15 +-
 net/l2tp/l2tp_core.c                               | 102 ++++---
 net/mac80211/agg-tx.c                              |   2 -
 net/mac80211/debugfs_sta.c                         |   5 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/ht.c                                  |  37 +++
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/tx.c                                  |  30 +-
 net/mac80211/util.c                                |  20 +-
 net/mctp/af_mctp.c                                 |  10 +-
 net/mctp/route.c                                   |  34 ++-
 net/netfilter/nf_conntrack_proto_sctp.c            | 118 ++++----
 net/netfilter/nf_conntrack_proto_tcp.c             |  15 +
 net/netfilter/nf_conntrack_standalone.c            |   8 -
 net/netfilter/nft_set_rbtree.c                     | 332 +++++++++++++--------
 net/netlink/af_netlink.c                           |  38 ++-
 net/netrom/nr_timer.c                              |   1 +
 net/nfc/llcp_core.c                                |   1 +
 net/sched/sch_gred.c                               |   2 +
 net/sched/sch_htb.c                                |  27 +-
 net/sched/sch_taprio.c                             |   2 +
 net/sctp/bind_addr.c                               |   6 +
 samples/ftrace/ftrace-direct-multi-modify.c        |   1 +
 samples/ftrace/ftrace-direct-multi.c               |   1 +
 scripts/atomic/atomics.tbl                         |   0
 scripts/tracing/ftrace-bisect.sh                   |  34 ++-
 security/tomoyo/Makefile                           |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 sound/soc/codecs/es8326.c                          |   0
 sound/soc/codecs/es8326.h                          |   0
 sound/soc/fsl/fsl-asoc-card.c                      |   8 +-
 sound/soc/fsl/fsl_micfil.c                         |  16 +-
 sound/soc/fsl/fsl_ssi.c                            |   4 +-
 sound/soc/mediatek/Kconfig                         |   4 +-
 .../mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c |  22 +-
 sound/soc/sof/debug.c                              |   4 +-
 sound/soc/sof/pm.c                                 |   9 +-
 tools/gpio/gpio-event-mon.c                        |   1 +
 tools/include/nolibc/ctype.h                       |   3 +
 tools/include/nolibc/errno.h                       |   3 +
 tools/include/nolibc/signal.h                      |   3 +
 tools/include/nolibc/stdio.h                       |   3 +
 tools/include/nolibc/stdlib.h                      |   3 +
 tools/include/nolibc/string.h                      |   8 +-
 tools/include/nolibc/sys.h                         |   2 +
 tools/include/nolibc/time.h                        |   3 +
 tools/include/nolibc/types.h                       |  70 +++--
 tools/include/nolibc/unistd.h                      |   3 +
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 -
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 ---
 tools/testing/selftests/net/toeplitz.c             |  12 +-
 virt/kvm/vfio.c                                    |   6 +-
 338 files changed, 2823 insertions(+), 1519 deletions(-)


