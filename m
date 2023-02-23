Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6137B6A096B
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbjBWNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbjBWNFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9C7521EC;
        Thu, 23 Feb 2023 05:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE34C616EC;
        Thu, 23 Feb 2023 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F37DC433EF;
        Thu, 23 Feb 2023 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157540;
        bh=s/3X5WKvxANkXgmh1rxHMNlACBOamk359pLX18ncpxk=;
        h=From:To:Cc:Subject:Date:From;
        b=sEwEdIU+9+KOXE8jUCm0F9Phv+lgpBmW2OHTKzv8decWUl9tquJFw3Q2Fl0blYhRR
         eoUEeANMMEUZN6k7aF4y5/k98BP0rt2zJDi2qPalOyl4yHHOpdYG8MsEVePi/kA/Ni
         iKdOJ6D2pwyHP1zSWF9KRH93yziLp9z3yyNEwyOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/11] 4.19.274-rc1 review
Date:   Thu, 23 Feb 2023 14:04:41 +0100
Message-Id: <20230223130424.079732181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.274-rc1
X-KernelTest-Deadline: 2023-02-25T13:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.274 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.274-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.274-rc1

Kees Cook <keescook@chromium.org>
    ext4: Fix function prototype mismatch for ext4_feat_ktype

Lukas Wunner <lukas@wunner.de>
    wifi: mwifiex: Add missing compatible string for SD8787

Dave Hansen <dave.hansen@linux.intel.com>
    uaccess: Add speculation barrier to copy_from_user()

Pavel Skripkin <paskripkin@gmail.com>
    mac80211: mesh: embedd mesh_paths and mpp_paths into ieee80211_if_mesh

Zheng Wang <zyytlz.wz@163.com>
    drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

Thomas Gleixner <tglx@linutronix.de>
    alarmtimer: Prevent starvation by small intervals and SIG_IGN

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Marc Kleine-Budde <mkl@pengutronix.de>
    can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always mix cycle counter in add_latent_entropy()

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Turn on the rate control


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi | 44 +++++++++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi | 44 +++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        | 20 ++++-
 drivers/gpu/drm/i915/gvt/gtt.c                     | 17 ++++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  | 33 +++++---
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  8 +-
 fs/ext4/sysfs.c                                    |  7 +-
 include/linux/nospec.h                             |  4 +
 include/linux/random.h                             |  6 +-
 kernel/bpf/core.c                                  |  2 -
 kernel/time/alarmtimer.c                           | 33 +++++++-
 lib/usercopy.c                                     |  7 ++
 net/mac80211/ieee80211_i.h                         | 24 +++++-
 net/mac80211/mesh.h                                | 22 +-----
 net/mac80211/mesh_pathtbl.c                        | 89 ++++++++--------------
 17 files changed, 251 insertions(+), 114 deletions(-)


