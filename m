Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4F81A1778
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 23:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGVlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 17:41:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36611 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgDGVlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 17:41:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id g2so1737184plo.3
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 14:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=OcgTk0oacA9StsIDMl+6MhjFUtTMmS7Y+sK58xbpiSM=;
        b=KWVxXLMhkFRjbkIywwN+E3RLvBIGNELGuOR4jyVlTKwqXyxfDd9nBQasDNSjdXkvET
         anGDi3W5mgZapmRKxA+Jq0xEcZthsonsxXNPLJepozmIshSiXJ9LspNIYELsb6hSNL2+
         flNDYA1yMrz2VKkIWFU7MFk3V23uF8HgblqnNZRef0XhdCJf8He39U4GNyM/nkfsdcUh
         i3oxqo9Gakgf9586TGBIWDGQPDXyfyMrHwNjTzwa/31KJqiTWVJrxipiWAIlLfdxAT9j
         AJKnmMp0zoOiUgVNiEBsmudWzjV0psLuKIMxzACIGxXl0CGVbtuhDtU7s22O9n/5ZwE/
         RmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=OcgTk0oacA9StsIDMl+6MhjFUtTMmS7Y+sK58xbpiSM=;
        b=LMH54StVrSGPp1bLgLqyxHMqb9GIJXmsx0bSTTfM43/5qMhTATdGFDzbR3cOgz8/CZ
         mHUamP4ZSDYZK43lsYgEV5ARGj3YFx8wtoCA8NpPV4B6d7IAAxFkHdtp31S2XD7JIRQf
         1QItaJF6mMrT7WZ75gJ/Md7skJQn++RGCNclKUcm6IqpN0xhzf9KgFP+lGRsV9VvMMx/
         WLydIBXNHlqSbGmgU2T9KA+sXEfmTIOAk8wa/Q1AbxIVLtPxjeQlYZcOdaQEQ/i1Pl+w
         J1uFHe+nSF0xYQmSRufHwejTpTx3FO4mpQZYQr2H7hkUst9qAVAtrrPrc02P+5jEIbQi
         q3gw==
X-Gm-Message-State: AGi0PuaCZ9nz+M8QUKecE2Sqf2n+D/v7z7165hmkjndL33YJcGCHJUCP
        U+24t6jNrLrcAYmUB22qLyz2ng==
X-Google-Smtp-Source: APiQypIoh33lPAe4PZp06efRPul89phzf54v7EFh9aB0eyJZ8JBRAOxgWh67Ibl3730J0Hw1rwbOcg==
X-Received: by 2002:a17:90b:254:: with SMTP id fz20mr1507187pjb.27.1586295664414;
        Tue, 07 Apr 2020 14:41:04 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:a143:7d95:91a:a0ae? ([2601:646:c200:1ef2:a143:7d95:91a:a0ae])
        by smtp.gmail.com with ESMTPSA id np4sm2542972pjb.48.2020.04.07.14.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 14:41:03 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Tue, 7 Apr 2020 14:41:02 -0700
