Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2357524F3AC
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgHXIKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgHXIKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:10:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84A72074D;
        Mon, 24 Aug 2020 08:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256640;
        bh=ULx92fiehP+uNWO/U4kQmFzl/qMSZkrBJzTAAeQAPLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6j3U1gUGsTPlPJNiZTeQDc1HFwy2wOWuU2sFilWldC659awT6/HfYjRsFmcIMs3F
         2aflY6OpY87TwETLBxroTBsCGuSU90l3xUiJI0U5YuoO/jwqw4yQUayAMCKMRS9Nw+
         ZfhBkfAt3hgEZUKCrT/uK4shDKV5t33px5Z7Ax/E=
Date:   Mon, 24 Aug 2020 10:10:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fangrui Song <maskray@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: LLVM=1 patches for 5.4
Message-ID: <20200824081058.GB92813@kroah.com>
References: <CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=Ko_UHWF-bYotqjPVw=chW_KMUFuBp_o8uOg0wOyHyWA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 01:14:36PM -0700, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider the attached mbox file, which contains 9 patches which
> cherry pick cleanly onto 5.4:
> 
> 1. commit fcf1b6a35c16 ("Documentation/llvm: add documentation on
> building w/ Clang/LLVM")
> 2. commit 0f44fbc162b7 ("Documentation/llvm: fix the name of llvm-size")
> 3. commit 63b903dfebde ("net: wan: wanxl: use allow to pass
> CROSS_COMPILE_M68k for rebuilding firmware")
> 4. commit 734f3719d343 ("net: wan: wanxl: use $(M68KCC) instead of
> $(M68KAS) for rebuilding firmware")
> 5. commit eefb8c124fd9 ("x86/boot: kbuild: allow readelf executable to
> be specified")
> 6. commit 94f7345b7124 ("kbuild: remove PYTHON2 variable")
> 7. commit aa824e0c962b ("kbuild: remove AS variable")
> 8. commit 7e20e47c70f8 ("kbuild: replace AS=clang with LLVM_IAS=1")
> 9. commit a0d1c951ef08 ("kbuild: support LLVM=1 to switch the default
> tools to Clang/LLVM")
> 
> This series improves/simplifies building kernels with Clang and LLVM
> utilities; it will help the various CI systems testing kernels built
> with Clang+LLVM utilities (in fact I will be pointing to this, if
> accepted, next week at plumbers with those CI system maintainers), and
> we will make immediate use of it in Android (see also:
> https://android-review.googlesource.com/c/platform/prebuilts/clang/host/linux-x86/+/1405387).
> We can always carry it out of tree in Android, but I think the series
> is fairly tame, and would prefer not to.
> 
> I only particularly care about 5+8+9 (eefb8c124fd9, 7e20e47c70f8, and
> a0d1c951ef08), but the rest are required for them to cherry-pick
> cleanly.  I don't mind separating those three out, though they won't
> be clean cherry-picks at that point.  It might be good to have
> Masahiro review the series.  If accepted, I plan to wire up test
> coverage of these immediately in
> https://github.com/ClangBuiltLinux/continuous-integration/issues/300.
> 
> Most of the above landed in v5.7-rc1, with 94f7345b7124 landing in
> v5.6-rc1 and eefb8c124fd9 landing in v5.5-rc3.

All now queued up, thanks.

greg k-h
