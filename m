Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88709521717
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbiEJNXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243321AbiEJNVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDCC2657;
        Tue, 10 May 2022 06:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEECFB81DA9;
        Tue, 10 May 2022 13:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBB5C385A6;
        Tue, 10 May 2022 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188535;
        bh=QGm83nI5UE7f9xpTwlivyHrhLr/nIiblprXB5qW6e1k=;
        h=From:To:Cc:Subject:Date:From;
        b=M8KFbVq7BPLKRH6A4R3DJtM6mME0qT8723pvk2Sg81T37ztQXTPkmahPTOFT8WNub
         7xpIQq0+z2UHneC3uYtD/oajrc0uUb/5mooIthnLESR+AoESTYw4R1RzGBzBqdQx5Z
         g2XCDhPLShFV7iLKQjkPHHyUumQt/xTr9ylQhmAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/78] 4.14.278-rc1 review
Date:   Tue, 10 May 2022 15:06:46 +0200
Message-Id: <20220510130732.522479698@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.278-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.278-rc1
X-KernelTest-Deadline: 2022-05-12T13:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.278 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.278-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.278-rc1

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix reading MSI interrupt number

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Clear all MSIs at setup

Mike Snitzer <snitzer@redhat.com>
    dm: interlock pending dm_io and dm_wait_for_bios_completion

Jiazi Li <jqqlijiazi@gmail.com>
    dm: fix mempool NULL pointer race when completing IO

j.nixdorf@avm.de <j.nixdorf@avm.de>
    net: ipv6: ensure we call ipv6_mc_down() at most once

Sandipan Das <sandipan.das@amd.com>
    kvm: x86/cpuid: Only provide CPUID leaf 0xA if host has architectural PMU

Eric Dumazet <edumazet@google.com>
    net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()

Filipe Manana <fdmanana@suse.com>
    btrfs: always log symlinks in full mode

Sergey Shtylyov <s.shtylyov@omp.ru>
    smsc911x: allow using IRQ0

Shravya Kumbham <shravya.kumbham@xilinx.com>
    net: emaclite: Add error handling for of_address_to_resource()

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    ASoC: dmaengine: Restore NULL prepare_slave_config() callback

Armin Wolf <W_Armin@gmx.de>
    hwmon: (adt7470) Fix warning on module removal

Duoming Zhou <duoming@zju.edu.cn>
    NFC: netlink: fix sleep in atomic bug when firmware download timeout

Duoming Zhou <duoming@zju.edu.cn>
    nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs

Duoming Zhou <duoming@zju.edu.cn>
    nfc: replace improper check device_is_registered() in netlink related functions

Daniel Hellstrom <daniel@gaisler.com>
    can: grcan: use ofdev->dev when allocating DMA memory

Duoming Zhou <duoming@zju.edu.cn>
    can: grcan: grcan_close(): fix deadlock

Mark Brown <broonie@kernel.org>
    ASoC: wm8958: Fix change notifications for DSP controls

Niels Dossche <dossche.niels@gmail.com>
    firewire: core: extend card->lock in fw_core_handle_bus_reset

Jakob Koschel <jakobkoschel@gmail.com>
    firewire: remove check of list iterator against head past the loop body

Chengfeng Ye <cyeaa@connect.ust.hk>
    firewire: fix potential uaf in outbound_phy_packet_callback()

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: attempt AF_LOCAL connect on setup"

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes

Helge Deller <deller@gmx.de>
    parisc: Merge model and model name into one line in /proc/cpuinfo

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix CP0 counter erratum detection for R4k CPUs

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/vgem: Close use-after-free race in vgem_gem_create

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix incorrect UA handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command frame length field encoding

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong command retry handling

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing explicit ldisc flush

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix insufficient txframe size

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix malformed counter for out of frame data

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2

Borislav Petkov <bp@suse.de>
    x86/cpu: Load microcode during restore_processor_state()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: hippi: Fix deadlock in rr_close()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: destage any unwritten data to the server before calling copychunk_write

Mikulas Patocka <mpatocka@redhat.com>
    x86: __memcpy_flushcache: fix wrong alignment if size > 2^32

