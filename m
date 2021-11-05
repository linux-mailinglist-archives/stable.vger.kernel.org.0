Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8652F446072
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 09:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhKEIPn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 5 Nov 2021 04:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhKEIPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 04:15:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50A3C061714;
        Fri,  5 Nov 2021 01:13:03 -0700 (PDT)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1miuL6-0000j8-5Z; Fri, 05 Nov 2021 09:12:44 +0100
Date:   Fri, 5 Nov 2021 09:12:44 +0100
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
Message-ID: <20211105081244.brp34ec3covsuogt@flow>
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
> 
> This should be safe to apply on all stable kernels, and will be required
> in order to keep building them with gcc-11 and higher.

Could we get this applied, please?

Matthias Klose asked gcc-upstream if the change, causing the problem,
was expected/ intended. I don't think this matters given that the
provided fallback does not work.

Sebastian
