Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57022352AF
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHAOMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 10:12:31 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:42139 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgHAOMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 10:12:30 -0400
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 8A5602629A;
        Sat,  1 Aug 2020 14:12:27 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id A365B3F157;
        Sat,  1 Aug 2020 10:12:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 878752A0F5;
        Sat,  1 Aug 2020 10:12:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596291145;
        bh=OSGVx1OtfFaKm8I8w0sADt6AbrW06K823pohmEJXZaA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=zICQR9RBgGqSVJ4FCYoejj4R437T7CTR3NRIFQ8pEC6zSAOHq87M2VDNW/PbdJTi5
         kZKU101u/u5dvo6DSDYS8q14jk7epmuY7sx8hhva103+Sgb2YDWwSEwDNzyJVTCrqP
         Rng+nrVa1sTwNzwIBhEUshQiH5gREh9/3e2n7Af8=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tCooTDCgbF29; Sat,  1 Aug 2020 10:12:23 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sat,  1 Aug 2020 10:12:23 -0400 (EDT)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 19D3940846;
        Sat,  1 Aug 2020 14:12:22 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="KZ+9o9jS";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (n11212042148.netvigator.com [112.120.42.148])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 3827A40840;
        Sat,  1 Aug 2020 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596291092;
        bh=OSGVx1OtfFaKm8I8w0sADt6AbrW06K823pohmEJXZaA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KZ+9o9jSmAFY9h9weLfEvAYF7LI5MaldTxVXNHhcmEwAA1t+5tIv61fNYO5HeQlFD
         JfXZxqNVAgjxP9WmSaoZOJoVKZrznTlZgcbkmva7MSbXZhv0snJuPmE6svK/712KIE
         OgvYq+HPkhffTvI1J3VlLKWLQFCvfs5/lbSvXRqA=
Subject: Re: [PATCH stable] MIPS: Loongson: Introduce and use
 loongson_llsc_mb()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-mips@vger.kernel.org,
        chenhc@lemote.com
References: <20200801063443.1438289-1-jiaxun.yang@flygoat.com>
 <20200801102646.GA3046974@kroah.com>
 <5E555C31-EA38-456E-BB5D-263A54647873@flygoat.com>
 <20200801120459.GA506427@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <1b535cbd-b4b9-68a2-5e85-8cbcfcdbcf9a@flygoat.com>
