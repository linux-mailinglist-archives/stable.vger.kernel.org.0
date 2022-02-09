Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D114AFD5E
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiBIT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:27:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiBIT0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769B6E00E269;
        Wed,  9 Feb 2022 11:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF316198D;
        Wed,  9 Feb 2022 19:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71136C340E9;
        Wed,  9 Feb 2022 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434167;
        bh=GbYxzQhs4ms8jLe4UsGvclRFMx7kNRco0jyQSsTZumQ=;
        h=From:To:Cc:Subject:Date:From;
        b=FQbjSyJyF9SJ3/MnzKG8LRKosrAKEVyQeUtC1phzPGHb/Stc8Yg7jp1U+YDskL4JL
         UGLjzq2HWQ2QtC2EHBwD8/MSRprvgNrv1rf35QvZ9LQJ6ZVUKmqiM9itwuhEhLa9MO
         6ZcxoxLvTgwAWxEcjSagJ1j+cPag+003P4w7+KQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.16 0/5] 5.16.9-rc1 review
Date:   Wed,  9 Feb 2022 20:14:32 +0100
Message-Id: <20220209191249.887150036@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.9-rc1
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

This is the start of the stable review cycle for the 5.16.9 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.9-rc1

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Move cryptomgr soft dependency into algapi

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix SMB 3.11 posix extension mount failure

Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    KVM: s390: Return error on SIDA memop on normal guest

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    moxart: fix potential use-after-free on remove path

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata-core: Fix ata_dev_config_cpr()


-------------

Diffstat:

 Makefile                      |  4 ++--
 arch/s390/kvm/kvm-s390.c      |  2 ++
 crypto/algapi.c               |  1 +
 crypto/api.c                  |  1 -
 drivers/ata/libata-core.c     | 14 ++++++--------
 drivers/mmc/host/moxart-mmc.c |  2 +-
 fs/ksmbd/smb2pdu.c            |  2 +-
 include/linux/ata.h           |  2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)


