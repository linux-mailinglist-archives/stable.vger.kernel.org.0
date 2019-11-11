Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFC8F7CB2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKKSsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbfKKSsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 706E620674;
        Mon, 11 Nov 2019 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498124;
        bh=8PAemAcSiFJtKgHzIEkpQMYpCDFTQU3eTOo8ns+AV6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=b7SAn+PYVxJVmchnQazf3HK17cG5PCVIwdxLb0UVN/lEefFv/rQiRshbDTDvrNH8j
         f597XWGo8iKFLK7TS4MteBVjSi2uMkdL642RCQKpzSdeRPpQZzZ7wzdjamR1awUv5D
         zNKmaYFOjeEpujFkrO9qDIXCgWQ3kyKCwyHiZjiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/193] 5.3.11-stable review
Date:   Mon, 11 Nov 2019 19:26:22 +0100
Message-Id: <20191111181459.850623879@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.11-rc1
X-KernelTest-Deadline: 2019-11-13T18:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.11 release.
There are 193 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.11-rc1

Tejun Heo <tj@kernel.org>
    cgroup,writeback: don't switch wbs immediately on dead wbs if the memcg is dead

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Huacai Chen <chenhc@lemote.com>
    timekeeping/vsyscall: Update VDSO data unconditionally

Leonard Crestez <leonard.crestez@nxp.com>
    clk: imx8m: Use SYS_PLL1_800M as intermediate parent of CLK_ARM

Hans de Goede <hdegoede@redhat.com>
    pinctrl: cherryview: Fix irq_valid_mask calculation

Shuning Zhang <sunny.s.zhang@oracle.com>
    ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()

Yangchun Fu <yangchun@google.com>
    gve: Fixes DMA synchronization.

Wenwen Wang <wenwen@cs.uga.edu>
    e1000: fix memory leaks

Manfred Rudigier <manfred.rudigier@omicronenergy.com>
    igb: Fix constant media auto sense switching when no cable is connected

Chuhong Yuan <hslester96@gmail.com>
    net: ethernet: arc: add the missed clk_disable_unprepare

Trond Myklebust <trondmy@gmail.com>
    NFSv4: Don't allow a cached open with a revoked delegation

Florian Fainelli <f.fainelli@gmail.com>
    arm64: apply ARM64_ERRATUM_843419 workaround for Brahma-B53 core

Florian Fainelli <f.fainelli@gmail.com>
    arm64: Brahma-B53 is SSB and spectre v2 safe

Doug Berger <opendmb@gmail.com>
    arm64: apply ARM64_ERRATUM_845719 workaround for Brahma-B53 core

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: dwc3: gadget: fix race when disabling ep with cancelled xfers

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: cpufeature: Enable Qualcomm Falkor errata 1009 for Kryo

Kairui Song <kasong@redhat.com>
    x86, efi: Never relocate kernel below lowest acceptable address

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    efi: libstub/arm: Account for firmware reserved memory at the base of RAM

Jerry Snitselaar <jsnitsel@redhat.com>
    efi/tpm: Return -EINVAL when determining tpm final events log size fails

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix error handling in netvsc_attach()

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: Destroy the back channel when we destroy the host transport

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: The RDMA back channel mustn't disappear while requests are outstanding

Trond Myklebust <trondmy@gmail.com>
    SUNRPC: The TCP back channel mustn't disappear while requests are outstanding

zhongshiqi <zhong.shiqi@zte.com.cn>
    dc.c:use kzalloc without test

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Passive DP->HDMI dongle detection fix

Jun Lei <Jun.Lei@amd.com>
    drm/amd/display: add 50us buffer as WA for pstate switch in active

Jun Lei <Jun.Lei@amd.com>
    drm/amd/display: do not synchronize "drr" displays

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amdgpu: If amdgpu_ib_schedule fails return back the error.

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/sched: Set error to s_fence if HW job submission failed.

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu/sdma5: do not execute 0-sized IBs (v2)

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: fix buffer unmap with non-linear skbs

