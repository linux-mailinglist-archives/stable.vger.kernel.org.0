Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3996C27834E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 10:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgIYIyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 04:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYIyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 04:54:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38D8A20936;
        Fri, 25 Sep 2020 08:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601024076;
        bh=WUsO90NrRNiC9qXLctTCks6srHq3oQgwUOOTfHCcVwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gE8po0vHMIbfkiEW+3o92m2Cy7cK/bkhLoB5LCkFgMDt6RhcJJmI3r9RsAAt5PK+u
         5qDCYP0ScFsV1joCpNgkKF6SCadjwW2VDB8PjG+qacJOAVzrWeF0d32Eh78NEVZJ3N
         Wzze7L3Y/TBL0XNy0SX83KZ4ztNUkn2sgZpJ9gpg=
Date:   Fri, 25 Sep 2020 10:54:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: LLVM=1 patches for 4.19
Message-ID: <20200925085451.GA2041632@kroah.com>
References: <CAKwvOdkHBGXSXiX-Sgc0D9PiG7eCUyGPE2kAuGJ=NO-CCASp2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkHBGXSXiX-Sgc0D9PiG7eCUyGPE2kAuGJ=NO-CCASp2A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 05:04:45PM -0700, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider the attached mbox file, which contains 10 patches which
> cherry pick cleanly onto 4.19.y:
> 1. commit 8708e13c6a06 ("MAINTAINERS: add CLANG/LLVM BUILD SUPPORT info")
> 2. commit 7bac98707f65 ("kbuild: add OBJSIZE variable for the size tool")
> 3. commit fcf1b6a35c ("Documentation/llvm: add documentation on
> building w/ Clang/LLVM")
> 4. commit 0f44fbc162b7 ("Documentation/llvm: fix the name of llvm-size")
> 5. commit 63b903dfebde ("net: wan: wanxl: use allow to pass
> CROSS_COMPILE_M68k for rebuilding firmware")
> 6. commit 734f3719d343 ("net: wan: wanxl: use $(M68KCC) instead of
> $(M68KAS) for rebuilding firmware")
> 7. commit eefb8c124fd9 ("x86/boot: kbuild: allow readelf executable to
> be specified")
> 8. commit aa824e0c962b ("kbuild: remove AS variable")
> 9. commit 7e20e47c70f8 ("kbuild: replace AS=clang with LLVM_IAS=1")
> 10. commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default
> tools to Clang/LLVM")
> 
> The series is analogous to the previous accepted series sent for 5.4,
> though this series is for 4.19.y:
> https://lore.kernel.org/stable/CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com/T/#u
> 
> I don't plan to backport the series any further than 4.19.

Yeah, I wouldn't worry about anything older than 4.19.y at the moment
for stuff like this.

All look good, now queued up, thanks!

greg k-h
