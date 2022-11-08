Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F72621510
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiKHOH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiKHOHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB17E748C0;
        Tue,  8 Nov 2022 06:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4998BB81AFA;
        Tue,  8 Nov 2022 14:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E38CC433C1;
        Tue,  8 Nov 2022 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916465;
        bh=jFrZKOTGfK2eidoSQ5iPe753CqkFb6iXcypVThoP8nw=;
        h=From:To:Cc:Subject:Date:From;
        b=0UX0/ZM4bZ1f0DZCQHh9Xu8bEqu+xkDjDMSx5gDbkaIAU4faAUMNks5+a2bp4UuaS
         vkCqYm2ZRhUYW2u8d1gDrvsZB04BmEImhdxrdzWl68KjXA8kpOggrMP2Jam7/8U8qk
         iQto/JfQAAXG0mMGaG0Jgw1Ezy5PLGVU2cM8VTbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 6.0 000/197] 6.0.8-rc1 review
Date:   Tue,  8 Nov 2022 14:37:18 +0100
Message-Id: <20221108133354.787209461@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.8-rc1
X-KernelTest-Deadline: 2022-11-10T13:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.8 release.
There are 197 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.8-rc1

Dokyung Song <dokyung.song@gmail.com>
    wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Setup DDC fully before output init

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Filter out invalid outputs more sensibly

Leo Chen <sancchen@amd.com>
    drm/amd/display: Update DSC capabilitie for DCN314

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Update latencies on DCN321

Graham Sider <Graham.Sider@amd.com>
    drm/amdgpu: disable GFXOFF during compute for GFX11

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Force synchronous probe

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Clean up 'usage_mode' when failing to attach

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix regression in very old smb1 mounts

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4,f2fs: fix readahead of verity data

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after rsm

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: introduce emulator_recalc_and_set_mode

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: em_sysexit should update ctxt->mode

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: smm: number of GPRs in the SMRAM image depends on the image format

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE

Ryan Roberts <ryan.roberts@arm.com>
    KVM: arm64: Fix bad dereference on MTE-enabled systems

Sean Christopherson <seanjc@google.com>
    KVM: Reject attempts to consume or refresh inactive gfn_to_pfn_cache

Michal Luczaj <mhal@rbox.co>
    KVM: Initialize gfn_to_pfn_cache locks in dedicated helper

Emanuele Giuseppe Esposito <eesposit@redhat.com>
    KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.8000001FH

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.80000001H

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.80000008H

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.8000001AH

Jim Mattson <jmattson@google.com>
    KVM: x86: Mask off reserved bits in CPUID.80000006H

Jiri Olsa <olsajiri@gmail.com>
    x86/syscall: Include asm/ptrace.h in syscall_wrapper header

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/tdx: Panic on bad configs that #VE on "private" memory access

Dave Hansen <dave.hansen@linux.intel.com>
    x86/tdx: Prepare for using "INFO" call for a second purpose

Theodore Ts'o <tytso@mit.edu>
    ext4: update the backup superblock's at the end of the online resize

Luís Henriques <lhenriques@suse.de>
    ext4: fix BUG_ON() when directory entry has invalid rec_len

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in 'ext4_da_release_space'

Helge Deller <deller@gmx.de>
    parisc: Avoid printing the hardware path twice

Helge Deller <deller@gmx.de>
    parisc: Export iosapic_serial_irq() symbol for serial port driver

Helge Deller <deller@gmx.de>
    parisc: Make 8250_gsc driver dependend on CONFIG_PARISC

Stefan Metzmacher <metze@samba.org>
    net: also flag accepted sockets supporting msghdr originated zerocopy

Pavel Begunkov <asml.silence@gmail.com>
    net: remove SOCK_SUPPORT_ZC from sockmap

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for SPR

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for ICL

Petr Benes <petr.benes@ysoft.com>
    ARM: dts: imx6dl-yapp4: Do not allow PM to switch PU regulator off on Q/QP

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: avoid kprobe recursion

Pavel Begunkov <asml.silence@gmail.com>
    net/ulp: remove SOCK_SUPPORT_ZC from tls sockets

Ard Biesheuvel <ardb@kernel.org>
    efi: efivars: Fix variable writes with unsupported query_variable_store()

Ard Biesheuvel <ardb@kernel.org>
    efi: random: Use 'ACPI reclaim' memory for random seed

