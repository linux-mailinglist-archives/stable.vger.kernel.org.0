Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8519F5FFDA8
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiJPGqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJPGqH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:46:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D153AE6A;
        Sat, 15 Oct 2022 23:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8DBFB80B76;
        Sun, 16 Oct 2022 06:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB11CC433D7;
        Sun, 16 Oct 2022 06:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665902759;
        bh=7Ni+Ve70qPYhiPukKOhbsWMHgHZdGpsSJvXLWznV+NI=;
        h=From:To:Cc:Subject:Date:From;
        b=iVrBWQoN2re4ldke6Pa03pLhiqYwhCwpEFUssNx+1HnTUvfaYByYyfKokAsu09x14
         R/54bq//YnrWtpnhw+g05ZPcGqPGwz1z16q8pX0o/zI5y011MTQNj4M9vGzhYZbGm7
         CQEbDVOXxceVtn+w25vr1nmQQ/PlQifL7Tsb2keM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.4 0/4] 5.4.219-rc1 review
Date:   Sun, 16 Oct 2022 08:46:22 +0200
Message-Id: <20221016064454.327821011@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.219-rc1
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

This is the start of the stable review cycle for the 5.4.219 release.
There are 4 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.219-rc1

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


