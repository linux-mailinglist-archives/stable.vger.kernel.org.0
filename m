Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5F32DEED7
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLSMn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgLSMn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:43:56 -0500
Date:   Sat, 19 Dec 2020 13:44:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381796;
        bh=/m46wXCYI9jTZMr0nanVkMDjElQKyVfbvgN+p6WwQUM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ia6Y8RUL9CHVUa9yqLpU5t9gk3tlc6H9Su2NbdFZH/fNpJBW6u8gOpZDinesI1KrN
         z2C1dKufnNImwEhSOlLGFWhF0g9ZhE4WtOyLjzNXzlrZvLvqzIKv1igwkj4lEOxcVx
         LQgSQKy1+lVBbSltXvoosyrDSg3DHwGv5YL74eZA=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>, Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: FAILED: patch "[PATCH] arm64: Change .weak to
 SYM_FUNC_START_WEAK_PI for" failed to apply to 4.19-stable tree
Message-ID: <X931tHcHF8iIjo+t@kroah.com>
References: <1604431094102246@kroah.com>
 <CAKwvOdkE8_1s4xPYU0Gq9Ld9XhkFn1FowJJt5ZF5ve9zT8uL1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkE8_1s4xPYU0Gq9Ld9XhkFn1FowJJt5ZF5ve9zT8uL1w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 03:16:34PM -0800, Nick Desaulniers wrote:
> On Tue, Nov 3, 2020 at 11:18 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From ec9d78070de986ecf581ea204fd322af4d2477ec Mon Sep 17 00:00:00 2001
> > From: Fangrui Song <maskray@google.com>
> > Date: Thu, 29 Oct 2020 11:19:51 -0700
> > Subject: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for
> >  arch/arm64/lib/mem*.S
> 
> Dear stable kernel maintainers, please consider applying the attached
> patch for 4.19.y.  It is adjusted to avoid conflicts due to:
>       commit 3ac0f4526dfb ("arm64: lib: Use modern annotations for
> assembly functions")
>       commit 35e61c77ef38 ("arm64: asm: Add new-style position
> independent function annotations")]
> not being backported to 4.19.y.  It helps us enable LLVM_IAS=1 builds
> for aarch64 for Android and CrOS.

Now applied, thanks.

greg k-h
