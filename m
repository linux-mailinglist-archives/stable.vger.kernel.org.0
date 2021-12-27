Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94987480032
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhL0Pnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbhL0Plk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5179AC061374;
        Mon, 27 Dec 2021 07:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7AC65CE10D7;
        Mon, 27 Dec 2021 15:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42725C36AEA;
        Mon, 27 Dec 2021 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619648;
        bh=G6Bxkr8X7KyqK2mE9lzK1EXEKLxdfDpWng1zAqW9WwM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZIE65s71l4HlLvt/rjlu13z4eJzcb716ekzt0Nwho80zQBCN7jjpzoXzKMCZ1oiD3
         iKlKFs+IsdihwyImwe83a1QWRmUfrkMsEMyoID6taINlLwDV7dC2HMUwiRkR6nYHJ/
         ad8OQ+NtLwN2TO0EBpzyKxTZdMDRZnLke0F/J/cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/128] 5.15.12-rc1 review
Date:   Mon, 27 Dec 2021 16:29:35 +0100
Message-Id: <20211227151331.502501367@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.12-rc1
X-KernelTest-Deadline: 2021-12-29T15:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.12 release.
There are 128 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.12-rc1

Rémi Denis-Courmont <remi@remlab.net>
    phonet/pep: refuse to enable an unbound pipe

George Kennedy <george.kennedy@oracle.com>
    tun: avoid double free in tun_free_netdev

Lin Ma <linma@zju.edu.cn>
    hamradio: improve the incomplete fix to avoid NPD

Lin Ma <linma@zju.edu.cn>
    hamradio: defer ax25 kfree after unregister_netdev

Lin Ma <linma@zju.edu.cn>
    ax25: NPD bug when detaching AX25 device

Hayes Wang <hayeswang@realtek.com>
    r8152: sync ocp base

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Do not report 'busy' status bit as alarm

Guenter Roeck <linux@roeck-us.net>
    hwmom: (lm90) Fix citical alarm status for MAX6680/MAX6681

Guodong Liu <guodong.liu@mediatek.corp-partner.google.com>
    pinctrl: mediatek: fix global-out-of-bounds issue

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682: fix the wrong jack type detected

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: pci-tgl: add ADL-N support

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: pci-tgl: add new ADL-P variant

Martin Povišer <povik@protonmail.com>
    ASoC: tas2770: Fix setting of high sample rates

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add id->model mapping for the "9111" model

Samuel Čavoj <samuel@cavoj.net>
    Input: i8042 - enable deferred probe quirk for ASUS UM325UA

Johnny Chuang <johnny.chuang.emc@gmail.com>
    Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312

Jeff LaBundy <jeff@labundy.com>
    Input: iqs626a - prohibit inlining of channel parsing functions

Baokun Li <libaokun1@huawei.com>
    kfence: fix memory leak when cat kfence objects

Zhang Ying-22455 <ying.zhang22455@nxp.com>
    arm64: dts: lx2160a: fix scl-gpios property name

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state

Jeffle Xu <jefflexu@linux.alibaba.com>
    netfs: fix parameter of cleanup()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on last xattr entry in __f2fs_setxattr()

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix incorrect page free bug

SeongJae Park <sj@kernel.org>
    mm/damon/dbgfs: protect targets destructions with kdamond_lock

Liu Shixin <liushixin2@huawei.com>
    mm/hwpoison: clear MF_COUNT_INCREASED before retrying get_any_page()

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm, hwpoison: fix condition in free hugetlb page path

Andrey Ryabinin <arbn@yandex-team.com>
    mm: mempolicy: fix THP allocations escaping mempolicy restrictions

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix locking in ieee80211_start_ap error path

Marcos Del Sol Vives <marcos@orca.pet>
    ksmbd: disable SMB2_GLOBAL_CAP_ENCRYPTION for SMB 3.1.1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix uninitialized symbol 'pntsd_size'

Dan Carpenter <dan.carpenter@oracle.com>
    ksmbd: fix error code in ndr_read_int32()

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

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Always clear vmx->fail on emulation_required

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Don't advance iterator after restart due to yielding

Marc Orr <marcorr@google.com>
    KVM: x86: Always set kvm_run->if_flag

