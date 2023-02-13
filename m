Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A868E6949AF
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjBMPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjBMPAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C91E1C7;
        Mon, 13 Feb 2023 07:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB48FB8125D;
        Mon, 13 Feb 2023 15:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F342CC433D2;
        Mon, 13 Feb 2023 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300433;
        bh=600Rp+xMtDcOueOEfYX9TIONWLbMLG9AYZqNiVFKBBM=;
        h=From:To:Cc:Subject:Date:From;
        b=w3QzciYSUY/l50HqH5aBqJzQU1j1Nk8xckb2WQ4UVKWKdsfiyZB/O5HtMhf629Qr8
         g7pLv+8qo00/4Te7f00fMh5pipkAZEMTVJqgeZH5Zn3u9XUsKVkPVcUkFBSsdpoqaZ
         8dBBf4hLaXQepcn78YCh95a0U2S4ceF7G+1OKKsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/139] 5.10.168-rc1 review
Date:   Mon, 13 Feb 2023 15:49:05 +0100
Message-Id: <20230213144745.696901179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.168-rc1
X-KernelTest-Deadline: 2023-02-15T14:47+00:00
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

This is the start of the stable review cycle for the 5.10.168 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.168-rc1

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix return value

David Chen <david.chen@nutanix.com>
    Fix page corruption caused by racy check in __free_pages

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Xiubo Li <xiubli@redhat.com>
    ceph: flush cap releases when the session is flushed

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix probe pin assign check

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: core: add quirk for Alcor Link AK9563 smartcard reader

Anand Jain <anand.jain@oracle.com>
    btrfs: free device in btrfs_close_devices for a single device filesystem

Alan Stern <stern@rowland.harvard.edu>
    net: USB: Fix wrong-direction WARNING in plusb.c

ZhaoLong Wang <wangzhaolong1@huawei.com>
    cifs: Fix use-after-free in rdata->read_into_pages()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    spi: dw: Fix wrong FIFO level setting for long xfers

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    pinctrl: single: fix potential NULL dereference

Joel Stanley <joel@jms.id.au>
    pinctrl: aspeed: Fix confusing types in return value

Dan Carpenter <error27@gmail.com>
    ALSA: pci: lx6464es: fix a debug loop

Hangbin Liu <liuhangbin@gmail.com>
    selftests: forwarding: lib: quote the sysctl values

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() use list_first_entry()

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Zero consumer index when reloading the tracer

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: IPoIB, Show unknown speed instead of error

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Herton R. Krzesinski <herton@redhat.com>
    uapi: add missing ip/ipv6 header dependencies for linux/stddef.h

Neel Patel <neel.patel@amd.com>
    ionic: clean interrupt before enabling queue to avoid credit race

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Qi Zheng <zhengqi.arch@bytedance.com>
    bonding: fix error checking in bond_debug_reregister()

Christian Hopps <chopps@chopps.org>
    xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Yang Yingliang <yangyingliang@huawei.com>
    RDMA/usnic: use iommu_map_atomic() under spin_lock()

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix legacy IPoIB due to wrong number of queues

Eric Dumazet <edumazet@google.com>
    xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Restore allocated resources on failed copyout

Anastasia Belova <abelova@astralinux.ru>
    xfrm: compat: change expression for switch in xfrm_xlate64

Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
    can: j1939: do not wait 250 ms if the same addr was already claimed

Mark Brown <broonie@kernel.org>
    of/address: Return an error when no valid dma-ranges are found

Shiju Jose <shiju.jose@huawei.com>
    tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Guillaume Pinot <texitoi@texitoi.eu>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360

Artemii Karasev <karasev@ispras.ru>
    ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Add Positivo N14KP6-TG

Alexander Potapenko <glider@google.com>
    btrfs: zlib: zero-initialize zlib workspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: limit device extents to the device size

Mike Kravetz <mike.kravetz@oracle.com>
    migrate: hugetlb: check for hugetlb shared PMD in node migration

Miaohe Lin <linmiaohe@huawei.com>
    mm/migration: return errno when isolate_huge_page failed

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurement of VAC

Martin KaFai Lau <kafai@fb.com>
    bpf: Do not reject when the stack read size is different from the tracked scalar size

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix registration vs use race

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix cleanup after dev_set_name()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: remove nvmem_config wp_gpio

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmem: core: add error handling for dev_set_name

Christophe Kerello <christophe.kerello@foss.st.com>
    nvmem: core: Fix a conflict between MTD and NVMEM on wp-gpios property

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_extra_isize in is_alive()

