Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073E7582CB2
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbiG0Qtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbiG0QtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10D752FE4;
        Wed, 27 Jul 2022 09:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E414DB81F90;
        Wed, 27 Jul 2022 16:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12040C433C1;
        Wed, 27 Jul 2022 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939564;
        bh=OYiHwai86YaHaNca5+Eg+el4bPH7GP//V0E0N11w1mg=;
        h=From:To:Cc:Subject:Date:From;
        b=IhU8VLQEeOAQf0pxOyCwKfd53Bq91Q7Tcxwvk+E6vyftZHfZTKQhh9EuXoJJYQhFC
         EVe0NiiTGrxdg2JSIbNKZzgLWfmbsyjundgPYmpzwrL1bopHDouWR8NDXKtsorUTF5
         2ZGXAAxI7eGsmGe6SN8F6+oKZ/O8fGf3KxPc07Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/105] 5.10.134-rc1 review
Date:   Wed, 27 Jul 2022 18:09:46 +0200
Message-Id: <20220727161012.056867467@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.134-rc1
X-KernelTest-Deadline: 2022-07-29T16:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.134 release.
There are 105 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.134-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.134-rc1

Christoph Hellwig <hch@lst.de>
    block-crypto-fallback: use a bio_set for splitting bios

Ming Lei <ming.lei@redhat.com>
    block: fix memory leak of bvec

Linus Torvalds <torvalds@linux-foundation.org>
    watch-queue: remove spurious double semicolon

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a needs FLAG_SEND_ZLP

Jiri Slaby <jirislaby@kernel.org>
    tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jiri Slaby <jirislaby@kernel.org>
    tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()

Jiri Slaby <jirislaby@kernel.org>
    tty: drop tty_schedule_flip()

Jiri Slaby <jirislaby@kernel.org>
    tty: the rest, stop using tty_schedule_flip()

Jiri Slaby <jirislaby@kernel.org>
    tty: drivers/tty/, stop using tty_schedule_flip()

Linus Torvalds <torvalds@linux-foundation.org>
    watchqueue: make sure to serialize 'wqueue->defunct' properly

Kees Cook <keescook@chromium.org>
    x86/alternative: Report missing return thunk details

Peter Zijlstra <peterz@infradead.org>
    x86/amd: Use IBPB for firmware calls

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix sco_send_frame returning skb->len

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix passing NULL to PTR_ERR

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Add bt_skb_sendmmsg helper

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Add bt_skb_sendmsg helper

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Align buffer allocations in page size

Peter Zijlstra <peterz@infradead.org>
    bitfield.h: Fix "type of reg too small for mask" test

Wang ShaoBo <bobo.shaobowang@huawei.com>
    drm/imx/dcss: fix unused but set variable warnings

Alexander Aring <aahringo@redhat.com>
    dlm: fix pending remove if msg allocation fails

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix BUG_ON condition for deboosted tasks

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: Don't null dereference ops->destroy

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_max_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_rfc1337.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_stdurg.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_retrans_collapse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_recovery.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_early_retrans.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl knobs related to SYN option.

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Fix a data-race around sysctl_udp_l3mdev_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_prot_sock.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.

Liang He <windhl@126.com>
    drm/imx/dcss: Add missing of_node_put() in fail path

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct register address when regcache sync during init

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct range when do regmap sync

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: only use single read/write for No AI mode

Piotr Skajewski <piotrx.skajewski@intel.com>
    ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Dawid Lukwinski <dawid.lukwinski@intel.com>
    i40e: Fix erroneous adapter reinitialization during recovery process

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix handling of dummy receive descriptors

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_max_syn_backlog.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_tw_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around some timeout sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_syncookies.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around keepalive sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_max_msf.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix a data-race around sysctl_igmp_max_memberships.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_llm_reports.

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Fix race in TLS device down flow

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: fix dma queue left shift overflow issue

Robert Hancock <robert.hancock@calian.com>
    i2c: cadence: Change large transfer count reset logic to be unconditional

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_interval.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_threshold.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_min_snd_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_base_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_mtu_probing.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_fwmark_reflect.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_ip_autobind_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_nonlocal_bind.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_update_priority.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_use_pmtu.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_no_pmtu_disc.

Lennert Buytenhek <buytenh@wantstofly.org>
    igc: Reinstate IGC_REMOVED logic and implement it properly

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: add quirk handling for stutter mode

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

William Dean <williamsukatube@gmail.com>
    pinctrl: ralink: Check for null return of devm_kcalloc

Miaoqian Lin <linmq006@gmail.com>
    power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Hangyu Hua <hbh25y@gmail.com>
    xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: correctly report configured baudrate value

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix interrupt mapping for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix multi-MSI to allow more than one MSI vector

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch"

