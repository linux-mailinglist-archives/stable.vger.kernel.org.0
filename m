Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46E31CBE2E
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 08:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgEIGv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 02:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgEIGv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 02:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8358224955;
        Sat,  9 May 2020 06:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589007118;
        bh=g2wGbm2OFtT0QrAnUdTqUoMUpUdFVXgaw3dx4OiYpfI=;
        h=From:To:Cc:Subject:Date:From;
        b=cET44AVIDorMG2l0ROLHop/mLxGbCMN7TzkuWs4fZS3hJVc52nuS04279ew0tWhZp
         j1BjQ81AMSnszrd6T2XW/BmQo2IR0p7hgC00p4mTxR48TrfZVBMuvjskUipzp71jLq
         Tbn6tjmSwdmXtXhuowy61sxwoNnS+ONXeJbP1ais=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/306] 4.4.223-rc3 review
Date:   Sat,  9 May 2020 08:51:55 +0200
Message-Id: <20200509064507.085696379@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.223-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.223-rc3
X-KernelTest-Deadline: 2020-05-11T06:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.223 release.
There are 306 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 11 May 2020 06:44:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.223-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.223-rc3

Thomas Pedersen <thomas@adapt-ip.com>
    mac80211: add ieee80211_is_any_nullfunc()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Match both PCI ID and SSID for driver blacklist

Jere Leppänen <jere.leppanen@nokia.com>
    sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Herbert Xu <herbert@gondor.apana.org.au>
    macvlan: Fix potential use-after free for broadcasts

Florian Fainelli <f.fainelli@gmail.com>
    net: ep93xx_eth: Do not crash unloading module

Shmulik Ladkani <shmulik.ladkani@ravellosystems.com>
    net: skbuff: Remove errornous length validation in skb_vlan_pop()

Ivan Vecera <ivecera@redhat.com>
    bna: add missing per queue ethtool stat

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Fix problems around fdb entries pointing to the bridge device

Arend Van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: restore stopping netdev queue when bus clogs up

Jaap Jan Meijer <jjmeijer88@gmail.com>
    brcmfmac: add fallback for devices that do not report per-chain values

Laxman Dewangan <ldewangan@nvidia.com>
    pinctrl: tegra: Correctly check the supported configuration

Mans Rullgard <mans@mansr.com>
    ata: sata_dwc_460ex: remove incorrect locking

Neil Armstrong <narmstrong@baylibre.com>
    net: ethernet: davinci_emac: Fix platform_data overwrite

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    cxl: Fix DAR check & use REGION_ID instead of opencoding

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    at803x: fix reset handling

Vivien Didelot <vivien.didelot@savoirfairelinux.com>
    net: dsa: mv88e6xxx: fix port VLAN maps

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    regulator: core: Rely on regulator_dev_release to free constraints

Nicolas Schichan <nschichan@freebox.fr>
    net: mv643xx_eth: fix packet corruption with TSO and tiny unaligned packets.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ovs/vxlan: fix rtnl notifications on iface deletion

Florian Fainelli <f.fainelli@gmail.com>
    net: ethoc: Fix early error paths

pravin shelar <pshelar@ovn.org>
    net: vxlan: lwt: Fix vxlan local traffic.

Arnd Bergmann <arnd@arndb.de>
    mvpp2: use correct size for memset

Geert Uytterhoeven <geert+renesas@glider.be>
    ravb: Add missing free_irq() call to ravb_close()

Cyrille Pitchen <cyrille.pitchen@atmel.com>
    net: macb: replace macb_writel() call by queue_writel() to update queue ISR

Jisheng Zhang <jszhang@marvell.com>
    net: mvneta: fix trivial cut-off issue in mvneta_ethtool_update_stats

David Ahern <dsa@cumulusnetworks.com>
    net: icmp_route_lookup should use rt dev to determine L3 domain

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    hwrng: exynos - Disable runtime PM on driver unbind

Sabrina Dubroca <sd@queasysnail.net>
    l2tp: fix use-after-free during module unload

xypron.glpk@gmx.de <xypron.glpk@gmx.de>
    net: ehea: avoid null pointer dereference

Vivien Didelot <vivien.didelot@savoirfairelinux.com>
    net: dsa: mv88e6xxx: enable SA learning on DSA ports

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: don't increment tx_dropped in br_do_proxy_arp

Johan Hovold <johan@kernel.org>
    net: hns: fix device reference leaks

Johan Hovold <johan@kernel.org>
    net: ethernet: ti: cpsw: fix secondary-emac probe error path

Johan Hovold <johan@kernel.org>
    net: ethernet: ti: cpsw: fix device and of_node leaks

Andrew Lunn <andrew@lunn.ch>
    net: ethernet: mvneta: Remove IFF_UNICAST_FLT which is not implemented

Neil Armstrong <narmstrong@baylibre.com>
    net: ethernet: davinci_emac: Fix devioctl while in fixed link

Florian Fainelli <f.fainelli@gmail.com>
    bnxt_en: Remove locking around txr->dev_state

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    net: axienet: Fix return value check in axienet_probe()

Eric Dumazet <edumazet@google.com>
    qdisc: fix a module refcount leak in qdisc_create_dflt()

Eric Dumazet <edumazet@google.com>
    bnxt: add a missing rcu synchronization

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ovs/geneve: fix rtnl notifications on iface deletion

Johan Hovold <johan@kernel.org>
    net: ethernet: stmmac: dwmac-generic: fix probe error path

Eric Dumazet <edumazet@google.com>
    fq_codel: return non zero qlen in class dumps

Johan Hovold <johan@kernel.org>
    net: ethernet: stmmac: dwmac-rk: fix probe error path

Mathias Krause <minipli@googlemail.com>
    rtnl: reset calcit fptr in rtnl_unregister()

Johan Hovold <johan@kernel.org>
    net: ethernet: stmmac: dwmac-sti: fix probe error path

