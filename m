Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4641268D883
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjBGNKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjBGNKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:10:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2930D3A587;
        Tue,  7 Feb 2023 05:09:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E63C4B818E8;
        Tue,  7 Feb 2023 13:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F58C433EF;
        Tue,  7 Feb 2023 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775364;
        bh=hF6sQ+CMOK9R3NODNu4d2hN3fCqVY/+wGj292Q+hzx4=;
        h=From:To:Cc:Subject:Date:From;
        b=xGSi4bNBO3W+fsim+OWQZWQB2W9O8b3HtYTiLfX7txCQwl1Z+sVRvMFwXGJZjxx3A
         zAYMi/aoTfn0fQmfOvMRB3nPqJ8GuZA6u2nS2Bm3xDM+DBL7AfzxPzqlw2ttH6UacR
         73k0frkKJK6tM6Y8XNjbwhkHLPZQGEUL8/k7yQLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/120] 5.15.93-rc1 review
Date:   Tue,  7 Feb 2023 13:56:11 +0100
Message-Id: <20230207125618.699726054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.93-rc1
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

This is the start of the stable review cycle for the 5.15.93 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.93-rc1

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

Kees Cook <keescook@chromium.org>
    ovl: Use "buf" flexible array for memcpy() destination

Abdun Nihaal <abdun.nihaal@gmail.com>
    fs/ntfs3: Validate attribute data and valid sizes

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurement of VAC

Martin KaFai Lau <kafai@fb.com>
    bpf: Do not reject when the stack read size is different from the tracked scalar size

Paul Chaignon <paul@isovalent.com>
    bpf: Fix incorrect state pruning for <8B spill/fill

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix runtime suspend

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix broken power on

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-usb: fix memleak on probe deferral

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: fix memleak on probe deferral

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp-combo: disable runtime PM on unbind

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx rearm race

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx completion race

Michael Walle <michael@walle.cc>
    nvmem: core: fix cell removal on error

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: remove nvmem_config wp_gpio

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: initialise nvmem->id early

Rob Clark <robdclark@chromium.org>
    drm/i915: Fix potential bit_17 double-free

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix handling and sanity checking of xattr_ids count

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: round down the address passed to kunmap_flush_on_unmap()

Longlong Xia <xialonglong1@huawei.com>
    mm/swapfile: add cond_resched() in get_swap_pages()

Zheng Yongjun <zhengyongjun3@huawei.com>
    fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Joerg Roedel <jroedel@suse.de>
    x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kernel/irq/irqdomain.c: fix memory leak with using debugfs_lookup()

Pratham Pratap <quic_ppratap@quicinc.com>
    usb: gadget: f_uac2: Fix incorrect increment of bNumEndpoints

Mike Kravetz <mike.kravetz@oracle.com>
    mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps

Andreas Schwab <schwab@suse.de>
    riscv: disable generation of unwind tables

Helge Deller <deller@gmx.de>
    parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Helge Deller <deller@gmx.de>
    parisc: Fix return code of pdc_iodc_print()

Johan Hovold <johan+linaro@kernel.org>
    nvmem: qcom-spmi-sdam: fix module autoloading

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

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iio: adc: berlin2-adc: Add missing of_node_put() in error path

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in gyro_3d_capture_sample

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in accel_3d_capture_sample

Ard Biesheuvel <ardb@kernel.org>
    efi: Accept version 2 of memory attributes table

Victor Shyba <victor1984@riseup.net>
    ALSA: hda/realtek: Add Acer Predator PH315-54

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: do not use stack buffers for hardware data

Natalia Petrova <n.petrova@fintech.ru>
    net: qrtr: free memory on error path in radix_tree_insert()

Samuel Thibault <samuel.thibault@ens-lyon.org>
    fbcon: Check font dimension limits

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add Clevo PCX0DX to i8042 quirk table

George Kennedy <george.kennedy@oracle.com>
    vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Neil Armstrong <neil.armstrong@linaro.org>
    usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-dfsdm: fill module aliases

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Fix timing not changning when freesync video is enabled

Hyunwoo Kim <v4bel@theori.io>
    net/x25: Fix to not accept on connected socket

Kevin Kuriakose <kevinmkuriakose@gmail.com>
    platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF

Koba Ko <koba.ko@canonical.com>
    platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table

Randy Dunlap <rdunlap@infradead.org>
    i2c: rk3x: fix a bunch of kernel-doc warnings

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during logout when accessing the shost ipaddress

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Add Emerald Rapids

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on RT kernels

