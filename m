Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF0F432749
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhJRTNq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 18 Oct 2021 15:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhJRTNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 15:13:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAFCC06161C;
        Mon, 18 Oct 2021 12:11:33 -0700 (PDT)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1mcY2E-0000T4-Rv; Mon, 18 Oct 2021 21:10:58 +0200
Date:   Mon, 18 Oct 2021 21:10:58 +0200
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Matthias Klose <doko@debian.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: drop cc-option fallbacks for architecture selection
Message-ID: <20211018191058.3zn5l7ocgh2twy5d@flow>
References: <20211018140735.3714254-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20211018140735.3714254-1-arnd@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-10-18 16:07:12 [+0200], Arnd Bergmann wrote:
…
> Passing e.g. -march=armv6k+fp in place of -march=armv6k would avoid this
> issue, but the fallback logic is already broken because all supported
> compilers (gcc-5 and higher) are much more recent than these options,
> and building with -march=armv5t as a fallback no longer works.
> 
> The best way forward that I see is to just remove all the checks, which
> also has the nice side-effect of slightly improving the startup time for
> 'make'.
> 
…
> This should be safe to apply on all stable kernels, and will be required
> in order to keep building them with gcc-11 and higher.

Yes, please.

> Reported-by: Antonio Terceiro <antonio.terceiro@linaro.org>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=996419
> Cc: Matthias Klose <doko@debian.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Just booted Debian 9/ Stretch which ships
   gcc version 6.3.0 20170516 (Debian 6.3.0-18) 

to confirm that it fails to compile with the armv5t fallback.

Sebastian
