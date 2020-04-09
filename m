Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3871A317A
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 11:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgDIJD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 05:03:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726470AbgDIJD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 05:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586423034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8kQ7lBIYRxVIllP8WU3yr1RLlp3Ki4sY9tIMcm8NLXo=;
        b=IVNcAyufctBLzc53jkAutcUvY2tu2GD0XxJwmWuZEKz1ujU+Ius/XKI0SpLX5nKI+6+Tc1
        P0fTsVR9sCSfLPG0ffySnfeA5mIW3sen/T3iDzPl23Ntl7omZ1BFx4jPHoVtIXFk4b+cLe
        b11CIjVlPGb+nWxHIyHYl+pdHgqnqRI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-owOgS8F6MsuiHwsIfGHjJA-1; Thu, 09 Apr 2020 05:03:53 -0400
X-MC-Unique: owOgS8F6MsuiHwsIfGHjJA-1
Received: by mail-wr1-f71.google.com with SMTP id g6so5999714wru.8
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 02:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8kQ7lBIYRxVIllP8WU3yr1RLlp3Ki4sY9tIMcm8NLXo=;
        b=RuXrHudGbiJ2jpOQ4dcUL8JYGkzKIRthiFpCMO227SIVJpz9P3JQxDyULZLwKYkJyU
         DXLHXbY9HLRoYnMgpy4dpyzpIbt7y9YbEwUILl1kzYKRjMth8E5HN4eG/lGfE9yJZYDG
         Jro0ZEuNaGxwDW4cenwEBMY9MJ9Qeya7/Z2bLGXB0LE3euiPEz5MwUtEKO0MnI8NnhZB
         58na0qjn8R0Z92nXvnyMd2KYopbNp40wv52kvBbS4Wk8PQlVwwo6vvbzipIppdGYF0D/
         4vVWFfoPWz3Jp45K6bivnbKZNmZDE37ziBJpHf3+YyfLK1jnqcs4xhpIvKigQ96Cmjmy
         jokA==
X-Gm-Message-State: AGi0PuZF4nlEqs5sOD7WX35ZEuLW5hKvtJ9YTxTmr3TR8lnjSgNeiIyP
        owAmnK4X10fFKO/7lZO4MV7UcI7yA5ZuwueAsXBasmzq4AP0QQy1PnUdqjfQ3K36R2mYuja47M3
        YUf/1H+Ni11zjXvuX
X-Received: by 2002:adf:b1c6:: with SMTP id r6mr12632486wra.49.1586423032033;
        Thu, 09 Apr 2020 02:03:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypLF16jQY0MQeLOoeWEjDvj99XBLM/QjgSY70WD35IL8kqp+4bpmhm1qfLNT2fbzdEIEC3sYEw==
X-Received: by 2002:adf:b1c6:: with SMTP id r6mr12632450wra.49.1586423031690;
        Thu, 09 Apr 2020 02:03:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bddb:697c:bea8:abc? ([2001:b07:6468:f312:bddb:697c:bea8:abc])
        by smtp.gmail.com with ESMTPSA id t8sm300999wrq.88.2020.04.09.02.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 02:03:51 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <87pncib06x.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92ea7036-0b77-20da-34ac-f425e6f233c2@redhat.com>
Date:   Thu, 9 Apr 2020 11:03:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87pncib06x.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/04/20 15:01, Thomas Gleixner wrote:
> 
> And it comes with restrictions:
> 
>     The Do Other Stuff event can only be delivered when guest IF=1.
> 
>     If guest IF=0 then the host has to suspend the guest until the
>     situation is resolved.
> 
>     The 'Situation resolved' event must also wait for a guest IF=1 slot.

Additionally:

- the do other stuff event must be delivered to the same CPU that is
causing the host-side page fault

- the do other stuff event provides a token that identifies the cause
and the situation resolved event provides a matching token

This stuff is why I think the do other stuff event looks very much like
a #VE.  But I think we're in violent agreement after all.

> If you just want to solve Viveks problem, then its good enough. I.e. the
> file truncation turns the EPT entries into #VE convertible entries and
> the guest #VE handler can figure it out. This one can be injected
> directly by the hardware, i.e. you don't need a VMEXIT.
> 
> If you want the opportunistic do other stuff mechanism, then #VE has
> exactly the same problems as the existing async "PF". It's not magicaly
> making that go away.

You can inject #VE from the hypervisor too, with PV magic to distinguish
the two.  However that's not necessarily a good idea because it makes it
harder to switch to hardware delivery in the future.

> One possible solution might be to make all recoverable EPT entries
> convertible and let the HW inject #VE for those.
> 
> So the #VE handler in the guest would have to do:
> 
>        if (!recoverable()) {
>        	if (user_mode)
>                 	send_signal();
>                 else if (!fixup_exception())
>                 	die_hard();
>                 goto done;  
>        }                 
> 
>        store_ve_info_in_pv_page();
> 
>        if (!user_mode(regs) || !preemptible()) {
>        	hypercall_resolve_ept(can_continue = false);
>        } else {
>               init_completion();
>        	hypercall_resolve_ept(can_continue = true);
>               wait_for_completion();
>        }
> 
> or something like that.

Yes, pretty much.  The VE info can also be passed down to the hypercall
as arguments.

Paolo

> The hypercall to resolve the EPT fail on the host acts on the
> can_continue argument.
> 
> If false, it suspends the guest vCPU and only returns when done.
> 
> If true it kicks the resolve process and returns to the guest which
> suspends the task and tries to do something else.
> 
> The wakeup side needs to be a regular interrupt and cannot go through
> #VE.

