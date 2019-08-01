Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFB77D239
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 02:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfHAAU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 20:20:26 -0400
Received: from cmta16.telus.net ([209.171.16.89]:36533 "EHLO cmta16.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbfHAAU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 20:20:26 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id sypOhHXFzJEJssypPhNcR5; Wed, 31 Jul 2019 18:20:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564618822; bh=RoMjVsFeBR9dzGUqz9tQiX7wl6S48TalbzeQBho2o+M=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=5gFsc/5CyRctMvW4aoanZmzzt5ifjuADeh+/BeOFmhcOLbk8RtgBZcxmd2Np1m39A
         7o+DtNNCzexD65vHU75zNf81q12UsCayAyvGX7WuzNUAxkwEsYMejRHp7Vqj5/E4Jz
         f19FWbVMXwx2V8cYOKO//GAAsjtfoM3TDXlZKfdSj+CkP4GZOMb1vAKidFiqGk5n6k
         NdNMZSLRMHiDQJwDk1uKSmXB8YICXKVZ1Nb34hqR7r52K8vQ2bZyYIlYjYrJg2Y2yc
         qSqXUaPodOCvMukosK3vKnkAvNe1cz1FQbavMHCUYKlXWVc8qegtYQVQ/Zlwe+2pzi
         RirmkSznV4xzg==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=S/CnP7kP c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=IkcTkHD0fZMA:10 a=KKAkSRfTAAAA:8 a=8nDaf5tc8T7PpteUzTkA:9
 a=nIdytl5xOkx3LOjh:21 a=vJ4ZG_pkyBBSFmaj:21 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc:     "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Joel Fernandes'" <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net> <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org> <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7> <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com> <20190724114327.apmx35c7a4tv3qt5@vireshk-i7> <000c01d542fc$703ff850$50bfe8f0$@net> <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7> <000001d545e3$047d9750$0d78c5f0$@net> <20190729083219.fe4xxq4ugmetzntm@vireshk-i7> <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
In-Reply-To: <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Wed, 31 Jul 2019 17:20:17 -0700
Message-ID: <000b01d547fe$e7b51fd0$b71f5f70$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVF6OaMSjLmuqt4TTajKLfjV61wEwB4UqKQ
X-CMAE-Envelope: MS4wfEh6UKnGXu5jyO16eXtz2ErqL1CFfTfRyEXu+v6/ZC5YvIBsTFQ+2E0ruBn3ScmN8u07WmJ6mQROV73JO4oa/2bSiUFe9in493vcOIfrJkgRPgIJbuKB
 rTlo0pgAUf9D4I7Ra/aQdvhZwCPN5td1mHooCP6kTL+qqQ8jXVq4UHD0/L9HBrOi3UGcnnTuAZIdsruuOeM+Fvc+Xcr636YMh/pYbZw+ObCZlyD/+g9YkvVT
 yxHZlWZ9mC1mpKR94qJsygaTjcF0m0ROGJ+Z6emqpmGT22X/0lTMXt+Z6ARbqn1qfqjubHONksHThQAAO16ktbOXBY11YlsCLZxCvS4iRv9K9N5GNJInPRzL
 b8tc6GjIlPsyQQOmOUFOlS88VZurx9jpJlFsZza1VWmAQmkP/nARN1J7ezkjZOoG3lCL+tMYo50V4XwORvSbYUr8VR6F6mSlinB156giEXB/yTLZBW8=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

Summary:

The old way, using UINT_MAX had two purposes: first,
as a "need to do a frequency update" flag; but also second, to
force any subsequent old/new frequency comparison to NOT be "the same,
so why bother actually updating" (see: sugov_update_next_freq). All
patches so far have been dealing with the flag, but only partially
the comparisons. In a busy system, and when schedutil.c doesn't actually
know the currently set system limits, the new frequency is dominated by
values the same as the old frequency. So, when sugov_fast_switch calls=20
sugov_update_next_freq, false is usually returned.

However, if we move the resetting of the flag and add another condition
to the "no need to actually update" decision, then perhaps this patch
version 1 will be O.K. It seems to be. (see way later in this e-mail).

On 2019.07.29 01:38 Rafael J. Wysocki wrote:
> On Mon, Jul 29, 2019 at 10:32 AM Viresh Kumar =
<viresh.kumar@linaro.org> wrote:
>> On 29-07-19, 00:55, Doug Smythies wrote:
>>> On 2019.07.25 23:58 Viresh Kumar wrote:

...[snip]...

>>>> Now, the frequency never gets down and so gets set to the maximum
>>>> possible after a bit.
>>>>
>>>> - Then I did:
>>>>
>>>> echo <any-low-freq-value> > =
/sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
>>>>
>>>> Without my patch applied:
>>>>        The print never gets printed and so frequency doesn't go =
down.
>>>>
>>>> With my patch applied:
>>>>        The print gets printed immediately from sugov_work() and so
>>>>        the frequency reduces.
>>>>
>>>> Can you try with this diff along with my Patch2 ? I suspect there =
may
>>>> be something wrong with the intel_cpufreq driver as the patch fixes
>>>> the only path we have in the schedutil governor which takes =
busyness
>>>> of a CPU into account.
>>>
>>> With this diff along with your patch2 There is never a print message
>>> from sugov_work. There are from sugov_fast_switch.
>>
>> Which is okay. sugov_work won't get hit in your case as I explained
>> above.

O.K., I finally understand.

>>> Note that for the intel_cpufreq CPU scaling driver and the schedutil
>>> governor I adjust the maximum clock frequency this way:
>>>
>>> echo <any-low-percent> > =
/sys/devices/system/cpu/intel_pstate/max_perf_pct
>>
>> This should eventually call sugov_limits() in schedutil governor, =
this
>> can be easily checked with another print message.
>>
>>> I also applied the pr_info messages to the reverted kernel, and =
re-did
>>> my tests (where everything works as expected). There is never a =
print
>>> message from sugov_work. There are from sugov_fast_switch.
>>
>> that's fine.
>>
>>> Notes:
>>>
>>> I do not know if:
>>> /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
>>> /sys/devices/system/cpu/cpufreq/policy*/scaling_min_freq
>>> Need to be accurate when using the intel_pstate driver in passive =
mode.
>>> They are not.
>>> The commit comment for 9083e4986124389e2a7c0ffca95630a4983887f0
>>> suggests that they might need to be representative.
>>> I wonder if something similar to that commit is needed
>>> for other global changes, such as max_perf_pct and min_perf_pct?
>>
>> We are already calling intel_pstate_update_policies() in that case, =
so
>> it should be fine I believe.

I now believe that lack of synchronization between
/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
and
/sys/devices/system/cpu/intel_pstate/max_perf_pct
is the root issue here.
The UINT_MAX next freq flag was also used to force a change
because the limits are then forced to be checked and enforced.

This e-mail continues with the assumption that this lack of
synchronization is O.K., because that is the way it is now.
However, if you want to have them synchronized then
Viresh's patch1 will work fine afterwards.

>>
>>> intel_cpufreq/ondemand doesn't work properly on the reverted kernel.
>>
>> reverted kernel ? The patch you reverted was only for schedutil and =
it
>> shouldn't have anything to do with ondemand.

Agreed. This is on hold until I have time to look into it.

>>> (just discovered, not investigated)
>>> I don't know about other governors.
>>
>> When you do:
>>
>> echo <any-low-percent> > =
/sys/devices/system/cpu/intel_pstate/max_perf_pct
>>
>> How soon does the print from sugov_fast_switch() gets printed ?
>> Immediately ? Check with both the kernels, with my patch and with the
>> reverted patch.

I don't really know how long.
So I added a message so I could get a time stamp:
I now do this:

echo "doug: Change max percent..." | sudo tee /dev/kmsg && echo 42 | =
sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

and then I can calculate the time from the dmseg output, see below.

>>
>> Also see if there is any difference in the next_freq value in both =
the
>> kernels when you change max_perf_pct.

Not really, it doesn't seem to mean anything anyhow, because
schedutil doesn't know about the limits.

>>
>> FWIW, we now know the difference between intel-pstate and
>> acpi-cpufreq/my testcase and why we see differences here. In the =
cases
>> where my patch fixed the issue (acpi/ARM), we were really changing =
the
>> limits, i.e. policy->min/max. This happened because we touched
>> scaling_max_freq directly.
>>
>> For the case of intel-pstate, you are changing max_perf_pct which
>> doesn't change policy->max directly. I am not very sure how all of it
>> work really, but at least schedutil will not see policy->max =
changing.
>>
>> @Rafael: Do you understand why things don't work properly with
>> intel_cpufreq driver ?
>
> I haven't tried to understand this yet, so no.
>
> My somewhat educated guess is that using max_perf_pct has to do with
> it, so I would try to retest to see if there's any difference when
> scaling_max_freq is used instead of that.

Yes, that works, but isn't the accepted way here and then
/sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
and
/sys/devices/system/cpu/intel_pstate/max_perf_pct are still not
synchronized.

It was thermald misbehaving that brought me here in the first place
and it was definitely modifying
/sys/devices/system/cpu/intel_pstate/max_perf_pct
during throttling attempts for the intel_cpufreq
driver and schedutil governor.

Test data (all CPUs always busy):

Kernel: revert + extra debug print statements:
Driver/governor: intel_cpufreq/schedutil

doug@s15:~/temp$ uname -a
Linux s15 5.2.0-revertdebug #630 SMP PREEMPT Sat Jul 27 15:34:29 PDT =
2019 x86_64 x86_64 x86_64 GNU/Linux

Command:

$ echo "doug: Change max percent..." | sudo tee /dev/kmsg && echo 60 | =
sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

Result:

[137552.507296] doug: Change max percent...
[137552.570049] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  <<< =
62.75 mSec
[137552.570051] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.570053] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.570054] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.570055] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.570056] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.570057] cpufreq_schedutil: sugov_fast_switch: 127: 3800000
[137552.571050] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  <<< =
8, as expected

