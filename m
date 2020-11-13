Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CFE2B1446
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 03:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKMCab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 21:30:31 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:49884 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgKMCab (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 21:30:31 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 7616720DF3
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 02:30:29 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id CB2342008F;
        Fri, 13 Nov 2020 02:30:25 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id B41DD3F157;
        Fri, 13 Nov 2020 02:30:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 980DE2A34E;
        Thu, 12 Nov 2020 21:30:23 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1605234623;
        bh=jjkA70crZr53oOsQo8H39Ad7cEMWDse6NYHaxO3xobs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Xi/ImM2aNooaZF6y1jphX17jLeaNs7TuKNV9bv3DUULsbA1TzpPPoC9nP/plFGkTF
         I0imMEDUkSMOtURY/g4oGkrfGMhU+gCxQc2z+KSuLU/ZNmxAVHFKK58YygaNCmcOsY
         l/xpijMN3C9zndKCVW9lUpZPZl+YQt/RhzEhA5o0=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wXCsZvpMM80z; Thu, 12 Nov 2020 21:30:20 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Thu, 12 Nov 2020 21:30:20 -0500 (EST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id BAE7D41F47;
        Fri, 13 Nov 2020 02:30:19 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="vQBPOLEv";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [113.52.132.214])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 2E524400D1;
        Fri, 13 Nov 2020 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1605234615;
        bh=jjkA70crZr53oOsQo8H39Ad7cEMWDse6NYHaxO3xobs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vQBPOLEvr3WmDoyP6UholxzEFKc84BEzGx2CUGpTq92okF6g/7ZLobQeajUCxzK7Z
         g7b7Zrr9KUxy3CuQDlitzlnE2ra/ic+JIcNWPVt1n8Qqyf/twJxs745LL1otexT5jC
         TJqErW53MSLSnVYS5nmI0iXji1ctF50ArseT5rGg=
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
To:     Serge Semin <fancer.lancer@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com>
Date:   Fri, 13 Nov 2020 10:30:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201111145240.lok3q5g3pgcvknqr@mobilestation>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BAE7D41F47
X-Spamd-Result: default: False [4.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         RECEIVED_SPAMHAUS_XBL(3.00)[113.52.132.214:received];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         ARC_NA(0.00)[];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[7];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[gmail.com,nokia.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Server: mail20.mymailcheap.com
X-Spam: Yes
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

ÔÚ 2020/11/11 22:52, Serge Semin Ð´µÀ:
> Hello Alexander
>
> On Tue, Nov 10, 2020 at 11:29:50AM +0100, Alexander Sverdlin wrote:
> 2) The check_kernel_sections_mem() method can be removed. But it
> should be done carefully. We at least need to try to find all the
> platforms, which rely on its functionality.
It have been more than 10 years since introducing this this check, but
I believe there must be a reason at the time.

Also currently we have some unmaintained platform and it's impossible
to test on them for us.

For Cavium's issue, I believe removing the page rounding can help.
I'd suggest keep this method but remove the rounding part, also
leave a warning or kernel taint when out of boundary kernel image
is detected.

Thanks.

- Jiaxun

>
> -Sergey
>
>> -- 
>> Best regards,
>> Alexander Sverdlin.