Florian Fainelli <f.fainelli@gmail.com>
    et131x: Fix logical vs bitwise check in et131x_tx_timeout()

David Ahern <dsa@cumulusnetworks.com>
    net: icmp6_send should use dst dev to determine L3 domain

Wei Yongjun <weiyongjun1@huawei.com>
    tipc: fix the error handling in tipc_udp_enable()

Eric Dumazet <edumazet@google.com>
    macvtap: segmented packet is consumed

Wei Yongjun <weiyj.lk@gmail.com>
    net: macb: add missing free_netdev() on error in macb_probe()

Jiri Benc <jbenc@redhat.com>
    cxgbi: fix uninitialized flowi6

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmsysport: Device stats are unsigned long

Bert Kenward <bkenward@solarflare.com>
    sfc: clear napi_hash state when copying channels

Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>
    sfc: fix potential stack corruption from running past stat bitmask

Jiri Benc <jbenc@redhat.com>
    gre: reject GUE and FOU in collect metadata mode

Jiri Benc <jbenc@redhat.com>
    gre: build header correctly for collect metadata tunnels

Jiri Benc <jbenc@redhat.com>
    gre: do not assign header_ops in collect metadata mode

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ovs/gre: fix rtnl notifications on iface deletion

Eric Dumazet <edumazet@google.com>
    net: bcmgenet: device stats are unsigned long

Petri Gynther <pgynther@google.com>
    net: bcmgenet: fix skb_len in bcmgenet_xmit_single()

Hariprasad Shenai <hariprasad@chelsio.com>
    cxgb4/cxgb4vf: Fixes regression in perf when tx vlan offload is disabled

Simon Horman <simon.horman@netronome.com>
    openvswitch: update checksum in {push,pop}_mpls

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: edma: Add probe callback to edma_tptc_driver

Tahsin Erdogan <tahsin@google.com>
    dm: fix second blk_delay_queue() parameter to be in msec units not jiffies

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    blk-mq: fix undefined behaviour in order_to_size()

Junxiao Bi <junxiao.bi@oracle.com>
    gfs2: fix flock panic issue

Vivien Didelot <vivien.didelot@savoirfairelinux.com>
    net: dsa: mv88e6xxx: unlock DSA and CPU ports

Viresh Kumar <viresh.kumar@linaro.org>
    Revert "cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT"

Marcin Nowakowski <marcin.nowakowski@imgtec.com>
    MIPS: perf: Remove incorrect odd/even counter handling for I6400

Tobias Jungel <tobias.jungel@gmail.com>
    bonding: fix length of actor system

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ALSA: fm801: Initialize chip after IRQ handler is registered

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix backchannel allocation of extra rpcrdma_reps

Eric Dumazet <edumazet@google.com>
    mlx4: do not call napi_schedule() without care

David Ahern <dsahern@kernel.org>
    ipv4: Fix table id reference in fib_sync_down_addr

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti6: fix input path

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    net: Don't delete routes in different VRFs

David Ahern <dsa@cumulusnetworks.com>
    net: vrf: Fix dst reference counting

Marcin Niestroj <m.niestroj@grinn-global.com>
    power_supply: tps65217-charger: Fix NULL deref during property export

Liu Xiang <liu.xiang6@zte.com.cn>
    power: bq27xxx_battery: Fix bq27541 AveragePower register address

Sasha Levin <sasha.levin@oracle.com>
    power: test_power: correctly handle empty writes

H. Nikolaus Schaller <hns@goldelico.com>
    power: bq27xxx: fix register numbers of bq27500

H. Nikolaus Schaller <hns@goldelico.com>
    power: bq27xxx: fix reading for bq27000 and bq27010

Peter Zijlstra <peterz@infradead.org>
    sched/preempt: Fix preempt_count manipulations

Eric Dumazet <edumazet@google.com>
    pkt_sched: fq: use proper locking in fq_dump_stats()

Hadar Hen Zion <hadarh@mellanox.com>
    net_sched: flower: Avoid dissection of unmasked keys

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix calc_cfs_shares() fixed point arithmetics width confusion

Elad Raz <eladr@mellanox.com>
    mlxsw: switchx2: Fix ethernet port initialization

Yotam Gigi <yotamg@mellanox.com>
    mlxsw: switchx2: Fix misuse of hard_header_len

Moshe Shemesh <moshe@mellanox.com>
    net/mlx4_core: Fix QUERY FUNC CAP flags

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4: Fix uninitialized fields in rule when adding promiscuous mode to device managed flow steering

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_en: Fix potential deadlock in port statistics flow

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Do not access comm channel if it has not yet been initialized

Erez Shitrit <erezsh@mellanox.com>
    net/mlx4_en: Process all completions in RX rings after port goes up

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: Fix the resource-type enum in res tracker to conform to FW spec

Alex Vesker <valex@mellanox.com>
    net/mlx4_core: Check device state before unregistering it

Kamal Heib <kamalh@mellanox.com>
    net/mlx4_en: Fix the return value of a failure in VLAN VID add/kill

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix access to uninitialized index

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx4_core: Fix potential corruption in counters database

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix map not being uncharged during map creation failure

Alexei Starovoitov <ast@fb.com>
    bpf, trace: check event type in bpf_perf_event_read

Zi Shen Lim <zlim.lnx@gmail.com>
    arm64: bpf: jit JMP_JSET_{X,K}

Daniel Borkmann <daniel@iogearbox.net>
    cls_bpf: reset class and reuse major in da

Laura Abbott <labbott@redhat.com>
    clk: xgene: Don't call __pa on ioremaped address

Dong Aisheng <aisheng.dong@nxp.com>
    clk: imx: clk-pllv3: fix incorrect handle of enet powerdown bit

Maxime Ripard <maxime.ripard@free-electrons.com>
    clk: multiplier: Prevent the multiplier from under / over flowing

Tero Kristo <t-kristo@ti.com>
    clk: ti: omap3+: dpll: use non-locking version of clk_get_rate

