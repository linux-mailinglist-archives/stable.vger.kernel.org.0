Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E583C1D84BB
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbgERSN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732394AbgERSBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:01:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DB9207D3;
        Mon, 18 May 2020 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824889;
        bh=POFjkg+26CBCUmpBsPp/dtU8/3K8Wl7i/nS0LAMgFe0=;
        h=From:To:Cc:Subject:Date:From;
        b=JZbYJQUA8XuNYbeyADEtG1cjsPU8NqehY9jJEuLnxHU8DqmzHm4NFk0w6kFB2hnmS
         HtoIhI3yh/ycFAPY+2R+0xKRVnP3+etgGYRlG+y5YiJaGbuJuq8sYLzVsHJcmQVIfT
         ePIP+v265NAgIrPXhO68CWOl0/392jTIDAVkZPt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 000/194] 5.6.14-rc1 review
Date:   Mon, 18 May 2020 19:34:50 +0200
Message-Id: <20200518173531.455604187@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.14-rc1
X-KernelTest-Deadline: 2020-05-20T17:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.14 release.
There are 194 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.14-rc1

Sergei Trofimovich <slyfox@gentoo.org>
    Makefile: disallow data races on gcc-10 as well

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Restrict bpf_trace_printk()'s %s usage and add %pks, %pus specifier

Yonghong Song <yhs@fb.com>
    selftests/bpf: Enforce returning 0 for fentry/fexit programs

Yonghong Song <yhs@fb.com>
    bpf: Enforce returning 0 for fentry/fexit progs

Jim Mattson <jmattson@google.com>
    KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: perf: RISCV_BASE_PMU should be independent

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Move IB_EVENT_DEVICE_FATAL to destroy_uobj

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/uverbs: Do not discard the IB_EVENT_DEVICE_FATAL event

Nayna Jain <nayna@linux.ibm.com>
    powerpc/ima: Fix secure boot rules in ima arch policy

Nicholas Piggin <npiggin@gmail.com>
    powerpc/uaccess: Evaluate macro arguments once, before user access is allowed

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    bpf: Fix sk_psock refcnt leak when receiving message

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")

Michael Walle <michael@walle.cc>
    dt-bindings: dma: fsl-edma: fix ls1028a-edma compatible

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7740: Add missing extal2 to CPG node

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a73a4: Add missing CMT1 interrupts

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn: Change SDMA1 ahb clock for imx8mn

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-g12-common: fix dwc2 clock names

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: msm8996: Reduce vdd_apc voltage

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-g12b-khadas-vim3: add missing frddr_a status property

Marc Zyngier <maz@kernel.org>
    clk: Unlink clock if failed to prepare or enable

Tero Kristo <t-kristo@ti.com>
    clk: ti: clkctrl: Fix Bad of_node_put within clkctrl_get_name

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in cdc_bind()

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in gncm_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: audio: Fix a missing error return value in audio_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'

Thierry Reding <treding@nvidia.com>
    usb: gadget: tegra-xudc: Fix idle suspend/resume

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-g12b-ugoos-am6: fix usb vbus-supply

Amir Goldstein <amir73il@gmail.com>
    fanotify: fix merging marks masks with FAN_ONDIR

John Stultz <john.stultz@linaro.org>
    dwc3: Remove check for HWO flag in dwc3_gadget_ep_reclaim_trb_sg()

Justin Swartz <justin.swartz@risingedge.co.za>
    clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Eric W. Biederman <ebiederm@xmission.com>
    exec: Move would_dump into flush_old_exec

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix error handling in __unwind_start()

Borislav Petkov <bp@suse.de>
    x86: Fix early boot crash on gcc-10, third try

Babu Moger <babu.moger@amd.com>
    KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c

Adam McCoy <adam@forsedomani.com>
    cifs: fix leaked reference on requeued write

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: Fix build failure with CONFIG_PPC_KUAP_DEBUG

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso32: Fallback on getres syscall when clock is unknown