Ard Biesheuvel <ardb@kernel.org>
    efi: random: reduce seed size to 32 bytes

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Build without static libraries

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix readdir cache race

Miklos Szeredi <mszeredi@redhat.com>
    fuse: add file_modified() to fallocate

Gaosheng Cui <cuigaosheng1@huawei.com>
    capabilities: fix potential memleak on error path from vfs_getxattr_alloc()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/histogram: Update document for KEYS_MAX size

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    tools/nolibc/string: Fix memcmp() implementation

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Check for NULL cpu_buffer in ring_buffer_wake_waiters()

Li Qiang <liq3ea@163.com>
    kprobe: reverse kp->flags when arm_kprobe failed

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: kprobe: Fix memory leak in test_gen_kprobe/kretprobe_cmd()

Rafael Mendonca <rafaelmendsr@gmail.com>
    fprobe: Check rethook_alloc() return in rethook initialization

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/fprobe: Fix to check whether fprobe is registered correctly

Li Huafei <lihuafei1@huawei.com>
    ftrace: Fix use-after-free for dynamic ftrace_ops

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Fix 'distance' calculation with passthrough ports

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Fix cxl_region leak, cleanup targets at region delete

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Fix region HPA ordering validation

Vishal Verma <vishal.l.verma@intel.com>
    cxl/region: Fix decoder allocation crash

Dan Williams <dan.j.williams@intel.com>
    cxl/pmem: Fix cxl_pmem_region and cxl_memdev leak

Dan Williams <dan.j.williams@intel.com>
    ACPI: NUMA: Add CXL CFMWS 'nodes' to the possible nodes set

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    btrfs: fix a memory allocation failure test in btrfs_submit_direct

Qu Wenruo <wqu@suse.com>
    btrfs: don't use btrfs_chunk::sub_stripes from disk

David Sterba <dsterba@suse.com>
    btrfs: fix type of parameter generation in btrfs_get_dentry

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix tree mod log mishandling of reallocated nodes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost file sync on direct IO write with nowait and dsync iocb

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779g0: Add SASYNCPER clocks

Eric Biggers <ebiggers@google.com>
    fscrypt: fix keyring memory leak on mount failure

Eric Biggers <ebiggers@google.com>
    fscrypt: stop using keyrings subsystem for fscrypt_master_key

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

Chen Zhongjin <chenzhongjin@huawei.com>
    i2c: piix4: Fix adapter not be removed in piix4_remove()

Cristian Marussi <cristian.marussi@arm.com>
    arm64: dts: juno: Add thermal critical trip points

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix deferred_tx_wq release on error paths

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix devres allocation device in virtio transport

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Make Rx chan_setup fail on memory errors

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Suppress the driver's bind attributes

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Add trips to battery thermal zones

Chen Jun <chenjun102@huawei.com>
    blk-mq: Fix kmemleak in blk_mq_init_allocated_queue

Chen Zhongjin <chenzhongjin@huawei.com>
    block: Fix possible memory leak for rq_wb on add_disk failure

Ming Lei <ming.lei@redhat.com>
    ublk_drv: return flag of UBLK_F_URING_CMD_COMP_IN_TASK in case of module

Robert Beckett <bob.beckett@collabora.com>
    drm/i915: stop abusing swiotlb_max_segment

John Keeping <john@metanate.com>
    drm/rockchip: fix fbdev on non-IOMMU devices

Aurelien Jarno <aurelien@aurel32.net>
    drm/rockchip: dw_hdmi: filter regulator -EPROBE_DEFER error messages

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: ls208xa: specify clock frequencies for the MDIO controllers

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: ls1088a: specify clock frequencies for the MDIO controllers

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: lx2160a: specify clock frequencies for the MDIO controllers

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93: correct gpio-ranges

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93: add gpio clk

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8: correct clock order

Tim Harvey <tharvey@gateworks.com>
    ARM: dts: imx6qdl-gw59{10,13}: fix user pushbutton GPIO offset

Li Jun <jun.li@nxp.com>
    arm64: dts: imx8mn: Correct the usb power domain

Li Jun <jun.li@nxp.com>
    arm64: dts: imx8mn: remove otg1 power domain dependency on hsio

Li Jun <jun.li@nxp.com>
    arm64: dts: imx8mm: correct usb power domains