Brian Norris <computersforpeace@gmail.com>
    clk: gpio: handle error codes for of_clk_get_parent_count()

Arnd Bergmann <arnd@arndb.de>
    clk: st: avoid uninitialized variable use

Pablo Neira <pablo@netfilter.org>
    udp: restore UDPlite many-cast delivery

Liping Zhang <zlpnobody@gmail.com>
    netfilter: nft_dup: do not use sreg_dev if the user doesn't specify it

Liping Zhang <zlpnobody@gmail.com>
    netfilter: nf_tables: destroy the set if fail to add transaction

Liping Zhang <zlpnobody@gmail.com>
    netfilter: nft_dynset: fix panic if NFT_SET_HASH is not enabled

Liping Zhang <liping.zhang@spreadtrum.com>
    netfilter: nf_tables: fix a wrong check to skip the inactive rules

David Ahern <dsa@cumulusnetworks.com>
    net: ipv6: Fix processing of RAs in presence of VRF

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: add missing netconf notif when 'all' is updated

Eric Dumazet <edumazet@google.com>
    ipv6: do not abuse GFP_ATOMIC in inet6_netconf_notify_devconf()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix checksum annotation in udp6_csum_init

David Ahern <dsa@cumulusnetworks.com>
    net: vrf: Fix dev refcnt leak due to IPv6 prefix route

Eric Dumazet <edumazet@google.com>
    ipv4: accept u8 in IP_TOS ancillary data

Eric Dumazet <edumazet@google.com>
    ipv4: do not abuse GFP_ATOMIC in inet_netconf_notify_devconf()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv4: fix checksum annotation in udp4_csum_init

Alexander Duyck <aduyck@mirantis.com>
    flow_dissector: Check for IP fragmentation even if not using IPv4 address

Alexander Duyck <alexander.h.duyck@intel.com>
    ipv4: Fix memory leak in exception case for splitting tries

Douglas Miller <dougmill@linux.vnet.ibm.com>
    be2net: Don't leak iomapped memory on removal.

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: Fix memory leak in error path

Vince Hsu <vince.h@nvidia.com>
    memory/tegra: Add number of TLB lines for Tegra124

Bart Van Assche <bart.vanassche@sandisk.com>
    target: Fix a memory leak in target_dev_lba_map_store()

Dan Carpenter <dan.carpenter@oracle.com>
    qlcnic: use the correct ring in qlcnic_83xx_process_rcv_ring_diag()

Dan Carpenter <dan.carpenter@oracle.com>
    qlcnic: potential NULL dereference in qlcnic_83xx_get_minidump_template()

Dan Carpenter <dan.carpenter@oracle.com>
    qede: uninitialized variable in qede_start_xmit()

Dan Carpenter <dan.carpenter@oracle.com>
    i40e: fix an uninitialized variable bug

Dan Carpenter <dan.carpenter@oracle.com>
    power: ipaq-micro-battery: freeing the wrong variable

Dan Carpenter <dan.carpenter@oracle.com>
    ethernet: micrel: fix some error codes

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: lp8788-irq: Uninitialized variable in irq handler

Dan Carpenter <dan.carpenter@oracle.com>
    net: moxa: fix an error code

Dan Carpenter <dan.carpenter@oracle.com>
    VFIO: platform: reset: fix a warning message condition

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k_htc: check for underflow in ath9k_htc_rx_msg()

Dan Carpenter <dan.carpenter@oracle.com>
    cx23885: uninitialized variable in cx23885_av_work_handler()

Dan Carpenter <dan.carpenter@oracle.com>
    am437x-vpfe: fix an uninitialized variable bug

Alexey Khoroshilov <khoroshilov@ispras.ru>
    lirc_imon: do not leave imon_probe() with mutex held

Russell King <rmk+kernel@arm.linux.org.uk>
    rc: allow rc modules to be loaded if rc-main is not a module

Doug Berger <opendmb@gmail.com>
    net: systemport: suppress warnings on failed Rx SKB allocations

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: suppress warnings on failed Rx SKB allocations

Nathan Chancellor <natechancellor@gmail.com>
    lib/mpi: Fix building for powerpc with clang

Jeremie Francois (on alpha) <jeremie.francois@gmail.com>
    scripts/config: allow colons in option strings for sed

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: protect updating server->dstaddr with a spinlock

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    wimax/i2400m: Fix potential urb refcnt leak

Tyler Hicks <tyhicks@linux.microsoft.com>
    selftests/ipc: Fix test failure seen after initial test run

YueHaibing <yuehaibing@huawei.com>
    iio:ad7797: Use correct attribute_group

Dan Carpenter <dan.carpenter@oracle.com>
    mdio-sun4i: oops in error handling in probe

Robin Murphy <robin.murphy@arm.com>
    iommu/dma: Respect IOMMU aperture when allocating

David Rivshin <drivshin@allworx.com>
    drivers: net: cpsw: don't ignore phy-mode if phy-handle is used

Johan Hovold <johan@kernel.org>
    net: dsa: slave: fix of-node leak and phy priority

Roosen Henri <Henri.Roosen@ginzinger.com>
    phy: micrel: Fix finding PHY properties in MAC node for KSZ9031.

Johan Hovold <johan@kernel.org>
    of_mdio: fix node leak in of_phy_register_fixed_link error path

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: bcm7xxx: Fix shadow mode 2 disabling

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Fix phy_mac_interrupt()

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS

Dan Carpenter <dan.carpenter@oracle.com>
    NFC: nci: memory leak in nci_core_conn_create()

Chuck Lever <chuck.lever@oracle.com>
    sunrpc: Update RPCBIND_MAXNETIDLEN

Xin Long <lucien.xin@gmail.com>
    sctp: fix the transports round robin issue when init is retransmitted

Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
    powerpc/book3s: Fix MCE console messages for unrecoverable MCE.

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix stack pointer corruption in __tm_recheckpoint()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    perf tools: Fix perf regs mask generation

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix regression setting power on Trats2 board

