Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88B4D8D4
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfFTSCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfFTSCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:02:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB24208CA;
        Thu, 20 Jun 2019 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053761;
        bh=xawc2q9Krn45I226H85N4lKd1WYQDAg1mGNGh6RzOeo=;
        h=From:To:Cc:Subject:Date:From;
        b=j2KLcOqfpcKZXIGCNf2S85dUqbxK5+IYMmQksRZPEclAl2296zxDkfB+ghch/GU7W
         JiqXpyxNwo/voZZMQxebUSiP8ZGIYm1/f9mZXG5ntYy4rxD6SycY201NSm9Qa7682B
         YVGh25vtA2w2L7XbDG84hYAwtGrEm+n+RbIspErs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/117] 4.9.183-stable review
Date:   Thu, 20 Jun 2019 19:55:34 +0200
Message-Id: <20190620174351.964339809@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.183-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.183-rc1
X-KernelTest-Deadline: 2019-06-22T17:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.183 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.183-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.183-rc1

Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
    Abort file_remove_privs() for non-reg. files

Amit Cohen <amitc@mellanox.com>
    mlxsw: spectrum: Prevent force of 56G

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: delete sas port if expander discover failed

Lianbo Jiang <lijiang@redhat.com>
    scsi: smartpqi: properly set both the DMA mask and the coherent DMA mask

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: add a check for NULL pointer in cxgbi_check_route()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Don't take kvm->lock around kvm_for_each_vcpu

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S: Use new mutex to synchronize access to rtas token list

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix build errors by exporting paddr_to_nid()

Thomas Richter <tmricht@linux.ibm.com>
    perf record: Fix s390 missing module symbol and warning for non-root users

Shawn Landden <shawn@git.icu>
    perf data: Fix 'strncat may truncate' build failure with recent gcc

Sahitya Tummala <stummala@codeaurora.org>
    configfs: Fix use-after-free when accessing sd->s_dentry

Yingjoe Chen <yingjoe.chen@mediatek.com>
    i2c: dev: fix potential memory leak in i2cdev_ioctl_rdwr

Kees Cook <keescook@chromium.org>
    net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Randy Dunlap <rdunlap@infradead.org>
    gpio: fix gpio-adp5588 build errors

Peter Zijlstra <peterz@infradead.org>
    perf/ring_buffer: Add ordering to rb->nest increment

Yabin Cui <yabinc@google.com>
    perf/ring_buffer: Fix exposing a temporarily decreased data_head

Frank van der Linden <fllinden@amazon.com>
    x86/CPU/AMD: Don't force the CPB cap when running under a hypervisor

Dan Carpenter <dan.carpenter@oracle.com>
    mISDN: make sure device name is NUL terminated

Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
    selftests: netfilter: missing error check when setting up veth interface

Stephane Eranian <eranian@google.com>
    perf/x86/intel/ds: Fix EVENT vs. UEVENT PEBS constraints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "staging: vc04_services: prevent integer overflow in create_pagelist()"

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    sunhv: Fix device naming inconsistency between sunhv_console and sunhv_reg

Eric Dumazet <edumazet@google.com>
    neigh: fix use-after-free read in pneigh_get_next

Jeremy Sowden <jeremy@azazel.net>
    lapb: fixed leak of control-blocks.

Eric Dumazet <edumazet@google.com>
    ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero

Ivan Vecera <ivecera@redhat.com>
    be2net: Fix number of Rx queues used for flow hashing

Eric Dumazet <edumazet@google.com>
    ax25: fix inconsistent lock state in ax25_destroy_timer

Baruch Siach <baruch@tkos.co.il>
    rtc: pcf8523: don't return invalid date when battery is low

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add support for Simcom SIM7500/SIM7600 RNDIS mode

Chris Packham <chris.packham@alliedtelesis.co.nz>
    USB: serial: pl2303: add Allied Telesis VT-Kit3

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: usb-storage: Add new ID to ums-realtek

Marco Zatta <marco@zatta.me>
    USB: Fix chipmunk-like voice when using Logitech C270 for recording audio.

Martin Schiller <ms@dev.tdt.de>
    usb: dwc2: Fix DMA cache alignment issues

Murray McAllister <murray.mcallister@gmail.com>
    drm/vmwgfx: NULL pointer dereference from vmw_cmd_dx_view_define()

Murray McAllister <murray.mcallister@gmail.com>
    drm/vmwgfx: integer underflow in vmw_cmd_dx_set_shader() leading to an invalid read

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/pmu: do not mask the value that is written to fixed PMUs

Bernd Eckstein <3erndeckstein@gmail.com>
    usbnet: ipheth: fix racing condition

Kees Cook <keescook@chromium.org>
    selftests/timers: Add missing fflush(stdout) calls

