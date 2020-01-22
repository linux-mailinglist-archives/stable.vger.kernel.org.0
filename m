Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA15145508
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgAVNSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgAVNSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:15 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D16620678;
        Wed, 22 Jan 2020 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699094;
        bh=j6FxU71TFh66URa882jcTij2Bs9PGKTZqrW5XgfP/CE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z1GykSL0BBXQ0xdno/YGi2iHjg5/j+DQP+QA8ww4BvVhXLok0XvrA3GWOdDho5dhL
         Z4xa+alHxCzgU4+nWubR7nYPy/mZB6ycA6qMm8WeUCvfvmXPF+9cNqC28UJzcErF7C
         uudXDZdyofQwWzAJZ3gRW7kJVCs3/HQI5JKGcba4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/222] 5.4.14-stable review
Date:   Wed, 22 Jan 2020 10:26:26 +0100
Message-Id: <20200122092833.339495161@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.14-rc1
X-KernelTest-Deadline: 2020-01-24T09:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.14 release.
There are 222 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.14-rc1

Eddie James <eajames@linux.ibm.com>
    hwmon: (pmbus/ibm-cffps) Fix LED blink behavior

Eddie James <eajames@linux.ibm.com>
    hwmon: (pmbus/ibm-cffps) Switch LEDs to blocking brightness call

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Anson Huang <Anson.Huang@nxp.com>
    clk: imx7ulp: Correct DDR clock mux options

Anson Huang <Anson.Huang@nxp.com>
    clk: imx7ulp: Correct system clock source option #7

Baolin Wang <baolin.wang@linaro.org>
    clk: sprd: Use IS_ERR() to validate the return value of syscon_regmap_lookup_by_phandle()

Andi Kleen <ak@linux.intel.com>
    perf script: Allow --time with --reltime

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix wrong address verification

Tzu-En Huang <tehuang@realtek.com>
    rtw88: fix potential read outside array boundary

Bart Van Assche <bvanassche@acm.org>
    scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix hdwq sgl locks and irq handling

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq

Bart Van Assche <bvanassche@acm.org>
    scsi: core: scsi_trace: Use get_unaligned_be*()

Martin Wilck <mwilck@suse.com>
    scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Huacai Chen <chenhc@lemote.com>
    scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

John Garry <john.garry@huawei.com>
    scsi: scsi_transport_sas: Fix memory leak when removing devices

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Return directly if init hardware failed

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer dereferences

Bart Van Assche <bvanassche@acm.org>
    scsi: target: core: Fix a pr_debug() argument

Pan Bian <bianpan2016@163.com>
    scsi: bnx2i: fix potential use after free

Pan Bian <bianpan2016@163.com>
    scsi: qla4xxx: fix double free bug

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Set the BIST init value before enabling BIST

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Don't create debugfs dump folder twice

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: Disallow modular build

Johannes Berg <johannes.berg@intel.com>
    um: Don't trace irqflags during shutdown

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: cfi_cmdset_0002: fix delayed error detection on HyperFlash

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: cfi_cmdset_0002: only check errors when ready in cfi_check_err_status()

Angelo Dureghello <angelo.dureghello@timesys.com>
    mtd: devices: fix mchp23k256 read and write

Sudeep Holla <sudeep.holla@arm.com>
    Revert "arm64: dts: juno: add dma-ranges property"

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix sgx sysconfig register for omap4

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: juno: Fix UART frequency

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: dts: dra7: fix cpsw mdio fck clock

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a64: Re-add PMU node

Frieder Schrempf <frieder.schrempf@kontron.de>
    ARM: dts: imx6ul-kontron-n6310-s: Disable the snvs-poweroff driver

Rob Clark <robdclark@chromium.org>
    arm64: dts: qcom: sdm845-cheza: delete zap-shader

S.j. Wang <shengjiu.wang@nxp.com>
    arm64: dts: imx8mm-evk: Assigned clocks for audio plls

Biju Das <biju.das@bp.renesas.com>
    arm64: dts: renesas: r8a774a1: Remove audio port node

