Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB0C2452D1
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHOVzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729082AbgHOVwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Aug 2020 17:52:25 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7C2C06134E;
        Fri, 14 Aug 2020 18:40:10 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s16so8363579qtn.7;
        Fri, 14 Aug 2020 18:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/LJPODsukhk9ilKQ5Nhku7oJFNIdXYTCpu7/+RHvulw=;
        b=nLw79+rmoA2nElv+xnAFz8nXs/AlqzKnFWwt843zJ3flzcKUwV86WHPBtEYbGdl5NP
         pnqjP3u+xb17yJYfFXiutjt5y02NnTJhiiK+ZWvPo1FnjYjhvPeBe3k8ZDAidXu43QGq
         LbWjjCzzatkcCYFiRlFEBJFcPjmZx9Fgp5T/gy4C+x8ofCMVUTXcQS2wYBKnAMzgLLDl
         N3sNkBhDhQOg6mxoqkBrL4ooaXdjWLbuTEkNTdFlLF3gIpRqhFuBfOXvKMB+hx9XziB0
         r1Jr4Dar9TLw3jf6AXi2DhpbsoYTRIVyi3C5kYBH4EczNGf1VF+SSu0DtQBoYNU1CoYe
         mucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/LJPODsukhk9ilKQ5Nhku7oJFNIdXYTCpu7/+RHvulw=;
        b=lstCFHrmSlFJg/onNcoL1XX4e25IpL/hmpg3514jSmxI1eSsTk/tkDDUK1Kx/foNyQ
         lwz6Vu9XuSOcEhd7ynpEDawpzoQ1yDB+a6bcNTMIIVFR7wg6oT3mpcNZwCoXIe9wjvpZ
         LdSRYxFO19hyZhVUy1blD6kM2RFeALJ4Soug8vW9uDeV9CaSeOZOhgztXII1/Key80g5
         fynfYBI6APR+bBPgHO4eHh0aS7AMYRUK/GZQodrD/U6H2A9bOOmjxUI91BBiOnmrs/CX
         2lTBBCMZWV4WT22i8rm0H7hm80LQNs2VTbikKy0UiEy1VL+/MBiT9o2zOyPDygPbbTZm
         0cPA==
X-Gm-Message-State: AOAM533cp/9KF5gEc5Ts+u5cTo013aK1dl+EUEuK54Ov1fbFXXaRBdOZ
        jpn3M8HClDAcyKpvI1i15R8=
X-Google-Smtp-Source: ABdhPJytsRGRgirZNN/jnyKlfg9rTWG21qGTYN95Pon23TrSBl+teD15V1iyGWo9t9zg5J2PXwAGEA==
X-Received: by 2002:aed:3789:: with SMTP id j9mr4809739qtb.251.1597455608719;
        Fri, 14 Aug 2020 18:40:08 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id d124sm9846309qkg.65.2020.08.14.18.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 18:40:08 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 14 Aug 2020 21:40:06 -0400
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RMOhdmlkIEJvbHZhbnNrw70=?= <david.bolvansky@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Joe Perches <joe@perches.com>, Tony Luck <tony.luck@intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] lib/string.c: implement stpcpy
Message-ID: <20200815014006.GB99152@rani.riverdale.lan>
References: <20200815002417.1512973-1-ndesaulniers@google.com>
 <20200815013310.GA99152@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200815013310.GA99152@rani.riverdale.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 14, 2020 at 09:33:10PM -0400, Arvind Sankar wrote:
> On Fri, Aug 14, 2020 at 05:24:15PM -0700, Nick Desaulniers wrote:
> > +#ifndef __HAVE_ARCH_STPCPY
> > +/**
> > + * stpcpy - copy a string from src to dest returning a pointer to the new end
> > + *          of dest, including src's NULL terminator. May overrun dest.
> > + * @dest: pointer to end of string being copied into. Must be large enough
> > + *        to receive copy.
> > + * @src: pointer to the beginning of string being copied from. Must not overlap
> > + *       dest.
> > + *
> > + * stpcpy differs from strcpy in two key ways:
> > + * 1. inputs must not overlap.
> > + * 2. return value is the new NULL terminated character. (for strcpy, the
> > + *    return value is a pointer to src.
> > + */
> > +#undef stpcpy
> > +char *stpcpy(char *__restrict__ dest, const char *__restrict__ src)
> > +{
> > +	while ((*dest++ = *src++) != '\0')
> > +		/* nothing */;
> > +	return dest;
> > +}
> > +#endif
> > +
> 
> Won't this return a pointer that's one _past_ the terminating NUL? I
> think you need the increments to be inside the loop body, rather than as
> part of the condition.
> 
> Nit: NUL is more correct than NULL to refer to the string terminator.

Also, strcpy (at least the one in the C standard) is undefined if the
strings overlap, so that's not really a difference.
