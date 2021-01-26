Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3380E303C84
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392339AbhAZMHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392303AbhAZLWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 06:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6432D22795;
        Tue, 26 Jan 2021 11:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611660133;
        bh=Ukr2TmsKU2CEXkX34Xa4MfNYWsN3NLWzb1d2M6bkTRM=;
        h=From:To:Cc:Subject:Date:From;
        b=KS6ql3C8BfuxRujyMCtI9Qgfw+VG/AS55R8eDycD6emlgaJIny2oMgFvJVU3TZVeF
         KdFPKmuxnDpqN57iDuLdcr+Sxy2mYCPRVHwLy6b8NxhRvpyUpXzUpRYs0kas8nXwfh
         Mni7vQUCcIIjn+xRHLRxgL7YHLyVuAv4aDpqVVYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/87] 5.4.93-rc3 review
Date:   Tue, 26 Jan 2021 12:22:10 +0100
Message-Id: <20210126111748.320806573@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.93-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.93-rc3
X-KernelTest-Deadline: 2021-01-28T11:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.93 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Jan 2021 11:17:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.93-rc3

Enke Chen <enchen@paloaltonetworks.com>
    tcp: fix TCP_USER_TIMEOUT with zero window

Eric Dumazet <edumazet@google.com>
    tcp: do not mess with cloned skbs in tcp_add_backlog()

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: b53: fix an off by one in checking "vlan->vid"

Tariq Toukan <tariqt@nvidia.com>
    net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: allow offloading of bridge on top of LAG

Matteo Croce <mcroce@microsoft.com>
    ipv6: set multicast flag on the multicast route

Eric Dumazet <edumazet@google.com>
    net_sched: reject silly cell_log in qdisc_get_rtab()

Eric Dumazet <edumazet@google.com>
    net_sched: avoid shift-out-of-bounds in tcindex_set_parms()

Matteo Croce <mcroce@microsoft.com>
    ipv6: create multicast route with RTPROT_KERNEL

Guillaume Nault <gnault@redhat.com>
    udp: mask TOS bits in udp_v4_early_demux()

Lecopzer Chen <lecopzer@gmail.com>
    kasan: fix incorrect arguments passing in kasan_add_zero_shadow

Lecopzer Chen <lecopzer@gmail.com>
    kasan: fix unaligned address is unhandled in kasan_remove_zero_shadow

Alexander Lobakin <alobakin@pm.me>
    skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too

Pan Bian <bianpan2016@163.com>
    lightnvm: fix memory leak when submit fails

Geert Uytterhoeven <geert+renesas@glider.be>
    sh_eth: Fix power down vs. is_opened flag ordering

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    sh: dma: fix kconfig dependency for G2_DMA

Guillaume Nault <gnault@redhat.com>
    netfilter: rpfilter: mask ecn bits before fib lookup

Yazen Ghannam <Yazen.Ghannam@amd.com>
    x86/cpu/amd: Set __max_die_per_package on AMD

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Fix JZ4760 support

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Extend device_is_dependent()

JC Kuo <jckuo@nvidia.com>
    xhci: tegra: Delay for disabling LFPS detector

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure TRB is fully written before giving it to the controller

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    usb: bdc: Make bdc pci driver depend on BROKEN

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: udc: core: Use lock when write to soft_connect

Ryan Chen <ryan_chen@aspeedtech.com>
    usb: gadget: aspeed: fix stop dma register setting.

Longfang Liu <liulongfang@huawei.com>
    USB: ehci: fix an interrupt calltrace error

Eugene Korenevsky <ekorenevsky@astralinux.ru>
    ehci: fix EHCI host controller initialization sequence

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: fix tx lost characters at power off

Wang Hui <john.wanghui@huawei.com>
    stm class: Fix module init return on allocation failure

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Alder Lake-P support

Andy Lutomirski <luto@kernel.org>
    x86/mmx: Use KFPU_387 for MMX string operations

Borislav Petkov <bp@suse.de>
    x86/topology: Make __max_die_per_package available unconditionally

Andy Lutomirski <luto@kernel.org>
    x86/fpu: Add kernel_fpu_begin_mask() to selectively initialize state

Mathias Kresin <dev@kresin.me>
    irqchip/mips-cpu: Set IPI domain parent chip

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: do not fail __smb_send_rqst if non-fatal signals are pending

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad5504: Fix setting power-down state

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: peak_usb: fix use after free bugs

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: vxcan: vxcan_xmit: fix use after free bug

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: dev: can_restart: fix use after free bug

Hangbin Liu <liuhangbin@gmail.com>
    selftests: net: fib_tests: remove duplicate log test

