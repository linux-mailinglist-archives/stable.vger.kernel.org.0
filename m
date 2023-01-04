Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F058765D7E6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbjADQIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbjADQIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FBB18E20;
        Wed,  4 Jan 2023 08:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0F8617A1;
        Wed,  4 Jan 2023 16:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F215C433F0;
        Wed,  4 Jan 2023 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848479;
        bh=cu2DbWw4G+y+134mB/1XKJznzXFMg8APeJqujJk6zyw=;
        h=From:To:Cc:Subject:Date:From;
        b=YHzY1G3gw1g1CwYYTB9DXyhv3a22P+nR90NJUhoK/CFLYO5HZEJfNSbo34jz2uUIU
         pNYJw0Fq6dEcwWoM/a7SeVm145zBgx7ifznpF4XJb4bVwCNlSsy1ZwQYmXkz62OjXH
         H7LdYQGyy1AQjtK/yV17RyMRnfdEDDLXrzXWOfkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/207] 6.1.4-rc1 review
Date:   Wed,  4 Jan 2023 17:04:18 +0100
Message-Id: <20230104160511.905925875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.4-rc1
X-KernelTest-Deadline: 2023-01-06T16:05+00:00
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

This is the start of the stable review cycle for the 6.1.4 release.
There are 207 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.4-rc1

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the fan speed retrieving in PWM for some SMU13 asics

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: bump SMU13.0.0 driver_if header to version 0x34

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add missing SMU13.0.7 mm_dpm feature mapping

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: add missing SMU13.0.0 mm_dpm feature mapping

Chris Wilson <chris.p.wilson@intel.com>
    drm/i915/migrate: Account for the reserved_space

