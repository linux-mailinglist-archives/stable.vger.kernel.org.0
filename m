Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDF76777D3
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjAWJwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 04:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjAWJwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 04:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D41422C;
        Mon, 23 Jan 2023 01:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CC660DBB;
        Mon, 23 Jan 2023 09:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B8AC433EF;
        Mon, 23 Jan 2023 09:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674467547;
        bh=+umUdsKewC47Y7HuZXDCz6IUjwSAm0ssRpCmC2MhmF8=;
        h=From:To:Cc:Subject:Date:From;
        b=HIlTNSYH4tCzrx+R/y4HT4eLOSJx7npRN+gwAku4T2wHIZt9mIQG2nOGqjpzXflyr
         jVJL8zumMpQDlEKU8Uhe0C8iAV1TSCYL8NuRQtFvGbb10mi/L3V9FgtzGYDh6rZzmY
         JiyvtxBKzGk8sCJHvWacDQFJ+ENbDT6RpuTpSJzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/188] 6.1.8-rc2 review
Date:   Mon, 23 Jan 2023 10:52:24 +0100
Message-Id: <20230123094931.568794202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.8-rc2
X-KernelTest-Deadline: 2023-01-25T09:49+00:00
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

This is the start of the stable review cycle for the 6.1.8 release.
There are 188 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.8-rc2

Stephan Gerhold <stephan@gerhold.net>
    soc: qcom: apr: Make qcom,protection-domain optional again

Eric Dumazet <edumazet@google.com>
    Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Rename deadline_is_seq_writes()

Yang Yingliang <yangyingliang@huawei.com>
    net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

Kevin Hao <haokexin@gmail.com>
    octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt

Paolo Abeni <pabeni@redhat.com>
    net/ulp: use consistent error code when blocking ULP

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

Lang Yu <Lang.Yu@amd.com>
    drm/amdgpu: correct MEC number for gfx11 APUs

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: add tmz support for GC IP v11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add tmz support for GC 11.0.1

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.4

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: enable GFX IP v11.0.4 CG support

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: enable PSP IP v13.0.11 support

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: enable nbio support for NBIO v7.7.1

Tim Huang <tim.huang@amd.com>
    drm/amdgpu/pm: use the specific mailbox registers only for SMU IP v13.0.4

Tim Huang <tim.huang@amd.com>
    drm/amdgpu/soc21: add mode2 asic reset for SMU IP v13.0.11

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/pm: add GFXOFF control IP version check for SMU IP v13.0.11

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add smu 13 support for smu 13.0.11

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11

Tim Huang <tim.huang@amd.com>
    drm/amdgpu/discovery: add PSP IP v13.0.11 support

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add gmc v11 support for GC 11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add gfx support for GC 11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: set the APU flag for GC 11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: set GC 11.0.4 family

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: enable mes support for GC v11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu/discovery: enable soc21 common for GC 11.0.4

YingChi Long <me@inclyc.cn>
    x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN

Kees Cook <keescook@chromium.org>
    exit: Use READ_ONCE() for all oops/warn limit reads

Kees Cook <keescook@chromium.org>
    docs: Fix path paste-o for /sys/kernel/warn_count

Kees Cook <keescook@chromium.org>
    panic: Expose "warn_count" to sysfs

Kees Cook <keescook@chromium.org>
    panic: Introduce warn_limit

Kees Cook <keescook@chromium.org>
    panic: Consolidate open-coded panic_on_warn checks

Kees Cook <keescook@chromium.org>
    exit: Allow oops_limit to be disabled

Kees Cook <keescook@chromium.org>
    exit: Expose "oops_count" to sysfs

Jann Horn <jannh@google.com>
    exit: Put an upper limit on how often we can oops

Kees Cook <keescook@chromium.org>
    panic: Separate sysctl logic from CONFIG_SMP

Ard Biesheuvel <ardb@kernel.org>
    efi: rt-wrapper: Add missing include

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Execute runtime services from a dedicated stack

