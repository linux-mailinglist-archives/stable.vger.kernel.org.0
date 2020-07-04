Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CBA214480
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 09:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGDHoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 03:44:07 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:38169 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgGDHoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 03:44:07 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jul 2020 03:44:05 EDT
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [151.80.165.199])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 17AA326331;
        Sat,  4 Jul 2020 07:38:04 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id C81BE3EDBF;
        Sat,  4 Jul 2020 09:38:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id AAA222A8B6;
        Sat,  4 Jul 2020 09:38:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1593848281;
        bh=XiW1HI1EtY4K/9yoI93xs/abZ1JLjmBWmo36Jp86vI4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XQqYkXND2M+p/9DMShVZHdDw4iGPtmYHpNdHlj5yvG5Y3x2lVKGw58m17TMYgBh+E
         pyjjZ8d/qiUrlg7s4IVQFZXcG1hCUlHh0Ocf6bWX1AH3M1uCOJ0nhjelh/vQu8nlEI
         gxcQQLrp7r4di7nzlZMgRxqvzJxvSyS5r8peDJUQ=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KcixbAMqstGA; Sat,  4 Jul 2020 09:37:59 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Sat,  4 Jul 2020 09:37:59 +0200 (CEST)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 4195E41AC4;
        Sat,  4 Jul 2020 07:37:58 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="GnGkMDkb";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (ec2-18-162-62-95.ap-east-1.compute.amazonaws.com [18.162.62.95])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 9539841AC4;
        Sat,  4 Jul 2020 07:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1593848271;
        bh=XiW1HI1EtY4K/9yoI93xs/abZ1JLjmBWmo36Jp86vI4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GnGkMDkbLQx1KCjceJy9ZnYiz52AgMGp5TnpQYFCoTh8q0WsSnNHg5+wzyzz+CIZ8
         6acBtQz1ZcbaV9kvxRqjtOo/z3izeQv4OqakUwUPmCoVMQvH+d6otRWYYDnTWQFv2G
         ogkE+nix+kkhnA0rjU0Lgv84Lo8RYdpq68B393mo=
Subject: Re: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
To:     Hauke Mehrtens <hauke@hauke-m.de>, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200702225334.32414-1-hauke@hauke-m.de>
 <b9aa9a88-2e87-5317-f828-fc27d9f2221e@hauke-m.de>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <c41d9deb-4532-6903-38c6-9f27c3c97854@flygoat.com>
Date:   Sat, 4 Jul 2020 15:37:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b9aa9a88-2e87-5317-f828-fc27d9f2221e@hauke-m.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 4195E41AC4
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
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



在 2020/7/4 上午6:31, Hauke Mehrtens 写道:
> On 7/3/20 12:53 AM, Hauke Mehrtens wrote:
>> This resolves the hazard between the mtc0 in the change_c0_status() and
>> the mfc0 in configure_exception_vector(). Without resolving this hazard
>> configure_exception_vector() could read an old value and would restore
>> this old value again. This would revert the changes change_c0_status()
>> did. I checked this by printing out the read_c0_status() at the end of
>> per_cpu_trap_init() and the ST0_MX is not set without this patch.
>>
>> The hazard is documented in the MIPS Architecture Reference Manual Vol.
>> III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), rev
>> 6.03 table 8.1 which includes:
>>
>>     Producer | Consumer | Hazard
>>    ----------|----------|----------------------------
>>     mtc0     | mfc0     | any coprocessor 0 register
>>
>> I saw this hazard on an Atheros AR9344 rev 2 SoC with a MIPS 74Kc CPU.
>> There the change_c0_status() function would activate the DSPen by
>> setting ST0_MX in the c0_status register. This was reverted and then the
>> system got a DSP exception when the DSP registers were saved in
>> save_dsp() in the first process switch. The crash looks like this:
>>
>> [    0.089999] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
>> [    0.097796] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
>> [    0.107070] Kernel panic - not syncing: Unexpected DSP exception
>> [    0.113470] Rebooting in 1 seconds..
>>
>> We saw this problem in OpenWrt only on the MIPS 74Kc based Atheros SoCs,
>> not on the 24Kc based SoCs. We only saw it with kernel 5.4 not with
>> kernel 4.19, in addition we had to use GCC 8.4 or 9.X, with GCC 8.3 it
>> did not happen.
>>
>> In the kernel I bisected this problem to commit 9012d011660e ("compiler:
>> allow all arches to enable CONFIG_OPTIMIZE_INLINING"), but when this was
>> reverted it also happened after commit 172dcd935c34b ("MIPS: Always
>> allocate exception vector for MIPSr2+").
>>
>> Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")
>> does similar changes to a different file. I am not sure if there are
>> more places affected by this problem.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   arch/mips/kernel/traps.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
>> index 7c32c956156a..1234ea21dd8f 100644
>> --- a/arch/mips/kernel/traps.c
>> +++ b/arch/mips/kernel/traps.c
>> @@ -2169,6 +2169,7 @@ static void configure_status(void)
>>   
>>   	change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST0_SX|ST0_UX,
>>   			 status_set);
>> +	back_to_back_c0_hazard();
>>   }
>>   
>>   unsigned int hwrena;
>>
> The MIPS InterAptiv system software user manual suggests to put this
> back_to_back_c0_hazard() close to the consumer. Should I move it there?
I assume the suggestion was for performance concern.
I'd prefer just put it after c0 write, so we can easily trace missing 
barriers.
> Should I also add a back_to_back_c0_hazard() close to the other places
> which could be affected by similar problems even when I do not see them
> at runtime?
That's preventing us from potential risks. Please do so.

Thanks.

>
> Hauke
>
- Jiaxun