Matthew Auld <matthew.auld@intel.com>
    drm/i915: improve the catch-all evict to handle lock contention

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make display pinning more flexible (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: handle polaris10/11 overlap asics (v2)

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amd/display: Add DCN314 display SG Support

Matthew Auld <matthew.auld@intel.com>
    drm/i915/ttm: consider CCS for backup objects

Ye Bin <yebin10@huawei.com>
    ext4: allocate extended attribute value in vmalloc area

Jan Kara <jack@suse.cz>
    ext4: avoid unaccounted block allocation when expanding inode

Jan Kara <jack@suse.cz>
    ext4: initialize quota before expanding inode in setproject ioctl

Ye Bin <yebin10@huawei.com>
    ext4: fix inode leak in ext4_xattr_inode_create() on an error path

Ye Bin <yebin10@huawei.com>
    ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Jan Kara <jack@suse.cz>
    ext4: fix deadlock due to mbcache entry corruption

Jan Kara <jack@suse.cz>
    ext4: avoid BUG_ON when creating xattrs

Baokun Li <libaokun1@huawei.com>
    ext4: fix corrupt backup group descriptors after online resize

Darrick J. Wong <djwong@kernel.org>
    ext4: dont return EINVAL from GETFSUUID when reporting UUID length

Baokun Li <libaokun1@huawei.com>
    ext4: fix bad checksum after online resize

Luís Henriques <lhenriques@suse.de>
    ext4: fix error code return to user-space in ext4_get_branch()

Baokun Li <libaokun1@huawei.com>
    ext4: fix corruption when online resizing a 1K bigalloc fs

Eric Whitney <enwlinux@gmail.com>
    ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline

Darrick J. Wong <djwong@kernel.org>
    ext4: don't fail GETFSUUID when the caller provides a long buffer

Ye Bin <yebin10@huawei.com>
    ext4: init quota for 'old.inode' in 'ext4_rename'

Ye Bin <yebin10@huawei.com>
    ext4: fix uninititialized value in 'ext4_evict_inode'

Eric Biggers <ebiggers@google.com>
    ext4: fix off-by-one errors in fast-commit block filling

Eric Biggers <ebiggers@google.com>
    ext4: fix unaligned memory access in ext4_fc_reserve_space()

Eric Biggers <ebiggers@google.com>
    ext4: add missing validation of fast-commit record lengths

Eric Biggers <ebiggers@google.com>
    ext4: don't set up encryption key during jbd2 transaction

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking uninitialized memory in fast-commit journal

Eric Biggers <ebiggers@google.com>
    ext4: disable fast-commit of encrypted dir operations

Eric Biggers <ebiggers@google.com>
    ext4: don't allow journal inode to have encrypt flag

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad boot loader inode

Zhang Yi <yi.zhang@huawei.com>
    ext4: check and assert if marking an no_delete evicting inode dirty

Lukas Czerner <lczerner@redhat.com>
    ext4: journal_path mount options should follow links

Ye Bin <yebin10@huawei.com>
    ext4: fix reserved cluster accounting in __es_remove_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad quota inode

Baokun Li <libaokun1@huawei.com>
    ext4: add helper to check quota inums

Baokun Li <libaokun1@huawei.com>
    ext4: add EXT4_IGET_BAD flag to prevent unexpected bad inode

Gaosheng Cui <cuigaosheng1@huawei.com>
    ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_orphan_cleanup

Alexander Potapenko <glider@google.com>
    fs: ext4: initialize fsdata in pagecache_write()

Baokun Li <libaokun1@huawei.com>
    ext4: correct inconsistent error msg in nojournal mode

Luís Henriques <lhenriques@suse.de>
    ext4: remove trailing newline from ext4_msg() message

Baokun Li <libaokun1@huawei.com>
    ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop

Zhang Yi <yi.zhang@huawei.com>
    ext4: silence the warning when evicting inode with dioread_nolock

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: Execute runtime services from a dedicated stack

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: reap idle mapping if it doesn't match the softpin address

Yuan Can <yuancan@huawei.com>
    drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()

Mikko Kovanen <mikko.kovanen@aavamobile.com>
    drm/i915/dsi: fix VBT send packet port selection for dual link DSI

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: move idle mapping reaping into separate function

Jocelyn Falempe <jfalempe@redhat.com>
    drm/mgag200: Fix PLL setup for G200_SE_A rev >=4

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Validate the box size for the snooped cursor

Simon Ser <contact@emersion.fr>
    drm/connector: send hotplug uevent on connector cleanup

Wang Weiyang <wangweiyang2@huawei.com>
    device_cgroup: Roll back to original exceptions after copy failure

Helge Deller <deller@gmx.de>
    parisc: Drop PMD_SHIFT from calculation in pgtable.h

Helge Deller <deller@gmx.de>
    parisc: Drop duplicate kgdb_pdc console

Helge Deller <deller@gmx.de>
    parisc: Add missing FORCE prerequisites in Makefile

Helge Deller <deller@gmx.de>
    parisc: Fix locking in pdc_iodc_print() firmware call

Helge Deller <deller@gmx.de>
    parisc: Drop locking in pdc console code

Shang XiaoJing <shangxiaojing@huawei.com>
    parisc: led: Fix potential null-ptr-deref in start_task()

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Correct i.MX93 DRAM mapping

Maria Yu <quic_aiquny@quicinc.com>
    remoteproc: core: Do pm_relax when in RPROC_OFFLINE state

Shengjiu Wang <shengjiu.wang@nxp.com>
    remoteproc: imx_dsp_rproc: Add mutex protection for workqueue

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: really allocate vma lock for all sharable vmas

Li Hua <hucool.lihua@huawei.com>
    test_kprobes: Fix implicit declaration error of test_kprobes

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ivrs_acpihid cmdline parsing code

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix sc8180x reset

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix sdm845 reset

Qiang Yu <quic_qianyu@quicinc.com>
    bus: mhi: host: Fix race between channel preparation and M0 event

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Fix bus_type.match() error handling in __driver_attach()

Mario Limonciello <mario.limonciello@amd.com>
    crypto: ccp - Add support for TEE for PCI ID 0x14CA

Corentin Labbe <clabbe@baylibre.com>
    crypto: n2 - add missing hash statesize

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: mm: notify remote harts about mmu cache updates

Guo Ren <guoren@kernel.org>
    riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument

Li Huafei <lihuafei1@huawei.com>
    RISC-V: kexec: Fix memory leak of elf header buffer

Guo Ren <guoren@kernel.org>
    riscv: Fixup compile error with !MMU

Li Huafei <lihuafei1@huawei.com>
    RISC-V: kexec: Fix memory leak of fdt buffer

Sascha Hauer <s.hauer@pengutronix.de>
    PCI/sysfs: Fix double free in error path

Michael S. Tsirkin <mst@redhat.com>
    PCI: Fix pci_device_is_present() for VFs by checking PF

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: ccree,hisilicon - Fix dependencies to correct algorithm

Kees Cook <keescook@chromium.org>
    um: virt-pci: Avoid GCC non-NULL warning

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Fix memory leak in __ima_inode_hash()

Yaliang Wang <Yaliang.Wang@windriver.com>
    mtd: spi-nor: gigadevice: gd25q256: replace gd25q256_default_init with gd25q256_post_bfpt

Dan Carpenter <error27@gmail.com>
    ipmi: fix use after free in _ipmi_destroy_user()

Huaxin Lu <luhuaxin1@huawei.com>
    ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix long wait in unload when IPMI disconnect

Maximilian Luz <luzmaximilian@gmail.com>
    ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    ASoC: jz4740-i2s: Handle independent FIFO flush bits

Michael Walle <michael@walle.cc>
    wifi: wilc1000: sdio: fix module autoloading

Aditya Garg <gargaditya08@live.com>
    efi: Add iMac Pro 2017 to uefi skip cert quirk

Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
    md/bitmap: Fix bitmap chunk size overflow issues

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Do not break sequential write streams to zoned HDDs

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    block: mq-deadline: Fix dd_finish_request() for zoned devices

Yang Wang <KevinYang.Wang@amd.com>
    drm/amdgpu: fix mmhub register base coding error

Ian Abbott <abbotti@mev.co.uk>
    rtc: ds1347: fix value written to century register

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Fix "failed to switch device to config mode" message during unbind

Paulo Alcantara <pc@cjr.nz>
    cifs: set correct status of tcon ipc when reconnecting

Paulo Alcantara <pc@cjr.nz>
    cifs: set correct ipc status after initial tree connect

Paulo Alcantara <pc@cjr.nz>
    cifs: set correct tcon status after initial tree connect

Steve French <stfrench@microsoft.com>
    cifs: fix missing display of three mount options

Paulo Alcantara <pc@cjr.nz>
    cifs: fix confusing debug message

Takashi Iwai <tiwai@suse.de>
    media: dvb-core: Fix UAF due to refcount races at releasing

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    media: dvb-core: Fix double free in dvb_register_device()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Macpaul Lin <macpaul.lin@mediatek.com>
    arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon

Luca Ceresoli <luca.ceresoli@bootlin.com>
    staging: media: tegra-video: fix device_node use after free

Luca Ceresoli <luca.ceresoli@bootlin.com>
    staging: media: tegra-video: fix chan->mipi value on error

Yang Jihong <yangjihong1@huawei.com>
    tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Zheng Yejian <zhengyejian1@huawei.com>
    tracing: Fix issue of missing one synthetic field

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/probes: Handle system names with hyphens

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix wrong return value in parse_action_params()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Fix complicated dependency of CONFIG_TRACER_MAX_TRACE

Michael Jeanson <mjeanson@efficios.com>
    powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix race where eprobes can be called before the event

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix optprobe optimization check with CONFIG_RETHUNK

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/kprobes: Fix kprobes instruction boudary check with CONFIG_RETHUNK

Steven Rostedt (Google) <rostedt@goodmis.org>
    ftrace/x86: Add back ftrace_expected for ftrace bug reports

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Do not retry microcode reloading on the APs

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1

Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
    KVM: x86: fix APICv/x2AVIC disabled when vm reboot by itself

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Resume guest immediately when injecting #GP on ECREATE

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    ima: Fix hash dependency to correct algorithm

Rob Herring <robh@kernel.org>
    of/kexec: Fix reading 32-bit "linux,initrd-{start,end}" values

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add __umulsidi3 helper

Namhyung Kim <namhyung@kernel.org>
    perf/core: Call LSM hook after copying perf_event_attr

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix out-of-bound write on 'action_data.var_ref_idx'

Li Ming <ming4.li@intel.com>
    PCI/DOE: Fix maximum data object length miscalculation

Arnd Bergmann <arnd@arndb.de>
    ata: ahci: fix enum constants for gcc-13

Mike Snitzer <snitzer@kernel.org>
    dm cache: set needs_check flag after aborting metadata

Luo Meng <luomeng12@huawei.com>
    dm cache: Fix UAF in destroy()

Luo Meng <luomeng12@huawei.com>
    dm clone: Fix UAF in clone_dtr()

Luo Meng <luomeng12@huawei.com>
    dm integrity: Fix UAF in dm_integrity_dtr()

Luo Meng <luomeng12@huawei.com>
    dm thin: Fix UAF in run_timer_softirq()

Luo Meng <luomeng12@huawei.com>
    dm thin: resume even if in FAIL mode

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Use last transaction's pmd->root when commit failed

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Fix ABBA deadlock between shrink_slab and dm_pool_abort_metadata

Mike Snitzer <snitzer@kernel.org>
    dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: use proper req destructor for IPv6

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: dedicated request sock for subflow in v6

Matthieu Baerts <matthieu.baerts@tessares.net>
    mptcp: remove MPTCP 'ifdef' in TCP SYN cookies

Wei Yongjun <weiyongjun1@huawei.com>
    mptcp: netlink: fix some error return code

Alexander Aring <aahringo@redhat.com>
    fs: dlm: retry accept() until -EAGAIN or error returns

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix sock release if listen fails

Jaroslav Kysela <perex@perex.cz>
    ALSA: usb-audio: Add new quirk FIXED_RATE for JBL Quantum810 Wireless

José Expósito <jose.exposito89@gmail.com>
    HID: Ignore HP Envy x360 eu0009nv stylus battery

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Add Advantech MICA-071 extra button

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Add Lenovo Yoga Tab 3 (YT3-X90F) charger + fuel-gauge data

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Add Medion Lifetab S10346 data

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ALSA: hda/cirrus: Add extra 10 ms delay to allow PLL settle and lock.

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    platform/x86: intel-uncore-freq: add Emerald Rapids support

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Stop writing VPCCMD_W_TOUCHPAD at probe time

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Send KEY_TOUCHPAD_TOGGLE on some models

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Only toggle ps2 aux port on/off on select models

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Do not send KEY_TOUCHPAD* events on probe / resume

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Refactor ideapad_sync_touchpad_state()

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Prefer native over vendor

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Simplify __acpi_video_get_backlight_type()

Philipp Jungkamp <p.jungkamp@gmx.net>
    platform/x86: ideapad-laptop: support for more special keys in WMI

Eray Orçunus <erayorcunus@gmail.com>
    platform/x86: ideapad-laptop: Add new _CFG bit numbers for future use

Eray Orçunus <erayorcunus@gmail.com>
    platform/x86: ideapad-laptop: Revert "check for touchpad support in _CFG"

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Fix max_brightness of thinklight

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Apply dual codec fixup for Dell Latitude laptops

Philipp Jungkamp <p.jungkamp@gmx.net>
    ALSA: patch_realtek: Fix Dell Inspiron Plus 16

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Resolve fext program type when checking map compatibility

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix in register read and write for H264

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Clear workbit to handle error condition

Smitha T Murthy <smitha.t@samsung.com>
    media: s5p-mfc: Fix to handle reference queue during finishing

Al Viro <viro@zeniv.linux.org.uk>
    ext2: unbugger ext2_empty_dir()

Yongqiang Liu <liuyongqiang13@huawei.com>
    cpufreq: Init completion before kobject_init_and_add()

Kant Fan <kant@allwinnertech.com>
    PM/devfreq: governor: Add a private governor_data for governor

Jason A. Donenfeld <Jason@zx2c4.com>
    random: add helpers for random numbers with given floor or range

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/MCE/AMD: Clear DFR errors found in THR handler

Mickaël Salaün <mic@digikod.net>
    selftests: Use optional USERCFLAGS and USERLDFLAGS

Yazen Ghannam <yazen.ghannam@amd.com>
    EDAC/mc_sysfs: Increase legacy channel support to 12

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Fix missing probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm850-lenovo-yoga-c630: correct I2C12 pins drive strength

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/fpu/xstate: Fix XSTATE_WARN_ON() to emit relevant diagnostics

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use rejection sampling for uniform bounded random integers

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm850-samsung-w737: correct I2C12 pins drive strength

Jason A. Donenfeld <Jason@zx2c4.com>
    ARM: ux500: do not directly dereference __iomem

Boris Burkov <boris@bur.io>
    btrfs: fix resolving backrefs for inline extent followed by prealloc

void0red <void0red@gmail.com>
    btrfs: fix extent map use-after-free when handling missing device in read_one_chunk

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix uninitialized parent in insert_state

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct SMU13.0.0 pstate profiling clock settings

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: update SMU13.0.0 reported maximum shader clock

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix out-of-bounds clock access

Wenchao Chen <wenchao.chen@unisoc.com>
    mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix UFS reference clocks

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-db845c: correct SPI2 pins drive strength

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Clear attr_update properly

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Disable I/O stacks to PMU mapping on ICX-D

Bixuan Cui <cuibixuan@linux.alibaba.com>
    jbd2: use the correct print format

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl minconfig: Unset configs instead of just removing them

Steven Rostedt <rostedt@goodmis.org>
    kest.pl: Fix grub2 menu handling for rebooting

Manivannan Sadhasivam <mani@kernel.org>
    soc: qcom: Select REMAP_MMIO for ICC_BWMON driver

Manivannan Sadhasivam <mani@kernel.org>
    soc: qcom: Select REMAP_MMIO for LLCC driver

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    arm64: Prohibit instrumentation on arch_stack_walk()

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix UFS DMA coherency

Fan Ni <fan.ni@samsung.com>
    cxl/region: Fix memdev reuse check

Jason A. Donenfeld <Jason@zx2c4.com>
    media: stv0288: use explicitly signed char

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: skip mes self test after s0i3 resume for MES IP v11.0

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: skip MES for S0ix as well since it's part of GFX


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  27 +-
 Documentation/filesystems/mount_api.rst            |   1 +
 Makefile                                           |   4 +-
 arch/arm/nwfpe/Makefile                            |   6 +
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts       |   4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  10 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   5 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   6 +-
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts   |   6 +-
 arch/arm64/include/asm/efi.h                       |   3 +
 arch/arm64/kernel/efi-rt-wrapper.S                 |  13 +-
 arch/arm64/kernel/efi.c                            |  27 ++
 arch/arm64/kernel/stacktrace.c                     |  10 +-
 arch/parisc/include/asm/pgtable.h                  |   4 +-
 arch/parisc/kernel/firmware.c                      |  24 +-
 arch/parisc/kernel/kgdb.c                          |  20 --
 arch/parisc/kernel/pdc_cons.c                      |  16 +-
 arch/parisc/kernel/vdso32/Makefile                 |   4 +-
 arch/parisc/kernel/vdso64/Makefile                 |   4 +-
 arch/powerpc/include/asm/ftrace.h                  |  12 -
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/include/asm/kexec.h                     |   5 +
 arch/riscv/include/asm/mmu.h                       |   2 +
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/riscv/include/asm/tlbflush.h                  |  18 +
 arch/riscv/kernel/elf_kexec.c                      |  14 +
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/riscv/mm/context.c                            |  10 +
 arch/riscv/mm/tlbflush.c                           |  28 +-
 arch/um/drivers/virt-pci.c                         |   9 +-
 arch/x86/events/intel/uncore.h                     |   1 +
 arch/x86/events/intel/uncore_snbep.c               |  22 +-
 arch/x86/kernel/cpu/mce/amd.c                      |  33 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   8 +-
 arch/x86/kernel/fpu/xstate.c                       |  12 +-
 arch/x86/kernel/ftrace.c                           |   2 +
 arch/x86/kernel/kprobes/core.c                     |  10 +-
 arch/x86/kernel/kprobes/opt.c                      |  28 +-
 arch/x86/kvm/lapic.c                               |   5 +-
 arch/x86/kvm/vmx/nested.c                          |  47 ++-
 arch/x86/kvm/vmx/sgx.c                             |   4 +-
 arch/xtensa/kernel/xtensa_ksyms.c                  |   2 +
 arch/xtensa/lib/Makefile                           |   2 +-
 arch/xtensa/lib/umulsidi3.S                        | 230 +++++++++++++
 block/mq-deadline.c                                |  83 ++++-
 drivers/acpi/video_detect.c                        |  52 ++-
 drivers/ata/ahci.h                                 | 245 +++++++-------
 drivers/base/dd.c                                  |   6 +-
 drivers/bus/mhi/host/pm.c                          |   3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  27 +-
 drivers/char/random.c                              |  38 +++
 drivers/cpufreq/cpufreq.c                          |   2 +-
 drivers/crypto/Kconfig                             |   4 +-
 drivers/crypto/ccp/sp-pci.c                        |  11 +-
 drivers/crypto/hisilicon/Kconfig                   |   2 +-
 drivers/crypto/n2_core.c                           |   6 +
 drivers/cxl/core/region.c                          |   5 +-
 drivers/devfreq/devfreq.c                          |   6 +-
 drivers/devfreq/governor_userspace.c               |  12 +-
 drivers/edac/edac_mc_sysfs.c                       |  24 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   | 111 +++++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  19 +-
 drivers/gpu/drm/drm_connector.c                    |   3 +
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   7 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  23 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |   1 +
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  59 +++-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |  10 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c         |  18 +-
 drivers/gpu/drm/i915/gt/intel_migrate.c            |  16 +-
 drivers/gpu/drm/i915/i915_gem_evict.c              |  37 +-
 drivers/gpu/drm/i915/i915_gem_evict.h              |   4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |   2 +-
 drivers/gpu/drm/i915/selftests/i915_gem_evict.c    |   4 +-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |   6 +-
 drivers/gpu/drm/mgag200/mgag200_g200se.c           |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   3 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-input.c                            |   2 +
 drivers/iommu/amd/init.c                           |  86 +++--
 drivers/md/dm-cache-metadata.c                     |  54 ++-
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/md/dm-clone-target.c                       |   1 +
 drivers/md/dm-integrity.c                          |   2 +
 drivers/md/dm-thin-metadata.c                      |  60 +++-
 drivers/md/dm-thin.c                               |  18 +-
 drivers/md/md-bitmap.c                             |  20 +-
 drivers/media/dvb-core/dmxdev.c                    |   8 +
 drivers/media/dvb-core/dvbdev.c                    |   1 +
 drivers/media/dvb-frontends/stv0288.c              |   5 +-
 .../media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c  |   4 +-
 .../media/platform/samsung/s5p-mfc/s5p_mfc_enc.c   |  12 +-
 .../platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c      |  14 +-
 drivers/mmc/host/sdhci-sprd.c                      |  16 +-
 drivers/mtd/spi-nor/core.c                         |   2 +
 drivers/mtd/spi-nor/gigadevice.c                   |  24 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   2 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   1 +
 drivers/of/kexec.c                                 |  10 +-
 drivers/parisc/led.c                               |   3 +
 drivers/pci/doe.c                                  |  20 +-
 drivers/pci/pci-sysfs.c                            |  13 +-
 drivers/pci/pci.c                                  |   2 +
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |  47 ++-
 drivers/platform/x86/ideapad-laptop.c              | 371 ++++++++++++++++-----
 .../x86/intel/uncore-frequency/uncore-frequency.c  |   1 +
 drivers/platform/x86/thinkpad_acpi.c               |   1 +
 drivers/platform/x86/x86-android-tablets.c         | 285 +++++++++++++++-
 drivers/remoteproc/imx_dsp_rproc.c                 |  12 +-
 drivers/remoteproc/imx_rproc.c                     |   4 +-
 drivers/remoteproc/remoteproc_core.c               |   9 +-
 drivers/rtc/rtc-ds1347.c                           |   2 +-
 drivers/soc/qcom/Kconfig                           |   2 +
 drivers/soc/ux500/ux500-soc-id.c                   |  10 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  57 ++--
 drivers/staging/media/tegra-video/csi.c            |   4 +-
 drivers/staging/media/tegra-video/csi.h            |   2 +-
 fs/btrfs/backref.c                                 |   4 +
 fs/btrfs/extent-io-tree.c                          |   2 +-
 fs/btrfs/volumes.c                                 |   3 +-
 fs/cifs/cifsfs.c                                   |   8 +-
 fs/cifs/connect.c                                  |  16 +-
 fs/dlm/lowcomms.c                                  |   9 +-
 fs/ext2/dir.c                                      |   2 +-
 fs/ext4/ext4.h                                     |   9 +-
 fs/ext4/extents.c                                  |   8 +
 fs/ext4/extents_status.c                           |   3 +-
 fs/ext4/fast_commit.c                              | 171 +++++-----
 fs/ext4/fast_commit.h                              |   3 +-
 fs/ext4/indirect.c                                 |   9 +-
 fs/ext4/inode.c                                    |  48 ++-
 fs/ext4/ioctl.c                                    |  24 +-
 fs/ext4/namei.c                                    |  47 +--
 fs/ext4/orphan.c                                   |   2 +-
 fs/ext4/resize.c                                   |  32 +-
 fs/ext4/super.c                                    |  42 ++-
 fs/ext4/verity.c                                   |   2 +-
 fs/ext4/xattr.c                                    |  19 +-
 fs/fs_parser.c                                     |   3 +-
 fs/mbcache.c                                       |  14 +-
 fs/quota/dquot.c                                   |   2 +
 include/linux/bpf_verifier.h                       |   2 +-
 include/linux/devfreq.h                            |   7 +-
 include/linux/fs_parser.h                          |   1 +
 include/linux/mbcache.h                            |   9 +-
 include/linux/prandom.h                            |  18 +-
 include/linux/random.h                             |  65 ++++
 include/net/mptcp.h                                |  12 +-
 include/trace/events/ext4.h                        |   7 +-
 include/trace/events/jbd2.h                        |  44 +--
 kernel/bpf/core.c                                  |   5 +-
 kernel/events/core.c                               |   6 +-
 kernel/trace/Kconfig                               |   2 +
 kernel/trace/trace.c                               |  38 ++-
 kernel/trace/trace.h                               |  27 +-
 kernel/trace/trace_eprobe.c                        |   3 +
 kernel/trace/trace_events_hist.c                   |  11 +-
 kernel/trace/trace_events_synth.c                  |   2 +-
 kernel/trace/trace_probe.c                         |   2 +-
 lib/Kconfig.debug                                  |   1 +
 mm/hugetlb.c                                       | 333 ++++++++----------
 net/ipv4/syncookies.c                              |   7 +-
 net/mptcp/pm_userspace.c                           |   4 +
 net/mptcp/subflow.c                                |  61 +++-
 security/device_cgroup.c                           |  33 +-
 security/integrity/ima/Kconfig                     |   2 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/integrity/ima/ima_template.c              |   5 +-
 security/integrity/platform_certs/load_uefi.c      |   1 +
 sound/pci/hda/patch_cs8409.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |  50 +++
 sound/soc/jz4740/jz4740-i2s.c                      |  39 ++-
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |  16 +-
 sound/usb/endpoint.h                               |   3 +-
 sound/usb/implicit.c                               |   6 +-
 sound/usb/implicit.h                               |   2 +-
 sound/usb/pcm.c                                    |  36 +-
 sound/usb/pcm.h                                    |   2 +
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usbaudio.h                               |   4 +
 tools/testing/ktest/ktest.pl                       |  23 +-
 tools/testing/selftests/lib.mk                     |   5 +
 200 files changed, 3052 insertions(+), 1144 deletions(-)


