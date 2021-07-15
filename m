Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B833CA9FF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbhGOTLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242454AbhGOTIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 398DE613E7;
        Thu, 15 Jul 2021 19:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375878;
        bh=23pT/6kJd71FMkC+JQjiL++1hsF1a/BuFZ6rtEOPFUI=;
        h=From:To:Cc:Subject:Date:From;
        b=iVI78/yg0e1mV91EcuGgPADqZugNq2xH8wgltF4EyKwiwNTaVYqwJtJkLngphWUEx
         6DdUUcB3Jg5rKCGYLrMLPpEMGkbYkjZyvzzSagB68H5qS1aJfAHlfnrhkhHEwgm+JO
         VtAOr6FBQCD0TT/VUgxZCBjuzmFMZ3+XlrNXfWP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.13 000/266] 5.13.3-rc1 review
Date:   Thu, 15 Jul 2021 20:35:55 +0200
Message-Id: <20210715182613.933608881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.3-rc1
X-KernelTest-Deadline: 2021-07-17T18:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.13.3 release.
There are 266 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.13.3-rc1

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid racing on fsync_entry_slab by multi filesystem instances

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: restrict bytes count in smk_set_cipso()

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-core: explicitly clear ioctl input data

Pavel Skripkin <paskripkin@gmail.com>
    jfs: fix GPF in diFree

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible UAF when remounting r/o a mmp-protected file system

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Remove reference to struct drm_device.pdev

Zou Wei <zou_wei@huawei.com>
    pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: write at least 4k when committing

Sven Schnelle <svens@linux.ibm.com>
    s390/signal: switch to using vdso for sigreturn and syscall restart

Sven Schnelle <svens@linux.ibm.com>
    s390/vdso: add minimal compat vdso

Sven Schnelle <svens@linux.ibm.com>
    s390/vdso: rename VDSO64_LBASE to VDSO_LBASE

Sven Schnelle <svens@linux.ibm.com>
    s390/vdso64: add sigreturn,rt_sigreturn and restart_syscall

Sven Schnelle <svens@linux.ibm.com>
    s390/vdso: always enable vdso

Benjamin Drung <bdrung@posteo.de>
    media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Johan Hovold <johan@kernel.org>
    media: rtl28xxu: fix zero-length control request

Johan Hovold <johan@kernel.org>
    media: gspca/sunplus: fix zero-length control requests

Johan Hovold <johan@kernel.org>
    media: gspca/sq905: fix control-request direction

Bernhard Wimmer <be.wimm@gmail.com>
    media: ccs: Fix the op_pll_multiplier address

Pavel Skripkin <paskripkin@gmail.com>
    media: zr364xx: fix memory leak in zr364xx_start_readpipe

Johan Hovold <johan@kernel.org>
    media: dtv5100: fix control-request directions

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: i2c: ccs-core: fix pm_runtime_get_sync() usage count

Arnd Bergmann <arnd@arndb.de>
    media: subdev: disallow ioctl for saa6588/davinci

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Implement workaround for the readback value of VEND_ID

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix checking for PIO Non-posted Request

Konstantin Kharlamov <Hi-Angel@yandex.ru>
    PCI: Leave Apple Thunderbolt controllers on for s2idle or standby

Hou Tao <houtao1@huawei.com>
    dm btree remove: assign new_root only when removal succeeds

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: flush origin device when writing and cache is full

Damien Le Moal <damien.lemoal@wdc.com>
    dm zoned: check zone capacity

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()

Jeremy Linton <jeremy.linton@arm.com>
    coresight: Propagate symlink failure

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ipack/carriers/tpci200: Fix a double free in tpci200_pci_probe

Paul Burton <paulburton@google.com>
    tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT

Paul Burton <paulburton@google.com>
    tracing: Simplify & fix saved_tgids logic

Jan Kara <jack@suse.cz>
    rq-qos: fix missed wake-ups in rq_qos_throttle try two

Yun Zhou <yun.zhou@windriver.com>
    seq_buf: Fix overflow in seq_buf_putmem_hex()

Kees Cook <keescook@chromium.org>
    lkdtm: Enable DOUBLE_FAULT on all architectures

Ferry Toth <ftoth@exalondelft.nl>
    extcon: intel-mrfld: Sync hardware and software state on init

Kees Cook <keescook@chromium.org>
    selftests/lkdtm: Fix expected text for CR4 pinning

Kees Cook <keescook@chromium.org>
    lkdtm/bugs: XFAIL UNALIGNED_LOAD_STORE_WRITE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nvmem: core: add a missing of_node_put

Limeng <Meng.Li@windriver.com>
    mfd: syscon: Free the allocated name field of struct regmap_config

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Fix an old bug

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix races between xattr_{set|get} and listxattr operations

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal/drivers/int340x/processor_thermal: Fix tcc setting

