Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181515BAACD
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIPKNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiIPKMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:12:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB1E1CB25;
        Fri, 16 Sep 2022 03:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85180629E8;
        Fri, 16 Sep 2022 10:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA1C433C1;
        Fri, 16 Sep 2022 10:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322988;
        bh=G6GcImXQGJlk2KGQ0HwW4O/tFe8MQ/BEfstLtXjCS6k=;
        h=From:To:Cc:Subject:Date:From;
        b=owqKGd9WKHAbA7pNFoNXcgR6/TuE/jJCaRGwxesXYs20gyYfl9PmHIcEiKhAYBU90
         62tHagIUAnI5tFymyXX9S05hKenh5PowV7mdg+46YzauxmYRzTAAiQK4FY/7y/Wpv5
         /CnbgYImU71/Dnb3jDCgj5Gmboy7exyDaExmqrvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/14] 5.4.214-rc1 review
Date:   Fri, 16 Sep 2022 12:08:07 +0200
Message-Id: <20220916100443.123226979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.214-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.214-rc1
X-KernelTest-Deadline: 2022-09-18T10:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.214 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.214-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.214-rc1

Brian Norris <briannorris@chromium.org>
    tracefs: Only clobber mode/uid/gid on remount if asked

Mathew McBride <matt@traverse.com.au>
    soc: fsl: select FSL_GUTS driver for DPIO

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: dp83822: disable rx error interrupt

Jann Horn <jannh@google.com>
    mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()

Hu Xiaoying <huxiaoying@kylinos.cn>
    usb: storage: Add ASUS <0x0b05:0x1932> to IGNORE_UAS

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Yu Zhe <yuzhe@nfschina.com>
    perf/arm_pmu_platform: fix tests for platform_get_irq() failure

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()

Greg Tulli <greg.iforce@gmail.com>
    Input: iforce - add support for Boeder Force Feedback Wheel

Li Qiong <liqiong@nfschina.com>
    ieee802154: cc2520: add rc code in cc2520_tx()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    tg3: Disable tg3 device on system reboot to avoid triggering AER

Even Xu <even.xu@intel.com>
    hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message

Jason Wang <wangborong@cdjrlc.com>
    HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Rob Clark <robdclark@chromium.org>
    drm/msm/rd: Fix FIFO-full deadlock


-------------

Diffstat:

 Documentation/input/joydev/joystick.rst     |  1 +
 Makefile                                    |  4 +-
 drivers/gpu/drm/msm/msm_rd.c                |  3 ++
 drivers/hid/intel-ish-hid/ishtp-hid.h       |  2 +-
 drivers/hid/intel-ish-hid/ishtp/client.c    | 68 +++++++++++++++++------------
 drivers/input/joystick/iforce/iforce-main.c |  1 +
 drivers/net/ethernet/broadcom/tg3.c         |  8 +++-
 drivers/net/ieee802154/cc2520.c             |  1 +
 drivers/net/phy/dp83822.c                   |  3 +-
 drivers/nvme/target/tcp.c                   |  3 ++
 drivers/perf/arm_pmu_platform.c             |  2 +-
 drivers/platform/x86/acer-wmi.c             |  9 +++-
 drivers/soc/fsl/Kconfig                     |  1 +
 drivers/usb/storage/unusual_uas.h           |  7 +++
 fs/tracefs/inode.c                          | 31 +++++++++----
 mm/mmap.c                                   |  9 +++-
 16 files changed, 105 insertions(+), 48 deletions(-)


