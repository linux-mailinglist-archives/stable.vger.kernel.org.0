Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BBFB876A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405142AbfISWGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405139AbfISWGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:06:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6FB21907;
        Thu, 19 Sep 2019 22:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930770;
        bh=jeSySUfleWeX2Y/EGvf5SlLYq5xu2WCm2zPbshQ8Unk=;
        h=From:To:Cc:Subject:Date:From;
        b=HbiOGsIQpRc+J7WtsirYb5Hq7c1oK9M1h0ryA7ws4T1POgpeDbpPc/WYWqgcdtfhL
         6SSUuUUE0LfvSeL9WQCj2HtDxfntfddUt4MZlE5LZtIa9RJcOCElKQc7NxTU8/OFrN
         ZYgXYVUFH3juUDLPSbfei6WaPfru4gLzc+U/021Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 00/21] 5.3.1-stable review
Date:   Fri, 20 Sep 2019 00:03:01 +0200
Message-Id: <20190919214657.842130855@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.1-rc1
X-KernelTest-Deadline: 2019-09-21T21:47+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.1 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.1-rc1

Sean Young <sean@mess.org>
    media: technisat-usb2: break out of loop at end of buffer

Jann Horn <jannh@google.com>
    floppy: fix usercopy direction

Bjorn Andersson <bjorn.andersson@linaro.org>
    phy: qcom-qmp: Correct ready status, again

Amir Goldstein <amir73il@gmail.com>
    ovl: fix regression caused by overlapping layers detection

Will Deacon <will@kernel.org>
    Revert "arm64: Remove unnecessary ISBs from set_{pte,pmd,pud}"

Masashi Honma <masashi.honma@gmail.com>
    nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    tty/serial: atmel: reschedule TX after RX was started

Chunyan Zhang <chunyan.zhang@unisoc.com>
    serial: sprd: correct the wrong sequence of arguments

Hung-Te Lin <hungte@chromium.org>
    firmware: google: check if size is valid when decoding VPD data

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    Documentation: sphinx: Add missing comma to list of strings

Matt Delco <delco@chromium.org>
    KVM: coalesced_mmio: add bounds checking

Jose Abreu <Jose.Abreu@synopsys.com>
    net: stmmac: Hold rtnl lock in suspend/resume callbacks

Andrew Lunn <andrew@lunn.ch>
    net: dsa: Fix load order between DSA drivers and taggers

Dongli Zhang <dongli.zhang@oracle.com>
    xen-netfront: do not assume sk_buff_head list is empty in error handling

Willem de Bruijn <willemb@google.com>
    udp: correct reuseport selection with connected sockets

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: let qdisc_put() accept NULL pointer

Paolo Abeni <pabeni@redhat.com>
    net/sched: fix race between deactivation and dequeue for NOLOCK qdisc

Xin Long <lucien.xin@gmail.com>
    ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Disable clearing VBUS in over-current

Sean Young <sean@mess.org>
    media: tm6000: double free if usb disconnect while streaming

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Fix slab-out-of-bounds bug during device reset


-------------

Diffstat:

 Documentation/filesystems/overlayfs.txt           |  2 +-
 Documentation/sphinx/automarkup.py                |  2 +-
 Makefile                                          |  4 +-
 arch/arm64/include/asm/pgtable.h                  | 12 +++-
 drivers/block/floppy.c                            |  4 +-
 drivers/firmware/google/vpd.c                     |  4 +-
 drivers/firmware/google/vpd_decode.c              | 55 ++++++++++-------
 drivers/firmware/google/vpd_decode.h              |  6 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c        | 22 ++++---
 drivers/media/usb/tm6000/tm6000-dvb.c             |  3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++--
 drivers/net/xen-netfront.c                        |  2 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c               | 33 +++++-----
 drivers/phy/renesas/phy-rcar-gen3-usb2.c          |  2 +
 drivers/tty/serial/atmel_serial.c                 |  1 -
 drivers/tty/serial/sprd_serial.c                  |  2 +-
 drivers/usb/core/config.c                         | 12 ++--
 fs/overlayfs/ovl_entry.h                          |  1 +
 fs/overlayfs/super.c                              | 73 +++++++++++++++--------
 include/net/pkt_sched.h                           |  7 ++-
 include/net/sock_reuseport.h                      | 20 ++++++-
 net/core/dev.c                                    | 16 +++--
 net/core/sock_reuseport.c                         | 15 ++++-
 net/dsa/dsa2.c                                    |  2 +
 net/ipv4/datagram.c                               |  2 +
 net/ipv4/udp.c                                    |  5 +-
 net/ipv6/datagram.c                               |  2 +
 net/ipv6/ip6_gre.c                                |  2 +-
 net/ipv6/udp.c                                    |  5 +-
 net/sched/sch_generic.c                           |  3 +
 net/wireless/nl80211.c                            |  4 +-
 virt/kvm/coalesced_mmio.c                         | 19 +++---
 32 files changed, 227 insertions(+), 127 deletions(-)


