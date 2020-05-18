Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9151D86A8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgERS0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729444AbgERRpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A87820657;
        Mon, 18 May 2020 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823944;
        bh=W4pxxew7K9L5LFTqR8sHV37Eto2aFW3kIdsutUY3lBU=;
        h=From:To:Cc:Subject:Date:From;
        b=p5HFlKJZO2v2XTAnlocv3OTgRFmGpxracBKyy1tkHiemVOo39AtJmwktTisftE3l3
         qey/MoP12BigULn/pmmL3DqNC9TM8RnjhDz9taeGY1Fz/vMUWgqKb6IhOsxf1T2txl
         AN/Wd5tixHkgaYNAytG9UiiIay4fnKwjzLYFi7Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/114] 4.14.181-rc1 review
Date:   Mon, 18 May 2020 19:35:32 +0200
Message-Id: <20200518173503.033975649@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.181-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.181-rc1
X-KernelTest-Deadline: 2020-05-20T17:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.181 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.181-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.181-rc1

Sergei Trofimovich <slyfox@gentoo.org>
    Makefile: disallow data races on gcc-10 as well

Jim Mattson <jmattson@google.com>
    KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a7740: Add missing extal2 to CPG node

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: r8a73a4: Add missing CMT1 interrupts

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards

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

Justin Swartz <justin.swartz@risingedge.co.za>
    clk: rockchip: fix incorrect configuration of rk3228 aclk_gpu* clocks

Eric W. Biederman <ebiederm@xmission.com>
    exec: Move would_dump into flush_old_exec

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix error handling in __unwind_start()

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

Borislav Petkov <bp@suse.de>
    x86: Fix early boot crash on gcc-10, third try

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: dra7: Fix bus_dma_limit for PCIe

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Fix racy buffer resize under concurrent accesses

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Initialize allocated buffers

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Limit int mic boost for Thinkpad T530

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

Maciej Żenczykowski <maze@google.com>
    Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fix aneg restart in phy_ethtool_set_eee

Paolo Abeni <pabeni@redhat.com>
    netlabel: cope with NULL catmap

Cong Wang <xiyou.wangcong@gmail.com>
    net: fix a potential recursive NETDEV_FEAT_CHANGE

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: micrel: Use strlcpy() for ethtool::get_strings

Jan Beulich <JBeulich@suse.com>
    x86/asm: Add instruction suffixes to bitops

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

Jason Gunthorpe <jgg@mellanox.com>
    pnp: Use list_for_each_entry() instead of open coding

Samu Nuutamo <samu.nuutamo@vincit.fi>
    hwmon: (da9052) Synchronize access with mfd

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Test return value of calls to ib_get_cached_pkey

Arnd Bergmann <arnd@arndb.de>
    netfilter: conntrack: avoid gcc-10 zero-length-bounds warning

Dan Carpenter <dan.carpenter@oracle.com>
    i40iw: Fix error handling in i40iw_manage_arp_cache()

Grace Kao <grace.kao@intel.com>
    pinctrl: cherryview: Add missing spinlock usage in chv_gpio_irq_handler

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: baytrail: Enable pin configuration setting for GPIO chip

Gustavo A. R. Silva <gustavo@embeddedor.com>
    ipmi: Fix NULL pointer dereference in ssif_probe

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Fix unwind hints in register clearing code

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

Thierry Reding <treding@nvidia.com>
    net: stmmac: Use mutex instead of spinlock

Randall Huang <huangrandall@google.com>
    f2fs: fix to avoid memory leakage in f2fs_listxattr

Randall Huang <huangrandall@google.com>
    f2fs: fix to avoid accessing xattr across the boundary

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: sanity check of xattr entry size

Chao Yu <yuchao0@huawei.com>
    f2fs: introduce read_xattr_block

Chao Yu <yuchao0@huawei.com>
    f2fs: introduce read_inline_xattr

Cengiz Can <cengiz@kernel.wtf>
    blktrace: fix dereference after null check

Jan Kara <jack@suse.cz>
    blktrace: Protect q->blk_trace with RCU

Jens Axboe <axboe@kernel.dk>
    blktrace: fix trace mutex deadlock

