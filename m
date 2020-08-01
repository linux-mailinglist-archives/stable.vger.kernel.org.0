Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EBD2351EC
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgHALu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 07:50:26 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:41897 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgHALu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 07:50:26 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.156])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 9D3BF26296
        for <stable@vger.kernel.org>; Sat,  1 Aug 2020 11:50:23 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 667B33F162;
        Sat,  1 Aug 2020 13:50:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 9AF8C2A3B2;
        Sat,  1 Aug 2020 07:50:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596282618;
        bh=8stJeU1JaeICFuJ0m/0jw1gT9hV+yMuPxvpauFH4FoQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=cPTOmB+1UGzT9b50PLPB/X7pTpxKi4T4zlmmRCbi5iaFCh4H6BVZC+CdWTNGjbj/s
         uhxGO62pj3UgBGjWv40N4wz8R62CJm9yTiEEWiT4gKaiCXAV5Nvi1ro9+8tkt9yy3a
         4mWCXEFxv0HkK/CbrIJH+6b5jSdwLCwFVGjFiXkY=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DG-XeRu9YRfN; Sat,  1 Aug 2020 07:50:17 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sat,  1 Aug 2020 07:50:16 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id C01BB40840;
        Sat,  1 Aug 2020 11:50:13 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="r2kZr1LX";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [127.0.0.1] (unknown [223.104.246.221])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 2C6C840840;
        Sat,  1 Aug 2020 11:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596282536;
        bh=8stJeU1JaeICFuJ0m/0jw1gT9hV+yMuPxvpauFH4FoQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=r2kZr1LXvikYshKh9b+cHQigc89uIwfx9HjHZYu/kjboKdWWl8oEIOcmCcKTktXWm
         IY24VPjCsh1rY6qOTOpdfRhnftJFQi7Ldd6/0foYsdenPEGxskTXIagXpjlh8NU/Va
         sdbrOn/4pl+OyXlI6uZ0zSAjwMFkOJG/q9rwFPW0=
Date:   Sat, 01 Aug 2020 19:48:48 +0800
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     stable@vger.kernel.org, linux-mips@vger.kernel.org,
        chenhc@lemote.com
Subject: Re: [PATCH stable] MIPS: Loongson: Introduce and use loongson_llsc_mb()
User-Agent: K-9 Mail for Android
In-Reply-To: <20200801102646.GA3046974@kroah.com>
References: <20200801063443.1438289-1-jiaxun.yang@flygoat.com> <20200801102646.GA3046974@kroah.com>
Message-ID: <5E555C31-EA38-456E-BB5D-263A54647873@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C01BB40840
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[223.104.246.221:received];
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



