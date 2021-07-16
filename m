Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323C13CBBD3
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhGPSbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPSbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6B0613F3;
        Fri, 16 Jul 2021 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626460109;
        bh=oVBRm2feKR2A6NJvoz4mYny2aAunRP+7b0f3lc2iby4=;
        h=From:To:Cc:Subject:Date:From;
        b=lxAgYIKK5ExPp4A5yNIex8++USeNgZpu8VHKcPzRJ8T+g/+mjDtpY3utoze0D8QU1
         Qbi0GDam2a95K2OsWpABQGClkrYOr28KvUTCJ+LU8O/6P5wkoZR8Ab1SW5tZ8vrQGi
         8y/LLdX/Ltr3YkKEV5hrDemphp2sHMuH6jkuufmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/119] 5.4.133-rc2 review
Date:   Fri, 16 Jul 2021 20:28:26 +0200
Message-Id: <20210716182029.878765454@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.133-rc2
X-KernelTest-Deadline: 2021-07-18T18:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.133 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.133-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.133-rc2

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    smackfs: restrict bytes count in smk_set_cipso()

Pavel Skripkin <paskripkin@gmail.com>
    jfs: fix GPF in diFree

Zou Wei <zou_wei@huawei.com>
    pinctrl: mcp23s08: Fix missing unlock on error in mcp23s08_irq()

Benjamin Drung <bdrung@posteo.de>
    media: uvcvideo: Fix pixel format change for Elgato Cam Link 4K

Johan Hovold <johan@kernel.org>
    media: gspca/sunplus: fix zero-length control requests

Johan Hovold <johan@kernel.org>
    media: gspca/sq905: fix control-request direction

Pavel Skripkin <paskripkin@gmail.com>
    media: zr364xx: fix memory leak in zr364xx_start_readpipe

Johan Hovold <johan@kernel.org>
    media: dtv5100: fix control-request directions

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

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc-etf: Fix global-out-of-bounds in tmc_update_etf_buffer()

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

Ferry Toth <ftoth@exalondelft.nl>
    extcon: intel-mrfld: Sync hardware and software state on init

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    nvmem: core: add a missing of_node_put

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Fix an old bug

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix races between xattr_{set|get} and listxattr operations

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal/drivers/int340x/processor_thermal: Fix tcc setting

Petr Pavlu <petr.pavlu@suse.com>
    ipmi/watchdog: Stop watchdog timer when the current action is 'none'

Nathan Chancellor <nathan@kernel.org>
    qemu_fw_cfg: Make fw_cfg_rev_attr a proper kobj_attribute

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Set driver_name=tegra for all machine drivers

Gao Xiang <hsiangkao@linux.alibaba.com>
    MIPS: fix "mipsel-linux-ld: decompress.c:undefined reference to `memmove'"

Russ Weight <russell.h.weight@intel.com>
    fpga: stratix10-soc: Add missing fpga_mgr_free() call

Samuel Holland <samuel@sholland.org>
    clocksource/arm_arch_timer: Improve Allwinner A64 timer workaround

Thomas Gleixner <tglx@linutronix.de>
    cpu/hotplug: Cure the cpusets trainwreck

Timo Sigurdsson <public_timo.s@silentcreek.de>
    ata: ahci_sunxi: Disable DIPM

Christian Löhle <CLoehle@hyperstone.com>
    mmc: core: Allow UHS-I voltage switch for SDSC cards if supported

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: core: clear flags before allowing to retune

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci: Fix warning message when accessing RPMB in HS400 mode

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/arm/malidp: Always list modifiers

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/msm/mdp4: Fix modifier support enabling

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/tegra: Don't set allow_fb_modifiers explicitly

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Reject non-zero src_y and src_x for video planes

Maximilian Luz <luzmaximilian@gmail.com>
    pinctrl/amd: Add device HID for new AMD GPIO controller

Guchun Chen <guchun.chen@amd.com>
    drm/amd/display: fix incorrrect valid irq check

Thomas Hebb <tommyhebb@gmail.com>
    drm/rockchip: dsi: remove extra component_del() call

Jing Xiangfeng <jingxiangfeng@huawei.com>
    drm/radeon: Add the missed drm_gem_object_put() in radeon_user_framebuffer_create()

Joseph Greathouse <Joseph.Greathouse@amd.com>
    drm/amdgpu: Update NV SIMD-per-CU to 2

Nathan Chancellor <nathan@kernel.org>
    powerpc/barrier: Avoid collision with clang's __lwsync macro

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/mm: Fix lockup on kernel exec fault

