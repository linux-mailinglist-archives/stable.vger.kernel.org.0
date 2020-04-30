Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFCD1C0B1F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 01:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD3Xwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 19:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgD3Xwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 19:52:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EB9C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 16:52:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rh22so6182903ejb.12
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 16:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7MF1/Pddp4dhGKH9x4iKD8rjSjk+ZGQHnl4uXbC/+TA=;
        b=dPpcYEEkvq8ZWM/jSsBIAi3UKaYNI1WVWBVTLYMB2LGGdKZ7j4RiDwdbaThqfngPt2
         dY1VoMJ9o5v7csTLFC8UtnvbuZxmV7ZbXj9f8OdGd7h9jWnxiWetKuCoTCAtbTvwZhbV
         pn1KZl9QshPTNiecbjqpjGR8CzuoM9vPC7Qq74tfH8Ae0qpGpm6jdonNhrImgbrFxXah
         ZqfKIn1872Ne7dc9wTwgp7qk6Nf2NfnUMT6Lg05YH2iKhVhygSE6vJka0ZvpXBGQiUcW
         VmBU7vvo9gweFcrn6hy6RNAZXeCdtc1fJNXBQSThyT4VY2FiLezyerj384lGD2jBMVSM
         8TFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7MF1/Pddp4dhGKH9x4iKD8rjSjk+ZGQHnl4uXbC/+TA=;
        b=I/kZ994gX29FS2FuDxChrVREzAhyl1diA4aTv/K+KIgwVzA9zC+LEh9nuR4uPQ5mVz
         1rS4l+wTAYfxe/Kpv1MIhFF5WRMLe4TVUDRdE+/AK1AOvh+JK8jRI1sPdbOKpcyt7qvL
         t8AL8lXT/R9jr9GTHAxFVMG0N/dEHJh3j1XqnHVUNT9anF3fABoIvLeZUMqkT5cdWeg3
         AVPNYutgSE4Bvcxd1fC6ofOMBU941qy0AKou1NncGJ51F9iLZL6ERz5hVM15nqwiJOQG
         hkHDrdwAICeD2PXTuX6h8mQWJI6IFhfBhMho2b1E3kysNmweVsPjosV10DkB6GVD4w76
         Xm0g==
X-Gm-Message-State: AGi0PuYCR4SM29fIUQYnmgGYu5z8JNCCoaYxPDFrDUN3TJ+hITcAQPj2
        lA/uP49XE3I6j+Z9v8Z86/mf7kg/6Gatpm7me+4e1w==
X-Google-Smtp-Source: APiQypLO66YIc/Con8fdxtL40NZbJdw0s6bJpco1r1TZnc7dlxOTtje3aF1//kP+vs6YBpm/gW7AA85QUe0mSrFqIko=
X-Received: by 2002:a17:906:90cc:: with SMTP id v12mr892682ejw.211.1588290754110;
 Thu, 30 Apr 2020 16:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
 <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com> <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
In-Reply-To: <CAHk-=wg0Sza8uzQHzJbdt7FFc7bRK+o1BB=VBUGrQEvVv6+23w@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 30 Apr 2020 16:52:22 -0700
Message-ID: <CAPcyv4g0a406X9-=NATJZ9QqObim9Phdkb_WmmhsT9zvXsGSpw@mail.gmail.com>
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

