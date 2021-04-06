Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD6355553
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344552AbhDFNhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:37:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233252AbhDFNhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 09:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617716245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMiNBtEMrQvnxIoUeX1bu77l5Tzq/22mbIKvwOxGjy8=;
        b=YmrfQPYgDWbzgEKvfVBYiytHJox3MxfyGx0eCAATq6WCHMhTWpcSF12dV1MJrTJdQxvOTX
        oL16AgWWOV78Luk1boUwVXHXry4KtlREoQbr5xndgSfWiU1AfboQa12PwJ1ocVXD/VmFAX
        7uE2FrleEJM+upaACGYTHj3X5Oy4LBU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-uGvyIF1ANhSPzNyUd96i6g-1; Tue, 06 Apr 2021 09:37:24 -0400
X-MC-Unique: uGvyIF1ANhSPzNyUd96i6g-1
Received: by mail-ej1-f71.google.com with SMTP id bn26so5457095ejb.20
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 06:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dMiNBtEMrQvnxIoUeX1bu77l5Tzq/22mbIKvwOxGjy8=;
        b=G2gVG6Xtml3khN9ZjEcRiIyiq/XsjH9mhhX3day8sziXvAvhIR6G8G6CEC67wqDMH5
         0hGy4ijOmDWfsgUHjZY1TvgpukkAixexWt2YyBfoKwbUy8DInBHKxLzeELwGMa0SKpfI
         F+BjTUpnTNSJS1VeMdVNkeIsMxzEZq0cB93noI+jJfxeRJnoirdPw1qcPL8dIp1geE1J
         qRUqGF9TXf3dALb+jms2loHgjJB+9LARL2QRtG+DORxaL4JOGPxWf3TmFpcFAgctbTWR
         pQEcnBxcBvUTsGcYU4q6r4z+cUr36zukzturtQ+N4XyffdOVVOpviPPR5wEskZjDnWjL
         X61g==
X-Gm-Message-State: AOAM531O+7dcNJXiPv6tf474oTV7GYQgdBgmpX5W2DkYtH5ecGzCtBtE
        TexLlTE3GpM4VwuixdPzdrBL/Sw9K2MKnjZMxG87jztqa3TxAj2UmQepFhlKZ9dSZ3PxWHWRWgs
        +ElK8oU7ryY23on75
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr34632030ejc.267.1617716243116;
        Tue, 06 Apr 2021 06:37:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPlX5I+as++Bo8KruxUM9wb9AZX5YYNyyxHZGmZWQjUSiI0DOUwwJMY80ynUyPN+ZY2HHTFg==
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr34632009ejc.267.1617716242875;
        Tue, 06 Apr 2021 06:37:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t14sm11010189ejc.121.2021.04.06.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 06:37:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
In-Reply-To: <CAJZ5v0hpkF-acQAomZZKN=r00gNy831R7J-ZWZgWnoCJe5xSkg@mail.gmail.com>
References: <20210406125047.547501-1-vkuznets@redhat.com>
 <CAJZ5v0hpkF-acQAomZZKN=r00gNy831R7J-ZWZgWnoCJe5xSkg@mail.gmail.com>
Date:   Tue, 06 Apr 2021 15:37:21 +0200
Message-ID: <87mtubcz5a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Rafael J. Wysocki" <rafael@kernel.org> writes:

> On Tue, Apr 6, 2021 at 2:50 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Commit 8cdddd182bd7 ("ACPI: processor: Fix CPU0 wakeup in
>> acpi_idle_play_dead()") tried to fix CPU0 hotplug breakage by copying
>> wakeup_cpu0() + start_cpu0() logic from hlt_play_dead()//mwait_play_dead()
>> into acpi_idle_play_dead(). The problem is that these functions are not
>> exported to modules so when CONFIG_ACPI_PROCESSOR=m build fails.
>>
>> The issue could've been fixed by exporting both wakeup_cpu0()/start_cpu0()
>> (the later from assembly) but it seems putting the whole pattern into a
>> new function and exporting it instead is better.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Fixes: 8cdddd182bd7 ("CPI: processor: Fix CPU0 wakeup in acpi_idle_play_dead()")
>> Cc: <stable@vger.kernel.org> # 5.10+
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/smp.h    |  2 +-
>>  arch/x86/kernel/smpboot.c     | 15 ++++++++++-----
>>  drivers/acpi/processor_idle.c |  3 +--
>>  3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
>> index 57ef2094af93..6f79deb1f970 100644
>> --- a/arch/x86/include/asm/smp.h
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -132,7 +132,7 @@ void native_play_dead(void);
>>  void play_dead_common(void);
>>  void wbinvd_on_cpu(int cpu);
>>  int wbinvd_on_all_cpus(void);
>> -bool wakeup_cpu0(void);
>> +void wakeup_cpu0_if_needed(void);
>>
>>  void native_smp_send_reschedule(int cpu);
>>  void native_send_call_func_ipi(const struct cpumask *mask);
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index f877150a91da..9547d870ee27 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1659,7 +1659,7 @@ void play_dead_common(void)
>>         local_irq_disable();
>>  }
>>
>> -bool wakeup_cpu0(void)
>> +static bool wakeup_cpu0(void)
>>  {
>>         if (smp_processor_id() == 0 && enable_start_cpu0)
>>                 return true;
>> @@ -1667,6 +1667,13 @@ bool wakeup_cpu0(void)
>>         return false;
>>  }
>>
>> +void wakeup_cpu0_if_needed(void)
>> +{
>> +       if (wakeup_cpu0())
>> +               start_cpu0();
>
> Note that all of the callers of wakeup_cpu0 do the above, so maybe
> make them all use the new function?
>
> In which case it can be rewritten in the following way
>
> void cond_wakeup_cpu0(void)
> {
>         if (smp_processor_id() == 0 && enable_start_cpu0)
>                 start_cpu0();
> }
> EXPORT_SYMBOL_GPL(cond_wakeup_cpu0);
>

Sure, separate wakeup_cpu0() is no longer needed.

> Also please add a proper kerneldoc comment to it and maybe drop the
> comments at the call sites?

Also a good idea. v2 is coming, thanks!

>
>
>> +}
>> +EXPORT_SYMBOL_GPL(wakeup_cpu0_if_needed);
>> +
>>  /*
>>   * We need to flush the caches before going to sleep, lest we have
>>   * dirty data in our caches when we come back up.
>> @@ -1737,8 +1744,7 @@ static inline void mwait_play_dead(void)
>>                 /*
>>                  * If NMI wants to wake up CPU0, start CPU0.
>>                  */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +               wakeup_cpu0_if_needed();
>>         }
>>  }
>>
>> @@ -1752,8 +1758,7 @@ void hlt_play_dead(void)
>>                 /*
>>                  * If NMI wants to wake up CPU0, start CPU0.
>>                  */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +               wakeup_cpu0_if_needed();
>>         }
>>  }
>>
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 768a6b4d2368..de15116b754a 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -545,8 +545,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
>>
>>  #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
>>                 /* If NMI wants to wake up CPU0, start CPU0. */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +               wakeup_cpu0_if_needed();
>>  #endif
>>         }
>>
>> --
>> 2.30.2
>>
>

-- 
Vitaly