Note 1: 3.8 GHz is the max turbo frequency. 60% would be ~2.3 GHz
Note 2: this response behaviour is consistent.

Command:

$ echo "doug: Change max percent..." | sudo tee /dev/kmsg && echo 100 | =
sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

Result:

[137722.788266] doug: Change max percent...
[137722.837871] cpufreq_schedutil: sugov_fast_switch: 127: 2860961  << =
ramp up stuff ?
[137722.837873] cpufreq_schedutil: sugov_fast_switch: 127: 2852539
[137722.837875] cpufreq_schedutil: sugov_fast_switch: 127: 2875000
[137722.837877] cpufreq_schedutil: sugov_fast_switch: 127: 2591430
[137722.837878] cpufreq_schedutil: sugov_fast_switch: 127: 2875000
[137722.837880] cpufreq_schedutil: sugov_fast_switch: 127: 2875000
[137722.837882] cpufreq_schedutil: sugov_fast_switch: 127: 2863769
[137722.837883] cpufreq_schedutil: sugov_fast_switch: 127: 2875000
[137722.838876] cpufreq_schedutil: sugov_fast_switch: 127: 3625000
[137722.838891] cpufreq_schedutil: sugov_fast_switch: 127: 3600219
[137722.838893] cpufreq_schedutil: sugov_fast_switch: 127: 2935791
[137722.838894] cpufreq_schedutil: sugov_fast_switch: 127: 3625000
[137722.838895] cpufreq_schedutil: sugov_fast_switch: 127: 3596679
[137722.838896] cpufreq_schedutil: sugov_fast_switch: 127: 3625000
[137722.838897] cpufreq_schedutil: sugov_fast_switch: 127: 3625000
[137722.839872] cpufreq_schedutil: sugov_fast_switch: 127: 3617919
[137722.839873] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 1
[137722.839884] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 2
[137722.839884] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 3
[137722.839885] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 4
[137722.839886] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 5
[137722.839887] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 6
[137722.839888] cpufreq_schedutil: sugov_fast_switch: 127: 3394775
[137722.840886] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 7
[137722.840993] cpufreq_schedutil: sugov_fast_switch: 127: 3800000  << 8

