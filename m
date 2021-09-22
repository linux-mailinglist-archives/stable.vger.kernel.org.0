Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93EA414DD5
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhIVQN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 12:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbhIVQN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 12:13:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726F7C061574;
        Wed, 22 Sep 2021 09:12:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so2680425pjb.4;
        Wed, 22 Sep 2021 09:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZINFEPPh5tg9DcuNidDp1iGsjEhXUfCCil0bzDOEJ+A=;
        b=Bsql6hS/N+ovN75mrNVkPa428mUsRoN6xdFG3tmvlK2WZPnGno+Bbg5Whs6NzJZbq8
         L03Xh1/RJMaWg7ulP4XR5GToMa1z8gaWh9KdjVncLaF11zzGgIG0mzZpDqlaqfpvw819
         2gnLm8weaKGzwoBJat1IiRb9KDbB+P+/IPjRcWW64NoCl0otFek4BVHPCj3rsLcXIwU4
         FJMxRyX2W7/v0ActDNgd00u/sRWYREEN7taJQ4rMIIiFrazFQzA6NAkvkhzOcxYqeTyF
         CHsRPxPI220ZJKkpI2+FlVOixD2mjGKQWpv1gq7dggYCKhRiw7zoGD73IwTfe1PXaYGh
         YwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZINFEPPh5tg9DcuNidDp1iGsjEhXUfCCil0bzDOEJ+A=;
        b=QZVGFJ3cpPoKLbrBlB0ZNtHO7LGKTf952UxBHpKywibjLfHl+ZmIYk4isjadu4aws6
         MLGpjdeU7dp+OSP1/JzoKa+G6lUNWM+TEXdnBc4SBsncEFsnWqoBP9le+/ir/KNzN6B7
         7NWcKDzugidb7lI9ANOx4IP3Bj4xG1G71RRZ1UHdt5zmXXbUieXL5NlK/qLuQ63f35N3
         nA9whAUcw+uekCloWX4/EZ4ts2aPpGs0FPyXPxzbgzxIKBxfi3LjKtlbP/QgO81MoMb7
         hwwcoYmS5fW8DhC5KGsCFzfPQ6oA0bLrLxmsvihMLVllBHFLl00O2hmdPxwUu+G11AEK
         b/8g==
X-Gm-Message-State: AOAM5307/T3yLZ/ZVlDLbR8W+PnWEcOM2TDpeaJNo5delYeikA8DzQAl
        A6LGK/phO45RrGQy7dt+4R0=
X-Google-Smtp-Source: ABdhPJzDmGgeDok7iSg/MA/CENANSQczlBxbqQwxO576Ge3GXyi9Mc/pOxPVv3DEGTmZWfiyvSNQhg==
X-Received: by 2002:a17:902:8ec5:b0:13a:2789:cbb0 with SMTP id x5-20020a1709028ec500b0013a2789cbb0mr80225plo.60.1632327145920;
        Wed, 22 Sep 2021 09:12:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l11sm6188421pjg.22.2021.09.22.09.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:12:25 -0700 (PDT)
Subject: Re: [PATCH stable 5.10 3/3] ARM: 9079/1: ftrace: Add MODULE_PLTS
 support
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <20210922023947.59636-1-f.fainelli@gmail.com>
 <20210922023947.59636-4-f.fainelli@gmail.com>
 <d374a9ae-2dd0-3b11-d5f8-211ef3a6f991@nokia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8acd5f74-7dcb-d563-310d-01e1bd066065@gmail.com>
Date:   Wed, 22 Sep 2021 09:12:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d374a9ae-2dd0-3b11-d5f8-211ef3a6f991@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alex,

On 9/21/21 11:53 PM, Alexander Sverdlin wrote:
> Hello Florian,
> 
> On 22/09/2021 04:39, Florian Fainelli wrote:
>> From: Alex Sverdlin <alexander.sverdlin@nokia.com>
>>
>> commit 79f32b221b18c15a98507b101ef4beb52444cc6f upstream
>>
>> Teach ftrace_make_call() and ftrace_make_nop() about PLTs.
>> Teach PLT code about FTRACE and all its callbacks.
> 
> sorry for inconvenience, but I'd propose to add 6fa630bf473827ae
> "ARM: 9098/1: ftrace: MODULE_PLT: Fix build problem without DYNAMIC_FTRACE"
> to all series on this topic, because of the below chunk which might
> lead to build issues on some exotic configurations.
> 
> Link: https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZUVCQBHDMFVR7CCB7JPESLJEWERZDJ3T/

Good point, missed that one, I will add it to the stable submission and
resend, thanks!
-- 
Florian
