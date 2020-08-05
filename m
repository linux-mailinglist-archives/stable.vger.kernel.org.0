Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A433523CC29
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgHEQ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 12:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgHEQZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:25:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C03DE233EA;
        Wed,  5 Aug 2020 15:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642805;
        bh=Vnpavvxe8eGhapeUtR3pmJcXKQkD1enXO3mcQe6i6Dw=;
        h=From:To:Cc:Subject:Date:From;
        b=M5I/gLV1dixpnHbCswIbHCiXzuCVG+bza169wVueh3NQFGwn4At5amKtLwBGsUqj4
         ldgyXpT+jZnPLcYkvPQbBUfWpuvB/FOlkqZQ29UZFCfEuMFclDUZ4zqyXCySOYNQSO
         hkhpAxw6IhzbhGaiPCf9Jqltar2Frx06K0DuVGRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 0/6] 4.19.138-rc1 review
Date:   Wed,  5 Aug 2020 17:52:59 +0200
Message-Id: <20200805153505.472594546@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.138-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.138-rc1
X-KernelTest-Deadline: 2020-08-07T15:35+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.138 release.
There are 6 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.138-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.138-rc1

Jiang Ying <jiangying8582@126.com>
    ext4: fix direct I/O read error

Linus Torvalds <torvalds@linux-foundation.org>
    random32: move the pseudo-random 32-bit definitions to prandom.h

Linus Torvalds <torvalds@linux-foundation.org>
    random32: remove net_rand_state from the latent entropy gcc plugin

Willy Tarreau <w@1wt.eu>
    random: fix circular include dependency on arm64 after addition of percpu.h

Grygorii Strashko <grygorii.strashko@ti.com>
    ARM: percpu.h: fix build error

Willy Tarreau <w@1wt.eu>
    random32: update the net random state on interrupt and activity


-------------

Diffstat:

 Makefile                      |  4 +--
 arch/arm/include/asm/percpu.h |  2 ++
 drivers/char/random.c         |  1 +
 fs/ext4/inode.c               |  5 +++
 include/linux/prandom.h       | 78 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h        | 63 +++-------------------------------
 kernel/time/timer.c           |  8 +++++
 lib/random32.c                |  2 +-
 8 files changed, 101 insertions(+), 62 deletions(-)


