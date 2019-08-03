Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE11C806DE
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfHCPAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 11:00:30 -0400
Received: from cmta20.telus.net ([209.171.16.93]:39005 "EHLO cmta20.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfHCPAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 11:00:30 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id tvWDhKTHvmIDxtvWEhxFKv; Sat, 03 Aug 2019 09:00:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564844428; bh=Lj1By7YmAc45Sa4BMiPVFr2mo3E8ffsuE5NLZErH4xY=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=nZWI92EOtREXBJ+AE4XUGaBBPa/kIC9KmLUrj9PIvfEWt/iK2H/MF79VLoLG2HisG
         fr+bhEBQU0cfIvVxMyBklje9Z/DeVTz6jgShCYuj9CS5tudfImYJJOGhhSMLU63g5t
         7G0Zp6Wo5x+ixpmZaWlh0QVDpahVJXDz0XQ2E55rFbUnH5pDyTBltbmfS+j5miAtOR
         72oElGyYngLFw4f4gQb3BcqfKQO9Ydb2ci7sPndPW1pf9KbrhSFDs1lCDnHP+qJQfg
         DtZRmpwzd6GjajMqHnzFUzL6ifENOyp7RneHOTeHQbkNprP9ULAbEhCjFRed5ogFLT
         3iHpqLLRgd2zQ==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=Tq+Yewfh c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=KKAkSRfTAAAA:8 a=QvZYLQxYM4yHgahalX0A:9 a=CjuIK1q_8ugA:10
 a=cvBusfyB2V15izCimMoJ:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc:     "'Srinivas Pandruvada'" <srinivas.pandruvada@linux.intel.com>,
        "'Len Brown'" <lenb@kernel.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Doug Smythies'" <doug.smythies@gmail.com>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org> <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org> <CAJZ5v0iqztRWyxf1cgiAN1dK4qTGwy9raaGOx5u3tfBTGUKOng@mail.gmail.com> <2676200.jfxhmTd764@kreacher>
In-Reply-To: <2676200.jfxhmTd764@kreacher>
Subject: RE: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
Date:   Sat, 3 Aug 2019 08:00:23 -0700
Message-ID: <000401d54a0c$2f03aa50$8d0afef0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdVJFKTHz0k2Xgs/RzO01AVtAMTNrwAejLVg
Content-Language: en-ca
X-CMAE-Envelope: MS4wfG+TdJyI6eP2AGXmcP91oklGkSevBO0/OgYrXTxgVOtmzrBQhs/sV/aH2oS+YWag+QT1XxhlsWaZldrJxjZ92TnGN01gKUw2U8yZpOmIkrU0Pj0sGjnt
 Wn061oU1sFzXh4j3IvF/Ll7ciVA9G4Qc0EZ/xKk924qnUXnFG4EQB2/2plbuaFzxaTj7FdtyrIOAPZcEkES3RfitGFIIAM+Bazerteh6RiZw+3Pi/DVrnYgV
 Q8v3IYDr5Y3GlBAGMQrQYxushPnvNoJFRQeUgk8YdGQkjgTfYm7ZGKGfoICkShNfGxmlUP9F64LFIvpnZe9Kx5/h8ihFmXjvpvKrSKU/LKbNw84RlqngIPv8
 b3+FlgDt+oZyE1tjk9E+fB5mVa95WDDP2HL7lfpzt6x1njnArlPxiAMtDmUJc4mzpWR/FW2V7y0oatl2OVABuD/qxkXnJ03SKZllm9h9VuulmaRfA18=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.08.02 02:28 Rafael J. Wysocki wrote:
> On Friday, August 2, 2019 11:17:55 AM CEST Rafael J. Wysocki wrote:
>> On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>
>>> Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
>>> which can be used to force a limit on the min/max P state of the driver.
>>> Though these files eventually control the min/max frequencies that the
>>> CPUs will run at, they don't make a change to policy->min/max values.
>> 
>> That's correct.
>> 
>>> When the values of these files are changed (in passive mode of the
>>> driver), it leads to calling ->limits() callback of the cpufreq
>>> governors, like schedutil. On a call to it the governors shall
>>> forcefully update the frequency to come within the limits.
>> 
>> OK, so the problem is that it is a bug to invoke the governor's ->limits()
>> callback without updating policy->min/max, because that's what
>> "limits" mean to the governors.
>> 
>> Fair enough.
>
> AFAICS this can be addressed by adding PM QoS freq limits requests of each CPU to
> intel_pstate in the passive mode such that changing min_perf_pct or max_perf_pct
> will cause these requests to be updated.

All governors for the intel_cpufreq (intel_pstate in passive mode) CPU frequency
scaling driver are broken with respect to this issue, not just the schedutil
governor. My initial escalation had been focused on acpi-cpufreq/schedutil
and intel_cpufreq/schedutil, as they were both broken, and both fixed by my initially
submitted reversion. What can I say, I missed that other intel_cpufreq governors
were also involved.

I tested all of them: conservative ondemand userspace powersave performance schedutil
Note that no other governor uses resolve_freq().

... Doug


