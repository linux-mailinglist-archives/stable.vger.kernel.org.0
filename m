Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA446C2CAF
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCUIj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 04:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCUIjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:39:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80A11E;
        Tue, 21 Mar 2023 01:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8ADD61A24;
        Tue, 21 Mar 2023 08:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE9C433EF;
        Tue, 21 Mar 2023 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679387965;
        bh=iDnyLVwa7P0RNhyJ3L2Yfk2i7QkYkonoY0ElKFreiEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=sKWhTCnK8ymGlkEjgLHa3Ee8g4ZxeLiAQrU2kEs3okudGoNzRqD7/Vll/vjSBtTne
         nqvjAzvdG2T0SishQgArSW6O1OnKuUlnzpCV6QRUVIsPK6RuUUvfY3pa5/93qZqi9z
         Z0j1xYGPFC1AcrK4A8IYmsL3s1f8JfJJL9zqrSyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 000/213] 6.2.8-rc2 review
Date:   Tue, 21 Mar 2023 09:39:22 +0100
Message-Id: <20230321080604.493429263@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.8-rc2
X-KernelTest-Deadline: 2023-03-23T08:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.8 release.
There are 213 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.8-rc2

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG

Budimir Markovic <markovicbudimir@gmail.com>
    perf: Fix check before add_event_to_groups() in perf_group_detach()

Dionna Glaze <dionnaglaze@google.com>
    virt/coco/sev-guest: Add throttling awareness

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Convert the sw_exit_info_2 checking to a switch-case

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Do some code style cleanups

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Carve out the request issuing logic into a helper

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Remove the disable_vmpck label in handle_guest_request()

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Simplify extended guest request handling

Borislav Petkov (AMD) <bp@alien8.de>
    virt/coco/sev-guest: Check SEV_SNP attribute at probe time

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Pass correct CPU reference to assembler

Shawn Wang <shawnwang@linux.alibaba.com>
    x86/resctrl: Clear staged_config[] before and after it is used

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    x86/mm: Fix use of uninitialized buffer in sme_enable()

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Make sure logged MCEs are processed after sysfs update

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: q6prm: fix incorrect clk_root passed to ADSP

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: soc-acpi: fix copy-paste issue in topology names

Shawn Guo <shawn.guo@linaro.org>
    cpuidle: psci: Iterate backwards over list in psci_pd_remove()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/msg_ring: let target know allocated index

Dylan Jhong <dylan@andestech.com>
    RISC-V: mm: Support huge page in vmalloc_fault()

Takashi Iwai <tiwai@suse.de>
    fbdev: Fix incorrect page mapping clearance at fb_deferred_io_release()

Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit

Sudeep Holla <sudeep.holla@arm.com>
    ACPI: PPTT: Fix to avoid sleep in the atomic context when PPTT is absent

Tero Kristo <tero.kristo@linux.intel.com>
    trace/hwlat: Do not start per-cpu thread if it is already running

Tero Kristo <tero.kristo@linux.intel.com>
    trace/hwlat: Do not wipe the contents of per-cpu thread data

Helge Deller <deller@gmx.de>
    fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks

Francesco Dolcini <francesco.dolcini@toradex.com>
    mmc: sdhci_am654: lower power-on failed message severity

Pali Rohár <pali@kernel.org>
    powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64: Set default CPU in Kconfig

James Houghton <jthoughton@google.com>
    mm: teach mincore_hugetlb about pte markers

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: propagate uffd-wp bit when PTE-mapping the huge zeropage

Cindy Lu <lulu@redhat.com>
    vp_vdpa: fix the crash in hot unplug with vp_vdpa

Dave Ertman <david.m.ertman@intel.com>
    ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000

Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix data corruption after failed write

Chen Zhongjin <chenzhongjin@huawei.com>
    ftrace: Fix invalid address access in lookup_rec() when index is 0

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: avoid setting TCP_CLOSE state twice

Geliang Tang <geliang.tang@suse.com>
    mptcp: add ro_after_init for tcp{,v6}_prot_override

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix UaF in listener shutdown