Takashi Iwai <tiwai@suse.de>
    iommu/amd: Apply the same IVRS IOAPIC workaround to Acer Aspire A315-41

Vladimir Oltean <olteanv@gmail.com>
    net: mscc: ocelot: refuse to overwrite the port's native vlan

Vladimir Oltean <olteanv@gmail.com>
    net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is up

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix "Trying to free already-free IRQ"

Will Deacon <will@kernel.org>
    fjes: Handle workqueue allocation failure

Anton Eidelman <anton@lightbitslabs.com>
    nvme-multipath: fix possible io hang after ctrl reconnect

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Allow sched_asym_cpucapacity to be disabled

Valentin Schneider <valentin.schneider@arm.com>
    sched/topology: Don't try to build empty sched domains

Nicholas Piggin <npiggin@gmail.com>
    scsi: qla2xxx: stop timer in shutdown path

Nicolin Chen <nicoleotsuka@gmail.com>
    hwmon: (ina3221) Fix read timeout issue

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Prevent memory leaks of eq->buf_list

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

GwanYeong Kim <gy741.kim@gmail.com>
    usbip: tools: Fix read_usb_vudc_device() error path handling

Johan Hovold <johan@kernel.org>
    USB: ldusb: use unsigned size format specifiers

Alan Stern <stern@rowland.harvard.edu>
    USB: Skip endpoints with 0 maxpacket length

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/uncore: Fix event group support

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family (10h)

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity

Yinbo Zhu <yinbo.zhu@nxp.com>
    usb: dwc3: remove the call trace of USBx_GFLADJ

Peter Chen <peter.chen@nxp.com>
    usb: gadget: configfs: fix concurrent issue between composite APIs

Navid Emamdoost <navid.emamdoost@gmail.com>
    usb: dwc3: pci: prevent memory leak in dwc3_pci_probe

Chandana Kishori Chiluveru <cchiluve@codeaurora.org>
    usb: gadget: composite: Fix possible double free memory bug

Cristian Birsan <cristian.birsan@microchip.com>
    usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Nikhil Badola <nikhil.badola@freescale.com>
    usb: fsl: Check memory resource before releasing it

Arnd Bergmann <arnd@arndb.de>
    usb: dwc3: select CONFIG_REGMAP_MMIO

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: define variable dif as unsigned int instead of bool

Taehee Yoo <ap420073@gmail.com>
    virt_wifi: fix refcnt leak in module exit routine

Taehee Yoo <ap420073@gmail.com>
    macsec: fix refcnt leak in module exit routine

Taehee Yoo <ap420073@gmail.com>
    bonding: use dynamic lockdep key instead of subclass

Taehee Yoo <ap420073@gmail.com>
    bonding: fix unexpected IFF_BONDING bit unset

Mark Zhang <markz@mellanox.com>
    RDMA/nldev: Skip counter if port doesn't match

wenxu <wenxu@ucloud.cn>
    netfilter: nft_payload: fix missing check for matching length in offloads

Eric Dumazet <edumazet@google.com>
    ipvs: move old_secure_tcp into struct netns_ipvs

Davide Caratti <dcaratti@redhat.com>
    ipvs: don't ignore errors in case refcounting ip_vs module fails

Martin Fuzzey <martin.fuzzey@flowbird.group>
    net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix registration of Rx-only sockets

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/v3d: Fix memory leak in v3d_submit_cl_ioctl

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_flow_table: set timeout before insertion into hashes

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: 0x2720 is qu and 0x30DC is not

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: fix all 9460 entries for qnj

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pcie: fix PCI ID 0x2720 configs that should be soc

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix use after free in bpf_get_prog_name

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Initialized mailbox to prevent driver load failure

Daniel Wagner <dwagner@suse.de>
    scsi: lpfc: Honor module parameter lpfc_use_adisc

