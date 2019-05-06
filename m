Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8955A14E89
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEFPDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfEFOkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4861120449;
        Mon,  6 May 2019 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153602;
        bh=SofiXO+SGNFIaUAvA4V9kKlQR/HbHAiR/KeNV2dtSGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WNdjvrQBKOMlRzj79ZR5BzvLyfcENTPvQRXY8UeNfiP5ne2LS9XI1fYIV7Hi/PELa
         iHVxt0BpwLFoj9cNXC4ZUeVn2RHJvotVExw/YayA5hARPAOc6nT6QausgHy0nOGOEq
         h4XoxGdi/oXNPS6lKsExB1UQ/WpuOVC9TNNUdfa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/99] 4.19.41-stable review
Date:   Mon,  6 May 2019 16:31:33 +0200
Message-Id: <20190506143053.899356316@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.41-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.41-rc1
X-KernelTest-Deadline: 2019-05-08T14:31+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.41 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 08 May 2019 02:29:12 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.41-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.41-rc1

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: v4l2: i2c: ov7670: Fix PLL bypass register values

Nicolas Le Bayon <nicolas.le.bayon@st.com>
    i2c: i2c-stm32f7: Fix SDADEL minimum formula

Peter Zijlstra <peterz@infradead.org>
    x86/mm/tlb: Revert "x86/mm: Align TLB invalidation info"

Qian Cai <cai@lca.pw>
    x86/mm: Fix a crash with kmemleak_scan()

Baoquan He <bhe@redhat.com>
    x86/mm/KASLR: Fix the size of the direct mapping section

David Müller <dave.mueller@gmx.ch>
    clk: x86: Add system specific quirk to mark clocks as critical

Tony Luck <tony.luck@intel.com>
    x86/mce: Improve error message when kernel cannot recover, p2

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mm/hash: Handle mmap_min_addr correctly in get_unmapped_area topdown search

Alexander Wetzel <alexander@wetzel-home.de>
    mac80211: Honor SW_CRYPTO_CONTROL for unicast keys in AP VLAN mode

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: never allow relabeling on context mounts

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: avoid silent denials in permissive mode under RCU walk

Anson Huang <anson.huang@nxp.com>
    gpio: mxc: add check to return defer probe if clock tree NOT ready

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - acknowledge that setting brightness is a blocking call

Anson Huang <anson.huang@nxp.com>
    Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ

Yuval Avnery <yuvalav@mellanox.com>
    IB/core: Destroy QP if XRC QP fails

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Fix potential memory leak while creating MAD agents

Daniel Jurgens <danielj@mellanox.com>
    IB/core: Unregister notifier before freeing MAD security

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    platform/x86: intel_pmc_core: Handle CFL regmap properly

Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
    platform/x86: intel_pmc_core: Fix PCH IP name

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    ASoC: stm32: fix sai driver name initialisation

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm_adsp: Correct handling of compressed streams that restart

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5651: Revert "Fix DMIC map headsetmic mapping"

Bart Van Assche <bvanassche@acm.org>
    scsi: RDMA/srpt: Fix a credit leak for aborted commands

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac write calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: fix the dac read calculation

Jeremy Fertic <jeremyfertic@gmail.com>
    staging: iio: adt7316: allow adt751x to use internal vref for all dacs

Jeffrey Hugo <jhugo@codeaurora.org>
    clk: qcom: Add missing freq for usb30_master_clk on 8998

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: mediatek: fix up an error path to restore bdev->tx_state

Brian Norris <briannorris@chromium.org>
    Bluetooth: btusb: request wake pin with NOAUTOEN

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Update generic hardware cache events for Family 17h

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    block: pass no-op callback to INIT_WORK().

Arnd Bergmann <arnd@arndb.de>
    ARM: iop: don't use using 64-bit DMA masks

Arnd Bergmann <arnd@arndb.de>
    ARM: orion: don't use using 64-bit DMA masks

Kirill Smelkov <kirr@nexedi.com>
    fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock

Guenter Roeck <linux@roeck-us.net>
    xsysace: Fix error handling in ace_setup

Randy Dunlap <rdunlap@infradead.org>
    sh: fix multiple function definition build errors

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: fix memory leak for resv_map

Catalin Marinas <catalin.marinas@arm.com>
    kmemleak: powerpc: skip scanning holes in the .bss section

David Rientjes <rientjes@google.com>
    KVM: SVM: prevent DBG_DECRYPT and DBG_ENCRYPT overflow

Varun Prakash <varun@chelsio.com>
    libcxgb: fix incorrect ppmax calculation

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix WARNING when remove HNS driver with SMMU enabled

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: fix ICMP6 neighbor solicitation messages discard problem

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Fix probabilistic memory overwrite when HNS driver initialized

Yonglong Liu <liuyonglong@huawei.com>
    net: hns: Use NAPI_POLL_WEIGHT for hns driver

Liubin Shu <shuliubin@huawei.com>
    net: hns: fix KASAN: use-after-free in hns_nic_net_xmit_hw()