Paolo Abeni <pabeni@redhat.com>
    mptcp: use the workqueue to destroy unaccepted sockets

Paolo Abeni <pabeni@redhat.com>
    mptcp: refactor passive socket initialization

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix possible deadlock in subflow_error_report

Benjamin Cheng <ben@bcheng.me>
    drm/amd/display: Write to correct dirty_rect

Ayush Gupta <ayugupta@amd.com>
    drm/amd/display: disconnect MPCC only on OTG change

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Do not set DRR on pipe Commit

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: bump SMU 13.0.4 driver_if header version

Guilherme G. Piccoli <gpiccoli@igalia.com>
    drm/amdgpu/vcn: Disable indirect SRAM on Vangogh broken BIOSes

Błażej Szczygieł <mumei6102@gmail.com>
    drm/amd/pm: Fix sienna cichlid incorrect OD volage after resume

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdgpu: Don't resume IOMMU after incomplete init

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/dg2: Add HDMI pixel clock frequencies 267.30 and 319.89 MHz

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/active: Fix misuse of non-idle barriers as fence trackers

Johan Hovold <johan+linaro@kernel.org>
    drm/sun4i: fix missing component unbind on bind errors

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/shmem-helper: Remove another errant put in error path

Johan Hovold <johan+linaro@kernel.org>
    drm/edid: fix info leak when failing to get panel id

Guo Ren <guoren@kernel.org>
    riscv: asid: Fixup stale TLB entry cause application crash

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    Revert "riscv: mm: notify remote harts about mmu cache updates"

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix speaker, mute/micmute LEDs not work on a HP platform

Hamidreza H. Fard <nitocris@posteo.net>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro

Bard Liao <yung-chuan.liao@linux.intel.com>
    ALSA: hda: intel-dsp-config: add MTL PCI id

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: add missing consistency checks for CR0 and CR4

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask

Paulo Alcantara <pc@manguebit.com>
    cifs: use DFS root session instead of tcon ses

Paulo Alcantara <pc@manguebit.com>
    cifs: return DFS root session id in DebugData

Paulo Alcantara <pc@manguebit.com>
    cifs: fix use-after-free bug in refresh_cache_worker()

Paulo Alcantara <pc@manguebit.com>
    cifs: set DFS root session in cifs_get_smb_ses()

Volker Lendecke <vl@samba.org>
    cifs: Fix smb2_set_path_size()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make tracepoint lockdep check actually test something

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Check field value in hist_field_name()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Do not let histogram values have some modifiers

Sung-hun Kim <sfoon.kim@samsung.com>
    tracing: Make splice_read available again

Shyam Prasad N <sprasad@microsoft.com>
    cifs: generate signkey for the channel that's reconnecting

NeilBrown <neilb@suse.de>
    md: select BLOCK_LEGACY_AUTOLOAD

Johan Hovold <johan+linaro@kernel.org>
    interconnect: exynos: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: exynos: fix node leak in probe PM QoS error path

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: msm8974: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: rpmh: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: rpmh: fix probe child-node error handling

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: rpm: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: rpm: fix probe child-node error handling

Johan Hovold <johan+linaro@kernel.org>
    interconnect: qcom: osm-l3: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: fix mem leak when freeing nodes

Johan Hovold <johan+linaro@kernel.org>
    interconnect: imx: fix registration race

Johan Hovold <johan+linaro@kernel.org>
    interconnect: fix provider registration API

Johan Hovold <johan+linaro@kernel.org>
    interconnect: fix icc_provider_del() error handling

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add missing intersection check to ipl_report handling

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/ttm: Fix a NULL pointer dereference

Johan Hovold <johan+linaro@kernel.org>
    memory: tegra30-emc: fix interconnect registration race

Johan Hovold <johan+linaro@kernel.org>
    memory: tegra124-emc: fix interconnect registration race

Johan Hovold <johan+linaro@kernel.org>
    memory: tegra20-emc: fix interconnect registration race

Johan Hovold <johan+linaro@kernel.org>
    memory: tegra: fix interconnect registration race

Roman Gushchin <roman.gushchin@linux.dev>
    firmware: xilinx: don't make a sleepable memory allocation from an atomic context

