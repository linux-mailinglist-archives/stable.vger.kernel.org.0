Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2534A6368
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiBASRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241869AbiBASQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:16:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF625C061755;
        Tue,  1 Feb 2022 10:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 500F061418;
        Tue,  1 Feb 2022 18:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98DEC340EC;
        Tue,  1 Feb 2022 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739415;
        bh=TDuJuTDku0kHyQpV7ppZT1wjeLf9kcE4/fB7g/DaVgA=;
        h=From:To:Cc:Subject:Date:From;
        b=oLLYH9xrWHS2yJ+XjN3XMpfDM4DacrCxo/G/t2zp8HqCcjPvZmbs3AORofOY7sKrI
         N0DLjxBtYEMPC7amAVsgbUf6DkzkdHZl3bGox5l6isXE91sHNSKqOF+A1oS24Undhz
         MA7QhcDoRrjBEAS/rGXUVL5/iS806R+av9Tc+qmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 4.4 00/25] 4.4.302-rc1 review
Date:   Tue,  1 Feb 2022 19:16:24 +0100
Message-Id: <20220201180822.148370751@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.302-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.302-rc1
X-KernelTest-Deadline: 2022-02-03T18:08+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

NOTE!  This is the proposed LAST 4.4.y kernel release to happen under
the rules of the normal stable kernel releases.  After this one, it will
be marked End-Of-Life as it has been 6 years and you really should know
better by now and have moved to a newer kernel tree.  After this one, no
more security fixes will be backported and you will end up with an
insecure system over time.

--------------------------

This is the start of the stable review cycle for the 4.4.302 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Feb 2022 18:08:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.302-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.302-rc1

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    KVM: x86: Fix misplaced backport of "work around leak of uninitialized stack contents"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    Revert "tc358743: fix register i2c_rd/wr function fix"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    Revert "drm/radeon/ci: disable mclk switching for high refresh rates (v2)"

Guillaume Bertholon <guillaume.bertholon@ens.fr>
    Bluetooth: MGMT: Fix misplaced BT_HS check

Eric Dumazet <edumazet@google.com>
    ipv4: tcp: send zero IPID in SYNACK messages

Eric Dumazet <edumazet@google.com>
    ipv4: raw: lock the socket in raw_bind()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Reduce maximum conversion rate for G781

Xianting Tian <xianting.tian@linux.alibaba.com>
    drm/msm: Fix wrong size calculation

Jianguo Wu <wujianguo@chinatelecom.cn>
    net-procfs: show net devices bound packet types

Eric Dumazet <edumazet@google.com>
    ipv4: avoid using shared IP generator for connected sockets

Congyu Liu <liu3101@purdue.edu>
    net: fix information leakage in /proc/net/ptype

Ido Schimmel <idosch@nvidia.com>
    ipv6_tunnel: Rate limit warning messages

John Meneghini <jmeneghi@redhat.com>
    scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix hang in usb_kill_urb by adding memory barriers

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge

Cameron Williams <cang1@live.co.uk>
    tty: Add support for Brainboxes UC cards.

daniel.starke@siemens.com <daniel.starke@siemens.com>
    tty: n_gsm: fix SW flow control encoding/handling

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: fix software flow control transfer

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: wakeup: simplify the output logic of pm_show_wakelocks()

Jan Kara <jack@suse.cz>
    udf: Fix NULL ptr deref when converting from inline format

Jan Kara <jack@suse.cz>
    udf: Restore i_lenAlloc when inode expansion fails

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Vasily Gorbik <gor@linux.ibm.com>
    s390/hypfs: include z/VM guests with access control group set

Brian Gix <brian.gix@intel.com>
    Bluetooth: refactor malicious adv data check

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: bcm: fix UAF of bcm op


-------------

Diffstat:

 Makefile                           |   4 +-
 arch/s390/hypfs/hypfs_vm.c         |   6 ++-
 arch/x86/kvm/x86.c                 |  14 +++---
 drivers/gpu/drm/msm/msm_drv.c      |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c    |   6 ---
 drivers/hwmon/lm90.c               |   2 +-
 drivers/media/i2c/tc358743.c       |   2 +-
 drivers/s390/scsi/zfcp_fc.c        |  13 ++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |  20 ++------
 drivers/tty/n_gsm.c                |   4 +-
 drivers/tty/serial/8250/8250_pci.c | 100 ++++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/stm32-usart.c   |   2 +-
 drivers/usb/core/hcd.c             |  14 ++++++
 drivers/usb/core/urb.c             |  12 +++++
 drivers/usb/storage/unusual_devs.h |  10 ++++
 fs/udf/inode.c                     |   9 ++--
 include/linux/netdevice.h          |   1 +
 include/net/ip.h                   |  21 ++++----
 kernel/power/wakelock.c            |  12 ++---
 net/bluetooth/hci_event.c          |  10 ++--
 net/bluetooth/mgmt.c               |   8 +--
 net/can/bcm.c                      |  20 ++++----
 net/core/net-procfs.c              |  38 ++++++++++++--
 net/ipv4/ip_output.c               |  11 +++-
 net/ipv4/raw.c                     |   5 +-
 net/ipv6/ip6_tunnel.c              |   8 +--
 net/packet/af_packet.c             |   2 +
 27 files changed, 262 insertions(+), 94 deletions(-)