Stefan Wahren <stefan.wahren@i2se.com>
    i2c: mxs: suppress probe-deferral error message

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    i2c: designware-pci: Add new PCI IDs for AMD NAVI GPU

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

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

Tom Rix <trix@redhat.com>
    igc: return an error if the mac type is unknown in igc_ptp_systim_to_hwtstamp()

Guo Ren <guoren@linux.alibaba.com>
    riscv: kprobe: Fixup kernel panic when probing an illegal position

Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
    ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address

Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
    ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address

Chris Healy <healych@amazon.com>
    net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Fedor Pchelkin <pchelkin@ispras.ru>
    squashfs: harden sanity check in squashfs_read_xattr_id_table

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: disable sabotage_in hook after first suppression

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/adlp: Fix typo for reference clock

John Harrison <John.C.Harrison@Intel.com>
    drm/i915/guc: Fix locking when searching for a hung request

Hyunwoo Kim <v4bel@theori.io>
    netrom: Fix use-after-free caused by accept on already connected socket

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bic_set_bfqq()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: replace 0/1 with false/true in bic apis

NeilBrown <neilb@suse.de>
    block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

Andre Kalb <andre.kalb@sma.de>
    net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Íñigo Huguet <ihuguet@redhat.com>
    sfc: correctly advertise tunneled IPv6 segmentation

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

Al Viro <viro@zeniv.linux.org.uk>
    fix "direction" argument of iov_iter_kvec()

Al Viro <viro@zeniv.linux.org.uk>
    fix iov_iter_bvec() "direction" argument

Al Viro <viro@zeniv.linux.org.uk>
    READ is "data destination", not source...

Al Viro <viro@zeniv.linux.org.uk>
    WRITE is "data source", not destination...

Eric Auger <eric.auger@redhat.com>
    vhost/net: Clear the pending messages when the backend is removed

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    drm/vc4: hdmi: make CEC adapter name unique

Pierluigi Passaro <pierluigi.p@variscite.com>
    arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix to preserve reg parent/live fields when copying range info

Martin KaFai Lau <kafai@fb.com>
    bpf: Support <8-byte scalar spill and refill

Artemii Karasev <karasev@ispras.ru>
    ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Yonghong Song <yhs@fb.com>
    bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_wm5102: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_rt5640: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ASoC: Intel: bytcht_es8316: Drop reference count of ACPI device after use

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: bytcht_es8316: move comment to the right place

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: boards: fix spelling in comments

