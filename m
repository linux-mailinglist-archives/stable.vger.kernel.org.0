Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AE62143C
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiKHN7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiKHN67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:58:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1EF65E51;
        Tue,  8 Nov 2022 05:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBFE6152D;
        Tue,  8 Nov 2022 13:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A81C433D6;
        Tue,  8 Nov 2022 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915936;
        bh=mZ2lZy2MA/sppQZx9qUb42C2j0cPZ4j84H5ADNC5kVU=;
        h=From:To:Cc:Subject:Date:From;
        b=JIZ/faHjfBr+oJrG8vsxScCBX3n8HNsrWJlPE3ub4AM+QTcn3VDYlHo2xPYORV5kP
         ZGrnwmXQjOvmt99T60YWZMyRLGdi0j4+oe2zx8oWteQ051LN2l0ir856d6Jt9Lh8lV
         u1PzBnV4XHMBpiOT56PN5Vp4zndNeYbZu97PJqf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 5.15 000/144] 5.15.78-rc1 review
Date:   Tue,  8 Nov 2022 14:37:57 +0100
Message-Id: <20221108133345.346704162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.78-rc1
X-KernelTest-Deadline: 2022-11-10T13:33+00:00
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

This is the start of the stable review cycle for the 5.15.78 release.
There are 144 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.78-rc1

Dokyung Song <dokyung.song@gmail.com>
    wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Setup DDC fully before output init

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/sdvo: Filter out invalid outputs more sensibly

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Force synchronous probe

Brian Norris <briannorris@chromium.org>
    drm/rockchip: dsi: Clean up 'usage_mode' when failing to attach

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix regression in very old smb1 mounts

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4,f2fs: fix readahead of verity data

Sumit Garg <sumit.garg@linaro.org>
    tee: Fix tee_shm_register() for kernel TEE drivers

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after CR0 write

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: update the emulation mode after rsm

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: introduce emulator_recalc_and_set_mode

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: emulator: em_sysexit should update ctxt->mode

Ryan Roberts <ryan.roberts@arm.com>
    KVM: arm64: Fix bad dereference on MTE-enabled systems

Emanuele Giuseppe Esposito <eesposit@redhat.com>
    KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable

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

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for SPR

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Cooper Lake stepping to isolation_ucodes[]

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix pebs event constraints for ICL

Mark Rutland <mark.rutland@arm.com>
    arm64: entry: avoid kprobe recursion

Ard Biesheuvel <ardb@kernel.org>
    efi: random: Use 'ACPI reclaim' memory for random seed

Ard Biesheuvel <ardb@kernel.org>
    efi: random: reduce seed size to 32 bytes

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

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/udp: Make early_demux back namespacified.

Li Huafei <lihuafei1@huawei.com>
    ftrace: Fix use-after-free for dynamic ftrace_ops

David Sterba <dsterba@suse.com>
    btrfs: fix type of parameter generation in btrfs_get_dentry

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix tree mod log mishandling of reallocated nodes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost file sync on direct IO write with nowait and dsync iocb

Eric Biggers <ebiggers@google.com>
    fscrypt: fix keyring memory leak on mount failure

Eric Biggers <ebiggers@google.com>
    fscrypt: stop using keyrings subsystem for fscrypt_master_key

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix memory leaks of the whole sk due to OOB skb.

Yu Kuai <yukuai3@huawei.com>
    block, bfq: protect 'bfqd->queued' by 'bfqd->lock'

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to access uninitialized memory

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM

Chen Zhongjin <chenzhongjin@huawei.com>
    i2c: piix4: Fix adapter not be removed in piix4_remove()

Cristian Marussi <cristian.marussi@arm.com>
    arm64: dts: juno: Add thermal critical trip points

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix devres allocation device in virtio transport

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Make Rx chan_setup fail on memory errors

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Suppress the driver's bind attributes