Hillf Danton <hdanton@sina.com>
    net: openvswitch: free vport unless register_netdevice() succeeds

yuqi jin <jinyuqi@huawei.com>
    net: stmmac: Fix the problem of tso_xmit

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix use after free in subprog's jited symbol removal

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/uverbs: Prevent potential underflow

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    ARC: [plat-hsdk]: Enable on-board SPI NOR flash IC

Avri Altman <avri.altman@wdc.com>
    scsi: ufs-bsg: Wake the device before sending raw upiu commands

Daniel Wagner <dwagner@suse.de>
    scsi: lpfc: Check queue pointer before use

Hannes Reinecke <hare@suse.com>
    scsi: qla2xxx: fixup incorrect usage of host_byte

Jiri Benc <jbenc@redhat.com>
    selftests/bpf: More compatible nc options in test_tc_edt

Navid Emamdoost <navid.emamdoost@gmail.com>
    net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump

Navid Emamdoost <navid.emamdoost@gmail.com>
    net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: TX, Fix consumer index of error cqe dump

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown flow

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow

Parav Pandit <parav@mellanox.com>
    IB/core: Use rdma_read_gid_l2_fields to compare GID L2 fields

Kamal Heib <kamalheib1@gmail.com>
    RDMA/qedr: Fix reported firmware version

Krishnamraju Eraparaju <krishna2@chelsio.com>
    RDMA/siw: free siw_base_qp in kref release routine

Potnuri Bharat Teja <bharat@chelsio.com>
    iw_cxgb4: fix ECN check on the passive accept

Rafi Wiener <rafiw@mellanox.com>
    RDMA/mlx5: Clear old rate limit when closing QP

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: fix allow/prevent_user_access() when crossing segment boundaries.

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_ring()

Baolin Wang <baolin.wang@linaro.org>
    dmaengine: sprd: Fix the possible memory leak issue

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_config

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: Fix 64-bit simple AXIDMA transfer

Jiri Benc <jbenc@redhat.com>
    bpf: lwtunnel: Fix reroute supplying invalid dst

Zhenfang Wang <zhenfang.wang@unisoc.com>
    dmaengine: sprd: Fix the link-list pointer register configuration issue

Nicolas Boichat <drinkcat@chromium.org>
    HID: google: add magnemite/masterball USB ids

Suwan Kim <suwan.kim027@gmail.com>
    usbip: Implement SG support to vhci-hcd and stub driver

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix copy&paste error in the validator

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: usb-audio: remove some dead code

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix possible NULL dereference at create_yamaha_midi_quirk()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clean up check_input_term()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Remove superfluous bLength checks

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Unify the release of usb_mixer_elem_info objects

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Simplify parse_audio_unit()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More validations of descriptor units

Al Viro <viro@zeniv.linux.org.uk>
    configfs: fix a deadlock in configfs_symlink()

Johan Hovold <johan@kernel.org>
    can: peak_usb: fix slab info leak

Johan Hovold <johan@kernel.org>
    can: mcba_usb: fix use-after-free on disconnect

Wen Yang <wenyang@linux.alibaba.com>
    can: dev: add missing of_node_put() after calling of_get_child_by_name()

Navid Emamdoost <navid.emamdoost@gmail.com>
    can: gs_usb: gs_can_open(): prevent memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix a potential out-of-sync while decoding packets

Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
    can: c_can: c_can_poll(): only read status register after status IRQ

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: disable completely the ECC mechanism

Johan Hovold <johan@kernel.org>
    can: usb_8dev: fix use-after-free on disconnect

Pavel Shilovsky <pshilov@microsoft.com>
    SMB3: Fix persistent handles reconnect

Jan Beulich <jbeulich@suse.com>
    x86/apic/32: Avoid bogus LDR warnings

Thomas Gleixner <tglx@linutronix.de>
    x86/dumpstack/64: Don't evaluate exception stacks before setup

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Jasper Lake PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Comet Lake PCH support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: gth: Fix the window switching sequence

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Lukas Wunner <lukas@wunner.de>
    netfilter: nf_tables: Align nft_expr private data to 64-bit