Nicholas Mc Guire <hofrat@osadl.org>
    mmc: moxart: fix wait_for_completion_interruptible_timeout return variable type

Douglas Anderson <dianders@chromium.org>
    mmc: dw_mmc: rockchip: Set the drive phase properly

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Revert "clk: rockchip: reset init state before mmc card initialization"

Olof Johansson <olof@lixom.net>
    mmc: block: return error on failed mmc_blk_get()

Chuanxiao Dong <chuanxiao.dong@intel.com>
    mmc: debugfs: correct wrong voltage value

Russell King <rmk+kernel@arm.linux.org.uk>
    mmc: sd: limit SD card power limit according to cards capabilities

Jisheng Zhang <jszhang@marvell.com>
    mmc: sdhci: restore behavior when setting VDD via external regulator

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Revert "ACPI / LPSS: allow to use specific PM domain during ->probe()"

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    ASoC: fsl_ssi: mark SACNT register volatile

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    ASoC: tegra_alc5632: check return value

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: Intel: pass correct parameter in sst_alloc_stream_mrfld()

Boris Brezillon <boris.brezillon@free-electrons.com>
    mtd: nand: denali: add missing nand_release() call in denali_remove()

Eric Dumazet <edumazet@google.com>
    net: get rid of an signed integer overflow in ip_idents_reserve()

Chuck Lever <chuck.lever@oracle.com>
    NFS: Fix an LOCK/OPEN race when unlinking an open file

Ilan Peer <ilan.peer@intel.com>
    mac80211: Fix BW upgrade for TDLS peers

Arik Nemtsov <arik@wizery.com>
    mac80211: TDLS: change BW calculation for WIDER_BW peers

Arik Nemtsov <arik@wizery.com>
    mac80211: TDLS: always downgrade invalid chandefs

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix mgmt-tx abort cookie and leak

Ilan Tayari <ilant@mellanox.com>
    xfrm: Fix memory leak of aead algorithm name

Mathias Krause <minipli@googlemail.com>
    xfrm_user: propagate sec ctx allocation errors

Alexey Kodanev <alexey.kodanev@oracle.com>
    net/xfrm_input: fix possible NULL deref of tunnel.ip6->parms.i_key

Philipp Zabel <p.zabel@pengutronix.de>
    Input: edt-ft5x06 - fix setting gain, offset, and threshold via device tree

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: gpio-keys - fix check for disabling unsupported keys

Dan Carpenter <dan.carpenter@oracle.com>
    Btrfs: clean up an error code in btrfs_init_space_info()

William Breathitt Gray <vilhelm.gray@gmail.com>
    isa: Call isa_bus_init before dependent ISA bus drivers register

Olaf Hering <olaf@aepfle.de>
    Drivers: hv: utils: use memdup_user in hvt_op_write

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    serial: samsung: Fix possible out of bounds access on non-DT platform

Stephen Boyd <stephen.boyd@linaro.org>
    tty: serial: msm: Support more bauds

Simon Wunderlich <sw@simonwunderlich.de>
    batman-adv: replace WARN with rate limited output on non-existing VLAN

Sven Eckelmann <sven@open-mesh.com>
    batman-adv: Fix lockdep annotation of batadv_tlv_container_remove

David Ahern <dsa@cumulusnetworks.com>
    net: ipv6: tcp reset, icmp need to consider L3 domain

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    RDS:TCP: Synchronize rds_tcp_accept_one with rds_send_xmit when resetting t_sock

Eric Dumazet <edumazet@google.com>
    tcp: do not set rtt_min to 1

Johannes Weiner <hannes@cmpxchg.org>
    net: tcp_memcontrol: properly detect ancestor socket pressure

Yotam Gigi <yotamg@mellanox.com>
    mlxsw: spectrum: Fix misuse of hard_header_len

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Indicate support for autonegotiation

Nogah Frankel <nogahf@mellanox.com>
    mlxsw: spectrum: Don't count internal TX header bytes to stats

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Disable learning according to STP state

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Don't forward packets when STP state is DISABLED

Honggang Li <honli@redhat.com>
    RDMA/cxgb3: device driver frees DMA memory with different size

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: rpcrdma_bc_receive_call() should init rq_private_buf.len

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: xprt_rdma_free() must not release backchannel reqs

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix additional uses of spin_lock_irqsave(rb_lock)

Dan Carpenter <dan.carpenter@oracle.com>
    xprtrdma: checking for NULL instead of IS_ERR()

Raja Mani <rmani@qti.qualcomm.com>
    ath10k: free cached fw bin contents when get board id fails

Boris Brezillon <boris.brezillon@free-electrons.com>
    mtd: nand: fix ONFI parameter page layout

Eric Dumazet <edumazet@google.com>
    bonding: prevent out of bound accesses

Johan Hovold <johan@kernel.org>
    phy: fix device reference leaks

phil.turnbull@oracle.com <phil.turnbull@oracle.com>
    irda: Free skb on irda_accept error path.

Jiri Kosina <jkosina@suse.cz>
    btrfs: cleaner_kthread() doesn't need explicit freeze

WANG Cong <xiyou.wangcong@gmail.com>
    sch_tbf: update backlog as well

WANG Cong <xiyou.wangcong@gmail.com>
    sch_sfb: keep backlog updated with qlen

WANG Cong <xiyou.wangcong@gmail.com>
    sch_qfq: keep backlog updated with qlen

WANG Cong <xiyou.wangcong@gmail.com>
    sch_prio: update backlog as well

WANG Cong <xiyou.wangcong@gmail.com>
    sch_hfsc: always keep backlog updated

WANG Cong <xiyou.wangcong@gmail.com>
    sch_drr: update backlog as well

WANG Cong <xiyou.wangcong@gmail.com>
    net_sched: keep backlog updated with qlen

Matthew Finlay <matt@mellanox.com>
    net/mlx5e: Copy all L2 headers into inline segment