Wei Li <liwei391@huawei.com>
    arm64: fix wrong check of on_sdei_stack in nmi context

Peng Hao <peng.hao2@zte.com.cn>
    arm/mach-at91/pm : fix possible object reference leak

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix calculation of sub-channel count

Xose Vazquez Perez <xose.vazquez@gmail.com>
    scsi: core: add new RDAC LENOVO/DE_Series device

Louis Taylor <louis@kragniz.eu>
    vfio/pci: use correct format characters

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: input: add mapping for Assistant key

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: da9063: set uie_unsupported when relevant

Shenghui Wang <shhuiw@foxmail.com>
    block: use blk_free_flush_queue() to free hctx->fq in blk_mq_init_hctx

Andreas Kemnade <andreas@kemnade.info>
    mfd: twl-core: Disable IRQ while suspended

Al Viro <viro@zeniv.linux.org.uk>
    debugfs: fix use-after-free on symlink traversal

Al Viro <viro@zeniv.linux.org.uk>
    jffs2: fix use-after-free on symlink traversal

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't log oversized frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: fix dropping of multi-descriptor RX frames

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't overwrite discard_frame status

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: don't stop NAPI processing when dropping a packet

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: ratelimit RX error logs

Aaro Koskinen <aaro.koskinen@nokia.com>
    net: stmmac: use correct DMA buffer size in the RX descriptor

Konstantin Khorenko <khorenko@virtuozzo.com>
    bonding: show full hw address in sysfs for slave entries

Omri Kahalon <omrik@mellanox.com>
    net/mlx5: E-Switch, Fix esw manager vport indication for more vport commands

Xi Wang <wangxi11@huawei.com>
    net: hns3: fix compile error

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    HID: quirks: Fix keyboard + touchpad on Lenovo Miix 630

Alan Kao <alankao@andestech.com>
    riscv: fix accessing 8-byte variable from RV32

Arvind Sankar <niveditas98@gmail.com>
    igb: Fix WARN_ONCE on runtime suspend

Axel Lin <axel.lin@ingics.com>
    reset: meson-audio-arb: Fix missing .owner setting of reset_controller_dev

Douglas Anderson <dianders@chromium.org>
    ARM: dts: rockchip: Fix gpu opp node names for rk3288

Anders Roxell <anders.roxell@linaro.org>
    batman-adv: fix warning in function batadv_v_elp_get_throughput

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_global hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce tt_local hash refcnt only for removed entry

Sven Eckelmann <sven@narfation.org>
    batman-adv: Reduce claim hash refcnt only for removed entry

Geert Uytterhoeven <geert+renesas@glider.be>
    rtc: sh: Fix invalid alarm warning for non-enabled alarm

Stephen Boyd <swboyd@chromium.org>
    rtc: cros-ec: Fail suspend/resume if wake IRQ can't be configured

He, Bo <bo.he@intel.com>
    HID: debug: fix race condition with between rdesc_show() and device removal

Kangjie Lu <kjlu@umn.edu>
    HID: logitech: check the return value of create_singlethread_workqueue

Leonidas P. Papadakos <papadakospan@gmail.com>
    arm64: dts: rockchip: fix rk3328-roc-cc gmac2io tx/rx_delay

Waiman Long <longman@redhat.com>
    efi: Fix debugobjects warning on 'efi_rts_work'

Yufen Yu <yuyufen@huawei.com>
    nvme-loop: init nvmet_ctrl fatal_err_work when allocate

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug caused by duplicate interface PM usage counter

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix unterminated string returned by usb_string()

Malte Leip <malte@leip.net>
    usb: usbip: fix isoc packet num validation in get_pipe

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix failure to give back unlinked URBs

Alan Stern <stern@rowland.harvard.edu>
    USB: w1 ds2490: Fix bug caused by improper use of altsetting array

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix protection fault after device removal

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply the fixup for ASUS Q325UAR

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Dell AIO speaker noise

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new Dell platform for headset mode

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: Prevent runtime suspend of adapter when Host Notify is required

Jim Broadus <jbroadus@gmail.com>
    i2c: Allow recovery of the initial IRQ by an I2C client device.

Charles Keepax <ckeepax@opensource.cirrus.com>
    i2c: Clear client->irq in i2c_device_remove

Charles Keepax <ckeepax@opensource.cirrus.com>
    i2c: Remove unnecessary call to irq_find_mapping

Anson Huang <anson.huang@nxp.com>
    i2c: imx: correct the method of getting private data in notifier_call

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    i2c: synquacer: fix enumeration of slave devices

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't attempt to rename ERR_PTR() debugfs dirs

Douglas Anderson <dianders@chromium.org>
    mwifiex: Make resume actually do something useful again on SDIO cards

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix driver operation for 5350


-------------

