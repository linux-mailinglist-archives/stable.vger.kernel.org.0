Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A171D22525A
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgGSO7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 10:59:31 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:55425 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGSO7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jul 2020 10:59:31 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jul 2020 10:59:30 EDT
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 196A420130
        for <stable@vger.kernel.org>; Sun, 19 Jul 2020 14:51:34 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 3DEA03F1CC;
        Sun, 19 Jul 2020 16:51:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 1A8912A6D5;
        Sun, 19 Jul 2020 16:51:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1595170289;
        bh=MGwkLzKypO4J6nY2xTrNaiT71gTYgq65h2UegRb3cCs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ltz8Ki61iJpBU0cM8AfvAsBB1cSD7Rr4GUA6ISGHLilzONfdf4yy0xhhBbY573mCA
         7zy0mESheh4i8cSAloNkmmU908H0+5W/z+zxQn3tW2RIRNYdi0yHedsCe+sj05K34c
         reQfiVj9qlI5s/sLGfxUK0op014G0UBXbU2RVKV8=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O1Ig8pEgcOla; Sun, 19 Jul 2020 16:51:27 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 19 Jul 2020 16:51:27 +0200 (CEST)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 1A2E940854;
        Sun, 19 Jul 2020 14:51:25 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="S+f/pb22";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (ec2-18-162-62-95.ap-east-1.compute.amazonaws.com [18.162.62.95])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 0A66E40854;
        Sun, 19 Jul 2020 14:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1595170277;
        bh=MGwkLzKypO4J6nY2xTrNaiT71gTYgq65h2UegRb3cCs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=S+f/pb22Bb/rS+vxjFukXkRjKG/2+AZQ3iSmXUTN7KGqAGrX701TM+khW7FNXhIsp
         ZaMySFm9jE3/jdNofjZSmTjLCruoyAo+aH/TwUAzf42zs2DC8e9jM3Ay+KR9TFNwUW
         2h2MeKXSKkMXyf+Fqm5HaSQhi5ddYuML+A6+N6a8=
Subject: Re: [PATCH -stable] MIPS: Fix build for LTS kernel caused by
 backporting lpj adjustment
To:     Huacai Chen <chenhuacai@gmail.com>, gregkh@linuxfoundation.org
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
References: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4wdxtLCAFOJE6wgAZdg+U5mquSZjHmAL_qsDaGtENbFg@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <34928e81-3675-0309-b020-0cb4b402dc5c@flygoat.com>
Date:   Sun, 19 Jul 2020 22:51:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4wdxtLCAFOJE6wgAZdg+U5mquSZjHmAL_qsDaGtENbFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 1A2E940854
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[5];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[gmail.com,linuxfoundation.org];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2020/7/19 上午11:24, Huacai Chen 写道:
> Hi, Serge,
>
> Could you please have a look at this patch?


+ Gregkh

This is urgent for next stable release, please take a look.

Thanks


>
> Huacai
>
> On Thu, Jul 16, 2020 at 5:37 PM Huacai Chen <chenhc@lemote.com> wrote:
>> Commit ed26aacfb5f71eecb20a ("mips: Add udelay lpj numbers adjustment")
>> has backported to 4.4~5.4, but the "struct cpufreq_freqs" (and also the
>> cpufreq notifier machanism) of 4.4~4.19 are different from the upstream
>> kernel. These differences cause build errors, and this patch can fix the
>> build.
>>
>> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
>> Cc: Stable <stable@vger.kernel.org> # 4.4/4.9/4.14/4.19
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> ---
>>   arch/mips/kernel/time.c | 13 ++++---------
>>   1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
>> index b7f7e08..b15ee12 100644
>> --- a/arch/mips/kernel/time.c
>> +++ b/arch/mips/kernel/time.c
>> @@ -40,10 +40,8 @@ static unsigned long glb_lpj_ref_freq;
>>   static int cpufreq_callback(struct notifier_block *nb,
>>                              unsigned long val, void *data)
>>   {
>> -       struct cpufreq_freqs *freq = data;
>> -       struct cpumask *cpus = freq->policy->cpus;
>> -       unsigned long lpj;
>>          int cpu;
>> +       struct cpufreq_freqs *freq = data;
>>
>>          /*
>>           * Skip lpj numbers adjustment if the CPU-freq transition is safe for
>> @@ -64,6 +62,7 @@ static int cpufreq_callback(struct notifier_block *nb,
>>                  }
>>          }
>>
>> +       cpu = freq->cpu;
>>          /*
>>           * Adjust global lpj variable and per-CPU udelay_val number in
>>           * accordance with the new CPU frequency.
>> @@ -74,12 +73,8 @@ static int cpufreq_callback(struct notifier_block *nb,
>>                                                  glb_lpj_ref_freq,
>>                                                  freq->new);
>>
>> -               for_each_cpu(cpu, cpus) {
>> -                       lpj = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
>> -                                           per_cpu(pcp_lpj_ref_freq, cpu),
>> -                                           freq->new);
>> -                       cpu_data[cpu].udelay_val = (unsigned int)lpj;
>> -               }
>> +               cpu_data[cpu].udelay_val = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
>> +                                          per_cpu(pcp_lpj_ref_freq, cpu), freq->new);
>>          }
>>
>>          return NOTIFY_OK;
>> --
>> 2.7.0
>>