Alon Zahavi <zahavi.alon@gmail.com>
    fs/ntfs3: Fix attr_punch_hole() null pointer derenference

Paulo Alcantara <pc@cjr.nz>
    cifs: reduce roundtrips on create/qinfo requests

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: disable S/G display on DCN 3.1.4

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: disable S/G display on DCN 3.1.5

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Fix COLOR_SPACE_YCBCR2020_TYPE matrix

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Calculate output_color_space after pixel encoding adjustment

hongao <hongao@uniontech.com>
    drm/amd/display: Fix set scaling doesn's work

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Remove unused variable

Thomas Zimmermann <tzimmermann@suse.de>
    drm/i915: Allow switching away via vga-switcheroo if uninitialized

Drew Davenport <ddavenport@chromium.org>
    drm/i915/display: Check source height is > 0

Sasa Dragic <sasa.dragic@gmail.com>
    drm/i915: re-disable RC6p on Sandy Bridge

jie1zhan <jesse.zhang@amd.com>
    drm/amdgpu: Correct the power calcultion for Renior/Cezanne.

Lang Yu <Lang.Yu@amd.com>
    drm/amdgpu: allow multipipe policy on ASICs with one MEC

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix amdgpu_job_free_resources v2

Arnd Bergmann <arnd@arndb.de>
    ARM: omap1: fix !ARCH_OMAP1_ANY link failures

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI

Vishnu Dasa <vdasa@vmware.com>
    VMCI: Use threaded irqs instead of tasklets

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add meteor lake point M DID

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: fix unlink on bus in error path

Khazhismel Kumykov <khazhy@chromium.org>
    gsmi: fix null-deref in gsmi_get_variable

Matthew Howell <matthew.howell@sealevel.com>
    serial: exar: Add support for Sealevel 7xxxC serial cards

Tobias Schramm <t.schramm@manjaro.org>
    serial: atmel: fix incorrect baudrate setup

Lino Sanfilippo <l.sanfilippo@kunbus.com>
    serial: amba-pl011: fix high priority character transmission in rs486 mode

Reinette Chatre <reinette.chatre@intel.com>
    dmaengine: idxd: Do not call DMX TX callbacks during workqueue disable

Reinette Chatre <reinette.chatre@intel.com>
    dmaengine: idxd: Prevent use after free on completion memory

Reinette Chatre <reinette.chatre@intel.com>
    dmaengine: idxd: Let probe fail when workqueue cannot be enabled

Mohan Kumar <mkumard@nvidia.com>
    dmaengine: tegra210-adma: fix global intr clear

Peter Harliman Liem <pliem@maxlinear.com>
    dmaengine: lgm: Move DT parsing after initialization

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: pch_uart: Pass correct sg to dma_unmap_sg()

Heiner Kallweit <hkallweit1@gmail.com>
    dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation

Heiner Kallweit <hkallweit1@gmail.com>
    dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation

Li Jun <jun.li@nxp.com>
    arm64: dts: imx8mp: correct usb clocks

Juhyung Park <qkrwngud825@gmail.com>
    usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210

Maciej Żenczykowski <maze@google.com>
    usb: gadget: f_ncm: fix potential NULL ptr deref in ncm_bitrate()

Chanh Nguyen <chanh@os.amperecomputing.com>
    USB: gadget: Add ID numbers to configfs-gadget driver names

Daniel Scally <dan.scally@ideasonboard.com>
    usb: gadget: g_webcam: Send color matching descriptor per frame

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix pin assignment calculation

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Add pin assignment helper

ChiYuan Huang <cy_huang@richtek.com>
    usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: fix error return code in omap2430_probe()

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: ehci-fsl: Fix module alias

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: remove fetched trb from cache before dequeuing

Michael Adler <michael.adler@siemens.com>
    USB: serial: cp210x: add SCALANCE LPE-9000 device id

Alan Stern <stern@rowland.harvard.edu>
    USB: gadgetfs: Fix race between mounting and unmounting

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: userspace: validate v4-v6 subflows mix

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: netlink: respect v4/v6-only sockets

