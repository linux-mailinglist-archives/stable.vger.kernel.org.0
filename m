Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA557D3E1
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiGUTLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiGUTLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:11:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5324989676;
        Thu, 21 Jul 2022 12:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F666205E;
        Thu, 21 Jul 2022 19:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6643C3411E;
        Thu, 21 Jul 2022 19:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658430658;
        bh=BrtBzWU2k27SZSXOLkZPFRxmrCH6DZLygm2t0648VBk=;
        h=From:To:Cc:Subject:Date:From;
        b=bLwA732J9W/2DfeBubz54KNiVO/etohbcGcGF2KL0A3X+WszNMcgbHb20OstB0so7
         bEhzz6SwHl66Lf/vVSQEjxK/VOUfNCk3+N/faxrfxYeyDpwDRBIqKLFiY1eBv9tLZK
         2JYxmQIjmP6ammZoLZJa72fhNQFaY8SJwdd8mXkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.207
Date:   Thu, 21 Jul 2022 21:10:05 +0200
Message-Id: <165843060622339@kroah.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.207 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt                  |    4 -
 Makefile                                                |    2 
 arch/arm/boot/dts/imx6qdl-ts7970.dtsi                   |    2 
 arch/arm/boot/dts/sama5d2.dtsi                          |    2 
 arch/arm/boot/dts/stm32mp157c.dtsi                      |    2 
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts       |    2 
 arch/arm/include/asm/mach/map.h                         |    1 
 arch/arm/include/asm/ptrace.h                           |   26 +++++++++++
 arch/arm/mm/alignment.c                                 |    3 +
 arch/arm/mm/mmu.c                                       |   15 ++++++
 arch/arm/mm/proc-v7-bugs.c                              |    9 +--
 arch/arm/probes/decode.h                                |   26 -----------
 arch/x86/kernel/head64.c                                |    2 
 drivers/cpufreq/pmac32-cpufreq.c                        |    4 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c             |    1 
 drivers/gpu/drm/i915/gt/intel_gt.c                      |   15 ++++++
 drivers/gpu/drm/panfrost/panfrost_drv.c                 |    4 -
 drivers/irqchip/irq-or1k-pic.c                          |    1 
 drivers/net/can/m_can/m_can.c                           |    5 +-
 drivers/net/ethernet/faraday/ftgmac100.c                |   15 ++++++
 drivers/net/ethernet/sfc/ef10.c                         |    3 +
 drivers/net/ethernet/sfc/ef10_sriov.c                   |   10 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c |    1 
 drivers/net/phy/sfp.c                                   |    2 
 drivers/net/xen-netback/rx.c                            |    1 
 drivers/nfc/nxp-nci/i2c.c                               |    8 ++-
 drivers/nvme/host/core.c                                |    2 
 drivers/nvme/host/nvme.h                                |    1 
 drivers/nvme/host/rdma.c                                |   12 +++--
 drivers/nvme/host/tcp.c                                 |   10 +++-
 drivers/platform/x86/hp-wmi.c                           |    3 +
 drivers/soc/ixp4xx/ixp4xx-npe.c                         |    2 
 drivers/tty/serial/8250/8250_port.c                     |    4 +
 drivers/tty/serial/amba-pl011.c                         |   23 +++++++++
 drivers/tty/serial/samsung.c                            |    5 --
 drivers/tty/serial/stm32-usart.c                        |    2 
 drivers/usb/dwc3/gadget.c                               |    4 +
 drivers/usb/serial/ftdi_sio.c                           |    3 +
 drivers/usb/serial/ftdi_sio_ids.h                       |    6 ++
 drivers/usb/typec/class.c                               |    1 
 drivers/virtio/virtio_mmio.c                            |   26 +++++++++++
 fs/ext4/extents.c                                       |    8 ++-
 fs/ext4/inode.c                                         |    9 ---
 fs/nilfs2/nilfs.h                                       |    3 +
 include/linux/cgroup-defs.h                             |    3 -
 include/net/raw.h                                       |    2 
 include/net/sock.h                                      |    2 
 include/trace/events/sock.h                             |    6 +-
 kernel/cgroup/cgroup.c                                  |   37 +++++++++-------
 kernel/sched/features.h                                 |    2 
 kernel/signal.c                                         |    8 +--
 kernel/sysctl.c                                         |   20 ++++----
 kernel/trace/trace_events_hist.c                        |    2 
 net/bridge/br_netfilter_hooks.c                         |   21 +++++++--
 net/core/filter.c                                       |    1 
 net/ipv4/af_inet.c                                      |    4 -
 net/ipv4/cipso_ipv4.c                                   |   12 +++--
 net/ipv4/fib_semantics.c                                |    2 
 net/ipv4/fib_trie.c                                     |    2 
 net/ipv4/icmp.c                                         |   10 ++--
 net/ipv4/inetpeer.c                                     |   12 +++--
 net/ipv6/seg6_iptunnel.c                                |    5 +-
 net/ipv6/seg6_local.c                                   |    2 
 net/mac80211/wme.c                                      |    4 -
 net/tipc/socket.c                                       |    1 
 security/integrity/evm/evm_crypto.c                     |    7 ---
 security/integrity/ima/ima_appraise.c                   |    3 -
 sound/pci/hda/patch_conexant.c                          |    1 
 sound/pci/hda/patch_realtek.c                           |   15 ++++++
 sound/soc/codecs/cs47l15.c                              |    5 +-
 sound/soc/codecs/madera.c                               |   14 ++++--
 sound/soc/codecs/sgtl5000.c                             |    9 +++
 sound/soc/codecs/sgtl5000.h                             |    1 
 sound/soc/codecs/wm5110.c                               |    8 ++-
 sound/soc/soc-ops.c                                     |    4 -
 75 files changed, 364 insertions(+), 151 deletions(-)

