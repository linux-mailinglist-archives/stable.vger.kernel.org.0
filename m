Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A1323D155
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHET7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgHET7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 15:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D643320842;
        Wed,  5 Aug 2020 19:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596657557;
        bh=NqqjDQMRilzAdD7UPU03j2iNb8NGkE/19Y0RHoqcz6U=;
        h=From:To:Cc:Subject:Date:From;
        b=s4JZgkbrDrXzFR7AF2Xnqbs6Z7UGlQfMZzgq+Tvj+qs1oGYl/GgPTP/HBvQ9WpdW9
         /NstMv7W5yf5RuTWoQ13cRHrurjLSXNyq4klOhHIxH3Ha8/INecpHxTkzTRJVmeQUO
         FD9k51RCAXX6yZ54RIzQIxyWl4xPY/vJS734vzvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 0/7] 5.7.14-rc2 review
Date:   Wed,  5 Aug 2020 21:59:33 +0200
Message-Id: <20200805195916.183355405@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.14-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.14-rc2
X-KernelTest-Deadline: 2020-08-07T19:59+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.14 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.14-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    random: random.h should include archrandom.h, not the other way around

Marc Zyngier <maz@kernel.org>
    arm64: Workaround circular dependency in pointer_auth.h

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

 Makefile                              |  4 +-
 arch/arm/include/asm/percpu.h         |  2 +
 arch/arm64/include/asm/archrandom.h   |  1 -
 arch/arm64/include/asm/pointer_auth.h |  8 +++-
 arch/arm64/kernel/kaslr.c             |  2 +-
 drivers/char/random.c                 |  1 +
 include/linux/prandom.h               | 78 +++++++++++++++++++++++++++++++++++
 include/linux/random.h                | 63 ++--------------------------
 kernel/time/timer.c                   |  8 ++++
 lib/random32.c                        |  2 +-
 10 files changed, 104 insertions(+), 65 deletions(-)


