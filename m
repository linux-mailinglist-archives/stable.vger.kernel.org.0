Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6B53CE30
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344595AbiFCRj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344555AbiFCRju (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:39:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E175130C;
        Fri,  3 Jun 2022 10:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D7EB8242D;
        Fri,  3 Jun 2022 17:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F46C385A9;
        Fri,  3 Jun 2022 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654277985;
        bh=p2GCzAWlx5WHS4kzHaXiA38/lzpnnEAGGZP3L0BolXc=;
        h=From:To:Cc:Subject:Date:From;
        b=AkWGb6Kv0Cw7bPN73WRytyAPYAq2O052evcdbRNR0R+oiJGo2dyvJYNe/6CJziMVO
         MdcnTTfjVYyvCuxAoaYMzhq2E8tnOFrxc3aTRsJeJjOh/zwkX9xUCycD1zDlIKPtdT
         Tpo60wn+MqsVfl9a4MqhW+FLOUvDzDbSMA7uO+kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/12] 4.9.317-rc1 review
Date:   Fri,  3 Jun 2022 19:39:26 +0200
Message-Id: <20220603173812.524184588@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.317-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.317-rc1
X-KernelTest-Deadline: 2022-06-05T17:38+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.317 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.317-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.317-rc1

Liu Jian <liujian56@huawei.com>
    bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix possible sleep during nfsd4_release_lockowner()

Xiu Jianfeng <xiujianfeng@huawei.com>
    tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

Sarthak Kukreti <sarthakkukreti@google.com>
    dm verity: set DM_TARGET_IMMUTABLE feature flag

Mikulas Patocka <mpatocka@redhat.com>
    dm stats: add cond_resched when looping over entries

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: make printing of the key constant-time

Kees Cook <keescook@chromium.org>
    exec: Force single empty string when argv is empty

Haimin Zhang <tcs.kernel@gmail.com>
    block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Gustavo A. R. Silva <gustavoars@kernel.org>
    drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Stephen Brennan <stephen.s.brennan@oracle.com>
    assoc_array: Fix BUG_ON during garbage collect

Piyush Malgujar <pmalgujar@marvell.com>
    drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Thomas Bartschies <thomas.bartschies@cvk.de>
    net: af_key: check encryption module availability consistency


-------------

Diffstat:

 Makefile                                 |  4 ++--
 block/bio.c                              |  2 +-
 drivers/char/tpm/tpm_ibmvtpm.c           |  1 +
 drivers/gpu/drm/i915/intel_pm.c          |  2 +-
 drivers/i2c/busses/i2c-thunderx-pcidrv.c |  1 +
 drivers/md/dm-crypt.c                    | 15 +++++++++++----
 drivers/md/dm-stats.c                    |  8 ++++++++
 drivers/md/dm-verity-target.c            |  1 +
 fs/exec.c                                | 17 +++++++++++++++++
 fs/nfsd/nfs4state.c                      | 12 ++++--------
 lib/assoc_array.c                        |  8 ++++++++
 net/core/filter.c                        |  4 ++--
 net/key/af_key.c                         |  6 +++---
 13 files changed, 60 insertions(+), 21 deletions(-)


