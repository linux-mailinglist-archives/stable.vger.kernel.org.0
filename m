Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DA069CC7C
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjBTNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjBTNkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471881CF65;
        Mon, 20 Feb 2023 05:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEFB6B80D49;
        Mon, 20 Feb 2023 13:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A12AC433EF;
        Mon, 20 Feb 2023 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900440;
        bh=pXLS9KmTUQ+x6cELlzVNlQNQpYCXdy89lKA/DiFXJ2g=;
        h=From:To:Cc:Subject:Date:From;
        b=u2gmomEqGAKRKP3KWpMsTEERz4LavOO1I26mU1drM0AtYXxjkRT+AYiLYZztGuq3Z
         zLItgUaF4uFITxE49FyC2eDsicpR+FkO74cVBnxurO3RCgS7d2wNcFo+cOH3GRp1/i
         +NVw6/XK91Yyli13Xl2kG/BXvqAxm+P8hPnUmP3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/89] 4.19.273-rc1 review
Date:   Mon, 20 Feb 2023 14:34:59 +0100
Message-Id: <20230220133553.066768704@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.273-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.273-rc1
X-KernelTest-Deadline: 2023-02-22T13:35+00:00
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

This is the start of the stable review cycle for the 4.19.273 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.273-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.273-rc1

Chris Healy <healych@amazon.com>
    net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix underflow in second superblock position calculations

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: initialize all of the kvm_debugregs structure before sending it to userspace

Natalia Petrova <n.petrova@fintech.ru>
    i40e: Add checking for null for nlmsg_find_attr()

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix tcp socket connection with DSCP.

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix datagram socket connection with DSCP.

Jakub Kicinski <kuba@kernel.org>
    net: mpls: fix stale pointer if allocation fails during device rename

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    net: stmmac: Restrict warning on disabling DMA store and fwd mode

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix mqprio and XDP ring checking logic

Johannes Zink <j.zink@pengutronix.de>
    net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Miko Larsson <mikoxyzzz@gmail.com>
    net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Rafał Miłecki <rafal@milecki.pl>
    net: bgmac: fix BCM5358 support by setting correct flags

Jason Xing <kernelxing@tencent.com>
    i40e: add double of VLAN header when computing the max MTU

Andrew Morton <akpm@linux-foundation.org>
    revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: check for undefined shift on 32 bit architectures

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed wrong gpio assigned

Bo Liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec SN6180

Yang Yingliang <yangyingliang@huawei.com>
    mmc: sdio: fix possible resource leaks in some error paths

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN"

Florian Westphal <fw@strlen.de>
    netfilter: nft_tproxy: restrict to prerouting hook

Seth Jenkins <sethjenkins@google.com>
    aio: fix mremap after fork null-deref

Amit Engel <Amit.Engel@dell.com>
    nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Hyunwoo Kim <v4bel@theori.io>
    net/rose: Fix to not accept on connected socket

Shunsuke Mie <mie@igel.co.jp>
    tools/virtio: fix the vringh test for virtio ring changes

Arnd Bergmann <arnd@arndb.de>
    ASoC: cs42l56: fix DT probe

Mike Kravetz <mike.kravetz@oracle.com>
    migrate: hugetlb: check for hugetlb shared PMD in node migration

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Always return target ifindex in bpf_fib_lookup

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Heiner Kallweit <hkallweit1@gmail.com>
    arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive

Guo Ren <guoren@linux.alibaba.com>
    riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Prashant Malani <pmalani@chromium.org>
    usb: typec: altmodes/displayport: Fix probe pin assign check

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: core: add quirk for Alcor Link AK9563 smartcard reader

Alan Stern <stern@rowland.harvard.edu>
    net: USB: Fix wrong-direction WARNING in plusb.c

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Restore the pins that used to be in Direct IRQ mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Convert unsigned to unsigned int

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

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY

Jerome Brunet <jbrunet@baylibre.com>
    net: phy: meson-gxl: add g12a support

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: add macros for PHYID matching

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Restore allocated resources on failed copyout

Artemii Karasev <karasev@ispras.ru>
    ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Josef Bacik <josef@toxicpanda.com>
    btrfs: limit device extents to the device size

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurement of VAC

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx rearm race

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_dma: Fix DMA Rx completion race

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix handling and sanity checking of xattr_ids count

Longlong Xia <xialonglong1@huawei.com>
    mm/swapfile: add cond_resched() in get_swap_pages()

Mike Kravetz <mike.kravetz@oracle.com>
    mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps

Andreas Schwab <schwab@suse.de>
    riscv: disable generation of unwind tables

Helge Deller <deller@gmx.de>
    parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Helge Deller <deller@gmx.de>
    parisc: Fix return code of pdc_iodc_print()

Andreas Kemnade <andreas@kemnade.info>
    iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iio: adc: berlin2-adc: Add missing of_node_put() in error path

Dmitry Perchanov <dmitry.perchanov@intel.com>
    iio: hid: fix the retval in accel_3d_capture_sample

Ard Biesheuvel <ardb@kernel.org>
    efi: Accept version 2 of memory attributes table

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Egorenkov <egorenar@linux.ibm.com>
    watchdog: diag288_wdt: do not use stack buffers for hardware data

Samuel Thibault <samuel.thibault@ens-lyon.org>
    fbcon: Check font dimension limits

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: int340x: Protect trip temperature from concurrent updates

Hendrik Borghorst <hborghor@amazon.de>
    KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Move caching of MSR_IA32_XSS to hardware_setup()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Move VMX specific files to a "vmx" subdirectory

Krish Sadhukhan <krish.sadhukhan@oracle.com>
    nVMX x86: Check VMX-preemption timer controls on vmentry of L2 guests

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

