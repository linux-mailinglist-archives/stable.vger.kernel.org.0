Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6E55871C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiFWSUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbiFWSSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:18:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D88C68014;
        Thu, 23 Jun 2022 10:24:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4F55B824C2;
        Thu, 23 Jun 2022 17:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A45DC341C4;
        Thu, 23 Jun 2022 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005093;
        bh=q0ieiWvZZzyqC5tb88xHI5LpV46pRBqESt3kdwFvz28=;
        h=From:To:Cc:Subject:Date:From;
        b=C6MDfOIY205YIm20VLu4FSJoMT5S9tDhb6HbpWw0xfJ/KAc+A+Ueq64aSjgp+BQ1p
         y7MfiQxiM/kN/mYjUS9nEc0Z+Ah4tlf80RFH9QShmox8INE97ahwd0MgEcF7P+Vtbr
         CJu0DgsliRtba6JY7Qjj2wKjHEKDsKHyt/qOSMis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/11] 5.4.201-rc1 review
Date:   Thu, 23 Jun 2022 18:45:04 +0200
Message-Id: <20220623164321.195163701@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.201-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.201-rc1
X-KernelTest-Deadline: 2022-06-25T16:43+00:00
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

This is the start of the stable review cycle for the 5.4.201 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.201-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.201-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "hwmon: Make chip parameter for with_info API mandatory"

Will Deacon <will@kernel.org>
    arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Willy Tarreau <w@1wt.eu>
    tcp: drop the hash_32() part from the index calculation

Willy Tarreau <w@1wt.eu>
    tcp: increase source port perturb table to 2^16

Willy Tarreau <w@1wt.eu>
    tcp: dynamically allocate the perturb table used by source ports

Willy Tarreau <w@1wt.eu>
    tcp: add small random increments to the source port

Willy Tarreau <w@1wt.eu>
    tcp: use different parts of the port_offset for index and offset

Eric Dumazet <edumazet@google.com>
    tcp: add some entropy in __inet_hash_connect()

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix regression in setting fixed MAC address

Mike Snitzer <snitzer@kernel.org>
    dm: remove special-casing of bio-based immutable singleton target on NVMe

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/mm: use non-quiescing sske for KVM switch to keyed guest


-------------

Diffstat:

 Documentation/hwmon/hwmon-kernel-api.rst |  2 +-
 Makefile                                 |  4 +-
 arch/arm64/mm/cache.S                    |  2 -
 arch/s390/mm/pgtable.c                   |  2 +-
 drivers/hwmon/hwmon.c                    | 16 ++++---
 drivers/md/dm-table.c                    | 32 +-------------
 drivers/md/dm.c                          | 73 +++-----------------------------
 drivers/usb/gadget/function/u_ether.c    | 11 ++++-
 include/linux/device-mapper.h            |  1 -
 net/ipv4/inet_hashtables.c               | 31 ++++++++++----
 10 files changed, 54 insertions(+), 120 deletions(-)


