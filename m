Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303AB560849
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiF2SCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiF2SCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:02:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2DDFCF;
        Wed, 29 Jun 2022 11:02:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b2so7815999plx.7;
        Wed, 29 Jun 2022 11:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OeT2ITrjmuVxlcpJzzC4BUYFkEFLXsguD1Lu33hDD8A=;
        b=PPaFWkYUAhPqssi/bSgVMVOJGJonL2COt9o59m5Hi/6thI4htaY8Zdw/dFbmNn0n3Y
         n9KPJuvlpK9+TsAf4xnv0KUFLNASjmo9SBYG5+s3wHtsDfLiAz7uD5qNpcLTYF60/XWK
         BnpJZaFimUbWD5715dqYmpjUaDt39f4qQ8VY6Zi/0Xh/UFHN15KxMWZlFD2z5HevaWM1
         hG9z1suQpmPRDi3ZPV9diKxKPgPVajJlO55/sV8ltH+IOFn/7eCPuXX7CYVv9nes0JHQ
         iZPww5SxtpMh2jTSC54QCiemWSTR7U/ZDmvS0if5YwpLqKXTky/wpRABfNzXPU8gDtRW
         WRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OeT2ITrjmuVxlcpJzzC4BUYFkEFLXsguD1Lu33hDD8A=;
        b=3a7AjgPemzTCC0O4wkaX1xSSX14aWKfZwVjPQDvgUWLc8gDOUUzhML+7MkvtK9Xi0r
         6cRHGqjAPvImG0E9vsr/Eaht/eE2IMC+kPswfuSvAwOWt3R43I5nOfrL1wCV3e3aAkGS
         Xm9fo8hmVIyHIDeF2j1VuoGzC7c43zdfV2Pu4wxjND18l3WQx5nwGtntcSqap98crFrl
         HQguLtgVZtZrTkMpfWwDh7GY/I9SZzZXpLnbWBf4edAZxATgpoh0yYNY4IGWBOFg3Tu8
         LMXnRE1LXKh83XdED5xHqnPM9mgVr9Wv6KzAc9FpdixDxH/jhaax95A2HfeicEt0plED
         qAEg==
X-Gm-Message-State: AJIora+ckWvbUAy2gUcmfan1iaLAJvTI+CBOVezktsPzAkZzwa8DR7Ca
        r5ekd/iWAMPqe2wj/nSSopHY6weTboM=
X-Google-Smtp-Source: AGRyM1vlpn9VfkHdI1GSkmUIdEu8Va4vyYc4mICOFLm2qyu6WECUH/zTfRBEKfnpd7iO8mD0eGfT8Q==
X-Received: by 2002:a17:90a:c4f:b0:1df:a178:897f with SMTP id u15-20020a17090a0c4f00b001dfa178897fmr5155617pje.19.1656525758913;
        Wed, 29 Jun 2022 11:02:38 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:38 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <caij2003@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-omap@vger.kernel.org (open list:OMAP2+ SUPPORT),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.4 00/11] ARM 32-bit build with Clang IAS
Date:   Wed, 29 Jun 2022 11:02:16 -0700
Message-Id: <20220629180227.3408104-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This patch series is a collection of clean cherry picks into the 5.4
kernel allowing us to use the Clang integrated assembler to build the
ARM 32-bit kernel.

This is useful in order to have proper build and runtime coverage of the
stable kernel(s).

Ard Biesheuvel (3):
  crypto: arm/sha256-neon - avoid ADRL pseudo instruction
  crypto: arm/sha512-neon - avoid ADRL pseudo instruction
  crypto: arm - use Kconfig based compiler checks for crypto opcodes

Jian Cai (2):
  ARM: 8971/1: replace the sole use of a symbol with its definition
  ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler

Nick Desaulniers (1):
  ARM: 8933/1: replace Sun/Solaris style flag on section directive

Stefan Agner (5):
  ARM: 8989/1: use .fpu assembler directives instead of assembler
    arguments
  ARM: 8990/1: use VFP assembler mnemonics in register load/store macros
  ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
  ARM: OMAP2+: drop unnecessary adrl
  crypto: arm/ghash-ce - define fpu before fpu registers are referenced

 arch/arm/boot/bootp/init.S            |  2 +-
 arch/arm/boot/compressed/big-endian.S |  2 +-
 arch/arm/boot/compressed/head.S       |  4 +-
 arch/arm/boot/compressed/piggy.S      |  2 +-
 arch/arm/crypto/Kconfig               | 14 +++--
 arch/arm/crypto/Makefile              | 32 ++--------
 arch/arm/crypto/crct10dif-ce-core.S   |  2 +-
 arch/arm/crypto/ghash-ce-core.S       |  4 +-
 arch/arm/crypto/sha1-ce-core.S        |  1 +
 arch/arm/crypto/sha2-ce-core.S        |  1 +
 arch/arm/crypto/sha256-armv4.pl       |  4 +-
 arch/arm/crypto/sha256-core.S_shipped |  4 +-
 arch/arm/crypto/sha512-armv4.pl       |  4 +-
 arch/arm/crypto/sha512-core.S_shipped |  4 +-
 arch/arm/include/asm/assembler.h      |  3 +-
 arch/arm/include/asm/vfpmacros.h      | 19 +++---
 arch/arm/kernel/iwmmxt.S              | 89 ++++++++++++++-------------
 arch/arm/kernel/iwmmxt.h              | 47 ++++++++++++++
 arch/arm/mach-omap2/sleep34xx.S       |  2 +-
 arch/arm/mm/proc-arm1020.S            |  2 +-
 arch/arm/mm/proc-arm1020e.S           |  2 +-
 arch/arm/mm/proc-arm1022.S            |  2 +-
 arch/arm/mm/proc-arm1026.S            |  6 +-
 arch/arm/mm/proc-arm720.S             |  2 +-
 arch/arm/mm/proc-arm740.S             |  2 +-
 arch/arm/mm/proc-arm7tdmi.S           |  2 +-
 arch/arm/mm/proc-arm920.S             |  2 +-
 arch/arm/mm/proc-arm922.S             |  2 +-
 arch/arm/mm/proc-arm925.S             |  2 +-
 arch/arm/mm/proc-arm926.S             |  6 +-
 arch/arm/mm/proc-arm940.S             |  2 +-
 arch/arm/mm/proc-arm946.S             |  2 +-
 arch/arm/mm/proc-arm9tdmi.S           |  2 +-
 arch/arm/mm/proc-fa526.S              |  2 +-
 arch/arm/mm/proc-feroceon.S           |  2 +-
 arch/arm/mm/proc-mohawk.S             |  2 +-
 arch/arm/mm/proc-sa110.S              |  2 +-
 arch/arm/mm/proc-sa1100.S             |  2 +-
 arch/arm/mm/proc-v6.S                 |  2 +-
 arch/arm/mm/proc-v7.S                 |  2 +-
 arch/arm/mm/proc-v7m.S                |  4 +-
 arch/arm/mm/proc-xsc3.S               |  2 +-
 arch/arm/mm/proc-xscale.S             |  2 +-
 arch/arm/vfp/Makefile                 |  2 -
 arch/arm/vfp/vfphw.S                  | 30 ++++++---
 45 files changed, 187 insertions(+), 143 deletions(-)
 create mode 100644 arch/arm/kernel/iwmmxt.h

-- 
2.25.1

