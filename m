Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D9E68D766
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjBGM7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjBGM7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5993928E;
        Tue,  7 Feb 2023 04:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068E5B8198C;
        Tue,  7 Feb 2023 12:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD046C433D2;
        Tue,  7 Feb 2023 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774763;
        bh=YrZR/oS2BL3nEnHzWBrKHyGvDgdU2VscFhwban9HATc=;
        h=From:To:Cc:Subject:Date:From;
        b=1OkqrPtCpmGG7/b/MfasGewN2Pjvt7KJgIILXkHTn2dEB0hLf6UimyCMvxHIOn0WJ
         5LTeH+uZn+pOHfcqGhAlMu51lZp1hGpKFNjXUKQO7FWmdsx7xpfQ60GhVOAjdIemAA
         V0hm+rVt31pNugALVH5AAd+gTZXRsb1zgVbfZWt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/208] 6.1.11-rc1 review
Date:   Tue,  7 Feb 2023 13:54:14 +0100
Message-Id: <20230207125634.292109991@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.11-rc1
X-KernelTest-Deadline: 2023-02-09T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.11 release.
There are 208 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.11-rc1

Hao Sun <sunhao.th@gmail.com>
    bpf: Skip invalid kfunc call in backtrack_insn

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Always check inode size of inline inodes

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Cosmetic gfs2_dinode_{in,out} cleanup

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_extra_isize in is_alive()

Dongliang Mu <dzm91@hust.edu.cn>
    fbdev: smscufx: fix error handling code in ufx_usb_probe

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    f2fs: initialize locks earlier in f2fs_fill_super()

Kees Cook <keescook@chromium.org>
    ovl: Use "buf" flexible array for memcpy() destination

Abdun Nihaal <abdun.nihaal@gmail.com>
    fs/ntfs3: Validate attribute data and valid sizes

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix local irq disable when PMIs are disabled

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/radix: Fix crash with unaligned relocated kernel

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurement of VAC

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: sof-audio: prepare_widgets: Check swidget for NULL on sink failure

Arnd Bergmann <arnd@arndb.de>
    platform/x86/amd: pmc: add CONFIG_SERIO dependency

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx rearm race

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx completion race

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix runtime suspend

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix return value

Michael Walle <michael@walle.cc>
    nvmem: core: fix cell removal on error

Michael Walle <michael@walle.cc>
    nvmem: core: fix device node refcounting

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix registration vs use race

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix cleanup after dev_set_name()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: remove nvmem_config wp_gpio

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: initialise nvmem->id early

Graham Sider <Graham.Sider@amd.com>
    drm/amdgpu: update wave data type to 3 for gfx11

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: drop unneeded dpm features disablement for SMU 13.0.4/11

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix initialization for nbio 4.3.0

Rob Clark <robdclark@chromium.org>
    drm/i915: Fix potential bit_17 double-free

Rob Clark <robdclark@chromium.org>
    drm/i915: Avoid potential vm use-after-free

Marek Vasut <marex@denx.de>
    serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler

Danilo Krummrich <dakr@redhat.com>
    dma-buf: actually set signaling bit for private stub fences

Mike Kravetz <mike.kravetz@oracle.com>
    migrate: hugetlb: check for hugetlb shared PMD in node migration

Liam Howlett <liam.howlett@oracle.com>
    maple_tree: fix mas_empty_area_rev() lower bound validation

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix handling and sanity checking of xattr_ids count

James Morse <james.morse@arm.com>
    ia64: fix build error due to switch case label appearing next to declaration

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: round down the address passed to kunmap_flush_on_unmap()

Zach O'Keefe <zokeefe@google.com>
    mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups

Vlastimil Babka <vbabka@suse.cz>
    mm, mremap: fix mremap() expanding for vma's with vm_ops->close()

Jann Horn <jannh@google.com>
    mm/khugepaged: fix ->anon_vma race

Longlong Xia <xialonglong1@huawei.com>
    mm/swapfile: add cond_resched() in get_swap_pages()

Peter Xu <peterx@redhat.com>
    mm/uffd: fix pte marker when fork() without fork event