Varad Gautam <varad.gautam@suse.com>
    xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype

Petr Pavlu <petr.pavlu@suse.com>
    ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Nathan Chancellor <nathan@kernel.org>
    qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute

Jesse Brandeburg <jesse.brandeburg@intel.com>
    i40e: fix PTP on 5Gb links

Brian Norris <briannorris@chromium.org>
    mwifiex: bring down link before deleting interface

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Set driver_name=tegra for all machine drivers

Russ Weight <russell.h.weight@intel.com>
    fpga: stratix10-soc: Add missing fpga_mgr_free() call

Samuel Holland <samuel@sholland.org>
    clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround

Thomas Gleixner <tglx@linutronix.de>
    cpu/hotplug: Cure the cpusets trainwreck

Zhenyu Ye <yezhenyu2@huawei.com>
    arm64: tlb: fix the TTL value of tlb_get_level

Timo Sigurdsson <public_timo.s@silentcreek.de>
    ata: ahci_sunxi: Disable DIPM

Kees Cook <keescook@chromium.org>
    docs: Makefile: Use CONFIG_SHELL not SHELL

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: core: clear flags before allowing to retune

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Disable write protect detection on Toshiba Encore 2 WT8-B

Kees Cook <keescook@chromium.org>
    drm/i915/display: Do not zero past infoframes.vsc

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Switch IPU plane to type OVERLAY

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/nouveau: Don't set allow_fb_modifiers explicitly

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/arm/malidp: Always list modifiers

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/msm/mdp4: Fix modifier support enabling

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/tegra: Don't set allow_fb_modifiers explicitly

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Fix pixclock rate for 24-bit serial panels

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Reject non-zero src_y and src_x for video planes

Maximilian Luz <luzmaximilian@gmail.com>
    pinctrl/amd: Add device HID for new AMD GPIO controller

Guchun Chen <guchun.chen@amd.com>
    drm/amd/display: fix incorrrect valid irq check

Thomas Hebb <tommyhebb@gmail.com>
    drm/rockchip: dsi: remove extra component_del() call

Lyude Paul <lyude@redhat.com>
    drm/dp: Handle zeroed port counts in drm_dp_read_downstream_info()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Prevent clock unbalance

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: crtc: Skip the TXP

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: txp: Properly set the possible_crtcs mask

Tiezhu Yang <yangtiezhu@loongson.cn>
    drm/radeon: Call radeon_suspend_kms() in radeon_pci_shutdown() for Loongson64

Jing Xiangfeng <jingxiangfeng@huawei.com>
    drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: fix the hang caused by PCIe link width switch

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: fix NAK-G generation during PCI-e link width switch

Aaron Liu <aaron.liu@amd.com>
    drm/amdgpu: enable sdma0 tmz for Raven/Renoir(V2)

Joseph Greathouse <Joseph.Greathouse@amd.com>
    drm/amdgpu: Update NV SIMD-per-CU to 2

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add new dimgrey cavefish DID

Haren Myneni <haren@linux.ibm.com>
    powerpc/powernv/vas: Release reference to tgid during window close

Nathan Chancellor <nathan@kernel.org>
    powerpc/barrier: Avoid collision with clang's __lwsync macro

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Fix error handling when allocating an IPI

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Reject atomic ops in ppc32 JIT

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/mm: Fix lockup on kernel exec fault

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/mremap: hold the rmap lock in write mode when moving page table entries.

Paul Cercueil <paul@crapouillou.net>
    MIPS: MT extensions are not available on MIPS32r1

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix host initialization during resume

周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
    MIPS: CI20: Reduce clocksource to 750 kHz.

Nick Desaulniers <ndesaulniers@google.com>
    MIPS: set mips32r5 for virt extensions

zhanglianjie <zhanglianjie@uniontech.com>
    MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add size validation when walking chunks

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate from_addr_param return

gushengxian <gushengxian@yulong.com>
    flow_offload: action should not be NULL when it is referenced

Rustam Kovhaev <rkovhaev@gmail.com>
    bpf: Fix false positive kmemleak report in bpf_ringbuf_area_alloc()

Odin Ugedal <odin@uged.al>
    sched/fair: Ensure _sum and _avg values stay consistent

Tim Jiang <tjiang@codeaurora.org>
    Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Tim Jiang <tjiang@codeaurora.org>
    Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: mgmt: Fix the command returns garbage parameter value

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add support USB ALT 3 for WBS

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix invalid access on ECRED Connection response

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails

Daniel Lenski <dlenski@gmail.com>
    Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Kiran K <kiran.k@intel.com>
    Bluetooth: Fix alt settings for incoming SCO with transparent coding format

Yu Liu <yudiliu@google.com>
    Bluetooth: Fix the HCI to MGMT status conversion table

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

mark-yw.chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.