Li Jun <jun.li@nxp.com>
    arm64: dts: imx8mm: remove otg1/2 power domain dependency on hsio

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: verdin-imx8mp: fix ctrl_sleep_moci

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: Update the force mem core bit for GPU clocks

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779g0: Fix HSCIF parent clocks

Jerry Snitselaar <jsnitsel@redhat.com>
    efi/tpm: Pass correct address to memblock_reserve

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Enable CPLD_Dn pull down resistor on MX8Menlo

Marek Vasut <marex@denx.de>
    clk: rs9: Fix I2C accessors

Pavel Begunkov <asml.silence@gmail.com>
    bio: safeguard REQ_ALLOC_CACHE bio put

Martin Tůma <martin.tuma@digiteqautomotive.com>
    i2c: xiic: Add platform module alias

Xander Li <xander_li@kingston.com.tw>
    nvme-pci: disable write zeroes on various Kingston SSD

YuBiao Wang <YuBiao.Wang@amd.com>
    drm/amdgpu: dequeue mes scheduler during fini

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Program GC registers through RLCG interface in gfx_v11/gmc_v11

Nathan Chancellor <nathan@kernel.org>
    drm/amdkfd: Fix type of reset_type parameter in hqd_destroy() callback

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: skip loading pptable from driver on secure board for smu_v13_0_10

Danijel Slivka <danijel.slivka@amd.com>
    drm/amdgpu: set vm_update_mode=0 as default for Sienna Cichlid in SRIOV case

Samuel Bailey <samuel.bailey1@gmail.com>
    HID: saitek: add madcatz variant of MMO7 mouse device ID

Uday Shankar <ushankar@purestorage.com>
    scsi: core: Restrict legal sdev_state transitions via sysfs

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't iopoll from io_ring_ctx_wait_and_kill()

Jason A. Donenfeld <Jason@zx2c4.com>
    hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()

Ashish Kalra <ashish.kalra@amd.com>
    ACPI: APEI: Fix integer overflow in ghes_estatus_pool_init()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Check the HSM rate at runtime_resume

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: subdev: Fail graciously when getting try data for NULL state

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: HEVC: Fix chroma offset computation

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: HEVC: Fix auxilary buffer size calculation

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: hantro: Store HEVC bit depth in context

Hangyu Hua <hbh25y@gmail.com>
    media: meson: vdec: fix possible refcount leak in vdec_probe()

Rory Liu <hellojacky0226@hotmail.com>
    media: platform: cros-ec: Add Kuldax to the match table

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-frontends/drxk: initialize err to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cros-ec-cec: limit msg.len to CEC_MAX_MSG_SIZE

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: s5p_cec: limit msg.len to CEC_MAX_MSG_SIZE

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: rkisp1: Zero v4l2_subdev_format fields in when validating links

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: rkisp1: Use correct macro for gradient registers

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: rkisp1: Initialize color space on resizer sink and source pads

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: rkisp1: Don't pass the quantization to rkisp1_csm_config()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: rkisp1: Fix source pad format configuration

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-adc: fix channel sampling time init

Dexuan Cui <decui@microsoft.com>
    vsock: fix possible infinite sleep in vsock_connectible_wait_data()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipv6: fix WARNING in ip6_route_net_exit_late()

Ido Schimmel <idosch@nvidia.com>
    bridge: Fix flushing of dynamic FDB entries

Chen Zhongjin <chenzhongjin@huawei.com>
    net, neigh: Fix null-ptr-deref in neigh_table_clear()

Chen Zhongjin <chenzhongjin@huawei.com>
    net/smc: Fix possible leaked pernet namespace in smc_init()

Liu Peibao <liupeibao@loongson.cn>
    stmmac: dwmac-loongson: fix invalid mdio_node

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Free rwi on reset success

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: mdio: fix undefined behavior in bit shift for __mdiobus_register

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix not restoring ISO buffer count on disconnect

Hawkins Jiawei <yin31149@gmail.com>
    Bluetooth: L2CAP: Fix memory leak in vhci_write

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: virtio_bt: Use skb_put to set length

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_conn: Fix CIS connection dst_type handling

Maxim Mikityanskiy <maxtram95@gmail.com>
    Bluetooth: L2CAP: Fix use-after-free caused by l2cap_reassemble_sdu

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: enforce documented limit to prevent allocating huge memory

