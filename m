Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2F55874F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiFWSX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiFWSXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:23:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD5BC2C69;
        Thu, 23 Jun 2022 10:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5418861F0A;
        Thu, 23 Jun 2022 17:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A9C341C5;
        Thu, 23 Jun 2022 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005150;
        bh=SyFyZ2sRAWl65JKjtAQGLYjMGv0I2r4u6CPEgMxxpHE=;
        h=From:To:Cc:Subject:Date:From;
        b=UndrPuqlREOVAdbphSJ54FLO4A6s+2z413Pfi+d+k2c6q3trM6Txqulo9U8vN1CY1
         ZZmCuyKvYYYC3b2aUV4Ga39Iutl9ajMG3ACnhl7d1fwpJjExuBf7zNQ+kt4eBAtb3S
         bKXp7mUxTcgZ0xzlBUrXP5ppQxNxu39SJ7B3hXPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 00/11] 5.18.7-rc1 review
Date:   Thu, 23 Jun 2022 18:45:12 +0200
Message-Id: <20220623164322.315085512@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.7-rc1
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

This is the start of the stable review cycle for the 5.18.7 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.7-rc1

Sean Anderson <sean.anderson@seco.com>
    dt-bindings: nvmem: sfp: Add clock properties

Toke Høiland-Jørgensen <toke@redhat.com>
    selftests/bpf: Add selftest for calling global functions from freplace

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs

Amir Goldstein <amir73il@gmail.com>
    fsnotify: consistent behavior for parent not watching children

Amir Goldstein <amir73il@gmail.com>
    fsnotify: introduce mark type iterator

Kees Cook <keescook@chromium.org>
    x86/boot: Wrap literal addresses in absolute_pointer()

Jakub Kicinski <kuba@kernel.org>
    net: wwan: iosm: remove pointless null check

Martin Liška <mliska@suse.cz>
    eth: sun: cassini: remove dead code

Jakub Kicinski <kuba@kernel.org>
    wifi: rtlwifi: remove always-true condition pointed out by GCC 12

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix zonefs_iomap_begin() for reads

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/mm: use non-quiescing sske for KVM switch to keyed guest


-------------

Diffstat:

 .../bindings/nvmem/fsl,layerscape-sfp.yaml         | 14 ++++
 Makefile                                           |  4 +-
 arch/s390/mm/pgtable.c                             |  2 +-
 arch/x86/boot/boot.h                               | 36 ++++++---
 arch/x86/boot/main.c                               |  2 +-
 drivers/net/ethernet/sun/cassini.c                 |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  5 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      | 10 ---
 fs/notify/fanotify/fanotify.c                      | 24 ++----
 fs/notify/fsnotify.c                               | 85 +++++++++----------
 fs/zonefs/super.c                                  | 94 +++++++++++++++-------
 include/linux/fsnotify_backend.h                   | 31 +++++--
 kernel/bpf/btf.c                                   |  4 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       | 14 ++++
 .../selftests/bpf/progs/freplace_global_func.c     | 18 +++++
 15 files changed, 216 insertions(+), 131 deletions(-)