Paolo Abeni <pabeni@redhat.com>
    mptcp: explicitly specify sock family at subflow creation time

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't reissue in case of poll race on multishot request

Jens Axboe <axboe@kernel.dk>
    pktcdvd: check for NULL returna fter calling bio_split_to_limits()

Gaosheng Cui <cuigaosheng1@huawei.com>
    tty: fix possible null-ptr-defer in spk_ttyio_release

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO buffer

Paul Moore <paul@paul-moore.com>
    bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: dts: sifive: fu740: fix size of pcie 32bit memory

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Do not call PM runtime functions in tb_retimer_scan()

Utkarsh Patel <utkarsh.h.patel@intel.com>
    thunderbolt: Do not report errors if on-board retimers are found

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use correct function to calculate maximum USB3 link rate

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Disable XDomain lane 1 only in software connection manager

Enzo Matsumiya <ematsumiya@suse.de>
    cifs: do not include page data when checking signature

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota rescan and disable leading to NULL pointer deref

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid leaf access due to inline extent during lseek

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: do not warn on record without old_roots populated

Filipe Manana <fdmanana@suse.com>
    btrfs: do not abort transaction on failure to update log root

Filipe Manana <fdmanana@suse.com>
    btrfs: do not abort transaction on failure to write log tree when syncing log

Filipe Manana <fdmanana@suse.com>
    btrfs: add missing setup of log for full commit at add_conflicting_inode()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix directory logging due to race with concurrent index key deletion

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when logging directory items

Qu Wenruo <wqu@suse.com>
    btrfs: add extra error messages to cover non-ENOMEM errors from device_add_list()

Zach O'Keefe <zokeefe@google.com>
    mm/MADV_COLLAPSE: don't expand collapse when vm_end is past requested end

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA

Peter Xu <peterx@redhat.com>
    mm/hugetlb: pre-allocate pgtable pages for uffd wr-protects

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()

David Hildenbrand <david@redhat.com>
    mm/hugetlb: fix PTE marker handling in hugetlb_change_protection()

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting

Samuel Holland <samuel@sholland.org>
    mmc: sunxi-mmc: Fix clock refcount imbalance during unbind

Ard Biesheuvel <ardb@kernel.org>
    ACPI: PRM: Check whether EFI runtime is available

Ian Abbott <abbotti@mev.co.uk>
    comedi: adv_pci1760: Fix PWM instruction handling

Flavio Suligoi <f.suligoi@asem.it>
    usb: core: hub: disable autosuspend for TI TUSB8041

Ola Jeppsson <ola@snap.com>
    misc: fastrpc: Fix use-after-free race condition for maps

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Don't remove map on creater_process and device_release

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Fix use-after-free and race in fastrpc_map_find

Matthias Kaehlcke <mka@chromium.org>
    usb: misc: onboard_hub: Move 'attach' work to the driver

Matthias Kaehlcke <mka@chromium.org>
    usb: misc: onboard_hub: Invert driver registration order

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100

Arnd Bergmann <arnd@arndb.de>
    staging: vchiq_arm: fix enum vchiq_status return types

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05CN (SG) modem