Mohamad Haj Yahia <mohamad@mellanox.com>
    net/mlx5: Fix pci error recovery flow

Mohamad Haj Yahia <mohamad@mellanox.com>
    net/mlx5: Add timeout handle to commands with callback

Mohamad Haj Yahia <mohamad@mellanox.com>
    net/mlx5: Fix potential deadlock in command mode change

Daniel Jurgens <danielj@mellanox.com>
    net/mlx5: Fix wait_vital for VFs and remove fixed sleep

Mohamad Haj Yahia <mohamad@mellanox.com>
    net/mlx5: Avoid calling sleeping function by the health poll thread

Wang Sheng-Hui <shhuiw@foxmail.com>
    net/mlx5: use mlx5_buf_alloc_node instead of mlx5_buf_alloc in mlx5_wq_ll_create

Eli Cohen <eli@mellanox.com>
    net/mlx5e: Fix blue flame quota logic

Majd Dibbiny <majd@mellanox.com>
    net/mlx5: Fix masking of reserved bits in XRCD number

Majd Dibbiny <majd@mellanox.com>
    net/mlx5: Fix the size of modify QP mailbox

Rana Shahout <ranas@mellanox.com>
    net/mlx5e: Fix MLX5E_100BASE_T define

Eran Ben Elisha <eranbe@mellanox.com>
    IB/mlx5: Fix FW version diaplay in sysfs

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx5: Make command timeout way shorter

Leon Romanovsky <leon@leon.nu>
    IB/mlx5: Fix RC transport send queue overhead computation

Noa Osherovich <noaos@mellanox.com>
    net/mlx5: Avoid passing dma address 0 to firmware

Peter Griffin <peter.griffin@linaro.org>
    c8sectpfe: Rework firmware loading mechanism

Brian Norris <computersforpeace@gmail.com>
    firmware: actually return NULL on failed request_firmware_nowait()

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pci/of: Parse unassigned resources

Alexander Duyck <aduyck@mirantis.com>
    GRE: Disable segmentation offloads w/ CSUM and we are encapsulated via FOU

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ovs/gre,geneve: fix error path when creating an iface

Matan Barak <matanb@mellanox.com>
    IB/mlx4: Initialize hop_limit when creating address handle

Ido Schimmel <idosch@mellanox.com>
    mlxsw: Treat local port 64 as valid

Franky Lin <franky.lin@broadcom.com>
    brcmfmac: add eth_type_trans back for PCIe full dongle

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Allow VPD short read

Bjorn Helgaas <bhelgaas@google.com>
    alpha/PCI: Call iomem_is_exclusive() for IORESOURCE_MEM, but not IORESOURCE_IO

Daniel Jurgens <danielj@mellanox.com>
    net/mlx4_core: Implement pci_resume callback

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Supply CPU physical address (not bus address) to iomem_is_exclusive()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: pci: Correctly determine if descriptor queue is full

Daniel Jurgens <danielj@mellanox.com>
    net/mlx4_core: Do not BUG_ON during reset when PCI is offline

Willem de Bruijn <willemb@google.com>
    dccp: limit sk_filter trim to payload

Chin-Ran Lo <crlo@marvell.com>
    Bluetooth: btmrvl: fix hung task warning dump

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: set max firmware version of 7265 to 17

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: add missing check for PCIe8997 chipset

chunfan chen <jeffc@marvell.com>
    mwifiex: fix IBSS data path issue.

Vegard Nossum <vegard.nossum@oracle.com>
    xfrm: fix crash in XFRM_MSG_GETSA netlink handler

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: use original skbuff when acking batches

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ALSA: fm801: detect FM-only card earlier

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ALSA: fm801: propagate TUNER_ONLY bit when autodetected

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ALSA: fm801: explicitly free IRQ line

Dan Carpenter <dan.carpenter@oracle.com>
    x86/apic/uv: Silence a shift wrapping warning

Jan Beulich <JBeulich@suse.com>
    x86/LDT: Print the real LDT base address

Stephane Eranian <eranian@google.com>
    perf/x86: Fix filter_events() bug with event mappings

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: hwmod: fix _idle() hwmod state sanity check sequence

Heinrich Schuchardt <xypron.glpk@gmx.de>
    ARM: dts: kirkwood: add kirkwood-ds112.dtb to Makefile

Heinrich Schuchardt <xypron.glpk@gmx.de>
    ARM: dts: kirkwood: use unique machine name for ds112

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: orion5x: fix the missing mtd flash on linkstation lswtgl

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: orion5x: gpio pin fixes for linkstation lswtgl

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: kirkwood: gpio-leds fixes for linkstation ls-wvl/vl

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: kirkwood: gpio-leds fixes for linkstation ls-wxl/wsxl

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: kirkwood: gpio pin fixes for linkstation ls-wvl/vl

Roger Shimizu <rogershimizu@gmail.com>
    ARM: dts: kirkwood: gpio pin fixes for linkstation ls-wxl/wsxl

Arnd Bergmann <arnd@arndb.de>
    ARM: imx: select SRC for i.MX7

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: armadillo800eva Correct extal1 frequency to 24 MHz

Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
    mips/panic: replace smp_send_stop() with kdump friendly version in panic path

James Hogan <james.hogan@imgtec.com>
    MIPS: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO

Dan Carpenter <dan.carpenter@oracle.com>
    MIPS: RM7000: Double locking bug in rm7k_tc_disable()

Daniel Borkmann <daniel@iogearbox.net>
    bpf, mips: fix off-by-one in ctx offset allocation

Dan Carpenter <dan.carpenter@oracle.com>
    MIPS: Octeon: Off by one in octeon_irq_gpio_map()

James Hogan <james.hogan@imgtec.com>
    MIPS: c-r4k: Fix protected_writeback_scache_line for EVA

James Hogan <james.hogan@imgtec.com>
    MIPS: SMP: Update cpu_foreign_map on CPU disable

