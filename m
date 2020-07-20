Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F62256E1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 07:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGTE6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 00:58:54 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:56631 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgGTE6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 00:58:53 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.156])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 0FF25200BC;
        Mon, 20 Jul 2020 04:58:50 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 78C9E3F162;
        Mon, 20 Jul 2020 06:58:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 984B02A354;
        Mon, 20 Jul 2020 00:58:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1595221127;
        bh=40VIwKJxYiI17ZU97ur/sQkBbQzspcLDrk5hBBWfQGk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tkTuQEv7dKexBo0u74Ev+WuBMVl2/Df0kdVpfLJjjrVryVub97JOcfsAUYuy+3QCY
         9pSi/vIjXtofW3J3NtPO6GdriWbSccRplZBnEhmiBIvqbEawlHvrIuoXQB8nSSHLLN
         EwWKGAFSwNQGRkgYsN5OEPKbNePxQaxF5kZJQmrY=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 31uwpQb_UYl5; Mon, 20 Jul 2020 00:58:46 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Mon, 20 Jul 2020 00:58:46 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 257E940EB8;
        Mon, 20 Jul 2020 04:58:43 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="CI5kQ2h2";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1634-142.members.linode.com [172.104.54.142])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 493A840EB8;
        Mon, 20 Jul 2020 04:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1595221112;
        bh=40VIwKJxYiI17ZU97ur/sQkBbQzspcLDrk5hBBWfQGk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CI5kQ2h2y2/fcewPU8SReDrBQWHjKBmyhfSdUKTqPbDLx+0O3eKMNqxFwLr5kMp4W
         0evNSAgN6vB/7/W5w0/mBSgL1grdiJ6NJ3EBIxiS3KwCYPp6mfYED4w7ZMfJ7eZ0Hf
         9H9HS4kDbKHsoXdpo1bj9fwysllWHgds1lRzqAxQ=
Subject: Re: [PATCH -stable] MIPS: Fix build for LTS kernel caused by
 backporting lpj adjustment
To:     Huacai Chen <chenhuacai@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "open list:MIPS" <linux-mips@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
References: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4wdxtLCAFOJE6wgAZdg+U5mquSZjHmAL_qsDaGtENbFg@mail.gmail.com>
 <34928e81-3675-0309-b020-0cb4b402dc5c@flygoat.com>
 <20200719151322.GA301242@kroah.com>
 <CAAhV-H6f0Ohx=jZL_VeC2oncW-UUMA85t5C+x84xC_NZs83jNA@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <b9828040-5298-9235-b790-855de6cb497c@flygoat.com>
Date:   Mon, 20 Jul 2020 12:58:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6f0Ohx=jZL_VeC2oncW-UUMA85t5C+x84xC_NZs83jNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 257E940EB8
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[5];
         ML_SERVERS(-3.10)[148.251.23.173];
         TO_DN_ALL(0.00)[];
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


在 2020/7/20 上午9:42, Huacai Chen 写道:
> Hi, Greg,
>
> On Sun, Jul 19, 2020 at 11:13 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Sun, Jul 19, 2020 at 10:51:11PM +0800, Jiaxun Yang wrote:
>>> 在 2020/7/19 上午11:24, Huacai Chen 写道:
>>>> Hi, Serge,
>>>>
>>>> Could you please have a look at this patch?
>>>
>>> + Gregkh
>>>
>>> This is urgent for next stable release, please take a look.
>> Relax, it was only sent 3 days ago, we will get to this...


Ahh, sorry for the rush~


>>
>> Also, why was this not caught by any of the testing systems that we
>> have?  That might be good to determine so we don't mess up again in the
>> future.
> I think that is because CPUFREQ is disabled by default on MIPS.


Yeah, I'm working with kernel-ci to get more config covered.

Thanks.

- Jiaxun


>
> Huacai
>
>> thanks,
>>
>> greg k-h
