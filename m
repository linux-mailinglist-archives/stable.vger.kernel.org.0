Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA81B6633
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 23:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWVk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 17:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgDWVk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 17:40:28 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBFBC09B042;
        Thu, 23 Apr 2020 14:40:28 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k28so5973040lfe.10;
        Thu, 23 Apr 2020 14:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B4RZTKHTrP3wBG9zJwtWhegdvgn29ox5YrCUT7WXAJ4=;
        b=ZJcQEntdxgbMblE+z87/QKGJ+awD1Ot2/CtIuojgn1sBDQlha8fMitzxPccH2Udh9s
         I4B2Zcvkyl5/qQIRa1Uoa0l7mSmBiLeBHnsBLEbMtwa/TZkSL3ztvU+er12+tssMXaeV
         omsUP4YrSGL70eu6Tz0YZffopVruh6Dxh13cLnAqv1HLnqTHY7VT5/b7t1SAxv/6tdum
         92IbiU2W7jyitvI2knRYKRav7zxafRZdZnRUos5G1rFkwTntYyuffu26EZ+z58z9yBb5
         vcfhOddriibnHRmu8Iw+XfrWeQ9U5j9aVZQAaHIDVqUhoUh/hmus61aQIikNCrmovsy7
         onsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B4RZTKHTrP3wBG9zJwtWhegdvgn29ox5YrCUT7WXAJ4=;
        b=ewxHHxZiL/3RJXpnLOQsaDfcNQbWyI18oIMC7zjDCrpm674x1pWJKmbiR/1kIy4rZq
         YALSGvUY4FtxsN3xF4fkn2dlb035FAJvJffcrzt3K9mFdcSJVTmi8lskh3I3pQCzyL4z
         GmmKto7+OrW7VFaP6PqQ6DBvtDTAFjHqNcpi8w4/fB41z2HhatyeEeIebHZWtU67X9i+
         dD1ERGKQOn+bGm+HY/3vVhyOnSV9wdxN7T88S+Zus655SUYa/MlnrGhtLjtEMKUtTWsO
         b9vPNJv1Xe8gB3NR6/5N4Bfn2+pF8ZQoSTnbzbV3n+9zEzTV3+pSd2gciHVuTQzPDVs7
         q40A==
X-Gm-Message-State: AGi0PuY9O4e8nH3mn7gH/UPVxi9ZYwYdWPTvFuoA/HIPD9/07+DplYSq
        HwilxE4ODmG7ZmD7Z3JvilZ+iAoXzys=
X-Google-Smtp-Source: APiQypLGcMo/fEop6NY0fVLEt7nOPRCfs1D3JpZ9PxBpTTWfza5WJZD2RcJ7an3XzqYq23asN5h8mg==
X-Received: by 2002:a19:7706:: with SMTP id s6mr3714355lfc.31.1587678026931;
        Thu, 23 Apr 2020 14:40:26 -0700 (PDT)
Received: from rikard (h-82-196-111-165.NA.cust.bahnhof.se. [82.196.111.165])
        by smtp.gmail.com with ESMTPSA id s30sm2914129lfc.93.2020.04.23.14.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 14:40:26 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
X-Google-Original-From: Rikard Falkeborn <rikard.falkeborn>
Date:   Thu, 23 Apr 2020 23:40:23 +0200
To:     Sasha Levin <sashal@kernel.org>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Haren Myneni <haren@us.ibm.com>, Joe Perches <joe@perches.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 5.4 52/84] linux/bits.h: add compile time sanity
 check of GENMASK inputs
Message-ID: <20200423214023.GA1153@rikard>
References: <20200415114442.14166-1-sashal@kernel.org>
 <20200415114442.14166-52-sashal@kernel.org>
 <20200415194032.GA935@rikard>
 <20200422005735.GW1809@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422005735.GW1809@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 08:57:35PM -0400, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 09:40:32PM +0200, Rikard Falkeborn wrote:
> > On Wed, Apr 15, 2020 at 07:44:09AM -0400, Sasha Levin wrote:
> > > From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> > > 
> > > [ Upstream commit 295bcca84916cb5079140a89fccb472bb8d1f6e2 ]
> > > 
> > > GENMASK() and GENMASK_ULL() are supposed to be called with the high bit as
> > > the first argument and the low bit as the second argument.  Mixing them
> > > will return a mask with zero bits set.
> > > 
> > > Recent commits show getting this wrong is not uncommon, see e.g.  commit
> > > aa4c0c9091b0 ("net: stmmac: Fix misuses of GENMASK macro") and commit
> > > 9bdd7bb3a844 ("clocksource/drivers/npcm: Fix misuse of GENMASK macro").
> > > 
> > > To prevent such mistakes from appearing again, add compile time sanity
> > > checking to the arguments of GENMASK() and GENMASK_ULL().  If both
> > > arguments are known at compile time, and the low bit is higher than the
> > > high bit, break the build to detect the mistake immediately.
> > > 
> > > Since GENMASK() is used in declarations, BUILD_BUG_ON_ZERO() must be used
> > > instead of BUILD_BUG_ON().
> > > 
> > > __builtin_constant_p does not evaluate is argument, it only checks if it
> > > is a constant or not at compile time, and __builtin_choose_expr does not
> > > evaluate the expression that is not chosen.  Therefore, GENMASK(x++, 0)
> > > does only evaluate x++ once.
> > > 
> > > Commit 95b980d62d52 ("linux/bits.h: make BIT(), GENMASK(), and friends
> > > available in assembly") made the macros in linux/bits.h available in
> > > assembly.  Since BUILD_BUG_OR_ZERO() is not asm compatible, disable the
> > > checks if the file is included in an asm file.
> > > 
> > > Due to bugs in GCC versions before 4.9 [0], disable the check if building
> > > with a too old GCC compiler.
> > > 
> > > [0]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=19449
> > > 
> > > Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Haren Myneni <haren@us.ibm.com>
> > > Cc: Joe Perches <joe@perches.com>
> > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > Cc: lkml <linux-kernel@vger.kernel.org>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Link: http://lkml.kernel.org/r/20200308193954.2372399-1-rikard.falkeborn@gmail.com
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  include/linux/bits.h | 22 ++++++++++++++++++++--
> > >  1 file changed, 20 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/bits.h b/include/linux/bits.h
> > > index 669d69441a625..f108302a3121c 100644
> > > --- a/include/linux/bits.h
> > > +++ b/include/linux/bits.h
> > > @@ -18,12 +18,30 @@
> > >   * position @h. For example
> > >   * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
> > >   */
> > > -#define GENMASK(h, l) \
> > > +#if !defined(__ASSEMBLY__) && \
> > > +	(!defined(CONFIG_CC_IS_GCC) || CONFIG_GCC_VERSION >= 49000)
> > > +#include <linux/build_bug.h>
> > > +#define GENMASK_INPUT_CHECK(h, l) \
> > > +	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
> > > +		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
> > > +#else
> > > +/*
> > > + * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
> > > + * disable the input check if that is the case.
> > > + */
> > > +#define GENMASK_INPUT_CHECK(h, l) 0
> > > +#endif
> > > +
> > > +#define __GENMASK(h, l) \
> > >  	(((~UL(0)) - (UL(1) << (l)) + 1) & \
> > >  	 (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
> > > +#define GENMASK(h, l) \
> > > +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
> > > 
> > > -#define GENMASK_ULL(h, l) \
> > > +#define __GENMASK_ULL(h, l) \
> > >  	(((~ULL(0)) - (ULL(1) << (l)) + 1) & \
> > >  	 (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
> > > +#define GENMASK_ULL(h, l) \
> > > +	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
> > > 
> > >  #endif	/* __LINUX_BITS_H */
> > > --
> > > 2.20.1
> > > 
> > 
> > This does not really fix anything, it's compile time prevention, so I
> > don't know how appropriate this is for stable (it was also picked for
> > 5.5 and 5.6, but I'm just replying here now, I can ping the other
> > selections if necessary if the patch should be dropped)?
> > 
> > Also, for 5.4, it does somewhat depend on commit 8788994376d8
> > ("linux/build_bug.h: change type to int"). Without it, there may be a
> > subtle integer promotion issue if sizeof(size_t) > sizeof(unsigned long)
> > (I don't *think* such platform exists, but I don't have a warm a fuzzy
> > feeling about it).
> 
> I'll drop it from this selection, but ideally I'd like to have it in.
> 
> The codebase is different between Linus's tree and the stable trees, and
> I'm worried that some of these GENMASK issues were fixed upstream and
> not in the stable trees. Getting this patch back would help us fix those
> with minimal risk.
> 
> -- 
> Thanks,
> Sasha

Ok, I see. If you think it's good to backport it to the stable trees,
I'm all for it. I've been thinking a bit about commit 8788994376d8 
("linux/build_bug.h: change type to int"), I *think* it is probably fine
without it, but I'd rather be safe than sorry, but it's your call
really.

Rikard

Rikard