Randy Dunlap <rdunlap@infradead.org>
    serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Johan Hovold <johan@kernel.org>
    serial: 8250_fsl: fix handle_irq locking

Biju Das <biju.das.jz@bp.renesas.com>
    serial: 8250_em: Fix UART port type

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    tty: serial: fsl_lpuart: fix race on RX DMA shutdown

Tom Rix <trix@redhat.com>
    Revert "tty: serial: fsl_lpuart: adjust SERIAL_FSL_LPUART_CONSOLE config dependency"

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible double unlock when moving a directory

Alex Hung <alex.hung@amd.com>
    drm/amd/display: fix shift-out-of-bounds in CalculateVMAndRowBytes

Horatio Zhang <Hongkun.Zhang@amd.com>
    drm/amdgpu: fix ttm_bo calltrace warning in psp_hw_fini

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sh: intc: Avoid spurious sizeof-pointer-div warning

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Only call get_timer_irq() once in constant_clockevent_init()

Eric Van Hensbergen <ericvh@kernel.org>
    net/9p: fix bug in client create for .L

Qu Huang <qu.huang@linux.dev>
    drm/amdkfd: Fix an illegal memory access

Baokun Li <libaokun1@huawei.com>
    ext4: fix task hung in ext4_xattr_delete_inode

Baokun Li <libaokun1@huawei.com>
    ext4: update s_journal_inum if it changes after journal replay

Linus Torvalds <torvalds@linux-foundation.org>
    media: m5mols: fix off-by-one loop termination error

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (ltc2992) Set `can_sleep` flag for GPIO chip

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (adm1266) Set `can_sleep` flag for GPIO chip

Jurica Vukadin <jura@vukad.in>
    kconfig: Update config changed flag before calling callback

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    hwmon: tmp512: drop of_match_ptr for ID table

Lars-Peter Clausen <lars@metafoo.de>
    hwmon: (ucd90320) Add minimum delay between bus accesses

Marcus Folkesson <marcus.folkesson@gmail.com>
    hwmon: (ina3221) return prober error code

Zheng Wang <zyytlz.wz@163.com>
    hwmon: (xgene) Fix use after free bug in xgene_hwmon_remove due to race condition

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Fix masking of hysteresis registers

Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
    hwmon: (adt7475) Display smoothing attributes in correct order

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails

Nikolay Aleksandrov <razor@blackwall.org>
    bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: rswitch: Fix the output value of quote from rswitch_rx()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue

Liang He <windhl@126.com>
    ethernet: sun: add check for the mdesc_grab()

Marek Vasut <marex@denx.de>
    net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_mng_tlv: correctly zero out ->min instead of ->hour

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: devlink_port_split.py: skip test if no suitable device available

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    i825xx: sni_82596: use eth_hw_addr_set()

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: Fix size of interrupt data

Toke Høiland-Jørgensen <toke@redhat.com>
    net: atlantic: Fix crash when XDP is enabled but no program is loaded

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect table ID in IOCTL path

Wolfram Sang <wsa+renesas@sang-engineering.com>
    sh_eth: avoid PHY being resumed when interface is not up

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ravb: avoid PHY being resumed when interface is not up

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't error out when drivers return ETH_DATA_LEN in .port_max_mtu()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: disable txq irq before flushing hw

Shawn Bohrer <sbohrer@cloudflare.com>
    veth: Fix use after free in XDP_REDIRECT

Shay Drory <shayd@nvidia.com>
    net/mlx5: Set BREAK_FW_WAIT flag first when removing driver

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: Fix cleanup null-ptr deref on encap lock

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port

Maor Dickman <maord@nvidia.com>
    net/mlx5: E-switch, Fix wrong usage of source port rewrite in split rules

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Disable eswitch before waiting for VF pages

Parav Pandit <parav@nvidia.com>
    net/mlx5: Fix setting ec_function bit in MANAGE_PAGES

Parav Pandit <parav@nvidia.com>
    net/mlx5e: Don't cache tunnel offloads capability

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: Fix macsec ASO context alignment

