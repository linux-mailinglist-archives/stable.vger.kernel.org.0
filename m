Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F7323F814
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgHHPgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 11:36:44 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:60000 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgHHPgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 11:36:44 -0400
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id DD9FC26071;
        Sat,  8 Aug 2020 15:36:40 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 47ACA3F1CC;
        Sat,  8 Aug 2020 17:36:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 854592A0FA;
        Sat,  8 Aug 2020 11:36:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596900996;
        bh=xTHmmWbJYn3DJqIfOvyTzLoBnhl+h9i9sDegUtx8360=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YVI7dwqDIcii02o8w+mlKeA1x9DaqkC8/vPUmGRc3tlCpLoA59YogUvWY98nIvEtv
         eNGJRXtbJ3s0ad+CLmaCMTO9R8SORx2qvC8LDRe1eh1ZF27T5mU5MgUOANuXZ3orKc
         PEqEChhmqgNZkqBI470aVUQJCFeVfoOvqlX8cRBs=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GY-ZZec7x3dE; Sat,  8 Aug 2020 11:36:35 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sat,  8 Aug 2020 11:36:35 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 42A2F419E4;
        Sat,  8 Aug 2020 15:36:31 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="gPia8sjH";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1000-254.members.linode.com [45.33.50.254])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 9869A425AA;
        Sat,  8 Aug 2020 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596900969;
        bh=xTHmmWbJYn3DJqIfOvyTzLoBnhl+h9i9sDegUtx8360=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gPia8sjHVJReT9gRMKcq5QcVEHxwsR+ptLFaoyKsuGfy5wBTvIke5xpQ3YikAq/Bn
         zfvQqF7s82XteCAWbtLPc/gNe8Zp0yE1jsZvNhWSMRZW6D6+JvFE4ticSNCBAoJ06o
         g98Wmc0zhjcugedDFyroGcS9K29qKroUbxzTJ5bg=
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
To:     Greg KH <greg@kroah.com>, Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
Date:   Sat, 8 Aug 2020 23:35:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200808153123.GC369184@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 42A2F419E4
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[10];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[redhat.com,alpha.franken.de,gmail.com,vger.kernel.org,lemote.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2020/8/8 ÏÂÎç11:31, Greg KH Ð´µÀ:
> On Sat, Aug 08, 2020 at 08:50:52PM +0800, Huacai Chen wrote:
>> Only Loongson64 platform has and needs loongson_regs.h, including it
>> unconditionally will cause build errors.
>>
>> Fixes: 7f2a83f1c2a941ebfee5 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
>> Cc: stable@vger.kernel.org
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> ---
>>   arch/mips/kvm/vz.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
>> index 3932f76..a474578 100644
>> --- a/arch/mips/kvm/vz.c
>> +++ b/arch/mips/kvm/vz.c
>> @@ -29,7 +29,9 @@
>>   #include <linux/kvm_host.h>
>>   
>>   #include "interrupt.h"
>> +#ifdef CONFIG_CPU_LOONGSON64
>>   #include "loongson_regs.h"
>> +#endif
> The fix for this should be in the .h file, no #ifdef should be needed in
> a .c file.

The header file can only be reached when CONFIG_CPU_LOONGSON64 is 
selected...
Otherwise the include path of this file won't be a part of CFLAGS.

Thanks.

- Jiaxun

>
> thanks,
>
> greg k-h
