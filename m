Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0CC17EDFB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 02:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgCJBZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 21:25:48 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39141 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgCJBZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 21:25:48 -0400
Received: by mail-ot1-f67.google.com with SMTP id a9so5423329otl.6;
        Mon, 09 Mar 2020 18:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cmN98IWbXYyX8O2K4XgYM3Py4nvl6j5+94LDp5dV7Vg=;
        b=jvlcjXMjPstzI1Okjh/O3QUZAvEZ/Kfyu5rZtN85X3RDxZIoT+I3FhiQfszFnUr3PB
         rjmvnd3BYoxcsbifr59TRJioEiue9ZjkbeBNvPZfMCho+uGrn0i70dBK7SeX80CSg08J
         qZudc2nOaAdJa6DnlqPdlb0Fw9gRC0AvYtjXPYqHfy/pjB90OkMLJddiXIHwolBk6BCY
         0fQra8IBoVitfNhdkmYs5L0+NUEwn79eHP1V+OUpTDiHzQ0aRNZ3zjxjdrEQsRiJyeN7
         QDz9KkAQqZ5cxRTxp7yd2Uy1kiTtNbYk4I3/6/QL5n60RlOwHHJEnxEsrwCywKRVZCDQ
         gefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cmN98IWbXYyX8O2K4XgYM3Py4nvl6j5+94LDp5dV7Vg=;
        b=pGcVz32P31Uxg6h5kl4mGcT144Le69mboQt8ivJIWR5guJiHD7zt/434XIP0QXS8Z7
         Y0zx2JZIeC23w1ezrE62MaN5mK2RLuomAkE/N7qtxvdnimLplj8SHT3J3l1BFtC9jdJf
         fQAf0yps/UEIILa4gXk11s1T23rPzc2S7KSxgUdmoZKpsMtLzUlT2lPEMVh4lge2tW1z
         +pMFQyYLaaMESVbICgfA2/b2IwZ7pADSBUs1cUL5u9RjMsvkGoBT1PO72LRTHfePxFt2
         AtwEbMuBTzz9uTlZIc05zedwOP1U9QFWnOzgyi6+/rAe0rsZeS1XdmpWhY2npPKF6rbO
         5Ehw==
X-Gm-Message-State: ANhLgQ0cpewjBQyxtqvNLKEi9E25Gn6BOr+Xt6lchJnqx2OtyHGdMc7e
        DgR5fmEFcOYJzagh0ZBu65XigpEa
X-Google-Smtp-Source: ADFU+vsxGNApGisVXD3NVMh8XI7wrg8LefHd5C3x98L4l2FQ2Gua3VLLXwZCRmR0sWFzd+7I9aIcXA==
X-Received: by 2002:a9d:3de4:: with SMTP id l91mr15681122otc.35.1583803547733;
        Mon, 09 Mar 2020 18:25:47 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id e15sm3769314oie.3.2020.03.09.18.25.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Mar 2020 18:25:47 -0700 (PDT)
Date:   Mon, 9 Mar 2020 18:25:45 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
Message-ID: <20200310012545.GA16822@ubuntu-m2-xlarge-x86>
References: <20200308073400.23398-1-natechancellor@gmail.com>
 <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 11:11:05AM +0900, Masahiro Yamada wrote:
> Hi Nathan,
> 
> On Sun, Mar 8, 2020 at 4:34 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
> > casting to enums. The kernel does this in certain places, such as device
> > tree matches to set the version of the device being used, which allows
> > the kernel to avoid using a gigantic union.
> >
> > https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
> > https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
> > https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264
> >
> > To avoid a ton of false positive warnings, disable this particular part
> > of the warning, which has been split off into a separate diagnostic so
> > that the entire warning does not need to be turned off for clang.
> >
> > Cc: stable@vger.kernel.org
> > Link: https://github.com/ClangBuiltLinux/linux/issues/887
> > Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  Makefile | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/Makefile b/Makefile
> > index 86035d866f2c..90e56d5657c9 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -748,6 +748,10 @@ KBUILD_CFLAGS += -Wno-tautological-compare
> >  # source of a reference will be _MergedGlobals and not on of the whitelisted names.
> >  # See modpost pattern 2
> >  KBUILD_CFLAGS += -mno-global-merge
> > +# clang's -Wpointer-to-int-cast warns when casting to enums, which does not match GCC.
> > +# Disable that part of the warning because it is very noisy across the kernel and does
> > +# not point out any real bugs.
> > +KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
> >  else
> 
> 
> 
> I'd rather want to fix all the call-sites (97 drivers?)
> instead of having -Wno-pointer-to-enum-cast forever.

Yes, there are 97 unique warnings across my builds, which are mainly
arm, arm64, and x86_64 defconfig/allmodconfig/allyesconfig:

https://github.com/ClangBuiltLinux/linux/issues/887#issuecomment-587938406

> If it is tedious to fix them all for now, can we add it
> into scripts/Makefile.extrawarn so that this is disabled
> by default, but shows up with W=1 builds?

Sure, I can send v2 to do that but I think that sending 97 patches just
casting the small values (usually less than twenty) to unsigned long
then to the enum is rather frivolous. I audited at least ten to fifteen
of these call sites when creating the clang patch and they are all
basically false positives.

I believe Nick discussed this with some other developers off list, maybe
he has some other feedback to give. I'll wait to send a v2 until
tomorrow in case anyone else has further comments.

> (When we fix most of them, we will be able to
> make it a real warning.)
> 
> 
> What do you think?
> 
> Thanks.

Cheers,
Nathan