Jens Axboe <axboe@kernel.dk>
    blktrace: fix unlocked access to init/start-stop/teardown

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Sabrina Dubroca <sd@queasysnail.net>
    net: ipv6: add net argument to ip6_dst_lookup_flow

Ivan Delalande <colona@arista.com>
    scripts/decodecode: fix trapping instruction formatting

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix stack offset tracking for indirect CFAs

Guillaume Nault <gnault@redhat.com>
    netfilter: nat: never update the UDP checksum when it's 0

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Fix error path for bad ORC entry type

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/unwind/orc: Prevent unwinding before ORC initialization

Miroslav Benes <mbenes@suse.cz>
    x86/unwind/orc: Don't skip the first frame for inactive tasks

Jann Horn <jannh@google.com>
    x86/entry/64: Fix unwind hints in rewind_stack_do_exit()

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/entry/64: Fix unwind hints in kernel exit path

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_v_ogm_process

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_store_throughput_override

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    batman-adv: Fix refcnt leak in batadv_show_throughput_override

George Spelvin <lkml@sdf.org>
    batman-adv: fix batadv_nc_random_weight_tq

Luis Chamberlain <mcgrof@kernel.org>
    coredump: fix crash when umh is disabled

David Hildenbrand <david@redhat.com>
    mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

Marc Zyngier <maz@kernel.org>
    KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add a vmalloc_sync_mappings() for safe measure

Oliver Neukum <oneukum@suse.com>
    USB: serial: garmin_gps: add sanity checking for data length

Oliver Neukum <oneukum@suse.com>
    USB: uas: add quirk for LaCie 2Big Quadra

Alan Stern <stern@rowland.harvard.edu>
    HID: usbhid: Fix race between usbhid_close() and usbhid_stop()

Hangbin Liu <liuhangbin@gmail.com>
    geneve: only configure or fill UDP_ZERO_CSUM6_RX/TX info when CONFIG_IPV6

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: fix cleanup ordering for ip6_mr failure

Willem de Bruijn <willemb@google.com>
    net: stricter validation of untrusted gso packets

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VF anti-spoof filter setup.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve AER slot reset.

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix command entry leak in Internal Error State

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Fix forced completion access non initialized command entry

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix VLAN acceleration handling in bnxt_fix_features().

Eric Dumazet <edumazet@google.com>
    sch_sfq: validate silly quantum values

Eric Dumazet <edumazet@google.com>
    sch_choke: avoid potential panic in choke_reset()

Matt Jolly <Kangie@footclan.ninja>
    net: usb: qmi_wwan: add support for DW5816e

Tariq Toukan <tariqt@mellanox.com>
    net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()

Scott Dial <scott@scottdial.com>
    net: macsec: preserve ingress frame ordering

Eric Dumazet <edumazet@google.com>
    fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks

Julia Lawall <Julia.Lawall@inria.fr>
    dp83640: reverse arguments to list_add_tail

Matt Jolly <Kangie@footclan.ninja>
    USB: serial: qcserial: Add DW5816e support


-------------

