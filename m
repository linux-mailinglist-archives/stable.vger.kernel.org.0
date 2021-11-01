Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9124E4416DF
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhKAJaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhKAJ2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E2961211;
        Mon,  1 Nov 2021 09:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758585;
        bh=jJlnU4hJEHq+Mo32UtlI/7G/atqMZJGtyA5nkfPfS/8=;
        h=From:To:Cc:Subject:Date:From;
        b=EWLqUhRYYVS8V0nUTwRafN7Yru8VNrtDPejOQheAQRLbkKsB7stbrRZdzhJR0de0V
         FAQ/+d6EREd9FMsQT1ouDU41DcF83gvvdA42A58LssUJmJLyCtsdyLJbaXDkVUEBZ7
         5Mc/uYgC/ZphFer30Jo9nLl8QgwsUo5QrvKeZ8RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/51] 5.4.157-rc1 review
Date:   Mon,  1 Nov 2021 10:17:04 +0100
Message-Id: <20211101082500.203657870@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.157-rc1
X-KernelTest-Deadline: 2021-11-03T08:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.157 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.157-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.157-rc1

Song Liu <songliubraving@fb.com>
    perf script: Check session->header.env.arch before using it

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Halil Pasic <pasic@linux.ibm.com>
    KVM: s390: clear kicked_mask before sleeping again

Janusz Dziedzic <janusz.dziedzic@gmail.com>
    cfg80211: correct bridge/4addr mode check

Julian Wiedmann <jwi@linux.ibm.com>
    net: use netif_is_bridge_port() to check for IFF_BRIDGE_PORT

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_ootb

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_do_8_5_1_E_sa

Xin Long <lucien.xin@gmail.com>
    sctp: add vtag check in sctp_sf_violation

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for COOKIE_ECHO chunk

Xin Long <lucien.xin@gmail.com>
    sctp: fix the processing for INIT_ACK chunk

Xin Long <lucien.xin@gmail.com>
    sctp: use init_tag from inithdr for ABORT chunk

Andrew Lunn <andrew@lunn.ch>
    phy: phy_start_aneg: Add an unlocked version

Andrew Lunn <andrew@lunn.ch>
    phy: phy_ethtool_ksettings_get: Lock the phy for consistency

Daniel Jordan <daniel.m.jordan@oracle.com>
    net/tls: Fix flipped sign in async_wait.err assignment

Trevor Woerner <twoerner@gmail.com>
    net: nxp: lpc_eth.c: avoid hang when bringing interface down

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails

Guenter Roeck <linux@roeck-us.net>
    nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Mark Zhang <markzhang@nvidia.com>
    RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string

Michael Chan <michael.chan@broadcom.com>
    net: Prevent infinite while loop in skb_tx_hash()

Pavel Skripkin <paskripkin@gmail.com>
    net: batman-adv: fix error handling

Yang Yingliang <yangyingliang@huawei.com>
    regmap: Fix possible double-free in regcache_rbtree_exit()

Clément Bœsch <u@pkh.me>
    arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Set user priority for DCT

Varun Prakash <varun@chelsio.com>
    nvme-tcp: fix data digest pointer calculation

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: fix data digest pointer calculation

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Fix abba locking issue with sc_disable()

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Liu Jian <liujian56@huawei.com>
    tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Christian König <christian.koenig@amd.com>
    drm/ttm: fix memleak in ttm_transfered_destroy

Johan Hovold <johan@kernel.org>
    net: lan78xx: fix division by zero in send path

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Jaehoon Chung <jh80.chung@samsung.com>
    mmc: dw_mmc: exynos: fix the finding clock sample value

Wenbin Mei <wenbin.mei@mediatek.com>
    mmc: cqhci: clear HALT state after CQE enable

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix control-message timeouts

Daniel Jordan <daniel.m.jordan@oracle.com>
    net/tls: Fix flipped sign in tls_err_abort() calls

Pavel Skripkin <paskripkin@gmail.com>
    Revert "net: mdiobus: Fix memory leak in __mdiobus_register"

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: port100: fix using -ERRNO as command type mask