Imre Deak <imre.deak@intel.com>
    drm/i915/tgl+: Fix interrupt handling for DP AUX transactions

Tom St Denis <tom.stdenis@amd.com>
    drm/amd/amdgpu: add raven1 part to the gfxoff quirk list

Simon Ser <contact@emersion.fr>
    drm/amd/display: add basic atomic check for cursor plane

Michal Vokáč <michal.vokac@ysoft.com>
    ARM: dts: imx6dl-yapp4: Fix Ursa board Ethernet connection

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Fix bus_dma_limit for PCIe

Peter Jones <pjones@redhat.com>
    Make the "Reducing compressed framebufer size" message be DRM_INFO_ONCE()

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Kyungtae Kim <kt0755@gmail.com>
    USB: gadget: fix illegal array access in binding with UDC

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: prev_req->trb is NULL for ep0

Li Jun <jun.li@nxp.com>
    usb: host: xhci-plat: keep runtime active when removing host

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B

Jesus Ramos <jesus-ramos@live.com>
    ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Add COEF workaround for ASUS ZenBook UX431DA

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Limit int mic boost for Thinkpad T530

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: usbfs: fix mmap dma mismatch

Jeremy Linton <jeremy.linton@arm.com>
    usb: usbfs: correct kernel->user page attribute mismatch

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Fix to prevent warning message if no bootconfig option

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Fix to remove bootconfig data from initrd while boot

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: avoid shadowing standard library 'free()' in crypto

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: mark more functions __init to avoid section mismatch warnings

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10 warnings: fix low-hanging fruit

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'restrict' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'stringop-overflow' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'array-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'zero-length-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    Stop the ad-hoc games with -Wno-maybe-initialized

Jason Gunthorpe <jgg@ziepe.ca>
    net/rds: Use ERR_PTR for rds_message_alloc_sgs()

Jason Gunthorpe <jgg@ziepe.ca>
    pnp: Use list_for_each_entry() instead of open coding

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSv3: fix rpc receive buffer size for MOUNT call

Sasha Levin <sashal@kernel.org>
    bpf: Fix bug in mmap() implementation for BPF array map

Roman Penyaev <rpenyaev@suse.de>
    epoll: call final ep_events_available() check under the lock

Yafang Shao <laoar.shao@gmail.com>
    mm, memcg: fix inconsistent oom event behavior

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Handle idling during i915_gem_evict_something busy loops

Wei Yongjun <weiyongjun1@huawei.com>
    s390/ism: fix error return code in ism_probe()

Samu Nuutamo <samu.nuutamo@vincit.fi>
    hwmon: (da9052) Synchronize access with mfd

Steven Rostedt (VMware) <rostedt@goodmis.org>
    x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: Fix incorrect function parameters

Maor Gottlieb <maorg@mellanox.com>
    RDMA/core: Fix double put of resource

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/core: Fix potential NULL pointer dereference in pkey cache

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Test return value of calls to ib_get_cached_pkey

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    RDMA/rxe: Always return ERR_PTR from rxe_create_mmap_info()

Phil Sutter <phil@nwl.cc>
    netfilter: nft_set_rbtree: Add missing expired checks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: set NF_FLOW_TEARDOWN flag on entry expiration

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Wait for preempt irq delay thread to execute

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Signalled ASYNC tasks need to exit

J. Bruce Fields <bfields@redhat.com>
    nfs: fix NULL deference in nfs4_get_valid_delegation

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Mark concurrent submissions with a weak-dependency

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix infinite loop on rmmod

Christoph Hellwig <hch@lst.de>
    arm64: fix the flush_icache_range arguments in machine_kexec

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix kernel oops for 3-level ppgtt guest

Arnd Bergmann <arnd@arndb.de>
    netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Guenter Roeck <linux@roeck-us.net>
    hwmon: (drivetemp) Fix SCT support if SCT data tables are not supported