Ali Mirghasemi <ali.mirghasemi1376@gmail.com>
    USB: serial: option: add Quectel EC200U modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (RS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (CS) modem

Duke Xin(辛安文) <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G (GR) modem

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    prlimit: do_prlimit needs to have a speculation check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: acpi: add helper to check port lpm capability using acpi _DSM

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add a flag to disable USB3 lpm on a xhci root port level.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Add update_hub_device override for PCI xHCI hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix null pointer dereference when host dies

Jimmy Hu <hhhuuu@google.com>
    usb: xhci: Check endpoint is valid before dereferencing it

Ricardo Ribalda <ribalda@chromium.org>
    xhci-pci: set the dma max_seg_size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler"

Marek Vasut <marex@denx.de>
    serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler

Hugh Dickins <hughd@google.com>
    mm/khugepaged: fix collapse_pte_mapped_thp() to allow anon_vma

James Houghton <jthoughton@google.com>
    hugetlb: unshare some PMDs when splitting VMAs

Zach O'Keefe <zokeefe@google.com>
    mm/shmem: restore SHMEM_HUGE_DENY precedence over MADV_COLLAPSE

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix general protection fault in nilfs_btree_insert()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Detect append writes at invalid locations

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add HWCAP_LOONGARCH_CPUCFG to elf_hwcap

Shawn.Shao <shawn.shao@jaguarmicro.com>
    Add exception protection processing for vd in axi_chan_handle_err function

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fix PIE proc-empty-vm, proc-pid-vm tests

Liam Howlett <liam.howlett@oracle.com>
    nommu: fix split_vma() map_count error

Liam Howlett <liam.howlett@oracle.com>
    nommu: fix do_munmap() error path

Liam Howlett <liam.howlett@oracle.com>
    nommu: fix memory leak in do_mmap() error path

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix initialization of rx->link and rx->link_sta

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: mac80211: sdata can be NULL during AMPDU start

Aloka Dixit <quic_alokad@quicinc.com>
    wifi: mac80211: reset multiple BSSID options in stop_ap()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix MLO + AP_VLAN check

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    Bluetooth: hci_qca: Fix driver shutdown on closed serdev

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2

Arnd Bergmann <arnd@arndb.de>
    fbdev: omapfb: avoid stack overflow warning

Rob Herring <robh@kernel.org>
    of: fdt: Honor CONFIG_CMDLINE* even without /chosen node, take 2

Zhang Rui <rui.zhang@intel.com>
    perf/x86/rapl: Add support for Intel Emerald Rapids

Zhang Rui <rui.zhang@intel.com>
    perf/x86/rapl: Add support for Intel Meteor Lake

Aaron Thompson <dev@aaront.org>
    memblock tests: Fix compilation error.

Paulo Alcantara <pc@cjr.nz>
    cifs: fix race in assemble_neg_contexts()

Chris Wilson <chris@chris-wilson.co.uk>
    perf/x86/rapl: Treat Tigerlake like Icelake

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: let's avoid panic if extent_tree is not created

Mikulas Patocka <mpatocka@redhat.com>
    x86/asm: Fix an assembler warning with current binutils

Qu Wenruo <wqu@suse.com>
    btrfs: always report error in run_one_delayed_ref()

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: fix cmsg_so_mark.sh test hang

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    RDMA/srp: Move large values to a new enum for gcc13

Kui-Feng Lee <kuifeng@meta.com>
    bpf: keep a reference to the mm, in case the task is dead.

Chunhao Lin <hau@realtek.com>
    r8169: fix dmar pte write access is not set error

Chunhao Lin <hau@realtek.com>
    r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats

Cindy Lu <lulu@redhat.com>
    vdpa_sim_net: should not drop the multicast/broadcast packet

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    vduse: Validate vq_num in vduse_validate_config()

Angus Chen <angus.chen@jaguarmicro.com>
    virtio_pci: modify ENOENT to EINVAL

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Avoid overwriting CVQ iotlb

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Avoid using reslock in event_handler

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Return error on vlan ctrl commands if not supported

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    tools/virtio: initialize spinlocks in vring_test.c

Anuradha Weeraman <anuradha@debian.org>
    net: ethernet: marvell: octeontx2: Fix uninitialized variable warning

Hao Sun <sunhao.th@gmail.com>
    selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    pNFS/filelayout: Fix coalescing test for single DS

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fw: skip PPAG for JF

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix trace event name typo for FLUSH_DELAYED_REFS

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_buf_export init order v2


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-oops_count  |   6 +
 Documentation/ABI/testing/sysfs-kernel-warn_count  |   6 +
 Documentation/admin-guide/sysctl/kernel.rst        |  19 ++
 ...2a-usb2-phy.yaml => amlogic,g12a-usb2-phy.yaml} |   8 +-
 ...ie-phy.yaml => amlogic,g12a-usb3-pcie-phy.yaml} |   6 +-
 MAINTAINERS                                        |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts         |  20 +-
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   4 +-
 arch/arm/mach-omap1/Kconfig                        |   5 +-
 arch/arm/mach-omap1/Makefile                       |   4 -
 arch/arm/mach-omap1/io.c                           |  32 ++-
 arch/arm/mach-omap1/mcbsp.c                        |  21 --
 arch/arm/mach-omap1/pm.h                           |   7 -
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |  12 +-
 arch/arm64/include/asm/efi.h                       |   3 +
 arch/arm64/kernel/efi-rt-wrapper.S                 |  14 +-
 arch/arm64/kernel/efi.c                            |  27 +++
 arch/loongarch/kernel/cpu-probe.c                  |   2 +-
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi         |   2 +-
 arch/x86/events/rapl.c                             |   5 +
 arch/x86/kernel/fpu/init.c                         |   7 +-
 arch/x86/lib/iomap_copy_64.S                       |   2 +-
 block/mq-deadline.c                                |   4 +-
 drivers/accessibility/speakup/spk_ttyio.c          |   3 +
 drivers/acpi/prmt.c                                |  10 +
 drivers/block/pktcdvd.c                            |   2 +
 drivers/bluetooth/hci_qca.c                        |   7 +
 drivers/comedi/drivers/adv_pci1760.c               |   2 +-
 drivers/dma-buf/dma-buf-sysfs-stats.c              |   7 +-
 drivers/dma-buf/dma-buf-sysfs-stats.h              |   4 +-
 drivers/dma-buf/dma-buf.c                          |  84 ++++----
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   6 +
 drivers/dma/idxd/device.c                          |  16 +-
 drivers/dma/lgm/lgm-dma.c                          |  10 +-
 drivers/dma/tegra210-adma.c                        |   2 +-
 drivers/firmware/google/gsmi.c                     |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  22 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  19 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   7 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   3 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |  17 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   2 +-
 drivers/gpu/drm/i915/i915_driver.c                 |   5 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   3 +-
 drivers/gpu/drm/i915/i915_switcheroo.c             |   6 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |   8 +-
 drivers/misc/fastrpc.c                             |  67 ++++---
 drivers/misc/mei/bus.c                             |  12 +-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/vmw_vmci/vmci_guest.c                 |  49 ++---
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  22 +-
 drivers/mmc/host/sunxi-mmc.c                       |   8 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  58 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   5 +
 drivers/of/fdt.c                                   |  28 +--
 drivers/soc/qcom/apr.c                             |   3 +-
 .../include/linux/raspberrypi/vchiq.h              |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.h  |   4 +-
 drivers/thunderbolt/retimer.c                      |  20 +-
 drivers/thunderbolt/tb.c                           |  20 +-
 drivers/thunderbolt/tunnel.c                       |   2 +-
 drivers/thunderbolt/xdomain.c                      |  17 +-
 drivers/tty/serial/8250/8250_exar.c                |  14 ++
 drivers/tty/serial/amba-pl011.c                    |   8 +-
 drivers/tty/serial/atmel_serial.c                  |   8 +-
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/tty/serial/qcom_geni_serial.c              |  18 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |  12 ++
 drivers/usb/core/hub.c                             |  13 ++
 drivers/usb/core/usb-acpi.c                        |  65 ++++++
 drivers/usb/gadget/configfs.c                      |  12 +-
 drivers/usb/gadget/function/f_ncm.c                |   4 +-
 drivers/usb/gadget/legacy/inode.c                  |  28 ++-
 drivers/usb/gadget/legacy/webcam.c                 |   3 +
 drivers/usb/host/ehci-fsl.c                        |   2 +-
 drivers/usb/host/xhci-pci.c                        |  45 +++++
 drivers/usb/host/xhci-ring.c                       |   5 +-
 drivers/usb/host/xhci.c                            |  18 +-
 drivers/usb/host/xhci.h                            |   5 +
 drivers/usb/misc/iowarrior.c                       |   2 +-
 drivers/usb/misc/onboard_usb_hub.c                 |  18 +-
 drivers/usb/musb/omap2430.c                        |   4 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/option.c                        |  17 ++
 drivers/usb/storage/uas-detect.h                   |  13 ++
 drivers/usb/storage/unusual_uas.h                  |   7 -
 drivers/usb/typec/altmodes/displayport.c           |  22 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   7 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   5 +-
 drivers/vdpa/mlx5/core/mr.c                        |  44 ++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  68 ++-----
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   3 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   3 +
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |  28 ++-
 drivers/virtio/virtio_pci_modern.c                 |   2 +-
 fs/btrfs/disk-io.c                                 |   9 +-
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/file.c                                    |  13 +-
 fs/btrfs/qgroup.c                                  |  39 +++-
 fs/btrfs/tree-log.c                                |  47 +++--
 fs/btrfs/volumes.c                                 |  11 +-
 fs/cifs/connect.c                                  |  16 --
 fs/cifs/inode.c                                    |   6 -
 fs/cifs/misc.c                                     |  45 -----
 fs/cifs/smb2inode.c                                |  45 +++--
 fs/cifs/smb2ops.c                                  |  28 ++-
 fs/cifs/smb2pdu.c                                  |  26 ++-
 fs/f2fs/extent_cache.c                             |   3 +-
 fs/nfs/filelayout/filelayout.c                     |   8 +
 fs/nilfs2/btree.c                                  |  15 +-
 fs/ntfs3/attrib.c                                  |   2 +-
 fs/userfaultfd.c                                   |  28 ++-
 fs/zonefs/super.c                                  |  22 ++
 include/linux/panic.h                              |   1 +
 include/linux/soc/ti/omap1-io.h                    |   4 +-
 include/linux/usb.h                                |   3 +
 include/trace/events/btrfs.h                       |   2 +-
 io_uring/poll.c                                    |   6 +-
 kernel/bpf/offload.c                               |   3 -
 kernel/bpf/syscall.c                               |   6 +-
 kernel/bpf/task_iter.c                             |  39 ++--
 kernel/exit.c                                      |  62 ++++++
 kernel/kcsan/report.c                              |   3 +-
 kernel/panic.c                                     |  48 ++++-
 kernel/sched/core.c                                |   3 +-
 kernel/sys.c                                       |   2 +
 lib/ubsan.c                                        |   3 +-
 mm/hugetlb.c                                       |  95 ++++++---
 mm/kasan/report.c                                  |   4 +-
 mm/kfence/report.c                                 |   3 +-
 mm/khugepaged.c                                    |  16 +-
 mm/mmap.c                                          |   4 +
 mm/nommu.c                                         |   9 +-
 mm/shmem.c                                         |   6 +-
 net/bluetooth/hci_sync.c                           |   6 +-
 net/ethtool/ioctl.c                                |   3 +-
 net/ipv4/tcp_ulp.c                                 |   2 +-
 net/mac80211/agg-tx.c                              |   6 +-
 net/mac80211/cfg.c                                 |   7 +
 net/mac80211/driver-ops.c                          |   3 +
 net/mac80211/iface.c                               |   5 +-
 net/mac80211/rx.c                                  | 222 +++++++++------------
 net/mptcp/pm.c                                     |  25 +++
 net/mptcp/pm_userspace.c                           |   7 +
 net/mptcp/protocol.c                               |   2 +-
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                |   9 +-
 tools/testing/memblock/.gitignore                  |   1 +
 tools/testing/memblock/Makefile                    |   3 +-
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 +
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 ++++
 tools/testing/selftests/net/cmsg_sender.c          |   2 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  47 +++++
 tools/testing/selftests/proc/proc-empty-vm.c       |  12 +-
 tools/testing/selftests/proc/proc-pid-vm.c         |   9 +-
 tools/virtio/vringh_test.c                         |   2 +
 173 files changed, 1632 insertions(+), 853 deletions(-)