Miquel Raynal <miquel.raynal@bootlin.com>
    arm64: dts: marvell: Fix CP110 NAND controller node multi-line comment alignment

Eric Dumazet <edumazet@google.com>
    tick/sched: Annotate lockless access to last_jiffies_update

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check for set_wiphy_params

Miquel Raynal <miquel.raynal@bootlin.com>
    arm64: dts: marvell: Add AP806-dual missing CPU clocks

Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
    arm64: dts: renesas: r8a77970: Fix PWM3

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: g12: fix audio fifo reg size

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: meson: axg: fix audio fifo reg size

Dan Carpenter <dan.carpenter@oracle.com>
    cw1200: Fix a signedness bug in cw1200_load_firmware()

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    arm64: dts: qcom: msm8998: Disable coresight by default

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    irqchip: Place CONFIG_SIFIVE_PLIC into the menu

Eric Dumazet <edumazet@google.com>
    tcp: refine rule to allow EPOLLOUT generation under mem pressure

Rob Herring <robh@kernel.org>
    dt-bindings: Add missing 'properties' keyword enclosing 'snps,tso'

Nathan Chancellor <natechancellor@gmail.com>
    xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Ido Schimmel <idosch@mellanox.com>
    devlink: Wait longer before warning about unset port type

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: tc: Do not setup flower filtering if RSS is enabled

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: selftests: Update status when disabling RSS

Petr Machata <petrm@mellanox.com>
    selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: selftests: Mark as fail when received VLAN ID != expected

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: selftests: Make it work in Synopsys AXS101 boards

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum_qdisc: Include MC TCs in Qdisc counters

Petr Machata <petrm@mellanox.com>
    mlxsw: spectrum: Wipe xstats.backlog of down ports

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Do not modify cloned SKBs during xmit

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sh_eth: check sh_eth_cpu_data::dual_port when dumping registers

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: allow direct upload save restore list for raven2

Navid Emamdoost <navid.emamdoost@gmail.com>
    i40e: prevent memory leak in i40e_setup_macvlans

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec

Eric Dumazet <edumazet@google.com>
    net: sched: act_ctinfo: fix memory leak

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: tag_gswip: fix typo in tagger name

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: Don't error out on disabled ports with no phy-mode

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Fixed queue mapping in internal ring map

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    net: ethernet: ave: Avoid lockdep warning

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not treat DSN (Digital Serial Number) read failure as fatal.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ipv6 RFS filter matching logic.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix NTUPLE firmware command failures.

Pengcheng Yang <yangpc@wangsu.com>
    tcp: fix marked lost packets not being retransmitted

Johan Hovold <johan@kernel.org>
    r8152: add missing endpoint sanity check

Vladis Dronov <vdronov@redhat.com>
    ptp: free ptp device pin descriptors properly

Colin Ian King <colin.king@canonical.com>
    net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Eric Dumazet <edumazet@google.com>
    net: usb: lan78xx: limit size of local TSO packets

Eric Dumazet <edumazet@google.com>
    net/sched: act_ife: initalize ife->metalist earlier

Michael Grzeschik <m.grzeschik@pengutronix.de>
    net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix soft lockup when there is not enough memory

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: pad the short frame before sending to the hardware

Alexander Lobakin <alobakin@dlink.ru>
    net: dsa: tag_qca: fix doubled Tx statistics

Cong Wang <xiyou.wangcong@gmail.com>
    net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()

Mohammed Gamal <mgamal@redhat.com>
    hv_netvsc: Fix memory leak when removing rndis device

Eric Dumazet <edumazet@google.com>
    macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix DAT candidate selection on little endian systems

Martin KaFai Lau <kafai@fb.com>
    bpftool: Fix printing incorrect pointer in btf_dump_ptr

Lorenz Bauer <lmb@cloudflare.com>
    net: bpf: Don't leak time wait and request sockets

Johan Hovold <johan@kernel.org>
    NFC: pn533: fix bulk-message timeout

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: fix flowtable list del corruption

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: store transaction list locally while requesting module

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: remove WARN and add NLA_STRING upper limits

Florian Westphal <fw@strlen.de>
    netfilter: nft_tunnel: ERSPAN_VERSION must not be null