Filipe Manana <fdmanana@suse.com>
    btrfs: fix ulist leaks in error paths of qgroup self tests

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode list leak during backref walking at find_parent_nodes()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode list leak during backref walking at resolve_indirect_refs()

Yang Yingliang <yangyingliang@huawei.com>
    isdn: mISDN: netjet: fix wrong check of device registration

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_register_device()

Zhang Qilong <zhangqilong3@huawei.com>
    rose: Fix NULL pointer dereference in rose_send_frame()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipvs: fix WARNING in ip_vs_app_net_cleanup()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipvs: fix WARNING in __ip_vs_cleanup_batch()

Jason A. Donenfeld <Jason@zx2c4.com>
    ipvs: use explicitly signed chars

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix unmapping of received frames using FDMA

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix FDMA when MTU is changed

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Adjust maximum frame size when vlan is enabled/disabled

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix the MTU calculation

Jeff Layton <jlayton@kernel.org>
    nfsd: fix net-namespace logic in __nfsd_file_cache_purge

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file_unhash_and_dispose

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    sfc: Fix an error handling path in efx_pci_probe()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flow rule object from commit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: netlink notifier might race to release objects

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: tun: fix bugs for oversize packet when napi frags enabled

Dan Carpenter <dan.carpenter@oracle.com>
    net: sched: Fix use after free in red_enqueue()

Yang Yingliang <yangyingliang@huawei.com>
    ata: palmld: fix return value check in palmld_pata_probe()

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: fix pdc20230_set_piomode()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: fec: fix improper use of NETDEV_TX_BUSY

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()

Shang XiaoJing <shangxiaojing@huawei.com>
    nfc: fdp: Fix potential memory leak in fdp_nci_send()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fall back to default tagger if we can't load the one from DT

Willy Tarreau <w@1wt.eu>
    tools/nolibc: Fix missing strlen() definition and infinite loop with gcc-12

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/qedr: clean up work queue on failure in qedr_alloc_resources()

Chen Zhongjin <chenzhongjin@huawei.com>
    RDMA/core: Fix null-ptr-deref in ib_core_cleanup()

Chen Zhongjin <chenzhongjin@huawei.com>
    net: dsa: Fix possible memory leaks in dsa_loop_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    nfs4: Fix kmemleak when allocate slot failed

Benjamin Coddington <bcodding@redhat.com>
    NFSv4.2: Fixup CLONE dest file size for zero-length count

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    SUNRPC: Fix null-ptr-deref when xps sysfs alloc failed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Handle RECLAIM_COMPLETE trunking errors

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a potential state reclaim deadlock

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix mr leak in RESPST_ERR_RNR

Akira Yokosawa <akiyks@gmail.com>
    docs/process/howto: Replace C89 with C11

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Fix NULL pointer problem in free_mr_init()

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Disable local invalidate operation

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Correctly move list in sc_disable()

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Use output interface for net_dev check

Jason Gunthorpe <jgg@ziepe.ca>
    drm/i915/gvt: Add missing vfio_unregister_group_dev() call

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't delay End Transfer on delayed_status

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Force sending delayed status during soft disconnect


-------------

