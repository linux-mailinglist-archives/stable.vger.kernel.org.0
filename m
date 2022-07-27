Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40530582BCA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbiG0QiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238347AbiG0QhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A554C613;
        Wed, 27 Jul 2022 09:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1BF0619FF;
        Wed, 27 Jul 2022 16:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3A4C433D6;
        Wed, 27 Jul 2022 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939294;
        bh=FJB6YvgF4vTxzWh37WtnjYz3mBlhKx0zmLuJtYlSfKY=;
        h=From:To:Cc:Subject:Date:From;
        b=R2bT1xVloNxMEmC7Q6UIxNdAOguBx1oK+sNmbDp0ayfxeOaKec0NitIeyce2y+Off
         iUcBXayk3Y2X1uyMdr1pm/iaJtlDNxjetFMnqxitsWFwLQcr4DjxL7iw4uK6BJ5pzy
         X2HMrPA3r5IwM0SB4SEittBj2LGnPPr32U08P9Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/87] 5.4.208-rc1 review
Date:   Wed, 27 Jul 2022 18:09:53 +0200
Message-Id: <20220727161008.993711844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.208-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.208-rc1
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

This is the start of the stable review cycle for the 5.4.208 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.208-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.208-rc1

Jan Beulich <jbeulich@suse.com>
    x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a needs FLAG_SEND_ZLP

Jiri Slaby <jslaby@suse.cz>
    tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jiri Slaby <jslaby@suse.cz>
    tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()

Jiri Slaby <jslaby@suse.cz>
    tty: drop tty_schedule_flip()

Jiri Slaby <jslaby@suse.cz>
    tty: the rest, stop using tty_schedule_flip()

Jiri Slaby <jslaby@suse.cz>
    tty: drivers/tty/, stop using tty_schedule_flip()

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

Thomas Gleixner <tglx@linutronix.de>
    x86/mce: Deduplicate exception handling

Michel Lespinasse <walken@google.com>
    mmap locking API: initial implementation as rwsem wrappers

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Implement macros for CMPXCHG on user addresses

Al Viro <viro@zeniv.linux.org.uk>
    x86: get rid of small constant size cases in raw_copy_{to,from}_user()

Will Deacon <will@kernel.org>
    locking/refcount: Consolidate implementations of refcount_t

Will Deacon <will@kernel.org>
    locking/refcount: Consolidate REFCOUNT_{MAX,SATURATED} definitions

Will Deacon <will@kernel.org>
    locking/refcount: Move saturation warnings out of line

Will Deacon <will@kernel.org>
    locking/refcount: Improve performance of generic REFCOUNT_FULL code

Will Deacon <will@kernel.org>
    locking/refcount: Move the bulk of the REFCOUNT_FULL implementation into the <linux/refcount.h> header

Will Deacon <will@kernel.org>
    locking/refcount: Remove unused refcount_*_checked() variants

Will Deacon <will@kernel.org>
    locking/refcount: Ensure integer operands are treated as signed

Will Deacon <will@kernel.org>
    locking/refcount: Define constants for saturation and max refcount values

GUO Zihua <guozihua@huawei.com>
    ima: remove the IMA_TEMPLATE Kconfig option

Alexander Aring <aahringo@redhat.com>
    dlm: fix pending remove if msg allocation fails

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

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
    ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: only use single read/write for No AI mode

Piotr Skajewski <piotrx.skajewski@intel.com>
    ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Dawid Lukwinski <dawid.lukwinski@intel.com>
    i40e: Fix erroneous adapter reinitialization during recovery process

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix handling of dummy receive descriptors

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
    igmp: Fix a data-race around sysctl_igmp_max_memberships.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_llm_reports.

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Fix race in TLS device down flow

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: fix dma queue left shift overflow issue

Robert Hancock <robert.hancock@calian.com>
    i2c: cadence: Change large transfer count reset logic to be unconditional

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
    ip: Fix data-races around sysctl_ip_nonlocal_bind.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_use_pmtu.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_no_pmtu_disc.