Dave Wysochanski <dwysocha@redhat.com>
    NFSv4: Fix fscache cookie aux_data to ensure change_attr is included

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix fscache super_cookie allocation

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix fscache super_cookie index_key from changing after umount

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: force fbdev into vram

Christian Brauner <christian.brauner@ubuntu.com>
    fork: prevent accidental access to clone3 features

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: More gfs2_find_jhead fixes

Adrian Hunter <adrian.hunter@intel.com>
    mmc: block: Fix request completion in the CQE timeout path

Sarthak Garg <sartgarg@codeaurora.org>
    mmc: core: Fix recursive locking issue in CQE recovery path

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: core: Check request type before completing the request

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Fix can not access GL9750 after reboot from Windows 10

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: alcor: Fix a resource leak in the error path for ->probe()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Remove object_is_locked assertion from unpin_from_display_plane

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: msg_pop_data can incorrecty set an sge length

Sultan Alsawaf <sultan@kerneltoast.com>
    drm/i915: Don't enable WaIncreaseLatencyIPCEnabled when IPC is disabled

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Make timeslicing an explicit engine property

Dan Carpenter <dan.carpenter@oracle.com>
    i40iw: Fix error handling in i40iw_manage_arp_cache()

David Howells <dhowells@redhat.com>
    cachefiles: Fix corruption of the return value in cachefiles_read_or_alloc_pages()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix 'function sizeof not defined' error of tracepoints format

Wei Yongjun <weiyongjun1@huawei.com>
    bpf: Fix error return code in map_lookup_and_delete_elem()

Thierry Reding <treding@nvidia.com>
    drm/tegra: Fix SMMU support on Tegra124 and Tegra210

Grace Kao <grace.kao@intel.com>
    pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Ansuel Smith <ansuelsmth@gmail.com>
    pinctrl: qcom: fix wrong write in update_dual_edge

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: sunrisepoint: Fix PAD lock register offset for SPT-H

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: PM: Avoid premature returns from acpi_s2idle_wake()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Fix another case where pq is left on waitlist

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Fix no irq handler from suspend

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Another gfs2_walk_metadata fix

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: check non-sync defer_list carefully

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()

Ritesh Harjani <riteshh@linux.ibm.com>
    fibmap: Warn and return an error in case of block > INT_MAX

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()

Sung Lee <sung.lee@amd.com>
    drm/amd/display: Update downspread percent to match spreadsheet for DCN2.1

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Defer cursor update around VUPDATE for all ASIC

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: check if REFCLK_CNTL register is present

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: bump version for invalidate L2 before SDMA IBs

Tiecheng Zhou <Tiecheng.Zhou@amd.com>
    drm/amd/powerplay: avoid using pm_en before it is initialized revised

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix race in monitor detection during probe

Chris Wilson <chris@chris-wilson.co.uk>
    cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once

Xiao Yang <yangx.jy@cn.fujitsu.com>
    selftests/ftrace: Check the first record for kprobe_args_type.tc

Xiaodong Yan <Xiaodong.Yan@amd.com>
    drm/amd/display: blank dp stream before re-train the link

Lubomir Rintel <lkundrak@v3.sk>
    dmaengine: mmp_tdma: Reset channel error on release

Lubomir Rintel <lkundrak@v3.sk>
    dmaengine: mmp_tdma: Do not ignore slave config validation errors

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Ilie Halip <ilie.halip@gmail.com>
    riscv: fix vdso build with lld

Sebastian von Ohr <vonohr@smaract.com>
    dmaengine: xilinx_dma: Add missing check for empty list

Florian Fainelli <f.fainelli@gmail.com>
    net: broadcom: Select BROADCOM_PHY for BCMGENET

Vincent Minet <v.minet@criteo.com>
    umh: fix memory leak on execve failure

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: re-establish support for RTL8401 chip version

Wei Yongjun <weiyongjun1@huawei.com>
    nfp: abm: fix error return code in nfp_abm_vnic_alloc()

Kelly Littlepage <kelly@onechronos.com>
    net: tcp: fix rx timestamp behavior for tcp_recvmsg

