Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0127B1C0BA4
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 03:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgEABV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 21:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727930AbgEABV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 21:21:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4322C035495
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 18:21:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n4so6329579ejs.11
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 18:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0WHCfo12YFpkzc0szZ4Nv4Cwf1R5n0LiGAEBC0vARlw=;
        b=yLLLX3viV91kRFnykTAmBX8/5/pV6R27FltG65l2TDagTsPDSGz0hnqsuiTtmmlAZC
         T7eMYnabMcjoM9b9+sOZm4k7ymz3ikjxcOWCmcmT7j9T9PzO4ab6W+GOE95LDhp0kEsA
         77kE+oEsT6+LW2x1Qf01SZ20BZPRymB9BXeLm3tFR5wJ7NIpO57OcczL5SBSTIV8zoKK
         NWWAgQbcI/cfAp5YcMwQUyTUyEWsWWUvv+Ob/7DBrsvfJtYEF+x/GuS4o7f1F8r0kAWR
         BfhXeDBLH2kZL4oCWmAndG4IAUZZLIMyU6zgrPtL2CaIeC4bwKh5ja1WIRC7CDl7k0wK
         YGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0WHCfo12YFpkzc0szZ4Nv4Cwf1R5n0LiGAEBC0vARlw=;
        b=GguciHtuRcJpEhVpzSHRJnExr2mQUPkAZ0n6+baJTtTJZU7P3/WqNtQMq5n7pBmrGM
         9Hj3IXwzm1HsdaGmh1XkAmQ0Vt6c/fg9hrw8OXIFBUV2r2ErX6zIGXkIzXSRghT2vDCe
         XJu+RD6dXBNAMHC2/vLArA/DNAu3c0QJaGIfYGEbyokunrwVfhU6z2FrCEgEqVIuc9Mr
         NN4Njbs+5BqedIbS2WyXYwgA+x9IKGwc/T9UZgmr00yf1iShsoIutYktYyePGlZUOajY
         wjLe4zafJT3QnrOqxXjVe0+4c4SVfJlBxEp+XcHaNYA/aJnfgzY79QWwXnl2RaIJiBB8
         zJ1g==
X-Gm-Message-State: AGi0PuaOIpkOUyE/sV2UFt8+PE3ROvSbiVianl+D6B06Jlhw8i39Wnd4
        c910TGo2YUVNcOb84xOisdJUVcZ/opXebM2WU4e3HA==
X-Google-Smtp-Source: APiQypLgIGV3KJNUB6kjEzDIy/JL7FfpU+mSWrRsGSBvx0nOD2CIZhVhWdGJEosw343TeMYtWuG1EJ2evwMQ7pvhb6k=
X-Received: by 2002:a17:906:7750:: with SMTP id o16mr1196548ejn.12.1588296116582;
 Thu, 30 Apr 2020 18:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com> <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
 <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com> <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
In-Reply-To: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 30 Apr 2020 18:21:45 -0700
Message-ID: <CAPcyv4jvgCGU700x_U6EKyGsHwQBoPkJUF+6gP4YDPupjdViyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
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
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 5:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 30, 2020 at 4:52 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > You had me until here. Up to this point I was grokking that Andy's
> > "_fallible" suggestion does help explain better than "_safe", because
> > the copy is doing extra safety checks. copy_to_user() and
> > copy_to_user_fallible() mean *something* where copy_to_user_safe()
> > does not.
>
> It's a horrible word, btw. The word doesn't actually mean what Andy
> means it to mean. "fallible" means "can make mistakes", not "can
> fault".
>
> So "fallible" is a horrible name.
>
> But anyway, I don't hate something like "copy_to_user_fallible()"
> conceptually. The naming needs to be fixed, in that "user" can always
> take a fault, so it's the _source_ that can fault, not the "user"
> part.
>
> It was the "copy_safe()" model that I find unacceptable, that uses
> _one_ name for what is at the very least *four* different operations:
>
>  - copy from faulting memory to user
>
>  - copy from faulting memory to kernel
>
>  - copy from kernel to faulting memory
>
>  - copy within faulting memory
>
> No way can you do that with one single function. A kernel address and
> a user address may literally have the exact same bit representation.
> So the user vs kernel distinction _has_ to be in the name.
>
> The "kernel vs faulting" doesn't necessarily have to be there from an
> implementation standpoint, but it *should* be there, because
>
>  - it might affect implemmentation
>
>  - but even if it DOESN'T affect implementation, it should be separate
> just from the standpoint of being self-documenting code.
>
> > However you lose me on this "broken nvdimm semantics" contention.
> > There is nothing nvdimm-hardware specific about the copy_safe()
> > implementation, zero, nada, nothing new to the error model that DRAM
> > did not also inflict on the Linux implementation.
>
> Ok, so good. Let's kill this all, and just use memcpy(), and copy_to_user().
>
> Just make sure that the nvdimm code doesn't use invalid kernel
> addresses or other broken poisoning.
>
> Problem solved.
>
> You can't have it both ways. Either memcpy just works, or it doesn't.

It doesn't, but copy_to_user() is frustratingly close and you can see
in the patch that I went ahead and used copy_user_generic() to
implement the backend of the default "fast" implementation.

However now I see that copy_user_generic() works for the wrong reason.
It works because the exception on the source address due to poison
looks no different than a write fault on the user address to the
caller, it's still just a short copy. So it makes copy_to_user() work
for the wrong reason relative to the name.

How about, following your suggestion, introduce copy_mc_to_user() (can
just use copy_user_generic() internally) and copy_mc_to_kernel() for
the other the helpers that the copy_to_iter() implementation needs?
That makes it clear that no mmu-faults are expected on reads, only
exceptions, and no protection-faults are expected at all for
copy_mc_to_kernel() even if it happens to accidentally handle it.
Following Jann's ex_handler_uaccess() example I could arrange for
copy_mc_to_kernel() to use a new _ASM_EXTABLE_MC() to validate that
the only type of exception meant to be handled is MC and warn
otherwise?
