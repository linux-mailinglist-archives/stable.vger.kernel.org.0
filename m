Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCE7E1C1
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 19:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbfHAR5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 13:57:54 -0400
Received: from cmta18.telus.net ([209.171.16.91]:47438 "EHLO cmta18.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732763AbfHAR5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 13:57:53 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id tFKmhhzgV7TgTtFKnhLMRU; Thu, 01 Aug 2019 11:57:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564682271; bh=AQsQ99WCuCqJOKlvJNCOdDk8980EzDdQqEbT1VG/Heo=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=zCcZjeBU4t+94/mlEplsDforaFnHh3Iuhjwwk35NHfGM0U+KQYR1Nkx2nKeWohM0Q
         PLkiCNJ8ApI1Kph5LlWDqpfnjUxN6qFVay0/Y+Yu5i/45OfrgzeWGkDB2xH77uqXgl
         1jPu2bjyIeuxC1d6J6b0ZHHCuI+FUyafQluEobm4USlS2MlNoDmaKG1Ias2GkRqzm9
         yTJOkCKHNvy+50qFQKXt/u4nQjqv+PIvnVoZ1ZvPDNkMuh9LeOaIaZMyW4lwesqU7F
         CERMlAKQ9ealMnRqRCbElQXCZSP02zxb8k/p95L4N8xcOvXd/+HtParnBwUBgSMonQ
         qvkz8OhXb8E7A==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=e6N4tph/ c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=mNDiB0oIJ1z1wK9adlEA:9 a=CjuIK1q_8ugA:10
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Joel Fernandes'" <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7> <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com> <20190724114327.apmx35c7a4tv3qt5@vireshk-i7> <000c01d542fc$703ff850$50bfe8f0$@net> <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7> <000001d545e3$047d9750$0d78c5f0$@net> <20190729083219.fe4xxq4ugmetzntm@vireshk-i7> <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com> <000b01d547fe$e7b51fd0$b71f5f70$@net> <20190801061700.dl33rtilvg44obzu@vireshk-i7>
In-Reply-To: <20190801061700.dl33rtilvg44obzu@vireshk-i7>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Thu, 1 Aug 2019 10:57:46 -0700
Message-ID: <000001d54892$a25b86b0$e7129410$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVIML32quHCDOMQR5up5zsOxw7gYQATZJcA
X-CMAE-Envelope: MS4wfJ0MjgZ96E2SwzNR/9au5zlBHqgaVJfss0kIEtBtBLE6x0jdoIh50uCCONpjoLz50lL+XnrGzuu+hwb8NZZIJyjJ4ScN6LvLwyjDXTlDzJadVSMBPXgc
 dQD/zNaDT8WxohZVnePHMEcrYs0Po2GuPVB0gYbLkrkLPc36XksE8nGFihsvHoPAWDig0oW7mtaqcU6HoOFE2cnLdDWfysvpojlf5jjZFrT+i8p4NvVG1P3c
 z+aqXWrG0sjFQkIxdTnIpRjpSbBltnSLin5kt6qLfp+Dh9glH42BmqefxaZurKaPa25C8Y6ZpjSptnmpgxI8MsA341wlqQbOhXfGujmC7wLaSEgufd0cNuxu
 foEzdEsWZkBvLpQj3qs+j4l87mjY915ZFpv3Thc742G2D8i+xIQUVNyubIEzeZ6Ty6+V+NNr6l8PegHMREFE/1xzmStY/SVZy7m4ZPki8AGgIw8GH0I=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.07.31 23:17 Viresh Kumar wrote:
> On 31-07-19, 17:20, Doug Smythies wrote:
>> Summary:
>> 
>> The old way, using UINT_MAX had two purposes: first,
>> as a "need to do a frequency update" flag; but also second, to
>> force any subsequent old/new frequency comparison to NOT be "the same,
>> so why bother actually updating" (see: sugov_update_next_freq). All
>> patches so far have been dealing with the flag, but only partially
>> the comparisons. In a busy system, and when schedutil.c doesn't actually
>> know the currently set system limits, the new frequency is dominated by
>> values the same as the old frequency. So, when sugov_fast_switch calls 
>> sugov_update_next_freq, false is usually returned.
>
> And finally we know "Why" :)
>
> Good work Doug. Thanks for taking it to the end.
>
>> However, if we move the resetting of the flag and add another condition
>> to the "no need to actually update" decision, then perhaps this patch
>> version 1 will be O.K. It seems to be. (see way later in this e-mail).
>
>> With all this new knowledge, how about going back to
>> version 1 of this patch, and then adding this:
>> 
>> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
>> index 808d32b..f9156db 100644
>> --- a/kernel/sched/cpufreq_schedutil.c
>> +++ b/kernel/sched/cpufreq_schedutil.c
>> @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
>>  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
>>                                    unsigned int next_freq)
>>  {
>> -       if (sg_policy->next_freq == next_freq)
>> +       /*
>> +        * Always force an update if the flag is set, regardless.
>> +        * In some implementations (intel_cpufreq) the frequency is clamped
>> +        * further downstream, and might not actually be different here.
>> +        */
>> +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
>>                 return false;
>
> This is not correct because this is an optimization we have in place
> to make things more efficient. And it was working by luck earlier and
> my patch broke it for good :)