On Thu, Apr 30, 2020 at 12:56 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 30, 2020 at 12:23 PM Luck, Tony <tony.luck@intel.com> wrote:
> >
> > How about
> >
> >         try_copy_catch(void *dst, void *src, size_t count, int *fault)
> >
> > returns number of bytes not-copied (like copy_to_user etc).
> >
> > if return is not zero, "fault" tells you what type of fault
> > cause the early stop (#PF, #MC).
>
> That just makes things worse.
>
> The problem isn't "what fault did I get?".
>
> The problem is "what is the point of this function?".
>
> In other words, I want the code to explain _why_ it uses a particular function.
>
> So the question the function should answer is not "Why did it take a
> fault?", but "Why isn't this just a 'memcpy()'"?
>
> When somebody writes
>
>     x = copy_to_user(a,b,c);
>
> the "why is it not a memcpy" question never comes up, because the code
> is obvious. It's not a memory copy, because it's copying to user
> space, and user space is different!
>
> In contrast, if you write
>
>     x = copy_safe(a,b,c);
>
> then what is going on? There is no rhyme or reason to the call. Is the
> source unsafe? Wny? Is the destination faulting? Why? Both? How?
>
> So "copy_to_user()" _answers_ a question. But "copy_safe()" just
> results in more questions. See the difference?
>
> And notice that the "why did it fault" question is NOT about your
> "what kind of fault did it take" question. That question is generally
> pretty much uninteresting.
>
> The question I want answered is "why is this function being called AT ALL".
>
> Again, "copy_to_user()" can fail, and we know to check failure cases.
> But more importantly, the _reason_ it can fail is obvious from the
> name and from the use. There's no confusion about "why".
>
> "copy_safe()"? or "try_copy_catch()"? No such thing. It doesn't answer
> that fundamental "why" question.
>
> And yes, this also has practical consequences. If you know that the
> failure is due to the source being some special memory (and if we care
> about the MC case with unaligned accesses), then the function in
> question should probably strive to make those _source_ accesses be the
> aligned ones.  But if it's the destination that is special memory,
> then it's the writes to the destination that should be aligned. If you
> need both, you may need to be either mutually aligned, or do byte
> accesses, or do special shifting copies. So it matters for any initial
> alignment code (if the thing has alignment issues to begin with).
>
> I haven't even gotten an answer to the "why would the write fail".
> When I asked, Dan said
>
>  "writes can mmu-fault now that memcpy_mcsafe() is also used by
> _copy_to_iter_mcsafe()"
>
> but as mentioned, the only reason I can find for _that_ is that the
> destination is user space.
>
> In which case a "copy_safe()" absolutely could never work.
>
> If I can't figure out the "why is this function used" or even figure
> out why it needs the semantics it claims it needs, then there's a
> problem.
>
> Personally, I suspect that the *easiest* way to support the broken
> nvdimm semantics is to not have a "copy" function at all as the basic
> accessor model.

You had me until here. Up to this point I was grokking that Andy's
"_fallible" suggestion does help explain better than "_safe", because
the copy is doing extra safety checks. copy_to_user() and
copy_to_user_fallible() mean *something* where copy_to_user_safe()
does not.

However you lose me on this "broken nvdimm semantics" contention.
There is nothing nvdimm-hardware specific about the copy_safe()
implementation, zero, nada, nothing new to the error model that DRAM
did not also inflict on the Linux implementation.

This is about Linux treating memory as a disk and performing bulk
transfers with the CPU instead of a DMA engine. Whereas existing
memory error handling has a high chance for it to trigger on userspace
accesses, large copies in kernel mode now have a higher chance of
tripping over the same errors in kernel space. Since there is an error
model overlaid on top of the block-I/O, software is well prepared to
handle the short transfer case.

> Why? Exactly because "copy" is not a fundamental well-defined action.
> You get nasty combinatorial explosions of different things, where you
> have three different kinds of sources (user, RAM, nvdimm) and three
> different kinds of destinations.

True, copy is not a fundamentally well defined operation. It's
unfortunate that the low-level of a direct-I/O read(2) eventually
turns into a call to memcpy() inside a typical ramdisk driver. So
you're right, this isn't a copy routine as much as it's the backend of
read(2)/write(2) with short transfer semantics, but by the time it
gets to pmem driver it's been disconnected from its original intent
and all it sees is "move bytes from here to there if you can".

> And that's ignoring the whole "maybe you don't want to do a plain
> copy, maybe you want to calculate a RAID checksum, or do a 'strcpy()'
> or whatever". If those are ever issues, you get another explosion of
> combinations.
>
> The only *fundamental* access would likely be a single read/write
> operation, not a copy operation. Think "get_user()" instead of
> "copy_from_user()".  Even there you get combinatorial explosions with
> access sizes, but you can often generate those automatically or with
> simple patterns, and then you can build up the copy functions from
> that if you really need to.

The CPU overhead of synchronous bulk block-I/O transfers with the CPU
is already painful, a get_user() loop adds to that without a benefit
that I can currently perceive. The vast majority of driver actions and
DAX operations are in PAGE_SIZE units.