Chen Zhongjin <chenzhongjin@huawei.com>
    block: Fix possible memory leak for rq_wb on add_disk failure

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: ls208xa: specify clock frequencies for the MDIO controllers

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: ls1088a: specify clock frequencies for the MDIO controllers

Ioana Ciornei <ioana.ciornei@nxp.com>
    arm64: dts: lx2160a: specify clock frequencies for the MDIO controllers

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8: correct clock order

Tim Harvey <tharvey@gateworks.com>
    ARM: dts: imx6qdl-gw59{10,13}: fix user pushbutton GPIO offset

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: Update the force mem core bit for GPU clocks

Jerry Snitselaar <jsnitsel@redhat.com>
    efi/tpm: Pass correct address to memblock_reserve

Martin Tůma <martin.tuma@digiteqautomotive.com>
    i2c: xiic: Add platform module alias

Danijel Slivka <danijel.slivka@amd.com>
    drm/amdgpu: set vm_update_mode=0 as default for Sienna Cichlid in SRIOV case

Samuel Bailey <samuel.bailey1@gmail.com>
    HID: saitek: add madcatz variant of MMO7 mouse device ID

Uday Shankar <ushankar@purestorage.com>
    scsi: core: Restrict legal sdev_state transitions via sysfs

Ashish Kalra <ashish.kalra@amd.com>
    ACPI: APEI: Fix integer overflow in ghes_estatus_pool_init()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: subdev: Fail graciously when getting try data for NULL state

Hangyu Hua <hbh25y@gmail.com>
    media: meson: vdec: fix possible refcount leak in vdec_probe()

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

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix out-of-bounds access on cio_ignore free

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: derive cdev information only for IO-subchannels

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/boot: add secure boot trailer

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing EX_TABLE entries to __clear_user()

Linus Walleij <linus.walleij@linaro.org>
    mtd: parsers: bcm47xxpart: Fix halfblock reads

Rafał Miłecki <rafal@milecki.pl>
    mtd: parsers: bcm47xxpart: print correct offset on read error

Helge Deller <deller@gmx.de>
    fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards

Helge Deller <deller@gmx.de>
    video/fbdev/stifb: Implement the stifb_fillrect() function

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix IRQ lifetime

Daniel Thompson <daniel.thompson@linaro.org>
    drm/msm/hdmi: Remove spurious IRQF_ONESHOT flag

Dexuan Cui <decui@microsoft.com>
    vsock: fix possible infinite sleep in vsock_connectible_wait_data()

Zhengchao Shao <shaozhengchao@huawei.com>
    ipv6: fix WARNING in ip6_route_net_exit_late()

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

Hawkins Jiawei <yin31149@gmail.com>
    Bluetooth: L2CAP: Fix memory leak in vhci_write

Zhengchao Shao <shaozhengchao@huawei.com>
    Bluetooth: L2CAP: fix use-after-free in l2cap_conn_del()

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: virtio_bt: Use skb_put to set length

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release flow rule object from commit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: netlink notifier might race to release objects

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: tun: fix bugs for oversize packet when napi frags enabled

Dan Carpenter <dan.carpenter@oracle.com>
    net: sched: Fix use after free in red_enqueue()

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

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Disable local invalidate operation

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Use hr_reg_xxx() instead of remaining roce_set_xxx()

Xinhao Liu <liuxinhao5@hisilicon.com>
    RDMA/hns: Remove magic number

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Correctly move list in sc_disable()

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cma: Use output interface for net_dev check

Alexander Graf <graf@amazon.com>
    KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

Alexander Graf <graf@amazon.com>
    KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()

Aaron Lewis <aaronlewis@google.com>
    KVM: x86: Protect the unused bits in MSR exiting flags

Roderick Colenbrander <roderick@gaikai.com>
    HID: playstation: add initial DualSense Edge controller support

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page

Shirish S <shirish.s@amd.com>
    drm/amd/display: explicitly disable psr_feature_enable appropriately

