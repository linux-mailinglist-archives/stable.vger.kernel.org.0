Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386172D4075
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgLIK7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbgLIK7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:59:23 -0500
Date:   Wed, 9 Dec 2020 11:59:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511522;
        bh=E23eO2DnR2ksm+i8wBbesQovtHMBoxwER1BmmVNALu0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ETvtKf7z87QaYSFmrepzlq+qZgcf73AZYRjD3gGDAtfQJe0vryz5x0s3yUNJrlXCM
         bpBLkGyiFNLGduHhmB6kRtqK02E6e91e/jS9DPSvxzvTV8+PBrqbED+fPDH+9PO1m4
         JCwbhL3OZf2ILEl3IIEYTDxcU0sj7ucbuptMftyI=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Dmitry Golovin <dima@golovin.in>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jian Cai <jiancai@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Subject: Re: 5.4 and 4.19 warning fix for LLVM_IAS
Message-ID: <X9CuL4Kdl1dw2gws@kroah.com>
References: <CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 04:43:34PM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> (Woah, two in one day; have I exceeded my limit?)
> 
> Please consider the attached patch for 5.4 and 4.19 for commit
> b8a9092330da ("Kbuild: do not emit debug info for assembly with
> LLVM_IAS=1"), which fixes a significant number of warnings under arch/
> when assembling a kernel with Clang.

I also need a version of this for 5.9.y before we can take this for
older kernels.  Can you provide that as well?

thanks,

greg k-h
