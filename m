Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3C561CC9
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiF3OD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbiF3OCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:02:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56431C13C;
        Thu, 30 Jun 2022 06:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06CFBB82AEE;
        Thu, 30 Jun 2022 13:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42893C34115;
        Thu, 30 Jun 2022 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597185;
        bh=WeVqCnvj5Hml9xdmVwvKBV7gjQdrWu2Wb/j50XnN2mY=;
        h=From:To:Cc:Subject:Date:From;
        b=lgJ+Mwosz+UtECcmNRrLcnidBS/ZoqtbMftgk5SqDO87f4ABD99xADppmBxy/2Xo5
         KLrBob5LV3wntY9JMt+JhTi24F4eXR6DqX2w0FM+mbTwklUrmrXZkVQetWFdDtizno
         a2+eWwqcxxyDBScxeOyZjK72VRY+jX00joZrh/sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/16] 5.4.203-rc1 review
Date:   Thu, 30 Jun 2022 15:46:54 +0200
Message-Id: <20220630133230.936488203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.203-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.203-rc1
X-KernelTest-Deadline: 2022-07-02T13:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.203 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.203-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.203-rc1

Stefan Agner <stefan@agner.ch>
    crypto: arm/ghash-ce - define fpu before fpu registers are referenced

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: arm - use Kconfig based compiler checks for crypto opcodes

Jian Cai <jiancai@google.com>
    ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler

Stefan Agner <stefan@agner.ch>
    ARM: OMAP2+: drop unnecessary adrl

Stefan Agner <stefan@agner.ch>
    ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 8933/1: replace Sun/Solaris style flag on section directive

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm/sha512-neon - avoid ADRL pseudo instruction

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm/sha256-neon - avoid ADRL pseudo instruction

Jian Cai <caij2003@gmail.com>
    ARM: 8971/1: replace the sole use of a symbol with its definition

Stefan Agner <stefan@agner.ch>
    ARM: 8990/1: use VFP assembler mnemonics in register load/store macros

Stefan Agner <stefan@agner.ch>
    ARM: 8989/1: use .fpu assembler directives instead of assembler arguments

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: allow unregistered IP multicast flooding

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    powerpc/ftrace: Remove ftrace init tramp once kernel init is complete

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    clocksource/drivers/ixp4xx: remove __init from ixp4xx_timer_setup()

Christoph Hellwig <hch@lst.de>
    drm: remove drm_fb_helper_modinit


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/arm/boot/bootp/init.S                 |  2 +-
 arch/arm/boot/compressed/big-endian.S      |  2 +-
 arch/arm/boot/compressed/head.S            |  4 +-
 arch/arm/boot/compressed/piggy.S           |  2 +-
 arch/arm/crypto/Kconfig                    | 14 +++--
 arch/arm/crypto/Makefile                   | 32 ++---------
 arch/arm/crypto/crct10dif-ce-core.S        |  2 +-
 arch/arm/crypto/ghash-ce-core.S            |  4 +-
 arch/arm/crypto/sha1-ce-core.S             |  1 +
 arch/arm/crypto/sha2-ce-core.S             |  1 +
 arch/arm/crypto/sha256-armv4.pl            |  4 +-
 arch/arm/crypto/sha256-core.S_shipped      |  4 +-
 arch/arm/crypto/sha512-armv4.pl            |  4 +-
 arch/arm/crypto/sha512-core.S_shipped      |  4 +-
 arch/arm/include/asm/assembler.h           |  3 +-
 arch/arm/include/asm/vfpmacros.h           | 19 ++++---
 arch/arm/kernel/iwmmxt.S                   | 89 +++++++++++++++---------------
 arch/arm/kernel/iwmmxt.h                   | 47 ++++++++++++++++
 arch/arm/mach-omap2/sleep34xx.S            |  2 +-
 arch/arm/mm/proc-arm1020.S                 |  2 +-
 arch/arm/mm/proc-arm1020e.S                |  2 +-
 arch/arm/mm/proc-arm1022.S                 |  2 +-
 arch/arm/mm/proc-arm1026.S                 |  6 +-
 arch/arm/mm/proc-arm720.S                  |  2 +-
 arch/arm/mm/proc-arm740.S                  |  2 +-
 arch/arm/mm/proc-arm7tdmi.S                |  2 +-
 arch/arm/mm/proc-arm920.S                  |  2 +-
 arch/arm/mm/proc-arm922.S                  |  2 +-
 arch/arm/mm/proc-arm925.S                  |  2 +-
 arch/arm/mm/proc-arm926.S                  |  6 +-
 arch/arm/mm/proc-arm940.S                  |  2 +-
 arch/arm/mm/proc-arm946.S                  |  2 +-
 arch/arm/mm/proc-arm9tdmi.S                |  2 +-
 arch/arm/mm/proc-fa526.S                   |  2 +-
 arch/arm/mm/proc-feroceon.S                |  2 +-
 arch/arm/mm/proc-mohawk.S                  |  2 +-
 arch/arm/mm/proc-sa110.S                   |  2 +-
 arch/arm/mm/proc-sa1100.S                  |  2 +-
 arch/arm/mm/proc-v6.S                      |  2 +-
 arch/arm/mm/proc-v7.S                      |  2 +-
 arch/arm/mm/proc-v7m.S                     |  4 +-
 arch/arm/mm/proc-xsc3.S                    |  2 +-
 arch/arm/mm/proc-xscale.S                  |  2 +-
 arch/arm/vfp/Makefile                      |  2 -
 arch/arm/vfp/vfphw.S                       | 30 ++++++----
 arch/powerpc/include/asm/ftrace.h          |  5 +-
 arch/powerpc/kernel/trace/ftrace.c         | 15 ++++-
 arch/powerpc/mm/mem.c                      |  2 +
 arch/s390/include/asm/kexec.h              | 10 ++++
 arch/x86/include/asm/kexec.h               |  9 +++
 drivers/clocksource/mmio.c                 |  2 +-
 drivers/clocksource/timer-ixp4xx.c         | 10 ++--
 drivers/gpu/drm/drm_crtc_helper_internal.h | 10 ----
 drivers/gpu/drm/drm_fb_helper.c            | 21 -------
 drivers/gpu/drm/drm_kms_helper_common.c    | 25 ++++-----
 drivers/net/ethernet/mscc/ocelot.c         |  8 ++-
 include/linux/kexec.h                      | 46 ++++++++++++---
 include/linux/platform_data/timer-ixp4xx.h |  5 +-
 kernel/kexec_file.c                        | 34 ------------
 60 files changed, 289 insertions(+), 247 deletions(-)