James Hogan <james.hogan@imgtec.com>
    MIPS: KVM: Fix translation of MFC0 ErrCtl

James Hogan <james.hogan@imgtec.com>
    MIPS: perf: Fix I6400 event numbers

Paul Burton <paul.burton@imgtec.com>
    MIPS: Fix BC1{EQ,NE}Z return offset calculation

Paul Burton <paul.burton@imgtec.com>
    MIPS: math-emu: Fix BC1{EQ,NE}Z emulation

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Adjust mips-hpt-frequency for BCM7435

James Hogan <james.hogan@imgtec.com>
    MIPS: Fix HTW config on XPA kernel without LPA enabled

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Pretty print BMIPS5200 processor name

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: local_r4k___flush_cache_all needs to blast S-cache

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Clear MIPS_CACHE_ALIASES earlier

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: BMIPS5000 has I cache filing from D cache

Matt Redfearn <matt.redfearn@imgtec.com>
    MIPS: scall: Handle seccomp filters which redirect syscalls

Paul Burton <paul.burton@imgtec.com>
    MIPS: smp-cps: Stop printing EJTAG exceptions to UART

Florian Fainelli <f.fainelli@gmail.com>
    MIPS: BMIPS: Fix PRID_IMP_BMIPS5000 masking for BMIPS5200

James Hogan <james.hogan@imgtec.com>
    MIPS: ptrace: Drop cp0_tcstatus from regoffset_table[]

Jaedon Shin <jaedon.shin@gmail.com>
    MIPS: Fix macro typo

Felipe Balbi <felipe.balbi@linux.intel.com>
    usb: gadget: udc: core: don't starve DMA resources

Iago Abal <mail@iagoabal.eu>
    usb: gadget: pch_udc: reorder spin_[un]lock to avoid deadlock

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadged: pch_udc: get rid of redundant assignments

Krzysztof Opasiak <k.opasiak@samsung.com>
    usb: gadget: f_acm: Fix configfs attr name

