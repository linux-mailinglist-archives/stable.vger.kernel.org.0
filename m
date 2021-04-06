Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACDC355842
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbhDFPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:39:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345990AbhDFPj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 11:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617723558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dEwvW3Eu7pp0GjhQTtqchn8FzoztUJpOnaMjs0hwKdE=;
        b=U8FHvawG2GoHI5el1RYrZ3aUrzZEW0rHkDmkjKE9+NbN79mxSXV9BUA4RRGdwAJmkJ+cMX
        PiaIzf2L7VNXtM47FPIT4xPHi9rajFASJq3gdjn8s+Brt4LpZ0R/OJ113RLQzQsig1Qa4d
        FI3OQZhIxf0RW252NslgjEoyqwLSFGk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-3a2SEjprM3WSiJ2lbawE8Q-1; Tue, 06 Apr 2021 11:39:16 -0400
X-MC-Unique: 3a2SEjprM3WSiJ2lbawE8Q-1
Received: by mail-ej1-f72.google.com with SMTP id gn30so5637422ejc.3
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 08:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dEwvW3Eu7pp0GjhQTtqchn8FzoztUJpOnaMjs0hwKdE=;
        b=JYXLx5mVGQfNvRJwvIImZk4B3KVTZ9qXsMeYuY/zJKWmRz9e6YS9DdHh7iEn1raJ9l
         x37KEPscL6B57YhVrBDh8iXTnw1jr6DyhwwYlo42RnGr5TeJd8NdFjC67e79Tj7Cei0J
         uInMjUKuj888fJryMnCpZyS8GfarnhYl3SodYZi76DLLA5Bv1vPiZ0/i4/5wWRCjzB+P
         QHHCSq5EzC0orie1kbUw9lu5JOmTjdMwVvvqJHxvJp1IQutmZe/NAla9seiAq/7q9mat
         T0rhGxbeSdT+CrIuG86T78itkQuxBXCnaNnCOlT5tWQEewS9DHwplIYVun4WORzsiiXJ
         Z8Qw==
X-Gm-Message-State: AOAM533syCB9nYxnnDLwVyiJuqOKWqBnJgBNDZmTf6nRkkxXuQx6Po+u
        tBnaeuS1vGnwndZ5ZqEzBQia4Vx2pv1DbSpRJzN0DIrN2pGb3V/+LojqNwCmUUmy4rgfiSeRlRo
        zdgi5lyA2SSBI4nyL
X-Received: by 2002:a05:6402:17d5:: with SMTP id s21mr38566139edy.65.1617723554916;
        Tue, 06 Apr 2021 08:39:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0VARjuvs04vccawlabe0DP2bRNkNi4WV2ROTlXgyJy2mWSPrbeLpM8tDa5z5RnwfxIKQDrQ==
X-Received: by 2002:a05:6402:17d5:: with SMTP id s21mr38566114edy.65.1617723554723;
        Tue, 06 Apr 2021 08:39:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hz24sm6380209ejc.119.2021.04.06.08.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:39:14 -0700 (PDT)
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
Subject: Re: [PATCH v2] ACPI: processor: Fix build when CONFIG_ACPI_PROCESSOR=m
In-Reply-To: <CAJZ5v0ixuM0HfVrrn47+vmTaBq8RS9b3nyKbbTr9qKQps_buYg@mail.gmail.com>
References: <20210406140005.554402-1-vkuznets@redhat.com>
 <CAJZ5v0ixuM0HfVrrn47+vmTaBq8RS9b3nyKbbTr9qKQps_buYg@mail.gmail.com>
Date:   Tue, 06 Apr 2021 17:39:13 +0200
Message-ID: <87h7kjcti6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Rafael J. Wysocki" <rafael@kernel.org> writes:

> On Tue, Apr 6, 2021 at 4:01 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
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
>> Changes since v1:
>> - Rename wakeup_cpu0() to cond_wakeup_cpu0() and fold wakeup_cpu0() in
>>  as it has no other users [Rafael J. Wysocki]
>> ---
>>  arch/x86/include/asm/smp.h    |  2 +-
>>  arch/x86/kernel/smpboot.c     | 24 ++++++++++--------------
>>  drivers/acpi/processor_idle.c |  4 +---
>>  3 files changed, 12 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
>> index 57ef2094af93..630ff08532be 100644
>> --- a/arch/x86/include/asm/smp.h
>> +++ b/arch/x86/include/asm/smp.h
>> @@ -132,7 +132,7 @@ void native_play_dead(void);
>>  void play_dead_common(void);
>>  void wbinvd_on_cpu(int cpu);
>>  int wbinvd_on_all_cpus(void);
>> -bool wakeup_cpu0(void);
>> +void cond_wakeup_cpu0(void);
>>
>>  void native_smp_send_reschedule(int cpu);
>>  void native_send_call_func_ipi(const struct cpumask *mask);
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index f877150a91da..147f1bba9736 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1659,13 +1659,15 @@ void play_dead_common(void)
>>         local_irq_disable();
>>  }
>>
>> -bool wakeup_cpu0(void)
>> +/*
>> + * If NMI wants to wake up CPU0, start CPU0.
>> + */
>
> Hasn't checkpatch.pl complained about this?
>

No, it didn't.

> A proper kerneldoc would be something like:
>
> /**
>  * cond_wakeup_cpu0 - Wake up CPU0 if needed.
>  *
>  * If NMI wants to wake up CPU0, start CPU0.
>  */

Yea, I didn't do that partly because of my laziness but partly because
I don't see much usage of this format in arch/x86/kernel/[smpboot.c]. I
can certainly do v3 if it's prefered.

>
>> +void cond_wakeup_cpu0(void)
>>  {
>>         if (smp_processor_id() == 0 && enable_start_cpu0)
>> -               return true;
>> -
>> -       return false;
>> +               start_cpu0();
>>  }
>> +EXPORT_SYMBOL_GPL(cond_wakeup_cpu0);
>>
>>  /*
>>   * We need to flush the caches before going to sleep, lest we have
>> @@ -1734,11 +1736,8 @@ static inline void mwait_play_dead(void)
>>                 __monitor(mwait_ptr, 0, 0);
>>                 mb();
>>                 __mwait(eax, 0);
>> -               /*
>> -                * If NMI wants to wake up CPU0, start CPU0.
>> -                */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +
>> +               cond_wakeup_cpu0();
>>         }
>>  }
>>
>> @@ -1749,11 +1748,8 @@ void hlt_play_dead(void)
>>
>>         while (1) {
>>                 native_halt();
>> -               /*
>> -                * If NMI wants to wake up CPU0, start CPU0.
>> -                */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +
>> +               cond_wakeup_cpu0();
>>         }
>>  }
>>
>> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
>> index 768a6b4d2368..4e2d76b8b697 100644
>> --- a/drivers/acpi/processor_idle.c
>> +++ b/drivers/acpi/processor_idle.c
>> @@ -544,9 +544,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
>>                         return -ENODEV;
>>
>>  #if defined(CONFIG_X86) && defined(CONFIG_HOTPLUG_CPU)
>> -               /* If NMI wants to wake up CPU0, start CPU0. */
>> -               if (wakeup_cpu0())
>> -                       start_cpu0();
>> +               cond_wakeup_cpu0();
>>  #endif
>>         }
>>
>> --
>> 2.30.2
>>
>

-- 
Vitaly