Ian Rogers <irogers@google.com>
    perf bench: Fix 2 memory sanitizer warnings

Joerg Roedel <jroedel@suse.de>
    crypto: ccp - Annotate SEV Firmware file names

Eric Biggers <ebiggers@google.com>
    fscrypt: don't ignore minor_hash when hash is 0

Nick Desaulniers <ndesaulniers@google.com>
    MIPS: set mips32r5 for virt extensions

zhanglianjie <zhanglianjie@uniontech.com>
    MIPS: loongsoon64: Reserve memory below starting pfn to prevent Oops

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: add size validation when walking chunks

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: validate from_addr_param return

Tim Jiang <tjiang@codeaurora.org>
    Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Yu Liu <yudiliu@google.com>
    Bluetooth: Fix the HCI to MGMT status conversion table

mark-yw.chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.

Gerd Rausch <gerd.rausch@oracle.com>
    RDMA/cma: Fix rdma_resolve_route() memory leak

Jakub Kicinski <kuba@kernel.org>
    net: ip: avoid OOM kills with large UDP sends over loopback

Sean Young <sean@mess.org>
    media, bpf: Do not copy more entries than user space requested

Gustavo A. R. Silva <gustavoars@kernel.org>
    wireless: wext-spy: Fix out-of-bounds warning

Íñigo Huguet <ihuguet@redhat.com>
    sfc: error code if SRIOV cannot be disabled

Íñigo Huguet <ihuguet@redhat.com>
    sfc: avoid double pci_remove of VFs

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix context info freeing

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: free IML DMA memory allocation

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: don't change band on bound PHY contexts

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Don't overwrite errno from ib_umem_get()

Longpeng(Mike) <longpeng2@huawei.com>
    vsock: notify server to shutdown when client has pending signal

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: register the interrupt handler in the right place

Zheyu Ma <zheyuma97@gmail.com>
    atm: nicstar: use 'dma_free_coherent' instead of 'kfree'

Huang Pei <huangpei@loongson.cn>
    MIPS: add PMD table accounting into MIPS'pmd_alloc_one

Pascal Terjan <pterjan@google.com>
    rtl8xxxu: Fix device info for RTL8192EU devices

xinhui pan <xinhui.pan@amd.com>
    drm/amdkfd: Walk through list with dqm lock hold

Yang Yingliang <yangyingliang@huawei.com>
    net: sched: fix error return code in tcf_del_walker()

Jian Shen <shenjian15@huawei.com>
    net: fix mistake path for netdev_features_strings

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix fixed-rate tx status reporting

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix up register-based shifts in interpreter to silence KUBSAN

Zou Wei <zou_wei@huawei.com>
    cw1200: add missing MODULE_DEVICE_TABLE

Lee Gibson <leegib@gmail.com>
    wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Tony Lindgren <tony@atomide.com>
    wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix error reporting in xfrm_state_construct.

Mark Yacoub <markyacoub@chromium.org>
    drm/amd/display: Verify Gamma & Degamma LUT sizes in amdgpu_dm_atomic_check

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM

Minchan Kim <minchan@kernel.org>
    selinux: use __GFP_NOWARN with GFP_NOWAIT in the AVC

Yang Yingliang <yangyingliang@huawei.com>
    fjes: check return value after calling platform_get_resource()

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdkfd: use allowed domain for vmbo validation

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7

Vladimir Stempen <vladimir.stempen@amd.com>
    drm/amd/display: Release MST resources on switch from MST to SST

Roman Li <roman.li@amd.com>
    drm/amd/display: Update scaling settings on modeset

Yang Yingliang <yangyingliang@huawei.com>
    net: micrel: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: mvpp2: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    net: bcmgenet: check return value after calling platform_get_resource()

Xianting Tian <xianting.tian@linux.alibaba.com>
    virtio_net: Remove BUG() to avoid machine dead

Liwei Song <liwei.song@windriver.com>
    ice: set the value of global config lock timeout longer

Radim Pavlik <radim.pavlik@tbs-biometrics.com>
    pinctrl: mcp23s08: fix race condition in irq handler

Joe Thornber <ejt@redhat.com>
    dm space maps: don't reset space map allocation cursor when committing

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    RDMA/cxgb4: Fix missing error code in create_qp()

Willy Tarreau <w@1wt.eu>
    ipv6: use prandom_u32() for ID generation

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: Ensure that PLLU configuration is applied properly

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    clk: renesas: r8a77995: Add ZA2 clock

