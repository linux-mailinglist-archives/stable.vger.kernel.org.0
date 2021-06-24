Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CFB3B3080
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFXNxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 09:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhFXNx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 09:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7961B613EA;
        Thu, 24 Jun 2021 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624542669;
        bh=AqCIsPnTqsE0K/ONL9Wov9nBlpH66La8TOVY0e1N6O4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hzixfj2luXCZtiuRhKJcW3TfjRp6Bonzr0t2IFfH2xbfW6qlT3Yy5CXYRttZETZmF
         7lLWnpgNR0zDaSYbGuRiYOm5955xLwbMgLsGbVeEHjPsdJA+K/CK2YYdzbrTHe8S+Z
         xTz02uZgd4p87pXz4YDppJb+U73rBkKVN6SSpevUTOkDcvAPPfi8ctaHM4KslBTO77
         3GgkG2BfJkl7tLolcSJbndFdpszOahZtXEUybJxTLTExlfq2xFOvcR2lLDKZFda63f
         0+Hb9jScGzJ4BIIqdI8fyNXDndIvZM3BlgfsLC//0Bb4p2leu9H/qWMtzwVx1kQcsx
         gq87Q2+X03Zxg==
Date:   Thu, 24 Jun 2021 08:04:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 4.4 to 4.19] Makefile: Move -Wno-unused-but-set-variable
 out of GCC only block
Message-ID: <YNR02aQT3f9Naap/@sashalap>
References: <20210623172610.3281050-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210623172610.3281050-1-nathan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 10:26:12AM -0700, Nathan Chancellor wrote:
>commit 885480b084696331bea61a4f7eba10652999a9c1 upstream.
>
>Currently, -Wunused-but-set-variable is only supported by GCC so it is
>disabled unconditionally in a GCC only block (it is enabled with W=1).
>clang currently has its implementation for this warning in review so
>preemptively move this statement out of the GCC only block and wrap it
>with cc-disable-warning so that both compilers function the same.
>
>Cc: stable@vger.kernel.org
>Link: https://reviews.llvm.org/D100581
>Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>[nc: Backport, workaround lack of e2079e93f562 in older branches]

Can we just take the above patch instead?

-- 
Thanks,
Sasha