Gerd Rausch <gerd.rausch@oracle.com>
    RDMA/cma: Fix rdma_resolve_route() memory leak

Jakub Kicinski <kuba@kernel.org>
    net: ip: avoid OOM kills with large UDP sends over loopback

Martynas Pumputis <m@lambda.lt>
    net: retrieve netns cookie via getsocketopt

Sean Young <sean@mess.org>
    media, bpf: Do not copy more entries than user space requested

Max Gurtovoy <mgurtovoy@nvidia.com>
    IB/isert: Align target max I/O size to initiator size

Ilan Peer <ilan.peer@intel.com>
    mac80211: Properly WARN on HW scan before restart

Weilun Du <wdu@google.com>
    mac80211_hwsim: add concurrent channels scanning support over virtio

Johannes Berg <johannes.berg@intel.com>
    mac80211: consider per-CPU statistics if present

Ping-Ke Shih <pkshih@realtek.com>
    cfg80211: fix default HE tx bitrate mask in 2G band

Gustavo A. R. Silva <gustavoars@kernel.org>
    wireless: wext-spy: Fix out-of-bounds warning

Íñigo Huguet <ihuguet@redhat.com>
    sfc: error code if SRIOV cannot be disabled

Íñigo Huguet <ihuguet@redhat.com>
    sfc: avoid double pci_remove of VFs

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: add quirks to disable pci capabilities

Po-Hao Huang <phhuang@realtek.com>
    rtw88: 8822c: update RF parameter tables to v62

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix context info freeing

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: free IML DMA memory allocation

Shaul Triebitz <shaul.triebitz@intel.com>
    iwlwifi: mvm: fix error print when session protection ends

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: apply RX diversity per PHY context

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: don't change band on bound PHY contexts

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Don't overwrite errno from ib_umem_get()

Logush Oliver <ollogush@amd.com>
    drm/amd/display: Fix edp_bootup_bl_level initialization issue

Longpeng(Mike) <longpeng2@huawei.com>
    vsock: notify server to shutdown when client has pending signal

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: register the interrupt handler in the right place

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: use 'dma_free_coherent' instead of 'kfree'

Fugang Duan <fugang.duan@nxp.com>
    net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

Huang Pei <huangpei@loongson.cn>
    MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Pascal Terjan <pterjan@google.com>
    rtl8xxxu: Fix device info for RTL8192EU devices

Ryder Lee <ryder.lee@mediatek.com>
    mt76: fix iv and CCMP header insertion

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode

Sean Wang <sean.wang@mediatek.com>
    mt76: connac: fix the maximum interval schedule scan can support

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: fix UC entry is being overwritten

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: enable hw offloading for wep keys

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: reset wfsys during hw probe

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix reset under the deep sleep is enabled

Evelyn Tsai <evelyn.tsai@mediatek.com>
    mt76: mt7915: fix tssi indication field of DBDC NICs

xinhui pan <xinhui.pan@amd.com>
    drm/amdkfd: Walk through list with dqm lock hold

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: fix bad address translation for sienna_cichlid

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix false WARN_ONCE

Yang Yingliang <yangyingliang@huawei.com>
    net: sched: fix error return code in tcf_del_walker()

Yang Yingliang <yangyingliang@huawei.com>
    net: ipa: Add missing of_node_put() in ipa_firmware_load()

Jian Shen <shenjian15@huawei.com>
    net: fix mistake path for netdev_features_strings

Felix Fietkau <nbd@nbd.name>
    mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix fixed-rate tx status reporting

Jacob Keller <jacob.e.keller@intel.com>
    ice: mark PTYPE 2 as reserved

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix incorrect payload indicator on PTYPE

Pavel Skripkin <paskripkin@gmail.com>
    ext4: fix memory leak in ext4_fill_super

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix up register-based shifts in interpreter to silence KUBSAN

George McCollister <george.mccollister@gmail.com>
    net: hsr: don't check sequence number if tag removal is offloaded

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Fix circular lock in nocpsch path

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Cover edge-case when changing DISPCLK WDIVIDER

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: fix circular locking on get_wave_state

Zou Wei <zou_wei@huawei.com>
    cw1200: add missing MODULE_DEVICE_TABLE

Lee Gibson <leegib@gmail.com>
    wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers

Tony Lindgren <tony@atomide.com>
    wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: commit just one block, not a full page

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix error reporting in xfrm_state_construct.

Lijun Pan <lijunp213@gmail.com>
    ibmvnic: fix kernel build warnings in build_hdr_descs_arr

Mark Yacoub <markyacoub@chromium.org>
    drm/amd/display: Verify Gamma & Degamma LUT sizes in amdgpu_dm_atomic_check

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM

Minchan Kim <minchan@kernel.org>
    selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Yang Yingliang <yangyingliang@huawei.com>
    net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()

