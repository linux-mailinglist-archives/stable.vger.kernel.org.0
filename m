Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C494AFD4F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiBIT0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:26:49 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiBIT01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35263C02B5D3;
        Wed,  9 Feb 2022 11:19:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6589EB82392;
        Wed,  9 Feb 2022 19:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC67C340E7;
        Wed,  9 Feb 2022 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434147;
        bh=CDJT6ceF+7GANApPV9fPTE87Zdt/GRsTa1rFq3MjZzs=;
        h=From:To:Cc:Subject:Date:From;
        b=ocb3OFJWEvHrWBYxPLvEt6LTrer1WhdiSHYMhOk9g+h3UyttZch3F3GgjYinhXZ4g
         TLaj96hj6tNC4QEcq3MxrgLxzKOtLugJJCH3UTj7LBtqZ+MfdzUtmJf3TY+34ZlA+g
         EEP7nQqsGGBwxMBRMHu4ntbhALx/Jth2rs7Nhp6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 0/5] 5.15.23-rc1 review
Date:   Wed,  9 Feb 2022 20:14:25 +0100
Message-Id: <20220209191249.980911721@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.23-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.23-rc1
X-KernelTest-Deadline: 2022-02-11T19:12+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.23 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.23-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.23-rc1

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Move cryptomgr soft dependency into algapi

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix SMB 3.11 posix extension mount failure

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: Return error on SIDA memop on normal guest

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-A510 CPU part definition

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    moxart: fix potential use-after-free on remove path


-------------

Diffstat:

 Makefile                         | 4 ++--
 arch/arm64/include/asm/cputype.h | 2 ++
 arch/s390/kvm/kvm-s390.c         | 2 ++
 crypto/algapi.c                  | 1 +
 crypto/api.c                     | 1 -
 drivers/mmc/host/moxart-mmc.c    | 2 +-
 fs/ksmbd/smb2pdu.c               | 2 +-
 7 files changed, 9 insertions(+), 5 deletions(-)