Lennert Buytenhek <buytenh@wantstofly.org>
    igc: Reinstate IGC_REMOVED logic and implement it properly

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

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

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

 Makefile                                           |   4 +-
 arch/Kconfig                                       |  21 --
 arch/alpha/kernel/srmcons.c                        |   2 +-
 arch/arm/Kconfig                                   |   1 -
 arch/arm64/Kconfig                                 |   1 -
 arch/riscv/Makefile                                |   1 +
 arch/s390/configs/debug_defconfig                  |   1 -
 arch/x86/Kconfig                                   |   1 -
 arch/x86/include/asm/asm.h                         |   6 -
 arch/x86/include/asm/refcount.h                    | 126 ----------
 arch/x86/include/asm/uaccess.h                     | 154 +++++++++++-
 arch/x86/include/asm/uaccess_32.h                  |  27 ---
 arch/x86/include/asm/uaccess_64.h                  | 108 +--------
 arch/x86/kernel/cpu/mce/core.c                     |  34 +--
 arch/x86/mm/extable.c                              |  49 ----
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   6 +-
 drivers/gpio/gpio-pca953x.c                        |   3 +
 drivers/gpu/drm/i915/Kconfig.debug                 |   1 -
 drivers/i2c/busses/i2c-cadence.c                   |  30 +--
 drivers/misc/lkdtm/refcount.c                      |   8 -
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  31 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  13 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   5 +-
 drivers/net/ethernet/intel/igc/igc_regs.h          |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   3 +
 drivers/net/usb/ax88179_178a.c                     |  16 +-
 drivers/pci/controller/pci-hyperv.c                | 100 ++++++--
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  18 +-
 drivers/power/reset/arm-versatile-reboot.c         |   1 +
 drivers/s390/char/keyboard.h                       |   4 +-
 drivers/spi/spi-bcm2835.c                          |  12 +-
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |   2 +
 drivers/staging/speakup/spk_ttyio.c                |   4 +-
 drivers/tty/cyclades.c                             |   6 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/moxa.c                                 |   4 +-
 drivers/tty/pty.c                                  |  14 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   2 +-
 drivers/tty/serial/mvebu-uart.c                    |  25 +-
 drivers/tty/tty_buffer.c                           |  66 +++--
 drivers/tty/vt/keyboard.c                          |   6 +-
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/xen/gntdev.c                               |   3 +-
 fs/dlm/lock.c                                      |   3 +-
 include/linux/bitfield.h                           |  19 +-
 include/linux/mm.h                                 |   1 +
 include/linux/mmap_lock.h                          |  54 +++++
 include/linux/refcount.h                           | 269 ++++++++++++++++++---
 include/linux/tty_flip.h                           |   4 +-
 include/net/bluetooth/bluetooth.h                  |  65 +++++
 include/net/inet_sock.h                            |   5 +-
 include/net/ip.h                                   |   4 +-
 include/net/tcp.h                                  |   9 +-
 include/net/udp.h                                  |   2 +-
 kernel/bpf/core.c                                  |   8 +-
 kernel/events/core.c                               |  45 ++--
 lib/refcount.c                                     | 255 +++----------------
 mm/mempolicy.c                                     |   2 +-
 net/bluetooth/rfcomm/core.c                        |  50 +++-
 net/bluetooth/rfcomm/sock.c                        |  46 +---
 net/bluetooth/sco.c                                |  30 +--
 net/core/filter.c                                  |   4 +-
 net/core/secure_seq.c                              |   4 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    |  23 +-
 net/ipv4/route.c                                   |   2 +-
 net/ipv4/syncookies.c                              |   9 +-
 net/ipv4/tcp.c                                     |  10 +-
 net/ipv4/tcp_fastopen.c                            |   4 +-
 net/ipv4/tcp_input.c                               |  51 ++--
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |  29 +--
 net/ipv4/tcp_recovery.c                            |   6 +-
 net/ipv4/tcp_timer.c                               |  20 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/sctp/protocol.c                                |   2 +-
 net/tls/tls_device.c                               |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 security/integrity/ima/Kconfig                     |  12 +-
 security/integrity/ima/ima_policy.c                |   4 +
 sound/core/memalloc.c                              |   1 +
 93 files changed, 1046 insertions(+), 990 deletions(-)


