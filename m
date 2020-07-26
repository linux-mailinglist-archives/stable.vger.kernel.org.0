Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F328422DE92
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgGZLbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 07:31:00 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:52907 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgGZLbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 07:31:00 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 641D126279
        for <stable@vger.kernel.org>; Sun, 26 Jul 2020 11:30:57 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 173723F1D0;
        Sun, 26 Jul 2020 13:30:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 36CE52A3B7;
        Sun, 26 Jul 2020 07:30:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1595763054;
        bh=BQBNLqQjWunDlwa1PfunSQHbTvmqp5JOyLBK9bljwJc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bK3iJM4d4WVI3yw9FT+ExQ9UAb3REl0Uq27ytxbqrVHE7esJ6zcNhxihJ4xu9pqr4
         DcWdb0DYiwtHgJKMN+oHKIoOPwRmX8vw8AXxlE9J9Q9pxLdOqHVkmezhNaYhAirLHM
         EKyNh8/fbAUnGO3ZM6LCjv7KuUAfumdxMQXgu6BY=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3LOCLbww_218; Sun, 26 Jul 2020 07:30:51 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 26 Jul 2020 07:30:51 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 674D0414BE;
        Sun, 26 Jul 2020 11:30:48 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="lkpDQ8VX";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li161-247.members.linode.com [173.230.151.247])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id EA5B3414BE;
        Sun, 26 Jul 2020 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1595763017;
        bh=BQBNLqQjWunDlwa1PfunSQHbTvmqp5JOyLBK9bljwJc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lkpDQ8VXnleWwbNNxDpo2KBD8SCnOqdDW42o4rWEM/Vf9OWcXLOtalK9iViMtivL4
         RZu72DjbBsO9vM7z9FzX4HmLyzRmgnfzZtGKQ7zK99d5ns1RZr+5GbW8Lx5xtnaf+t
         4yvvpdA9n9PITzOesNJkZMztCtXT+BkLvXnIxEiE=
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        stable <stable@vger.kernel.org>
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com>
 <20200726082501.GC5032@alpha.franken.de>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <9b87ae28-a818-3c82-796a-d3dfca4a73cc@flygoat.com>
Date:   Sun, 26 Jul 2020 19:30:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200726082501.GC5032@alpha.franken.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 674D0414BE
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[148.251.23.173];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[alpha.franken.de,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[vger.kernel.org,lemote.com,gmail.com];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2020/7/26 ÏÂÎç4:25, Thomas Bogendoerfer Ð´µÀ:
> On Sat, Jul 25, 2020 at 02:37:52PM +0800, Huacai Chen wrote:
>> Hi, Thomas,
>>
>> What do you think about this patch? Other archs also do the same thing
>> except those support hotplug CPU#0.
> I'm ok with the patch, I'm just wondering if this is a hardware or
> software limitation. If it's the latter, what needs to be done to
> support it ?

It should be a software limitation, x86 have already deal with that [1].
But there is no reason to spend extra effort on CPU0 hotplug. I don't 
think any user is expecting this feature.

Thanks.

[1]: 
https://events.static.linuxfound.org/sites/events/files/lcjpcojp13_fenghua.pdf

- Jiaxun
>
> Thomas.
>