Zou Wei <zou_wei@huawei.com>
    drm/bridge: cdns: Fix PM reference leak in cdns_dsi_transfer()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: handle vlan types with checker enabled

Jesse Brandeburg <jesse.brandeburg@intel.com>
    e100: handle eeprom as little endian

Arturo Giusti <koredump@protonmail.com>
    udf: Fix NULL pointer dereference in udf_symlink function

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/sched: Avoid data corruptions

Xie Yongji <xieyongji@bytedance.com>
    drm/virtio: Fix double free on probe failure

Pavel Skripkin <paskripkin@gmail.com>
    reiserfs: add check for invalid 1st journal block

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

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix use_max_lb flag for 420 pixel formats

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vc4: fix argument ordering in vc4_crtc_get_margins()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amd/amdgpu/sriov disable all ip hw status by default

Thomas Zimmermann <tzimmermann@suse.de>
    drm/zte: Don't select DRM_KMS_FB_HELPER

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mxsfb: Don't select DRM_KMS_FB_HELPER


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/mips/boot/compressed/string.c                 | 17 ++++
 arch/mips/include/asm/hugetlb.h                    |  8 +-
 arch/mips/include/asm/mipsregs.h                   |  8 +-
 arch/mips/include/asm/pgalloc.h                    | 10 ++-
 arch/mips/loongson64/loongson-3/numa.c             |  3 +
 arch/powerpc/include/asm/barrier.h                 |  2 +
 arch/powerpc/mm/fault.c                            |  4 +-
 block/blk-rq-qos.c                                 |  4 +-
 drivers/ata/ahci_sunxi.c                           |  2 +-
 drivers/atm/iphase.c                               |  2 +-
 drivers/atm/nicstar.c                              | 26 ++++---
 drivers/bluetooth/btusb.c                          | 15 ++--
 drivers/char/ipmi/ipmi_watchdog.c                  | 22 +++---
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |  1 +
 drivers/clk/tegra/clk-pll.c                        |  9 +--
 drivers/clocksource/arm_arch_timer.c               |  2 +-
 drivers/crypto/ccp/psp-dev.c                       |  4 +
 drivers/extcon/extcon-intel-mrfld.c                |  9 +++
 drivers/firmware/qemu_fw_cfg.c                     |  8 +-
 drivers/fpga/stratix10-soc.c                       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   | 21 +----
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 22 +++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 24 +++++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    | 41 ++++++++--
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  2 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c  |  9 ++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  2 +-
 drivers/gpu/drm/amd/display/dc/irq_types.h         |  2 +-
 drivers/gpu/drm/amd/include/navi10_enum.h          |  2 +-
 drivers/gpu/drm/arm/malidp_planes.c                |  9 ++-
 drivers/gpu/drm/bridge/cdns-dsi.c                  |  2 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |  2 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |  2 -
 drivers/gpu/drm/msm/disp/mdp4/mdp4_plane.c         |  8 +-
 drivers/gpu/drm/mxsfb/Kconfig                      |  1 -
 drivers/gpu/drm/radeon/radeon_display.c            |  1 +
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  4 -
 drivers/gpu/drm/scheduler/sched_entity.c           |  5 ++
 drivers/gpu/drm/tegra/dc.c                         | 10 ++-
 drivers/gpu/drm/tegra/drm.c                        |  2 -
 drivers/gpu/drm/vc4/vc4_drv.h                      |  2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |  1 +
 drivers/gpu/drm/zte/Kconfig                        |  1 -
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  2 +-
 drivers/infiniband/core/cma.c                      |  3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  2 +-
 drivers/ipack/carriers/tpci200.c                   |  5 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  2 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  3 +-
 drivers/md/persistent-data/dm-space-map-disk.c     |  9 ++-
 drivers/md/persistent-data/dm-space-map-metadata.c |  9 ++-
 drivers/media/i2c/saa6588.c                        |  4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |  6 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  6 +-
 drivers/media/platform/davinci/vpbe_display.c      |  2 +-
 drivers/media/platform/davinci/vpbe_venc.c         |  6 +-
 drivers/media/rc/bpf-lirc.c                        |  3 +-
 drivers/media/usb/dvb-usb/dtv5100.c                |  7 +-
 drivers/media/usb/gspca/sq905.c                    |  2 +-
 drivers/media/usb/gspca/sunplus.c                  |  8 +-
 drivers/media/usb/uvc/uvc_video.c                  | 27 +++++++
 drivers/media/usb/zr364xx/zr364xx.c                |  1 +
 drivers/mmc/core/core.c                            |  7 +-
 drivers/mmc/core/sd.c                              | 10 ++-
 drivers/mmc/host/sdhci.c                           |  4 +
 drivers/mmc/host/sdhci.h                           |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  4 +
 drivers/net/ethernet/intel/e100.c                  | 12 +--
 drivers/net/ethernet/intel/ice/ice_type.h          |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  5 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |  4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  4 +
 drivers/net/ethernet/micrel/ks8842.c               |  4 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   | 19 ++---
 drivers/net/ethernet/realtek/r8169_main.c          |  1 -
 drivers/net/ethernet/sfc/ef10_sriov.c              | 25 +++---
 drivers/net/fjes/fjes_main.c                       |  4 +
 drivers/net/virtio_net.c                           |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 ++++--
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 15 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  3 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    | 10 +--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   | 11 +--
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 59 ++++++++++++--
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |  1 +
 drivers/net/wireless/ti/wl1251/cmd.c               |  9 ++-
 drivers/net/wireless/ti/wl12xx/main.c              |  7 ++
 drivers/nvmem/core.c                               |  9 ++-
 drivers/pci/controller/pci-aardvark.c              | 13 +++-
 drivers/pci/quirks.c                               | 11 +++
 drivers/pinctrl/pinctrl-amd.c                      |  1 +
 drivers/pinctrl/pinctrl-mcp23s08.c                 | 10 +--
 .../int340x_thermal/processor_thermal_device.c     | 20 +++--
 fs/crypto/fname.c                                  |  9 +--
 fs/jfs/inode.c                                     |  3 +-
 fs/reiserfs/journal.c                              | 14 ++++
 fs/ubifs/super.c                                   |  1 +
 fs/ubifs/ubifs.h                                   |  2 +
 fs/ubifs/xattr.c                                   | 44 ++++++++---
 fs/udf/namei.c                                     |  4 +
 include/linux/mfd/abx500/ux500_chargalg.h          |  2 +-
 include/linux/netdev_features.h                    |  2 +-
 include/linux/wait.h                               |  2 +-
 include/media/v4l2-subdev.h                        |  4 +
 include/net/sctp/structs.h                         |  2 +-
 include/uapi/linux/ethtool.h                       |  4 +-
 kernel/bpf/core.c                                  | 61 ++++++++++-----
 kernel/cpu.c                                       | 49 ++++++++++++
 kernel/sched/wait.c                                |  9 ++-
 kernel/trace/trace.c                               | 91 +++++++++++++---------
 lib/seq_buf.c                                      |  4 +-
 net/bluetooth/hci_core.c                           | 16 ++--
 net/bluetooth/mgmt.c                               |  3 +
 net/core/dev.c                                     | 11 ++-
 net/ipv4/ip_output.c                               | 32 ++++----
 net/ipv6/ip6_output.c                              | 32 ++++----
 net/ipv6/output_core.c                             | 28 ++-----
 net/sched/act_api.c                                |  3 +-
 net/sctp/bind_addr.c                               | 19 +++--
 net/sctp/input.c                                   |  8 +-
 net/sctp/ipv6.c                                    |  7 +-
 net/sctp/protocol.c                                |  7 +-
 net/sctp/sm_make_chunk.c                           | 29 +++----
 net/vmw_vsock/af_vsock.c                           |  2 +-
 net/wireless/wext-spy.c                            | 14 ++--
 net/xfrm/xfrm_user.c                               | 28 +++----
 security/selinux/avc.c                             | 13 ++--
 security/smack/smackfs.c                           |  2 +
 sound/soc/tegra/tegra_alc5632.c                    |  1 +
 sound/soc/tegra/tegra_max98090.c                   |  1 +
 sound/soc/tegra/tegra_rt5640.c                     |  1 +
 sound/soc/tegra/tegra_rt5677.c                     |  1 +
 sound/soc/tegra/tegra_sgtl5000.c                   |  1 +
 sound/soc/tegra/tegra_wm8753.c                     |  1 +
 sound/soc/tegra/tegra_wm8903.c                     |  1 +
 sound/soc/tegra/tegra_wm9712.c                     |  1 +
 sound/soc/tegra/trimslice.c                        |  1 +
 tools/perf/bench/sched-messaging.c                 |  4 +-
 143 files changed, 896 insertions(+), 439 deletions(-)