Message-Id: <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
In-Reply-To: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
X-Mailer: iPhone Mail (17E255)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 7, 2020, at 1:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> =EF=BB=BFAndy Lutomirski <luto@amacapital.net> writes:
>>>> On Apr 7, 2020, at 10:21 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> Whether interrupts are enabled or not check only happens before we decid=
e
>>> if async pf protocol should be followed or not. Once we decide to
>>> send PAGE_NOT_PRESENT, later notification PAGE_READY does not check
>>> if interrupts are enabled or not. And it kind of makes sense otherwise
>>> guest process will wait infinitely to receive PAGE_READY.
>>>=20
>>> I modified the code a bit to disable interrupt and wait 10 seconds (afte=
r
>>> getting PAGE_NOT_PRESENT message). And I noticed that error async pf
>>> got delivered after 10 seconds after enabling interrupts. So error
>>> async pf was not lost because interrupts were disabled.
>=20
> Async PF is not the same as a real #PF. It just hijacked the #PF vector
> because someone thought this is a brilliant idea.
>=20
>>> Havind said that, I thought disabling interrupts does not mask exception=
s.
>>> So page fault exception should have been delivered even with interrupts
>>> disabled. Is that correct? May be there was no vm exit/entry during
>>> those 10 seconds and that's why.
>=20
> No. Async PF is not a real exception. It has interrupt semantics and it
> can only be injected when the guest has interrupts enabled. It's bad
> design.
>=20
>> My point is that the entire async pf is nonsense. There are two types of e=
vents right now:
>>=20
>> =E2=80=9CPage not ready=E2=80=9D: normally this isn=E2=80=99t even visibl=
e to the guest =E2=80=94 the
>> guest just waits. With async pf, the idea is to try to tell the guest
>> that a particular instruction would block and the guest should do
>> something else instead. Sending a normal exception is a poor design,
>> though: the guest may not expect this instruction to cause an
>> exception. I think KVM should try to deliver an *interrupt* and, if it
>> can=E2=80=99t, then just block the guest.
>=20
> That's pretty much what it does, just that it runs this through #PF and
> has the checks for interrupts disabled - i.e can't right now' around
> that. If it can't then KVM schedules the guest out until the situation
> has been resolved.
>=20
>> =E2=80=9CPage ready=E2=80=9D: this is a regular asynchronous notification=
 just like,
>> say, a virtio completion. It should be an ordinary interrupt.  Some in
>> memory data structure should indicate which pages are ready.
>>=20
>> =E2=80=9CPage is malfunctioning=E2=80=9D is tricky because you *must* del=
iver the
>> event. x86=E2=80=99s #MC is not exactly a masterpiece, but it does kind o=
f
>> work.
>=20
> Nooooo. This does not need #MC at all. Don't even think about it.

Yessssssssssss.  Please do think about it. :)

>=20
> The point is that the access to such a page is either happening in user
> space or in kernel space with a proper exception table fixup.
>=20
> That means a real #PF is perfectly fine. That can be injected any time
> and does not have the interrupt semantics of async PF.

The hypervisor has no way to distinguish between MOV-and-has-valid-stack-and=
-extable-entry and MOV-definitely-can=E2=80=99t-fault-here.  Or, for that ma=
tter, MOV-in-do_page_fault()-will-recurve-if-it-faults.

>=20
> So now lets assume we distangled async PF from #PF and made it a regular
> interrupt, then the following situation still needs to be dealt with:
>=20
>   guest -> access faults
>=20
> host -> injects async fault
>=20
>   guest -> handles and blocks the task
>=20
> host figures out that the page does not exist anymore and now needs to
> fixup the situation.
>=20
> host -> injects async wakeup
>=20
>   guest -> returns from aysnc PF interrupt and retries the instruction
>            which faults again.
>=20
> host -> knows by now that this is a real fault and injects a proper #PF
>=20
>   guest -> #PF runs and either sends signal to user space or runs
>            the exception table fixup for a kernel fault.

Or guest blows up because the fault could not be recovered using #PF.

I can see two somewhat sane ways to make this work.

1. Access to bad memory results in an async-page-not-present, except that,  i=
t=E2=80=99s not deliverable, the guest is killed. Either that async-page-not=
-present has a special flag saying =E2=80=9Cmemory failure=E2=80=9D or the e=
ventual wakeup says =E2=80=9Cmemory failure=E2=80=9D.

2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it=E2=80=99=
s an *architectural* turd. By all means, have a nice simple PV mechanism to t=
ell the #MC code exactly what went wrong, but keep the overall flow the same=
 as in the native case.

I think I like #2 much better. It has another nice effect: a good implementa=
tion will serve as a way to exercise the #MC code without needing to muck wi=
th EINJ or with whatever magic Tony uses. The average kernel developer does n=
ot have access to a box with testable memory failure reporting.

>=20
> Thanks,
>=20
>        tglx
>=20
>=20
>=20
>=20
