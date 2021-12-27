Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1847FF78
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbhL0Phr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:37:47 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40616 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbhL0Pgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A4FACE10CB;
        Mon, 27 Dec 2021 15:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DB3C36AEB;
        Mon, 27 Dec 2021 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619398;
        bh=YwtNzq8KFsN/B53wSY4HtjMukQPTOiOUvTFcQMHroB0=;
        h=From:To:Cc:Subject:Date:From;
        b=FEd2XNm8XkHotI7qV8JPqdVOVcjUCu7A4srlhYgfyDyn2lsVDuh/gakZxFzsQXcOk
         1gCvoX4hOPFmwEiItUFpw/tdZDHAm37qE5/t3rv/G4Vr6A7BEJGKhuP4NLyRSlhI37
         lvSwzbYhHEQSSxVq+Ldjf1JRMFQT7wQgXVtEYsI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/76] 5.10.89-rc1 review
Date:   Mon, 27 Dec 2021 16:30:15 +0100
Message-Id: <20211227151324.694661623@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.89-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.89-rc1
X-KernelTest-Deadline: 2021-12-29T15:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.89 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.89-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.89-rc1

Rémi Denis-Courmont <remi@remlab.net>
    phonet/pep: refuse to enable an unbound pipe

Lin Ma <linma@zju.edu.cn>
    hamradio: improve the incomplete fix to avoid NPD

Lin Ma <linma@zju.edu.cn>
    hamradio: defer ax25 kfree after unregister_netdev

Lin Ma <linma@zju.edu.cn>
    ax25: NPD bug when detaching AX25 device

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Do not report 'busy' status bit as alarm

Guenter Roeck <linux@roeck-us.net>
    hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681

Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>
    pinctrl: mediatek: fix global-out-of-bounds issue

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682: fix the wrong jack type detected

Martin Povišer <povik@protonmail.com>
    ASoC: tas2770: Fix setting of high sample rates

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add id->model mapping for the "9111" model

Samuel Čavoj <samuel@cavoj.net>
    Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Johnny Chuang <johnny.chuang.emc@gmail.com>
    Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312

Andrey Ryabinin <arbn@yandex-team.com>
    mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix race in setting MAC address in setup phase

Christian Brauner <christian.brauner@ubuntu.com>
    ceph: fix up non-directory creation in SGID directories

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix incorrect page free bug

Liu Shixin <liushixin2@huawei.com>
    mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix locking in ieee80211_start_ap error path

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling

Yann Gautier <yann.gautier@foss.st.com>
    mmc: mmci: stm32: clear DLYB_CR after sending tuning command

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Disable card detect during shutdown

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    mmc: meson-mx-sdhc: Set MANUAL_STOP for multi-block SDIO commands

Prathamesh Shete <pshete@nvidia.com>
    mmc: sdhci-tegra: Fix switch to HS400ES mode

Noralf Trønnes <noralf@tronnes.org>
    gpio: dln2: Fix interrupts when replugging the device

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: consider the GPIO offset to expose all the GPIO lines

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU

Johan Hovold <johan@kernel.org>
    platform/x86: intel_pmc_core: fix memleak on registration failure

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/pkey: Fix undefined behaviour with PKRU_WD_BIT

Jens Wiklander <jens.wiklander@linaro.org>
    tee: handle lookup of shm with reference count 0

John David Anglin <dave.anglin@bell.net>
    parisc: Fix mask used to select futex spinlock

John David Anglin <dave.anglin@bell.net>
    parisc: Correct completer in lws start

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    ipmi: fix initialization when workqueue allocation fails

Mian Yousaf Kaukab <ykaukab@suse.de>
    ipmi: ssif: initialize ssif_info->client early

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    ipmi: bail out if init_srcu_struct fails

José Expósito <jose.exposito89@gmail.com>
    Input: atmel_mxt_ts - fix double free in mxt_read_info_block

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: aiu: Move AIU_I2S_MISC hold setting to aiu-fifo-i2s

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Fix quirk for Clevo NJ51CU

Bradley Scott <bscott@teksavvy.com>
    ALSA: hda/realtek: Add new alc285-hp-amp-init model

Bradley Scott <Bradley.Scott@zebra.com>
    ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6

Colin Ian King <colin.i.king@gmail.com>
    ALSA: drivers: opl3: Fix incorrect use of vp->state

Xiaoke Wang <xkernel.wang@foxmail.com>
    ALSA: jack: Check the return value of kstrdup()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Drop critical attribute support for MAX6654

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Introduce flag indicating extended temperature support

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Add basic support for TI TMP461

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix usage of CONFIG2 register in detect function

Phil Elwell <phil@raspberrypi.com>
    pinctrl: bcm2835: Change init order for gpio hogs

Andrea Righi <andrea.righi@canonical.com>
    Input: elantech - fix stack out of bound access in elantech_change_report_id()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    sfc: falcon: Check null pointer of rx_queue->page_ring

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    sfc: Check null pointer of rx_queue->page_ring

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: ks8851: Check for error irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drivers: net: smc911x: Check for error irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fjes: Check for error irq

Fernando Fernandez Mancera <ffmancera@riseup.net>
    bonding: fix ad_actor_system option setting to default

Wu Bo <wubo40@huawei.com>
    ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Heiner Kallweit <hkallweit1@gmail.com>
    igb: fix deadlock caused by taking RTNL in RPM resume path