Colin Ian King <colin.king@canonical.com>
    scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Mark Rutland <mark.rutland@arm.com>
    arm64/mm: Inhibit huge-vmap with ptdump

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: add check for loss of ndlp when sending RRQ

Young Xiao <YangX92@hotmail.com>
    Drivers: misc: fix out-of-bounds access in function param_set_kgdbts_var

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix race of get-subscription call vs port-delete ioctls

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Protect in-kernel ioctl calls with mutex

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, kcov: Disable stack protector

S.j. Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: Fix the issue about unsupported rate

S.j. Wang <shengjiu.wang@nxp.com>
    ASoC: cs42xx8: Add regcache mask dirty

Tejun Heo <tj@kernel.org>
    cgroup: Use css_tryget() instead of css_tryget_online() in task_get_css()

Coly Li <colyli@suse.de>
    bcache: fix stack corruption by PRECEDING_KEY()

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: acorn: fix i2c warning

Hans Verkuil <hans.verkuil@cisco.com>
    media: v4l2-ioctl: clear fields in s_parm

Jann Horn <jannh@google.com>
    ptrace: restore smp_rmb() in __ptrace_may_access()

Eric W. Biederman <ebiederm@xmission.com>
    signal/ptrace: Don't leak unitialized kernel memory with PTRACE_PEEK_SIGINFO

Wengang Wang <wen.gang.wang@oracle.com>
    fs/ocfs2: fix race in ocfs2_dentry_attach_lock()

Shakeel Butt <shakeelb@google.com>
    mm/list_lru.c: fix memory leak in __memcg_init_list_lru_node

Hans de Goede <hdegoede@redhat.com>
    libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: oxfw: allow PCM capture for Stanton SCS.1m

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Cover unsubscribe_port() in list_mutex

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: exynos: Fix undefined instruction during Exynos5422 resume

Phong Hoang <phong.hoang.wz@renesas.com>
    pwm: Fix deadlock warning when removing PWM device

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regulators on Arndale Octa

Christoph Vogtländer <c.vogtlaender@sigma-surface-science.com>
    pwm: tiehrpwm: Update shadow register for disabling PWMs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: idma64: Use actual device for DMA transfers

Tony Lindgren <tony@atomide.com>
    gpio: gpio-omap: add check for off wake capable gpios

Kangjie Lu <kjlu@umn.edu>
    PCI: xilinx: Check for __get_free_pages() failure

Kangjie Lu <kjlu@umn.edu>
    video: imsttfb: fix potential NULL pointer dereferences

Kangjie Lu <kjlu@umn.edu>
    video: hgafb: fix potential NULL pointer dereference

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: rcar: Fix 64bit MSI message address handling

Kangjie Lu <kjlu@umn.edu>
    PCI: rcar: Fix a potential NULL pointer dereference

Junxiao Chang <junxiao.chang@intel.com>
    platform/x86: intel_pmc_ipc: adding error handling

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA

Andrey Smirnov <andrew.smirnov@gmail.com>
    ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288

Nathan Chancellor <natechancellor@gmail.com>
    soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Enrico Granata <egranata@chromium.org>
    platform/chrome: cros_ec_proto: check for NULL transfer function

Wenwen Wang <wang6495@umn.edu>
    x86/PCI: Fix PCI IRQ routing table memory leak

J. Bruce Fields <bfields@redhat.com>
    nfsd: allow fh_want_write to be called twice

Kirill Smelkov <kirr@nexedi.com>
    fuse: retrieve: cap requested size to negotiated max_write

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    nvmem: core: fix read buffer in place

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Register irq handler after the chip initialization

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Vladimir Zapolskiy <vz@mleia.com>
    watchdog: fix compile time error of pretimeout governors

Georg Hofmann <georg@hofmannsweb.com>
    watchdog: imx2_wdt: Fix set_timeout for big timeout values

Maciej Żenczykowski <maze@google.com>
    uml: fix a boot splat wrt use of cpu_all_mask

YueHaibing <yuehaibing@huawei.com>
    configfs: fix possible use-after-free in configfs_register_group

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to do sanity check on valid block count of segment

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to clear dirty inode in error path of f2fs_iget()

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to avoid panic in do_recover_data()

Miroslav Lichvar <mlichvar@redhat.com>
    ntp: Allow TAI-UTC offset to be set to zero

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pwm: meson: Use the spin-lock only to protect register modifications

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Don't use ignore flag for fake jumps

Matt Redfearn <matt.redfearn@thinci.com>
    drm/bridge: adv7511: Fix low refresh rate selection

Stephane Eranian <eranian@google.com>
    perf/x86/intel: Allow PEBS multi-entry in watermark mode

Tony Lindgren <tony@atomide.com>
    mfd: twl6040: Fix device init errors for ACCCTL register

Binbin Wu <binbin.wu@intel.com>
    mfd: intel-lpss: Set the device in reset state when init