Disagree.
All I did was use a flag where it used to be set to UNIT_MAX, to basically
implement the same thing.

> Things need to get a bit more synchronized and something like this may
> help (completely untested):
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index cc27d4c59dca..2d84361fbebc 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -2314,6 +2314,18 @@ static int intel_cpufreq_target(struct cpufreq_policy *policy,
>        return 0;
> }
> 
> +static unsigned int intel_cpufreq_resolve_freq(struct cpufreq_policy *policy,
> +                                              unsigned int target_freq)
> +{
> +       struct cpudata *cpu = all_cpu_data[policy->cpu];
> +       int target_pstate;
> +
> +       target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
> +       target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
> +
> +       return target_pstate * cpu->pstate.scaling;
> +}
> +
>  static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
>                                               unsigned int target_freq)
>  {
> @@ -2350,6 +2362,7 @@ static struct cpufreq_driver intel_cpufreq = {
>         .verify         = intel_cpufreq_verify_policy,
>         .target         = intel_cpufreq_target,
>         .fast_switch    = intel_cpufreq_fast_switch,
> +       .resolve_freq   = intel_cpufreq_resolve_freq,
>         .init           = intel_cpufreq_cpu_init,
>         .exit           = intel_pstate_cpu_exit,
>         .stop_cpu       = intel_cpufreq_stop_cpu,
> 
> -------------------------8<-------------------------
>
> Please try this with my patch 2.

O.K.

> We need patch 2 instead of 1 because
> of another race condition Rafael noticed.

Disagree.
Notice that my modifications to your patch1 addresses
that condition by moving the clearing of "need_freq_update"
to sometime later.

> 
> cpufreq_schedutil calls driver specific resolve_freq() to find the new
> target frequency and this is where the limits should get applied IMO.

Oh! I didn't know. But yes, that makes sense.

>
> Rafael can help with reviewing this diff but it would be great if you
> can give this a try Doug.

Anyway, I added the above code (I am calling it patch3) to patch2, as
you asked, and it does work. I also added it to my modified patch1,
additionally removing the extra condition check that I added
(i.e. all that remains of my patch1 modifications is the moved
clearing of "need_freq_update") That kernel also worked for both
intel_cpufreq/schedutil and acpi-cpufreq/schedutil.

Again, I do not know how to test the original issue that led
to the change away from UINT_MAX in the first place,
ecd2884291261e3fddbc7651ee11a20d596bb514, which should be
tested in case of some introduced regression.

... Doug


