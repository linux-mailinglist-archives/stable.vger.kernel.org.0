Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44EB5584D6
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiFWRtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiFWRtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61DEA5879;
        Thu, 23 Jun 2022 10:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74D361D4D;
        Thu, 23 Jun 2022 17:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D40AC3411B;
        Thu, 23 Jun 2022 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004307;
        bh=pklxb88Ek2QpKWGJh6saUza8lO+0JgT/jD9tQ2YNxPA=;
        h=From:To:Cc:Subject:Date:From;
        b=jYBFmS9onfskJc86lahvXyZ5SGf9r5HAnEikLJ4nOmU2Oc4woUoRsmxZWaE6y8RWl
         /Frm8C9vLGPzsEBf7wb6zos+cJw4Y3hZ4PPY3+NBzHuCWdZYqMYCGFBbyK7A74VUOl
         HuDEbAwzbQsYY4eBY7IhRKsMc6hA5XozxqVSeRd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/11] 5.10.125-rc1 review
Date:   Thu, 23 Jun 2022 18:44:33 +0200
Message-Id: <20220623164322.296526800@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.125-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.125-rc1
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

This is the start of the stable review cycle for the 5.10.125 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.125-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.125-rc1

Will Deacon <will@kernel.org>
    arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Lukas Wunner <lukas@wunner.de>
    serial: core: Initialize rs485 RTS polarity already on probe

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

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix zonefs_iomap_begin() for reads

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/mm: use non-quiescing sske for KVM switch to keyed guest


-------------

Diffstat:

 Makefile                              |  4 +-
 arch/arm64/mm/cache.S                 |  2 -
 arch/s390/mm/pgtable.c                |  2 +-
 drivers/tty/serial/serial_core.c      | 34 +++++--------
 drivers/usb/gadget/function/u_ether.c | 11 ++++-
 fs/zonefs/super.c                     | 92 +++++++++++++++++++++++------------
 net/ipv4/inet_hashtables.c            | 31 +++++++++---
 7 files changed, 109 insertions(+), 67 deletions(-)


