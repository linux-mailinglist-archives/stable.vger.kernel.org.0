Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39FE1C0B58
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgEAArq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAArq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 20:47:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADB2C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:47:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id s3so6304354eji.6
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sRFJfZwHnsJQqFJepe+LvPqS40H3J51FnSnbFsYaAJM=;
        b=AvUgqN7PB/2m6j6r3ChFqht9nBGFMbV8AKa9u30SyVlVrTUy+Tv1TOIg+df2atuDm9
         mrQr9/kg7XzvTBlUGO0QByBQRaSsjKRXNdddPP7Y9Z8zjn9Nh1TKQSTFhhdcbHFIGZAm
         23fUYndzjvvhniZu8dhlkJL4EDHoYqfSv1iW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sRFJfZwHnsJQqFJepe+LvPqS40H3J51FnSnbFsYaAJM=;
        b=kIMe1GBDJd29bucskhG36s+Hj4PpKoDIT7bc8Cs9H7t2uRT374zsFJzGQlJqUtUMQ9
         yAqQyUV7/cJJAgcc5t46gWUlrydtsrUoNAbFUQYEOJQZ0T6Qb6WwGZmcfsj+jmzH4i0Z
         L3pD5KKhDwCLz37JgYoQXEywcPFvUYFjhn3QpuJfq95ugDA7sbqpSLlEvRzHo2KtNmo+
         YsdITqKrVa7YyeLK/p+40jV5+WhuR6CIvPnBr82pYjTmpcMU8jFu7flxEB+RXSI+wSKx
         0l/nboFwzWWIIIeSZDgPVVxyPNYMk10jmKwtmaG3628UKg7dmNIjrKbk4+/4b1Tpr+qR
         qV1Q==
X-Gm-Message-State: AGi0PuZUN3d0lluCoYM70xHoFqMMuBmpQ/9rFUszJoc7tO0vqD1nGXJZ
        OYjFFI605DMuhCKO8WtSIt35e0u/hOs=
X-Google-Smtp-Source: APiQypIPDufVRJHTTvFoOMkz3KZ3AcK3KnfboBHb3vBEkAPl63kkdTD+vK1Fcnx9JZkgxWhS76oObw==
X-Received: by 2002:a17:906:459:: with SMTP id e25mr1060264eja.379.1588294064230;
        Thu, 30 Apr 2020 17:47:44 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id f17sm64088edj.86.2020.04.30.17.47.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 17:47:43 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id n4so6271782ejs.11
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:47:43 -0700 (PDT)
X-Received: by 2002:a2e:814e:: with SMTP id t14mr886854ljg.204.1588293602471;
 Thu, 30 Apr 2020 17:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
In-Reply-To: <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Apr 2020 17:39:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeMRm_yhb_fwvmgdaPMYzgXY01cYvw5htHUCTwSzswqg@mail.gmail.com>
Message-ID: <CAHk-=wgeMRm_yhb_fwvmgdaPMYzgXY01cYvw5htHUCTwSzswqg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 5:23 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> > But anyway, I don't hate something like "copy_to_user_fallible()"
> > conceptually. The naming needs to be fixed, in that "user" can always
> > take a fault, so it's the _source_ that can fault, not the "user"
> > part.
>
> I don=E2=80=99t like this.  =E2=80=9Cuser=E2=80=9D already implied that b=
asically anything can be wrong with the memory

Maybe I didn't explain.

"user" already implies faulting. We agree.

And since we by definition cannot know what the user has mapped into
user space, *every* normal copy_to_user() has to be able to handle
whatever faults that throws at us.

The reason I dislike "copy_to_user_fallible()" is that the user side
already has that 'fallible".

If it's the _source_ being "fallible" (it really needs a better name -
I will not call it just "f") then it should be "copy_f_to_user()".

That would be ok.

So "copy_f_to_user()" makes sense. But "copy_to_user_f()" does not.
That puts the "f" on the "user", which we already know can fault.

See what I want in the name? I want the name to say which side can
cause problems!

If you are copying memory from some f source, it must not be
"copy_safe()". That doesn't say if the _source_ is f, or the
destination is f.

So "copy_to_f()" makes sense (we don't say "copy_kernel_to_user()" -
the "normal" case is silent), and "copy_from_f()" makes sense.
"copy_in_f()" makes sense too.

But not this "randomly copy some randomly f memory area that I don't
know if it's the source or the destination".

Sometimes you may then use a common implementation for the different
directions - if that works on the architecture.

For example, "copy_to_user()" and "copy_from_user()" on x86 both end
up internally using a shared "copy_user_generic()" implementation. I
wish that wasn't the case (when I asked for what was to become
STAC/CLAC, I asked for one that could determine which direction of a
"rep movs" could touch user space), but it so happens that the
implementations end up being symmetric on x86.

But that's a pure implementation issue, and it very much is not going
to be true in general, and it shouldn't be exposed to users as such
(and we obviously don't).

                Linus