Yu Kuai <yukuai3@huawei.com>
    block: count 'ios' and 'sectors' when io is done for bio-based device

Liang He <windhl@126.com>
    block: sunvdc: add check for mdesc_grab() returning NULL

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    nvmet: avoid potential UAF in nvmet_req_complete()

Ming Lei <ming.lei@redhat.com>
    nvme: fix handling single range discard request

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: null_blk: Fix handling of fake timeout request

Russell Currey <ruscur@russell.cc>
    powerpc/mm: Fix false detection of read faults

Liu Ying <victor.liu@nxp.com>
    drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: only write values if needed

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: reset PCS state

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc75xx: Limit packet length to skb->len

Wenjia Zhang <wenjia@linux.ibm.com>
    net/smc: fix deadlock triggered by cancel_delayed_work_syn()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Fix incorrect parsing depth after reload

Zheng Wang <zyytlz.wz@163.com>
    nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix bind() conflict check for dual-stack wildcard address.

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: smsc: bail out in lan87xx_read_status if genphy_read_status fails

Eric Dumazet <edumazet@google.com>
    net: tunnels: annotate lockless accesses to dev->needed_headroom

Chris Leech <cleech@redhat.com>
    blk-mq: fix "bad unlock balance detected" on q->srcu in __blk_mq_run_dispatch_ops

Bart Van Assche <bvanassche@acm.org>
    loop: Fix use-after-free issues

Jan Kara <jack@suse.cz>
    block: do not reverse request order when flushing plug list

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: set PLL frequency and trgmii only when trgmii is used

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: remove now incorrect comment regarding port 5

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_dev: guard against a possible division by zero

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix NULL sndbuf_desc in smc_cdc_tx_handler()

Vadim Fedorenko <vadfed@meta.com>
    bnxt_en: reset PHC frequency in free-running mode

Andrea Righi <andrea.righi@canonical.com>
    drm/i915/sseu: fix max_subslices array-index-out-of-bounds access

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Use calculated io and fast wake lines

Niklas Schnelle <schnelle@linux.ibm.com>
    PCI: s390: Fix use-after-free of PCI resources with per-function hotplug

Eugenio Pérez <eperezma@redhat.com>
    vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready

Eugenio Pérez <eperezma@redhat.com>
    vdpa_sim: not reset state in vdpasim_queue_ready

Gautam Dawar <gautam.dawar@amd.com>
    vhost-vdpa: free iommu domain after last use during cleanup

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix kernel crash during reboot when adapter is in recovery mode

Jianguo Wu <wujianguo@chinatelecom.cn>
    ipvlan: Make skb->skb_iif track skb->dev for l3s mode

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: pn533: initialize struct pn533_out_arg properly

Guillaume Tucker <guillaume.tucker@collabora.com>
    selftests: fix LLVM build for i386 and x86_64

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix MLO connection ownership

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: fix NULL-ptr deref in offchan check

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: should not activate virtq object when suspended

Breno Leitao <leitao@debian.org>
    tcp: tcp_make_synack() can be called from process context

Arnd Bergmann <arnd@arndb.de>
    ftrace,kcfi: Define ftrace_stub_graph conditionally

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a procfs host directory removal regression

Lee Duncan <lduncan@suse.com>
    scsi: core: Add BLIST_NO_VPD_SIZE for some VDASD

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_redir: correct value of inet type `.maxattrs`

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_redir: correct length for loading protocol registers

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_masq: correct length for loading protocol registers

Jeremy Sowden <jeremy@azazel.net>
    netfilter: nft_nat: correct length for loading protocol registers

Bjorn Helgaas <bhelgaas@google.com>
    ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix expander node leak in mpi3mr_remove()

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: ioctl timeout when disabling/enabling interrupt

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix memory leaks in mpi3mr_init_ioc()

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Return proper values for failures in firmware init path

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix sas_hba.phy memory leak in mpi3mr_remove()

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix mpi3mr_hba_port memory leak in mpi3mr_remove()

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix config page DMA memory leak

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Fix throttle_groups memory leak

