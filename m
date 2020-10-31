Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE602A1530
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgJaK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgJaK3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805FA20885;
        Sat, 31 Oct 2020 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604140175;
        bh=b5dW76EIFokZI+6FzLfCv4T51iLrydrrJrULF4T46VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SunlFEtnH6MidXcF2p8JxBTCbWNCNAaCSaM59tj5CeVMVEmn9dPqSgXAWUGig1q7T
         QX7G5WxguTjefZzfX2nvVgNc+2jEZ0O3MAvR8jHEjefOzxOBGNOkhd+KZgVDWzWAvx
         mc77LtD+LtPx6ghshdUkXehHaMGUpr5vfmWt8ZfE=
Date:   Sat, 31 Oct 2020 11:30:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jian Cai <jiancai@google.com>
Subject: Re: [PATCH] crypto: x86/crc32c - fix building with clang ias
Message-ID: <20201031103020.GA961225@kroah.com>
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201030190245.92967-1-jiancai@google.com>
 <CAKwvOdmduyqjn7d6mG6CrSqCJC3ikJRphjWfKnqxvC2P=yoU2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmduyqjn7d6mG6CrSqCJC3ikJRphjWfKnqxvC2P=yoU2g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 12:06:28PM -0700, Nick Desaulniers wrote:
> + stable
> 
> On Fri, Oct 30, 2020 at 12:04 PM Jian Cai <caij2003@gmail.com> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > commit 44623b2818f4 ("crypto: x86/crc32c - fix building with clang ias")
> > upstream
> >
> > The clang integrated assembler complains about movzxw:
> >
> > arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
> >
> > It seems that movzwq is the mnemonic that it expects instead,
> > and this is what objdump prints when disassembling the file.
> >
> > Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > [jc: Fixed conflicts due to lack of 34fdce6981b969]

Nit, please spell out commit ids as the documentation asks you to.  I've
edited it and done that now...

thanks,

greg k-h
