Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A94579914
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiGSL6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbiGSL6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:58:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0919D46D80;
        Tue, 19 Jul 2022 04:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFE16165B;
        Tue, 19 Jul 2022 11:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E506DC341CB;
        Tue, 19 Jul 2022 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231820;
        bh=ooS0I+eC6PtPB7b+zKScaFejKGD8WQRseHnonxoNLN0=;
        h=From:To:Cc:Subject:Date:From;
        b=vHw6Dih9hkynWDyCpOLXhQ8dO82WR4HYmHyfjRHn9mDLEjpKjcS/MyyXjOrMLQUH/
         r3uDLdXgchz/8U0yow/BnhPpgkRkNlOvfVXAeoxXOfBALDypDgej9xm5eLqHmixlMJ
         HEmfV5N2erbOkoBMh+TIVpdVFiVV7HmcJ8KZ3lEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/43] 4.14.289-rc1 review
Date:   Tue, 19 Jul 2022 13:53:31 +0200
Message-Id: <20220719114521.868169025@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.289-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.289-rc1
X-KernelTest-Deadline: 2022-07-21T11:45+00:00
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

This is the start of the stable review cycle for the 4.14.289 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.289-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.289-rc1

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_tx_handler(): fix use after free of skb

Rik van Riel <riel@surriel.com>
    mm: invalidate hwpoison page cache page in fault path

Yi Yang <yiyang13@huawei.com>
    serial: 8250: fix return error code in serial8250_request_std_resource()

Chanho Park <chanho61.park@samsung.com>
    tty: serial: samsung_tty: set dma burst_size to 1

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix event pending check

Lucien Buchmann <lucien.buchmann@gmx.net>
    USB: serial: ftdi_sio: add Belimo device ids

Linus Torvalds <torvalds@linux-foundation.org>
    signal handling: don't use BUG_ON() for debugging

Juergen Gross <jgross@suse.com>
    x86: Clear .brk area at early boot

Stafford Horne <shorne@gmail.com>
    irqchip: or1k-pic: Undefine mask_ack for level triggered hardware

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm5110: Fix DRE control

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix off by one in range control validation

Jianglei Nie <niejianglei2021@163.com>
    net: sfp: fix memory leak in sfp_probe()

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: don't print header length mismatch on i2c error

Hangyu Hua <hbh25y@gmail.com>
    net: tipc: fix possible refcount leak in tipc_sk_create()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp-wmi: Ignore Sanitization Mode event

Liang He <windhl@126.com>
    cpufreq: pmac32-cpufreq: Fix refcount leak bug

Florian Westphal <fw@strlen.de>
    netfilter: br_netfilter: do not skip all hooks with 0 priority

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Restore guest page size on resume

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Add missing PM calls to freeze/restore

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix kernel panic when creating VF

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix skb checksum evaluation in SRH encapsulation/insertion

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix use after free when disabling sriov

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_ip_dynaddr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratemask.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix a data-race around sysctl_icmp_ratelimit.

Michal Suchanek <msuchanek@suse.de>
    ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    cipso: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix data-races around sysctl_mem.

Kuniyuki Iwashima <kuniyu@amazon.com>
    inetpeer: Fix data-races around sysctl.

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make xhci_handshake timeout for xhci_reset() adjustable

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: bail out early if driver can't accress host in resume

Doug Berger <opendmb@gmail.com>
    net: dsa: bcm_sf2: force pause link settings

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect masking of permission flags for symlinks

Tejun Heo <tj@kernel.org>
    cgroup: Use separate src/dst nodes when preloading css_sets for migration

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    ARM: 9213/1: Print message about disabled Spectre workarounds only once

Steven Rostedt (Google) <rostedt@goodmis.org>
    net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Juergen Gross <jgross@suse.com>
    xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda - Add fixup for Dell Latitidue E5430


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt            |  4 +--
 Makefile                                          |  4 +--
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts |  2 +-
 arch/arm/include/asm/ptrace.h                     | 26 ++++++++++++++++
 arch/arm/mm/alignment.c                           |  3 ++
 arch/arm/mm/proc-v7-bugs.c                        |  9 +++---
 arch/arm/probes/decode.h                          | 26 +---------------
 arch/x86/kernel/head64.c                          |  2 ++
 drivers/cpufreq/pmac32-cpufreq.c                  |  4 +++
 drivers/irqchip/irq-or1k-pic.c                    |  1 -
 drivers/net/can/m_can/m_can.c                     |  5 +--
 drivers/net/dsa/bcm_sf2.c                         | 19 ++++++++++++
 drivers/net/ethernet/sfc/ef10.c                   |  3 ++
 drivers/net/ethernet/sfc/ef10_sriov.c             | 10 ++++--
 drivers/net/phy/sfp.c                             |  2 +-
 drivers/net/xen-netback/rx.c                      |  1 +
 drivers/nfc/nxp-nci/i2c.c                         |  8 +++--
 drivers/platform/x86/hp-wmi.c                     |  3 ++
 drivers/tty/serial/8250/8250_port.c               |  4 ++-
 drivers/tty/serial/samsung.c                      |  5 ++-
 drivers/usb/dwc3/gadget.c                         |  4 ++-
 drivers/usb/host/xhci-hub.c                       |  2 +-
 drivers/usb/host/xhci-mem.c                       |  2 +-
 drivers/usb/host/xhci.c                           | 22 +++++++-------
 drivers/usb/host/xhci.h                           |  7 +++--
 drivers/usb/serial/ftdi_sio.c                     |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h                 |  6 ++++
 drivers/virtio/virtio_mmio.c                      | 26 ++++++++++++++++
 fs/nilfs2/nilfs.h                                 |  3 ++
 include/linux/cgroup-defs.h                       |  3 +-
 include/net/sock.h                                |  2 +-
 include/trace/events/sock.h                       |  6 ++--
 kernel/cgroup/cgroup.c                            | 37 ++++++++++++++---------
 kernel/signal.c                                   |  8 ++---
 mm/memory.c                                       |  9 ++++--
 net/bridge/br_netfilter_hooks.c                   | 21 +++++++++++--
 net/ipv4/af_inet.c                                |  4 +--
 net/ipv4/cipso_ipv4.c                             | 12 +++++---
 net/ipv4/icmp.c                                   | 10 +++---
 net/ipv4/inetpeer.c                               | 12 +++++---
 net/ipv6/seg6_iptunnel.c                          |  5 ++-
 net/ipv6/seg6_local.c                             |  2 --
 net/tipc/socket.c                                 |  1 +
 sound/pci/hda/patch_conexant.c                    |  1 +
 sound/pci/hda/patch_realtek.c                     |  1 +
 sound/soc/codecs/wm5110.c                         |  8 +++--
 sound/soc/soc-ops.c                               |  4 +--
 47 files changed, 249 insertions(+), 113 deletions(-)