Johan Hovold <johan@kernel.org>
    platform/x86: intel_pmc_core: fix memleak on registration failure

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86: amd-pmc: only use callbacks for suspend

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

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Restore headphones jack name on Nyan Big

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: Add DAPM switches for headphones and mic jack

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: aiu: Move AIU_I2S_MISC hold setting to aiu-fifo-i2s

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Fix quirk for Clevo NJ51CU

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Bradley Scott <bscott@teksavvy.com>
    ALSA: hda/realtek: Add new alc285-hp-amp-init model

Bradley Scott <Bradley.Scott@zebra.com>
    ALSA: hda/realtek: Amp init fixup for HP ZBook 15 G6

Ville Syrjälä <ville.syrjala@linux.intel.com>
    ALSA: hda/hdmi: Disable silent stream on GLK

Jaroslav Kysela <perex@perex.cz>
    ALSA: rawmidi - fix the uninitalized user_pversion

Colin Ian King <colin.i.king@gmail.com>
    ALSA: drivers: opl3: Fix incorrect use of vp->state

Xiaoke Wang <xkernel.wang@foxmail.com>
    ALSA: jack: Check the return value of kstrdup()

Mike Rapoport <rppt@kernel.org>
    x86/boot: Move EFI range reservation after cmdline parsing

Borislav Petkov <bp@suse.de>
    Revert "x86/boot: Pull up cmdline preparation and early param parsing"

Philipp Rudo <prudo@redhat.com>
    kernel/crash_core: suppress unknown crashkernel parameter warning

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86/intel: Remove X86_PLATFORM_DRIVERS_INTEL

Josh Poimboeuf <jpoimboe@redhat.com>
    compiler.h: Fix annotation macro misplacement with Clang

Ismael Luceno <ismael@iodev.co.uk>
    uapi: Fix undefined __always_inline on non-glibc systems

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 9160/1: NOMMU: Reload __secondary_data after PROCINFO_INITFUNC

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Drop critical attribute support for MAX6654

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Add basic support for TI TMP461

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Introduce flag indicating extended temperature support

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Prevent integer overflow/underflow in hysteresis calculations

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Fix usage of CONFIG2 register in detect function

Phil Elwell <phil@raspberrypi.com>
    pinctrl: bcm2835: Change init order for gpio hogs

Andrea Righi <andrea.righi@canonical.com>
    Input: elantech - fix stack out of bound access in elantech_change_report_id()

Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
    net: stmmac: dwmac-visconti: Fix value of ETHER_CLK_SEL_FREQ_SEL_2P5M

Hayes Wang <hayeswang@realtek.com>
    r8152: fix the force speed doesn't work for RTL8156

Remi Pommarel <repk@triplefau.lt>
    net: bridge: fix ioctl old_deviceless bridge argument

Gustavo A. R. Silva <gustavoars@kernel.org>
    net: bridge: Use array_size() helper in copy_to_user()

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: stmmac: ptp: fix potentially overflowing expression

Paolo Abeni <pabeni@redhat.com>
    veth: ensure skb entering GRO are not cloned.

Jens Axboe <axboe@kernel.dk>
    io_uring: zero iocb->ki_pos for stream file types

Pavel Skripkin <paskripkin@gmail.com>
    asix: fix wrong return value in asix_check_host_enable()

Pavel Skripkin <paskripkin@gmail.com>
    asix: fix uninit-value in asix_mdio_read()

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

Vincent Whitchurch <vincent.whitchurch@axis.com>
    gpio: virtio: remove timeout

Wu Bo <wubo40@huawei.com>
    ipmi: Fix UAF when uninstall ipmi_si and ipmi_msghandler module

Heiner Kallweit <hkallweit1@gmail.com>
    igb: fix deadlock caused by taking RTNL in RPM resume path

Willem de Bruijn <willemb@google.com>
    net: skip virtio_net_hdr_set_proto if protocol already set

Willem de Bruijn <willemb@google.com>
    net: accept UFOv6 packages in virtio_net_hdr_to_skb

Eric Dumazet <edumazet@google.com>
    inet: fully convert sk->sk_rx_dst to RCU rules

