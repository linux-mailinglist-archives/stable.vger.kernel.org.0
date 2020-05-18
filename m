Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94D71D81DC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgERRv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730860AbgERRvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318A32083E;
        Mon, 18 May 2020 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824284;
        bh=suizgqnfNPmIPvPNa7tKCyv0Jp3Gbtl1MSa41kN93ks=;
        h=From:To:Cc:Subject:Date:From;
        b=n57906JyfpCgMBOdATvaxGfmCz4lJM9BcUsX7vB+s3JURP85p+UFlPTVrIWBwR6nb
         QE/NlLLLPcs1kVnms1fTcIM6gmPdfIM64jHLMwgqOoFTNaUbStYk+meWi6wdaV95sx
         jtY1Q0/ct+bEyfC7CKWgEYWabqfAbcmnkC5YOsDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/80] 4.19.124-rc1 review
Date:   Mon, 18 May 2020 19:36:18 +0200
Message-Id: <20200518173450.097837707@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.124-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.124-rc1
X-KernelTest-Deadline: 2020-05-20T17:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.124 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.124-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.124-rc1

Sergei Trofimovich <slyfox@gentoo.org>
    Makefile: disallow data races on gcc-10 as well

Jim Mattson <jmattson@google.com>
    KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7740: Add missing extal2 to CPG node

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: r8a77980: Fix IPMMU VIP[01] nodes

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a73a4: Add missing CMT1 interrupts

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards

Marc Zyngier <maz@kernel.org>
    clk: Unlink clock if failed to prepare or enable

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Revert "ALSA: hda/realtek: Fix pop noise on ALC225"

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in cdc_bind()

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: legacy: fix error return code in gncm_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: audio: Fix a missing error return value in audio_bind()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: net2272: Fix a memory leak in an error handling path in 'net2272_plat_probe()'

John Stultz <john.stultz@linaro.org>
    dwc3: Remove check for HWO flag in dwc3_gadget_ep_reclaim_trb_sg()

Justin Swartz <justin.swartz@risingedge.co.za>
    clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Eric W. Biederman <ebiederm@xmission.com>
    exec: Move would_dump into flush_old_exec

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix error handling in __unwind_start()

Borislav Petkov <bp@suse.de>
    x86: Fix early boot crash on gcc-10, third try

Adam McCoy <adam@forsedomani.com>
    cifs: fix leaked reference on requeued write

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Fix bus_dma_limit for PCIe

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: xhci: Fix NULL pointer dereference when enqueuing trbs from urb sg list

Kyungtae Kim <kt0755@gmail.com>
    USB: gadget: fix illegal array access in binding with UDC

Li Jun <jun.li@nxp.com>
    usb: host: xhci-plat: keep runtime active when removing host

Eugeniu Rosca <erosca@de.adit-jv.com>
    usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B

Jesus Ramos <jesus-ramos@live.com>
    ALSA: usb-audio: Add control message quirk delay for Kingston HyperX headset

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Limit int mic boost for Thinkpad T530

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: avoid shadowing standard library 'free()' in crypto

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'restrict' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'stringop-overflow' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'array-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10: disable 'zero-length-bounds' warning for now

Linus Torvalds <torvalds@linux-foundation.org>
    Stop the ad-hoc games with -Wno-maybe-initialized

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: compute false-positive -Wmaybe-uninitialized cases in Kconfig

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-10 warnings: fix low-hanging fruit

Jason Gunthorpe <jgg@ziepe.ca>
    pnp: Use list_for_each_entry() instead of open coding

Samu Nuutamo <samu.nuutamo@vincit.fi>
    hwmon: (da9052) Synchronize access with mfd

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Test return value of calls to ib_get_cached_pkey

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()

Christoph Hellwig <hch@lst.de>
    arm64: fix the flush_icache_range arguments in machine_kexec

Arnd Bergmann <arnd@arndb.de>
    netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Dave Wysochanski <dwysocha@redhat.com>
    NFSv4: Fix fscache cookie aux_data to ensure change_attr is included

