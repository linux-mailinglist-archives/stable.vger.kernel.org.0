Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AB72353C7
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHAR1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 13:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHAR1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 13:27:50 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC7C06174A;
        Sat,  1 Aug 2020 10:27:49 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id j10so8896624qvo.13;
        Sat, 01 Aug 2020 10:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sH4ZgoE2+krh+pccRrSZUcqU9PhKP/eT8yH9LsNvEAE=;
        b=lDrKUAaQxNvYx4tI3nODZhJ8NcdsIkFV5oX3fhol8e4eN7e+SiVw939+t1R8UOsx01
         NSBpVkU25zrVoic7dwx7vwPpt2Aoqluvpt9j57py3CrKQWNWRW/0ocBMD52snn+v8caX
         M5EIHqZBjgjmuY1sMynhvFwF9WFUnBJY9U/R0onHK6bADrVu5jsdfo7KQi7I+b3rmiyH
         I94kcHuWo7JSHfdbKTGM6SWqwPkurjVD4/oFL2UnQJjspmk2pVz1JyEb9FbK2c5RyjH8
         e8Hlx4C+F+z+XQ3k78QRq/hE1RDG6ofkeYYFzko1A5R84bKXmrmY/eSIefXtxSAK4nDW
         K76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sH4ZgoE2+krh+pccRrSZUcqU9PhKP/eT8yH9LsNvEAE=;
        b=MTPYBAxVbM1E8LjLl+ZvzGea48iUR/V7PiezQ6Q6mmlYL8nDAZFHUuFdvTipXQsVB9
         ftPFXn4YSQgwuGziioJnk3B2SCfvQ0RxCqaL4SzxTlZFN/4PsNjZBOSTTNONl44im0ZO
         fWQx8VJt3dHpL3eHmWpxvFaPv0KMpMw0xr1N5JLEj6oSmaBY67qk3hy3ZSHiIohninTi
         MxUPm5RmDUok5fDdUnpgR+Va2vRqMJsaHscR1N83TvgnRoV2v6DEghs/iHtggByZGwn1
         df8kRCpkISIjqWW3WhHueN37jduN+B07IqBVwXo8cwkoMsIkol/jqniJC2cjgktJwhlv
         9gag==
X-Gm-Message-State: AOAM530AK+4zEsGiJFJCjSZGvpEtVGqo3tJDBP1hvo74Y3M6VcHvbFZm
        K2dkZRpuKmTx8fT0lkwFpvs=
X-Google-Smtp-Source: ABdhPJzHOFdwhm3qJs8SrnZpWK+1UKvwkZdOAaQkwtzYxCu1nPpleYVo2pqxw+5n/1qFGKkbypbvDA==
X-Received: by 2002:ad4:43c9:: with SMTP id o9mr9657897qvs.217.1596302868608;
        Sat, 01 Aug 2020 10:27:48 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id z197sm13658960qkb.66.2020.08.01.10.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 10:27:48 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Sat, 1 Aug 2020 13:27:46 -0400
To:     Kees Cook <keescook@chromium.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input
 sections
Message-ID: <20200801172746.GC3249534@rani.riverdale.lan>
References: <20200731230820.1742553-1-keescook@chromium.org>
 <20200731230820.1742553-14-keescook@chromium.org>
 <20200801035128.GB2800311@rani.riverdale.lan>
 <202007312237.4F385EB3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007312237.4F385EB3@keescook>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 11:18:02PM -0700, Kees Cook wrote:
> On Fri, Jul 31, 2020 at 11:51:28PM -0400, Arvind Sankar wrote:
> > 
> > This also changes the ordering to place all hot resp unlikely sections separate
> > from other text, while currently it places the hot/unlikely bits of each file
> > together with the rest of the code in that file. That seems like a reasonable
> 
> Oh, hmm, yes, we aren't explicitly using SORT() here. Does that mean the
> input sections were entirely be ordered in compilation unit link order,
> even in the case of orphan sections? (And I think either way, the answer
> isn't the same between bfd and lld.) I actually thought the like-named
> input sections were collected together first with lld, but bfd strictly
> appended to the output section. I guess it's time for me to stare at -M
> output from ld...

I don't know what happened to the orphans previously. But .text.hot and
.text.unlikely will now change ordering. It sounds from below like this
wasn't intentional? Though it does seem to be how BFD's default linker
scripts lay it out.

> 
> Regardless, this patch is attempting to fix the problem where bfd and lld
> lay out the orphans differently (as mentioned above, lld seems to sort
> them in a way that is not strictly appended, and bfd seems to sort them
> strictly appended). In the case of being appended to the .text output
> section, this would cause boot failures due to _etext not covering the
> resulting sections (which this[1] also encountered and fixed to be more
> robust for such appended collection -- that series actually _depends_ on
> orphan handling doing the appending, because there is no current way
> to map wildcard input sections to their own separate output sections).
> 
> > change and should be mentioned in the commit message.
> > 
> > However, the history of their being together comes from
> > 
> >   9bebe9e5b0f3 ("kbuild: Fix .text.unlikely placement")
> > 
> > which seems to indicate there was some problem with having them separated out,
> > although I don't quite understand what the issue was from the commit message.
> 
> Looking at this again, I actually wonder if we have bigger issues here
> with dead code elimination:
> 
> #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
> ...
> 
> that would catch: .text.hot .text.fixup .text.unlikely and .text.unknown
> but not .text.hot.*, etc (i.e. the third dot isn't matched, which is,
> I assume, why Clang switched to adding a trailing dot). However, this
> patch lists .text.hot .text.hot.* first, so they'd get pulled to the
> front correctly, but the trailing ones (with 2 dots) would not, since
> they'd match the TEXT_MAIN wildcard first. (This problem actually existed
> before this patch too, and is not the fault of 9bebe9e5b0f3, but rather
> the addition of TEXT_MAIN, which could potentially match .text.unlikely
> and .text.fixup)

The existing comment on TEXT_TEXT mentions that issue. However, note
that the dead code stuff is only available currently on mips and ppc,
and is hidden behind EXPERT for those, so I'm not sure if anyone
actually uses it.

9bebe9e5b0f3 predates LD_DEAD_CODE_DATA_ELIMINATION, and there were no
wildcards I can see in .text at the time, which is why I don't
understand what problem is referred to in the commit message.

Btw, for the FGKASLR stuff, instead of keeping the output sections per
function, couldn't you generate a table of functions with sizes, and use
that when randomizing the order? Then the sections themselves could be
collected into .text explicitly.