Zheng Yongjun <zhengyongjun3@huawei.com>
    fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    fpga: m10bmc-sec: Fix probe rollback

Joerg Roedel <jroedel@suse.de>
    x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HV: hv_balloon: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/irq/irqdomain.c: fix memory leak with using debugfs_lookup()

Aaro Koskinen <aaro.koskinen@iki.fi>
    usb: gadget: udc: do not clear gadget driver.bus

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Don't attempt to resume the ports before they exist

Pratham Pratap <quic_ppratap@quicinc.com>
    usb: gadget: f_uac2: Fix incorrect increment of bNumEndpoints

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()

Mike Kravetz <mike.kravetz@oracle.com>
    mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps

Yu Zhao <yuzhao@google.com>
    mm: multi-gen LRU: fix crash during cgroup migration

Isaac J. Manjarres <isaacmanjarres@google.com>
    Revert "mm: kmemleak: alloc gray object for reserved region with direct map"

Andreas Schwab <schwab@suse.de>
    riscv: disable generation of unwind tables

Helge Deller <deller@gmx.de>
    parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Helge Deller <deller@gmx.de>
    parisc: Replace hardcoded value with PRIV_USER constant in ptrace.c

Helge Deller <deller@gmx.de>
    parisc: Fix return code of pdc_iodc_print()

Johan Hovold <johan+linaro@kernel.org>
    nvmem: qcom-spmi-sdam: fix module autoloading

Samuel Holland <samuel@sholland.org>
    nvmem: sunxi_sid: Always use 32-bit MMIO reads

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    nvmem: brcm_nvram: Add check for kzalloc

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix MAGN sensor scale and unit

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix failed initialization ODR mode assignment

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix incorrect ODR mode readback

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix swapped ACCEL and MAGN channels readback

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix map label of channel type to MAGN sensor

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix IMU data bits returned to user space

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback

Carlos Song <carlos.song@nxp.com>
    iio: imu: fxos8700: fix ACCEL measurement range selection

Kai-Heng Feng <kai.heng.feng@canonical.com>
    iio: light: cm32181: Fix PM support on system with 2 I2C resources

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Frank Li <Frank.Li@nxp.com>
    iio: imx8qxp-adc: fix irq flood when call imx8qxp_adc_read_raw()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iio: adc: berlin2-adc: Add missing of_node_put() in error path

Marco Pagani <marpagan@redhat.com>
    iio: adc: xilinx-ams: fix devm_krealloc() return value check

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in gyro_3d_capture_sample

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in accel_3d_capture_sample

Shanker Donthineni <sdonthineni@nvidia.com>
    rtc: efi: Enable SET/GET WAKEUP services as optional

Ard Biesheuvel <ardb@kernel.org>
    efi: Accept version 2 of memory attributes table

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: keep prepare/unprepare widgets in sink path

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: sof-audio: skip prepare/unprepare if swidget is NULL

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: correct playback min/max rates

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs, speaker don't work for a HP platform

Victor Shyba <victor1984@riseup.net>
    ALSA: hda/realtek: Add Acer Predator PH315-54

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: do not use stack buffers for hardware data

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: handle wait_event_interruptible() return values

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: split tx timer into transmission and timeout

Natalia Petrova <n.petrova@fintech.ru>
    net: qrtr: free memory on error path in radix_tree_insert()

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx7d-smegw01: Fix USB host over-current polarity

Michael Kelley <mikelley@microsoft.com>
    hv_netvsc: Fix missed pagebuf entries in netvsc_dma_map/unmap()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix wrong check in update_parent_subparts_cpumask()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    fbcon: Check font dimension limits

George Kennedy <george.kennedy@oracle.com>
    vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Neil Armstrong <neil.armstrong@linaro.org>
    usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-dfsdm: fill module aliases

Kees Cook <keescook@chromium.org>
    bcache: Silence memcpy() run-time false positive warnings

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix timing not changning when freesync video is enabled

Hyunwoo Kim <v4bel@theori.io>
    net/x25: Fix to not accept on connected socket

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN

Kevin Kuriakose <kevinmkuriakose@gmail.com>
    platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF

Rishit Bansal <rishitbansal0@gmail.com>
    platform/x86: hp-wmi: Handle Omen Key event

Koba Ko <koba.ko@canonical.com>
    platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table

Nathan Chancellor <nathan@kernel.org>
    x86/build: Move '-mindirect-branch-cs-prefix' out of GCC-only block

Andreas Gruenbacher <agruenba@redhat.com>
    Revert "gfs2: stop using generic_writepages in gfs2_ail1_start_one"

Randy Dunlap <rdunlap@infradead.org>
    i2c: rk3x: fix a bunch of kernel-doc warnings

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/cstate: Add Emerald Rapids

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Emerald Rapids

Yair Podemsky <ypodemsk@redhat.com>
    x86/aperfmperf: Erase stale arch_freq_scale values when disabling frequency invariance readings

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on RT kernels

Stefan Wahren <stefan.wahren@i2se.com>
    i2c: mxs: suppress probe-deferral error message

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU

Jan Luebbe <jlu@pengutronix.de>
    kbuild: modinst: Fix build error when CONFIG_MODULE_SIG_KEY is a PKCS#11 URI

Jan Luebbe <jlu@pengutronix.de>
    certs: Fix build error when PKCS#11 URI contains semicolon

Arnd Bergmann <arnd@arndb.de>
    rtc: sunplus: fix format string for printing resource

Anton Gusev <aagusev@ispras.ru>
    efi: fix potential NULL deref in efi_mem_reserve_persistent

Fedor Pchelkin <pchelkin@ispras.ru>
    net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Parav Pandit <parav@nvidia.com>
    virtio-net: Keep stop() to follow mirror sequence of open()

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided

Andrei Gherzan <andrei.gherzan@canonical.com>
    selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw: fix CAN FD frame transmissions over CAN XL devices

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix devlink unregister

Tom Rix <trix@redhat.com>
    igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()

Guo Ren <guoren@kernel.org>
    riscv: kprobe: Fixup kernel panic when probing an illegal position

Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
    ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address

Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
    ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address

Stephen Boyd <swboyd@chromium.org>
    drm/panel: boe-tv101wum-nl6: Ensure DSI writes succeed during disable

Chris Healy <healych@amazon.com>
    net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Xin Long <lucien.xin@gmail.com>
    sctp: do not check hb_timer.expires when resetting hb_timer

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: should get pivots boundary by type

Fedor Pchelkin <pchelkin@ispras.ru>
    squashfs: harden sanity check in squashfs_read_xattr_id_table

Brendan Higgins <brendan.higgins@linux.dev>
    kunit: fix kunit_test_init_section_suites(...)

Liu Xiaodong <xiaodong.liu@intel.com>
    block: ublk: extending queue_size to fix overflow

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: disable sabotage_in hook after first suppression

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: fix unreleased lock warning in hwdep device

Pietro Borrello <borrello@diag.uniroma1.it>
    net/tls: tls_is_tx_ready() checked list_entry

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/adlp: Fix typo for reference clock

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Fix up locking around dumping requests lists

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Fix request ref counting during error capture & debugfs dump

John Harrison <John.C.Harrison@Intel.com>
    drm/i915/guc: Fix locking when searching for a hung request

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Fix thinklight LED brightness returning 255

Hans de Goede <hdegoede@redhat.com>
    platform/x86/amd/pmf: Ensure mutexes are initialized before use

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Fix to update SPS thermals when power supply change

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Add helper routine to check pprof is balanced

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Fix to update SPS default pprof thermals

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Add helper routine to update SPS thermals

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: update to auto-mode limits only after AMT event

Hou Tao <houtao1@huawei.com>
    fscache: Use wait_on_bit() to wait for the freeing of relinquished volume

Hyunwoo Kim <v4bel@theori.io>
    netrom: Fix use-after-free caused by accept on already connected socket

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bic_set_bfqq()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: replace 0/1 with false/true in bic apis

Kornel Dulęba <mindal@semihalf.com>
    net: wwan: t7xx: Fix Runtime PM initialization

