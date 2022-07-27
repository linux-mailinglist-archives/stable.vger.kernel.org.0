Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABD582B56
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiG0QcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiG0Qbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:31:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BAD252E65;
        Wed, 27 Jul 2022 09:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F38B821C5;
        Wed, 27 Jul 2022 16:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70593C433D6;
        Wed, 27 Jul 2022 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939125;
        bh=dkDZF/pxtYGjls8v77g4+ZDmqI28zcGKWebVjqXHMk0=;
        h=From:To:Cc:Subject:Date:From;
        b=bvbnHITR6hsX68MUTVZ655yc4+iMD774zdhoLk6EOsLhFPeQNkRGG918duv0SYToJ
         /Nras+5TeZHBnI03a2/z6Fv1zFTgj4JRV8rdRuwl+NELWs2BNvcEhNLD1j+Tm2Z/To
         94swCUxV+uX2VJ5sHyEWpvqh9xpEknqDWnHWj7Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/62] 4.19.254-rc1 review
Date:   Wed, 27 Jul 2022 18:10:09 +0200
Message-Id: <20220727161004.175638564@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.254-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.254-rc1
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

This is the start of the stable review cycle for the 4.19.254 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.254-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.254-rc1

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix interrupt mapping for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix multi-MSI to allow more than one MSI vector

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

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: correctly report configured baudrate value

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

GUO Zihua <guozihua@huawei.com>
    ima: remove the IMA_TEMPLATE Kconfig option

Alexander Aring <aahringo@redhat.com>
    dlm: fix pending remove if msg allocation fails

Tony Fischetti <tony.fischetti@gmail.com>
    HID: add ALWAYS_POLL quirk to lenovo pixart mouse

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: add support for the Smart Tech panel

Mikael Wikström <leakim.wikstrom@gmail.com>
    HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: simplify the application retrieval

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator

Jyri Sarha <jsarha@ti.com>
    drm/tilcdc: Remove obsolete crtc_mode_valid() hack

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Jason A. Donenfeld <Jason@zx2c4.com>
    Revert "Revert "char/random: silence a lockdep splat with printk()""

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

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_tw_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around some timeout sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reordering.

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
    tcp: Fix data-races around sysctl_tcp_mtu_probing.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_fwmark_reflect.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_nonlocal_bind.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_use_pmtu.

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

William Dean <williamsukatube@gmail.com>
    pinctrl: ralink: Check for null return of devm_kcalloc

Miaoqian Lin <linmq006@gmail.com>
    power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Hangyu Hua <hbh25y@gmail.com>
    xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: add as-options for modules with assembly compontents


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/alpha/kernel/srmcons.c                       |   2 +-
 arch/riscv/Makefile                               |   1 +
 drivers/char/random.c                             |   4 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c              |  28 +++---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c               |   1 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.h               |   2 -
 drivers/gpu/drm/tilcdc/tilcdc_external.c          |  96 +++----------------
 drivers/gpu/drm/tilcdc/tilcdc_external.h          |   1 -
 drivers/gpu/drm/tilcdc/tilcdc_panel.c             |   9 --
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c            |   9 --
 drivers/hid/hid-ids.h                             |   2 +
 drivers/hid/hid-multitouch.c                      | 112 +++++++++++++---------
 drivers/hid/hid-quirks.c                          |   1 +
 drivers/i2c/busses/i2c-cadence.c                  |  30 +-----
 drivers/net/ethernet/emulex/benet/be_cmds.c       |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h       |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c    |  31 +++---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |   3 +
 drivers/net/usb/ax88179_178a.c                    |  16 ++--
 drivers/pci/controller/pci-hyperv.c               | 100 +++++++++++++++----
 drivers/power/reset/arm-versatile-reboot.c        |   1 +
 drivers/s390/char/keyboard.h                      |   4 +-
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c   |   2 +
 drivers/staging/speakup/spk_ttyio.c               |   4 +-
 drivers/tty/cyclades.c                            |   6 +-
 drivers/tty/goldfish.c                            |   2 +-
 drivers/tty/moxa.c                                |   4 +-
 drivers/tty/pty.c                                 |  14 +--
 drivers/tty/serial/lpc32xx_hs.c                   |   2 +-
 drivers/tty/serial/mvebu-uart.c                   |  25 ++---
 drivers/tty/tty_buffer.c                          |  66 ++++++++-----
 drivers/tty/vt/keyboard.c                         |   6 +-
 drivers/tty/vt/vt.c                               |   2 +-
 drivers/xen/gntdev.c                              |   3 +-
 fs/dlm/lock.c                                     |   3 +-
 include/linux/tty_flip.h                          |   4 +-
 include/net/bluetooth/bluetooth.h                 |  65 +++++++++++++
 include/net/inet_sock.h                           |   5 +-
 include/net/ip.h                                  |   4 +-
 include/net/tcp.h                                 |   9 +-
 kernel/bpf/core.c                                 |   8 +-
 kernel/events/core.c                              |  45 ++++++---
 mm/mempolicy.c                                    |   2 +-
 net/bluetooth/rfcomm/core.c                       |  50 ++++++++--
 net/bluetooth/rfcomm/sock.c                       |  46 ++-------
 net/bluetooth/sco.c                               |  30 ++----
 net/ipv4/af_inet.c                                |   2 +-
 net/ipv4/igmp.c                                   |  23 +++--
 net/ipv4/route.c                                  |   2 +-
 net/ipv4/tcp.c                                    |  10 +-
 net/ipv4/tcp_fastopen.c                           |   4 +-
 net/ipv4/tcp_input.c                              |  19 ++--
 net/ipv4/tcp_ipv4.c                               |   2 +-
 net/ipv4/tcp_metrics.c                            |   3 +-
 net/ipv4/tcp_minisocks.c                          |   2 +-
 net/ipv4/tcp_output.c                             |  14 +--
 net/ipv4/tcp_recovery.c                           |   6 +-
 net/ipv4/tcp_timer.c                              |  14 +--
 net/sctp/protocol.c                               |   2 +-
 net/tls/tls_device.c                              |   8 +-
 net/xfrm/xfrm_policy.c                            |   5 +-
 security/integrity/ima/Kconfig                    |  12 +--
 sound/core/memalloc.c                             |   1 +
 64 files changed, 555 insertions(+), 450 deletions(-)


