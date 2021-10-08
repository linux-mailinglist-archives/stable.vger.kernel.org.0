Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF774268CC
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbhJHLb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240578AbhJHLat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB286101A;
        Fri,  8 Oct 2021 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692534;
        bh=D4wvIH0WRrwhY1UHrkJiPn1mMpvkdCeVtXWNdw4dOGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=G5h3EKP95B1QiAH6WvKUJ39GSgh8B8R2az5DSYk9Ylsx34nkMKkThzHZ51IHt27VX
         BjABomO4dFeXawxLxA2yHPYRdXLt15ad8nPenmLjsfefBmoQmpjvZU2rbfkr2Fyz3E
         17oD355h4ZXwknp5QHkr80xd8ueuC/nAxdW04z3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 0/8] 4.9.286-rc1 review
Date:   Fri,  8 Oct 2021 13:27:37 +0200
Message-Id: <20211008112713.941269121@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.286-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.286-rc1
X-KernelTest-Deadline: 2021-10-10T11:27+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.286 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.286-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.286-rc1

Kate Hsuan <hpa@redhat.com>
    libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Faizel K B <faizel.kb@dicortech.com>
    usb: testusb: Fix for showing the connection speed

Ming Lei <ming.lei@redhat.com>
    scsi: sd: Free scsi_disk device via put_device()

Dan Carpenter <dan.carpenter@oracle.com>
    ext2: fix sleeping in atomic bugs on error

Linus Torvalds <torvalds@linux-foundation.org>
    sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Jan Beulich <jbeulich@suse.com>
    xen-netback: correct success/error reporting for the SKB-with-fraglist case

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mdio: introduce a shutdown method to mdio device drivers

Eric Dumazet <edumazet@google.com>
    af_unix: fix races in sk_peer_pid and sk_peer_cred accesses


-------------

Diffstat:

 Makefile                          |  4 ++--
 arch/sparc/lib/iomap.c            |  2 ++
 drivers/ata/libata-core.c         | 34 ++++++++++++++++++++++++++++++++--
 drivers/net/phy/mdio_device.c     | 11 +++++++++++
 drivers/net/xen-netback/netback.c |  2 +-
 drivers/scsi/sd.c                 |  9 +++++----
 fs/ext2/balloc.c                  | 14 ++++++--------
 include/linux/libata.h            |  1 +
 include/linux/mdio.h              |  3 +++
 include/net/sock.h                |  2 ++
 net/core/sock.c                   | 12 +++++++++---
 net/unix/af_unix.c                | 34 ++++++++++++++++++++++++++++------
 tools/usb/testusb.c               | 14 ++++++++------
 13 files changed, 110 insertions(+), 32 deletions(-)


