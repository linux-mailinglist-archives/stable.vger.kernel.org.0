Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD01C03AE
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgD3RRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 13:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbgD3RRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 13:17:39 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E404C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 10:17:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u10so1870181lfo.8
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 10:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AbtaQ1Pr8o8wY3oZ0XUT+6r9NQjFUKQ2iX6lszWerYA=;
        b=hvyYWSqj2/fPEY1WvRlxpzG6+BEmdG53Q6FGr0rmFjqrtn6k+h40SEBcbuDXCqxUgu
         oQj9pLhUMMsLzXOxx5yIsXnoxM5edRADMw3Nok9hHdGYJi9aZqee4YhpZbofCd09La3i
         YD/BYT0Ja4/85/lTKRMWx/UXUjWBdf/VeXqqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbtaQ1Pr8o8wY3oZ0XUT+6r9NQjFUKQ2iX6lszWerYA=;
        b=icX+e9ulPjEAGTugMmlE1QjSWBo7k7iug/RwDuiF6zKn6XuoadelfPpNdaOOtrIeeD
         Y0AHEM1bPWJ2qYonSO4kswhIlLBt8WEx3rnuwM4AHZhBlxNxF1fDkraZwEwcJNSw9u2b
         O9/LjKGYJshzOTigrAv2hx9aOz9OFM2Mpn5UtfMwQ/JPLmeLtqwmFp6csYzquttwJtj6
         4x41y014S1Xv6NpJlImK9eCQhRBuEybMEBU379KuGqFGwGB2eo6UqZxr4PwYStoD6c6i
         bR/vn1l6p0ZZEMKqXxOpuVleuBeEyvMlOAubsICo6rb7F3cd6/7SJJ+NLfpOFVvSGqT5
         77hw==
X-Gm-Message-State: AGi0PuYBFII3l9iQD33+VA7mATetd0qffLhMvs+L6f99t+SfcuwORJsy
        +JRPQ9/NUQlqV4jS6MqzcXEj6RCiZ2c=
X-Google-Smtp-Source: APiQypLb+ckUSAPAneBd6vmvxKrY4eAbwzEXaFJ7+pCdovtVbTfbDniEOoSv1V5ogU4TujbK408IEw==
X-Received: by 2002:ac2:4105:: with SMTP id b5mr2938775lfi.94.1588267057139;
        Thu, 30 Apr 2020 10:17:37 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id 4sm220960ljf.79.2020.04.30.10.17.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 10:17:36 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id u15so174602ljd.3
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 10:17:35 -0700 (PDT)
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr167004ljp.209.1588267055471;
 Thu, 30 Apr 2020 10:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com> <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
In-Reply-To: <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Apr 2020 10:17:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
Message-ID: <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 9:52 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> If I'm going to copy from memory that might be bad but is at least a
> valid pointer, I want a function to do this.  If I'm going to copy
> from memory that might be entirely bogus, that's a different
> operation.  In other words, if I'm writing e.g. filesystem that is
> touching get_user_pages()'d persistent memory, I don't want to panic
> if the memory fails, but I do want at least a very loud warning if I
> follow a wild pointer.
>
> So I think that probe_kernel_copy() is not a valid replacement for
> memcpy_mcsafe().

Fair enough.

That said, the part I do like about probe_kernel_read/write() is that
it does indicate which part we think is possibly the one that needs
more care.

Sure, it _might_ be both sides, but honestly, that's likely the much
less common case. Kind of like "copy_{to,from}_user()" vs
"copy_in_user()".

Yes, the "copy_in_user()" case exists, but it's the odd and unusual case.

Looking at the existing cases of "memcpy_mcsafe()", they do seem to
generally have a very clearly defined direction, not "both sides can
break".

I also find myself suspecting that one case people _do_ want to
possibly do is to copy from nvdimm memory into user space. So then
that needs yet another function.

And we have that copy_to_user_mcsafe() for that, and used in the
disgustingly named "copyout_mcsafe()". Ugly incomprehensible BSD'ism.

But oddly we don't have the "from_user" case.

So this thing seems messy, the naming is odd and inconsistent, and I'd
really like the whole "access with exception handling" to have some
clear rules and clear names.

The whole "there are fifty different special cases" really drives me
wild. It's why I think the hardware was so broken.

And now the special "writes can fault" rule still confuses me.
_copy_to_iter_mcsafe() was mentioned, which makes me think that it's
literally about that "copy from nvram to user space" issue.

But that can't just trap on the destination, that fundamentally needs
special user space accesses anyway. Even on x86 you have the whole
STAC/CLAC issue, on other architectures the stores may not be normal
stores at all.

So a "copy_safe()" model doesn't actually work for that at all.

So I'm a bit (maybe a _lot_) confused about what the semantics should
actually be. And I want the naming to reflect whatever those semantics
are. And I don't think "copy_safe()" reflects any semantics at all.

                     Linus