Hans de Goede <hdegoede@redhat.com>
    platform/x86: intel-vbtn: Drop HP Stream x360 Convertible PC 11 from allow-list

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: octeon: check correct size of maximum RECV_LEN packet

Ariel Marcovitch <arielmarcovitch@gmail.com>
    powerpc: Fix alignment bug within the init sections

Arnd Bergmann <arnd@arndb.de>
    scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: aspeed: g6: Fix PWMG0 pinctrl setting

Youling Tang <tangyouling@loongson.cn>
    powerpc: Use the common INIT_DATA_SECTION macro in vmlinux.lds.S

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/mmu: fix vram heap sizing

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/gm200: increase width of aux semaphore owner fields

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/privring: ack interrupts the same way as RM

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: fix issue shadowing expansion ROMs

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fix to be able to stop crc calculation

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu/psp: fix psp gfx ctrl cmds

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    riscv: defconfig: enable gpio support for HiFive Unleashed

Sagar Shrikant Kadam <sagar.kadam@sifive.com>
    dts: phy: fix missing mdio device and probe failure of vsc8541-01 device

David Woodhouse <dwmw@amazon.co.uk>
    x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery

David Woodhouse <dwmw@amazon.co.uk>
    xen: Fix event channel callback via INTX/GSI

Arnd Bergmann <arnd@arndb.de>
    arm64: make atomic helpers __always_inline

Peter Geis <pgwipeout@gmail.com>
    clk: tegra30: Add hda clock default rates to clock driver

Seth Miller <miller.seth@gmail.com>
    HID: Ignore battery for Elan touchscreen on ASUS UX550

Filipe Laíns <lains@archlinux.org>
    HID: logitech-dj: add the G602 receiver

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Fix sifive serial driver

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Fix kernel time_init()

Ewan D. Milne <emilne@redhat.com>
    scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Correct max length of CHAP secret

Can Guo <cang@codeaurora.org>
    scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Anthony Iliopoulos <ailiop@suse.com>
    dm integrity: select CRYPTO_SKCIPHER

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: haswell: Add missing pm_ops

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Prevent use of engine->wa_ctx after error

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/syncobj: Fix use-after-free

Pan Bian <bianpan2016@163.com>
    drm/atomic: put state on error path

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a crash if "recalculate" used without "internal_hash"

Hannes Reinecke <hare@suse.de>
    dm: avoid filesystem lookup in dm_get_dev_t()

Alex Leibovich <alexl@marvell.com>
    mmc: sdhci-xenon: fix 1.8v regulator stabilization