Yuan Can <yuancan@huawei.com>
    bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |   2 +-
 arch/parisc/kernel/firmware.c                      |   5 +-
 arch/parisc/kernel/ptrace.c                        |  15 ++-
 arch/powerpc/perf/imc-pmu.c                        |  14 +--
 arch/riscv/Makefile                                |   3 +
 arch/riscv/kernel/probes/kprobes.c                 |  18 ++++
 arch/x86/events/intel/core.c                       |   1 +
 arch/x86/include/asm/debugreg.h                    |  26 ++++-
 block/bfq-cgroup.c                                 |   8 +-
 block/bfq-iosched.c                                |  10 +-
 drivers/ata/libata-core.c                          |   2 +-
 drivers/bus/sunxi-rsb.c                            |   8 +-
 drivers/firewire/core-cdev.c                       |   4 +-
 drivers/firmware/efi/efi.c                         |   2 +
 drivers/firmware/efi/memattr.c                     |   2 +-
 drivers/fpga/stratix10-soc.c                       |   4 +-
 drivers/fsi/fsi-sbefifo.c                          |   6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 ++
 drivers/gpu/drm/i915/display/intel_cdclk.c         |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c         |   9 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  10 ++
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   3 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   2 +
 drivers/i2c/busses/i2c-mxs.c                       |   4 +-
 drivers/i2c/busses/i2c-rk3x.c                      |  44 ++++----
 drivers/iio/accel/hid-sensor-accel-3d.c            |   1 +
 drivers/iio/adc/berlin2-adc.c                      |   4 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |   1 +
 drivers/iio/adc/twl6030-gpadc.c                    |  32 ++++++
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   1 +
 drivers/iio/imu/fxos8700_core.c                    | 111 +++++++++++++++++----
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   2 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 ++
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   9 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |  23 +++--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h       |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  28 +++++-
 drivers/net/ethernet/intel/ice/ice_main.c          |   5 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  14 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   7 +-
 drivers/net/ethernet/sfc/efx.c                     |   5 +-
 drivers/net/phy/dp83822.c                          |   6 +-
 drivers/net/phy/meson-gxl.c                        |   2 +
 drivers/net/virtio_net.c                           |   8 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  17 ++++
 drivers/nvmem/core.c                               |  10 +-
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  89 +++++++++++------
 drivers/platform/x86/dell/dell-wmi-base.c          |   3 +
 drivers/platform/x86/gigabyte-wmi.c                |   1 +
 drivers/scsi/iscsi_tcp.c                           |  20 +++-
 drivers/scsi/libiscsi.c                            |  38 +++++--
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/target/target_core_file.c                  |   4 +-
 drivers/target/target_core_tmr.c                   |   4 +-
 drivers/tty/serial/8250/8250_dma.c                 |  26 ++++-
 drivers/tty/vt/vc_screen.c                         |   9 +-
 drivers/usb/dwc3/dwc3-qcom.c                       |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +-
 drivers/usb/gadget/function/f_uac2.c               |   1 +
 drivers/vhost/net.c                                |   3 +
 drivers/vhost/vhost.c                              |   3 +-
 drivers/vhost/vhost.h                              |   1 +
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 drivers/video/fbdev/smscufx.c                      |  46 ++++++---
 drivers/watchdog/diag288_wdt.c                     |  15 ++-
 drivers/xen/pvcalls-back.c                         |   8 +-
 fs/f2fs/gc.c                                       |  18 ++--
 fs/gfs2/aops.c                                     |   2 -
 fs/gfs2/bmap.c                                     |   3 -
 fs/gfs2/glops.c                                    |  44 ++++----
 fs/gfs2/super.c                                    |  27 ++---
 fs/ntfs3/inode.c                                   |   7 ++
 fs/overlayfs/export.c                              |   2 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/proc/task_mmu.c                                 |   4 +-
 fs/squashfs/squashfs_fs.h                          |   2 +-
 fs/squashfs/squashfs_fs_sb.h                       |   2 +-
 fs/squashfs/xattr.h                                |   4 +-
 fs/squashfs/xattr_id.c                             |   4 +-
 include/linux/highmem-internal.h                   |   4 +-
 include/linux/hugetlb.h                            |  13 +++
 include/linux/nvmem-provider.h                     |   2 -
 include/linux/util_macros.h                        |  12 +++
 include/scsi/libiscsi.h                            |   2 +
 kernel/bpf/verifier.c                              | 108 ++++++++++++++------
 kernel/irq/irqdomain.c                             |   2 +-
 kernel/trace/bpf_trace.c                           |   3 +-
 mm/swapfile.c                                      |   1 +
 net/bridge/br_netfilter_hooks.c                    |   1 +
 net/can/j1939/transport.c                          |   4 -
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/ipv6/addrconf.c                                |  59 ++++++-----
 net/netrom/af_netrom.c                             |   5 +
 net/openvswitch/datapath.c                         |  12 +--
 net/qrtr/ns.c                                      |   5 +-
 net/x25/af_x25.c                                   |   6 ++
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/hda/patch_via.c                          |   3 +
 sound/soc/intel/boards/bdw-rt5650.c                |   2 +-
 sound/soc/intel/boards/bdw-rt5677.c                |   2 +-
 sound/soc/intel/boards/broadwell.c                 |   2 +-
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |   2 +-
 sound/soc/intel/boards/bxt_rt298.c                 |   2 +-
 sound/soc/intel/boards/bytcht_cx2072x.c            |   2 +-
 sound/soc/intel/boards/bytcht_da7213.c             |   2 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  24 +++--
 sound/soc/intel/boards/bytcr_rt5640.c              |  14 +--
 sound/soc/intel/boards/bytcr_rt5651.c              |   4 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |   2 +-
 sound/soc/intel/boards/cht_bsw_max98090_ti.c       |   4 +-
 sound/soc/intel/boards/cht_bsw_nau8824.c           |   4 +-
 sound/soc/intel/boards/cht_bsw_rt5645.c            |   2 +-
 sound/soc/intel/boards/cht_bsw_rt5672.c            |   2 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   2 +-
 sound/soc/intel/boards/haswell.c                   |   2 +-
 tools/testing/selftests/net/udpgso_bench.sh        |  24 ++++-
 tools/testing/selftests/net/udpgso_bench_rx.c      |   4 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |  36 +++++--
 122 files changed, 923 insertions(+), 395 deletions(-)