Zefan Li <lizefan@huawei.com>
    netprio_cgroup: Fix unlimited memory leak of v2 cgroups

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: really enforce backoff for redirects

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: loop: Add module soft dependency

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of ndo_stop

Dan Carpenter <dan.carpenter@oracle.com>
    dpaa2-eth: prevent array underflow in update_cls_rule()

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix lockdep warning on 32 bit

Eric Dumazet <edumazet@google.com>
    tcp: fix SO_RCVLOWAT hangs with fat skbs

Eric Dumazet <edumazet@google.com>
    tcp: fix error recovery in tcp_zerocopy_receive()

Maciej Żenczykowski <maze@google.com>
    Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Guillaume Nault <gnault@redhat.com>
    pppoe: only process PADT targeted at local interfaces

Vinod Koul <vkoul@kernel.org>
    net: stmmac: fix num_por initialization

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix aneg restart in phy_ethtool_set_eee

Paolo Abeni <pabeni@redhat.com>
    netlabel: cope with NULL catmap

Cong Wang <xiyou.wangcong@gmail.com>
    net: fix a potential recursive NETDEV_FEAT_CHANGE

Paolo Abeni <pabeni@redhat.com>
    mptcp: set correct vfs info for subflows

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: properly handle buffer size restrictions

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: Add SDHCI_QUIRK2_BROKEN_64_BIT_DMA for AMDI0040

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: ocelot: the MAC table on Felix is twice as large

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Update Device Table in increase_address_space()

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix race in increase_address_space()/fetch_pte()

Colin Ian King <colin.king@canonical.com>
    net: stmmac: gmac5+: fix potential integer overflow on 32 bit multiply

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix tcm_parent in tc filter dump

Arnd Bergmann <arnd@arndb.de>
    sun6i: dsi: fix gcc-4.8

Stefan Hajnoczi <stefanha@redhat.com>
    virtio-blk: handle block_device_operations callbacks after hot unplug

Arnd Bergmann <arnd@arndb.de>
    drop_monitor: work around gcc-10 stringop-overflow warning

Clay McClure <clay@daemons.net>
    net: Make PTP-specific drivers depend on PTP_1588_CLOCK

Nathan Chancellor <natechancellor@gmail.com>
    hv_netvsc: Fix netvsc_start_xmit's return type

Alan Maguire <alan.maguire@oracle.com>
    ftrace/selftests: workaround cgroup RT scheduling issues

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: moxa: Fix a potential double 'free_irq()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix GSS privacy computation of auth->au_ralign

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Add "@len" parameter to gss_unwrap()

Adam Ford <aford173@gmail.com>
    gpio: pca953x: Fix pca953x_gpio_set_config

Marc Zyngier <maz@kernel.org>
    KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits

Marc Zyngier <maz@kernel.org>
    KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: phy: microchip_t1: add lan87xx_phy_init to initialize the lan87xx phy.

Hugh Dickins <hughd@google.com>
    shmem: fix possible deadlocks on shmlock_user_lock

José Roberto de Souza <jose.souza@intel.com>
    drm/i915/display: Load DP_TP_CTL/STATUS offset before use it

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/tgl: TBT AUX should use TC power well ops

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/tgl: Add Wa_14010477008:tgl

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix trace point use-after-free race

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Clean up the post_send path

Oliver Upton <oupton@google.com>
    kvm: nVMX: reflect MTF VM-exits if injected by L1

Oliver Upton <oupton@google.com>
    KVM: nVMX: Consolidate nested MTF checks to helper function


-------------