Eric Dumazet <edumazet@google.com>
    ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie

Eric Dumazet <edumazet@google.com>
    tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    qlcnic: potential dereference null pointer of rx_queue->page_ring

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: marvell: prestera: fix incorrect structure access

Yevhen Orlov <yevhen.orlov@plvision.eu>
    net: marvell: prestera: fix incorrect return of port_find

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: return xsk buffers back to pool when cleaning the ring

Magnus Karlsson <magnus.karlsson@intel.com>
    ice: Use xdp_buf instead of rx_buf for xsk zero-copy

Martin Haaß <vvvrrooomm@gmail.com>
    ARM: dts: imx6qdl-wandboard: Fix Ethernet support

Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
    netfilter: fix regression in looped (broad|multi)cast's MAC handling

Eric Dumazet <edumazet@google.com>
    netfilter: nf_tables: fix use-after-free in nft_set_catchall_destroy()

Jiacheng Shi <billsjc@sjtu.edu.cn>
    RDMA/hns: Replace kfree() with kvfree()

José Expósito <jose.exposito89@gmail.com>
    IB/qib: Fix memory leak in qib_user_sdma_queue_pkts()

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Fix RNR retransmission issue for HIP08

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: aiu: fifo: Add missing dma_coerce_mask_and_coherent()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: hdmi: Perform NULL pointer check for mtk_hdmi_conf

Alexey Gladkov <legion@kernel.org>
    ucounts: Fix rlimit max values check

Dongliang Mu <mudongliangabcd@gmail.com>
    spi: change clk_disable_unprepare to clk_unprepare

Jernej Skrabec <jernej.skrabec@gmail.com>
    bus: sunxi-rsb: Fix shutdown

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: allwinner: orangepi-zero-plus: fix PHY mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix error handling in dpm_prepare()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix READDIR buffer overflow

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: potential dereference of null pointer

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: holtek: fix mouse probing