Dongliang Mu <dzm91@hust.edu.cn>
    fbdev: smscufx: fix error handling code in ufx_usb_probe

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx rearm race

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx completion race

Michael Walle <michael@walle.cc>
    nvmem: core: fix cell removal on error

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: initialise nvmem->id early

Rob Clark <robdclark@chromium.org>
    drm/i915: Fix potential bit_17 double-free

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix handling and sanity checking of xattr_ids count

Longlong Xia <xialonglong1@huawei.com>
    mm/swapfile: add cond_resched() in get_swap_pages()

Zheng Yongjun <zhengyongjun3@huawei.com>
    fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Joerg Roedel <jroedel@suse.de>
    x86/debug: Fix stack recursion caused by wrongly ordered DR7 accesses

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

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO devices to i8042 quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - merge quirk tables

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - move __initconst to fix code styling warning

George Kennedy <george.kennedy@oracle.com>
    vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Neil Armstrong <neil.armstrong@linaro.org>
    usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API

Olivier Moysan <olivier.moysan@foss.st.com>
    iio: adc: stm32-dfsdm: fill module aliases

Hyunwoo Kim <v4bel@theori.io>
    net/x25: Fix to not accept on connected socket

Koba Ko <koba.ko@canonical.com>
    platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table

Randy Dunlap <rdunlap@infradead.org>
    i2c: rk3x: fix a bunch of kernel-doc warnings

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on RT kernels

Stefan Wahren <stefan.wahren@i2se.com>
    i2c: mxs: suppress probe-deferral error message

Magnus Karlsson <magnus.karlsson@intel.com>
    qede: execute xdp_do_flush() before napi_complete_done()

Bhaskar Upadhaya <bupadhaya@marvell.com>
    qede: add netpoll support for qede driver

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

Chris Healy <healych@amazon.com>
    net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Fedor Pchelkin <pchelkin@ispras.ru>
    squashfs: harden sanity check in squashfs_read_xattr_id_table

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: disable sabotage_in hook after first suppression

Hyunwoo Kim <v4bel@theori.io>
    netrom: Fix use-after-free caused by accept on already connected socket

Andre Kalb <andre.kalb@sma.de>
    net: phy: dp83822: Fix null pointer access on DP83825/DP83826 devices

Íñigo Huguet <ihuguet@redhat.com>
    sfc: correctly advertise tunneled IPv6 segmentation

Magnus Karlsson <magnus.karlsson@intel.com>
    virtio-net: execute xdp_do_flush() before napi_complete_done()

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

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bpf: Move common helpers into bpf_jit.h

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bpf: Change register numbering for bpf_set/is_seen_register()

Artemii Karasev <karasev@ispras.ru>
    ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Yonghong Song <yhs@fb.com>
    bpf: Fix a possible task gone issue with bpf_send_signal[_thread]() helpers

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Paul Chaignon <paul@isovalent.com>
    bpf: Fix incorrect state pruning for <8B spill/fill

