Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D442D78C0
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403999AbgLKPFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437579AbgLKPE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:04:27 -0500
Date:   Fri, 11 Dec 2020 15:25:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607696660;
        bh=bATZlkCI1CVLo8rB+Thvi7fBSnI1Y8jz0vLE9ryx04Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zq53PehbLTN7Ur51LZg5ouH4Y3Kiu/jC7OtJHCmg+dQg4riBBsLXMHwqfBk9J8t7j
         7WxDq3wo3b8Anh3IdAOBj1MlqeYGBOw3UoCGKZw7bRkeagSFPWUZ3FzCVaCywVQbhk
         huYrQGpFHY3i70C3mAfuIzGQtz53ieZFNM4niIaI=
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
Message-ID: <X9OBU+Ey8xlrFv2F@kroah.com>
References: <CAKwvOdnGDHn+Y+g5AsKvOFiuF7iVAJ8+x53SgWxH9ejqEZwY9w@mail.gmail.com>
 <X9CuL4Kdl1dw2gws@kroah.com>
 <CAKwvOdkN85dnAEUCvjULh8-gojwmK-e4-aVhNbO0RdyXsO_H2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkN85dnAEUCvjULh8-gojwmK-e4-aVhNbO0RdyXsO_H2w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 01:21:00PM -0800, Nick Desaulniers wrote:
> On Wed, Dec 9, 2020 at 2:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Dec 08, 2020 at 04:43:34PM -0800, Nick Desaulniers wrote:
> > > Dear stable kernel maintainers,
> > > (Woah, two in one day; have I exceeded my limit?)
> > >
> > > Please consider the attached patch for 5.4 and 4.19 for commit
> > > b8a9092330da ("Kbuild: do not emit debug info for assembly with
> > > LLVM_IAS=1"), which fixes a significant number of warnings under arch/
> > > when assembling a kernel with Clang.
> >
> > I also need a version of this for 5.9.y before we can take this for
> > older kernels.  Can you provide that as well?
> 
> Yes, apologies.  It's similar to the 5.4.y patch, but with a shorter
> set of conflicts as noted in the commit message.  Attached.
> -- 
> Thanks,
> ~Nick Desaulniers

thanks, all now applied.

greg k-h