Arnd Bergmann <arnd@arndb.de>
    nfs: fscache: use timespec64 in inode auxdata

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix fscache super_cookie index_key from changing after umount

Adrian Hunter <adrian.hunter@intel.com>
    mmc: block: Fix request completion in the CQE timeout path

Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
    mmc: core: Check request type before completing the request

Dan Carpenter <dan.carpenter@oracle.com>
    i40iw: Fix error handling in i40iw_manage_arp_cache()

Grace Kao <grace.kao@intel.com>
    pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Another gfs2_walk_metadata fix

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek - Fix S3 pop noise on Dell Wyse

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Vasily Averin <vvs@virtuozzo.com>
    drm/qxl: lost qxl_bo_kunmap_atomic_page in qxl_image_init_helper()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda/hdmi: fix race in monitor detection during probe

Chris Wilson <chris@chris-wilson.co.uk>
    cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once

Lubomir Rintel <lkundrak@v3.sk>
    dmaengine: mmp_tdma: Reset channel error on release

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    dmaengine: pch_dma.c: Avoid data race between probe and irq handler

Ilie Halip <ilie.halip@gmail.com>
    riscv: fix vdso build with lld

Eric Dumazet <edumazet@google.com>
    tcp: fix SO_RCVLOWAT hangs with fat skbs

Kelly Littlepage <kelly@onechronos.com>
    net: tcp: fix rx timestamp behavior for tcp_recvmsg

Zefan Li <lizefan@huawei.com>
    netprio_cgroup: Fix unlimited memory leak of v2 cgroups

Paolo Abeni <pabeni@redhat.com>
    net: ipv4: really enforce backoff for redirects

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: loop: Add module soft dependency

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of ndo_stop

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix lockdep warning on 32 bit

Eric Dumazet <edumazet@google.com>
    tcp: fix error recovery in tcp_zerocopy_receive()

Maciej Żenczykowski <maze@google.com>
    Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Guillaume Nault <gnault@redhat.com>
    pppoe: only process PADT targeted at local interfaces

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix aneg restart in phy_ethtool_set_eee

Paolo Abeni <pabeni@redhat.com>
    netlabel: cope with NULL catmap

Cong Wang <xiyou.wangcong@gmail.com>
    net: fix a potential recursive NETDEV_FEAT_CHANGE

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: Add SDHCI_QUIRK2_BROKEN_64_BIT_DMA for AMDI0040

Wu Bo <wubo40@huawei.com>
    scsi: sg: add sg_remove_request in sg_write

Stefan Hajnoczi <stefanha@redhat.com>
    virtio-blk: handle block_device_operations callbacks after hot unplug

Arnd Bergmann <arnd@arndb.de>
    drop_monitor: work around gcc-10 stringop-overflow warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: moxa: Fix a potential double 'free_irq()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'

Hugh Dickins <hughd@google.com>
    shmem: fix possible deadlocks on shmlock_user_lock

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: Do not make user port errors fatal


-------------