Diffstat:

 Documentation/core-api/printk-formats.rst          |  14 ++
 Documentation/devicetree/bindings/dma/fsl-edma.txt |   3 +-
 Makefile                                           |  20 ++-
 arch/arm/boot/dts/dra7.dtsi                        |   4 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts   |   4 +-
 arch/arm/boot/dts/imx6dl-yapp4-ursa.dts            |   2 +-
 arch/arm/boot/dts/r8a73a4.dtsi                     |   9 +-
 arch/arm/boot/dts/r8a7740.dtsi                     |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 .../boot/dts/amlogic/meson-g12b-khadas-vim3.dtsi   |   4 +
 .../boot/dts/amlogic/meson-g12b-ugoos-am6.dts      |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |   4 +-
 arch/arm64/boot/dts/renesas/r8a77980.dtsi          |   2 +
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts        |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   4 +-
 arch/arm64/kernel/machine_kexec.c                  |   1 +
 arch/powerpc/include/asm/book3s/32/kup.h           |   2 +-
 arch/powerpc/include/asm/uaccess.h                 |  49 ++++--
 arch/powerpc/kernel/ima_arch.c                     |   6 +-
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   6 +-
 arch/riscv/include/asm/perf_event.h                |   8 +-
 arch/riscv/kernel/Makefile                         |   2 +-
 arch/riscv/kernel/vdso/Makefile                    |   6 +-
 arch/x86/include/asm/ftrace.h                      |   6 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/stackprotector.h              |   7 +-
 arch/x86/kernel/ftrace.c                           |  29 +++-
 arch/x86/kernel/smpboot.c                          |   8 +
 arch/x86/kernel/unwind_orc.c                       |  16 +-
 arch/x86/kvm/vmx/nested.c                          |  19 ++-
 arch/x86/kvm/vmx/vmx.c                             |  18 --
 arch/x86/kvm/x86.c                                 |  19 ++-
 arch/x86/mm/init_64.c                              |   3 +
 arch/x86/xen/smp_pv.c                              |   1 +
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/acpi/ec.c                                  |  24 ++-
 drivers/acpi/internal.h                            |   1 -
 drivers/acpi/sleep.c                               |  14 +-
 drivers/block/virtio_blk.c                         |  86 +++++++++-
 drivers/clk/clk.c                                  |   3 +
 drivers/clk/rockchip/clk-rk3228.c                  |  17 +-
 drivers/clk/ti/clkctrl.c                           |   1 -
 drivers/cpufreq/intel_pstate.c                     |   2 +-
 drivers/dma/mmp_tdma.c                             |   5 +-
 drivers/dma/pch_dma.c                              |   2 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  20 +--
 drivers/firmware/efi/tpm.c                         |   2 +-
 drivers/gpio/gpio-pca953x.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  26 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  12 ++
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |  28 +--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   3 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c      |   6 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |  14 +-
 drivers/gpu/drm/i915/display/intel_display_power.c |  12 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   5 +-
 drivers/gpu/drm/i915/display/intel_fbc.c           |   3 +-
 drivers/gpu/drm/i915/display/intel_sprite.c        |  17 +-
 drivers/gpu/drm/i915/gem/i915_gem_domain.c         |   7 +-
 drivers/gpu/drm/i915/gt/intel_engine.h             |   9 -
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |  18 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   8 +-
 drivers/gpu/drm/i915/gvt/scheduler.c               |   6 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   2 +
 drivers/gpu/drm/i915/i915_gem_evict.c              |  26 ++-
 drivers/gpu/drm/i915/i915_irq.c                    |  16 +-
 drivers/gpu/drm/i915/i915_request.c                |   8 +-
 drivers/gpu/drm/i915/i915_scheduler.c              |   6 +-
 drivers/gpu/drm/i915/i915_scheduler.h              |   3 +-
 drivers/gpu/drm/i915/i915_scheduler_types.h        |   1 +
 drivers/gpu/drm/i915/intel_pm.c                    |   2 +-
 drivers/gpu/drm/qxl/qxl_image.c                    |   3 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |   2 +-
 drivers/gpu/drm/tegra/drm.c                        |   3 +-
 drivers/gpu/host1x/dev.c                           |  13 ++
 drivers/hwmon/da9052-hwmon.c                       |   4 +-
 drivers/hwmon/drivetemp.c                          |   2 +-
 drivers/infiniband/core/cache.c                    |   7 +-
 drivers/infiniband/core/nldev.c                    |   3 +-
 drivers/infiniband/core/rdma_core.c                |   3 +-
 drivers/infiniband/core/uverbs.h                   |   4 +
 drivers/infiniband/core/uverbs_main.c              |  12 +-
 .../infiniband/core/uverbs_std_types_async_fd.c    |  30 +++-
 drivers/infiniband/hw/cxgb4/cm.c                   |   7 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |   4 -
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |   2 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  14 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |   2 +-
 drivers/infiniband/sw/rxe/rxe_queue.c              |  11 +-
 drivers/iommu/amd_iommu.c                          | 175 ++++++++++++++-----
 drivers/iommu/amd_iommu_types.h                    |   9 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/core/queue.c                           |  16 +-
 drivers/mmc/host/alcor.c                           |   6 +-
 drivers/mmc/host/sdhci-acpi.c                      |  10 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |  23 +++
 drivers/net/dsa/dsa_loop.c                         |   1 +
 drivers/net/dsa/mv88e6xxx/Kconfig                  |   2 +-
 drivers/net/dsa/ocelot/felix.c                     |   1 +
 drivers/net/dsa/ocelot/felix.h                     |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   1 +
 drivers/net/dsa/sja1105/Kconfig                    |   1 +
 drivers/net/ethernet/broadcom/Kconfig              |   1 +
 drivers/net/ethernet/cadence/Kconfig               |   2 +-
 drivers/net/ethernet/cavium/Kconfig                |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  29 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |  16 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  16 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |   2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  17 +-
 drivers/net/ethernet/mscc/ocelot_regs.c            |   1 +
 drivers/net/ethernet/natsemi/jazzsonic.c           |   6 +-
 drivers/net/ethernet/netronome/nfp/abm/main.c      |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   2 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  17 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   2 +-
 drivers/net/ethernet/ti/Kconfig                    |   3 +-
 drivers/net/hyperv/netvsc_drv.c                    |   3 +-
 drivers/net/phy/microchip_t1.c                     | 171 +++++++++++++++++++
 drivers/net/phy/phy.c                              |   8 +-
 drivers/net/ppp/pppoe.c                            |   3 +
 drivers/net/virtio_net.c                           |   6 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |   1 +
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 +
 drivers/pinctrl/intel/pinctrl-sunrisepoint.c       |  15 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   2 +-
 drivers/s390/net/ism_drv.c                         |   4 +-
 drivers/usb/cdns3/gadget.c                         |   2 +-
 drivers/usb/core/devio.c                           |  19 ++-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/dwc3/gadget.c                          |   3 -
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/gadget/legacy/audio.c                  |   4 +-
 drivers/usb/gadget/legacy/cdc2.c                   |   4 +-
 drivers/usb/gadget/legacy/ncm.c                    |   4 +-
 drivers/usb/gadget/udc/net2272.c                   |   2 +
 drivers/usb/gadget/udc/tegra-xudc.c                |   8 +-
 drivers/usb/host/xhci-plat.c                       |   4 +-
 drivers/usb/host/xhci-ring.c                       |   4 +-
 fs/cachefiles/rdwr.c                               |  10 +-
 fs/cifs/cifssmb.c                                  |   2 +-
 fs/eventpoll.c                                     |  48 +++---
 fs/exec.c                                          |   4 +-
 fs/gfs2/bmap.c                                     |  16 +-
 fs/gfs2/lops.c                                     |  19 ++-
 fs/io_uring.c                                      |   4 +-
 fs/ioctl.c                                         |   8 +
 fs/iomap/fiemap.c                                  |   5 +-
 fs/nfs/fscache.c                                   |  39 ++---
 fs/nfs/mount_clnt.c                                |   3 +-
 fs/nfs/nfs4state.c                                 |   2 +-
 fs/nfs/super.c                                     |   1 -
 fs/notify/fanotify/fanotify.c                      |  11 +-
 include/linux/compiler.h                           |   6 +
 include/linux/fs.h                                 |   2 +-
 include/linux/ftrace.h                             |  23 +++
 include/linux/host1x.h                             |   3 +
 include/linux/memcontrol.h                         |   2 +
 include/linux/pnp.h                                |  29 +---
 include/linux/skmsg.h                              |   1 +
 include/linux/sunrpc/gss_api.h                     |   3 +
 include/linux/sunrpc/gss_krb5.h                    |   6 +-
 include/linux/sunrpc/xdr.h                         |   1 +
 include/linux/tty.h                                |   2 +-
 include/net/netfilter/nf_conntrack.h               |   2 +-
 include/net/sch_generic.h                          |   1 +
 include/net/tcp.h                                  |  13 ++
 include/soc/mscc/ocelot.h                          |   1 +
 include/sound/rawmidi.h                            |   1 +
 include/trace/events/rpcrdma.h                     |  12 +-
 init/Kconfig                                       |  18 --
 init/initramfs.c                                   |   2 +-
 init/main.c                                        |  75 +++++++--
 ipc/util.c                                         |  12 +-
 kernel/bpf/arraymap.c                              |   7 +-
 kernel/bpf/syscall.c                               |   4 +-
 kernel/bpf/verifier.c                              |  16 ++
 kernel/fork.c                                      |  13 +-
 kernel/trace/Kconfig                               |   1 -
 kernel/trace/bpf_trace.c                           |  94 +++++++----
 kernel/trace/ftrace_internal.h                     |  22 ---
 kernel/trace/preemptirq_delay_test.c               |  12 +-
 kernel/umh.c                                       |   6 +
 lib/vsprintf.c                                     |  12 ++
 mm/shmem.c                                         |   7 +-
 net/core/dev.c                                     |   4 +-
 net/core/drop_monitor.c                            |  11 +-
 net/core/filter.c                                  |   2 +-
 net/core/netprio_cgroup.c                          |   2 +
 net/ipv4/cipso_ipv4.c                              |   6 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/tcp.c                                     |  27 ++-
 net/ipv4/tcp_bpf.c                                 |  10 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/route.c                                   |   6 +-
 net/mptcp/subflow.c                                |  10 ++
 net/netfilter/nf_conntrack_core.c                  |  17 +-
 net/netfilter/nf_flow_table_core.c                 |   8 +-
 net/netfilter/nft_set_rbtree.c                     |  11 ++
 net/netlabel/netlabel_kapi.c                       |   6 +
 net/rds/message.c                                  |  19 +--
 net/rds/rdma.c                                     |  12 +-
 net/rds/rds.h                                      |   3 +-
 net/rds/send.c                                     |   6 +-
 net/sched/cls_api.c                                |   8 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  12 +-
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |   8 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  44 +++--
 net/sunrpc/auth_gss/gss_mech_switch.c              |   3 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  10 +-
 net/sunrpc/clnt.c                                  |   5 +
 net/sunrpc/xdr.c                                   |  41 +++++
 net/sunrpc/xprtrdma/backchannel.c                  |   2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |  14 +-
 net/sunrpc/xprtrdma/transport.c                    |   2 +-
 net/sunrpc/xprtrdma/verbs.c                        |  15 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   5 +-
 scripts/kallsyms.c                                 |   2 +-
 sound/core/rawmidi.c                               |  31 +++-
 sound/firewire/amdtp-stream-trace.h                |   3 +-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |  41 ++++-
 sound/usb/quirks.c                                 |   9 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |   9 +
 tools/testing/selftests/bpf/progs/test_overhead.c  |   4 +-
 tools/testing/selftests/ftrace/ftracetest          |  22 +++
 .../ftrace/test.d/kprobe/kprobe_args_type.tc       |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                   |  10 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |  12 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      | 187 ++++++++++++++-------
 virt/kvm/arm/vgic/vgic-mmio.h                      |  11 ++
 241 files changed, 1928 insertions(+), 837 deletions(-)


