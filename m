Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CDD1C0B40
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEAAZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgEAAZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 20:25:12 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6855C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:25:10 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id g10so2753593lfj.13
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDf2N8mBL2qJb74S4ITCK9fAPPmUAgvoerWrh8dXt4o=;
        b=MreruorxVqBBm3pLqSig9B5BAdyGIXSOxD6BJt2oKVTHUb1/8Whm8gIpcX16l58lSv
         QPNB29r7LEHIVU4GCCsv3CKa2gCOu0ExTOuE3vO1blHXWjouvTt8wvZBkUIdShaFwHPi
         GYDLjgWlY3m6y8KprJDmZNXjTI5GXeXGOTUNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDf2N8mBL2qJb74S4ITCK9fAPPmUAgvoerWrh8dXt4o=;
        b=n9EcDatGXQpmrq8aadCstTqIACKNkl2h9Jq8J0hG5fzP6Y7Vu2o7BBsmFNSubX2BU4
         6MSV12BsJcvVoY8921W40zigYx6pkEy8Imu+n2ouWqHAtP/DVA6tZMs+JBz4QAnAFKFA
         ehVOALQExJDtA+2E8IIQMZ5zxGwLTkx5aDoUlDFJx++YZ/lq793byExKXu53so65wVbb
         93NtWBIC2K/Fi3pUKXSTM6gI4uiiyVLx7vADU4J9T1JNnjaYO/AA2UleuoVXFpVa0pCo
         WWa8aFxuYoixwvtXbfi/om8flz4L4lbBDuFHSh2/FxlboO3h2F7eCxzSLVinvPUBQido
         uRnQ==
X-Gm-Message-State: AGi0PuZl6/MfMsFELbS/ASD58K8aRlSVZYU6SIu4fATKzr7i/4voF9F3
        CEzYEmWEBK0uxBOFkVuDKTEkc3tcwok=
X-Google-Smtp-Source: APiQypJITk8eQRseYglAhqrHIt978jPYSUJb1cY7scWfBE/8117JN6+jQuOUcszL9d/73QwoZZLgvg==
X-Received: by 2002:a05:6512:44d:: with SMTP id y13mr493291lfk.118.1588292707990;
        Thu, 30 Apr 2020 17:25:07 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id j15sm1090386lji.18.2020.04.30.17.25.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 17:25:06 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id t11so2776390lfe.4
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:25:06 -0700 (PDT)
X-Received: by 2002:ac2:4da1:: with SMTP id h1mr783565lfe.152.1588292705876;
 Thu, 30 Apr 2020 17:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com> <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
 <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com> <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
In-Reply-To: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 30 Apr 2020 17:24:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1SPyuGkTkQESsacwKTpjWd=_-KwoCK5o=SuC3yMdf7A@mail.gmail.com>
Message-ID: <CAHk-=wh1SPyuGkTkQESsacwKTpjWd=_-KwoCK5o=SuC3yMdf7A@mail.gmail.com>
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

On Thu, Apr 30, 2020 at 5:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It's a horrible word, btw. The word doesn't actually mean what Andy
> means it to mean. "fallible" means "can make mistakes", not "can
> fault".

Btw, on naming: the name should be about _why_ it can fault, not about
whether it faults.

Which hasn't been explained to me.

I know why user accesses can fault. I still don't know why these new
accesses can fault. I know of the old name (mcs), but the newly
suggested name (safe) is the _opposite_ of an explanation of why it
faults.

Naming - like comments - shouldn't be about what some implementation
is, but about the concept.

Again, let me use that "copy_to_user()" as an example of this. Yes, it
can fault. Notice how the name doesn't say "copy_to_faulting()". That
would be WRONG. It can fault _because_ it is user memory, so
"copy_to_user()" not only describes what it does, but it also
implicitly describes that it can fault.

THAT is the kind of explanation I'm looking for. The "memcpy_mcsafe()"
at least had _some_ of that in it. It was wrong for all the _other_
reasons (not having a direction, and the hardware just being complete
and utter garbage), but at least there was a reason in the name.

I am not interested in adding new infrastructure that cannot even be
explained. Why would writes ever fault, considering they are posted
(and again, "user space" is not a valid reason, we have that case
already and have had it since day #1 even if the original naming was
the same kind of bad implementation-specific name that "mcsafe" was).

If the ONLY reason for the fault is a machine check, then the name
should say so, and "copy_mc_to_user()" would be a perfectly fine name
(along with copy_to_mc(), copy_from_mc(), and copy_in_mc()).

It wasn't clear how "copy_to_mc()" could ever fault. Poisoning
after-the-fact? Why would that be preferable to just mapping a dummy
page? But even if it cannot fault, I can see that you might want to do
it as a special kind of copy to avoid any read-mask-write artifacts
(which can definitely happen on other architectures, and I could see a
manual memcpy() implementation doing even on x86)

                  Linus