Diffstat:

 Documentation/process/howto.rst                    |   2 +-
 Documentation/trace/histogram.rst                  |   2 +-
 Documentation/translations/it_IT/process/howto.rst |   2 +-
 Documentation/translations/ja_JP/howto.rst         |   2 +-
 Documentation/translations/ko_KR/howto.rst         |   2 +-
 Documentation/translations/zh_CN/process/howto.rst |   2 +-
 Documentation/translations/zh_TW/process/howto.rst |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6q-yapp4-crux.dts             |   4 +
 arch/arm/boot/dts/imx6qdl-gw5910.dtsi              |   2 +-
 arch/arm/boot/dts/imx6qdl-gw5913.dtsi              |   2 +-
 arch/arm/boot/dts/imx6qp-yapp4-crux-plus.dts       |   4 +
 arch/arm/boot/dts/ste-href.dtsi                    |   8 +
 arch/arm/boot/dts/ste-snowball.dts                 |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts     |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts     |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts     |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts     |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-kyle.dts       |   8 +
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     |   8 +
 arch/arm64/boot/dts/arm/juno-base.dtsi             |  14 +
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi    |  18 +-
 arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts  |  16 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   8 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   4 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi   |  20 +-
 arch/arm64/boot/dts/freescale/imx93.dtsi           |  21 +-
 arch/arm64/kernel/entry-common.c                   |   3 +-
 arch/arm64/kvm/hyp/exception.c                     |   3 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  20 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  26 --
 arch/arm64/kvm/hyp/vhe/switch.c                    |   8 -
 arch/parisc/include/asm/hardware.h                 |  12 +-
 arch/parisc/kernel/drivers.c                       |  14 +-
 arch/x86/coco/tdx/tdx.c                            |  25 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/ds.c                         |  18 +-
 arch/x86/include/asm/syscall_wrapper.h             |   2 +-
 arch/x86/kvm/cpuid.c                               |  11 +-
 arch/x86/kvm/emulate.c                             | 108 +++--
 arch/x86/kvm/vmx/capabilities.h                    |  19 +-
 arch/x86/kvm/vmx/vmx.c                             |  23 +-
 arch/x86/kvm/x86.c                                 |  12 +-
 arch/x86/kvm/xen.c                                 |  57 +--
 block/bio.c                                        |   2 +-
 block/blk-mq.c                                     |   4 +-
 block/genhd.c                                      |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/numa/srat.c                           |   1 +
 drivers/ata/pata_legacy.c                          |   5 +-
 drivers/ata/pata_palmld.c                          |   4 +-
 drivers/block/ublk_drv.c                           |   3 +
 drivers/bluetooth/virtio_bt.c                      |   2 +-
 drivers/char/hw_random/bcm2835-rng.c               |   2 +-
 drivers/clk/clk-renesas-pcie.c                     |  65 ++-
 drivers/clk/qcom/gcc-sc7280.c                      |   1 +
 drivers/clk/qcom/gpucc-sc7280.c                    |   1 +
 drivers/clk/renesas/r8a779g0-cpg-mssr.c            |  13 +-
 drivers/cxl/core/pmem.c                            |   2 +
 drivers/cxl/core/port.c                            |  11 +-
 drivers/cxl/core/region.c                          |  90 ++--
 drivers/cxl/cxl.h                                  |   4 +-
 drivers/cxl/pmem.c                                 | 101 +++--
 drivers/firmware/arm_scmi/driver.c                 |   9 +-
 drivers/firmware/arm_scmi/virtio.c                 |  26 +-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/firmware/efi/libstub/random.c              |   7 +-
 drivers/firmware/efi/tpm.c                         |   2 +-
 drivers/firmware/efi/vars.c                        |  68 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |  18 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |  42 +-
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |   2 +-
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |  10 +-
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |   5 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c          |  58 ++-
 drivers/gpu/drm/i915/gem/i915_gem_internal.c       |  19 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |   2 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   1 +
 drivers/gpu/drm/i915/i915_scatterlist.h            |  34 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  22 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |   3 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |   5 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  20 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-saitek.c                           |   2 +
 drivers/i2c/busses/i2c-piix4.c                     |   1 +
 drivers/i2c/busses/i2c-xiic.c                      |   1 +
 drivers/iio/adc/stm32-adc.c                        |  11 +-
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/device.c                   |  10 +-
 drivers/infiniband/core/nldev.c                    |   2 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  15 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 -
 drivers/infiniband/hw/qedr/main.c                  |   9 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |   4 +-
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/isdn/mISDN/core.c                          |   5 +-
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c   |   4 +
 drivers/media/cec/platform/s5p/s5p_cec.c           |   2 +
 drivers/media/dvb-frontends/drxk_hard.c            |   2 +-
 .../platform/rockchip/rkisp1/rkisp1-capture.c      |   7 +-
 .../media/platform/rockchip/rkisp1/rkisp1-isp.c    |  40 +-
 .../media/platform/rockchip/rkisp1/rkisp1-params.c |  14 +-
 .../media/platform/rockchip/rkisp1/rkisp1-regs.h   |   2 +-
 .../platform/rockchip/rkisp1/rkisp1-resizer.c      |   4 +
 drivers/net/dsa/dsa_loop.c                         |  25 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  16 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  26 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   2 +
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |  15 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |   6 +
 drivers/net/ethernet/sfc/efx.c                     |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   7 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/tun.c                                  |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   4 +
 drivers/nfc/fdp/fdp.c                              |  10 +-
 drivers/nfc/nfcmrvl/i2c.c                          |   7 +-
 drivers/nfc/nxp-nci/core.c                         |   7 +-
 drivers/nfc/s3fwrn5/core.c                         |   8 +-
 drivers/nvme/host/pci.c                            |  10 +
 drivers/parisc/iosapic.c                           |   1 +
 drivers/scsi/scsi_sysfs.c                          |   8 +
 drivers/staging/media/hantro/hantro_drv.c          |   7 +
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c  |   2 +-
 drivers/staging/media/hantro/hantro_hevc.c         |   4 +-
 drivers/staging/media/meson/vdec/vdec.c            |   2 +
 drivers/tty/serial/8250/Kconfig                    |   2 +-
 fs/btrfs/backref.c                                 |  54 ++-
 fs/btrfs/ctree.h                                   |   5 +-
 fs/btrfs/export.c                                  |   2 +-
 fs/btrfs/export.h                                  |   2 +-
 fs/btrfs/extent-tree.c                             |  25 +-
 fs/btrfs/file.c                                    |  22 +-
 fs/btrfs/inode.c                                   |  16 +-
 fs/btrfs/tests/qgroup-tests.c                      |  20 +-
 fs/btrfs/volumes.c                                 |  12 +-
 fs/cifs/connect.c                                  |  11 +-
 fs/crypto/fscrypt_private.h                        |  71 ++-
 fs/crypto/hooks.c                                  |  10 +-
 fs/crypto/keyring.c                                | 491 +++++++++++----------
 fs/crypto/keysetup.c                               |  81 ++--
 fs/crypto/policy.c                                 |   8 +-
 fs/ext4/ioctl.c                                    |   3 +-
 fs/ext4/migrate.c                                  |   3 +-
 fs/ext4/namei.c                                    |  10 +-
 fs/ext4/resize.c                                   |   5 +
 fs/ext4/verity.c                                   |   3 +-
 fs/f2fs/verity.c                                   |   3 +-
 fs/fuse/file.c                                     |   4 +
 fs/fuse/readdir.c                                  |  10 +-
 fs/nfs/delegation.c                                |  36 +-
 fs/nfs/nfs42proc.c                                 |   3 +
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4state.c                                 |   2 +
 fs/nfsd/filecache.c                                |  39 +-
 fs/super.c                                         |   3 +-
 include/acpi/ghes.h                                |   2 +-
 include/linux/efi.h                                |   2 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/fscrypt.h                            |   4 +-
 include/linux/kvm_host.h                           |  24 +-
 include/media/v4l2-subdev.h                        |   6 +
 include/net/sock.h                                 |   7 +
 io_uring/io_uring.c                                |  13 +-
 kernel/kprobes.c                                   |   5 +-
 kernel/trace/fprobe.c                              |   5 +-
 kernel/trace/ftrace.c                              |  16 +-
 kernel/trace/kprobe_event_gen_test.c               |  18 +-
 kernel/trace/ring_buffer.c                         |  11 +
 net/bluetooth/hci_conn.c                           |  18 +-
 net/bluetooth/iso.c                                |  14 +-
 net/bluetooth/l2cap_core.c                         |  84 +++-
 net/bridge/br_netlink.c                            |   2 +-
 net/bridge/br_sysfs_br.c                           |   2 +-
 net/core/neighbour.c                               |   2 +-
 net/dsa/dsa2.c                                     |  13 +-
 net/ipv4/af_inet.c                                 |   2 +
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/ipv4/tcp_ulp.c                                 |   3 +
 net/ipv4/udp_bpf.c                                 |   4 +-
 net/ipv6/route.c                                   |  14 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  30 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  30 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/rose/rose_link.c                               |   3 +
 net/sched/sch_red.c                                |   4 +-
 net/smc/af_smc.c                                   |   6 +-
 net/sunrpc/sysfs.c                                 |  12 +-
 net/unix/unix_bpf.c                                |   8 +-
 net/vmw_vsock/af_vsock.c                           |   5 +-
 security/commoncap.c                               |   6 +-
 tools/include/nolibc/string.h                      |  17 +-
 tools/testing/selftests/landlock/Makefile          |   7 +-
 virt/kvm/pfncache.c                                |  62 ++-
 213 files changed, 1962 insertions(+), 1102 deletions(-)