Andre Kalb <andre.kalb@sma.de>
    net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Íñigo Huguet <ihuguet@redhat.com>
    sfc: correctly advertise tunneled IPv6 segmentation

Alexander Duyck <alexanderduyck@fb.com>
    skb: Do mix page pool and page referenced frags in GRO

Magnus Karlsson <magnus.karlsson@intel.com>
    dpaa2-eth: execute xdp_do_flush() before napi_complete_done()

Magnus Karlsson <magnus.karlsson@intel.com>
    dpaa_eth: execute xdp_do_flush() before napi_complete_done()

Magnus Karlsson <magnus.karlsson@intel.com>
    virtio-net: execute xdp_do_flush() before napi_complete_done()

Magnus Karlsson <magnus.karlsson@intel.com>
    qede: execute xdp_do_flush() before napi_complete_done()

Dave Ertman <david.m.ertman@intel.com>
    ice: Prevent set_channel from changing queues while RDMA active

Jason Wang <jasowang@redhat.com>
    vhost-scsi: unbreak any layout for response

Al Viro <viro@zeniv.linux.org.uk>
    use less confusing names for iov_iter direction initializers

Al Viro <viro@zeniv.linux.org.uk>
    fix "direction" argument of iov_iter_kvec()

Al Viro <viro@zeniv.linux.org.uk>
    fix 'direction' argument of iov_iter_{init,bvec}()

Al Viro <viro@zeniv.linux.org.uk>
    fix iov_iter_bvec() "direction" argument

Al Viro <viro@zeniv.linux.org.uk>
    memcpy_real(): WRITE is "data source", not destination...

Al Viro <viro@zeniv.linux.org.uk>
    zcore: WRITE is "data source", not destination...

Al Viro <viro@zeniv.linux.org.uk>
    READ is "data destination", not source...

Al Viro <viro@zeniv.linux.org.uk>
    WRITE is "data source", not destination...

Al Viro <viro@zeniv.linux.org.uk>
    copy_oldmem_kernel() - WRITE is "data source", not destination

Eric Auger <eric.auger@redhat.com>
    vhost/net: Clear the pending messages when the backend is removed

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Workaround for Xen PV

Kui-Feng Lee <kuifeng@meta.com>
    bpf: Fix the kernel crash caused by bpf_setsockopt().

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Javier Martinez Canillas <javierm@redhat.com>
    drm/ssd130x: Init display before the SSD130X_DISPLAY_ON command

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    drm/vc4: hdmi: make CEC adapter name unique

Philippe Schenker <philippe.schenker@toradex.com>
    arm64: dts: imx8mm-verdin: Do not power down eth-phy

Pierluigi Passaro <pierluigi.p@variscite.com>
    arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls-api.c: move ctrl->is_new = 1 to the correct line

Jiri Olsa <jolsa@kernel.org>
    bpf: Add missing btf_put to register_btf_id_dtor_kfuncs

Dan Carpenter <error27@gmail.com>
    ASoC: SOF: ipc4-mtrace: prevent underflow in sof_ipc4_priority_mask_dfs_write()

Pengfei Xu <pengfei.xu@intel.com>
    selftests/filesystems: grant executable permission to run_fat_tests.sh

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix to preserve reg parent/live fields when copying range info

Artemii Karasev <karasev@ispras.ru>
    ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Yonghong Song <yhs@fb.com>
    bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Hou Tao <houtao1@huawei.com>
    bpf: Fix off-by-one error in bpf_mem_cache_idx()

Peter Xu <peterx@redhat.com>
    selftests/vm: remove __USE_GNU in hugetlb-madvise.c

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Implement PCI shutdown

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: sof_es8336: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_wm5102: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_rt5640: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcht_es8316: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: amd: acp-es8336: Drop reference count of ACPI device after use

Frank Li <Frank.Li@nxp.com>
    arm64: dts: freescale: imx8dxl: fix sc_pwrkey's property name linux,keycode

Fabio Estevam <festevam@denx.de>
    arm64: dts: imx8m-venice: Remove incorrect 'uart-has-rtscts'

