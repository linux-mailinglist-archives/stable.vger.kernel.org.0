Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2D2DEED6
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgLSMna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgLSMna (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:43:30 -0500
Date:   Sat, 19 Dec 2020 13:44:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381769;
        bh=2ORg0ZsITa7Pf//mqaoQBxoKkPOS8csSsY539dXXaxQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=dIEvczRjuJa+iC8pCFPy0LJZ9RR8eTEA7SF4wht0EgVPn8LdJtcJJQHQ4YAtguVC3
         jVVUgNJ4QVygo/I2ZpDJ0w1rUCZjPUMtshTTJfPaXdA8Sw+yg9wywv1yk+aP39owPW
         Iz6irgQREBJb9wiZnhYxPtwkyl3rWyNv6Px6ZmpU=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jian Cai <jiancai@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Amit Daniel Kachhap <Amit.Kachhap@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: arm64 v4.19.y LLVM_IAS=y patches
Message-ID: <X931mZNdiLxCfEUy@kroah.com>
References: <CAKwvOdmEcjjw78K0Avj-7s5BBXcT7ARhEMMEYqpCP-ZT=2dAJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmEcjjw78K0Avj-7s5BBXcT7ARhEMMEYqpCP-ZT=2dAJw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 05:08:38PM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider applying the following backports of commit
> e0d5896bd356 ("arm64: lse: fix LSE atomics with LLVM's integrated
> assembler") which first landed in v5.6-rc1 and was already picked up
> into linux-5.4.y as f68668292496 in v5.4.22 (adjusted for a conflict
> due to commit addfc38672c7 ("arm64: atomics: avoid out-of-line ll/sc
> atomics") which landed in v5.4-rc1).
> 
> Also contains a fix for that first patch which cherry-picks cleanly,
> commit dd1f6308b28e ("arm64: lse: Fix LSE atomics with LLVM").
> 
> The attached patches allow for Android and CrOS to build with
> LLVM_IAS=1 for arm64 for v4.19.y (modulo one small patch that I will
> send tomorrow).

Now queued up, thanks.

greg k-h
