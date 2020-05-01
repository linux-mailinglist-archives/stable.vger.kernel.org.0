Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE881C1D2E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 20:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgEAS25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 14:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729767AbgEAS24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 14:28:56 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56279C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 11:28:56 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a21so3382141ljb.9
        for <stable@vger.kernel.org>; Fri, 01 May 2020 11:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rg73oT2i7CN6P9GKzkav2692ScwMvCV8w1kfBm2rvpc=;
        b=DBxmwg4XXi8IArR4p+XyseptF37LsJFDYGKqn4Fej360l2/VSOaUYBVFHiPhk/xhQ8
         s6lROshASV7jHjtWyNPvqjhgrgkaFVzegagn8zAtbWr/xDt6AORujuznySe6OYHZ6Vgb
         o4yy070krugoANDoZtUamLdr0Ij+rfCPnRdZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rg73oT2i7CN6P9GKzkav2692ScwMvCV8w1kfBm2rvpc=;
        b=mxI5KEzUZibbROycJo0qX2jNjQeyhQZsglVHpGsIgo64ERQK1zXJmJ+ZWRNX7yz22x
         dX3AR1+rIiRyshnvC+QXov4p2XLaKM1WhqQtGxXJiOYZ389++bbIiZM2UJDgAOFMSGAZ
         SJmJjHJkqbTgkV3++CXub8OEz9QSv4qQ7XkAKbntJrFxxax7HmgLbK35CqkKPAU1bXWG
         Czrq0jfYnao0+ofcTp8g0VnFTKqa8vv5YisW1/MYAN3rhhzaHxQfzuB0Uyf4r3D6SMfJ
         WebTfvFOxX5b1EfokQYGeanegBRy/wkrnpiyahC8vLGfyYCqkdK+f8h1+uxRH6ioGYsX
         NNDw==
X-Gm-Message-State: AGi0Pubb2d7bv8P1LBDLwvcnRpAJr16wEHkf6+a+AxWyPSJ0Yfm60f0L
        sCQ2KTIpLRgyf9hAlg+8pQ3kriNK6CA=
X-Google-Smtp-Source: APiQypKnl9Jjja+OXmzrYD4mg5u7K2nJVRDeyXYIbLb0g43a6FlGQydYbxfTEvmdsSBdJWt2WoJXLA==
X-Received: by 2002:a2e:7e04:: with SMTP id z4mr3186387ljc.50.1588357733762;
        Fri, 01 May 2020 11:28:53 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id j23sm2691801lfh.65.2020.05.01.11.28.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 11:28:52 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id a21so3382010ljb.9
        for <stable@vger.kernel.org>; Fri, 01 May 2020 11:28:51 -0700 (PDT)
X-Received: by 2002:a2e:7308:: with SMTP id o8mr3129793ljc.16.1588357731518;
 Fri, 01 May 2020 11:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com> <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
 <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com>
 <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com> <CAPcyv4jvgCGU700x_U6EKyGsHwQBoPkJUF+6gP4YDPupjdViyQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jvgCGU700x_U6EKyGsHwQBoPkJUF+6gP4YDPupjdViyQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 1 May 2020 11:28:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiPkwF2+y6wZd=VD9BooKxHRWhSVW8dr+WSeeSPkJk7kQ@mail.gmail.com>
Message-ID: <CAHk-=wiPkwF2+y6wZd=VD9BooKxHRWhSVW8dr+WSeeSPkJk7kQ@mail.gmail.com>
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

On Thu, Apr 30, 2020 at 6:21 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> However now I see that copy_user_generic() works for the wrong reason.
> It works because the exception on the source address due to poison
> looks no different than a write fault on the user address to the
> caller, it's still just a short copy. So it makes copy_to_user() work
> for the wrong reason relative to the name.

Right.

And it won't work that way on other architectures. On x86, we have a
generic function that can take faults on either side, and we use it
for both cases (and for the "in_user" case too), but that's an
artifact of the architecture oddity.

In fact, it's probably wrong even on x86 - because it can hide bugs -
but writing those things is painful enough that everybody prefers
having just one function.

That's particularly true since that "one function" is actually a whole
family of functions - just for different optimizations.

Plus on x86 you can't reasonably even have different code sequences
for that case, because CLAC/STAC don't have a "enable users read
accesses" vs "write accesses" case. It's an all-or-nothing "enable
user faults".

We _used_ to have a difference on x86, back when we did the whole "fs
segment points to user space".

But on other architectures, there really is a difference between
"copy_to_user()" and "copy_from_user()", and the functions won't do
fault handling for the kernel side accesses.

> How about, following your suggestion, introduce copy_mc_to_user() (can
> just use copy_user_generic() internally) and copy_mc_to_kernel() for
> the other the helpers that the copy_to_iter() implementation needs?

Yes. That at least solves my naming worries, and is conceptually
something that works on other architectures.

Those other architectures may not have nvdimm support yet, but I think
everybody is at least looking at it.

And I really do think it will make the users more readable too, when
you see on a source level that "oh, this code is expecting that it
could take a poison fault/machine check on the source/destination".

> Following Jann's ex_handler_uaccess() example I could arrange for
> copy_mc_to_kernel() to use a new _ASM_EXTABLE_MC() to validate that
> the only type of exception meant to be handled is MC and warn
> otherwise?

That may be a good idea, but won't work for any shared case.

IOW, it would be lovely to have a "copy_mc_to_user()" check that if
it's a write fault, it's because it's a user address (and if it's a
read fault it's because it's a poisoned page or mc or whatever, but a
valid kernel address).

But it's exactly the kind of thing that we currently don't do even for
the bog-standard "copy_to_user()", because we share all the code
because we're lazy.

And as DavidL pointed out - if you ever have "iomem" as a source or
destination, you need yet another case. Not because they can take
another kind of fault (although on some platforms you have the machine
checks for that too), but because they have *very* different
performance profiles (and the ERMS "rep movsb" sucks baby donkeys
through a straw).

              Linus