Wenchao Hao <haowenchao2@huawei.com>
    scsi: mpt3sas: Fix NULL pointer access in mpt3sas_transport_port_add()

Glenn Washburn <development@efficientek.com>
    docs: Correct missing "d_" prefix for dentry_operations member d_weak_revalidate

Jaska Uimonen <jaska.uimonen@linux.intel.com>
    ASoC: SOF: ipc4-topology: set dmic dai index from copier

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASOC: SOF: Intel: pci-tgl: Fix device description

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: SKL: Fix device description

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: HDA: Fix device description

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: MTL: Fix the device description

Guillaume Tucker <guillaume.tucker@collabora.com>
    selftests: amd-pstate: fix TEST_FILES

Randy Dunlap <rdunlap@infradead.org>
    clk: HI655X: select REGMAP instead of depending on it

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: fix 1px pink line on GXM when scaling video overlay

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Move the in_send statistic to __smb_send_rqst()

Dan Carpenter <error27@gmail.com>
    fbdev: chipsfb: Fix error codes in chipsfb_pci_init()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/panfrost: Don't sync rpm suspension after mmu flushing

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/msm/gem: Prevent blocking within shrinker loop

Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
    drm/virtio: Pass correct device to dma_sync_sgtable_for_device()

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: Allow transport-mode states with AF_UNSPEC selector


-------------