Diffstat:

 Makefile                                           |  25 +--
 arch/arm/boot/dts/dra7.dtsi                        |   4 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts   |   4 +-
 arch/arm/boot/dts/r8a73a4.dtsi                     |   9 +-
 arch/arm/boot/dts/r8a7740.dtsi                     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts        |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts     |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   4 +-
 arch/x86/entry/calling.h                           |  38 +++--
 arch/x86/entry/entry_64.S                          |   5 +-
 arch/x86/include/asm/bitops.h                      |  29 ++--
 arch/x86/include/asm/percpu.h                      |   2 +-
 arch/x86/include/asm/stackprotector.h              |   7 +-
 arch/x86/kernel/smpboot.c                          |   8 +
 arch/x86/kernel/unwind_orc.c                       |  20 +--
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/xen/smp_pv.c                              |   1 +
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/block/virtio_blk.c                         |  86 +++++++++-
 drivers/char/ipmi/ipmi_ssif.c                      |   4 +-
 drivers/clk/rockchip/clk-rk3228.c                  |  17 +-
 drivers/cpufreq/intel_pstate.c                     |   2 +-
 drivers/dma/mmp_tdma.c                             |   2 +
 drivers/dma/pch_dma.c                              |   2 +-
 drivers/gpu/drm/qxl/qxl_image.c                    |   3 +-
 drivers/hid/usbhid/hid-core.c                      |  37 ++++-
 drivers/hid/usbhid/usbhid.h                        |   1 +
 drivers/hid/wacom_sys.c                            |   4 +-
 drivers/hwmon/da9052-hwmon.c                       |   4 +-
 drivers/infiniband/core/addr.c                     |   7 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |   2 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  14 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   8 +-
 drivers/net/dsa/dsa_loop.c                         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  18 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   9 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |  16 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |  16 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  11 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |   2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c           |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  12 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  31 ++--
 drivers/net/geneve.c                               |  20 ++-
 drivers/net/macsec.c                               |   3 +-
 drivers/net/phy/dp83640.c                          |   2 +-
 drivers/net/phy/micrel.c                           |   4 +-
 drivers/net/phy/phy.c                              |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan.c                                |   8 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |   1 +
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 +
 drivers/scsi/sg.c                                  |   4 +-
 drivers/usb/core/hub.c                             |   6 +-
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/gadget/legacy/audio.c                  |   4 +-
 drivers/usb/gadget/legacy/cdc2.c                   |   4 +-
 drivers/usb/gadget/legacy/ncm.c                    |   4 +-
 drivers/usb/gadget/udc/net2272.c                   |   2 +
 drivers/usb/host/xhci-plat.c                       |   4 +-
 drivers/usb/host/xhci-ring.c                       |   4 +-
 drivers/usb/serial/garmin_gps.c                    |   4 +-
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 fs/coredump.c                                      |   8 +
 fs/exec.c                                          |   4 +-
 fs/f2fs/xattr.c                                    | 176 ++++++++++++--------
 fs/f2fs/xattr.h                                    |   2 +
 include/linux/blkdev.h                             |   2 +-
 include/linux/blktrace_api.h                       |  18 ++-
 include/linux/compiler.h                           |   6 +
 include/linux/fs.h                                 |   2 +-
 include/linux/pnp.h                                |  29 ++--
 include/linux/tty.h                                |   2 +-
 include/linux/virtio_net.h                         |  24 ++-
 include/net/addrconf.h                             |   6 +-
 include/net/ipv6.h                                 |   2 +-
 include/net/netfilter/nf_conntrack.h               |   2 +-
 include/sound/rawmidi.h                            |   1 +
 init/main.c                                        |   2 +
 ipc/util.c                                         |  12 +-
 kernel/trace/blktrace.c                            | 177 ++++++++++++++++-----
 kernel/trace/trace.c                               |  13 ++
 kernel/umh.c                                       |   5 +
 mm/page_alloc.c                                    |   1 +
 mm/shmem.c                                         |   7 +-
 net/batman-adv/bat_v_ogm.c                         |   2 +-
 net/batman-adv/network-coding.c                    |   9 +-
 net/batman-adv/sysfs.c                             |   3 +-
 net/core/dev.c                                     |   4 +-
 net/core/drop_monitor.c                            |  11 +-
 net/core/netprio_cgroup.c                          |   2 +
 net/dccp/ipv6.c                                    |   6 +-
 net/ipv4/cipso_ipv4.c                              |   6 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv6/addrconf_core.c                           |  11 +-
 net/ipv6/af_inet6.c                                |  10 +-
 net/ipv6/calipso.c                                 |   3 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/inet6_connection_sock.c                   |   4 +-
 net/ipv6/ip6_output.c                              |   8 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |   6 +-
 net/ipv6/syncookies.c                              |   2 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/mpls/af_mpls.c                                 |   7 +-
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/netfilter/nf_nat_proto_udp.c                   |   5 +-
 net/netlabel/netlabel_kapi.c                       |   6 +
 net/sched/sch_choke.c                              |   3 +-
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sched/sch_sfq.c                                |   9 ++
 net/sctp/ipv6.c                                    |   4 +-
 net/tipc/udp_media.c                               |   9 +-
 scripts/decodecode                                 |   2 +-
 sound/core/rawmidi.c                               |  35 +++-
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |  28 +++-
 sound/usb/quirks.c                                 |   9 +-
 tools/objtool/check.c                              |   2 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |   4 +-
 128 files changed, 892 insertions(+), 443 deletions(-)