Christian Brauner <christian.brauner@ubuntu.com>
    clone3: validate stack arguments

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: Fix invalid EPB setting

Adam Ford <aford173@gmail.com>
    ARM: dts: imx6-logicpd: Re-enable SNVS power key

Ondrej Jirman <megous@megous.com>
    ARM: sunxi: Fix CPU powerdown on A83T

Andreas Klinger <ak@it-klinger.de>
    iio: srf04: fix wrong limitation in distance measuring

Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
    iio: imu: inv_mpu6050: fix no data on MPU6050

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: make sure provided frequency is positive

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix stopping dma

Luis Henriques <lhenriques@suse.com>
    ceph: don't allow copy_file_range when stripe_count != 1

Jeff Layton <jlayton@kernel.org>
    ceph: don't try to handle hashed dentries in non-O_CREAT atomic_open

Al Viro <viro@zeniv.linux.org.uk>
    ceph: add missing check in d_revalidate snapdir handling

Al Viro <viro@zeniv.linux.org.uk>
    ceph: fix RCU case handling in ceph_d_revalidate()

Luis Henriques <lhenriques@suse.com>
    ceph: fix use-after-free in __ceph_remove_cap()

Jiada Wang <jiada_wang@mentor.com>
    ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma address

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not mask out PTE_RDONLY in pte_same()

Tejun Heo <tj@kernel.org>
    blkcg: make blkcg_print_stat() print stats only for online blkgs

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: bus: set initial value to port_status

Michal Suchanek <msuchanek@suse.de>
    soundwire: depend on ACPI || OF

Michal Suchanek <msuchanek@suse.de>
    soundwire: depend on ACPI

Ville Syrjälä <ville.syrjala@linux.intel.com>
    mm/khugepaged: fix might_sleep() warn with CONFIG_HIGHPTE=y

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: generic: Treat serial number and related fields as unsigned

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix si_enable_smc_cac() failed issue

John Keeping <john@metanate.com>
    perf map: Use zalloc for map_groups

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix time sorting

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Avoid potential glitches if pin is in GPIO mode

Shuah Khan <skhan@linuxfoundation.org>
    tools: gpio: Use !building_out_of_srctree to determine srctree

Josef Bacik <josef@toxicpanda.com>
    btrfs: save i_size to avoid double evaluation of i_size_read in compress_file_range

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: Fix wrong check on max devid

Qu Wenruo <wqu@suse.com>
    btrfs: Consider system chunk array size for new SYSTEM chunks

Roman Gushchin <guro@fb.com>
    mm: slab: make page_cgroup_ino() to recognize non-compound slab pages properly

Kevin Hao <haokexin@gmail.com>
    dump_stack: avoid the livelock of the dump_lock

Michal Hocko <mhocko@suse.com>
    mm, vmstat: hide /proc/pagetypeinfo from normal users

Yang Shi <yang.shi@linux.alibaba.com>
    mm: thp: handle page cache THP correctly in PageTransCompoundMap

Mel Gorman <mgorman@techsingularity.net>
    mm, meminit: recalculate pcpu batch and high limits after init completes

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges

Shakeel Butt <shakeelb@google.com>
    mm: memcontrol: fix NULL-ptr deref in percpu stats flush

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Fix possible workqueue stall

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: fix to detect configured source of sampling clock for Focusrite Saffire Pro i/o series

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix incorrectly assigned timer instance

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix page read in r8168g_mdio_read

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix sock refcnt holding during the shutdown

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix ethernet interface refcounting

John Hurley <john.hurley@netronome.com>
    net: sched: prevent duplicate flower rules from tcf_proto destroy race

Eric Dumazet <edumazet@google.com>
    net: prevent load/store tearing on sk->sk_stamp