Diffstat:

 Documentation/driver-api/usb/power-management.rst  |  14 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |  12 +-
 arch/arm/mach-at91/pm.c                            |   6 +-
 arch/arm/mach-iop13xx/setup.c                      |   8 +-
 arch/arm/mach-iop13xx/tpmi.c                       |  10 +-
 arch/arm/plat-iop/adma.c                           |   6 +-
 arch/arm/plat-orion/common.c                       |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts     |   4 +-
 arch/arm64/kernel/sdei.c                           |   6 +
 arch/powerpc/kernel/kvm.c                          |   7 +
 arch/powerpc/mm/slice.c                            |  10 +-
 arch/riscv/include/asm/uaccess.h                   |   2 +-
 arch/sh/boards/of-generic.c                        |   4 +-
 arch/x86/events/amd/core.c                         | 111 ++++++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c          |   5 +
 arch/x86/kvm/svm.c                                 |  12 +-
 arch/x86/mm/init.c                                 |   6 +
 arch/x86/mm/kaslr.c                                |   2 +-
 arch/x86/mm/tlb.c                                  |   2 +-
 block/blk-core.c                                   |   6 +-
 block/blk-mq.c                                     |   2 +-
 drivers/block/xsysace.c                            |   2 +
 drivers/bluetooth/btmtkuart.c                      |   2 +
 drivers/bluetooth/btusb.c                          |   2 +-
 drivers/clk/qcom/gcc-msm8998.c                     |   1 +
 drivers/clk/x86/clk-pmc-atom.c                     |  14 +-
 drivers/firmware/efi/runtime-wrappers.c            |   2 +-
 drivers/gpio/gpio-mxc.c                            |   5 +-
 drivers/hid/hid-debug.c                            |   5 +
 drivers/hid/hid-input.c                            |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   8 +-
 drivers/hid/hid-quirks.c                           |   5 +-
 drivers/i2c/busses/i2c-imx.c                       |   4 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +
 drivers/i2c/i2c-core-base.c                        |  18 +-
 drivers/infiniband/core/security.c                 |  11 +-
 drivers/infiniband/core/verbs.c                    |  41 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  11 +
 drivers/input/keyboard/snvs_pwrkey.c               |   6 +-
 drivers/input/touchscreen/stmfts.c                 |  30 +-
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/mfd/twl-core.c                             |  23 ++
 drivers/net/bonding/bond_sysfs_slave.c             |   4 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c |   9 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  33 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |  12 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |   2 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   2 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  57 +---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |  22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  22 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |  12 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  34 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |   3 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/nvme/target/core.c                         |  20 +-
 drivers/platform/x86/intel_pmc_core.c              |   4 +-
 drivers/platform/x86/pmc_atom.c                    |  21 ++
 drivers/reset/reset-meson-audio-arb.c              |   1 +
 drivers/rtc/rtc-cros-ec.c                          |   4 +-
 drivers/rtc/rtc-da9063.c                           |   7 +
 drivers/rtc/rtc-sh.c                               |   2 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_dh.c                             |   1 +
 drivers/scsi/storvsc_drv.c                         |  13 +-
 drivers/staging/iio/addac/adt7316.c                |  22 +-
 drivers/usb/core/driver.c                          |  13 -
 drivers/usb/core/message.c                         |   4 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  19 +-
 drivers/usb/misc/yurex.c                           |   1 +
 drivers/usb/storage/realtek_cr.c                   |  13 +-
 drivers/usb/usbip/stub_rx.c                        |  12 +-
 drivers/usb/usbip/usbip_common.h                   |   7 +
 drivers/vfio/pci/vfio_pci.c                        |   4 +-
 drivers/w1/masters/ds2490.c                        |   6 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   4 +-
 fs/debugfs/inode.c                                 |  13 +-
 fs/hugetlbfs/inode.c                               |  20 +-
 fs/jffs2/readinode.c                               |   5 -
 fs/jffs2/super.c                                   |   5 +-
 fs/open.c                                          |  18 +
 fs/read_write.c                                    |   5 +-
 include/linux/fs.h                                 |   4 +
 include/linux/i2c.h                                |   1 +
 include/linux/platform_data/x86/clk-pmc-atom.h     |   3 +
 include/linux/usb.h                                |   2 -
 mm/kmemleak.c                                      |  16 +-
 net/batman-adv/bat_v_elp.c                         |   6 +-
 net/batman-adv/bridge_loop_avoidance.c             |  16 +-
 net/batman-adv/translation-table.c                 |  32 +-
 net/mac80211/debugfs_netdev.c                      |   2 +-
 net/mac80211/key.c                                 |   9 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++++++
 security/selinux/avc.c                             |  23 +-
 security/selinux/hooks.c                           |  44 ++-
 security/selinux/include/avc.h                     |   1 +
 sound/pci/hda/patch_realtek.c                      |  13 +
 sound/soc/codecs/wm_adsp.c                         |   3 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |   2 +-
 sound/soc/stm/stm32_sai_sub.c                      |   2 +-
 109 files changed, 1125 insertions(+), 350 deletions(-)


