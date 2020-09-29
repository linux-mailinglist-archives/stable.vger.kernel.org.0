Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED76227BD6C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 08:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgI2Gyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 02:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI2Gyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 02:54:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDE62083B;
        Tue, 29 Sep 2020 06:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601362481;
        bh=BV2/HQX1w5FRtwF+2OrRX8VXSYkopTtOcCZ3CxkZcbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITe7N6vzA2up3sFzp3OQ9K006YOXv81Go4Cj0Rpjg16KFmoUAWuixmFDRCwsf1Ns4
         MP6TF25YJgQNNBHHJExuzW+zzrvY7yXaZjAgkZjAqFLCnt9Fwamzeg+y1zX8JBTPdn
         LZJsLtBFq097nhtAmv8QfykIVSG3eWEcoHboJDcg=
Date:   Tue, 29 Sep 2020 08:54:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: lib/string.c: implement stpcpy for 4.14, 4.9, and 4.4
Message-ID: <20200929065448.GC2439787@kroah.com>
References: <CAKwvOd=iRhjy_3Ebzj0=ptKCSfcdaKe71n9Hs-KSkJTzxmRD-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=iRhjy_3Ebzj0=ptKCSfcdaKe71n9Hs-KSkJTzxmRD-w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 01:17:15PM -0700, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider applying the following patches to 4.14, 4.9, and 4.4
> implementing stpcpy, which is required when building w/ clang-12 and
> newer.  These are manual backports of patches already accepted into
> stable earlier today, but for branches which they do not cherry pick
> back cleanly, due to us not backporting commit 458a3bf82df4
> ("lib/string: Add strscpy_pad() function") which landed in v5.2-rc1.
> 
> Thanks to Nathan Chancellor for taking the time to backport these.
> The 4.9 and 4.4 patches look the same to me (other than the base).

Ah, I didn't realize you needed these to go back further, which is why I
didn't do it.  Now queued up, thanks.

greg k-h