Ben Hutchings <ben@decadent.org.uk>
    staging: rtl8192u: Fix crash due to pointers being "confusing"

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: qxl_release use after free

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix PCIe register information for 8997 chipset


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/pci-sysfs.c                      |   4 +-
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/kirkwood-ds112.dts               |   2 +-
 arch/arm/boot/dts/kirkwood-lswvl.dts               |  25 +--
 arch/arm/boot/dts/kirkwood-lswxl.dts               |  31 ++--
 arch/arm/boot/dts/orion5x-linkstation-lswtgl.dts   |  39 ++++-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts      |   2 +-
 arch/arm/mach-imx/Kconfig                          |   1 +
 arch/arm/mach-omap2/omap_hwmod.c                   |  12 +-
 arch/arm64/net/bpf_jit_comp.c                      |   1 +
 arch/mips/boot/dts/brcm/bcm7435.dtsi               |   2 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   2 +-
 arch/mips/cavium-octeon/setup.c                    |  14 ++
 arch/mips/cavium-octeon/smp.c                      |   1 +
 arch/mips/include/asm/elf.h                        |   1 +
 arch/mips/include/asm/kexec.h                      |   1 +
 arch/mips/include/asm/r4kcache.h                   |   4 +
 arch/mips/include/asm/smp.h                        |   2 +
 arch/mips/include/uapi/asm/auxvec.h                |   2 +
 arch/mips/kernel/bmips_vec.S                       |   9 +-
 arch/mips/kernel/branch.c                          |  18 +--
 arch/mips/kernel/cps-vec.S                         |   1 -
 arch/mips/kernel/cpu-probe.c                       |   5 +-
 arch/mips/kernel/crash.c                           |  18 ++-
 arch/mips/kernel/machine_kexec.c                   |   1 +
 arch/mips/kernel/perf_event_mipsxx.c               |  60 ++++++-
 arch/mips/kernel/ptrace.c                          |   3 -
 arch/mips/kernel/scall32-o32.S                     |  11 +-
 arch/mips/kernel/scall64-64.S                      |   3 +-
 arch/mips/kernel/scall64-n32.S                     |  14 +-
 arch/mips/kernel/scall64-o32.S                     |  14 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/mips/kernel/smp-bmips.c                       |   1 +
 arch/mips/kernel/smp-cps.c                         |   1 +
 arch/mips/kernel/smp.c                             |   2 +-
 arch/mips/kvm/dyntrans.c                           |   2 +-
 arch/mips/loongson64/loongson-3/smp.c              |   1 +
 arch/mips/math-emu/cp1emu.c                        |  11 +-
 arch/mips/mm/c-r4k.c                               |  13 +-
 arch/mips/mm/sc-rm7k.c                             |   2 +-
 arch/mips/mm/tlbex.c                               |   4 +-
 arch/mips/net/bpf_jit.c                            |   2 +-
 arch/powerpc/kernel/mce.c                          |   3 +-
 arch/powerpc/kernel/pci_of_scan.c                  |  12 +-
 arch/powerpc/kernel/tm.S                           |   3 +-
 arch/powerpc/platforms/powernv/opal.c              |   1 +
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   4 +-
 arch/x86/kernel/cpu/perf_event.c                   |  11 +-
 arch/x86/kernel/process_64.c                       |   2 +-
 block/blk-mq.c                                     |   2 +-
 drivers/acpi/acpi_lpss.c                           |   8 +-
 drivers/ata/sata_dwc_460ex.c                       |   4 +-
 drivers/base/firmware_class.c                      |   8 +-
 drivers/base/isa.c                                 |   2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |   3 +-
 drivers/char/hw_random/exynos-rng.c                |   9 ++
 drivers/clk/clk-gpio.c                             |   6 +-
 drivers/clk/clk-multiplier.c                       |  20 ++-
 drivers/clk/clk-xgene.c                            |  10 +-
 drivers/clk/imx/clk-pllv3.c                        |   8 +-
 drivers/clk/rockchip/clk-mmc-phase.c               |  11 --
 drivers/clk/st/clkgen-fsyn.c                       |  17 +-
 drivers/clk/ti/dpll3xxx.c                          |   3 +-
 drivers/cpufreq/cpufreq.c                          |   5 -
 drivers/dma/edma.c                                 |   6 +
 drivers/gpu/drm/qxl/qxl_cmd.c                      |   5 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   6 +-
 drivers/gpu/drm/qxl/qxl_draw.c                     |  13 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |   5 +-
 drivers/hv/hv_utils_transport.c                    |   9 +-
 drivers/iio/adc/ad7793.c                           |   2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |   2 +-
 drivers/infiniband/hw/mlx4/ah.c                    |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  12 +-
 drivers/input/keyboard/gpio_keys.c                 |  29 +++-
 drivers/input/touchscreen/edt-ft5x06.c             |  18 ++-
 drivers/iommu/dma-iommu.c                          |  11 +-
 drivers/md/dm.c                                    |   2 +-
 drivers/media/pci/cx23885/cx23885-av.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   2 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  65 +++-----
 drivers/media/rc/rc-main.c                         |   2 +-
 drivers/memory/tegra/tegra124.c                    |   1 +
 drivers/mfd/lp8788-irq.c                           |   2 +-
 drivers/misc/cxl/fault.c                           |   2 +-
 drivers/mmc/card/block.c                           |   4 +-
 drivers/mmc/core/debugfs.c                         |   2 +-
 drivers/mmc/core/sd.c                              |  20 ++-
 drivers/mmc/host/dw_mmc-rockchip.c                 |  64 ++++++++
 drivers/mmc/host/moxart-mmc.c                      |   5 +-
 drivers/mmc/host/sdhci-pxav3.c                     |  22 +++
 drivers/mmc/host/sdhci.c                           |  44 +++--
 drivers/mmc/host/sdhci.h                           |   4 +
 drivers/mtd/nand/denali.c                          |  11 +-
 drivers/net/bonding/bond_3ad.c                     |  11 +-
 drivers/net/bonding/bond_alb.c                     |   7 +-
 drivers/net/bonding/bond_netlink.c                 |   3 +-
 drivers/net/dsa/mv88e6xxx.c                        |   9 +-
 drivers/net/ethernet/agere/et131x.c                |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  11 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |   7 +-
 drivers/net/ethernet/cadence/macb.c                |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |   2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |   4 +
 drivers/net/ethernet/emulex/benet/be.h             |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |   4 +
 drivers/net/ethernet/ethoc.c                       |  10 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   8 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c         |   2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   4 +-
 drivers/net/ethernet/marvell/mvneta.c              |  11 +-
 drivers/net/ethernet/marvell/mvpp2.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx4/catas.c         |  11 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   9 ++
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  28 +++-
 drivers/net/ethernet/mellanox/mlx4/en_port.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   5 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   2 +-
 drivers/net/ethernet/mellanox/mlx4/intf.c          |   3 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |  39 +++--
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |  11 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   5 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |  13 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 117 ++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  84 +++++-----
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  26 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |  15 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/port.h         |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  11 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |   3 +-
 drivers/net/ethernet/micrel/ks8842.c               |  10 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +
 drivers/net/ethernet/sfc/ef10.c                    |   3 +-
 drivers/net/ethernet/sfc/efx.c                     |   3 +
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  11 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    |  11 +-
 drivers/net/ethernet/ti/cpsw-phy-sel.c             |   3 +
 drivers/net/ethernet/ti/cpsw.c                     |  14 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   7 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   4 +-
 drivers/net/geneve.c                               |  14 +-
 drivers/net/macvlan.c                              |  10 +-
 drivers/net/macvtap.c                              |   2 +-
 drivers/net/phy/at803x.c                           |   6 +-
 drivers/net/phy/bcm7xxx.c                          |   2 +-
 drivers/net/phy/mdio-sun4i.c                       |   4 +-
 drivers/net/phy/micrel.c                           |  12 +-
 drivers/net/phy/phy.c                              |  46 +++---
 drivers/net/phy/phy_device.c                       |   2 +
 drivers/net/vrf.c                                  | 177 ++-------------------
 drivers/net/vxlan.c                                |  62 +++++---
 drivers/net/wimax/i2400m/usb-fw.c                  |   1 +
 drivers/net/wireless/ath/ath10k/core.c             |   2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  16 ++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  22 ++-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |   2 +
 drivers/net/wireless/iwlwifi/iwl-7000.c            |   2 +-
 drivers/net/wireless/mwifiex/pcie.h                |   9 +-
 drivers/net/wireless/mwifiex/sta_event.c           |  10 +-
 drivers/net/wireless/mwifiex/wmm.c                 |   6 +-
 drivers/of/of_mdio.c                               |   5 +-
 drivers/pci/pci-sysfs.c                            |   7 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   2 +-
 drivers/pinctrl/pinctrl-tegra.c                    |   2 +-
 drivers/power/bq27xxx_battery.c                    |  20 ++-
 drivers/power/ipaq_micro_battery.c                 |   2 +-
 drivers/power/test_power.c                         |   2 +
 drivers/power/tps65217_charger.c                   |   6 +-
 drivers/regulator/core.c                           |  29 ++--
 drivers/scsi/cxgbi/libcxgbi.c                      |   1 +
 drivers/staging/media/lirc/lirc_imon.c             |   2 +
 drivers/staging/rtl8192u/r8192U_core.c             |   4 +-
 drivers/target/target_core_configfs.c              |   6 +-
 drivers/tty/serial/msm_serial.c                    |  99 ++++++++----
 drivers/tty/serial/samsung.c                       |   4 +-
 drivers/usb/gadget/function/f_acm.c                |   4 +-
 drivers/usb/gadget/udc/pch_udc.c                   |  30 ++--
 drivers/usb/gadget/udc/udc-core.c                  |   2 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   3 +-
 .../vfio/platform/reset/vfio_platform_amdxgbe.c    |   2 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/cifs/connect.c                                  |   2 +
 fs/gfs2/file.c                                     |   5 +-
 fs/nfs/nfs4proc.c                                  |   4 +
 include/asm-generic/preempt.h                      |   4 +-
 include/linux/cpufreq.h                            |   4 -
 include/linux/ieee80211.h                          |   9 ++
 include/linux/mlx5/driver.h                        |   3 +-
 include/linux/mlx5/qp.h                            |   1 +
 include/linux/mtd/nand.h                           |   4 +-
 include/linux/netdevice.h                          |   5 +-
 include/linux/sunrpc/msg_prot.h                    |   4 +-
 include/net/bonding.h                              |   7 +-
 include/net/ip6_fib.h                              |   2 +
 include/net/ip6_route.h                            |   3 +
 include/net/ip_fib.h                               |   3 +-
 include/net/route.h                                |   3 +
 include/net/sch_generic.h                          |   5 +-
 include/net/sock.h                                 |  18 ++-
 include/net/xfrm.h                                 |   4 +-
 kernel/bpf/syscall.c                               |   4 +-
 kernel/sched/fair.c                                |  27 ++--
 kernel/trace/bpf_trace.c                           |   4 +
 lib/mpi/longlong.h                                 |  34 ++--
 net/batman-adv/main.c                              |   2 +-
 net/batman-adv/translation-table.c                 |   6 +-
 net/bridge/br_fdb.c                                |  52 +++---
 net/bridge/br_input.c                              |   7 +-
 net/core/dev.c                                     |   1 +
 net/core/flow_dissector.c                          |  17 +-
 net/core/rtnetlink.c                               |   1 +
 net/core/skbuff.c                                  |  10 +-
 net/core/sock.c                                    |   7 +-
 net/dccp/ipv4.c                                    |   2 +-
 net/dccp/ipv6.c                                    |   2 +-
 net/dsa/slave.c                                    |   7 +-
 net/ipv4/devinet.c                                 |  12 +-
 net/ipv4/fib_frontend.c                            |   3 +-
 net/ipv4/fib_semantics.c                           |   8 +-
 net/ipv4/fib_trie.c                                |   4 +-
 net/ipv4/fou.c                                     |   6 +
 net/ipv4/gre_offload.c                             |   8 +
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/ip_gre.c                                  |  46 ++++--
 net/ipv4/ip_sockglue.c                             |   7 +-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |   6 +-
 net/ipv4/route.c                                   |  17 +-
 net/ipv4/tcp_input.c                               |   5 +-
 net/ipv4/udp.c                                     |  13 +-
 net/ipv6/addrconf.c                                |  21 ++-
 net/ipv6/icmp.c                                    |   5 +-
 net/ipv6/ip6_checksum.c                            |   7 +-
 net/ipv6/ip6_vti.c                                 |   4 +-
 net/ipv6/ip6mr.c                                   |  13 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |   6 +-
 net/ipv6/route.c                                   |  75 ++++++---
 net/ipv6/tcp_ipv6.c                                |   7 +-
 net/ipv6/udp.c                                     |   6 +-
 net/ipv6/xfrm6_input.c                             |  15 +-
 net/ipv6/xfrm6_tunnel.c                            |   2 +-
 net/irda/af_irda.c                                 |   5 +-
 net/l2tp/l2tp_core.c                               |   3 +
 net/mac80211/ieee80211_i.h                         |   4 +
 net/mac80211/mlme.c                                |   2 +-
 net/mac80211/offchannel.c                          |   5 +-
 net/mac80211/rx.c                                  |   8 +-
 net/mac80211/status.c                              |   5 +-
 net/mac80211/tdls.c                                |  43 ++++-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/vht.c                                 |  30 +++-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nf_tables_core.c                     |   2 +-
 net/netfilter/nfnetlink.c                          |   6 +-
 net/netfilter/nft_dynset.c                         |   3 +
 net/nfc/nci/core.c                                 |   6 +-
 net/openvswitch/actions.c                          |  20 ++-
 net/rds/tcp.c                                      |   2 +-
 net/rds/tcp_listen.c                               |  40 +++--
 net/sched/cls_bpf.c                                |  13 +-
 net/sched/cls_flower.c                             |  28 ++--
 net/sched/sch_drr.c                                |   4 +
 net/sched/sch_fq.c                                 |  32 ++--
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sched/sch_generic.c                            |  11 +-
 net/sched/sch_hfsc.c                               |  12 +-
 net/sched/sch_prio.c                               |   4 +
 net/sched/sch_qfq.c                                |   3 +
 net/sched/sch_sfb.c                                |   3 +
 net/sched/sch_tbf.c                                |   4 +
 net/sctp/associola.c                               |   2 +-
 net/sctp/sm_make_chunk.c                           |   6 +-
 net/sctp/transport.c                               |   2 +-
 net/sunrpc/xprtrdma/backchannel.c                  |  22 +--
 net/sunrpc/xprtrdma/transport.c                    |   3 +
 net/sunrpc/xprtrdma/verbs.c                        |  41 ++---
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   2 +-
 net/tipc/udp_media.c                               |   5 +-
 net/xfrm/xfrm_input.c                              |  14 +-
 net/xfrm/xfrm_state.c                              |   1 +
 net/xfrm/xfrm_user.c                               |  15 +-
 scripts/config                                     |   5 +-
 sound/pci/fm801.c                                  |  71 +++++----
 sound/pci/hda/hda_intel.c                          |   9 +-
 sound/soc/fsl/fsl_ssi.c                            |   8 +-
 sound/soc/intel/atom/sst/sst_stream.c              |   2 +-
 sound/soc/tegra/tegra_alc5632.c                    |  12 +-
 tools/perf/util/perf_regs.c                        |   8 +-
 tools/testing/selftests/ipc/msgque.c               |   2 +-
 309 files changed, 2005 insertions(+), 1279 deletions(-)