Yuan Can <yuancan@huawei.com>
    bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx7d-smegw01.dts                |   3 +-
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi         |   2 +-
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |   2 +-
 .../imx8mm-venice-gw72xx-0x-rs232-rts.dts          |   1 -
 .../imx8mm-venice-gw73xx-0x-rs232-rts.dts          |   1 -
 .../boot/dts/freescale/imx8mm-venice-gw73xx.dtsi   |   1 -
 .../boot/dts/freescale/imx8mm-venice-gw7901.dts    |   3 -
 .../boot/dts/freescale/imx8mm-venice-gw7902.dts    |   3 -
 .../boot/dts/freescale/imx8mm-venice-gw7903.dts    |   1 -
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   1 +
 .../boot/dts/freescale/imx8mn-venice-gw7902.dts    |   1 -
 .../boot/dts/freescale/imx8mp-venice-gw74xx.dts    |   1 -
 arch/ia64/kernel/sys_ia64.c                        |   7 +-
 arch/parisc/kernel/firmware.c                      |   5 +-
 arch/parisc/kernel/ptrace.c                        |  21 +++-
 arch/powerpc/include/asm/hw_irq.h                  |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  11 ++
 arch/powerpc/perf/imc-pmu.c                        |  14 +--
 arch/riscv/Makefile                                |   3 +
 arch/riscv/kernel/probes/kprobes.c                 |  18 ++++
 arch/s390/kernel/crash_dump.c                      |   2 +-
 arch/s390/mm/maccess.c                             |   2 +-
 arch/x86/Makefile                                  |   2 +-
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/events/intel/cstate.c                     |   1 +
 arch/x86/include/asm/debugreg.h                    |  26 ++++-
 arch/x86/kernel/cpu/aperfmperf.c                   |   9 ++
 arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
 arch/x86/kernel/crash_dump_64.c                    |   2 +-
 block/bfq-cgroup.c                                 |   8 +-
 block/bfq-iosched.c                                |   8 +-
 certs/Makefile                                     |   4 +-
 crypto/testmgr.c                                   |   4 +-
 drivers/acpi/pfr_update.c                          |   2 +-
 drivers/ata/libata-core.c                          |   2 +-
 drivers/block/drbd/drbd_main.c                     |   2 +-
 drivers/block/drbd/drbd_receiver.c                 |   2 +-
 drivers/block/loop.c                               |  12 +--
 drivers/block/nbd.c                                |  10 +-
 drivers/block/ublk_drv.c                           |   2 +-
 drivers/bus/sunxi-rsb.c                            |   8 +-
 drivers/char/random.c                              |   4 +-
 drivers/dma-buf/dma-fence.c                        |   2 +-
 drivers/firewire/core-cdev.c                       |   4 +-
 drivers/firmware/efi/efi.c                         |   2 +
 drivers/firmware/efi/memattr.c                     |   2 +-
 drivers/fpga/intel-m10-bmc-sec-update.c            |  17 +++-
 drivers/fpga/stratix10-soc.c                       |   4 +-
 drivers/fsi/fsi-sbefifo.c                          |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c             |   8 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 ++
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  14 +++
 drivers/gpu/drm/i915/display/intel_cdclk.c         |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  14 ++-
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c         |   9 +-
 drivers/gpu/drm/i915/gt/intel_context.c            |   4 +-
 drivers/gpu/drm/i915/gt/intel_context.h            |   3 +-
 drivers/gpu/drm/i915/gt/intel_engine.h             |   4 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |  74 +++++++-------
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  27 +++++
 .../gpu/drm/i915/gt/intel_execlists_submission.h   |   4 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  14 ++-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  33 ++----
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |  16 ++-
 drivers/gpu/drm/solomon/ssd130x.c                  |  18 ++--
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   3 +-
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   2 +
 drivers/i2c/busses/i2c-mxs.c                       |   4 +-
 drivers/i2c/busses/i2c-rk3x.c                      |  44 ++++----
 drivers/iio/accel/hid-sensor-accel-3d.c            |   1 +
 drivers/iio/adc/berlin2-adc.c                      |   4 +-
 drivers/iio/adc/imx8qxp-adc.c                      |  11 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   1 +
 drivers/iio/adc/twl6030-gpadc.c                    |  32 ++++++
 drivers/iio/adc/xilinx-ams.c                       |   2 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   1 +
 drivers/iio/imu/fxos8700_core.c                    | 111 +++++++++++++++++----
 drivers/iio/light/cm32181.c                        |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   2 +-
 drivers/isdn/mISDN/l1oip_core.c                    |   2 +-
 drivers/md/bcache/bcache_ondisk.h                  |   3 +-
 drivers/md/bcache/journal.c                        |   3 +-
 drivers/media/v4l2-core/v4l2-ctrls-api.c           |   2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c  |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   9 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |  23 +++--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h       |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  28 +++++-
 drivers/net/ethernet/intel/ice/ice_main.c          |   5 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  14 ++-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  35 +++++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +-
 drivers/net/ethernet/sfc/efx.c                     |   5 +-
 drivers/net/hyperv/netvsc.c                        |   9 +-
 drivers/net/phy/dp83822.c                          |   6 +-
 drivers/net/phy/meson-gxl.c                        |   2 +
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/net/virtio_net.c                           |   8 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  17 ++++
 drivers/net/wwan/t7xx/t7xx_pci.c                   |   2 +
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/io-cmd-file.c                  |   4 +-
 drivers/nvme/target/tcp.c                          |   2 +-
 drivers/nvmem/brcm_nvram.c                         |   3 +
 drivers/nvmem/core.c                               |  60 +++++------
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/nvmem/sunxi_sid.c                          |  15 ++-
 drivers/of/fdt.c                                   |   6 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |  12 +--
 drivers/platform/x86/amd/Kconfig                   |   1 +
 drivers/platform/x86/amd/pmc.c                     |  50 ++++++++++
 drivers/platform/x86/amd/pmf/auto-mode.c           |   9 +-
 drivers/platform/x86/amd/pmf/cnqf.c                |  14 +--
 drivers/platform/x86/amd/pmf/core.c                |  32 +++++-
 drivers/platform/x86/amd/pmf/pmf.h                 |   3 +
 drivers/platform/x86/amd/pmf/sps.c                 |  28 ++++--
 drivers/platform/x86/dell/dell-wmi-base.c          |   3 +
 drivers/platform/x86/gigabyte-wmi.c                |   1 +
 drivers/platform/x86/hp-wmi.c                      |   4 +
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/rtc/rtc-efi.c                              |  48 +++++----
 drivers/rtc/rtc-sunplus.c                          |   4 +-
 drivers/s390/char/zcore.c                          |   2 +-
 drivers/scsi/iscsi_tcp.c                           |  20 +++-
 drivers/scsi/libiscsi.c                            |  38 +++++--
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/scsi/sg.c                                  |   2 +-
 drivers/target/iscsi/iscsi_target_util.c           |   4 +-
 drivers/target/target_core_file.c                  |   4 +-
 drivers/target/target_core_tmr.c                   |   4 +-
 drivers/tty/serial/8250/8250_dma.c                 |  26 ++++-
 drivers/tty/serial/stm32-usart.c                   |  33 +-----
 drivers/tty/vt/vc_screen.c                         |   9 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +-
 drivers/usb/gadget/function/f_uac2.c               |   1 +
 drivers/usb/gadget/udc/bcm63xx_udc.c               |   1 -
 drivers/usb/gadget/udc/fotg210-udc.c               |   1 -
 drivers/usb/gadget/udc/fsl_qe_udc.c                |   1 -
 drivers/usb/gadget/udc/fsl_udc_core.c              |   1 -
 drivers/usb/gadget/udc/fusb300_udc.c               |   1 -
 drivers/usb/gadget/udc/goku_udc.c                  |   1 -
 drivers/usb/gadget/udc/gr_udc.c                    |   1 -
 drivers/usb/gadget/udc/m66592-udc.c                |   1 -
 drivers/usb/gadget/udc/max3420_udc.c               |   1 -
 drivers/usb/gadget/udc/mv_u3d_core.c               |   1 -
 drivers/usb/gadget/udc/mv_udc_core.c               |   1 -
 drivers/usb/gadget/udc/net2272.c                   |   1 -
 drivers/usb/gadget/udc/net2280.c                   |   1 -
 drivers/usb/gadget/udc/omap_udc.c                  |   1 -
 drivers/usb/gadget/udc/pch_udc.c                   |   1 -
 drivers/usb/gadget/udc/snps_udc_core.c             |   1 -
 drivers/usb/typec/ucsi/ucsi.c                      |   9 +-
 drivers/usb/usbip/usbip_common.c                   |   2 +-
 drivers/vhost/net.c                                |   9 +-
 drivers/vhost/scsi.c                               |  29 ++++--
 drivers/vhost/vhost.c                              |   9 +-
 drivers/vhost/vhost.h                              |   1 +
 drivers/vhost/vringh.c                             |   4 +-
 drivers/vhost/vsock.c                              |   4 +-
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 drivers/video/fbdev/smscufx.c                      |  46 ++++++---
 drivers/watchdog/diag288_wdt.c                     |  15 ++-
 drivers/xen/pvcalls-back.c                         |   8 +-
 fs/9p/vfs_addr.c                                   |   4 +-
 fs/9p/vfs_dir.c                                    |   2 +-
 fs/9p/xattr.c                                      |   4 +-
 fs/afs/cmservice.c                                 |   2 +-
 fs/afs/dir.c                                       |   2 +-
 fs/afs/file.c                                      |   4 +-
 fs/afs/internal.h                                  |   4 +-
 fs/afs/rxrpc.c                                     |  10 +-
 fs/afs/write.c                                     |   4 +-
 fs/aio.c                                           |   4 +-
 fs/btrfs/ioctl.c                                   |   4 +-
 fs/ceph/addr.c                                     |   4 +-
 fs/ceph/file.c                                     |   4 +-
 fs/cifs/connect.c                                  |   6 +-
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/fscache.c                                  |   4 +-
 fs/cifs/smb2ops.c                                  |   4 +-
 fs/cifs/transport.c                                |   6 +-
 fs/coredump.c                                      |   2 +-
 fs/erofs/fscache.c                                 |   6 +-
 fs/f2fs/gc.c                                       |  18 ++--
 fs/f2fs/super.c                                    |  38 +++----
 fs/fscache/io.c                                    |   2 +-
 fs/fscache/volume.c                                |  11 +-
 fs/fuse/ioctl.c                                    |   4 +-
 fs/gfs2/aops.c                                     |   2 -
 fs/gfs2/bmap.c                                     |   3 -
 fs/gfs2/glops.c                                    |  44 ++++----
 fs/gfs2/log.c                                      |  11 +-
 fs/gfs2/super.c                                    |  27 ++---
 fs/netfs/io.c                                      |   6 +-
 fs/nfs/fscache.c                                   |   4 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/ntfs3/inode.c                                   |   7 ++
 fs/ocfs2/cluster/tcp.c                             |   2 +-
 fs/orangefs/inode.c                                |   8 +-
 fs/overlayfs/export.c                              |   2 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/proc/task_mmu.c                                 |   4 +-
 fs/proc/vmcore.c                                   |   6 +-
 fs/read_write.c                                    |  12 +--
 fs/seq_file.c                                      |   2 +-
 fs/splice.c                                        |  10 +-
 fs/squashfs/squashfs_fs.h                          |   2 +-
 fs/squashfs/squashfs_fs_sb.h                       |   2 +-
 fs/squashfs/xattr.h                                |   4 +-
 fs/squashfs/xattr_id.c                             |   4 +-
 include/kunit/test.h                               |   1 -
 include/linux/efi.h                                |   3 +-
 include/linux/highmem-internal.h                   |   4 +-
 include/linux/hugetlb.h                            |  13 +++
 include/linux/memcontrol.h                         |   5 +-
 include/linux/nvmem-provider.h                     |   2 -
 include/linux/uio.h                                |   3 +
 include/linux/util_macros.h                        |  12 +++
 include/scsi/libiscsi.h                            |   2 +
 io_uring/net.c                                     |  14 +--
 io_uring/rw.c                                      |  10 +-
 kernel/bpf/bpf_lsm.c                               |   1 -
 kernel/bpf/btf.c                                   |   4 +-
 kernel/bpf/memalloc.c                              |   2 +-
 kernel/bpf/verifier.c                              |  31 ++++--
 kernel/cgroup/cpuset.c                             |   3 +-
 kernel/irq/irqdomain.c                             |   2 +-
 kernel/trace/bpf_trace.c                           |   3 +-
 kernel/trace/trace_events_user.c                   |   2 +-
 lib/maple_tree.c                                   |  22 ++--
 lib/test_maple_tree.c                              |  89 +++++++++++++++++
 mm/khugepaged.c                                    |  22 +++-
 mm/madvise.c                                       |   2 +-
 mm/memory.c                                        |   8 +-
 mm/mempolicy.c                                     |   3 +-
 mm/mremap.c                                        |  25 +++--
 mm/page_io.c                                       |   4 +-
 mm/process_vm_access.c                             |   2 +-
 mm/swapfile.c                                      |   1 +
 mm/vmscan.c                                        |   5 +-
 net/9p/client.c                                    |   2 +-
 net/bluetooth/6lowpan.c                            |   2 +-
 net/bluetooth/a2mp.c                               |   2 +-
 net/bluetooth/smp.c                                |   2 +-
 net/bridge/br_netfilter_hooks.c                    |   1 +
 net/can/isotp.c                                    |  69 ++++++-------
 net/can/j1939/transport.c                          |   4 -
 net/can/raw.c                                      |  47 ++++++---
 net/ceph/messenger_v1.c                            |   4 +-
 net/ceph/messenger_v2.c                            |  14 +--
 net/compat.c                                       |   3 +-
 net/core/gro.c                                     |   9 ++
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/ipv6/addrconf.c                                |  59 ++++++-----
 net/netfilter/ipvs/ip_vs_sync.c                    |   2 +-
 net/netrom/af_netrom.c                             |   5 +
 net/openvswitch/datapath.c                         |  12 +--
 net/qrtr/ns.c                                      |   5 +-
 net/sctp/transport.c                               |   4 +-
 net/smc/smc_clc.c                                  |   6 +-
 net/smc/smc_tx.c                                   |   2 +-
 net/socket.c                                       |  12 +--
 net/sunrpc/socklib.c                               |   6 +-
 net/sunrpc/svcsock.c                               |   4 +-
 net/sunrpc/xprtsock.c                              |   6 +-
 net/tipc/topsrv.c                                  |   2 +-
 net/tls/tls_device.c                               |   4 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/x25/af_x25.c                                   |   6 ++
 net/xfrm/espintcp.c                                |   2 +-
 scripts/Makefile.modinst                           |   6 +-
 security/keys/keyctl.c                             |   4 +-
 sound/core/memalloc.c                              |  87 ++++++++++++----
 sound/firewire/motu/motu-hwdep.c                   |   4 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/pci/hda/patch_via.c                          |   3 +
 sound/soc/amd/acp-es8336.c                         |   6 +-
 sound/soc/codecs/wsa883x.c                         |   4 +-
 sound/soc/intel/avs/core.c                         |  24 +++++
 sound/soc/intel/boards/bytcht_es8316.c             |  20 ++--
 sound/soc/intel/boards/bytcr_rt5640.c              |  12 +--
 sound/soc/intel/boards/bytcr_rt5651.c              |   2 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |   2 +-
 sound/soc/intel/boards/sof_es8336.c                |  14 +--
 sound/soc/sof/ipc4-mtrace.c                        |   7 +-
 sound/soc/sof/sof-audio.c                          |  12 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |   1 +
 .../selftests/filesystems/fat/run_fat_tests.sh     |   0
 tools/testing/selftests/net/udpgso_bench.sh        |  24 ++++-
 tools/testing/selftests/net/udpgso_bench_rx.c      |   4 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |  36 +++++--
 tools/testing/selftests/vm/hugetlb-madvise.c       |   1 -
 300 files changed, 1829 insertions(+), 940 deletions(-)


