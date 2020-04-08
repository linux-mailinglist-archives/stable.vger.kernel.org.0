Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459751A1B1D
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 06:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDHEsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 00:48:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38849 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgDHEsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 00:48:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so2086218plz.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 21:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=LNVg5m10VqZbbFRrPe9mpgbCJKEcA3bVJTN2uVjXg1E=;
        b=DKTO2RpQlW/8y03oge+NQ98bY6waLeTaENz6932XlNe9FxydKB3+Z0m17yGgmxM3rm
         VuRB+qGv3gdGsj23ps4sxEtIkrM/rAAVLP4nSWFvMZrHoGUPcvtA0PuK9Y8DZUMWwplg
         xi3prmGWa12I/OBkqqPIRSD6zgbPZX7Q9WZWZOyUrcCz76u+eVcNKi3C7N2pY8iGneZv
         +KUppHnpUaQZ10/pZqwHKM9I+vctjGbfAprZp6Zs7RXyjOEln7Dpx/bpVtIACdFF0ZNm
         rd/78Ye1uke7WDp4cTuhN2QodAgcM4fx0fKPcIWyalTTBdykT2uzH/v59Rpv0D5ZeM57
         Uitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=LNVg5m10VqZbbFRrPe9mpgbCJKEcA3bVJTN2uVjXg1E=;
        b=Tg3ni1zMcOhCm7fCJfu/y1/lST5Mn/FvrL+4H0KwwuWkbGZzIkPYmEDP03tqd11rAv
         6U5jMLYATK3apWKGR8oEzMN8P7/3MFJ+tEqJZau+Jv//+8WN9rAW7dR4Avjl2GQV2esb
         U/dcnqF5YSoY2N9H5N6ifzenkw91EdRAWu/tFHuyCDG8K7oltRB5MVAJYiy1JhiHHoJX
         B3Zqd+aeX3T+5Igq8aYhzkRNZyur3cm40zSSuZ24Y/aFb3aRZF2z4YgKR1t62cwQ1pbR
         OGvgmQ5JjxxS/Vc+2qQLk6igdCxwd0KYR0/EGCrRX85HgYeh5HnGtLrgKnioI44X4OHB
         2NPQ==
X-Gm-Message-State: AGi0PublerbXIrAF51MM7VwM73KRvwDTuBQxJLlyXzoBOYZU7YCx2xQ3
        Z9LVsf5/JMKVpk+it8HPRoW3Cw==
X-Google-Smtp-Source: APiQypIrYppvn1ChEtZU1SFpF+11GN6510TtJ/Gon8Z6n6h7NMI38x5WfZoT6nlIxTrs2tXk1gye2g==
X-Received: by 2002:a17:902:850a:: with SMTP id bj10mr5491258plb.28.1586321285510;
        Tue, 07 Apr 2020 21:48:05 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d169:f16:4607:98d6? ([2601:646:c200:1ef2:d169:f16:4607:98d6])
        by smtp.gmail.com with ESMTPSA id b2sm8116809pgg.77.2020.04.07.21.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 21:48:04 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Tue, 7 Apr 2020 21:48:02 -0700
Message-Id: <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
References: <877dyqkj3h.fsf@nanos.tec.linutronix.de>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
In-Reply-To: <877dyqkj3h.fsf@nanos.tec.linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
X-Mailer: iPhone Mail (17E255)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 7, 2020, at 3:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> =EF=BB=BFAndy Lutomirski <luto@amacapital.net> writes:
>>>> On Apr 7, 2020, at 1:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:=

>>> =EF=BB=BFAndy Lutomirski <luto@amacapital.net> writes:
>>>> =E2=80=9CPage is malfunctioning=E2=80=9D is tricky because you *must* d=
eliver the
>>>> event. x86=E2=80=99s #MC is not exactly a masterpiece, but it does kind=
 of
>>>> work.
>>>=20
>>> Nooooo. This does not need #MC at all. Don't even think about it.
>>=20
>> Yessssssssssss.  Please do think about it. :)
>=20
> I stared too much into that code recently that even thinking about it
> hurts. :)
>=20
>>> The point is that the access to such a page is either happening in user
>>> space or in kernel space with a proper exception table fixup.
>>>=20
>>> That means a real #PF is perfectly fine. That can be injected any time
>>> and does not have the interrupt semantics of async PF.
>>=20
>> The hypervisor has no way to distinguish between
>> MOV-and-has-valid-stack-and-extable-entry and
>> MOV-definitely-can=E2=80=99t-fault-here.  Or, for that matter,
>> MOV-in-do_page_fault()-will-recurve-if-it-faults.
>=20
> The mechanism which Vivek wants to support has a well defined usage
> scenario, i.e. either user space or kernel-valid-stack+extable-entry.
>=20
> So why do you want to route that through #MC?=20

