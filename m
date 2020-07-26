Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3095F22DB56
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 04:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGZCRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 22:17:52 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:41079 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgGZCRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 22:17:52 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.199.117])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id A03E3200D8;
        Sun, 26 Jul 2020 02:17:49 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 346913F162;
        Sun, 26 Jul 2020 04:17:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id E6C2F2A8B1;
        Sun, 26 Jul 2020 04:17:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1595729866;
        bh=Rd2U38tZCfZE/BTCcopKl6jh9hRKONeG5J+ZjOAzDHg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=wPJ+6jZ6UVGhiJ7cFyFwaJdo/U5BFKJKExq54RzUSixnP2iVtetCrSipkZVV7fXkK
         e7tXhD8UwZxXApoxD9EpXlJXPDW7mU+3/A2Q9qmYI5XlVGEAf288HagUaJtLEc+kam
         UgE+GSMoLi9QtkrZCT6lI0FGbDmnjL3WkFWZR5TI=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Z7p6kHl8nAUu; Sun, 26 Jul 2020 04:17:45 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 26 Jul 2020 04:17:45 +0200 (CEST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 9FD954130F;
        Sun, 26 Jul 2020 02:17:41 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="Ds9VUt4o";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li161-247.members.linode.com [173.230.151.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 6D3B2419C2;
        Sun, 26 Jul 2020 02:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1595729834;
        bh=Rd2U38tZCfZE/BTCcopKl6jh9hRKONeG5J+ZjOAzDHg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ds9VUt4oxPXC0hM8f0mmhyCCz+HqBe62Jlehb7nppApiodIQGbr5A98FjGAz0KFsa
         nvgOeCAS7nU6/bhhmnpjcbpswlbvMXHLQILovaitBaq0hQCnfiuWSIHSlMM6lc1d5I
         ywend8wQJfQd/WdIdZoSt4uq5Io1ZqGP1KFyFk1k=
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
To:     Greg KH <gregkh@linuxfoundation.org>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        stable <stable@vger.kernel.org>
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com>
 <20200725064923.GA1059787@kroah.com>
 <CAAhV-H7WgGy=NKZ-YwDTQ1HtNT--qp2J8m25RmxpsdUBbmm8oQ@mail.gmail.com>
 <20200725074521.GA347597@kroah.com>
 <CAAhV-H7C3-uro-UD6voeamcECQHo1PYNBiyGyHLPDyEAJUm98w@mail.gmail.com>
 <20200725085748.GA394858@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <bf7c0881-a40f-6a35-40bb-96187129422a@flygoat.com>
Date:   Sun, 26 Jul 2020 10:17:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200725085748.GA394858@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 9FD954130F
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[flygoat.com:+];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[linuxfoundation.org,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[alpha.franken.de,vger.kernel.org,lemote.com,gmail.com];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2020/7/25 下午4:57, Greg KH 写道:
> On Sat, Jul 25, 2020 at 04:29:28PM +0800, Huacai Chen wrote:
>> Hi, Greg,
>>
>> On Sat, Jul 25, 2020 at 3:45 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Sat, Jul 25, 2020 at 02:57:31PM +0800, Huacai Chen wrote:
>>>> Hi Greg,
>>>>
>>>> On Sat, Jul 25, 2020 at 2:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> On Sat, Jul 25, 2020 at 02:37:52PM +0800, Huacai Chen wrote:
>>>>>> Hi, Thomas,
>>>>>>
>>>>>> What do you think about this patch? Other archs also do the same thing
>>>>>> except those support hotplug CPU#0.
>>>>>>
>>>>>> grep hotpluggable arch -rwI
>>>>>> arch/riscv/kernel/setup.c:        cpu->hotpluggable = cpu_has_hotplug(i);
>>>>>> arch/powerpc/kernel/sysfs.c:    BUG_ON(!c->hotpluggable);
>>>>>> arch/powerpc/kernel/sysfs.c:            c->hotpluggable = 1;
>>>>>> arch/powerpc/kernel/sysfs.c:        if (cpu_online(cpu) || c->hotpluggable) {
>>>>>> arch/arm/kernel/setup.c:        cpuinfo->cpu.hotpluggable =
>>>>>> platform_can_hotplug_cpu(cpu);
>>>>>> arch/sh/kernel/topology.c:        c->hotpluggable = 1;
>>>>>> arch/ia64/kernel/topology.c:     * CPEI target, then it is hotpluggable
>>>>>> arch/ia64/kernel/topology.c:        sysfs_cpus[num].cpu.hotpluggable = 1;
>>>>>> arch/xtensa/kernel/setup.c:        cpu->hotpluggable = !!i;
>>>>>> arch/s390/kernel/smp.c:    c->hotpluggable = 1;
>>>>>> arch/mips/kernel/topology.c:        c->hotpluggable = 1;
>>>>>> arch/arm64/kernel/cpuinfo.c: * In case the boot CPU is hotpluggable,
>>>>>> we record its initial state and
>>>>>> arch/arm64/kernel/setup.c:        cpu->hotpluggable = cpu_can_disable(i);
>>>>>> arch/x86/kernel/topology.c:        per_cpu(cpu_devices,
>>>>>> num).cpu.hotpluggable = 1;
>>>>>>
>>>>>> On Thu, Jul 16, 2020 at 6:38 PM Huacai Chen <chenhc@lemote.com> wrote:
>>>>>>> Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
>>>>>>> /system/cpu/cpu0/online which confuses some user-space tools.
>>>>> What userspace tools are confused by this?  They should be able to
>>>>> handle a cpu not being able to be removed, right?
>>>> It causes ltp's "hotplug" test fails, and ltp considers CPUs with a
>>>> "online" node be hotpluggable.
>>> Is that always true?
>> Yes, someone who meet the same problem report a bug to LTP, and LTP
>> maintainer said that this should be fixed in kernel.
> So the action _always_ has to succeed and can never return an error?
> That feels wrong even for normal systems.

If that returns error then it means kernel's hotplug function is not 
working as
expected. Thus, LTP as a testsuit will consider the error as a indicator 
of malfunction
kernel.

Thanks

- Jiaxun


>
> thanks,
>
> greg k-h
