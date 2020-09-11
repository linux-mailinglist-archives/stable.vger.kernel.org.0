Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7CA266129
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgIKO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E5B2224F;
        Fri, 11 Sep 2020 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829256;
        bh=9SZnSJ2IUQMOnQv1v0HyutS6AgCI4nGtzKD+DXqCrBU=;
        h=From:To:Cc:Subject:Date:From;
        b=jaaXaJZopyN/TgUD0qS56chD/HJhj8rB0uTjFru3mSXELCYh9gPhrPhw6iHM5U1zG
         GkRJudPUi+va7mI5H8/3G6ZVdbqK40Vr5gO9caaPWSELxPjfMDKFS3zeoilRTj3vXS
         hD8LpvpiCSIrDkD0WaCLe9gvpL6nf7cC+TGwKerA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 0/8] 4.19.145-rc1 review
Date:   Fri, 11 Sep 2020 14:54:47 +0200
Message-Id: <20200911125421.695645838@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.145-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.145-rc1
X-KernelTest-Deadline: 2020-09-13T12:54+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.145 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 13 Sep 2020 12:54:13 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.145-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.145-rc1

Roi Dayan <roid@mellanox.com>
    net/mlx5e: Don't support phys switch id if not in switchdev mode

Jakub Kicinski <kuba@kernel.org>
    net: disable netpoll on fresh napis

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tipc: fix shutdown() of connectionless socket

Xin Long <lucien.xin@gmail.com>
    sctp: not disable bh in the whole sctp_get_port_local()

Kamil Lorenc <kamil@re-ws.pl>
    net: usb: dm9601: Add USB ID of Keenetic Plus DSL

Paul Moore <paul@paul-moore.com>
    netlabel: fix problems with mapping removal

Jens Axboe <axboe@kernel.dk>
    block: ensure bdi->io_pages is always initialized

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA; firewire-tascam: exclude Tascam FE-8 from detection


-------------

Diffstat:

 Makefile                                         |  4 +-
 block/blk-core.c                                 |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  2 +-
 drivers/net/usb/dm9601.c                         |  4 ++
 net/core/dev.c                                   |  3 +-
 net/core/netpoll.c                               |  2 +-
 net/netlabel/netlabel_domainhash.c               | 59 ++++++++++++------------
 net/sctp/socket.c                                | 16 +++----
 net/tipc/socket.c                                |  9 ++--
 sound/firewire/tascam/tascam.c                   | 30 +++++++++++-
 10 files changed, 83 insertions(+), 48 deletions(-)


