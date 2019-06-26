Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7C564D8
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfFZIpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 04:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfFZIpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 04:45:53 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B951208E3;
        Wed, 26 Jun 2019 08:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561538752;
        bh=4YByf2PxEEuhbn1edcB/2+0q+gnllJ+41LsxN6y/WA0=;
        h=From:To:Cc:Subject:Date:From;
        b=v9oiGj9qXFdpvC+lnzkq+k7n6msrdRRraekXEedwhsKmtAHP2RddtwgDBQzx3ifSx
         SDYaeS2jIUEKavlqpnjAJy0tw2RC3J7jFeVkisCHI6OHNkS/rJwsbybJTwrlU8TPWk
         3v8xVCHNN+yRq43Jtsf7yDZ8iDmFTs7372gJ3d5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 0/1] 4.14.131-stable review
Date:   Wed, 26 Jun 2019 16:45:20 +0800
Message-Id: <20190626083606.248422423@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.131-rc1
X-KernelTest-Deadline: 2019-06-28T08:36+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.131 release.
There are 1 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.131-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.131-rc1

Eric Dumazet <edumazet@google.com>
    tcp: refine memory limit test in tcp_fragment()


-------------

Diffstat:

 Makefile              | 4 ++--
 net/ipv4/tcp_output.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