Andrew Jones <drjones@redhat.com>
    selftests: KVM: Fix non-x86 compiling

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


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   8 +-
 Documentation/hwmon/lm90.rst                       |  10 ++
 Documentation/networking/bonding.rst               |  11 +-
 Documentation/sound/hd-audio/models.rst            |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi           |   1 +
 arch/arm/kernel/entry-armv.S                       |   8 +-
 arch/arm/kernel/head-nommu.S                       |   1 +
 arch/arm64/Kconfig                                 |   3 +-
 .../dts/allwinner/sun50i-h5-orangepi-zero-plus.dts |   2 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |   4 +-
 arch/arm64/kernel/vdso32/Makefile                  |  17 +-
 arch/parisc/include/asm/futex.h                    |   4 +-
 arch/parisc/kernel/syscall.S                       |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/pkru.h                        |   4 +-
 arch/x86/kernel/setup.c                            |  72 ++++-----
 arch/x86/kvm/mmu/tdp_iter.c                        |   6 +
 arch/x86/kvm/mmu/tdp_iter.h                        |   6 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |  29 ++--
 arch/x86/kvm/svm/svm.c                             |  21 +--
 arch/x86/kvm/vmx/vmx.c                             |  45 ++++--
 arch/x86/kvm/x86.c                                 |   9 +-
 drivers/base/power/main.c                          |   2 +-
 drivers/bus/sunxi-rsb.c                            |   8 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  21 ++-
 drivers/char/ipmi/ipmi_ssif.c                      |   7 +-
 drivers/gpio/gpio-dln2.c                           |  19 ++-
 drivers/gpio/gpio-virtio.c                         |   6 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |  12 +-
 drivers/hid/hid-holtek-mouse.c                     |  15 ++
 drivers/hid/hid-vivaldi.c                          |   3 +
 drivers/hwmon/Kconfig                              |   2 +-
 drivers/hwmon/lm90.c                               | 175 +++++++++++++--------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  64 +++++++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   8 +
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   2 +-
 drivers/input/misc/iqs626a.c                       |  21 +--
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
 drivers/mmc/host/sdhci-tegra.c                     |  43 +++--
 drivers/net/bonding/bond_options.c                 |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  16 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  64 ++++----
 drivers/net/ethernet/intel/igb/igb_main.c          |  19 ++-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  35 +++--
 drivers/net/ethernet/micrel/ks8851_par.c           |   2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  12 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   4 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |   5 +-
 drivers/net/ethernet/sfc/rx_common.c               |   5 +-
 drivers/net/ethernet/smsc/smc911x.c                |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/fjes/fjes_main.c                       |   5 +
 drivers/net/hamradio/mkiss.c                       |   5 +-
 drivers/net/tun.c                                  | 115 +++++++-------
 drivers/net/usb/asix_common.c                      |   8 +-
 drivers/net/usb/lan78xx.c                          |   6 +
 drivers/net/usb/r8152.c                            |  43 ++++-
 drivers/net/veth.c                                 |   8 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |  29 ++--
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   8 +-
 drivers/platform/x86/Makefile                      |   2 +-
 drivers/platform/x86/amd-pmc.c                     |   3 +-
 drivers/platform/x86/intel/Kconfig                 |  15 --
 drivers/platform/x86/intel/pmc/pltdrv.c            |   2 +-
 drivers/spi/spi-armada-3700.c                      |   2 +-
 drivers/tee/optee/shm_pool.c                       |   6 +-
 drivers/tee/tee_shm.c                              | 171 ++++++++------------
 fs/ext4/extents.c                                  |  95 +++++++----
 fs/f2fs/xattr.c                                    |  11 +-
 fs/io_uring.c                                      |  10 +-
 fs/ksmbd/ndr.c                                     |   2 +-
 fs/ksmbd/smb2ops.c                                 |   3 -
 fs/ksmbd/smb2pdu.c                                 |  29 +++-
 fs/netfs/read_helper.c                             |   6 +-
 fs/nfsd/nfs3proc.c                                 |  11 +-
 fs/nfsd/nfsproc.c                                  |   8 +-
 include/linux/compiler.h                           |   4 +-
 include/linux/instrumentation.h                    |   4 +-
 include/linux/ipv6.h                               |   1 -
 include/linux/tee_drv.h                            |   4 +-
 include/linux/virtio_net.h                         |  25 ++-
 include/net/inet_sock.h                            |   3 +-
 include/net/sock.h                                 |   7 +-
 include/uapi/linux/byteorder/big_endian.h          |   1 +
 include/uapi/linux/byteorder/little_endian.h       |   1 +
 kernel/crash_core.c                                |  11 ++
 kernel/ucount.c                                    |  15 +-
 mm/damon/dbgfs.c                                   |   2 +
 mm/kfence/core.c                                   |   1 +
 mm/memory-failure.c                                |  14 +-
 mm/mempolicy.c                                     |   3 +-
 net/ax25/af_ax25.c                                 |   4 +-
 net/bridge/br_ioctl.c                              |   8 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |  17 +-
 net/ipv4/udp.c                                     |   6 +-
 net/ipv6/tcp_ipv6.c                                |  23 +--
 net/ipv6/udp.c                                     |   8 +-
 net/mac80211/cfg.c                                 |   3 +
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |   3 +-
 net/netfilter/nfnetlink_queue.c                    |   3 +-
 net/phonet/pep.c                                   |   2 +
 sound/core/jack.c                                  |   4 +
 sound/core/rawmidi.c                               |   1 +
 sound/drivers/opl3/opl3_midi.c                     |   2 +-
 sound/pci/hda/patch_hdmi.c                         |  21 ++-
 sound/pci/hda/patch_realtek.c                      |  29 +++-
 sound/soc/codecs/rt5682.c                          |   4 +
 sound/soc/codecs/tas2770.c                         |   4 +-
 sound/soc/meson/aiu-encoder-i2s.c                  |  33 ----
 sound/soc/meson/aiu-fifo-i2s.c                     |  19 +++
 sound/soc/meson/aiu-fifo.c                         |   6 +
 sound/soc/sof/intel/pci-tgl.c                      |   4 +
 sound/soc/tegra/tegra_asoc_machine.c               |  11 +-
 sound/soc/tegra/tegra_asoc_machine.h               |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  10 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +
 135 files changed, 1181 insertions(+), 723 deletions(-)