Yang Yingliang <yangyingliang@huawei.com>
    fjes: check return value after calling platform_get_resource()

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdkfd: use allowed domain for vmbo validation

Yang Yingliang <yangyingliang@huawei.com>
    net: sgi: ioc3-eth: check return value after calling platform_get_resource()

Amit Cohen <amcohen@nvidia.com>
    selftests: Clean forgotten resources as part of cleanup()

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: phy: realtek: add delay to fix RXC generation issue

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Fix crash during MPO + ODM combine mode recalculation

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Fix off-by-one error in DML

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7

Vladimir Stempen <vladimir.stempen@amd.com>
    drm/amd/display: Release MST resources on switch from MST to SST

Roman Li <roman.li@amd.com>
    drm/amd/display: Update scaling settings on modeset

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Revert "Fix clock table filling logic"

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Fix DCN 3.01 DSCCLK validation

Yang Yingliang <yangyingliang@huawei.com>
    net: moxa: Use devm_platform_get_and_ioremap_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: micrel: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: mvpp2: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: bcmgenet: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: mscc: ocelot: check return value after calling platform_get_resource()

Xianting Tian <xianting.tian@linux.alibaba.com>
    virtio_net: Remove BUG() to avoid machine dead

Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
    ice: fix clang warning regarding deadcode.DeadStores

Liwei Song <liwei.song@windriver.com>
    ice: set the value of global config lock timeout longer

Radim Pavlik <radim.pavlik@tbs-biometrics.com>
    pinctrl: mcp23s08: fix race condition in irq handler

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: bridge: mrp: Update ring transitions.

Damien Le Moal <damien.lemoal@wdc.com>
    block: introduce BIO_ZONE_WRITE_LOCKED bio flag

Damien Le Moal <damien.lemoal@wdc.com>
    dm: Fix dm_accept_partial_bio() relative to zone management commands

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: don't split bios when overwriting contiguous cache content

Joe Thornber <ejt@redhat.com>
    dm space maps: don't reset space map allocation cursor when committing

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    RDMA/cxgb4: Fix missing error code in create_qp()

Andreas Roeseler <andreas.a.roeseler@gmail.com>
    icmp: fix lib conflict with trinity

Yuchung Cheng <ycheng@google.com>
    net: tcp better handling of reordering then loss cases

Yang Yingliang <yangyingliang@huawei.com>
    clk: tegra: tegra124-emc: Fix clock imbalance in emc_set_timing()

Jiansong Chen <Jiansong.Chen@amd.com>
    drm/amdgpu: remove unsafe optimization to drop preamble ib

Kees Cook <keescook@chromium.org>
    drm/amd/display: Avoid HDCP over-read and corruption

Kevin Wang <kevin1.wang@amd.com>
    drm/amdgpu: fix sdma firmware version error in sriov

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: fix metadata_size for ubo ioctl queries

Paul Cercueil <paul@crapouillou.net>
    MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER

Paul Cercueil <paul@crapouillou.net>
    MIPS: cpu-probe: Fix FPU detection on Ingenic JZ4760(B)

Willy Tarreau <w@1wt.eu>
    ipv6: use prandom_u32() for ID generation

Xie Yongji <xieyongji@bytedance.com>
    virtio-net: Add validation for used length

Yu Kuai <yukuai3@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix PM reference leak in

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Ensure that PLLU configuration is applied properly

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Fix refcounting of gate clocks

Thierry Reding <treding@nvidia.com>
    drm/tegra: hub: Fix YUV support

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs: Change MAX_SESS_QUEUE_DEPTH

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: the XPCS obscures a potential "PHY not found" error

Alex Bee <knaerzche@gmail.com>
    drm: rockchip: add missing registers for RK3066

Alex Bee <knaerzche@gmail.com>
    drm: rockchip: add missing registers for RK3188

Eli Cohen <elic@nvidia.com>
    net/mlx5: Fix lag port remapping logic

Huy Nguyen <huyn@nvidia.com>
    net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu/aldebaran: fix check in is_dpm_running

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix odm scaling

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    clk: renesas: r8a77995: Add ZA2 clock

Zou Wei <zou_wei@huawei.com>
    drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: fix assignment on big endian machines

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: handle vlan types with checker enabled

Jesse Brandeburg <jesse.brandeburg@intel.com>
    e100: handle eeprom as little endian

Zou Wei <zou_wei@huawei.com>
    drm/vc4: hdmi: Fix PM reference leak in vc4_hdmi_encoder_pre_crtc_co()

Mateusz Kwiatkowski <kfyatek+publicgit@gmail.com>
    drm/vc4: Fix clock source for VEC PixelValve on BCM2711

Feifei Xu <Feifei.Xu@amd.com>
    drm/amd/pm: fix return value in aldebaran_set_mp1_state()

