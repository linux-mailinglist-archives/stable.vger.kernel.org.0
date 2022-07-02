Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A815D5640D0
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiGBOjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiGBOij (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:38:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DCA6433;
        Sat,  2 Jul 2022 07:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC0DBB82A94;
        Sat,  2 Jul 2022 14:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B33FC34114;
        Sat,  2 Jul 2022 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656772714;
        bh=TnD72pPp7rTR7xeo1J44Plco5EgpDZMxz6oQS+Hw1BU=;
        h=From:To:Cc:Subject:Date:From;
        b=P5y0nIhPxDBCG79W4gu0REpUKCKUNmSxWLkK99D1ojcLX8+I1tYv+4fsaSmMw0GkM
         YOij2y7Bw8xG10r35Yos1AxOFh5Cmr5ZlptZr3mTEM58tdetjF8i3HGKKvwW8EcFnE
         zfb4wVigyQhdIF/XGePsEQxCpAArmYJjsUqY3/wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.203
Date:   Sat,  2 Jul 2022 16:38:23 +0200
Message-Id: <165677270413529@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
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

I'm announcing the release of the 5.4.203 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/arm/boot/bootp/init.S                 |    2 
 arch/arm/boot/compressed/big-endian.S      |    2 
 arch/arm/boot/compressed/head.S            |    4 -
 arch/arm/boot/compressed/piggy.S           |    2 
 arch/arm/crypto/Kconfig                    |   14 ++--
 arch/arm/crypto/Makefile                   |   32 +---------
 arch/arm/crypto/crct10dif-ce-core.S        |    2 
 arch/arm/crypto/ghash-ce-core.S            |    4 -
 arch/arm/crypto/sha1-ce-core.S             |    1 
 arch/arm/crypto/sha2-ce-core.S             |    1 
 arch/arm/crypto/sha256-armv4.pl            |    4 -
 arch/arm/crypto/sha256-core.S_shipped      |    4 -
 arch/arm/crypto/sha512-armv4.pl            |    4 -
 arch/arm/crypto/sha512-core.S_shipped      |    4 -
 arch/arm/include/asm/assembler.h           |    3 
 arch/arm/include/asm/vfpmacros.h           |   19 +++---
 arch/arm/kernel/iwmmxt.S                   |   89 ++++++++++++++---------------
 arch/arm/kernel/iwmmxt.h                   |   47 +++++++++++++++
 arch/arm/mach-omap2/sleep34xx.S            |    2 
 arch/arm/mm/proc-arm1020.S                 |    2 
 arch/arm/mm/proc-arm1020e.S                |    2 
 arch/arm/mm/proc-arm1022.S                 |    2 
 arch/arm/mm/proc-arm1026.S                 |    6 -
 arch/arm/mm/proc-arm720.S                  |    2 
 arch/arm/mm/proc-arm740.S                  |    2 
 arch/arm/mm/proc-arm7tdmi.S                |    2 
 arch/arm/mm/proc-arm920.S                  |    2 
 arch/arm/mm/proc-arm922.S                  |    2 
 arch/arm/mm/proc-arm925.S                  |    2 
 arch/arm/mm/proc-arm926.S                  |    6 -
 arch/arm/mm/proc-arm940.S                  |    2 
 arch/arm/mm/proc-arm946.S                  |    2 
 arch/arm/mm/proc-arm9tdmi.S                |    2 
 arch/arm/mm/proc-fa526.S                   |    2 
 arch/arm/mm/proc-feroceon.S                |    2 
 arch/arm/mm/proc-mohawk.S                  |    2 
 arch/arm/mm/proc-sa110.S                   |    2 
 arch/arm/mm/proc-sa1100.S                  |    2 
 arch/arm/mm/proc-v6.S                      |    2 
 arch/arm/mm/proc-v7.S                      |    2 
 arch/arm/mm/proc-v7m.S                     |    4 -
 arch/arm/mm/proc-xsc3.S                    |    2 
 arch/arm/mm/proc-xscale.S                  |    2 
 arch/arm/vfp/Makefile                      |    2 
 arch/arm/vfp/vfphw.S                       |   30 ++++++---
 arch/powerpc/include/asm/ftrace.h          |    5 +
 arch/powerpc/kernel/trace/ftrace.c         |   15 +++-
 arch/powerpc/mm/mem.c                      |    2 
 arch/s390/include/asm/kexec.h              |   10 +++
 arch/x86/include/asm/kexec.h               |    9 ++
 drivers/gpu/drm/drm_crtc_helper_internal.h |   10 ---
 drivers/gpu/drm/drm_fb_helper.c            |   21 ------
 drivers/gpu/drm/drm_kms_helper_common.c    |   25 +++-----
 drivers/net/ethernet/mscc/ocelot.c         |    8 +-
 include/linux/kexec.h                      |   46 ++++++++++++--
 kernel/kexec_file.c                        |   34 -----------
 57 files changed, 281 insertions(+), 236 deletions(-)

Ard Biesheuvel (3):
      crypto: arm/sha256-neon - avoid ADRL pseudo instruction
      crypto: arm/sha512-neon - avoid ADRL pseudo instruction
      crypto: arm - use Kconfig based compiler checks for crypto opcodes

Christoph Hellwig (1):
      drm: remove drm_fb_helper_modinit

Greg Kroah-Hartman (1):
      Linux 5.4.203

Jian Cai (2):
      ARM: 8971/1: replace the sole use of a symbol with its definition
      ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler

Naveen N. Rao (2):
      powerpc/ftrace: Remove ftrace init tramp once kernel init is complete
      kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]

Nick Desaulniers (1):
      ARM: 8933/1: replace Sun/Solaris style flag on section directive

Stefan Agner (5):
      ARM: 8989/1: use .fpu assembler directives instead of assembler arguments
      ARM: 8990/1: use VFP assembler mnemonics in register load/store macros
      ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
      ARM: OMAP2+: drop unnecessary adrl
      crypto: arm/ghash-ce - define fpu before fpu registers are referenced

Vladimir Oltean (1):
      net: mscc: ocelot: allow unregistered IP multicast flooding

