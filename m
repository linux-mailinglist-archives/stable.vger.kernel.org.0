Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A075BAA0B
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiIPKIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiIPKIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:08:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A35DAB433;
        Fri, 16 Sep 2022 03:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E771B8250A;
        Fri, 16 Sep 2022 10:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B5AC433D6;
        Fri, 16 Sep 2022 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322876;
        bh=Zgy+Nazs56tP1qGi49XaKPb65JmdzjcY0uY4XZY5UWM=;
        h=From:To:Cc:Subject:Date:From;
        b=2rLFDdUmECnnneNSKUPRJhJN+RQN8Jun9G2k/UYgBPda8N+crNa2iebTufi+BSiKz
         1ADxBn/VL//C7/kmRDsA2qdUzbvrkoJuM4RgZXcdo0dWaMuf9Vxq75c3rrEf2quzxE
         gY3ht6yGXXhTvKT2QchWavgJn1y+sG7cThNzW55s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 0/7] 4.14.294-rc1 review
Date:   Fri, 16 Sep 2022 12:07:52 +0200
Message-Id: <20220916100441.528608977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.294-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.294-rc1
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

This is the start of the stable review cycle for the 4.14.294 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.294-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.294-rc1

Brian Norris <briannorris@chromium.org>
    tracefs: Only clobber mode/uid/gid on remount if asked

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Acer Aspire One AOD270/Packard Bell Dot keymap fixes

Li Qiong <liqiong@nfschina.com>
    ieee802154: cc2520: add rc code in cc2520_tx()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    tg3: Disable tg3 device on system reboot to avoid triggering AER

Jason Wang <wangborong@cdjrlc.com>
    HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo

Rob Clark <robdclark@chromium.org>
    drm/msm/rd: Fix FIFO-full deadlock

Jann Horn <jannh@google.com>
    mm: Fix TLB flush for not-first PFNMAP mappings in unmap_region()


-------------

Diffstat:

 Makefile                              |  4 ++--
 drivers/gpu/drm/msm/msm_rd.c          |  3 +++
 drivers/hid/intel-ish-hid/ishtp-hid.h |  2 +-
 drivers/net/ethernet/broadcom/tg3.c   |  8 ++++++--
 drivers/net/ieee802154/cc2520.c       |  1 +
 drivers/platform/x86/acer-wmi.c       |  9 ++++++++-
 fs/tracefs/inode.c                    | 31 +++++++++++++++++++++++--------
 mm/mmap.c                             |  9 +++++++--
 8 files changed, 51 insertions(+), 16 deletions(-)


