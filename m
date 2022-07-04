Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6235565EA5
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 22:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiGDUvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 16:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiGDUvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 16:51:39 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117941B3;
        Mon,  4 Jul 2022 13:51:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 91C1C42B99B;
        Mon,  4 Jul 2022 16:51:35 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id DH5nZT86e2OR; Mon,  4 Jul 2022 16:51:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id DB13442BC0B;
        Mon,  4 Jul 2022 16:51:34 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com DB13442BC0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1656967894;
        bh=7mvIjH+fsGN9W7SaTCreEKClSimZjLp/X1hExyb1QoA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Fogme5wXr1/dxnFRUG2swIlhESm9DzEOzjo5twMzJMnL/JJwj4c27Y88NPDsicT/k
         ZsBlzEWbIUq1+JYiuY4p8rGgAkKMJRS8VgsjROtS4duvmwwvHFQMSlORI24KET5UYl
         veO5fjKGkBeoMaknjDUTHVaG66irdMnY7uPozHS/eW9h1hIR032EwqLEZ8AE/AVk/V
         g8F2IkEF1qtVJ3kNKN1PG/7d3qoZVVwDK7qjXzN5b/oiC+BXQXaEn2pWwO7ZkmXXW5
         nmUpbkiHKZvGuqWbPWlac+erz9ipcVQgaVEZNudhXtF7tlQLua1pkDDlRpWRhgPjyA
         ulCg8M44G1ERw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d8H8Ti0b4CWj; Mon,  4 Jul 2022 16:51:34 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id C01A542B8DC;
        Mon,  4 Jul 2022 16:51:34 -0400 (EDT)
Date:   Mon, 4 Jul 2022 16:51:34 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        RAJESH DASARI <raajeshdasari@gmail.com>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1331962917.52634.1656967894704.JavaMail.zimbra@efficios.com>
In-Reply-To: <Yr2IDyuBr7DkgvdI@kroah.com>
References: <CAPXMrf-_RGYBJNu51rq2mdzcpf7Sk_z3kRNL9pmLvf4xmUkmow@mail.gmail.com> <YrlbDgpIVFvh5L9O@kroah.com> <YrnKyKiNlsqkuI6k@localhost> <Yr2IDyuBr7DkgvdI@kroah.com>
Subject: Re: Reg: rseq selftests failed on 5.4.199
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4304 (ZimbraWebClient - FF100 (Linux)/8.8.15_GA_4304)
Thread-Topic: rseq selftests failed on 5.4.199
Thread-Index: J4B3Oz4Q2/gZbpyX/hk0sLe+Vb+zng==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jun 30, 2022, at 7:25 AM, Greg Kroah-Hartman gregkh@linuxfoundation.org wrote:

> On Mon, Jun 27, 2022 at 11:20:40AM -0400, Mathieu Desnoyers wrote:
>> On 27-Jun-2022 09:23:58 AM, Greg KH wrote:
>> > On Sun, Jun 26, 2022 at 10:01:20PM +0300, RAJESH DASARI wrote:
>> > > Hi ,
>> > > 
>> > > We are running rseq selftests on 5.4.199 kernel with  glibc 2.34
>> > > version  and we see that tests are failing to compile with invalid
>> > > argument errors. When we took all the commits from
>> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/tools/testing/selftests/rseq
>> > >  related to rseq locally , test cases have passed. I see that there are
>> > > some adaptations to the latest glibc version done in those commits, is
>> > > there any plan to backport them to 5.4.x versions. Could you please
>> > > provide your inputs.
>> > 
>> > What commits specifically are you referring to please?  A list of them
>> > would be great, and if you have tested them and verified that they can
>> > be backported cleanly would also be very helpful.
>> 
>> Hi Greg,
>> 
>> Specifically related to rseq selftests, the following string of commits
>> would be relevant on top of v5.4.199. Those are not all strictly only
>> bugfixes, but they help applying the following commits without
>> conflicts. I have validated that this string of commits cherry-picks on
>> top of v5.4.199, and that the resulting selftests build fine.
>> 
>> ea366dd79c ("seq/selftests,x86_64: Add rseq_offset_deref_addv()")
>> 07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
>> 5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
>> 930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
>> 94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
>> e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
>> 886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
>> 233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with
>> glibc-2.35")
>> 24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on
>> big endian")
>> de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x"
>> for load/store")
>> 26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
>> d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
>> 94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
>> b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
>> 4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq
>> thread area")
>> 127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq
>> thread area")
>> 889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")
> 
> As many of these are newer than 5.10, can you provide a series of
> patches that should be applied to 5.4, 5.10, 5.15 and possibly 5.18 to
> resolve this issue.  We do not want anyone moving from 5.4 to a newer
> kernel and having regressions.

Hi Greg,

Here are the series of rseq selftests fixes to apply to the 5.4, 5.10, and 5.15
stable kernel series.

v5.4.203

ea366dd79c ("seq/selftests,x86_64: Add rseq_offset_deref_addv()")
07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian")
de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store")
26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area")
127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area")
889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")

v5.10.128

07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian")
de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store")
26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area")
127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area")
889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")

v5.15.52

07ad4f7629 ("selftests/rseq: remove ARRAY_SIZE define from individual tests")
5c105d55a9 ("selftests/rseq: introduce own copy of rseq uapi header")
930378d056 ("selftests/rseq: Remove useless assignment to cpu variable")
94b80a19eb ("selftests/rseq: Remove volatile from __rseq_abi")
e546cd48cc ("selftests/rseq: Introduce rseq_get_abi() helper")
886ddfba93 ("selftests/rseq: Introduce thread pointer getters")
233e667e1a ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
24d1136a29 ("selftests/rseq: Fix ppc32: wrong rseq_cs 32-bit field pointer on big endian")
de6b52a214 ("selftests/rseq: Fix ppc32 missing instruction selection "u" and "x" for load/store")
26dc8a6d8e ("selftests/rseq: Fix ppc32 offsets by using long rather than off_t")
d7ed99ade3 ("selftests/rseq: Fix warnings about #if checks of undefined tokens")
94c5cf2a0e ("selftests/rseq: Remove arm/mips asm goto compiler work-around")
b53823fb2e ("selftests/rseq: Fix: work-around asm goto compiler bugs")
4e15bb766b ("selftests/rseq: x86-64: use %fs segment selector for accessing rseq thread area")
127b6429d2 ("selftests/rseq: x86-32: use %gs segment selector for accessing rseq thread area")
889c5d60fb ("selftests/rseq: Change type of rseq_offset to ptrdiff_t")

Please note that if someone cares about getting rseq selftests to work on 4.9, 4.14 and
4.19 stable kernels with glibc 2.35+, additional commits will be needed prior to the commits
identified above. This would include commits that add rseq selftests support for additional
architectures, or to manually edit the follow up fix commits when backporting and omit the
parts applying to unsupported architectures. This is not straightforward, so I am not listing
those stable branches here.

As I identified in my prior email, there is also a patch from Michael Jeanson that would be
useful, but AFAIK it's still in -tip (not in master yet), so as per the cherry-picking rules
of stable kernels it will have to wait.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
