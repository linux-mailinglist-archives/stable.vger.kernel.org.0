Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0784EEC83
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 13:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345581AbiDALrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 07:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345577AbiDALrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 07:47:01 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4F89EEA72;
        Fri,  1 Apr 2022 04:45:11 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1naFiG-0000xJ-00; Fri, 01 Apr 2022 13:45:08 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id B9B39C4DEF; Fri,  1 Apr 2022 12:03:09 +0200 (CEST)
Date:   Fri, 1 Apr 2022 12:03:09 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Maciej W . Rozycki" <macro@orcam.me.uk>,
        linux-crypto@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] MIPS: crypto: Fix CRC32 code
Message-ID: <20220401100309.GA6670@alpha.franken.de>
References: <20220331164200.177015-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331164200.177015-1-paul@crapouillou.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 05:42:00PM +0100, Paul Cercueil wrote:
> Commit 67512a8cf5a7 ("MIPS: Avoid macro redefinitions") changed how the
> MIPS register macros were defined, in order to allow the code to compile
> under LLVM/Clang.
> 
> The MIPS CRC32 code however wasn't updated accordingly, causing a build
> bug when using a MIPS32r6 toolchain without CRC support.
> 
> Update the CRC32 code to use the macros correctly, to fix the build
> failures.
> 
> Fixes: 67512a8cf5a7 ("MIPS: Avoid macro redefinitions")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  arch/mips/crypto/crc32-mips.c | 46 ++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 20 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