YueHaibing <yuehaibing@huawei.com>
    net: xilinx_emaclite: Do not print real IOMEM pointer

Arturo Giusti <koredump@protonmail.com>
    udf: Fix NULL pointer dereference in udf_symlink function

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/sched: Avoid data corruptions

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/scheduler: Fix hang when sched_entity released

Bixuan Cui <cuibixuan@huawei.com>
    pinctrl: equilibrium: Add missing MODULE_DEVICE_TABLE

Wei Yongjun <weiyongjun1@huawei.com>
    net: ethernet: ixp4xx: Fix return value check in ixp4xx_eth_probe()

Davide Caratti <dcaratti@redhat.com>
    net/sched: cls_api: increase max_reclassify_loop

Vladimir Oltean <olteanv@gmail.com>
    net: mdio: provide shim implementation of devm_of_mdiobus_register

Xie Yongji <xieyongji@bytedance.com>
    drm/virtio: Fix double free on probe failure

Pavel Skripkin <paskripkin@gmail.com>
    reiserfs: add check for invalid 1st journal block

Zou Wei <zou_wei@huawei.com>
    drm/bridge: lt9611: Add missing MODULE_DEVICE_TABLE

Ansuel Smith <ansuelsmth@gmail.com>
    net: mdio: ipq8064: add regmap config to disable REGCACHE

Nicolas Boichat <drinkcat@chromium.org>
    drm/panfrost: devfreq: Disable devfreq when num_supplies > 1

Wang Li <wangli74@huawei.com>
    drm/mediatek: Fix PM reference leak in mtk_crtc_ddp_hw_init()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT

Zou Wei <zou_wei@huawei.com>
    atm: nicstar: Fix possible use-after-free in nicstar_cleanup()

Zou Wei <zou_wei@huawei.com>
    mISDN: fix possible use-after-free in HFC_cleanup()

Zou Wei <zou_wei@huawei.com>
    atm: iphase: fix possible use-after-free in ia_module_exit()

Bibo Mao <maobibo@loongson.cn>
    hugetlb: clear huge pte during flush function on mips platform

Youling Tang <tangyouling@loongson.cn>
    MIPS: Loongson64: Fix build error 'secondary_kexec_args' undeclared under !SMP

Dinghao Liu <dinghao.liu@zju.edu.cn>
    clk: renesas: rcar-usb2-clock-sel: Fix error handling in .probe()

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix use_max_lb flag for 420 pixel formats

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix clock table filling logic

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: change the default timeout for kernel compute queues

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Sebastian Reichel <sebastian.reichel@collabora.com>
    drm/imx: Add 8 pixel alignment fix

Liu Ying <victor.liu@nxp.com>
    drm/bridge: nwl-dsi: Force a full modeset when crtc_state->active is changed to be true

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vc4: fix argument ordering in vc4_crtc_get_margins()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amd/amdgpu/sriov disable all ip hw status by default

Chris Park <Chris.Park@amd.com>
    drm/amd/display: Fix BSOD with NULL check

Lewis Huang <Lewis.Huang@amd.com>
    drm/amd/display: Revert wait vblank on update dpp clock

Brandon Syu <Brandon.Syu@amd.com>
    drm/amd/display: fix HDCP reset sequence on reinitialize

KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
    drm/ast: Fixed CVE for DP501

Thomas Zimmermann <tzimmermann@suse.de>
    drm/zte: Don't select DRM_KMS_FB_HELPER

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mxsfb: Don't select DRM_KMS_FB_HELPER


-------------

