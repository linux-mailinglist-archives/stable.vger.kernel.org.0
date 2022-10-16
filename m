Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CD45FFD99
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJPGph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJPGpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3413640B;
        Sat, 15 Oct 2022 23:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE1D60A72;
        Sun, 16 Oct 2022 06:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63369C433C1;
        Sun, 16 Oct 2022 06:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902732;
        bh=HpFUCldXtQXZOvwMbcCBGHaCRK4B/TKd5FntapB56pg=;
        h=From:To:Cc:Subject:Date:From;
        b=kJ3xHpkCYGNaJ7rPBRb9n5K0GFV7nXgVTEYBhUy7xnLGK7bMuOZgkR8YzS9lUnKzb
         LOCC5RY9reVJ9mU1eGrcs5kcJMLmilB6HPplou9V5VpSCjzn2wEf5lDN5gbrrjhXMn
         1dBlX35iEzqGOdJpPYhdR908ERbz3D3rxRzUaqnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.10 0/4] 5.10.149-rc1 review
Date:   Sun, 16 Oct 2022 08:46:10 +0200
Message-Id: <20221016064454.382206984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.149-rc1
X-KernelTest-Deadline: 2022-10-18T06:44+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.149 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.149-rc1

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix MBSSID parsing use-after-free

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't parse mbssid in assoc response

Johannes Berg <johannes.berg@intel.com>
    mac80211: mlme: find auth challenge directly

Sasha Levin <sashal@kernel.org>
    Revert "fs: check FMODE_LSEEK to control internal pipe splicing"


-------------

Diffstat:

 Makefile                   |  4 ++--
 fs/splice.c                | 10 ++++++----
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/mlme.c        | 21 +++++++++++++--------
 net/mac80211/scan.c        |  2 ++
 net/mac80211/util.c        | 11 ++++++-----
 6 files changed, 31 insertions(+), 21 deletions(-)