Yuan Can <yuancan@huawei.com>
    bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |    6 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |    6 +-
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h     |    2 +-
 arch/parisc/kernel/firmware.c                      |    5 +-
 arch/parisc/kernel/ptrace.c                        |   15 +-
 arch/powerpc/net/bpf_jit.h                         |   35 +
 arch/powerpc/net/bpf_jit64.h                       |   19 -
 arch/powerpc/net/bpf_jit_comp64.c                  |   28 +-
 arch/powerpc/perf/imc-pmu.c                        |   14 +-
 arch/riscv/Makefile                                |    3 +
 arch/riscv/mm/cacheflush.c                         |    4 +-
 arch/x86/include/asm/debugreg.h                    |   26 +-
 drivers/ata/libata-core.c                          |    2 +-
 drivers/bus/sunxi-rsb.c                            |    8 +-
 drivers/firewire/core-cdev.c                       |    4 +-
 drivers/firmware/efi/efi.c                         |    2 +
 drivers/firmware/efi/memattr.c                     |    2 +-
 drivers/fpga/stratix10-soc.c                       |    4 +-
 drivers/fsi/fsi-sbefifo.c                          |    6 +-
 drivers/gpu/drm/i915/gem/i915_gem_tiling.c         |    9 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |    3 +-
 drivers/i2c/busses/i2c-mxs.c                       |    4 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   44 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |    1 +
 drivers/iio/adc/berlin2-adc.c                      |    4 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |    1 +
 drivers/iio/adc/twl6030-gpadc.c                    |   32 +
 drivers/iio/imu/fxos8700_core.c                    |  111 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |    7 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    8 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |    2 +-
 drivers/input/serio/i8042-x86ia64io.h              | 1188 ++++++++++++--------
 drivers/net/bonding/bond_debugfs.c                 |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |    2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   14 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |    3 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   13 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |   24 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   15 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   10 +-
 drivers/net/ethernet/sfc/efx.c                     |    5 +-
 drivers/net/phy/dp83822.c                          |    6 +-
 drivers/net/phy/meson-gxl.c                        |    4 +
 drivers/net/usb/plusb.c                            |    4 +-
 drivers/net/virtio_net.c                           |    8 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   17 +
 drivers/nvmem/core.c                               |   45 +-
 drivers/nvmem/qcom-spmi-sdam.c                     |    1 +
 drivers/of/address.c                               |   21 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |    2 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   16 +-
 drivers/pinctrl/pinctrl-single.c                   |    2 +
 drivers/platform/x86/dell-wmi.c                    |    3 +
 drivers/scsi/iscsi_tcp.c                           |    9 +-
 drivers/scsi/scsi_scan.c                           |    7 +-
 drivers/spi/spi-dw-core.c                          |    2 +-
 drivers/target/target_core_file.c                  |    4 +-
 drivers/target/target_core_tmr.c                   |    4 +-
 drivers/tty/serial/8250/8250_dma.c                 |   26 +-
 drivers/tty/vt/vc_screen.c                         |    9 +-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   10 +-
 drivers/usb/gadget/function/f_fs.c                 |    4 +-
 drivers/usb/typec/altmodes/displayport.c           |    8 +-
 drivers/vhost/net.c                                |    3 +
 drivers/vhost/vhost.c                              |    3 +-
 drivers/vhost/vhost.h                              |    1 +
 drivers/video/fbdev/core/fbcon.c                   |    7 +-
 drivers/video/fbdev/smscufx.c                      |   46 +-
 drivers/watchdog/diag288_wdt.c                     |   15 +-
 drivers/xen/pvcalls-back.c                         |    8 +-
 fs/btrfs/volumes.c                                 |   22 +-
 fs/btrfs/zlib.c                                    |    2 +-
 fs/ceph/mds_client.c                               |    6 +
 fs/cifs/file.c                                     |    4 +-
 fs/f2fs/gc.c                                       |   18 +-
 fs/proc/task_mmu.c                                 |    4 +-
 fs/squashfs/squashfs_fs.h                          |    2 +-
 fs/squashfs/squashfs_fs_sb.h                       |    2 +-
 fs/squashfs/xattr.h                                |    4 +-
 fs/squashfs/xattr_id.c                             |    4 +-
 include/linux/hugetlb.h                            |   19 +-
 include/linux/nvmem-provider.h                     |    4 +-
 include/linux/util_macros.h                        |   12 +
 include/uapi/linux/ip.h                            |    1 +
 include/uapi/linux/ipv6.h                          |    1 +
 kernel/bpf/verifier.c                              |  102 +-
 kernel/trace/bpf_trace.c                           |    3 +-
 kernel/trace/trace.c                               |    3 -
 mm/gup.c                                           |    2 +-
 mm/hugetlb.c                                       |    6 +-
 mm/memory-failure.c                                |    2 +-
 mm/memory_hotplug.c                                |    2 +-
 mm/mempolicy.c                                     |    5 +-
 mm/migrate.c                                       |    7 +-
 mm/page_alloc.c                                    |    5 +-
 mm/swapfile.c                                      |    1 +
 net/bridge/br_netfilter_hooks.c                    |    1 +
 net/can/j1939/address-claim.c                      |   40 +
 net/can/j1939/transport.c                          |    4 -
 net/ipv4/tcp_bpf.c                                 |    4 +-
 net/netrom/af_netrom.c                             |    5 +
 net/openvswitch/datapath.c                         |   12 +-
 net/qrtr/ns.c                                      |    5 +-
 net/rds/message.c                                  |    6 +-
 net/x25/af_x25.c                                   |    6 +
 net/xfrm/xfrm_compat.c                             |    4 +-
 net/xfrm/xfrm_input.c                              |    3 +-
 sound/pci/hda/patch_realtek.c                      |    3 +
 sound/pci/hda/patch_via.c                          |    3 +
 sound/pci/lx6464es/lx_core.c                       |   11 +-
 sound/synth/emux/emux_nrpn.c                       |    3 +
 tools/testing/selftests/net/forwarding/lib.sh      |    4 +-
 tools/testing/selftests/net/udpgso_bench.sh        |   24 +-
 tools/testing/selftests/net/udpgso_bench_rx.c      |    4 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |   36 +-
 119 files changed, 1573 insertions(+), 855 deletions(-)


