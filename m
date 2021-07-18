Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B97A3CCAFC
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhGRVjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 17:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhGRVjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 17:39:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B362C061762;
        Sun, 18 Jul 2021 14:36:42 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l6so9146210wmq.0;
        Sun, 18 Jul 2021 14:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TvIEPFl+F+P1NgPFrOx7C+hzgF78kqRRe5XTxIq3UqM=;
        b=tbcNiPA0zPQU0QbM6mZjNFZI3fI7/Tyva/zbSxE1j1K1d6TwNgDHCeWhtqD9Myl9a5
         5e6TmCYFkTpWtBNbS8dATZAMTdzDX7DzVUHhlo8+s9XBMoAeUW+ArG4DlLuoYF4ZXQA4
         72eKcUs7gBrFAHYfNS90mExwyMg1hx0x9d5DCquiDcBNq2Ek7DK27wF/pXFgeZXRjvBz
         QKWnayzMdvVvOUmBwRpuo/XN2T+WpTbXtnlduvzy81xOV2vnNFqzco1FbxohprWAfUcZ
         IUXhCdGXFn4M0wkaigt9q6o2B3pBaYbicueBZEf564GVFqbg3nMaEYQjfjyuTfne9Lcx
         U1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TvIEPFl+F+P1NgPFrOx7C+hzgF78kqRRe5XTxIq3UqM=;
        b=BuS9dPAIMTGhW9i8t5aW3y7VKwF+Je5fiA6iCiq7l7359cSfkER+fxNJFfCQRv8C7n
         VLUHXIdf4lgu0+hviNl4dasVPGnt/moPvlIiO+ldldB0+oX0BoPgjYfOXwHrzH5DVSGn
         Z+pbU1XIlU0Aa9T7mrT1/YyK61WsJWPxugD+FvoydHns3nEfn1hdsu2FbKn+MKeRKe1Q
         5noyC2A/GcUVhj3uooHntC+sbv7AzPsKvQrykbfK0PSWL3h5AL8dTw2wWif1ngHgh4aH
         83X/IszUjrO7STterAzi67sN10c17XPjhCw/fmX5Z7L9gAgVjadIbJYu2LWUONpKEjjy
         ZBDg==
X-Gm-Message-State: AOAM532c/ionERPl9ZVBiA8BH8LOW8YMLa42mRQgtRVrDW4n5hD1lSFv
        bQh+0xtRTdFS1+SEo6a5tethJMBrZUHEwWGtMZA=
X-Google-Smtp-Source: ABdhPJz7Y+UGelUexm0aRKstpx90z01sMxf4ifX4cUombHYhsE7LBVAiXT/95JC1ddxUVN+2eooV1w==
X-Received: by 2002:a7b:ca59:: with SMTP id m25mr28737082wml.74.1626644200469;
        Sun, 18 Jul 2021 14:36:40 -0700 (PDT)
Received: from [192.168.1.10] ([94.10.31.26])
        by smtp.googlemail.com with ESMTPSA id s17sm18435340wrv.2.2021.07.18.14.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 14:36:39 -0700 (PDT)
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     Matthew Wilcox <willy@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Rankin <rankincj@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <YPSbjXrBYsRZagAv@casper.infradead.org>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <f2a2c82b-bd5b-5ddb-1be5-4b5dcab5daf6@googlemail.com>
Date:   Sun, 18 Jul 2021 22:36:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPSbjXrBYsRZagAv@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 18/07/2021 22:22, Matthew Wilcox wrote:
> On Sun, Jul 18, 2021 at 11:03:51PM +0200, Oleksandr Natalenko wrote:
>> + stable@vger.kernel.org
>>
>> On neděle 18. července 2021 23:01:24 CEST Oleksandr Natalenko wrote:
>>> Hello.
>>>
>>> On sobota 17. července 2021 22:22:08 CEST Chris Clayton wrote:
>>>> I checked the output from dmesg yesterday and found the following warning:
>>>>
>>>> [Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
>>>> [Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at
>>>> kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0 [Fri Jul
> 
> Could you run ./scripts/faddr2line vmlinux rcu_note_context_switch+0x37/0x3d0
> 
$ ./scripts/faddr2line vmlinux rcu_note_context_switch+0x37/0x3d0
rcu_note_context_switch+0x37/0x3d0:
rcu_note_context_switch at ??:?

>>>> [Fri Jul 16 09:15:29 2021] Call Trace:
>>>> [Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
>>>> [Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
>>>> [Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
>>>> [Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
>>>> [Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
>>>> [Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
>>>> [Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
>>>> [Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
>>>> [Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170
> 
> You were handling a page fault at the time.  The page you wanted was
> on swap and this warning fired as a result of waiting for the page
> to come back in from swap.  There are a number of warnings in that
> function, so it'd be good to track down exactly which one it is.
> 