To be clear, I hate #MC as much as the next person.  But I think it needs to=
 be an IST vector, and the #MC *vector* isn=E2=80=99t so terrible.  (The fac=
t that we can=E2=80=99t atomically return from #MC and re-enable CR4.MCE in a=
 single instruction is problematic but not the end of the world.). But see b=
elow =E2=80=94 I don=E2=80=99t think my suggestion should work quite the way=
 you interpreted it.

>>>=20
>>>=20
>>>  guest -> #PF runs and either sends signal to user space or runs
>>>           the exception table fixup for a kernel fault.
>>=20
>> Or guest blows up because the fault could not be recovered using #PF.
>=20
> Not for the use case at hand. And for that you really want to use
> regular #PF.
>=20
> The scenario I showed above is perfectly legit:
>=20
>   guest:
>        copy_to_user()          <- Has extable
>           -> FAULT
>=20
> host:
>   Oh, page is not there, give me some time to figure it out.
>=20
>   inject async fault
>=20
>   guest:
>        handles async fault interrupt, enables interrupts, blocks
>=20
> host:
>   Situation resolved, shared file was truncated. Tell guest

All good so far.

>=20
>   Inject #MC

No, not what I meant. Host has two sane choices here IMO:

1. Tell the guest that the page is gone as part of the wakeup. No #PF or #MC=
.

2. Tell guest that it=E2=80=99s resolved and inject #MC when the guest retri=
es.  The #MC is a real fault, RIP points to the right place, etc.

>=20
>  =20
>>=20
>>=20
>> 1. Access to bad memory results in an async-page-not-present, except
>> that, it=E2=80=99s not deliverable, the guest is killed.
>=20
> That's incorrect. The proper reaction is a real #PF. Simply because this
> is part of the contract of sharing some file backed stuff between host
> and guest in a well defined "virtio" scenario and not a random access to
> memory which might be there or not.

The problem is that the host doesn=E2=80=99t know when #PF is safe. It=E2=80=
=99s sort of the same problem that async pf has now.  The guest kernel could=
 access the problematic page in the middle of an NMI, under pagefault_disabl=
e(), etc =E2=80=94 getting #PF as a result of CPL0 access to a page with a v=
alid guest PTE is simply not part of the x86 architecture.

>=20
> Look at it from the point where async whatever does not exist at all:
>=20
>   guest:
>        copy_to_user()          <- Has extable
>           -> FAULT
>=20
> host:
>        suspend guest and resolve situation
>=20
>        if (page swapped in)
>           resume_guest();
>        else
>           inject_pf();
>=20
> And this inject_pf() does not care whether it kills the guest or makes
> it double/triple fault or whatever.
>=20
> The 'tell the guest to do something else while host tries to sort it'
> opportunistic thingy turns this into:
>=20
>   guest:
>        copy_to_user()          <- Has extable
>           -> FAULT
>=20
> host:
>        tell guest to do something else, i.e. guest suspends task
>=20
>        if (page swapped in)
>           tell guest to resume suspended task
>        else
>           tell guest to resume suspended task
>=20
>   guest resumes and faults again
>=20
> host:
>           inject_pf();
>=20
> which is pretty much equivalent.

Replace copy_to_user() with some access to a gup-ed mapping with no extable h=
andler and it doesn=E2=80=99t look so good any more.

Of course, the guest will oops if this happens, but the guest needs to be ab=
le to oops cleanly. #PF is too fragile for this because it=E2=80=99s not IST=
, and #PF is the wrong thing anyway =E2=80=94 #PF is all about guest-virtual=
-to-guest-physical mappings.  Heck, what would CR2 be?  The host might not e=
ven know the guest virtual address.

>=20
>> 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it=E2=80=
=99s
>> an *architectural* turd. By all means, have a nice simple PV mechanism
>> to tell the #MC code exactly what went wrong, but keep the overall
>> flow the same as in the native case.
>=20
> It's a completely different flow as you evaluate PV turd instead of
> analysing the MCE banks and the other error reporting facilities.

I=E2=80=99m fine with the flow being different. do_machine_check() could hav=
e entirely different logic to decide the error in PV.  But I think we should=
 reuse the overall flow: kernel gets #MC with RIP pointing to the offending i=
nstruction. If there=E2=80=99s an extable entry that can handle memory failu=
re, handle it. If it=E2=80=99s a user access, handle it.  If it=E2=80=99s an=
 unrecoverable error because it was a non-extable kernel access, oops or pan=
ic.

The actual PV part could be extremely simple: the host just needs to tell th=
e guest =E2=80=9Cthis #MC is due to memory failure at this guest physical ad=
dress=E2=80=9D.  No banks, no DIMM slot, no rendezvous crap (LMCE), no other=
 nonsense.  It would be nifty if the host also told the guest what the guest=
 virtual address was if the host knows it.