Diffstat:

 Documentation/Makefile                             |    2 +-
 Makefile                                           |    4 +-
 arch/alpha/include/uapi/asm/socket.h               |    2 +
 arch/arm64/include/asm/tlb.h                       |    4 +
 arch/mips/Kconfig                                  |    2 +
 arch/mips/boot/dts/ingenic/ci20.dts                |    4 +-
 arch/mips/include/asm/cpu-features.h               |    4 +-
 arch/mips/include/asm/hugetlb.h                    |    8 +-
 arch/mips/include/asm/mipsregs.h                   |    8 +-
 arch/mips/include/asm/pgalloc.h                    |   10 +-
 arch/mips/include/uapi/asm/socket.h                |    2 +
 arch/mips/kernel/cpu-probe.c                       |    5 +
 arch/mips/loongson64/numa.c                        |    3 +
 arch/mips/loongson64/reset.c                       |    5 +-
 arch/parisc/include/uapi/asm/socket.h              |    2 +
 arch/powerpc/include/asm/barrier.h                 |    2 +
 arch/powerpc/mm/fault.c                            |    4 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |   14 +-
 arch/powerpc/platforms/powernv/vas-window.c        |    9 +-
 arch/powerpc/sysdev/xive/common.c                  |    7 +-
 arch/s390/Kconfig                                  |    1 +
 arch/s390/Makefile                                 |   13 +
 arch/s390/include/asm/elf.h                        |   13 +-
 arch/s390/include/asm/vdso.h                       |   25 +-
 arch/s390/include/asm/vdso/gettimeofday.h          |    1 -
 arch/s390/kernel/Makefile                          |    1 +
 arch/s390/kernel/compat_signal.c                   |   13 +-
 arch/s390/kernel/process.c                         |    6 +
 arch/s390/kernel/signal.c                          |   39 +-
 arch/s390/kernel/syscall.c                         |    4 +
 arch/s390/kernel/vdso.c                            |   63 +-
 arch/s390/kernel/vdso32/.gitignore                 |    2 +
 arch/s390/kernel/vdso32/Makefile                   |   75 ++
 arch/s390/kernel/vdso32/gen_vdso_offsets.sh        |   15 +
 arch/s390/kernel/vdso32/note.S                     |   13 +
 arch/s390/kernel/vdso32/vdso32.lds.S               |  141 +++
 arch/s390/kernel/vdso32/vdso32_wrapper.S           |   15 +
 arch/s390/kernel/vdso32/vdso_user_wrapper.S        |   21 +
 arch/s390/kernel/vdso64/Makefile                   |    8 +
 arch/s390/kernel/vdso64/gen_vdso_offsets.sh        |   15 +
 arch/s390/kernel/vdso64/vdso64.lds.S               |    5 +-
 arch/s390/kernel/vdso64/vdso_user_wrapper.S        |   17 +
 arch/sparc/include/uapi/asm/socket.h               |    2 +
 block/blk-rq-qos.c                                 |    4 +-
 drivers/ata/ahci_sunxi.c                           |    2 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/atm/nicstar.c                              |   26 +-
 drivers/bluetooth/btusb.c                          |   36 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |   22 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |    1 +
 drivers/clk/renesas/rcar-usb2-clock-sel.c          |   24 +-
 drivers/clk/tegra/clk-periph-gate.c                |   72 +-
 drivers/clk/tegra/clk-periph.c                     |   11 +
 drivers/clk/tegra/clk-pll.c                        |    9 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |    4 +-
 drivers/clocksource/arm_arch_timer.c               |    2 +-
 drivers/extcon/extcon-intel-mrfld.c                |    9 +
 drivers/firmware/qemu_fw_cfg.c                     |    8 +-
 drivers/fpga/stratix10-soc.c                       |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_nbio.h           |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |    5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.h            |    5 +
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c             |   41 +
 drivers/gpu/drm/amd/amdgpu/nv.c                    |    6 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |    6 +-
 drivers/gpu/drm/amd/amdgpu/umc_v8_7.c              |    2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   68 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   24 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |   41 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    2 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   |   68 +-
 .../amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h   |    3 +-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   12 +-
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |    4 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   15 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |    2 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  573 ++++-------
 drivers/gpu/drm/amd/display/dc/dc.h                |    1 -
 drivers/gpu/drm/amd/display/dc/dc_types.h          |    5 -
 .../gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c  |   21 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    2 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   14 +-
 .../amd/display/dc/dml/dcn30/display_mode_vba_30.c |   78 +-
 .../drm/amd/display/dc/dml/display_mode_structs.h  |    2 +
 .../gpu/drm/amd/display/dc/dml/display_mode_vba.c  |   13 +
 drivers/gpu/drm/amd/display/dc/inc/hw/transform.h  |    4 -
 drivers/gpu/drm/amd/display/dc/irq_types.h         |    2 +-
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c    |    1 -
 .../drm/amd/display/modules/hdcp/hdcp1_execution.c |    4 +-
 drivers/gpu/drm/amd/include/navi10_enum.h          |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    9 +-
 drivers/gpu/drm/arm/malidp_planes.c                |    9 +-
 drivers/gpu/drm/ast/ast_dp501.c                    |  139 ++-
 drivers/gpu/drm/ast/ast_drv.h                      |   12 +
 drivers/gpu/drm/ast/ast_main.c                     |   10 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |    4 +-
 drivers/gpu/drm/bridge/cdns-dsi.c                  |    2 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |    1 +
 drivers/gpu/drm/bridge/nwl-dsi.c                   |   61 +-
 drivers/gpu/drm/drm_dp_helper.c                    |    7 +
 drivers/gpu/drm/i915/display/intel_dp.c            |    2 +-
 drivers/gpu/drm/imx/imx-drm-core.c                 |   19 +-
 drivers/gpu/drm/imx/imx-ldb.c                      |    5 +
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   11 +-
 drivers/gpu/drm/imx/ipuv3-plane.c                  |   19 +-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |   13 +-
 drivers/gpu/drm/ingenic/ingenic-ipu.c              |    2 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |    2 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |    2 -
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c         |    8 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |    1 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |    1 -
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |    9 +
 drivers/gpu/drm/radeon/radeon_display.c            |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c                |    8 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |    4 -
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c        |   21 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |    8 +-
 drivers/gpu/drm/scheduler/sched_main.c             |   24 +
 drivers/gpu/drm/tegra/dc.c                         |   12 +-
 drivers/gpu/drm/tegra/dc.h                         |    7 +
 drivers/gpu/drm/tegra/drm.c                        |    2 -
 drivers/gpu/drm/tegra/hub.c                        |   52 +-
 drivers/gpu/drm/tegra/plane.c                      |   23 +-
 drivers/gpu/drm/tegra/plane.h                      |    3 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |    5 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |    2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   10 +-
 drivers/gpu/drm/vc4/vc4_txp.c                      |    2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |    1 +
 drivers/gpu/drm/zte/Kconfig                        |    1 -
 drivers/gpu/ipu-v3/ipu-dc.c                        |    5 +
 drivers/gpu/ipu-v3/ipu-di.c                        |    7 +
 drivers/hwtracing/coresight/coresight-core.c       |    2 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |    2 +-
 drivers/infiniband/core/cma.c                      |    3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |    1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    4 +-
 drivers/infiniband/ulp/isert/ib_isert.h            |    3 -
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |   13 +-
 drivers/ipack/carriers/tpci200.c                   |    5 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    2 +-
 drivers/md/dm-writecache.c                         |   48 +-
 drivers/md/dm-zoned-metadata.c                     |    7 +
 drivers/md/dm.c                                    |    8 +-
 drivers/md/persistent-data/dm-btree-remove.c       |    3 +-
 drivers/md/persistent-data/dm-space-map-disk.c     |    9 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |    9 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   32 +-
 drivers/media/i2c/ccs/ccs-limits.c                 |    4 +
 drivers/media/i2c/ccs/ccs-limits.h                 |    4 +
 drivers/media/i2c/ccs/ccs-regs.h                   |    6 +-
 drivers/media/i2c/saa6588.c                        |    4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    6 +-
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpbe_venc.c         |    6 +-
 drivers/media/rc/bpf-lirc.c                        |    3 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    3 +-
 drivers/media/usb/dvb-usb/dtv5100.c                |    7 +-
 drivers/media/usb/gspca/sq905.c                    |    2 +-
 drivers/media/usb/gspca/sunplus.c                  |    8 +-
 drivers/media/usb/uvc/uvc_video.c                  |   27 +
 drivers/media/usb/zr364xx/zr364xx.c                |    1 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 drivers/mfd/syscon.c                               |    2 +-
 drivers/misc/lkdtm/bugs.c                          |    3 +
 drivers/misc/lkdtm/core.c                          |    2 -
 drivers/mmc/core/core.c                            |    7 +-
 drivers/mmc/core/sd.c                              |   10 +-
 drivers/mmc/host/sdhci-acpi.c                      |   11 +
 drivers/mmc/host/sdhci.c                           |    4 +
 drivers/mmc/host/sdhci.h                           |    1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c           |    5 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    4 +
 drivers/net/ethernet/freescale/fec.h               |    5 +
 drivers/net/ethernet/freescale/fec_main.c          |   43 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |    3 +-
 drivers/net/ethernet/intel/e100.c                  |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |    8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |    6 +-
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |    4 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    9 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   19 +-
 drivers/net/ethernet/micrel/ks8842.c               |    4 +
 drivers/net/ethernet/moxa/moxart_ether.c           |    5 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   19 +-
 drivers/net/ethernet/realtek/r8169_main.c          |    1 -
 drivers/net/ethernet/sfc/ef10_sriov.c              |   25 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |    4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   21 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    5 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |    4 +-
 drivers/net/fjes/fjes_main.c                       |    4 +
 drivers/net/ipa/ipa_main.c                         |    1 +
 drivers/net/mdio/mdio-ipq8064.c                    |   34 +-
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |    7 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |    6 +
 drivers/net/phy/realtek.c                          |   15 +-
 drivers/net/virtio_net.c                           |   22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   15 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   28 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   15 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    3 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |   48 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   13 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   16 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   33 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |   12 -
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   74 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   42 -
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    3 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   28 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   29 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    4 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    3 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   59 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   32 +
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 1008 ++++++++++----------
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |    1 +
 drivers/net/wireless/ti/wl1251/cmd.c               |    9 +-
 drivers/net/wireless/ti/wl12xx/main.c              |    7 +
 drivers/nvmem/core.c                               |    9 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |    2 +
 drivers/pci/controller/pci-aardvark.c              |   13 +-
 drivers/pci/quirks.c                               |   11 +
 drivers/pinctrl/pinctrl-amd.c                      |    1 +
 drivers/pinctrl/pinctrl-equilibrium.c              |    1 +
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   10 +-
 drivers/power/supply/ab8500-chargalg.h             |    2 +-
 .../int340x_thermal/processor_thermal_device.c     |   20 +-
 fs/ext4/ext4.h                                     |    4 +
 fs/ext4/mmp.c                                      |   59 +-
 fs/ext4/super.c                                    |   14 +-
 fs/f2fs/f2fs.h                                     |    2 +
 fs/f2fs/recovery.c                                 |   23 +-
 fs/f2fs/super.c                                    |    8 +-
 fs/io-wq.c                                         |    5 +-
 fs/jfs/inode.c                                     |    3 +-
 fs/reiserfs/journal.c                              |   14 +
 fs/ubifs/super.c                                   |    1 +
 fs/ubifs/ubifs.h                                   |    2 +
 fs/ubifs/xattr.c                                   |   44 +-
 fs/udf/namei.c                                     |    4 +
 include/linux/blk_types.h                          |    1 +
 include/linux/netdev_features.h                    |    2 +-
 include/linux/of_mdio.h                            |    7 +
 include/linux/wait.h                               |    2 +-
 include/media/v4l2-subdev.h                        |    4 +
 include/net/flow_offload.h                         |   12 +-
 include/net/sctp/structs.h                         |    2 +-
 include/uapi/asm-generic/socket.h                  |    2 +
 include/uapi/linux/ethtool.h                       |    4 +-
 include/uapi/linux/icmp.h                          |    3 +-
 kernel/bpf/core.c                                  |   61 +-
 kernel/bpf/ringbuf.c                               |    2 +
 kernel/cpu.c                                       |   49 +
 kernel/sched/fair.c                                |    6 +-
 kernel/sched/wait.c                                |    9 +-
 kernel/trace/trace.c                               |   91 +-
 lib/seq_buf.c                                      |    4 +-
 mm/mremap.c                                        |    4 +-
 net/bluetooth/cmtp/core.c                          |    5 +
 net/bluetooth/hci_core.c                           |   16 +-
 net/bluetooth/hci_event.c                          |    6 +-
 net/bluetooth/l2cap_core.c                         |    8 +-
 net/bluetooth/mgmt.c                               |    5 +
 net/bridge/br_mrp.c                                |    6 +-
 net/core/dev.c                                     |   11 +-
 net/core/sock.c                                    |    7 +
 net/hsr/hsr_framereg.c                             |    3 +-
 net/ipv4/icmp.c                                    |    2 +-
 net/ipv4/ip_output.c                               |   32 +-
 net/ipv4/tcp_input.c                               |   45 +-
 net/ipv6/ip6_output.c                              |   32 +-
 net/ipv6/output_core.c                             |   28 +-
 net/mac80211/main.c                                |    7 +-
 net/mac80211/sta_info.c                            |   11 +-
 net/sched/act_api.c                                |    3 +-
 net/sched/cls_api.c                                |    2 +-
 net/sctp/bind_addr.c                               |   19 +-
 net/sctp/input.c                                   |    8 +-
 net/sctp/ipv6.c                                    |    7 +-
 net/sctp/protocol.c                                |    7 +-
 net/sctp/sm_make_chunk.c                           |   29 +-
 net/vmw_vsock/af_vsock.c                           |    2 +-
 net/wireless/nl80211.c                             |    9 +-
 net/wireless/wext-spy.c                            |   14 +-
 net/xfrm/xfrm_policy.c                             |   21 +-
 net/xfrm/xfrm_user.c                               |   28 +-
 security/selinux/avc.c                             |   13 +-
 security/smack/smackfs.c                           |    2 +
 sound/soc/tegra/tegra_alc5632.c                    |    1 +
 sound/soc/tegra/tegra_max98090.c                   |    1 +
 sound/soc/tegra/tegra_rt5640.c                     |    1 +
 sound/soc/tegra/tegra_rt5677.c                     |    1 +
 sound/soc/tegra/tegra_sgtl5000.c                   |    1 +
 sound/soc/tegra/tegra_wm8753.c                     |    1 +
 sound/soc/tegra/tegra_wm8903.c                     |    1 +
 sound/soc/tegra/tegra_wm9712.c                     |    1 +
 sound/soc/tegra/trimslice.c                        |    1 +
 .../drivers/net/mlxsw/devlink_trap_l3_drops.sh     |    3 +
 .../net/mlxsw/devlink_trap_l3_exceptions.sh        |    3 +
 .../selftests/drivers/net/mlxsw/qos_dscp_bridge.sh |    2 +
 tools/testing/selftests/lkdtm/tests.txt            |    2 +-
 .../selftests/net/forwarding/pedit_dsfield.sh      |    2 +
 .../selftests/net/forwarding/pedit_l4port.sh       |    2 +
 .../selftests/net/forwarding/skbedit_priority.sh   |    2 +
 339 files changed, 3656 insertions(+), 2144 deletions(-)


