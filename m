Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87782403FD
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 11:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgHJJ31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 05:29:27 -0400
Received: from relay3.mymailcheap.com ([217.182.119.155]:44026 "EHLO
        relay3.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHJJ30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 05:29:26 -0400
X-Greylist: delayed 150766 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2020 05:29:24 EDT
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 8EA2F3ECDF;
        Mon, 10 Aug 2020 11:29:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 6F1F92A90D;
        Mon, 10 Aug 2020 11:29:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1597051762;
        bh=ajPC80A6re42zk6C2RqsuWoZv/JuYF9JXb7BeN0rCJY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=J/GcO89ruZSSz+M/Yskcb+FHUKzuwxa2JmR0n2atv2aAvpXOWhUjC8MEXQvVI1BsK
         xIpPg7BN1ZCF4wecKW6XMGYsuFrNRY3Tpp+5XdFNHtjM5goUS3wKefrmYq0aL1tnv/
         qevjSyyFBLf6hfPM9Q6bmJo8lumhvbeVsIh19wVQ=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jxhYxYNCF69A; Mon, 10 Aug 2020 11:29:20 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon, 10 Aug 2020 11:29:20 +0200 (CEST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 41E20419DF;
        Mon, 10 Aug 2020 09:29:20 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="WWucQg1J";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (n11212042148.netvigator.com [112.120.42.148])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 7711B4259F;
        Mon, 10 Aug 2020 09:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1597051752;
        bh=ajPC80A6re42zk6C2RqsuWoZv/JuYF9JXb7BeN0rCJY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WWucQg1JsBA40NlHT9YegQkZfhkfjpS/NMPL2/oYfxN088UhRgW/g5CKx438UEDcr
         B6YIbRV4E+PCmz4gjG1odJWg3fCjm/8m+HP8YSp2zy9pIvaSxe4zcpJUp/at/ZFil9
         NjJI12E8Uj8Emih7JgWZH5lkSzwq76/qpb6W4sao=
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
To:     Greg KH <greg@kroah.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200810074417.GA1529187@kroah.com>
 <5522eef8-0da5-7f73-b2f8-2d0c19bb5819@redhat.com>
 <20200810090310.GA1837172@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <8bebfd76-da02-6208-7966-c82dceec9904@flygoat.com>
Date:   Mon, 10 Aug 2020 17:29:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810090310.GA1837172@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 41E20419DF
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
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[10];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[lemote.com,alpha.franken.de,gmail.com,vger.kernel.org];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2020/8/10 ÏÂÎç5:03, Greg KH Ð´µÀ:
> On Mon, Aug 10, 2020 at 10:56:48AM +0200, Paolo Bonzini wrote:
>> On 10/08/20 09:44, Greg KH wrote:
>>>> There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
>>>> more #include "loongson_regs.h" in arch/mips.  So while I agree with
>>>> Greg that this idiom is quite unusual, it seems to be the expected way
>>>> to use this header.  I queued the patch.
>>> Or you all could fix it up to work properly like all other #include
>>> lines in the kernel source tree.  There's no reason mips should be
>>> "special" here, right?
>> It's not just this #include, there's a couple dozen mach-* directories;
>> changing how they work would be up to the MIPS maintainers (CCed), and
>> it would certainly not be a patch that can be merged in stable@ kernels.
>>
>> arch/mips/kernel/cpu-probe.c has the same
>>
>> #ifdef CONFIG_CPU_LOONGSON64
>> #include <loongson_regs.h>
>>
>> for example, so apparently they're good with this.  So if I don't pick
>> up the patch to fix the build it would be in all likelihood merged by
>> MIPS maintainers.  The only difference will be how long the build
>> remains broken and the fact that they need to worry about KVM despite
>> the presence of a specific maintainer.
> Ok, fair enough, but in the long-run, this should probably be fixed up
> "properly" if this arch is still being maintained.

MIPS is using another approach to management machine specified headers.
It changes include path per-machine to get ride of the generic one.

I'm a little bit confused about the proper way to do that. I thought the 
design
overall, is just fine.

Should we try to migrate it to another style?

Thanks.

- Jiaxun
>
> thanks,
>
> greg k-h