Willem de Bruijn <willemb@google.com>
    net: skip virtio_net_hdr_set_proto if protocol already set

Willem de Bruijn <willemb@google.com>
    net: accept UFOv6 packages in virtio_net_hdr_to_skb

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    qlcnic: potential dereference null pointer of rx_queue->page_ring

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: marvell: prestera: fix incorrect return of port_find

Martin Haaß <vvvrrooomm@gmail.com>
    ARM: dts: imx6qdl-wandboard: Fix Ethernet support

Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
    netfilter: fix regression in looped (broad|multi)cast's MAC handling

Jiacheng Shi <billsjc@sjtu.edu.cn>
    RDMA/hns: Replace kfree() with kvfree()

José Expósito <jose.exposito89@gmail.com>
    IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: aiu: fifo: Add missing dma_coerce_mask_and_coherent()

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: change clk_disable_unprepare to clk_unprepare

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: potential dereference of null pointer

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: holtek: fix mouse probing

Zhang Yi <yi.zhang@huawei.com>
    ext4: check for inconsistent extents between index and leaf block

Zhang Yi <yi.zhang@huawei.com>
    ext4: check for out-of-order index extents in ext4_valid_extent_entries()

Zhang Yi <yi.zhang@huawei.com>
    ext4: prevent partial update of the extent blocks

Greg Jesionowski <jesionowskigreg@gmail.com>
    net: usb: lan78xx: add Allied Telesis AT29M2-AF

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: require CROSS_COMPILE_COMPAT for gcc+bfd

Nick Desaulniers <ndesaulniers@google.com>
    arm64: vdso32: drop -no-integrated-as flag


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   8 +-
 Documentation/hwmon/lm90.rst                       |  10 ++
 Documentation/networking/bonding.rst               |  11 +-
 Documentation/sound/hd-audio/models.rst            |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi           |   1 +
 arch/arm/kernel/entry-armv.S                       |   8 +-
 arch/arm64/Kconfig                                 |   3 +-
 .../dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |   2 +-
 arch/arm64/kernel/vdso32/Makefile                  |  25 +--
 arch/parisc/include/asm/futex.h                    |   4 +-
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/x86/include/asm/pgtable.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |   3 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  21 ++-
 drivers/char/ipmi/ipmi_ssif.c                      |   7 +-
 drivers/gpio/gpio-dln2.c                           |  19 ++-
 drivers/hid/hid-holtek-mouse.c                     |  15 ++
 drivers/hid/hid-vivaldi.c                          |   3 +
 drivers/hwmon/Kconfig                              |   2 +-
 drivers/hwmon/lm90.c                               | 171 +++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   2 +-
 drivers/input/mouse/elantech.c                     |   8 +-
 drivers/input/serio/i8042-x86ia64io.h              |   7 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/elants_i2c.c             |  46 +++++-
 drivers/input/touchscreen/goodix.c                 |   1 +
 drivers/mmc/core/core.c                            |   7 +-
 drivers/mmc/core/core.h                            |   1 +
 drivers/mmc/core/host.c                            |   9 ++
 drivers/mmc/host/meson-mx-sdhc-mmc.c               |  16 ++
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   2 +
 drivers/mmc/host/sdhci-tegra.c                     |  43 ++++--
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 ++-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  16 +-
 drivers/net/ethernet/micrel/ks8851_par.c           |   2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  12 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   4 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |   5 +-
 drivers/net/ethernet/sfc/rx_common.c               |   5 +-
 drivers/net/ethernet/smsc/smc911x.c                |   5 +
 drivers/net/fjes/fjes_main.c                       |   5 +
 drivers/net/hamradio/mkiss.c                       |   5 +-
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  29 ++--
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   8 +-
 drivers/platform/x86/intel_pmc_core_pltdrv.c       |   2 +-
 drivers/spi/spi-armada-3700.c                      |   2 +-
 drivers/tee/optee/shm_pool.c                       |   6 +-
 drivers/tee/tee_shm.c                              | 171 ++++++++-------------
 drivers/usb/gadget/function/u_ether.c              |  15 +-
 fs/ceph/file.c                                     |  18 ++-
 fs/ext4/extents.c                                  |  93 +++++++----
 fs/f2fs/xattr.c                                    |  11 +-
 include/linux/tee_drv.h                            |   4 +-
 include/linux/virtio_net.h                         |  25 ++-
 mm/memory-failure.c                                |   1 +
 mm/mempolicy.c                                     |   4 +-
 net/ax25/af_ax25.c                                 |   4 +-
 net/mac80211/cfg.c                                 |   3 +
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +-
 net/phonet/pep.c                                   |   2 +
 sound/core/jack.c                                  |   4 +
 sound/drivers/opl3/opl3_midi.c                     |   2 +-
 sound/pci/hda/patch_realtek.c                      |  28 +++-
 sound/soc/codecs/rt5682.c                          |   4 +
 sound/soc/codecs/tas2770.c                         |   4 +-
 sound/soc/meson/aiu-encoder-i2s.c                  |  33 ----
 sound/soc/meson/aiu-fifo-i2s.c                     |  19 +++
 sound/soc/meson/aiu-fifo.c                         |   6 +
 75 files changed, 677 insertions(+), 394 deletions(-)


