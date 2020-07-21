Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD312286E5
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 19:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgGURN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbgGURN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 13:13:26 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88393C061794;
        Tue, 21 Jul 2020 10:13:26 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id m8so9654544qvk.7;
        Tue, 21 Jul 2020 10:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZbVxqAmomsyhr+KEyYXdRet54/+siHxMMPFBRHCBS08=;
        b=qSfMSUQJ6WOKHXfb5DjEHw/nGyKktRAx4kiJQxElRHQr7JrxnQ1k55a8eCxv2zv65G
         gi7FoDOqHLECUyVllhxBYU6dyDEHKF6nNOUdK+p3K7mvrQzDLVrs6fiQfxMwh2mYaM/3
         crgg0ElpbMgjPqzygn8RHPhdeWOU1Q8LSH2isbjB4ISibsZKPioFclPsXWcJbdoRwiU8
         hSP4dbwmfHPPxD0xm4I5Hm6/41tMK1EXVkHKNH9gnP3goNxEG+SrNJlTYJ4Qu2vMVe1s
         2v3JDCnB6TpVN2329tBqdlXAOSPflCvpfyC5+vhn1KIxkOyFQto2nlGvLhVyykpISLv9
         tJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZbVxqAmomsyhr+KEyYXdRet54/+siHxMMPFBRHCBS08=;
        b=m7kON/awyOc6Olsi3KDskbnyF1swhSnw2+0rDTQ3ClemhP5urgnA4zu/EpxDDz/nxw
         lNSZfGcrA04r4gH6XXMnt3RRgefVeGaUROMdc2K/hSitQyuKF9cUmbVD7w9IsMo4hX4k
         w+hinAOykKctWGiklcFsTcQ3nrD3a7F0XoVbW4ZSVniP0aAVsw6g0a2Dom60/RsBD3zf
         MK63fpOu1Hfz5oNavwayYGy4yJI6wiCFiXPpJTuCQcooTFNQFgO7HNyjB20ONLTUP7hm
         mYbxpuu3akpV8Bq0J2T3T7ofSTLHiHgEi9ndvslu0TfQYtgAy4jNga6hXo49uXzzAdc9
         fgog==
X-Gm-Message-State: AOAM532jg3pvlTGvIqXTrLNWN69DYAQB5lcuKHUrF7zkWYzrah0e8EPo
        T0qJjTrFTxUp8xGyPuW4XKk=
X-Google-Smtp-Source: ABdhPJwAmHphVXWVxGd+7+rFL1JmGpNvGLd7pHr/P7IGmOsp2TKbd5OE9jgZNJcO8pPTI/vq4UXQnA==
X-Received: by 2002:a05:6214:851:: with SMTP id dg17mr27965377qvb.235.1595351605715;
        Tue, 21 Jul 2020 10:13:25 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id h124sm2938013qkd.84.2020.07.21.10.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 10:13:25 -0700 (PDT)
Date:   Tue, 21 Jul 2020 10:13:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Fangrui Song <maskray@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang
 cross compilation
Message-ID: <20200721171323.GA3327914@ubuntu-n2-xlarge-x86>
References: <20200721041940.4029552-1-maskray@google.com>
 <20200721104035.GC1676612@kroah.com>
 <CA+icZUW9JhZEEcXfL5bid7+M-Qtw22XzSm2x-JxW1bU15HJ6sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUW9JhZEEcXfL5bid7+M-Qtw22XzSm2x-JxW1bU15HJ6sA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 04:52:56PM +0200, Sedat Dilek wrote:
> On Tue, Jul 21, 2020 at 12:40 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jul 20, 2020 at 09:19:38PM -0700, Fangrui Song wrote:
> > > When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
> > > $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
> > > GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
> > > /usr/bin/ and Clang as of 11 will search for both
> > > $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
> > >
> > > GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
> > > $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
> > > $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
> > >
> > > To better model how GCC's -B/--prefix takes in effect in practice, newer
> > > Clang (since
> > > https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
> > > only searches for $(prefix)$needle. Currently it will find /usr/bin/as
> > > instead of /usr/bin/aarch64-linux-gnu-as.
> > >
> > > Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
> > > (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
> > > appropriate cross compiling GNU as (when -no-integrated-as is in
> > > effect).
> > >
> > > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > Signed-off-by: Fangrui Song <maskray@google.com>
> > > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > > Tested-by: Nathan Chancellor <natechancellor@gmail.com>
> > > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1099
> > > ---
> > > Changes in v2:
> > > * Updated description to add tags and the llvm-project commit link.
> > > * Fixed a typo.
> >
> >
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> >
> > </formletter>
> >
> 
> Hi Fangrui,
> 
> your patch needs to be accepted first in Linus tree - among other
> things to have a unique commit-id for inclusion into any affected
> Linux-stable trees.
> 
> Regards,
> - Sedat -

You are not wrong but that is not what Greg's auto response is complaining
about. It is that stable@vger.kernel.org was cc'd but there was no

Cc: stable@vger.kernel.org

in the commit message, which is how patches get automatically picked up
by Greg and Sasha once they hit Linus's tree.

That line should be added above my Reported-by tag. Fangrui, sorry for
not being clear in my initial response :(

Cheers,
Nathan