Florian Westphal <fw@strlen.de>
    netfilter: nft_tunnel: fix null-attribute check

Eyal Birger <eyal.birger@gmail.com>
    netfilter: nat: fix ICMP header corruption on ICMP errors

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: fix a use-after-free in mtype_destroy()

Krzysztof Kozlowski <krzk@kernel.org>
    i2c: iop3xx: Fix memory leak in probe error path

Lingpeng Chen <forrest0579@gmail.com>
    bpf/sockmap: Read psock ingress_msg before sk_receive_queue

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix page refcount issue in A-MSDU decap

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix memory leak in cfg80211_cqm_rssi_update

Felix Fietkau <nbd@nbd.name>
    cfg80211: fix memory leak in nl80211_probe_mesh_link

Markus Theil <markus.theil@tu-ilmenau.de>
    cfg80211: fix deadlocks in autodisconnect work

Dmitry Osipenko <digetx@gmail.com>
    i2c: tegra: Properly disable runtime PM on driver's probe error

Dmitry Osipenko <digetx@gmail.com>
    i2c: tegra: Fix suspending in active runtime PM state

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, fix pop data with SK_DROP return code

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, tls_sw can create a plaintext buf > encrypt buf

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, msg_push_data may leave end mark in place

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap, skmsg helper overestimates push, pull, and pop bounds

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, push write_space updates through ulp updates

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap, ensure sock lock held during tear down

John Fastabend <john.fastabend@gmail.com>
    bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier simulation of ARSH under ALU32

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Reorder detect_edp_sink_caps before link settings read.

Bart Van Assche <bvanassche@acm.org>
    block: Fix the type of 'sts' in bsg_queue_rq()

Randy Dunlap <rdunlap@infradead.org>
    net: fix kernel-doc warning in <linux/netdevice.h>

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix retrans failure due to wrong destination

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix potential hanging after b/rcast changing

Geert Uytterhoeven <geert+renesas@glider.be>
    reset: Fix {of,devm}_reset_control_array_get kerneldoc return types

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Enable 16KB buffer size

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: 16KB buffer must be 16 byte aligned

Marcel Ziswiler <marcel.ziswiler@toradex.com>
    ARM: dts: imx7: Fix Toradex Colibri iMX7S 256MB NAND flash support

Jagan Teki <jagan@amarulasolutions.com>
    ARM: dts: imx6q-icore-mipi: Use 1.5 version of i.Core MX6DL

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6sll-evk: Remove incorrect power supply assignment

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6sl-evk: Remove incorrect power supply assignment

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6sx-sdb: Remove incorrect power supply assignment

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx6qdl-sabresd: Remove incorrect power supply assignment

Yang Shi <yang.shi@linux.alibaba.com>
    mm: khugepaged: add trace status description for SCAN_PAGE_HAS_PRIVATE

Wen Yang <wenyang@linux.alibaba.com>
    mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: don't free usage map when removing a re-added early section

Filipe Manana <fdmanana@suse.com>
    Btrfs: always copy scrub arguments back to user space

Josef Bacik <josef@toxicpanda.com>
    btrfs: check rw_devices, not num_devices for balance

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix memory leak in qgroup accounting

Qu Wenruo <wqu@suse.com>
    btrfs: relocation: fix reloc_root lifespan and access

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not delete mismatched root refs

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix invalid removal of root ref

Josef Bacik <josef@toxicpanda.com>
    btrfs: rework arguments of btrfs_unlink_subvol

Vlastimil Babka <vbabka@suse.cz>
    mm, debug_pagealloc: don't rely on static keys too early

Adrian Huang <ahuang12@lenovo.com>
    mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue is valid

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: fix percpu slab vmstats flushing

Kirill A. Shutemov <kirill@shutemov.name>
    mm/huge_memory.c: thp: fix conflict of above-47bit hint address and PMD alignment

Kirill A. Shutemov <kirill@shutemov.name>
    mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and PMD alignment

Jin Yao <yao.jin@linux.intel.com>
    perf report: Fix incorrectly added dimensions as switch perf data file