Daniel Gomez <dagmcr@gmail.com>
    mfd: tps65912-spi: Add missing of table registration

Amit Kucheria <amit.kucheria@linaro.org>
    drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Cyrill Gorcunov <gorcunov@gmail.com>
    kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Qian Cai <cai@lca.pw>
    mm/slab.c: fix an infinite loop in leaks_show()

Yue Hu <huyue2@yulong.com>
    mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

Yue Hu <huyue2@yulong.com>
    mm/cma.c: fix crash on CMA allocation if bitmap allocation fails

Linxu Fang <fanglinxu@huawei.com>
    mem-hotplug: fix node spanned pages when we have a node with only ZONE_MOVABLE

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: on restore reserve error path retain subpool reservation

Arnd Bergmann <arnd@arndb.de>
    ARM: prevent tracing IPI_CPU_BACKTRACE

Li Rongqing <lirongqing@baidu.com>
    ipc: prevent lockup on alloc_msg and free_msg

Christian Brauner <christian@brauner.io>
    sysctl: return -EINVAL if val violates minmax

Hou Tao <houtao1@huawei.com>
    fs/fat/file.c: issue flush after the writeback of FAT

Kangjie Lu <kjlu@umn.edu>
    rapidio: fix a NULL pointer dereference when create_workqueue() fails


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  2 ++
 arch/arm/boot/dts/imx6qdl.dtsi                     |  2 +-
 arch/arm/boot/dts/imx6sl.dtsi                      |  2 +-
 arch/arm/boot/dts/imx6sx.dtsi                      |  2 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |  2 +-
 arch/arm/boot/dts/imx7s.dtsi                       |  4 +--
 arch/arm/include/asm/hardirq.h                     |  1 +
 arch/arm/kernel/smp.c                              |  6 +++-
 arch/arm/mach-exynos/suspend.c                     | 19 ++++++++++++
 arch/arm64/mm/mmu.c                                | 11 +++++--
 arch/ia64/mm/numa.c                                |  1 +
 arch/powerpc/include/asm/kvm_host.h                |  1 +
 arch/powerpc/kvm/book3s.c                          |  1 +
 arch/powerpc/kvm/book3s_hv.c                       |  9 +-----
 arch/powerpc/kvm/book3s_rtas.c                     | 14 ++++-----
 arch/s390/kvm/kvm-s390.c                           | 35 +++++++++++++---------
 arch/um/kernel/time.c                              |  2 +-
 arch/x86/events/intel/core.c                       |  2 +-
 arch/x86/events/intel/ds.c                         | 28 ++++++++---------
 arch/x86/kernel/cpu/amd.c                          |  7 +++--
 arch/x86/kvm/pmu_intel.c                           | 13 ++++----
 arch/x86/pci/irq.c                                 | 10 +++++--
 drivers/ata/libata-core.c                          |  9 ++++--
 drivers/clk/rockchip/clk-rk3288.c                  | 11 +++++++
 drivers/dma/idma64.c                               |  6 ++--
 drivers/dma/idma64.h                               |  2 ++
 drivers/gpio/Kconfig                               |  1 +
 drivers/gpio/gpio-omap.c                           | 25 +++++++++++-----
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  6 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  7 ++++-
 drivers/i2c/busses/i2c-acorn.c                     |  1 +
 drivers/i2c/i2c-dev.c                              |  1 +
 drivers/iommu/intel-iommu.c                        |  7 +++--
 drivers/isdn/mISDN/socket.c                        |  5 ++--
 drivers/md/bcache/bset.c                           | 16 ++++++++--
 drivers/md/bcache/bset.h                           | 34 ++++++++++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c               | 17 ++++++++++-
 drivers/mfd/intel-lpss.c                           |  3 ++
 drivers/mfd/tps65912-spi.c                         |  1 +
 drivers/mfd/twl6040.c                              | 13 +++++++-
 drivers/misc/kgdbts.c                              |  4 +--
 drivers/net/ethernet/dec/tulip/de4x5.c             |  1 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 +++
 drivers/net/ethernet/renesas/sh_eth.c              |  4 +++
 drivers/net/usb/ipheth.c                           |  3 +-
 drivers/nvmem/core.c                               | 15 ++++++----
 drivers/pci/host/pcie-rcar.c                       | 10 +++++--
 drivers/pci/host/pcie-xilinx.c                     | 12 ++++++--
 drivers/pci/hotplug/rpadlpar_core.c                |  4 +++
 drivers/platform/chrome/cros_ec_proto.c            | 11 +++++++
 drivers/platform/x86/intel_pmc_ipc.c               |  6 +++-
 drivers/pwm/core.c                                 | 10 +++----
 drivers/pwm/pwm-meson.c                            | 25 +++++++++++-----
 drivers/pwm/pwm-tiehrpwm.c                         |  2 ++
 drivers/pwm/sysfs.c                                | 14 +--------
 drivers/rapidio/rio_cm.c                           |  8 +++++
 drivers/rtc/rtc-pcf8523.c                          | 32 +++++++++++++++-----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |  4 +++
 drivers/scsi/libsas/sas_expander.c                 |  2 ++
 drivers/scsi/lpfc/lpfc_els.c                       |  5 +++-
 drivers/scsi/smartpqi/smartpqi_init.c              |  2 +-
 drivers/soc/mediatek/mtk-pmic-wrap.c               |  2 +-
 drivers/spi/spi-pxa2xx.c                           |  7 +----
 .../interface/vchiq_arm/vchiq_2835_arm.c           |  9 ------
 drivers/thermal/qcom/tsens.c                       |  3 +-
 drivers/tty/serial/8250/8250_dw.c                  |  4 +--
 drivers/tty/serial/sunhv.c                         |  2 +-
 drivers/usb/core/quirks.c                          |  3 ++
 drivers/usb/dwc2/hcd.c                             | 10 +++++--
 drivers/usb/serial/option.c                        |  6 ++++
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  3 ++
 drivers/usb/storage/unusual_realtek.h              |  5 ++++
 drivers/video/fbdev/hgafb.c                        |  2 ++
 drivers/video/fbdev/imsttfb.c                      |  5 ++++
 drivers/watchdog/Kconfig                           |  1 +
 drivers/watchdog/imx2_wdt.c                        |  4 ++-
 fs/configfs/dir.c                                  | 31 +++++++++++--------
 fs/f2fs/inode.c                                    |  1 +
 fs/f2fs/recovery.c                                 | 10 ++++++-
 fs/f2fs/segment.h                                  |  3 +-
 fs/fat/file.c                                      | 11 +++++--
 fs/fuse/dev.c                                      |  2 +-
 fs/inode.c                                         |  9 ++++--
 fs/nfsd/vfs.h                                      |  5 +++-
 fs/ocfs2/dcache.c                                  | 12 ++++++++
 include/linux/cgroup.h                             | 10 +++++--
 include/linux/pwm.h                                |  5 ----
 include/net/bluetooth/hci_core.h                   |  3 --
 ipc/mqueue.c                                       | 10 +++++--
 ipc/msgutil.c                                      |  6 ++++
 kernel/Makefile                                    |  1 +
 kernel/cred.c                                      |  9 ++++++
 kernel/events/ring_buffer.c                        | 33 +++++++++++++++++---
 kernel/ptrace.c                                    | 20 +++++++++++--
 kernel/sys.c                                       |  2 +-
 kernel/sysctl.c                                    |  6 ++--
 kernel/time/ntp.c                                  |  2 +-
 mm/cma.c                                           |  4 ++-
 mm/cma_debug.c                                     |  2 +-
 mm/hugetlb.c                                       | 21 +++++++++----
 mm/list_lru.c                                      |  2 +-
 mm/page_alloc.c                                    |  6 ++--
 mm/slab.c                                          |  6 +++-
 net/ax25/ax25_route.c                              |  2 ++
 net/bluetooth/hci_conn.c                           |  8 -----
 net/core/neighbour.c                               |  7 +++++
 net/ipv6/ip6_flowlabel.c                           |  7 +++--
 net/lapb/lapb_iface.c                              |  1 +
 sound/core/seq/seq_clientmgr.c                     | 10 ++-----
 sound/core/seq/seq_ports.c                         | 15 ++++++----
 sound/core/seq/seq_ports.h                         |  5 ++--
 sound/firewire/oxfw/oxfw.c                         |  3 --
 sound/pci/hda/hda_intel.c                          |  6 ++--
 sound/soc/codecs/cs42xx8.c                         |  1 +
 sound/soc/fsl/fsl_asrc.c                           |  4 +--
 tools/objtool/check.c                              |  8 +++--
 tools/perf/arch/s390/util/machine.c                |  9 ++++--
 tools/perf/util/data-convert-bt.c                  |  2 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |  6 +++-
 tools/testing/selftests/timers/adjtick.c           |  1 +
 tools/testing/selftests/timers/leapcrash.c         |  1 +
 tools/testing/selftests/timers/mqueue-lat.c        |  1 +
 tools/testing/selftests/timers/nanosleep.c         |  1 +
 tools/testing/selftests/timers/nsleep-lat.c        |  1 +
 tools/testing/selftests/timers/raw_skew.c          |  1 +
 tools/testing/selftests/timers/set-tai.c           |  1 +
 tools/testing/selftests/timers/set-tz.c            |  2 ++
 tools/testing/selftests/timers/threadtest.c        |  1 +
 tools/testing/selftests/timers/valid-adjtimex.c    |  2 ++
 133 files changed, 646 insertions(+), 284 deletions(-)


