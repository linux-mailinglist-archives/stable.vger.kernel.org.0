Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4324F5584FE
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiFWRwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiFWRvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5CB99150;
        Thu, 23 Jun 2022 10:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05D19B82490;
        Thu, 23 Jun 2022 17:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423CDC3411B;
        Thu, 23 Jun 2022 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004343;
        bh=DaYViUv7sKos6j+bBO3Sx5fQpf8p8DwpSG+lKpxJBdY=;
        h=From:To:Cc:Subject:Date:From;
        b=t+26JMdlnQ3JzbSn25mNX9izWfw6HJqJPJytpU/0xN2A6AQSfejMOjNcUklW/Mp3x
         j4nsjmVe/dtiTRlqV8o5oBd9L3IY+UZbJtmNU701vlZBYE9mY3C9+wKU31pUUZqulA
         k6IPrvx3kPCOU+hCBZxHwsTTJetktVUXy3p5v1KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 0/9] 5.15.50-rc1 review
Date:   Thu, 23 Jun 2022 18:44:43 +0200
Message-Id: <20220623164322.288837280@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.50-rc1
X-KernelTest-Deadline: 2022-06-25T16:43+00:00
Content-Type: text/plain; charset=UTF-8
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

This is the start of the stable review cycle for the 5.15.50 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.50-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.50-rc1

Will Deacon <will@kernel.org>
    arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer

Lukas Wunner <lukas@wunner.de>
    serial: core: Initialize rs485 RTS polarity already on probe

Toke Høiland-Jørgensen <toke@redhat.com>
    selftests/bpf: Add selftest for calling global functions from freplace

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs

Marian Postevca <posteuca@mutex.one>
    usb: gadget: u_ether: fix regression in setting fixed MAC address

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix zonefs_iomap_begin() for reads

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Add handling of CQE_RX_TRUNCATED

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Don't reinitialize DMCUB on s0ix resume

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/mm: use non-quiescing sske for KVM switch to keyed guest


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/mm/cache.S                              |  2 -
 arch/s390/mm/pgtable.c                             |  2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 30 ++++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  7 +-
 drivers/tty/serial/amba-pl011.c                    | 15 +---
 drivers/tty/serial/serial_core.c                   | 34 +++-----
 drivers/usb/gadget/function/u_ether.c              | 11 ++-
 fs/zonefs/super.c                                  | 94 +++++++++++++++-------
 kernel/bpf/btf.c                                   |  5 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 14 ++++
 .../selftests/bpf/progs/freplace_global_func.c     | 18 +++++
 12 files changed, 156 insertions(+), 80 deletions(-)