Zheyu Ma <zheyuma97@gmail.com>
    ata: sata_mv: Fix the error handling of mv_chip_id()

Rafał Miłecki <rafal@milecki.pl>
    Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"

Wang Hai <wanghai38@huawei.com>
    usbnet: fix error return code in usbnet_probe()

Oliver Neukum <oneukum@suse.com>
    usbnet: sanity check for maxpacket

Eric Dumazet <edumazet@google.com>
    ipv4: use siphash instead of Jenkins in fnhe_hashfun()

Eric Dumazet <edumazet@google.com>
    ipv6: use siphash in rt6_exception_hash()

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/bpf: Fix BPF_MOD when imm == 1

Arnd Bergmann <arnd@arndb.de>
    ARM: 9141/1: only warn about XIP address when not compile testing

Arnd Bergmann <arnd@arndb.de>
    ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype

Arnd Bergmann <arnd@arndb.de>
    ARM: 9134/1: remove duplicate memcpy() definition

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/boot/compressed/decompress.c              |  3 +
 arch/arm/kernel/vmlinux-xip.lds.S                  |  2 +-
 arch/arm/mm/proc-macros.S                          |  1 +
 arch/arm/probes/kprobes/core.c                     |  2 +-
 .../boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts   |  2 +-
 arch/nios2/platform/Kconfig.platform               |  1 +
 arch/powerpc/net/bpf_jit_comp64.c                  | 10 +++-
 arch/s390/kvm/interrupt.c                          |  5 +-
 arch/s390/kvm/kvm-s390.c                           |  1 +
 drivers/ata/sata_mv.c                              |  4 +-
 drivers/base/regmap/regcache-rbtree.c              |  7 +--
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  1 +
 drivers/infiniband/core/sa_query.c                 |  5 +-
 drivers/infiniband/hw/hfi1/pio.c                   |  9 ++-
 drivers/infiniband/hw/mlx5/qp.c                    |  2 +
 drivers/infiniband/hw/qib/qib_user_sdma.c          | 33 +++++++----
 drivers/mmc/host/cqhci.c                           |  3 +
 drivers/mmc/host/dw_mmc-exynos.c                   | 14 +++++
 drivers/mmc/host/sdhci-esdhc-imx.c                 | 16 ++++++
 drivers/mmc/host/sdhci.c                           |  6 ++
 drivers/mmc/host/vub300.c                          | 18 +++---
 drivers/net/bonding/bond_main.c                    |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c              |  2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      | 22 +++++++
 drivers/net/ethernet/nxp/lpc_eth.c                 |  5 +-
 drivers/net/phy/mdio_bus.c                         |  1 -
 drivers/net/phy/phy.c                              | 32 +++++++++--
 drivers/net/usb/lan78xx.c                          |  6 ++
 drivers/net/usb/usbnet.c                           |  5 ++
 drivers/nfc/port100.c                              |  4 +-
 drivers/nvme/host/tcp.c                            |  2 +-
 drivers/nvme/target/tcp.c                          |  2 +-
 drivers/pinctrl/bcm/pinctrl-ns.c                   | 29 ++++------
 include/net/tls.h                                  |  9 +--
 net/batman-adv/bridge_loop_avoidance.c             |  8 ++-
 net/batman-adv/main.c                              | 56 ++++++++++++------
 net/batman-adv/network-coding.c                    |  4 +-
 net/batman-adv/translation-table.c                 |  4 +-
 net/core/dev.c                                     |  6 ++
 net/core/rtnetlink.c                               | 12 ++--
 net/ipv4/route.c                                   | 12 ++--
 net/ipv4/tcp_bpf.c                                 | 12 ++++
 net/ipv6/route.c                                   | 20 +++++--
 net/sctp/sm_statefuns.c                            | 67 +++++++++++++---------
 net/tls/tls_sw.c                                   | 19 ++++--
 net/wireless/nl80211.c                             |  2 +-
 net/wireless/scan.c                                |  7 ++-
 net/wireless/util.c                                | 14 ++---
 tools/perf/builtin-script.c                        | 12 ++--
 50 files changed, 359 insertions(+), 166 deletions(-)