Fedor Pchelkin <pchelkin@ispras.ru>
    net: inline rollback_registered_many()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: move rollback_registered_many()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: inline rollback_registered()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: move net_set_todo inside rollback_registered()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: make sure devices go through netdev_wait_all_refs

Fedor Pchelkin <pchelkin@ispras.ru>
    net: make free_netdev() more lenient with unregistering devices

Fedor Pchelkin <pchelkin@ispras.ru>
    docs: net: explain struct net_device lifetime

Christoph Hellwig <hch@lst.de>
    block: fix bounce_clone_bio for passthrough bios

Christoph Hellwig <hch@lst.de>
    block: split bio_kmalloc from bio_alloc_bioset

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Lee Jones <lee@kernel.org>
    io_uring: Use original task for req identity in io_identity_cow()

Eric Snowberg <eric.snowberg@oracle.com>
    lockdown: Fix kexec lockdown bypass with ima policy

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: add as-options for modules with assembly compontents

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: fix optional IRQ support to gpios


-------------

Diffstat:

 Documentation/networking/netdevices.rst            | 171 ++++++++++++++-
 Makefile                                           |   4 +-
 arch/alpha/kernel/srmcons.c                        |   2 +-
 arch/m68k/Kconfig.bus                              |   2 +-
 arch/riscv/Makefile                                |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/mshyperv.h                    |   7 -
 arch/x86/include/asm/nospec-branch.h               |   2 +
 arch/x86/kernel/alternative.c                      |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 +-
 block/bio.c                                        | 166 ++++++++-------
 block/blk-crypto-fallback.c                        |  12 +-
 block/bounce.c                                     |  17 +-
 drivers/accessibility/speakup/spk_ttyio.c          |   4 +-
 drivers/gpio/gpio-pca953x.c                        |  22 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  33 +++
 drivers/gpu/drm/imx/dcss/dcss-dev.c                |   3 +
 drivers/gpu/drm/imx/dcss/dcss-plane.c              |   2 -
 drivers/i2c/busses/i2c-cadence.c                   |  30 +--
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   6 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  31 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  13 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   5 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/igc/igc_regs.h          |   5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  17 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/usb/ax88179_178a.c                     |  20 +-
 drivers/pci/controller/pci-hyperv.c                |  99 +++++++--
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  18 +-
 drivers/power/reset/arm-versatile-reboot.c         |   1 +
 drivers/s390/char/keyboard.h                       |   4 +-
 drivers/spi/spi-bcm2835.c                          |  12 +-
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |   2 +
 drivers/tty/cyclades.c                             |   6 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/moxa.c                                 |   4 +-
 drivers/tty/pty.c                                  |  14 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   2 +-
 drivers/tty/serial/mvebu-uart.c                    |  25 +--
 drivers/tty/tty_buffer.c                           |  66 ++++--
 drivers/tty/vt/keyboard.c                          |   6 +-
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/xen/gntdev.c                               |   3 +-
 fs/dlm/lock.c                                      |   3 +-
 fs/io_uring.c                                      |   2 +-
 include/linux/bio.h                                |   6 +-
 include/linux/bitfield.h                           |  19 +-
 include/linux/tty_flip.h                           |   4 +-
 include/net/bluetooth/bluetooth.h                  |  65 ++++++
 include/net/inet_sock.h                            |   5 +-
 include/net/ip.h                                   |   6 +-
 include/net/tcp.h                                  |  18 +-
 include/net/udp.h                                  |   2 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/events/core.c                               |  45 ++--
 kernel/sched/deadline.c                            |   5 +-
 kernel/watch_queue.c                               |  53 +++--
 mm/mempolicy.c                                     |   2 +-
 net/8021q/vlan.c                                   |   4 +-
 net/bluetooth/rfcomm/core.c                        |  50 ++++-
 net/bluetooth/rfcomm/sock.c                        |  46 +---
 net/bluetooth/sco.c                                |  30 +--
 net/core/dev.c                                     | 233 ++++++++++-----------
 net/core/filter.c                                  |   4 +-
 net/core/rtnetlink.c                               |  23 +-
 net/core/secure_seq.c                              |   4 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    |  25 ++-
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/ip_forward.c                              |   2 +-
 net/ipv4/ip_sockglue.c                             |   6 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/sysctl_net_ipv4.c                         |   6 +-
 net/ipv4/tcp.c                                     |  10 +-
 net/ipv4/tcp_fastopen.c                            |   9 +-
 net/ipv4/tcp_input.c                               |  51 +++--
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |  29 +--
 net/ipv4/tcp_recovery.c                            |   6 +-
 net/ipv4/tcp_timer.c                               |  20 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/sctp/protocol.c                                |   2 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/tls/tls_device.c                               |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 security/integrity/ima/ima_policy.c                |   4 +
 sound/core/memalloc.c                              |   1 +
 virt/kvm/kvm_main.c                                |   5 +-
 103 files changed, 1115 insertions(+), 649 deletions(-)