Waiman Long <longman@redhat.com>
    locking/lockdep: Fix buffer overrun problem in stack_trace[]

Yuya Fujita <fujita.yuya@fujitsu.com>
    perf hists: Fix variable name's inconsistency in hists__for_each() macro

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5420: Keep top G3D clocks enabled

Philipp Rudo <prudo@linux.ibm.com>
    s390/setup: Fix secure ipl message

Arvind Sankar <nivedita@alum.mit.edu>
    efi/earlycon: Fix write-combine mapping on x86

Shakeel Butt <shakeelb@google.com>
    x86/resctrl: Fix potential memory leak

YueHaibing <yuehaibing@huawei.com>
    drm/i915: Add missing include file <linux/math64.h>

Vignesh Raghavendra <vigneshr@ti.com>
    mtd: spi-nor: Fix selection of 4-byte addressing opcodes on Spansion

Long Li <longli@microsoft.com>
    scsi: storvsc: Correctly set number of hardware queues for IDE disk

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix CCA cipher key gen with clear key value function

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Disable paging at mixed mode entry

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix missing marker for snr_uncore_imc_freerunning_events

Waiman Long <longman@redhat.com>
    locking/rwsem: Fix kernel crash when spinning on RWSEM_OWNER_UNKNOWN

Tom Lendacky <thomas.lendacky@amd.com>
    x86/CPU/AMD: Ensure clearing of SME/SEV features is maintained

Qian Cai <cai@lca.pw>
    x86/resctrl: Fix an imbalance in domain_remove_cpu()

Arnd Bergmann <arnd@arndb.de>
    cpu/SMT: Fix x86 link error without CONFIG_SYSFS

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    usb: core: hub: Improved device recognition on remote wakeup

Esben Haabendal <esben@geanix.com>
    mtd: rawnand: gpmi: Restore nfc timing setup after suspend/resume

Esben Haabendal <esben@geanix.com>
    mtd: rawnand: gpmi: Fix suspend/resume problem

Christian Brauner <christian.brauner@ubuntu.com>
    ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: mptfusion: Fix double fetch bug in ioctl

Arnd Bergmann <arnd@arndb.de>
    scsi: fnic: fix invalid stack access

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_routes: allow partial routing information

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_routes: fix null dereference in ni_find_route_source()

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: handle unbound ports

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: add missing active-port sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: handle unbound ports on URB completion

Johan Hovold <johan@kernel.org>
    USB: serial: ch341: handle unbound port at reset_resume

Johan Hovold <johan@kernel.org>
    USB: serial: suppress driver bind attributes

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add support for Quectel RM500Q in QDL mode

Johan Hovold <johan@kernel.org>
    USB: serial: opticon: fix control-message timeouts

Kristian Evensen <kristian.evensen@gmail.com>
    USB: serial: option: Add support for Quectel RM500Q

Jerónimo Borque <jeronimo@borque.com.ar>
    USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Lars Möllendorf <lars.moellendorf@plating.de>
    iio: buffer: align the size of scan bytes to size of the largest element

Tomasz Duszynski <tduszyns@gmail.com>
    iio: chemical: pms7003: fix unmet triggered buffer dependency

Guido Günther <agx@sigxcpu.org>
    iio: light: vcnl4000: Fix scale for vcnl4040

Stephan Gerhold <stephan@gerhold.net>
    iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7124: Fix DT channel configuration

Mark Rutland <mark.rutland@arm.com>
    perf: Correctly handle failed perf_get_aux_event()

Arnd Bergmann <arnd@arndb.de>
    ARM: davinci: select CONFIG_RESET_CONTROLLER

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: am571x-idk: Fix gpios property to have the correct gpio number

Ikjoon Jang <ikjn@chromium.org>
    cpuidle: teo: Fix intervals[] array indexing bug

Jens Axboe <axboe@kernel.dk>
    io_uring: only allow submit from owning task

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix fuse_send_readpages() in the syncronous read case

Mikulas Patocka <mpatocka@redhat.com>
    block: fix an integer overflow in logical block size

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: r40: Allow setting parent rate for external clock outputs