Zheyu Ma <zheyuma97@gmail.com>
    ASoC: wm8731: Disable the regulator when probing fails

Manish Chopra <manishc@marvell.com>
    bnx2x: fix napi API usage sequence

Jonathan Lemon <jonathan.lemon@gmail.com>
    net: bcmgenet: hide status block before TX timestamping

Yang Yingliang <yangyingliang@huawei.com>
    clk: sunxi: sun9i-mmc: check return value after calling platform_get_resource()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    bus: sunxi-rsb: Fix the return value of sunxi_rsb_device_create()

Eric Dumazet <edumazet@google.com>
    tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

Peilin Ye <peilin.ye@bytedance.com>
    ip_gre: Make o_seqno start from 0 in native mode

Lv Ruyi <lv.ruyi@zte.com.cn>
    pinctrl: pistachio: fix use of irq_of_parse_and_map()

Xin Long <lucien.xin@gmail.com>
    sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Miaoqian Lin <linmq006@gmail.com>
    mtd: rawnand: Fix return value check of wait_for_completion_timeout

Pengcheng Yang <yangpc@wangsu.com>
    ipvs: correctly print the memory size of ip_vs_conn_tab

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: Fix mmc order for omap3-gta04

Miaoqian Lin <linmq006@gmail.com>
    ARM: OMAP2+: Fix refcount leak in omap_gic_of_init

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    phy: samsung: exynos5250-sata: fix missing device put in probe error paths

Miaoqian Lin <linmq006@gmail.com>
    phy: samsung: Fix missing of_node_put() in exynos_sata_phy_probe

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-apalis: Fix sgtl5000 detection issue

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    USB: Fix xhci event ring dequeue pointer ERDP update issue

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: fix access beyond string end

Mikulas Patocka <mpatocka@redhat.com>
    hex2bin: make the function hex_to_bin constant-time

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: 8250: Also set sticky MCR bits in console restoration

Vijayavardhan Vennapusa <vvreddy@codeaurora.org>
    usb: gadget: configfs: clear deactivation flag in configfs_composite_unbind()

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: Fix crash when encoding data for usb request

Hangyu Hua <hbh25y@gmail.com>
    usb: misc: fix improper handling of refcount in uss720_probe()

Zheyu Ma <zheyuma97@gmail.com>
    iio: magnetometer: ak8975: Fix the error handling in ak8975_power_on()

Michael Hennerich <michael.hennerich@analog.com>
    iio: dac: ad5446: Fix read_raw not returning set value

Zizhuang Deng <sunsetdzz@gmail.com>
    iio: dac: ad5592r: Fix the missing return value.

Henry Lin <henryl@nvidia.com>
    xhci: stop polling roothubs after shutdown

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Cinterion MV32-WA/MV32-WB

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader

Kees Cook <keescook@chromium.org>
    USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add STRING quirk for VCOM device

Oliver Neukum <oneukum@suse.com>
    USB: quirks: add a Realtek card reader

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix USB 3.0 dual-role-switch from device to host

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lightnvm: disable the subsystem

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link"

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix netns refcount changes in u32_change()

Lin Ma <linma@zju.edu.cn>
    hamradio: remove needs_free_netdev to avoid UAF

Lin Ma <linma@zju.edu.cn>
    hamradio: defer 6pack kfree after unregister_netdev