Andrea Mayer (3):
      seg6: fix skb checksum evaluation in SRH encapsulation/insertion
      seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
      seg6: bpf: fix skb checksum in bpf_push_seg6_encap()

Ard Biesheuvel (2):
      ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
      ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Baokun Li (1):
      ext4: fix race condition between ext4_write and ext4_convert_inline_data

Chanho Park (1):
      tty: serial: samsung_tty: set dma burst_size to 1

Charles Keepax (4):
      ASoC: wm5110: Fix DRE control
      ASoC: cs47l15: Fix event generation for low power mux control
      ASoC: madera: Fix event generation for OUT1 demux
      ASoC: madera: Fix event generation for rate controls

Chris Wilson (1):
      drm/i915/gt: Serialize TLB invalidates with GT resets

Daniel Bristot de Oliveira (1):
      sched/rt: Disable RT_RUNTIME_SHARE by default

Dmitry Osipenko (2):
      ARM: 9213/1: Print message about disabled Spectre workarounds only once
      drm/panfrost: Fix shrinker list corruption by madvise IOCTL

Felix Fietkau (1):
      wifi: mac80211: fix queue selection for mesh/OCB interfaces

Florian Westphal (1):
      netfilter: br_netfilter: do not skip all hooks with 0 priority

Francesco Dolcini (1):
      ASoC: sgtl5000: Fix noise on shutdown/remove

Gabriel Fernandez (1):
      ARM: dts: stm32: use the correct clock source for CEC on stm32mp151

Greg Kroah-Hartman (1):
      Linux 5.4.207

Hangyu Hua (2):
      drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()
      net: tipc: fix possible refcount leak in tipc_sk_create()

Huaxin Lu (1):
      ima: Fix a potential integer overflow in ima_appraise_measurement

Ilpo Järvinen (2):
      serial: stm32: Clear prev values before setting RTS delays
      serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle

Jianglei Nie (1):
      net: sfp: fix memory leak in sfp_probe()

Jon Hunter (1):
      net: stmmac: dwc-qos: Disable split header for Tegra194

Juergen Gross (2):
      xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
      x86: Clear .brk area at early boot

Kai-Heng Feng (1):
      platform/x86: hp-wmi: Ignore Sanitization Mode event

Kris Bahnsen (1):
      ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count

Kuniyuki Iwashima (9):
      inetpeer: Fix data-races around sysctl.
      net: Fix data-races around sysctl_mem.
      cipso: Fix data-races around sysctl.
      icmp: Fix data-races around sysctl.
      ipv4: Fix a data-race around sysctl_fib_sync_mem.
      icmp: Fix a data-race around sysctl_icmp_ratelimit.
      icmp: Fix a data-race around sysctl_icmp_ratemask.
      raw: Fix a data-race around sysctl_raw_l3mdev_accept.
      ipv4: Fix data-races around sysctl_ip_dynaddr.

Liang He (2):
      net: ftgmac100: Hold reference returned by of_get_child_by_name()
      cpufreq: pmac32-cpufreq: Fix refcount leak bug

Linus Torvalds (1):
      signal handling: don't use BUG_ON() for debugging

Linus Walleij (1):
      soc: ixp4xx/npe: Fix unused match warning

Linyu Yuan (1):
      usb: typec: add missing uevent when partner support PD

Lucien Buchmann (1):
      USB: serial: ftdi_sio: add Belimo device ids

Marc Kleine-Budde (1):
      can: m_can: m_can_tx_handler(): fix use after free of skb

Mark Brown (1):
      ASoC: ops: Fix off by one in range control validation

Meng Tang (5):
      ALSA: hda - Add fixup for Dell Latitidue E5430
      ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Michael Walle (1):
      NFC: nxp-nci: don't print header length mismatch on i2c error

Michal Suchanek (1):
      ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Muchun Song (1):
      mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE

Nicolas Dichtel (1):
      ip: fix dflt addr selection for connected nexthop

Ruozhu Li (1):
      nvme: fix regression when disconnect a recovering ctrl

Ryan Wanner (1):
      ARM: dts: at91: sama5d2: Fix typo in i2s1 node

Ryusuke Konishi (1):
      nilfs2: fix incorrect masking of permission flags for symlinks

Stafford Horne (1):
      irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

Steven Rostedt (Google) (1):
      net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Tejun Heo (1):
      cgroup: Use separate src/dst nodes when preloading css_sets for migration

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix event pending check

Xiu Jianfeng (1):
      Revert "evm: Fix memleak in init_desc"

Yi Yang (1):
      serial: 8250: fix return error code in serial8250_request_std_resource()

Zhen Lei (1):
      ARM: 9210/1: Mark the FDT_FIXED sections as shareable

Zheng Yejian (1):
      tracing/histograms: Fix memory leak problem

Íñigo Huguet (2):
      sfc: fix use after free when disabling sriov
      sfc: fix kernel panic when creating VF