Note 1: 3.8 GHz is the max turbo frequency.
Note 2: this response behaviour is consistent.

Kernel: Viresh "patch2" + extra debug print statements:
Driver/governor: intel_cpufreq/schedutil

doug@s15:~$ uname -a
Linux s15 5.2.0-patch2debug #629 SMP PREEMPT Sat Jul 27 09:35:24 PDT =
2019 x86_64 x86_64 x86_64 GNU/Linux
Command:

$ echo "doug: Change max percent..." | sudo tee /dev/kmsg && echo 60 | =
sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

Result:
[  295.223071] doug: Change max percent...
[  295.279621] cpufreq_schedutil: sugov_fast_switch: 124: 3427978  <<< =
56.55 mSec

Note 1: 3.8 GHz is the max turbo frequency. 60% would be ~2.3 GHz

Note 2: this response behaviour is NOT consistent:
In this example 1 CPU, of 8, was actually switched to the new limited =
upper frequency.
We do not observe this in the frequency data because the CPU frequency =
is held high
by the other CPUs vote into the PLL.
This can be verified by looking directly at the what pstate was asked =
for MSRs.
Example:

doug@s15:~$ sudo rdmsr --bitfield 15:8 -d -a 0x199
38
38
16  <<< This one changed, in this case I asked for 42%
38
38
38
38
38