=E4=BA=8E 2020=E5=B9=B48=E6=9C=881=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=886:=
26:46, Greg KH <gregkh@linuxfoundation=2Eorg> =E5=86=99=E5=88=B0:
>On Sat, Aug 01, 2020 at 02:34:43PM +0800, Jiaxun Yang wrote:
>> From: Huacai Chen <chenhc@lemote=2Ecom>
>>=20
>> commit e02e07e3127d8aec1f4bcdfb2fc52a2d99b4859e upstream=2E
>>=20
>> On the Loongson-2G/2H/3A/3B there is a hardware flaw that ll/sc and
>> lld/scd is very weak ordering=2E We should add sync instructions "befor=
e
>> each ll/lld" and "at the branch-target between ll/sc" to workaround=2E
>> Otherwise, this flaw will cause deadlock occasionally (e=2Eg=2E when do=
ing
>> heavy load test with LTP)=2E
>>=20
>> Below is the explaination of CPU designer:
>>=20
>> "For Loongson 3 family, when a memory access instruction (load, store,
>> or prefetch)'s executing occurs between the execution of LL and SC, the
>> success or failure of SC is not predictable=2E Although programmer woul=
d
>> not insert memory access instructions between LL and SC, the memory
>> instructions before LL in program-order, may dynamically executed
>> between the execution of LL/SC, so a memory fence (SYNC) is needed
>> before LL/LLD to avoid this situation=2E
>>=20
>> Since Loongson-3A R2 (3A2000), we have improved our hardware design to
>> handle this case=2E But we later deduce a rarely circumstance that some
>> speculatively executed memory instructions due to branch misprediction
>> between LL/SC still fall into the above case, so a memory fence (SYNC)
>> at branch-target (if its target is not between LL/SC) is needed for
>> Loongson 3A1000, 3B1500, 3A2000 and 3A3000=2E
>>=20
>> Our processor is continually evolving and we aim to to remove all these
>> workaround-SYNCs around LL/SC for new-come processor=2E"
>>=20
>> Here is an example:
>>=20
>> Both cpu1 and cpu2 simutaneously run atomic_add by 1 on same atomic var=
,
>> this bug cause both 'sc' run by two cpus (in atomic_add) succeed at sam=
e
>> time('sc' return 1), and the variable is only *added by 1*, sometimes,
>> which is wrong and unacceptable(it should be added by 2)=2E
>>=20
>> Why disable fix-loongson3-llsc in compiler?
>> Because compiler fix will cause problems in kernel's __ex_table section=
=2E
>>=20
>> This patch fix all the cases in kernel, but:
>>=20
>> +=2E the fix at the end of futex_atomic_cmpxchg_inatomic is for branch-=
target
>> of 'bne', there other cases which smp_mb__before_llsc() and smp_llsc_mb=
() fix
>> the ll and branch-target coincidently such as atomic_sub_if_positive/
>> cmpxchg/xchg, just like this one=2E
>>=20
>> +=2E Loongson 3 does support CONFIG_EDAC_ATOMIC_SCRUB, so no need to to=
uch
>> edac=2Eh
>>=20
>> +=2E local_ops and cmpxchg_local should not be affected by this bug sin=
ce
>> only the owner can write=2E
>>=20
>> +=2E mips_atomic_set for syscall=2Ec is deprecated and rarely used, jus=
t let
>> it go
>>=20
>> Signed-off-by: Huacai Chen <chenhc@lemote=2Ecom>
>> Signed-off-by: Huang Pei <huangpei@loongson=2Ecn>
>> [paul=2Eburton@mips=2Ecom:
>>   - Simplify the addition of -mno-fix-loongson3-llsc to cflags, and add
>>     a comment describing why it's there=2E
>>   - Make loongson_llsc_mb() a no-op when
>>     CONFIG_CPU_LOONGSON3_WORKAROUNDS=3Dn, rather than a compiler memory
>>     barrier=2E
>>   - Add a comment describing the bug & how loongson_llsc_mb() helps
>>     in asm/barrier=2Eh=2E]
>> Signed-off-by: Paul Burton <paul=2Eburton@mips=2Ecom>
>> Signed-off-by: Jiaxun Yang <jiaxun=2Eyang@flygoat=2Ecom>
>> Cc: Ralf Baechle <ralf@linux-mips=2Eorg>
>> Cc: ambrosehua@gmail=2Ecom
>> Cc: Steven J =2E Hill <Steven=2EHill@cavium=2Ecom>
>> Cc: linux-mips@linux-mips=2Eorg
>> Cc: Fuxin Zhang <zhangfx@lemote=2Ecom>
>> Cc: Zhangjin Wu <wuzhangjin@gmail=2Ecom>
>> Cc: Li Xuefeng <lixuefeng@loongson=2Ecn>
>> Cc: Xu Chenghua <xuchenghua@loongson=2Ecn>
>> Cc: stable@vger=2Ekernel=2Eorg # 4=2E19
>>=20
>> ---
>> Backport to stable according to request from Debian downstream=2E
>
>What do you mean by "request"?

Debian guys asked us to backport this to ensure the system stability on "b=
uster" release if possible=2E

>
>This feels like a new feature, why can't people just use the 5=2E4 kernel
>or newer?  Given that this issue has been fixed upstream for 1 1/2
>years, why does it need to go to the 4=2E19=2Ey stable kernel now?

It is a workaround of certain hardware bug=2E=2E=2E
Just because we've been asked by downstren why 4=2E19 can't run flawlessly=
 on certain systems=2E=2E=2E


Thanks=2E

>
>thanks,
>
>greg k-h

--=20
Jiaxun Yang