Jari Ruusu <jari.ruusu@gmail.com>
    Fix built-in early-load Intel microcode alignment

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Stefan Mavrodiev <stefan@olimex.com>
    arm64: dts: allwinner: a64: olinuxino: Fix eMMC supply regulator

Stefan Mavrodiev <stefan@olimex.com>
    arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix sync-ep altsetting sanity check

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-tascam: fix corruption due to spin lock without restoration in SoftIRQ context

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix racy access for queue timer in proc read

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix fallback from protocol extension into limited functionality

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk

Marek Vasut <marex@denx.de>
    ARM: dts: imx6q-dhcom: Fix SGTL5000 VDDIO regulator connection

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7ulp: fix reg of cpu node

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix ti_sysc_find_one_clockdomain to check for to_clk_hw_omap

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix MIC BIAS Internal1

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: dfsdm: fix 16 bits record

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: sai: fix possible circular locking

Stephan Gerhold <stephan@gerhold.net>
    ASoC: msm8916-wcd-digital: Reset RX interpolation path after use

Angus Ainslie (Purism) <angus@akkea.ca>
    arm64: dts: imx8mq-librem5-devkit: use correct interrupt for the magnetometer

Kevin Hao <haokexin@gmail.com>
    Revert "gpio: thunderx: Switch to GPIOLIB_IRQCHIP"

Guenter Roeck <linux@roeck-us.net>
    clk: Don't try to enable critical clocks if prepare failed

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix iterating over clocks

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm: Change SDMA1 ahb clock for imx8mm

Yinbo Zhu <yinbo.zhu@nxp.com>
    arm64: dts: ls1028a: fix endian setting for dcfg

Alexandre Belloni <alexandre.belloni@bootlin.com>
    ARM: dts: imx6q-dhcom: fix rtc compatible

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    dt-bindings: reset: meson8b: fix duplicate reset IDs

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    soc: amlogic: meson-ee-pwrc: propagate errors from pm_genpd_init()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    soc: amlogic: meson-ee-pwrc: propagate PD provider registration errors

Georgi Djakov <georgi.djakov@linaro.org>
    clk: qcom: gcc-sdm845: Add missing flag to votable GDSCs

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson8: fix the size of the PMU registers


-------------