Sean Christopherson <seanjc@google.com>
    KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)

Sean Christopherson <seanjc@google.com>
    KVM: x86: Trace re-injected exceptions

Lukas Wunner <lukas@wunner.de>
    serial: ar933x: Deassert Transmit Enable on ->rs485_config()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Rework MIB Rx Monitor debug info logic

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Adjust CMF total bytes and rxmonitor

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Adjust bytes received vales during cmf timer interval


-------------

Diffstat:

 Documentation/trace/histogram.rst                  |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-gw5910.dtsi              |   2 +-
 arch/arm/boot/dts/imx6qdl-gw5913.dtsi              |   2 +-
 arch/arm64/boot/dts/arm/juno-base.dtsi             |  14 +
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |   6 +
 arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi    |  18 +-
 arch/arm64/kernel/entry-common.c                   |   3 +-
 arch/arm64/kvm/hyp/exception.c                     |   3 +-
 arch/parisc/include/asm/hardware.h                 |  12 +-
 arch/parisc/kernel/drivers.c                       |  14 +-
 arch/s390/boot/compressed/vmlinux.lds.S            |  13 +-
 arch/s390/lib/uaccess.c                            |   6 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/ds.c                         |  18 +-
 arch/x86/include/asm/syscall_wrapper.h             |   2 +-
 arch/x86/kvm/cpuid.c                               |  11 +-
 arch/x86/kvm/emulate.c                             | 104 +++--
 arch/x86/kvm/trace.h                               |  12 +-
 arch/x86/kvm/vmx/vmx.c                             |   5 +
 arch/x86/kvm/x86.c                                 | 134 +++++-
 block/bfq-iosched.c                                |   4 +-
 block/genhd.c                                      |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/ata/pata_legacy.c                          |   5 +-
 drivers/bluetooth/virtio_bt.c                      |   2 +-
 drivers/clk/qcom/gcc-sc7280.c                      |   1 +
 drivers/clk/qcom/gpucc-sc7280.c                    |   1 +
 drivers/firmware/arm_scmi/driver.c                 |   9 +-
 drivers/firmware/arm_scmi/virtio.c                 |   6 +-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/firmware/efi/libstub/random.c              |   7 +-
 drivers/firmware/efi/tpm.c                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   8 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c          |  58 ++-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +-
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c    |  22 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-playstation.c                      |   5 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-saitek.c                           |   2 +
 drivers/i2c/busses/i2c-piix4.c                     |   1 +
 drivers/i2c/busses/i2c-xiic.c                      |   1 +
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/device.c                   |  10 +-
 drivers/infiniband/core/nldev.c                    |   2 +-
 drivers/infiniband/hw/hfi1/pio.c                   |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         | 266 ++++-------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         | 166 +++----
 drivers/infiniband/hw/qedr/main.c                  |   9 +-
 drivers/isdn/hardware/mISDN/netjet.c               |   2 +-
 drivers/isdn/mISDN/core.c                          |   5 +-
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c   |   2 +
 drivers/media/cec/platform/s5p/s5p_cec.c           |   2 +
 drivers/media/dvb-frontends/drxk_hard.c            |   2 +-
 .../platform/rockchip/rkisp1/rkisp1-capture.c      |   7 +-
 .../media/platform/rockchip/rkisp1/rkisp1-params.c |  14 +-
 .../media/platform/rockchip/rkisp1/rkisp1-regs.h   |   2 +-
 .../platform/rockchip/rkisp1/rkisp1-resizer.c      |   4 +
 drivers/mtd/parsers/bcm47xxpart.c                  |   4 +-
 drivers/net/dsa/dsa_loop.c                         |  25 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  16 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   7 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/tun.c                                  |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   4 +
 drivers/nfc/fdp/fdp.c                              |  10 +-
 drivers/nfc/nfcmrvl/i2c.c                          |   7 +-
 drivers/nfc/nxp-nci/core.c                         |   7 +-
 drivers/nfc/s3fwrn5/core.c                         |   8 +-
 drivers/parisc/iosapic.c                           |   1 +
 drivers/s390/cio/css.c                             |   3 +-
 drivers/scsi/lpfc/lpfc.h                           |  15 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   8 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  57 +--
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      | 101 ++---
 drivers/scsi/lpfc/lpfc_mem.c                       |   9 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 190 +++++++-
 drivers/scsi/scsi_sysfs.c                          |   8 +
 drivers/staging/media/meson/vdec/vdec.c            |   2 +
 drivers/tee/tee_core.c                             |   3 +
 drivers/tee/tee_shm.c                              |   3 -
 drivers/tty/serial/8250/Kconfig                    |   2 +-
 drivers/tty/serial/ar933x_uart.c                   |   5 +
 drivers/video/fbdev/stifb.c                        |  46 +-
 fs/btrfs/backref.c                                 |  54 ++-
 fs/btrfs/export.c                                  |   2 +-
 fs/btrfs/export.h                                  |   2 +-
 fs/btrfs/extent-tree.c                             |  25 +-
 fs/btrfs/file.c                                    |  39 +-
 fs/btrfs/tests/qgroup-tests.c                      |  20 +-
 fs/cifs/connect.c                                  |  11 +-
 fs/crypto/fscrypt_private.h                        |  71 ++-
 fs/crypto/hooks.c                                  |  10 +-
 fs/crypto/keyring.c                                | 491 +++++++++++----------
 fs/crypto/keysetup.c                               |  81 ++--
 fs/crypto/policy.c                                 |   8 +-
 fs/ext4/migrate.c                                  |   3 +-
 fs/ext4/namei.c                                    |  10 +-
 fs/ext4/verity.c                                   |   3 +-
 fs/f2fs/verity.c                                   |   3 +-
 fs/fuse/file.c                                     |   4 +
 fs/nfs/delegation.c                                |  36 +-
 fs/nfs/nfs42proc.c                                 |   3 +
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4state.c                                 |   2 +
 fs/super.c                                         |   3 +-
 include/acpi/ghes.h                                |   2 +-
 include/linux/efi.h                                |   2 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/fscrypt.h                            |   4 +-
 include/linux/hugetlb.h                            |   8 +-
 include/media/v4l2-subdev.h                        |   6 +
 include/net/protocol.h                             |   4 -
 include/net/tcp.h                                  |   2 +-
 include/net/udp.h                                  |   2 +-
 kernel/kprobes.c                                   |   5 +-
 kernel/trace/ftrace.c                              |  16 +-
 kernel/trace/kprobe_event_gen_test.c               |  18 +-
 kernel/trace/ring_buffer.c                         |  11 +
 mm/gup.c                                           |  14 +-
 mm/hugetlb.c                                       |  27 +-
 net/bluetooth/l2cap_core.c                         |  84 +++-
 net/core/neighbour.c                               |   2 +-
 net/dsa/dsa2.c                                     |  13 +-
 net/ipv4/af_inet.c                                 |  14 +-
 net/ipv4/ip_input.c                                |  37 +-
 net/ipv4/sysctl_net_ipv4.c                         |  59 +--
 net/ipv6/ip6_input.c                               |  23 +-
 net/ipv6/route.c                                   |  14 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/udp.c                                     |   9 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  30 +-
 net/netfilter/ipvs/ip_vs_app.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  30 +-
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/rose/rose_link.c                               |   3 +
 net/sched/sch_red.c                                |   4 +-
 net/smc/af_smc.c                                   |   6 +-
 net/sunrpc/sysfs.c                                 |  12 +-
 net/unix/af_unix.c                                 |  13 +-
 net/vmw_vsock/af_vsock.c                           |   5 +-
 security/commoncap.c                               |   6 +-
 tools/include/nolibc/nolibc.h                      |   4 +-
 151 files changed, 1767 insertions(+), 1243 deletions(-)


