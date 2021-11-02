Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C604436AE
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhKBTx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 15:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhKBTx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 15:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A05760F45;
        Tue,  2 Nov 2021 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635882650;
        bh=HnDxtjFxO97VGXJktGvT+wvl5YetC7+KwsEdVkz6KAk=;
        h=From:To:Cc:Subject:Date:From;
        b=FC1oP/ejmyMHiOAXyfgeIt6Ud/ma7m0k299MHlQEme/2RzB3zHS2e+CgWt1neEv7z
         83hTYKn+JRdfKNkkXXFuevbzDJ1FbIq0vqCXwzseW/lyESB4OSGqlMGjuK5vcB5qlv
         CFvywfms4VlhAE2yvCrueElmvbeiqdEZ5haP5Ue8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.157
Date:   Tue,  2 Nov 2021 20:50:47 +0100
Message-Id: <163588264722713@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.157 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/compressed/decompress.c                   |    3 
 arch/arm/kernel/vmlinux-xip.lds.S                       |    2 
 arch/arm/mm/proc-macros.S                               |    1 
 arch/arm/probes/kprobes/core.c                          |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts |    2 
 arch/nios2/platform/Kconfig.platform                    |    1 
 arch/powerpc/net/bpf_jit_comp64.c                       |   10 +-
 arch/s390/kvm/interrupt.c                               |    5 -
 arch/s390/kvm/kvm-s390.c                                |    1 
 drivers/ata/sata_mv.c                                   |    4 
 drivers/base/regmap/regcache-rbtree.c                   |    7 -
 drivers/gpu/drm/ttm/ttm_bo_util.c                       |    1 
 drivers/infiniband/core/sa_query.c                      |    5 -
 drivers/infiniband/hw/hfi1/pio.c                        |    9 +-
 drivers/infiniband/hw/mlx5/qp.c                         |    2 
 drivers/infiniband/hw/qib/qib_user_sdma.c               |   33 +++++--
 drivers/mmc/host/cqhci.c                                |    3 
 drivers/mmc/host/dw_mmc-exynos.c                        |   14 +++
 drivers/mmc/host/sdhci-esdhc-imx.c                      |   17 ++++
 drivers/mmc/host/sdhci.c                                |    6 +
 drivers/mmc/host/vub300.c                               |   18 ++--
 drivers/net/bonding/bond_main.c                         |    2 
 drivers/net/ethernet/micrel/ksz884x.c                   |    2 
 drivers/net/ethernet/microchip/lan743x_main.c           |   22 +++++
 drivers/net/ethernet/nxp/lpc_eth.c                      |    5 -
 drivers/net/phy/mdio_bus.c                              |    1 
 drivers/net/phy/phy.c                                   |   32 ++++++-
 drivers/net/usb/lan78xx.c                               |    6 +
 drivers/net/usb/usbnet.c                                |    5 +
 drivers/nfc/port100.c                                   |    4 
 drivers/nvme/host/tcp.c                                 |    2 
 drivers/nvme/target/tcp.c                               |    2 
 drivers/pinctrl/bcm/pinctrl-ns.c                        |   29 ++----
 include/net/tls.h                                       |    9 --
 net/batman-adv/bridge_loop_avoidance.c                  |    8 +
 net/batman-adv/main.c                                   |   56 +++++++++----
 net/batman-adv/network-coding.c                         |    4 
 net/batman-adv/translation-table.c                      |    4 
 net/core/dev.c                                          |    6 +
 net/core/rtnetlink.c                                    |   12 +-
 net/ipv4/route.c                                        |   12 +-
 net/ipv4/tcp_bpf.c                                      |   12 ++
 net/ipv6/route.c                                        |   20 +++-
 net/sctp/sm_statefuns.c                                 |   67 +++++++++-------
 net/tls/tls_sw.c                                        |   19 +++-
 net/wireless/nl80211.c                                  |    2 
 net/wireless/scan.c                                     |    7 +
 net/wireless/util.c                                     |   14 +--
 tools/perf/builtin-script.c                             |   12 +-
 50 files changed, 359 insertions(+), 165 deletions(-)

Andrew Lunn (2):
      phy: phy_ethtool_ksettings_get: Lock the phy for consistency
      phy: phy_start_aneg: Add an unlocked version

Arnd Bergmann (3):
      ARM: 9134/1: remove duplicate memcpy() definition
      ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
      ARM: 9141/1: only warn about XIP address when not compile testing

Christian König (1):
      drm/ttm: fix memleak in ttm_transfered_destroy

Clément Bœsch (1):
      arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node

Daniel Jordan (2):
      net/tls: Fix flipped sign in tls_err_abort() calls
      net/tls: Fix flipped sign in async_wait.err assignment

Eric Dumazet (2):
      ipv6: use siphash in rt6_exception_hash()
      ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Greg Kroah-Hartman (1):
      Linux 5.4.157

Guenter Roeck (1):
      nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Halil Pasic (2):
      KVM: s390: clear kicked_mask before sleeping again
      KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Jaehoon Chung (1):
      mmc: dw_mmc: exynos: fix the finding clock sample value

Janusz Dziedzic (1):
      cfg80211: correct bridge/4addr mode check

Johan Hovold (2):
      mmc: vub300: fix control-message timeouts
      net: lan78xx: fix division by zero in send path

Johannes Berg (1):
      cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()

Julian Wiedmann (1):
      net: use netif_is_bridge_port() to check for IFF_BRIDGE_PORT

Krzysztof Kozlowski (1):
      nfc: port100: fix using -ERRNO as command type mask

Liu Jian (1):
      tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Mark Zhang (1):
      RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string

Michael Chan (1):
      net: Prevent infinite while loop in skb_tx_hash()

Mike Marciniszyn (2):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
      IB/hfi1: Fix abba locking issue with sc_disable()

Naveen N. Rao (1):
      powerpc/bpf: Fix BPF_MOD when imm == 1

Nick Desaulniers (1):
      ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Patrisious Haddad (1):
      RDMA/mlx5: Set user priority for DCT

Pavel Skripkin (2):
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
      net: batman-adv: fix error handling

Rafał Miłecki (1):
      Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"

Shawn Guo (1):
      mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Song Liu (1):
      perf script: Check session->header.env.arch before using it

Trevor Woerner (1):
      net: nxp: lpc_eth.c: avoid hang when bringing interface down

Varun Prakash (2):
      nvmet-tcp: fix data digest pointer calculation
      nvme-tcp: fix data digest pointer calculation

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Wenbin Mei (1):
      mmc: cqhci: clear HALT state after CQE enable

Xin Long (6):
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: fix the processing for INIT_ACK chunk
      sctp: fix the processing for COOKIE_ECHO chunk
      sctp: add vtag check in sctp_sf_violation
      sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
      sctp: add vtag check in sctp_sf_ootb

Yang Yingliang (1):
      regmap: Fix possible double-free in regcache_rbtree_exit()

Yuiko Oshino (2):
      net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
      net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent

Zheyu Ma (1):
      ata: sata_mv: Fix the error handling of mv_chip_id()