Diffstat:

 .../devicetree/bindings/net/snps,dwmac.yaml        |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am571x-idk.dts                   |   2 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |   2 +-
 arch/arm/boot/dts/imx6dl-icore-mipi.dts            |   2 +-
 arch/arm/boot/dts/imx6q-dhcom-pdk2.dts             |   2 +-
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |   2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   4 -
 arch/arm/boot/dts/imx6sl-evk.dts                   |   4 -
 arch/arm/boot/dts/imx6sll-evk.dts                  |   4 -
 arch/arm/boot/dts/imx6sx-sdb-reva.dts              |   4 -
 arch/arm/boot/dts/imx6sx-sdb.dts                   |   4 -
 arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts       |   4 -
 arch/arm/boot/dts/imx7s-colibri.dtsi               |   4 +
 arch/arm/boot/dts/imx7ulp.dtsi                     |   4 +-
 arch/arm/boot/dts/meson8.dtsi                      |   2 +-
 arch/arm/boot/dts/omap4.dtsi                       |   4 +-
 arch/arm/mach-davinci/Kconfig                      |   1 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   6 +-
 .../dts/allwinner/sun50i-a64-olinuxino-emmc.dts    |   2 +-
 .../boot/dts/allwinner/sun50i-a64-olinuxino.dts    |   2 +-
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   9 +
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi  |   8 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |  12 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |  12 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   4 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |   1 -
 arch/arm64/boot/dts/arm/juno-clocks.dtsi           |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts       |   2 +
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |  10 +-
 .../boot/dts/freescale/imx8mq-librem5-devkit.dts   |   2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |   8 +-
 arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi |   2 +
 arch/arm64/boot/dts/marvell/armada-cp110.dtsi      |   8 +-
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi          |  68 +++++++
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  51 +++--
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   2 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +-
 arch/arm64/boot/dts/renesas/hihope-common.dtsi     |  20 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |  11 --
 arch/arm64/boot/dts/renesas/r8a77970.dtsi          |   2 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/um/drivers/Kconfig                            |   2 +-
 arch/um/drivers/virtio_uml.c                       |   4 +-
 arch/um/os-Linux/main.c                            |   2 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/events/intel/uncore_snbep.c               |   1 +
 arch/x86/kernel/cpu/amd.c                          |   4 +-
 arch/x86/kernel/cpu/resctrl/core.c                 |   2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   6 +-
 block/blk-settings.c                               |   2 +-
 block/bsg-lib.c                                    |   2 +-
 drivers/base/firmware_loader/builtin/Makefile      |   2 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/bus/ti-sysc.c                              |  10 +-
 drivers/clk/clk.c                                  |  10 +-
 drivers/clk/imx/clk-imx7ulp.c                      |   6 +-
 drivers/clk/qcom/gcc-sdm845.c                      |   7 +
 drivers/clk/samsung/clk-exynos5420.c               |   8 +
 drivers/clk/sprd/common.c                          |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-r40.c               |   6 +-
 drivers/cpuidle/governors/teo.c                    |   2 +-
 drivers/firmware/efi/earlycon.c                    |  16 +-
 drivers/gpio/Kconfig                               |   1 -
 drivers/gpio/gpio-thunderx.c                       | 163 ++++++++++------
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 drivers/gpu/drm/i915/selftests/i915_random.h       |   1 +
 drivers/hwmon/pmbus/ibm-cffps.c                    |  37 ++--
 drivers/i2c/busses/i2c-iop3xx.c                    |  12 +-
 drivers/i2c/busses/i2c-tegra.c                     |  38 +++-
 drivers/iio/adc/ad7124.c                           |  12 +-
 drivers/iio/chemical/Kconfig                       |   1 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   3 +-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/iio/light/vcnl4000.c                       |   3 +-
 drivers/irqchip/Kconfig                            |   4 +-
 drivers/md/dm-snap-persistent.c                    |   2 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/message/fusion/mptctl.c                    | 213 +++++----------------
 drivers/mtd/chips/cfi_cmdset_0002.c                |  60 +++---
 drivers/mtd/devices/mchp23k256.c                   |  20 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |  11 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   4 +-
 drivers/net/dsa/bcm_sf2.c                          |   2 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  29 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |   3 +
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   6 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  31 +--
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |  30 ++-
 drivers/net/ethernet/renesas/sh_eth.c              |  38 ++--
 drivers/net/ethernet/socionext/sni_ave.c           |  20 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  46 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   4 +
 drivers/net/hyperv/rndis_filter.c                  |   2 -
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/phy/dp83867.c                          |   8 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/usb/r8152.c                            |   3 +
 drivers/net/wan/fsl_ucc_hdlc.c                     |   2 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |  17 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |   9 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   4 +-
 drivers/net/wireless/st/cw1200/fwio.c              |   6 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/ptp/ptp_clock.c                            |   4 +-
 drivers/reset/core.c                               |   6 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |   4 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/fnic/vnic_dev.c                       |  20 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   3 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  11 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  56 +++---
 drivers/scsi/qla2xxx/qla_init.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   6 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 113 ++++-------
 drivers/scsi/scsi_transport_sas.c                  |   9 +-
 drivers/scsi/storvsc_drv.c                         |   4 +-
 drivers/soc/amlogic/meson-ee-pwrc.c                |  24 ++-
 drivers/staging/comedi/drivers/ni_routes.c         |  12 +-
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/usb/core/hub.c                             |   1 +
 drivers/usb/serial/ch341.c                         |   6 +-
 drivers/usb/serial/io_edgeport.c                   |  16 +-
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/quatech2.c                      |   6 +
 drivers/usb/serial/usb-serial-simple.c             |   2 +
 drivers/usb/serial/usb-serial.c                    |   3 +
 fs/btrfs/inode.c                                   |  73 +++----
 fs/btrfs/ioctl.c                                   |  14 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/btrfs/relocation.c                              |  51 ++++-
 fs/btrfs/root-tree.c                               |  10 +-
 fs/btrfs/volumes.c                                 |   6 +-
 fs/fuse/file.c                                     |   4 +-
 fs/io_uring.c                                      |   6 +
 fs/reiserfs/xattr.c                                |   8 +-
 include/dt-bindings/reset/amlogic,meson8b-reset.h  |   6 +-
 include/linux/blkdev.h                             |   8 +-
 include/linux/mm.h                                 |  18 +-
 include/linux/mmzone.h                             |   5 +-
 include/linux/netdevice.h                          |   2 +-
 include/linux/regulator/ab8500.h                   |   2 -
 include/linux/skmsg.h                              |  13 +-
 include/linux/tnum.h                               |   2 +-
 include/net/tcp.h                                  |   6 +-
 include/trace/events/huge_memory.h                 |   3 +-
 init/main.c                                        |   1 +
 kernel/bpf/tnum.c                                  |   9 +-
 kernel/bpf/verifier.c                              |  13 +-
 kernel/cpu.c                                       | 143 +++++++-------
 kernel/events/core.c                               |   4 +-
 kernel/locking/lockdep.c                           |   7 +-
 kernel/locking/rwsem.c                             |   4 +-
 kernel/ptrace.c                                    |  15 +-
 kernel/time/tick-sched.c                           |  14 +-
 mm/huge_memory.c                                   |  38 ++--
 mm/memcontrol.c                                    |  37 +---
 mm/page-writeback.c                                |   4 +-
 mm/page_alloc.c                                    |  37 ++--
 mm/shmem.c                                         |   7 +-
 mm/slab.c                                          |   4 +-
 mm/slab_common.c                                   |   3 +-
 mm/slub.c                                          |   2 +-
 mm/sparse.c                                        |   9 +-
 mm/vmalloc.c                                       |   4 +-
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/core/dev.c                                     |  12 --
 net/core/devlink.c                                 |   2 +-
 net/core/filter.c                                  |  20 +-
 net/core/skmsg.c                                   |   2 +
 net/core/sock_map.c                                |   7 +-
 net/dsa/tag_gswip.c                                |   2 +-
 net/dsa/tag_qca.c                                  |   3 -
 net/ipv4/netfilter/arp_tables.c                    |  19 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_bpf.c                                 |  17 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/ipv4/tcp_ulp.c                                 |   6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/nf_nat_proto.c                       |  13 ++
 net/netfilter/nf_tables_api.c                      |  38 ++--
 net/netfilter/nft_tunnel.c                         |   5 +-
 net/sched/act_ctinfo.c                             |  11 ++
 net/sched/act_ife.c                                |   7 +-
 net/tipc/bcast.c                                   |  24 ++-
 net/tipc/socket.c                                  |  32 ++--
 net/tls/tls_main.c                                 |  10 +-
 net/tls/tls_sw.c                                   |  31 ++-
 net/wireless/nl80211.c                             |   3 +
 net/wireless/rdev-ops.h                            |   4 +
 net/wireless/sme.c                                 |   6 +-
 net/wireless/util.c                                |   2 +-
 sound/core/seq/seq_timer.c                         |  14 +-
 sound/firewire/dice/dice-extension.c               |   5 +-
 sound/firewire/tascam/amdtp-tascam.c               |   5 +-
 sound/soc/codecs/msm8916-wcd-analog.c              |  20 +-
 sound/soc/codecs/msm8916-wcd-digital.c             |   6 +
 sound/soc/intel/boards/bytcht_es8316.c             |   3 +-
 sound/soc/stm/stm32_adfsdm.c                       |  12 +-
 sound/soc/stm/stm32_sai_sub.c                      | 194 +++++++++++++------
 sound/usb/pcm.c                                    |   2 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/perf/builtin-report.c                        |   5 +-
 tools/perf/builtin-script.c                        |   5 -
 tools/perf/util/hist.h                             |   4 +-
 tools/perf/util/probe-finder.c                     |  32 +---
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |   8 +-
 221 files changed, 1656 insertions(+), 1191 deletions(-)