Willy Tarreau <w@1wt.eu>
    floppy: disable FDRAWCMD by default


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx6qdl-apalis.dtsi              | 10 ++++-
 arch/arm/boot/dts/omap3-gta04.dtsi                 |  2 +
 arch/arm/mach-omap2/omap4-common.c                 |  2 +
 arch/mips/include/asm/timex.h                      |  8 ++--
 arch/mips/kernel/time.c                            | 11 ++----
 arch/parisc/kernel/processor.c                     |  3 +-
 arch/x86/include/asm/microcode.h                   |  2 +
 arch/x86/kernel/cpu/microcode/core.c               |  6 +--
 arch/x86/kvm/cpuid.c                               |  5 +++
 arch/x86/lib/usercopy_64.c                         |  2 +-
 arch/x86/power/cpu.c                               |  8 ++++
 drivers/block/Kconfig                              | 16 ++++++++
 drivers/block/floppy.c                             | 43 ++++++++++++++++------
 drivers/bus/sunxi-rsb.c                            |  2 +
 drivers/clk/sunxi/clk-sun9i-mmc.c                  |  2 +
 drivers/firewire/core-card.c                       |  3 ++
 drivers/firewire/core-cdev.c                       |  4 +-
 drivers/firewire/core-topology.c                   |  9 ++---
 drivers/firewire/core-transaction.c                | 30 ++++++++-------
 drivers/firewire/sbp2.c                            | 13 ++++---
 drivers/gpu/drm/vgem/vgem_drv.c                    |  9 +++--
 drivers/hwmon/adt7470.c                            |  4 +-
 drivers/iio/dac/ad5446.c                           |  2 +-
 drivers/iio/dac/ad5592r-base.c                     |  2 +-
 drivers/iio/magnetometer/ak8975.c                  |  1 +
 drivers/lightnvm/Kconfig                           |  2 +-
 drivers/md/dm.c                                    | 19 ++++++----
 drivers/mtd/nand/sh_flctl.c                        | 14 ++++---
 drivers/net/can/grcan.c                            |  8 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  9 +++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  7 ++++
 drivers/net/ethernet/smsc/smsc911x.c               |  2 +-
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |  8 ++++
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |  4 --
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 13 ++++---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      | 15 ++++++--
 drivers/net/hamradio/6pack.c                       |  5 ++-
 drivers/net/hippi/rrunner.c                        |  2 +
 drivers/nfc/nfcmrvl/main.c                         |  2 +-
 drivers/pci/host/pci-aardvark.c                    | 16 ++++----
 drivers/phy/samsung/phy-exynos5250-sata.c          | 21 ++++++++---
 drivers/pinctrl/pinctrl-pistachio.c                |  6 +--
 drivers/tty/n_gsm.c                                | 40 ++++++++++----------
 drivers/tty/serial/8250/8250_pci.c                 |  8 ++--
 drivers/tty/serial/8250/8250_port.c                |  2 +-
 drivers/usb/core/quirks.c                          |  6 +++
 drivers/usb/gadget/configfs.c                      |  2 +
 drivers/usb/gadget/function/uvc_queue.c            |  2 +
 drivers/usb/host/xhci-ring.c                       |  2 +
 drivers/usb/host/xhci.c                            | 11 ++++++
 drivers/usb/misc/uss720.c                          |  3 +-
 drivers/usb/mtu3/mtu3_dr.c                         |  6 +--
 drivers/usb/serial/cp210x.c                        |  2 +
 drivers/usb/serial/option.c                        | 12 ++++++
 drivers/usb/serial/whiteheat.c                     |  5 +--
 fs/btrfs/tree-log.c                                | 14 ++++++-
 fs/cifs/smb2ops.c                                  |  8 ++++
 include/linux/kernel.h                             |  2 +-
 include/net/tcp.h                                  |  1 +
 lib/hexdump.c                                      | 41 ++++++++++++++++-----
 net/ipv4/igmp.c                                    |  9 +++--
 net/ipv4/ip_gre.c                                  |  8 ++--
 net/ipv4/tcp_input.c                               | 12 +++++-
 net/ipv4/tcp_output.c                              |  1 +
 net/ipv6/addrconf.c                                |  8 +++-
 net/netfilter/ipvs/ip_vs_conn.c                    |  2 +-
 net/nfc/core.c                                     | 29 +++++++--------
 net/nfc/netlink.c                                  |  4 +-
 net/sched/cls_u32.c                                | 18 +++++----
 net/sctp/sm_sideeffect.c                           |  4 ++
 net/sunrpc/xprtsock.c                              |  3 --
 sound/firewire/fireworks/fireworks_hwdep.c         |  1 +
 sound/soc/codecs/wm8731.c                          | 19 ++++++----
 sound/soc/codecs/wm8958-dsp2.c                     |  8 ++--
 sound/soc/soc-generic-dmaengine-pcm.c              |  6 +--
 76 files changed, 435 insertions(+), 220 deletions(-)


