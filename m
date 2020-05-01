Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C911C0B2F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEAAKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgEAAKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 20:10:39 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2B3C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:10:36 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id l19so1225871lje.10
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IoAo79puf2fO2mxYjsnwa0bT+GJNCk2Wz2oE7jO1rZ0=;
        b=ai0nRHdnq5PKYZRE4Z2psZB8iAlRJQyyqODMZ0nZ/DvoxHUsUwQzU8YQzu1X4Wx3LB
         JBOdF8w1/Rq47Fp1oFb/63W9FrWFZJqfsOg0ikYPduy2VqtDflbRRqwIgmsAZQVQN8mO
         q9iAMISU0a7Og9lwvy9aWj32014T1C4JkTWFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IoAo79puf2fO2mxYjsnwa0bT+GJNCk2Wz2oE7jO1rZ0=;
        b=GQgIfjTsaLn/fokyg+6zBjr4Zi01COvr0rFxUO12AV5cClhG9Wj1x/WWkYgC34+AeL
         kkepGkPlJjL78e+eBBv+xYgkDkcTL68xd7J4daVJXdY/Exd4QHznx3SQVxBNOWOo/vw8
         r+p50KXkGnHcTcm7F2rHZgiy5WT3s/B5EKxlr06bI/1VoIflKxqngzS4ELCbwdhmwvLd
         qMbTAHZtKZOUH04GJwW5LE1hZDQ5dA8Ucz8SRa/zxWC4MFP4g08LW0dEu/c4Yn5Glind
         l2TOCi5Z340CNTd/3JP25g4+pON75X3sldbVDC33ZFNTnDeIdM6Fyo3GdB3WHDgMKtw7
         8VoA==
X-Gm-Message-State: AGi0PuaVzbRJcd5a95xE+QmOy1Sqn+ZySpNnh++LdKztPkIW3b0yjn78
        Z6f6CGABeO9Vb+2DeAJu8lPFLV0ojI8=
X-Google-Smtp-Source: APiQypLLLpMQZhru4fwQpFGSyCtVtJ30Vfk38Cot5pwufLzZjrdfln8Vi9z5A+OYGrxJ/yP9oqdYMw==
X-Received: by 2002:a2e:b0f5:: with SMTP id h21mr857597ljl.3.1588291833705;
        Thu, 30 Apr 2020 17:10:33 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id x25sm189757lfq.74.2020.04.30.17.10.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 17:10:32 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id y4so1246990ljn.7
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:10:31 -0700 (PDT)
X-Received: by 2002:a2e:3017:: with SMTP id w23mr887763ljw.150.1588291831360;
 Thu, 30 Apr 2020 17:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com> <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
 <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com>
In-Reply-To: <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Apr 2020 17:10:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
Message-ID: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Dan Williams <dan.j.williams@intel.com>
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

On Thu, Apr 30, 2020 at 4:52 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> You had me until here. Up to this point I was grokking that Andy's
> "_fallible" suggestion does help explain better than "_safe", because
> the copy is doing extra safety checks. copy_to_user() and
> copy_to_user_fallible() mean *something* where copy_to_user_safe()
> does not.

It's a horrible word, btw. The word doesn't actually mean what Andy
means it to mean. "fallible" means "can make mistakes", not "can
fault".

So "fallible" is a horrible name.

But anyway, I don't hate something like "copy_to_user_fallible()"
conceptually. The naming needs to be fixed, in that "user" can always
take a fault, so it's the _source_ that can fault, not the "user"
part.

It was the "copy_safe()" model that I find unacceptable, that uses
_one_ name for what is at the very least *four* different operations:

 - copy from faulting memory to user

 - copy from faulting memory to kernel

 - copy from kernel to faulting memory

 - copy within faulting memory

No way can you do that with one single function. A kernel address and
a user address may literally have the exact same bit representation.
So the user vs kernel distinction _has_ to be in the name.

The "kernel vs faulting" doesn't necessarily have to be there from an
implementation standpoint, but it *should* be there, because

 - it might affect implemmentation

 - but even if it DOESN'T affect implementation, it should be separate
just from the standpoint of being self-documenting code.

> However you lose me on this "broken nvdimm semantics" contention.
> There is nothing nvdimm-hardware specific about the copy_safe()
> implementation, zero, nada, nothing new to the error model that DRAM
> did not also inflict on the Linux implementation.

Ok, so good. Let's kill this all, and just use memcpy(), and copy_to_user().

Just make sure that the nvdimm code doesn't use invalid kernel
addresses or other broken poisoning.

Problem solved.

You can't have it both ways. Either memcpy just works, or it doesn't.

So which way is it?

                  Linus