Randy Dunlap <rdunlap@infradead.org>
    i2c: rk3x: fix a bunch of kernel-doc warnings

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on RT kernels

Fedor Pchelkin <pchelkin@ispras.ru>
    net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Fedor Pchelkin <pchelkin@ispras.ru>
    squashfs: harden sanity check in squashfs_read_xattr_id_table

Hyunwoo Kim <v4bel@theori.io>
    netrom: Fix use-after-free caused by accept on already connected socket

Artemii Karasev <karasev@ispras.ru>
    ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()

Yuan Can <yuancan@huawei.com>
    bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    4 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |    6 +-
 arch/parisc/kernel/firmware.c                      |    5 +-
 arch/parisc/kernel/ptrace.c                        |   15 +-
 arch/riscv/Makefile                                |    3 +
 arch/riscv/mm/cacheflush.c                         |    4 +-
 arch/x86/kernel/fpu/init.c                         |    7 +-
 arch/x86/kvm/Makefile                              |    2 +-
 arch/x86/kvm/{ => vmx}/pmu_intel.c                 |    0
 arch/x86/kvm/{ => vmx}/vmx.c                       |   37 +-
 arch/x86/kvm/{ => vmx}/vmx_evmcs.h                 |    0
 arch/x86/kvm/{ => vmx}/vmx_shadow_fields.h         |    0
 arch/x86/kvm/x86.c                                 |    3 +-
 drivers/ata/libata-core.c                          |    2 +-
 drivers/bus/sunxi-rsb.c                            |    8 +-
 drivers/firewire/core-cdev.c                       |    4 +-
 drivers/firmware/efi/memattr.c                     |    2 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   44 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |    1 +
 drivers/iio/adc/berlin2-adc.c                      |    4 +-
 drivers/iio/adc/stm32-dfsdm-adc.c                  |    1 +
 drivers/iio/adc/twl6030-gpadc.c                    |   32 +
 drivers/infiniband/hw/hfi1/file_ops.c              |    7 +-
 drivers/input/serio/i8042-x86ia64io.h              | 1188 ++++++++++++--------
 drivers/mmc/core/sdio_bus.c                        |   17 +-
 drivers/mmc/core/sdio_cis.c                        |   12 -
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |    6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |    3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    2 +-
 drivers/net/phy/meson-gxl.c                        |   15 +
 drivers/net/usb/kalmia.c                           |    8 +-
 drivers/net/usb/plusb.c                            |    4 +-
 drivers/nvme/target/fc.c                           |    4 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed.c            |    2 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |  117 +-
 drivers/pinctrl/intel/pinctrl-intel.h              |   32 +-
 drivers/pinctrl/pinctrl-single.c                   |    2 +
 drivers/scsi/iscsi_tcp.c                           |    9 +-
 drivers/target/target_core_tmr.c                   |    4 +-
 .../thermal/int340x_thermal/int340x_thermal_zone.c |   28 +-
 .../thermal/int340x_thermal/int340x_thermal_zone.h |    1 +
 drivers/tty/serial/8250/8250_dma.c                 |   26 +-
 drivers/tty/vt/vc_screen.c                         |    9 +-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   10 +-
 drivers/usb/gadget/function/f_fs.c                 |    4 +-
 drivers/usb/typec/altmodes/displayport.c           |    8 +-
 drivers/video/fbdev/core/fbcon.c                   |    7 +-
 drivers/watchdog/diag288_wdt.c                     |   15 +-
 fs/aio.c                                           |    4 +
 fs/btrfs/volumes.c                                 |    6 +-
 fs/nilfs2/ioctl.c                                  |    7 +
 fs/nilfs2/super.c                                  |    9 +
 fs/nilfs2/the_nilfs.c                              |    8 +-
 fs/proc/task_mmu.c                                 |    4 +-
 fs/squashfs/squashfs_fs.h                          |    2 +-
 fs/squashfs/squashfs_fs_sb.h                       |    2 +-
 fs/squashfs/xattr.h                                |    4 +-
 fs/squashfs/xattr_id.c                             |    2 +-
 include/linux/hugetlb.h                            |   18 +-
 include/linux/phy.h                                |    4 +
 include/net/sock.h                                 |   13 +
 mm/mempolicy.c                                     |    3 +-
 mm/swapfile.c                                      |    1 +
 net/core/filter.c                                  |    3 +-
 net/dccp/ipv6.c                                    |    7 +-
 net/ipv6/datagram.c                                |    2 +-
 net/ipv6/tcp_ipv6.c                                |   11 +-
 net/mpls/af_mpls.c                                 |    4 +
 net/netfilter/nft_tproxy.c                         |    8 +
 net/netrom/af_netrom.c                             |    5 +
 net/openvswitch/datapath.c                         |   12 +-
 net/rds/message.c                                  |    6 +-
 net/rose/af_rose.c                                 |    8 +
 net/x25/af_x25.c                                   |    6 +
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_realtek.c                      |    2 +-
 sound/pci/hda/patch_via.c                          |    3 +
 sound/pci/lx6464es/lx_core.c                       |   11 +-
 sound/soc/codecs/cs42l56.c                         |    6 -
 sound/synth/emux/emux_nrpn.c                       |    3 +
 tools/testing/selftests/net/forwarding/lib.sh      |    4 +-
 tools/virtio/linux/bug.h                           |    8 +-
 tools/virtio/linux/build_bug.h                     |    7 +
 tools/virtio/linux/cpumask.h                       |    7 +
 tools/virtio/linux/gfp.h                           |    7 +
 tools/virtio/linux/kernel.h                        |    1 +
 tools/virtio/linux/kmsan.h                         |   12 +
 tools/virtio/linux/scatterlist.h                   |    1 +
 tools/virtio/linux/topology.h                      |    7 +
 93 files changed, 1251 insertions(+), 731 deletions(-)


