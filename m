Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845949E9CA
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiA0SKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58784 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbiA0SJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 115D1B820CA;
        Thu, 27 Jan 2022 18:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7E7C340E4;
        Thu, 27 Jan 2022 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306966;
        bh=HI4hGvgu78TB65Td8mv9TPyPsLOaJ3CbFouB3GIGEq8=;
        h=From:To:Cc:Subject:Date:From;
        b=Ig24c6seq9LRuB0hH29F1nCDBQg1DRi0BTiSvA4P0ACGbzYzWi3075BW/63zZM/Hf
         Aat1zTvpD9SY5+p8KGsPUamiC5LCcrHfiKBCW8VI20w7Y4XK30NyleVTjyPpCcmzXX
         0h24wIQ+DVhUjrZvstDUQ35ps1gplGuliAk0v/iU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 4.19 0/3] 4.19.227-rc1 review
Date:   Thu, 27 Jan 2022 19:09:00 +0100
Message-Id: <20220127180256.837257619@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.227-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.227-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.227 release.
There are 3 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.227-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.227-rc1

Jan Kara <jack@suse.cz>
    select: Fix indefinitely sleeping task in poll_schedule_timeout()

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: clear bridge's private skb space on xmit

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Makefile                               |  4 +-
 drivers/gpu/drm/i915/i915_drv.h        |  2 +
 drivers/gpu/drm/i915/i915_gem.c        | 83 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_object.h |  1 +
 drivers/gpu/drm/i915/i915_reg.h        |  6 +++
 drivers/gpu/drm/i915/i915_vma.c        |  4 ++
 fs/select.c                            | 63 ++++++++++++++------------
 net/bridge/br_device.c                 |  2 +
 8 files changed, 133 insertions(+), 32 deletions(-)