If I run this command many times, making sure the starting conditions =
are always the same:
Most often no sugov_fast_switch message is printed at all, and no CPU's =
are limited; Sometimes
1 "sugov_fast_switch" message is printed and 1 CPU is limited; Rarely, 2 =
"sugov_fast_switch"
messages are printed and 2 CPUs are limited; I never saw 3 or more.

If I run this command many many times in a row (like 60 times, I didn't =
actually count),
WITHOUT resetting starting conditions, eventually all CPU's will end up =
in a limited state
and the CPU frequency goes down. This does not appear to be a timing =
race condition, but
rather a frequency calculation condition, which can be forced by =
submitting UNIT_MAX as
the next_freq. Since the schedutil policy limits do not reflect the new =
limit just set
via the global command, it might well calculate the same frequency as =
last time,
and mostly does. When we force UINT_MAX, we also force a new frequency =
to actually propagate
to the actual governor (I think).

Command:

$ echo "doug: Change max percent..." | sudo tee /dev/kmsg && echo 100 | =
sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct

Result (in this example, I think 1 CPU had been at a reduced state from =
before):

[  407.925707] doug: Change max percent...
[  407.982503] cpufreq_schedutil: sugov_fast_switch: 124: 2757080 <<< =
56.796 mSec
[  407.983509] cpufreq_schedutil: sugov_fast_switch: 124: 3356445
[  407.984512] cpufreq_schedutil: sugov_fast_switch: 124: 3800000

Note 1: this response behaviour is NOT consistent:
If I start from the condition above, where after about 60 tries, the CPU
frequency is now actually low, this command doesn't clear all CPUs
restricted frequencies. However, keep in mind that only 1 CPU needs to=20
have the restriction cleared for the overall frequency to rise to =
maximum
for all CPUs. The read MSR method is used to verify:

doug@s15:~$ sudo rdmsr --bitfield 15:8 -d -a 0x199
16
16
16
16
16
16
16
16
doug@s15:~$ echo "doug: Change max percent..." | sudo tee /dev/kmsg && =
echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct
doug: Change max percent...
100
doug@s15:~$ sudo rdmsr --bitfield 15:8 -d -a 0x199
38  << 1
16
38  << 2
16
16
38  << 3
16
38  << 4

So, in this example, 4 CPUs changed and 4 didn't:

[  307.309284] doug: Change max percent...
[  307.363849] cpufreq_schedutil: sugov_fast_switch: 124: 1769531  << =
54.565 mSec
[  307.363906] cpufreq_schedutil: sugov_fast_switch: 124: 1705078
[  307.364223] cpufreq_schedutil: sugov_fast_switch: 124: 1984375
[  307.364372] cpufreq_schedutil: sugov_fast_switch: 124: 1997314
[  307.365226] cpufreq_schedutil: sugov_fast_switch: 124: 1814941
[  307.365228] cpufreq_schedutil: sugov_fast_switch: 124: 1765625
[  307.365231] cpufreq_schedutil: sugov_fast_switch: 124: 2250976
[  307.365245] cpufreq_schedutil: sugov_fast_switch: 124: 2480468
[  307.366231] cpufreq_schedutil: sugov_fast_switch: 124: 3100585
[  307.366250] cpufreq_schedutil: sugov_fast_switch: 124: 2594238
[  307.366251] cpufreq_schedutil: sugov_fast_switch: 124: 1925048
[  307.367227] cpufreq_schedutil: sugov_fast_switch: 124: 1995117
[  307.367228] cpufreq_schedutil: sugov_fast_switch: 124: 2932617
[  307.367248] cpufreq_schedutil: sugov_fast_switch: 124: 3800000  << 1
[  307.367249] cpufreq_schedutil: sugov_fast_switch: 124: 2036132
[  307.368229] cpufreq_schedutil: sugov_fast_switch: 124: 3449707
[  307.368245] cpufreq_schedutil: sugov_fast_switch: 124: 2148193
[  307.369228] cpufreq_schedutil: sugov_fast_switch: 124: 2229003
[  307.369230] cpufreq_schedutil: sugov_fast_switch: 124: 3800000  << 2
[  307.369245] cpufreq_schedutil: sugov_fast_switch: 124: 2258544
[  307.370246] cpufreq_schedutil: sugov_fast_switch: 124: 2372436
[  307.371228] cpufreq_schedutil: sugov_fast_switch: 124: 2577392
[  307.371230] cpufreq_schedutil: sugov_fast_switch: 124: 2475585
[  307.372248] cpufreq_schedutil: sugov_fast_switch: 124: 2673339
[  307.374228] cpufreq_schedutil: sugov_fast_switch: 124: 2903686
[  307.374229] cpufreq_schedutil: sugov_fast_switch: 124: 2932617
[  307.375235] cpufreq_schedutil: sugov_fast_switch: 124: 3237304
[  307.375449] cpufreq_schedutil: sugov_fast_switch: 124: 3391113
[  307.376235] cpufreq_schedutil: sugov_fast_switch: 124: 3573120
[  307.377228] cpufreq_schedutil: sugov_fast_switch: 124: 3800000  << 3
[  307.377231] cpufreq_schedutil: sugov_fast_switch: 124: 3800000  << 4

It took 4 tries to clear all CPU's. I do not know why it takes
~60 tries to limit them all, but only a few to go the other way,
but it does seem much more probable that the calculated frequency
would be different because conditions are not pinned in this case.

O.K. 1 final test: O.K. so just add back this one line to
Viresh's patch2:

+               sg_policy->next_freq =3D UINT_MAX;

And everything works.
Why? Because now the frequency is different for certain.
O.K. so where is that decision made? How about here:
sugov_update_next_freq
Maybe that needs a flag check before returning false, since
the comparison is based on incorrect information because the
policies are do not reflect reality.

Going back to patch version 1:

With all this new knowledge, how about going back to
version 1 of this patch, and then adding this:

diff --git a/kernel/sched/cpufreq_schedutil.c =
b/kernel/sched/cpufreq_schedutil.c
index 808d32b..f9156db 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct =
sugov_policy *sg_policy, u64 time)
 static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 =
time,
                                   unsigned int next_freq)
 {
-       if (sg_policy->next_freq =3D=3D next_freq)
+       /*
+        * Always force an update if the flag is set, regardless.
+        * In some implementations (intel_cpufreq) the frequency is =
clamped
+        * further downstream, and might not actually be different here.
+        */
+       if (sg_policy->next_freq =3D=3D next_freq && =
!sg_policy->need_freq_update)
                return false;

        sg_policy->next_freq =3D next_freq;
@@ -171,7 +176,6 @@ static unsigned int get_next_freq(struct =
sugov_policy *sg_policy,
        if (freq =3D=3D sg_policy->cached_raw_freq && =
!sg_policy->need_freq_update)
                return sg_policy->next_freq;

-       sg_policy->need_freq_update =3D false;
        sg_policy->cached_raw_freq =3D freq;
        return cpufreq_driver_resolve_freq(policy, freq);
 }
@@ -478,6 +482,7 @@ static void sugov_update_single(struct =
update_util_data *hook, u64 time,
                sugov_deferred_update(sg_policy, time, next_f);
                raw_spin_unlock(&sg_policy->update_lock);
        }
+       sg_policy->need_freq_update =3D false;
 }

 static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, =
u64 time)

I do not know if there are other spots that need a similar change.
This seems to work, so far, but I still need to test more.
Works for both intel_cpufreq and acpi-cpufreq, so far.
Please note that I do not know how to test the original issue that led
to the change away from UINT_MAX in the first place,
ecd2884291261e3fddbc7651ee11a20d596bb514, which should be tested in case
of some introduced regression.

Thanks to anybody that actually read this far.

... Doug