Diffstat:

 Makefile                                          | 25 ++++---
 arch/arm/boot/dts/dra7.dtsi                       |  4 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts  |  4 +-
 arch/arm/boot/dts/r8a73a4.dtsi                    |  9 ++-
 arch/arm/boot/dts/r8a7740.dtsi                    |  2 +-
 arch/arm64/boot/dts/renesas/r8a77980.dtsi         |  2 +
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts       |  2 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts    |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi          |  4 +-
 arch/arm64/kernel/machine_kexec.c                 |  1 +
 arch/riscv/kernel/vdso/Makefile                   |  6 +-
 arch/x86/include/asm/stackprotector.h             |  7 +-
 arch/x86/kernel/smpboot.c                         |  8 +++
 arch/x86/kernel/unwind_orc.c                      | 16 +++--
 arch/x86/kvm/x86.c                                |  2 +-
 arch/x86/xen/smp_pv.c                             |  1 +
 crypto/lrw.c                                      |  4 +-
 crypto/xts.c                                      |  4 +-
 drivers/block/virtio_blk.c                        | 86 ++++++++++++++++++++---
 drivers/clk/clk.c                                 |  3 +
 drivers/clk/rockchip/clk-rk3228.c                 | 17 ++---
 drivers/cpufreq/intel_pstate.c                    |  2 +-
 drivers/dma/mmp_tdma.c                            |  2 +
 drivers/dma/pch_dma.c                             |  2 +-
 drivers/gpu/drm/qxl/qxl_image.c                   |  3 +-
 drivers/hwmon/da9052-hwmon.c                      |  4 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c            |  2 +-
 drivers/infiniband/hw/mlx4/qp.c                   | 14 +++-
 drivers/mmc/core/block.c                          |  3 +-
 drivers/mmc/core/queue.c                          |  3 +-
 drivers/mmc/host/sdhci-acpi.c                     | 10 +--
 drivers/net/dsa/dsa_loop.c                        |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 16 +++--
 drivers/net/ethernet/huawei/hinic/hinic_main.c    | 16 +----
 drivers/net/ethernet/moxa/moxart_ether.c          |  2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c          |  6 +-
 drivers/net/phy/phy.c                             |  8 ++-
 drivers/net/ppp/pppoe.c                           |  3 +
 drivers/net/virtio_net.c                          |  6 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c          |  1 +
 drivers/pinctrl/intel/pinctrl-cherryview.c        |  4 ++
 drivers/scsi/sg.c                                 |  4 +-
 drivers/usb/core/hub.c                            |  6 +-
 drivers/usb/dwc3/gadget.c                         |  3 -
 drivers/usb/gadget/configfs.c                     |  3 +
 drivers/usb/gadget/legacy/audio.c                 |  4 +-
 drivers/usb/gadget/legacy/cdc2.c                  |  4 +-
 drivers/usb/gadget/legacy/ncm.c                   |  4 +-
 drivers/usb/gadget/udc/net2272.c                  |  2 +
 drivers/usb/host/xhci-plat.c                      |  4 +-
 drivers/usb/host/xhci-ring.c                      |  4 +-
 fs/cifs/cifssmb.c                                 |  2 +-
 fs/exec.c                                         |  4 +-
 fs/gfs2/bmap.c                                    | 16 +++--
 fs/nfs/fscache-index.c                            |  6 +-
 fs/nfs/fscache.c                                  | 31 ++++----
 fs/nfs/fscache.h                                  |  8 ++-
 include/linux/compiler.h                          |  6 ++
 include/linux/fs.h                                |  2 +-
 include/linux/pnp.h                               | 29 +++-----
 include/linux/tty.h                               |  2 +-
 include/net/netfilter/nf_conntrack.h              |  2 +-
 include/net/tcp.h                                 | 13 ++++
 include/sound/rawmidi.h                           |  1 +
 init/main.c                                       |  2 +
 ipc/util.c                                        | 12 ++--
 mm/shmem.c                                        |  7 +-
 net/core/dev.c                                    |  4 +-
 net/core/drop_monitor.c                           | 11 +--
 net/core/netprio_cgroup.c                         |  2 +
 net/dsa/dsa2.c                                    |  2 +-
 net/ipv4/cipso_ipv4.c                             |  6 +-
 net/ipv4/route.c                                  |  2 +-
 net/ipv4/tcp.c                                    | 27 ++++---
 net/ipv4/tcp_input.c                              |  3 +-
 net/ipv6/calipso.c                                |  3 +-
 net/ipv6/route.c                                  |  6 +-
 net/netfilter/nf_conntrack_core.c                 |  4 +-
 net/netfilter/nft_set_rbtree.c                    | 17 +++--
 net/netlabel/netlabel_kapi.c                      |  6 ++
 sound/core/rawmidi.c                              | 31 ++++++--
 sound/pci/hda/patch_hdmi.c                        |  2 +
 sound/pci/hda/patch_realtek.c                     | 28 +++++++-
 sound/usb/quirks.c                                |  9 +--
 84 files changed, 452 insertions(+), 209 deletions(-)