Diffstat:

 Documentation/filesystems/vfs.rst                  |   2 +-
 Makefile                                           |   4 +-
 arch/loongarch/kernel/time.c                       |  11 +-
 arch/powerpc/Makefile                              |  26 +---
 arch/powerpc/boot/Makefile                         |  14 ++-
 arch/powerpc/mm/fault.c                            |  11 +-
 arch/powerpc/platforms/Kconfig.cputype             |  20 ++-
 arch/riscv/include/asm/mmu.h                       |   2 -
 arch/riscv/include/asm/tlbflush.h                  |  18 ---
 arch/riscv/mm/context.c                            |  40 +++---
 arch/riscv/mm/fault.c                              |   5 +
 arch/riscv/mm/tlbflush.c                           |  28 +++--
 arch/s390/boot/ipl_report.c                        |   8 ++
 arch/s390/pci/pci.c                                |  16 ++-
 arch/s390/pci/pci_bus.c                            |  12 +-
 arch/s390/pci/pci_bus.h                            |   3 +-
 arch/x86/include/asm/sev-common.h                  |   3 +-
 arch/x86/include/asm/svm.h                         |  12 +-
 arch/x86/kernel/cpu/mce/core.c                     |   1 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |   7 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   1 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  25 +++-
 arch/x86/kernel/ftrace_64.S                        |   2 +
 arch/x86/kernel/sev.c                              |  26 ++--
 arch/x86/kvm/svm/avic.c                            |  26 ++--
 arch/x86/kvm/vmx/nested.c                          |  10 +-
 arch/x86/mm/mem_encrypt_identity.c                 |   3 +-
 block/blk-core.c                                   |  16 +--
 block/blk-mq.c                                     |   5 +-
 block/blk-mq.h                                     |   5 +-
 drivers/acpi/pptt.c                                |   5 +-
 drivers/block/loop.c                               |  25 ++--
 drivers/block/null_blk/main.c                      |   6 +-
 drivers/block/sunvdc.c                             |   2 +
 drivers/block/zram/zram_drv.c                      |   4 +-
 drivers/clk/Kconfig                                |   2 +-
 drivers/cpuidle/cpuidle-psci-domain.c              |   3 +-
 drivers/firmware/xilinx/zynqmp.c                   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  19 +++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   3 -
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   6 +-
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |   5 +-
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   2 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  43 +++++--
 drivers/gpu/drm/drm_edid.c                         |   2 +-
 drivers/gpu/drm/drm_gem.c                          |   9 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   9 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   2 +
 drivers/gpu/drm/i915/display/intel_psr.c           |  78 +++++++++---
 drivers/gpu/drm/i915/display/intel_snps_phy.c      |  62 +++++++++
 drivers/gpu/drm/i915/gt/intel_sseu.h               |   2 +-
 drivers/gpu/drm/i915/i915_active.c                 |  25 ++--
 drivers/gpu/drm/meson/meson_vpp.c                  |   2 +
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |  11 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   2 +-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   6 +-
 drivers/gpu/drm/ttm/ttm_device.c                   |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   4 +-
 drivers/hwmon/adt7475.c                            |   8 +-
 drivers/hwmon/ina3221.c                            |   2 +-
 drivers/hwmon/ltc2992.c                            |   1 +
 drivers/hwmon/pmbus/adm1266.c                      |   1 +
 drivers/hwmon/pmbus/ucd9000.c                      |  75 +++++++++++
 drivers/hwmon/tmp513.c                             |   2 +-
 drivers/hwmon/xgene-hwmon.c                        |   1 +
 drivers/interconnect/core.c                        |  68 ++++++----
 drivers/interconnect/imx/imx.c                     |  20 +--
 drivers/interconnect/qcom/icc-rpm.c                |  29 +++--
 drivers/interconnect/qcom/icc-rpmh.c               |  30 +++--
 drivers/interconnect/qcom/msm8974.c                |  20 ++-
 drivers/interconnect/qcom/osm-l3.c                 |  14 +--
 drivers/interconnect/samsung/exynos.c              |  26 ++--
 drivers/md/Kconfig                                 |   4 +
 drivers/md/dm.c                                    |   6 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/memory/tegra/mc.c                          |  16 ++-
 drivers/memory/tegra/tegra124-emc.c                |  12 +-
 drivers/memory/tegra/tegra20-emc.c                 |  12 +-
 drivers/memory/tegra/tegra30-emc.c                 |  12 +-
 drivers/mmc/host/sdhci_am654.c                     |   2 +-
 drivers/net/bonding/bond_main.c                    |  23 ++--
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/dsa/mt7530.c                           |  64 +++++-----
 drivers/net/dsa/mv88e6xxx/chip.c                   |  16 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  28 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  56 +++++----
 drivers/net/ethernet/i825xx/sni_82596.c            |  14 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   1 +
 drivers/net/ethernet/intel/ice/ice.h               |  14 +--
 drivers/net/ethernet/intel/ice/ice_main.c          |  19 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   5 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   4 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |  28 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 -
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  22 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  14 +++
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |   5 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c      |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  12 +-
 drivers/net/ethernet/renesas/rswitch.c             |  74 +++++------
 drivers/net/ethernet/renesas/rswitch.h             |   4 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  12 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |   3 +
 drivers/net/ethernet/sun/sunvnet.c                 |   3 +
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +-
 drivers/net/phy/smsc.c                             |   5 +-
 drivers/net/usb/smsc75xx.c                         |   7 ++
 drivers/net/veth.c                                 |   6 +-
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nfc/st-nci/ndlc.c                          |   6 +-
 drivers/nvme/host/core.c                           |  28 +++--
 drivers/nvme/host/multipath.c                      |   8 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/core.c                         |   4 +-
 drivers/pci/bus.c                                  |  21 ++++
 drivers/scsi/hosts.c                               |   3 -
 drivers/scsi/mpi3mr/mpi3mr.h                       |   5 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  71 +++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  25 ++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  14 ++-
 drivers/scsi/scsi.c                                |   3 +
 drivers/scsi/scsi_devinfo.c                        |   3 +-
 drivers/scsi/scsi_scan.c                           |   3 +
 drivers/tty/serial/8250/8250_em.c                  |   4 +-
 drivers/tty/serial/8250/8250_fsl.c                 |   4 +-
 drivers/tty/serial/8250/Kconfig                    |   3 +-
 drivers/tty/serial/Kconfig                         |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  23 ++--
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   1 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  13 ++
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   2 +-
 drivers/vhost/vdpa.c                               |   3 +-
 drivers/video/fbdev/chipsfb.c                      |  14 ++-
 drivers/video/fbdev/core/fb_defio.c                |  17 ++-
 drivers/video/fbdev/stifb.c                        |  27 ++++
 drivers/virt/coco/sev-guest/sev-guest.c            | 128 +++++++++++--------
 fs/cifs/cifs_debug.c                               |   5 +
 fs/cifs/cifs_dfs_ref.c                             |   1 +
 fs/cifs/cifs_fs_sb.h                               |   2 -
 fs/cifs/cifsglob.h                                 |   4 +-
 fs/cifs/connect.c                                  |  10 +-
 fs/cifs/dfs.c                                      |  67 ++++++----
 fs/cifs/dfs.h                                      |  19 ++-
 fs/cifs/dfs_cache.c                                | 140 ---------------------
 fs/cifs/dfs_cache.h                                |   2 -
 fs/cifs/fs_context.h                               |   1 +
 fs/cifs/misc.c                                     |   8 ++
 fs/cifs/smb2inode.c                                |  31 +++--
 fs/cifs/smb2transport.c                            |   2 +-
 fs/cifs/transport.c                                |  21 ++--
 fs/ext4/namei.c                                    |   4 +-
 fs/ext4/super.c                                    |   7 +-
 fs/ext4/xattr.c                                    |  11 ++
 fs/ocfs2/aops.c                                    |  19 ++-
 include/drm/drm_bridge.h                           |   4 +-
 include/drm/drm_gem.h                              |   4 +-
 include/linux/blk-mq.h                             |   6 +
 include/linux/blkdev.h                             |   5 +-
 include/linux/fb.h                                 |   1 +
 include/linux/interconnect-provider.h              |  12 ++
 include/linux/netdevice.h                          |   6 +-
 include/linux/pci.h                                |   1 +
 include/linux/sh_intc.h                            |   5 +-
 include/linux/tracepoint.h                         |  15 +--
 include/scsi/scsi_device.h                         |   2 +
 include/scsi/scsi_devinfo.h                        |   6 +-
 io_uring/msg_ring.c                                |   4 +-
 kernel/events/core.c                               |   2 +-
 kernel/trace/ftrace.c                              |   3 +-
 kernel/trace/trace.c                               |   2 +
 kernel/trace/trace_events_hist.c                   |  12 ++
 kernel/trace/trace_hwlat.c                         |   7 +-
 mm/huge_memory.c                                   |   6 +-
 mm/mincore.c                                       |   2 +-
 net/9p/client.c                                    |   2 +-
 net/dsa/slave.c                                    |   9 +-
 net/ipv4/fib_frontend.c                            |   3 +
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/ip_tunnel.c                               |  12 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/iucv/iucv.c                                    |   2 +-
 net/mptcp/pm_netlink.c                             |  16 +++
 net/mptcp/protocol.c                               |  64 +++++-----
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                | 128 +++++++------------
 net/netfilter/nft_masq.c                           |   2 +-
 net/netfilter/nft_nat.c                            |   2 +-
 net/netfilter/nft_redir.c                          |   4 +-
 net/smc/smc_cdc.c                                  |   3 +
 net/smc/smc_core.c                                 |   2 +-
 net/wireless/nl80211.c                             |  18 ++-
 net/xfrm/xfrm_state.c                              |   5 -
 scripts/kconfig/confdata.c                         |   6 +-
 sound/hda/intel-dsp-config.c                       |   9 ++
 sound/pci/hda/hda_intel.c                          |   5 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/intel/common/soc-acpi-intel-adl-match.c  |   2 +-
 sound/soc/qcom/qdsp6/q6prm.c                       |   4 +-
 sound/soc/sof/intel/pci-apl.c                      |   1 +
 sound/soc/sof/intel/pci-cnl.c                      |   2 +
 sound/soc/sof/intel/pci-icl.c                      |   1 +
 sound/soc/sof/intel/pci-mtl.c                      |   1 +
 sound/soc/sof/intel/pci-skl.c                      |   2 +
 sound/soc/sof/intel/pci-tgl.c                      |   7 ++
 sound/soc/sof/ipc4-topology.h                      |   2 +-
 tools/testing/selftests/amd-pstate/Makefile        |  13 +-
 tools/testing/selftests/lib.mk                     |   2 +
 tools/testing/selftests/net/devlink_port_split.py  |  36 +++++-
 227 files changed, 1793 insertions(+), 1096 deletions(-)