Salil Mehta <salil.mehta@huawei.com>
    net: hns: Fix the stray netpoll locks causing deadlock in NAPI path

Eric Dumazet <edumazet@google.com>
    ipv6: fixes rt6_probe() and fib6_nh->last_probe init

Jakub Kicinski <jakub.kicinski@netronome.com>
    selftests/tls: add test for concurrent recv and send

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: add a TX lock

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: don't pay attention to sk_write_pending when pushing partial records

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: mscc: ocelot: fix NULL pointer on LAG slave removal

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: mscc: ocelot: don't handle netdev events for other netdevs

Manish Chopra <manishc@marvell.com>
    qede: fix NULL pointer deref in __qede_remove()

Pan Bian <bianpan2016@163.com>
    NFC: st21nfca: fix double free

Pan Bian <bianpan2016@163.com>
    nfc: netlink: fix double device reference drop

Pan Bian <bianpan2016@163.com>
    NFC: fdp: fix incorrect free object

Aleksander Morgado <aleksander@aleksander.es>
    net: usb: qmi_wwan: add support for DW5821e with eSIM support

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix sk_msg trim on fallback to copy mode

Sean Tranchetti <stranche@codeaurora.org>
    net: qualcomm: rmnet: Fix potential UAF when unregistering

Eric Dumazet <edumazet@google.com>
    net: fix data-race in neigh_event_send()

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    net: ethernet: octeon_mgmt: Account for second possible VLAN header

David Ahern <dsahern@kernel.org>
    ipv4: Fix table id reference in fib_sync_down_addr

Oliver Neukum <oneukum@suse.com>
    CDC-NCM: handle incomplete transfer of MTU

