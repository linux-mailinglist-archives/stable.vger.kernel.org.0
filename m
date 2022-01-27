Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E449E9C2
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245119AbiA0SJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244875AbiA0SJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEA0C06173B;
        Thu, 27 Jan 2022 10:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ECC861998;
        Thu, 27 Jan 2022 18:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A31C340E4;
        Thu, 27 Jan 2022 18:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306957;
        bh=bbfOD/4YE2y4GeQ+NACS0Sgc1r23bqHNiXK1YcX7pbc=;
        h=From:To:Cc:Subject:Date:From;
        b=hv5NG/mAdDSeezx746qndGepXIPVB8E8Cadtp/2xNYjZAE9+lEg6HV2rHCf/Ju32c
         TJcKzFGKOPaUZhPBUDl/5CsqUijZ6VqDspl5RkFq1RUyLNKO3KHD3fws3V7+BcLtPz
         9G/fFFTj2EbPgXFU0BYgTNGGIn9MRa+PUBiz9kwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 4.14 0/2] 4.14.264-rc1 review
Date:   Thu, 27 Jan 2022 19:08:55 +0100
Message-Id: <20220127180256.764665162@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.264-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.264-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.264 release.
There are 2 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.264-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.264-rc1

Ziyang Xuan <william.xuanziyang@huawei.com>
    can: bcm: fix UAF of bcm op

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Makefile                               |  4 +-
 drivers/gpu/drm/i915/i915_drv.h        |  2 +
 drivers/gpu/drm/i915/i915_gem.c        | 84 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/i915_gem_object.h |  1 +
 drivers/gpu/drm/i915/i915_reg.h        |  6 +++
 drivers/gpu/drm/i915/i915_vma.c        |  4 ++
 net/can/bcm.c                          | 20 ++++----
 7 files changed, 108 insertions(+), 13 deletions(-)