Peter Collingbourne <pcc@google.com>
    mmc: core: don't initialize block size from ext_csd if not present

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid clone operations when cloning from the same file and root

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't clear ret in btrfs_start_dirty_block_groups

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix lockdep splat in btrfs_recover_relocation

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't get an EINTR during drop_snapshot for reloc

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Make acpi_bus_get_device() clear return pointer on error

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via: Add minimum mute flag

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform/x86: ideapad-laptop: Disable touchpad_switch for ELAN0634

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    platform/x86: i2c-multi-instantiate: Don't create platform device for INT3515 ACPI nodes

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: bpmp-tegra: Ignore unknown I2C_M flags


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  4 ++
 Makefile                                           |  4 +-
 arch/arm/xen/enlighten.c                           |  2 +-
 arch/arm64/include/asm/atomic.h                    | 10 +--
 arch/powerpc/kernel/vmlinux.lds.S                  | 25 +++----
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |  1 +
 arch/riscv/configs/defconfig                       |  2 +
 arch/riscv/kernel/time.c                           |  3 +
 arch/sh/drivers/dma/Kconfig                        |  3 +-
 arch/x86/include/asm/fpu/api.h                     | 15 +++-
 arch/x86/include/asm/topology.h                    |  4 +-
 arch/x86/kernel/cpu/amd.c                          |  4 +-
 arch/x86/kernel/cpu/topology.c                     |  2 +-
 arch/x86/kernel/fpu/core.c                         |  9 +--
 arch/x86/lib/mmx_32.c                              | 20 ++++--
 arch/x86/xen/enlighten_hvm.c                       | 11 ++-
 drivers/acpi/scan.c                                |  2 +
 drivers/base/core.c                                | 17 ++++-
 drivers/clk/tegra/clk-tegra30.c                    |  2 +
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h            |  2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |  2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  2 +-
 drivers/gpu/drm/drm_syncobj.c                      |  8 ++-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  3 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  4 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.h            |  2 +-
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c        |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/shadow.c  |  2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |  8 +--
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c   | 10 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c   | 10 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/base.c     |  6 +-
 drivers/hid/hid-ids.h                              |  1 +
 drivers/hid/hid-input.c                            |  2 +
 drivers/hid/hid-logitech-dj.c                      |  4 ++
 drivers/hid/hid-multitouch.c                       |  4 ++
 drivers/hwtracing/intel_th/pci.c                   |  5 ++
 drivers/hwtracing/stm/heartbeat.c                  |  6 +-
 drivers/i2c/busses/i2c-octeon-core.c               |  2 +-
 drivers/i2c/busses/i2c-tegra-bpmp.c                |  2 +-
 drivers/iio/dac/ad5504.c                           |  4 +-
 drivers/irqchip/irq-mips-cpu.c                     |  7 ++
 drivers/lightnvm/core.c                            |  3 +-
 drivers/md/Kconfig                                 |  1 +
 drivers/md/dm-integrity.c                          |  6 ++
 drivers/md/dm-table.c                              | 15 +++-
 drivers/mmc/core/queue.c                           |  4 +-
 drivers/mmc/host/sdhci-xenon.c                     |  7 +-
 drivers/net/can/dev.c                              |  4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  8 +--
 drivers/net/can/vxcan.c                            |  6 +-
 drivers/net/dsa/b53/b53_common.c                   |  2 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |  4 ++
 drivers/net/ethernet/mscc/ocelot.c                 |  4 +-
 drivers/net/ethernet/renesas/sh_eth.c              |  4 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  2 +-
 drivers/pinctrl/pinctrl-ingenic.c                  | 24 +++----
 drivers/platform/x86/i2c-multi-instantiate.c       | 31 ++++++---
 drivers/platform/x86/ideapad-laptop.c              | 15 +++-
 drivers/platform/x86/intel-vbtn.c                  |  6 --
 drivers/scsi/megaraid/megaraid_sas_base.c          |  6 +-
 drivers/scsi/qedi/qedi_main.c                      |  4 +-
 drivers/scsi/sd.c                                  |  4 +-
 drivers/scsi/ufs/ufshcd.c                          | 11 ++-
 drivers/tty/serial/mvebu-uart.c                    | 10 ++-
 drivers/tty/serial/sifive.c                        |  1 +
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |  5 +-
 drivers/usb/gadget/udc/bdc/Kconfig                 |  2 +-
 drivers/usb/gadget/udc/core.c                      | 13 +++-
 drivers/usb/host/ehci-hcd.c                        | 12 ++++
 drivers/usb/host/ehci-hub.c                        |  3 +
 drivers/usb/host/xhci-ring.c                       |  2 +
 drivers/usb/host/xhci-tegra.c                      |  7 ++
 drivers/xen/events/events_base.c                   | 10 ---
 drivers/xen/platform-pci.c                         |  1 -
 drivers/xen/xenbus/xenbus.h                        |  1 +
 drivers/xen/xenbus/xenbus_comms.c                  |  8 ---
 drivers/xen/xenbus/xenbus_probe.c                  | 81 ++++++++++++++++++----
 fs/btrfs/block-group.c                             |  3 +-
 fs/btrfs/extent-tree.c                             | 10 ++-
 fs/btrfs/send.c                                    | 15 ++++
 fs/btrfs/volumes.c                                 |  2 +
 fs/cifs/transport.c                                |  4 +-
 include/asm-generic/bitops/atomic.h                |  6 +-
 include/net/inet_connection_sock.h                 |  3 +
 include/xen/xenbus.h                               |  2 +-
 mm/kasan/init.c                                    | 23 +++---
 net/core/dev.c                                     |  5 ++
 net/core/skbuff.c                                  |  6 +-
 net/ipv4/inet_connection_sock.c                    |  1 +
 net/ipv4/netfilter/ipt_rpfilter.c                  |  2 +-
 net/ipv4/tcp.c                                     |  1 +
 net/ipv4/tcp_input.c                               |  1 +
 net/ipv4/tcp_ipv4.c                                | 25 +++----
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv4/tcp_timer.c                               | 14 ++--
 net/ipv4/udp.c                                     |  3 +-
 net/ipv6/addrconf.c                                |  3 +-
 net/sched/cls_tcindex.c                            |  8 ++-
 net/sched/sch_api.c                                |  3 +-
 sound/core/seq/oss/seq_oss_synth.c                 |  3 +-
 sound/pci/hda/patch_via.c                          |  1 +
 sound/soc/intel/boards/haswell.c                   |  1 +
 tools/testing/selftests/net/fib_tests.sh           |  1 -
 104 files changed, 489 insertions(+), 223 deletions(-)