Jay Vosburgh <jay.vosburgh@canonical.com>
    bonding: fix state transition issue in link monitoring


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst             |   7 +-
 Makefile                                           |   4 +-
 arch/arc/boot/dts/hsdk.dts                         |   8 +
 arch/arc/configs/hsdk_defconfig                    |   2 +
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi      |   4 +
 arch/arm/mach-sunxi/mc_smp.c                       |   6 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |  17 -
 arch/arm64/include/asm/vdso/vsyscall.h             |   7 -
 arch/arm64/kernel/cpu_errata.c                     |  58 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |   1 +
 arch/x86/boot/compressed/eboot.c                   |   4 +-
 arch/x86/events/amd/ibs.c                          |   8 +-
 arch/x86/events/intel/uncore.c                     |  44 +-
 arch/x86/events/intel/uncore.h                     |  12 -
 arch/x86/kernel/apic/apic.c                        |  28 +-
 arch/x86/kernel/dumpstack_64.c                     |   7 +
 block/blk-cgroup.c                                 |  13 +-
 drivers/clk/imx/clk-imx8mm.c                       |   2 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/dma/sprd-dma.c                             |  27 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  10 +-
 drivers/firmware/efi/libstub/Makefile              |   1 +
 drivers/firmware/efi/libstub/arm32-stub.c          |  16 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |  24 +-
 drivers/firmware/efi/tpm.c                         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   4 +
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c  |  24 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   6 +
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |   3 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   1 +
 drivers/gpu/drm/scheduler/sched_main.c             |  19 +-
 drivers/gpu/drm/v3d/v3d_gem.c                      |   5 +-
 drivers/hid/hid-google-hammer.c                    |   4 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c   |   2 +-
 drivers/hid/wacom.h                                |  15 +
 drivers/hid/wacom_wac.c                            |  10 +-
 drivers/hwmon/ina3221.c                            |   2 +-
 drivers/hwtracing/intel_th/gth.c                   |   3 +
 drivers/hwtracing/intel_th/pci.c                   |  10 +
 drivers/iio/adc/stm32-adc.c                        |   4 +-
 drivers/iio/imu/adis16480.c                        |   5 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   9 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |   2 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |  15 +-
 drivers/iio/proximity/srf04.c                      |  29 +-
 drivers/infiniband/core/nldev.c                    |   2 +-
 drivers/infiniband/core/uverbs.h                   |   2 +-
 drivers/infiniband/core/verbs.c                    |   9 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  30 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   8 +-
 drivers/infiniband/hw/qedr/main.c                  |   2 +-
 drivers/infiniband/sw/siw/siw_qp.c                 |   2 +
 drivers/infiniband/sw/siw/siw_verbs.c              |   2 -
 drivers/iommu/amd_iommu_quirks.c                   |  13 +
 drivers/net/bonding/bond_main.c                    |  60 +-
 drivers/net/can/c_can/c_can.c                      |  25 +-
 drivers/net/can/c_can/c_can.h                      |   1 +
 drivers/net/can/dev.c                              |   1 +
 drivers/net/can/flexcan.c                          |   1 +
 drivers/net/can/rx-offload.c                       |   6 +-
 drivers/net/can/usb/gs_usb.c                       |   1 +
 drivers/net/can/usb/mcba_usb.c                     |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/can/usb/usb_8dev.c                     |   3 +-
 drivers/net/ethernet/arc/emac_rockchip.c           |   3 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |   2 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   2 +
 drivers/net/ethernet/google/gve/gve_tx.c           |  24 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |   1 -
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   1 -
 drivers/net/ethernet/hisilicon/hns/hnae.h          |   3 -
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  22 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   7 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  35 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  20 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  12 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
 drivers/net/fjes/fjes_main.c                       |  15 +-
 drivers/net/hyperv/netvsc_drv.c                    |   9 +-
 drivers/net/macsec.c                               |   4 -
 drivers/net/phy/smsc.c                             |   1 +
 drivers/net/usb/cdc_ncm.c                          |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wimax/i2400m/op-rfkill.c               |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 125 ++--
 drivers/net/wireless/mediatek/mt76/dma.c           |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   5 +-
 drivers/net/wireless/virt_wifi.c                   |  54 +-
 drivers/nfc/fdp/i2c.c                              |   2 +-
 drivers/nfc/st21nfca/core.c                        |   1 +
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   2 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  21 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   4 +
 drivers/soundwire/Kconfig                          |   1 +
 drivers/soundwire/bus.c                            |   2 +-
 drivers/usb/core/config.c                          |   5 +
 drivers/usb/dwc3/Kconfig                           |   1 +
 drivers/usb/dwc3/core.c                            |   3 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +-
 drivers/usb/dwc3/gadget.c                          |   6 +
 drivers/usb/gadget/composite.c                     |   4 +
 drivers/usb/gadget/configfs.c                      | 110 +++-
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   6 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   2 +-
 drivers/usb/misc/ldusb.c                           |   7 +-
 drivers/usb/usbip/stub.h                           |   7 +-
 drivers/usb/usbip/stub_main.c                      |  57 +-
 drivers/usb/usbip/stub_rx.c                        | 204 +++++--
 drivers/usb/usbip/stub_tx.c                        |  99 +++-
 drivers/usb/usbip/usbip_common.c                   |  59 +-
 drivers/usb/usbip/vhci_hcd.c                       |  12 +-
 drivers/usb/usbip/vhci_rx.c                        |   3 +
 drivers/usb/usbip/vhci_tx.c                        |  66 ++-
 fs/btrfs/inode.c                                   |  15 +-
 fs/btrfs/tree-checker.c                            |   8 -
 fs/btrfs/volumes.c                                 |   1 +
 fs/ceph/caps.c                                     |  10 +-
 fs/ceph/dir.c                                      |  15 +-
 fs/ceph/file.c                                     |  15 +-
 fs/ceph/inode.c                                    |   1 +
 fs/cifs/smb2pdu.h                                  |   1 +
 fs/configfs/symlink.c                              |  33 +-
 fs/fs-writeback.c                                  |   9 +-
 fs/nfs/delegation.c                                |  10 +
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/nfs4proc.c                                  |   7 +-
 fs/ocfs2/file.c                                    | 134 +++--
 include/asm-generic/vdso/vsyscall.h                |   7 -
 include/linux/efi.h                                |  18 +-
 include/linux/filter.h                             |   1 -
 include/linux/mm.h                                 |   5 -
 include/linux/mm_types.h                           |   5 +
 include/linux/page-flags.h                         |  20 +-
 include/linux/skmsg.h                              |   9 +-
 include/linux/sunrpc/bc_xprt.h                     |   5 +
 include/net/bonding.h                              |   4 +-
 include/net/ip_vs.h                                |   1 +
 include/net/neighbour.h                            |   4 +-
 include/net/netfilter/nf_tables.h                  |   3 +-
 include/net/sch_generic.h                          |   4 +
 include/net/sock.h                                 |   4 +-
 include/net/tls.h                                  |   5 +
 include/rdma/ib_verbs.h                            |   2 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/syscall.c                               |  31 +-
 kernel/cgroup/cpuset.c                             |   3 +-
 kernel/fork.c                                      |  33 +-
 kernel/sched/topology.c                            |  11 +-
 kernel/time/vsyscall.c                             |   9 +-
 lib/dump_stack.c                                   |   7 +-
 mm/filemap.c                                       |   3 +-
 mm/khugepaged.c                                    |   7 +-
 mm/memcontrol.c                                    |  23 +-
 mm/page_alloc.c                                    |  10 +-
 mm/slab.h                                          |   4 +-
 mm/vmstat.c                                        |   2 +-
 net/core/lwt_bpf.c                                 |   7 +-
 net/core/skmsg.c                                   |  20 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv6/route.c                                   |  13 +-
 net/netfilter/ipset/ip_set_core.c                  |   8 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  12 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  29 +-
 net/netfilter/ipvs/ip_vs_pe.c                      |   3 +-
 net/netfilter/ipvs/ip_vs_sched.c                   |   3 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  13 +-
 net/netfilter/nf_flow_table_core.c                 |   3 +-
 net/netfilter/nft_payload.c                        |  38 ++
 net/nfc/netlink.c                                  |   2 -
 net/openvswitch/vport-internal_dev.c               |  11 +-
 net/sched/cls_api.c                                |  83 ++-
 net/smc/smc_pnet.c                                 |   2 -
 net/sunrpc/backchannel_rqst.c                      |   7 +-
 net/sunrpc/xprt.c                                  |   5 +
 net/sunrpc/xprtrdma/backchannel.c                  |   2 +
 net/tls/tls_device.c                               |  10 +-
 net/tls/tls_main.c                                 |   2 +
 net/tls/tls_sw.c                                   |  30 +-
 net/vmw_vsock/virtio_transport_common.c            |   8 +-
 net/xdp/xdp_umem.c                                 |   6 +
 sound/core/timer.c                                 |   6 +-
 sound/firewire/bebob/bebob_focusrite.c             |   3 +
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/soc/sh/rcar/dma.c                            |   4 +-
 sound/usb/Makefile                                 |   3 +-
 sound/usb/clock.c                                  |  14 +-
 sound/usb/helper.h                                 |   4 +
 sound/usb/mixer.c                                  | 633 +++++++++------------
 sound/usb/power.c                                  |   2 +
 sound/usb/quirks.c                                 |   3 +
 sound/usb/stream.c                                 |  25 +-
 sound/usb/validate.c                               | 332 +++++++++++
 tools/gpio/Makefile                                |   6 +-
 tools/perf/util/hist.c                             |   2 +-
 tools/perf/util/map.c                              |   2 +-
 tools/testing/selftests/bpf/test_tc_edt.sh         |   2 +-
 tools/testing/selftests/net/tls.c                  | 108 ++++
 tools/usb/usbip/libsrc/usbip_device_driver.c       |   6 +-
 219 files changed, 2661 insertions(+), 1120 deletions(-)


