Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8C5798DA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiGSLzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbiGSLzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E0237F0;
        Tue, 19 Jul 2022 04:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 587AB615C9;
        Tue, 19 Jul 2022 11:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF145C341C6;
        Tue, 19 Jul 2022 11:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231742;
        bh=P7uujoagZVXY2+acqi8cFz5hWUXidjPWFFNbDMUaMHw=;
        h=From:To:Cc:Subject:Date:From;
        b=DSJ+GPkurSgI7EuVIJN9g+hOb1SwWxLk7JmdjgCsv3mcq/1+nbiuI0MfwEwNaP4y8
         uNiigBDHFQ1rou0DZ5TT5wannsiwbNG/Ey5+hyjfXrJPRNNaXBrTGQgGSG6Ad+x98Q
         /QTm06barjDofLCxBY6AxTOAu/PKOAwrVWx5EMvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/28] 4.9.324-rc1 review
Date:   Tue, 19 Jul 2022 13:53:38 +0200
Message-Id: <20220719114455.701304968@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.324-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.324-rc1
X-KernelTest-Deadline: 2022-07-21T11:44+00:00
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

This is the start of the stable review cycle for the 4.9.324 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.324-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.324-rc1

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

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm5110: Fix DRE control

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix off by one in range control validation

Michael Walle <michael@walle.cc>
    NFC: nxp-nci: don't print header length mismatch on i2c error

Hangyu Hua <hbh25y@gmail.com>
    net: tipc: fix possible refcount leak in tipc_sk_create()

Liang He <windhl@126.com>
    cpufreq: pmac32-cpufreq: Fix refcount leak bug

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Restore guest page size on resume

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    virtio_mmio: Add missing PM calls to freeze/restore

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix kernel panic when creating VF

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix use after free when disabling sriov

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_ip_dynaddr.

Kuniyuki Iwashima <kuniyu@amazon.com>
    icmp: Fix data-races around sysctl.

Kuniyuki Iwashima <kuniyu@amazon.com>
    cipso: Fix data-races around sysctl.

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle

Doug Berger <opendmb@gmail.com>
    net: dsa: bcm_sf2: force pause link settings

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect masking of permission flags for symlinks

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    ARM: 9213/1: Print message about disabled Spectre workarounds only once

Steven Rostedt (Google) <rostedt@goodmis.org>
    net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer

Juergen Gross <jgross@suse.com>
    xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue

Meng Tang <tangmeng@uniontech.com>
    ALSA: hda - Add fixup for Dell Latitidue E5430

James Morse <james.morse@arm.com>
    arm64: entry: Restore tramp_map_kernel ISB


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt |  4 ++--
 Makefile                               |  4 ++--
 arch/arm/mm/proc-v7-bugs.c             |  9 ++++-----
 arch/arm64/kernel/entry.S              |  1 +
 arch/x86/kernel/head64.c               |  2 ++
 drivers/cpufreq/pmac32-cpufreq.c       |  4 ++++
 drivers/net/can/m_can/m_can.c          |  5 +++--
 drivers/net/dsa/bcm_sf2.c              | 19 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef10.c        |  3 +++
 drivers/net/ethernet/sfc/ef10_sriov.c  | 10 +++++++---
 drivers/net/xen-netback/rx.c           |  1 +
 drivers/nfc/nxp-nci/i2c.c              |  8 ++++++--
 drivers/tty/serial/8250/8250_port.c    |  4 +++-
 drivers/tty/serial/samsung.c           |  5 ++---
 drivers/usb/dwc3/gadget.c              |  4 +++-
 drivers/usb/serial/ftdi_sio.c          |  3 +++
 drivers/usb/serial/ftdi_sio_ids.h      |  6 ++++++
 drivers/virtio/virtio_mmio.c           | 26 ++++++++++++++++++++++++++
 fs/nilfs2/nilfs.h                      |  3 +++
 include/trace/events/sock.h            |  6 ++++--
 kernel/signal.c                        |  8 ++++----
 mm/memory.c                            |  9 +++++++--
 net/ipv4/af_inet.c                     |  4 ++--
 net/ipv4/cipso_ipv4.c                  | 12 +++++++-----
 net/ipv4/icmp.c                        |  5 +++--
 net/tipc/socket.c                      |  1 +
 sound/pci/hda/patch_realtek.c          |  1 +
 sound/soc/codecs/wm5110.c              |  8 ++++++--
 sound/soc/soc-ops.c                    |  4 ++--
 29 files changed, 137 insertions(+), 42 deletions(-)


