Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B5849E9ED
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbiA0SK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245163AbiA0SKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D9CC061756;
        Thu, 27 Jan 2022 10:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C187B818E1;
        Thu, 27 Jan 2022 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69231C340EA;
        Thu, 27 Jan 2022 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307011;
        bh=jUmuJjJ5DnnOhIK4cDjR34Ur/dsWeKwGp1IVbdM9IAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=FSf0C2Q3ITaCv878XNOOG3C3iI94LIIuXcv06mHB+O4nyETRrCR41GTrhxVu2Bog/
         3PNXeOA6qtjRydJa6Tkr7oP07zTCKnA2NJ9XyUXsPXniunUpeiGnh0HHXqHGKVyWSX
         4HCiorW1vODLVNQawaxu1IFqK5hzJzeWQPFEIrtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 5.4 00/11] 5.4.175-rc1 review
Date:   Thu, 27 Jan 2022 19:09:01 +0100
Message-Id: <20220127180258.362000607@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.175-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.175-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.175 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.175-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.175-rc1

Jan Kara <jack@suse.cz>
    select: Fix indefinitely sleeping task in poll_schedule_timeout()

Tim Harvey <tharvey@gateworks.com>
    mmc: sdhci-esdhc-imx: disable CMDQ support

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: gpio-ranges property is now required

Phil Elwell <phil@raspberrypi.com>
    pinctrl: bcm2835: Change init order for gpio hogs

Florian Fainelli <f.fainelli@gmail.com>
    pinctrl: bcm2835: Add support for wake-up interrupts

Florian Fainelli <f.fainelli@gmail.com>
    pinctrl: bcm2835: Match BCM7211 compatible string

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: Add support for all GPIOs on BCM2711

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: Refactor platform data

Stefan Wahren <stefan.wahren@i2se.com>
    pinctrl: bcm2835: Drop unused define

Paul E. McKenney <paulmck@kernel.org>
    rcu: Tighten rcu_advance_cbs_nowake() checks

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm/boot/dts/bcm283x.dtsi                   |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |   3 +
 drivers/gpu/drm/i915/gem/i915_gem_pages.c        |  10 ++
 drivers/gpu/drm/i915/gt/intel_gt.c               |  99 +++++++++++
 drivers/gpu/drm/i915/gt/intel_gt.h               |   2 +
 drivers/gpu/drm/i915/gt/intel_gt_types.h         |   2 +
 drivers/gpu/drm/i915/i915_reg.h                  |  11 ++
 drivers/gpu/drm/i915/i915_vma.c                  |   4 +
 drivers/mmc/host/sdhci-esdhc-imx.c               |   3 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c            | 209 +++++++++++++++++++----
 fs/select.c                                      |  63 +++----
 kernel/rcu/tree.c                                |   7 +-
 13 files changed, 346 insertions(+), 72 deletions(-)