Date:   Sat, 1 Aug 2020 22:11:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200801120459.GA506427@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 19D3940846
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
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2020/8/1 下午8:04, Greg KH 写道:
> On Sat, Aug 01, 2020 at 07:48:48PM +0800, Jiaxun Yang wrote:
>>
>> 于 2020年8月1日 GMT+08:00 下午6:26:46, Greg KH <gregkh@linuxfoundation.org> 写到:
>>> On Sat, Aug 01, 2020 at 02:34:43PM +0800, Jiaxun Yang wrote:
>>>> From: Huacai Chen <chenhc@lemote.com>
>>>>
>>>> commit e02e07e3127d8aec1f4bcdfb2fc52a2d99b4859e upstream.
>>>>
>>>> On the Loongson-2G/2H/3A/3B there is a hardware flaw that ll/sc and
>>>> lld/scd is very weak ordering. We should add sync instructions "before
>>>> each ll/lld" and "at the branch-target between ll/sc" to workaround.
>>>> Otherwise, this flaw will cause deadlock occasionally (e.g. when doing
>>>> heavy load test with LTP).
>>>>
>>>> Below is the explaination of CPU designer:
>>>>
>>>> "For Loongson 3 family, when a memory access instruction (load, store,
>>>> or prefetch)'s executing occurs between the execution of LL and SC, the
>>>> success or failure of SC is not predictable. Although programmer would
>>>> not insert memory access instructions between LL and SC, the memory
>>>> instructions before LL in program-order, may dynamically executed
>>>> between the execution of LL/SC, so a memory fence (SYNC) is needed
>>>> before LL/LLD to avoid this situation.
>>>>
>>>> Since Loongson-3A R2 (3A2000), we have improved our hardware design to
>>>> handle this case. But we later deduce a rarely circumstance that some
>>>> speculatively executed memory instructions due to branch misprediction
>>>> between LL/SC still fall into the above case, so a memory fence (SYNC)
>>>> at branch-target (if its target is not between LL/SC) is needed for
>>>> Loongson 3A1000, 3B1500, 3A2000 and 3A3000.
>>>>
>>>> Our processor is continually evolving and we aim to to remove all these
>>>> workaround-SYNCs around LL/SC for new-come processor."
>>>>
>>>> Here is an example:
>>>>
>>>> Both cpu1 and cpu2 simutaneously run atomic_add by 1 on same atomic var,
>>>> this bug cause both 'sc' run by two cpus (in atomic_add) succeed at same
>>>> time('sc' return 1), and the variable is only *added by 1*, sometimes,
>>>> which is wrong and unacceptable(it should be added by 2).
>>>>
>>>> Why disable fix-loongson3-llsc in compiler?
>>>> Because compiler fix will cause problems in kernel's __ex_table section.
>>>>
>>>> This patch fix all the cases in kernel, but:
>>>>
>>>> +. the fix at the end of futex_atomic_cmpxchg_inatomic is for branch-target
>>>> of 'bne', there other cases which smp_mb__before_llsc() and smp_llsc_mb() fix
>>>> the ll and branch-target coincidently such as atomic_sub_if_positive/
>>>> cmpxchg/xchg, just like this one.
>>>>
>>>> +. Loongson 3 does support CONFIG_EDAC_ATOMIC_SCRUB, so no need to touch
>>>> edac.h
>>>>
>>>> +. local_ops and cmpxchg_local should not be affected by this bug since
>>>> only the owner can write.
>>>>
>>>> +. mips_atomic_set for syscall.c is deprecated and rarely used, just let
>>>> it go
>>>>
>>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>>>> Signed-off-by: Huang Pei <huangpei@loongson.cn>
>>>> [paul.burton@mips.com:
>>>>    - Simplify the addition of -mno-fix-loongson3-llsc to cflags, and add
>>>>      a comment describing why it's there.
>>>>    - Make loongson_llsc_mb() a no-op when
>>>>      CONFIG_CPU_LOONGSON3_WORKAROUNDS=n, rather than a compiler memory
>>>>      barrier.
>>>>    - Add a comment describing the bug & how loongson_llsc_mb() helps
>>>>      in asm/barrier.h.]
>>>> Signed-off-by: Paul Burton <paul.burton@mips.com>
>>>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>>>> Cc: Ralf Baechle <ralf@linux-mips.org>
>>>> Cc: ambrosehua@gmail.com
>>>> Cc: Steven J . Hill <Steven.Hill@cavium.com>
>>>> Cc: linux-mips@linux-mips.org
>>>> Cc: Fuxin Zhang <zhangfx@lemote.com>
>>>> Cc: Zhangjin Wu <wuzhangjin@gmail.com>
>>>> Cc: Li Xuefeng <lixuefeng@loongson.cn>
>>>> Cc: Xu Chenghua <xuchenghua@loongson.cn>
>>>> Cc: stable@vger.kernel.org # 4.19
>>>>
>>>> ---
>>>> Backport to stable according to request from Debian downstream.
>>> What do you mean by "request"?
>> Debian guys asked us to backport this to ensure the system stability on "buster" release if possible.
> Who is "Debian guys"?  And why can't they just add this to their kernel?

Hmm I just got this request from #debian-mips channel, they're tracing a 
deadlock
issue and thought this might be the root cause. So they thought deal 
with it in upstream
stable version may benefit users.

>
>>> This feels like a new feature, why can't people just use the 5.4 kernel
>>> or newer?  Given that this issue has been fixed upstream for 1 1/2
>>> years, why does it need to go to the 4.19.y stable kernel now?
>> It is a workaround of certain hardware bug...
>> Just because we've been asked by downstren why 4.19 can't run flawlessly on certain systems...
> What is wrong with those affected users running 5.0 or newer kernels?
Well, distros can only ship selected stable kernel by default.
And according to Debian's kernel upstream policy that won't apply this 
kind of patch
without accepted by upstream stable.

> So is this a bugfix or a new feature, I can't determine this...
>
> It feels "big" for a 4.19.y kernel patch at this point in time, don't
> you think?
Agreed, it's not generally a good idea. I should withdraw this patch.

Thanks.

- Jiaxun

>
> thanks,
>
> greg k-h
