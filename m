Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED523CE92
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 20:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgHES1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 14:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgHES1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:27:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98580C061575;
        Wed,  5 Aug 2020 11:27:17 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z5so24984194pgb.6;
        Wed, 05 Aug 2020 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GNqXP6MnEh5m4nolFEKGmKxP/qSwA0kXzhxyqrmFooY=;
        b=ujxSNUSwrYiDPsUjtX8N8ht53GZtmGNon9RArdMeEUOk8vWTJNFHFGmbKrO32yeuKt
         eAmWFoCMd3GFNCv9CaJmeaTnlE2IZoY2ADmX5y2bVjGN/FGSRsSrQRmOJ3jcBoETXc9j
         znHhreB9hzCLvKuK4nh9ugY/opKjtxl2N4UiYFTOQtAH+dFm6YQTrJiua4EPPx355i8Q
         munE4GZKYZHmIqkXXmXblVkMpuAbwN7j10kzJW7hwkbeDn1MQ0tJb6FIPAPjtZNyEnwj
         Y0Lu38aWQoJE3aUuN8nl+VZ94JVeoKbPx0eqpfZnT/bytVVhUF818j6EyaMyvwtz8A2E
         KLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GNqXP6MnEh5m4nolFEKGmKxP/qSwA0kXzhxyqrmFooY=;
        b=UO5phWhKNVAjizNmlag6ld7x2iWo5IjOf/cc8egyTT/1WgPN5LtGwxdoWxetRUPIu9
         Wa6Ra4oZZNXkgAMozdTUpzk+utWneuV2C+3hXceQDt+4pvy+ty4EyIaOENYeIN/4iHlH
         Le1G2f7nam33bYLB57CpeUvCmO8EwBEcyL2V189hOMcr3qCCHatgv9FhSPF5+1Brl/iU
         tZE4Xf6+ejdMKMaslilfzNDQoSuXnmVK7iJEB939hX6pYILFVhs00RuLZDhNXrc50l9L
         ZwHcCdwFypz/wzx3QRJFdv2heLhtL6YoQ1EVsKUPN/JHxUdPsxtVKU12TIiCb7BX5IQO
         CawA==
X-Gm-Message-State: AOAM531uWSiQL45lVhgmL4jslyl2Ttcl5o0vuJ+HHsh6vTqopxZq/cOg
        WA1S+efiW8DP+LsDCAIo7Bo=
X-Google-Smtp-Source: ABdhPJw8nPiWZ3KJpxExOnWcmRzAGdmaTarPQZDrOLbRtm1LSCxiyM9pJ3q1dA1xrGkfPNWJCZ9IEw==
X-Received: by 2002:a65:438c:: with SMTP id m12mr4013211pgp.373.1596652035873;
        Wed, 05 Aug 2020 11:27:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x7sm4536785pfc.209.2020.08.05.11.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:27:15 -0700 (PDT)
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200805153506.978105994@linuxfoundation.org>
 <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <CAHk-=wj1bhyhuJbA5_UbqAnbjqA_hSrmZFqCQrhJ=44P--T4vQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <ea90a651-9293-6837-9982-c4a988fd7a03@roeck-us.net>
Date:   Wed, 5 Aug 2020 11:27:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj1bhyhuJbA5_UbqAnbjqA_hSrmZFqCQrhJ=44P--T4vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 11:01 AM, Linus Torvalds wrote:
> On Wed, Aug 5, 2020 at 10:39 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>>
>> [ sorry if it is not interesting ! ]
> 
> It's a bit interesting only because it is so odd.
> 
>> While building with old gcc-7.3.0 the build breaks for arm64
>> whereas build PASS on gcc-8, gcc-9 and gcc-10.
> 
> Can you double-check that your gcc-7.3 setup is actually building the same tree?
> 

I see the same problem. I built images manually, using the same source
tree, so I am quite sure it is the same tree (at least in my case).

> Yeah, I know that's a slightly strange thing to ask, but your build
> log really looks very odd. There should be nothing in that error that
> is in any way compiler version specific.
> 

Same confusion here. I'll be stuck in a meeting for the next hour;
unless someone else figures out what is going on I'll get back
to it afterwards.

Guenter

> Sure, we may have some header that checks the compiler version and
> does something different based on that, and I guess that could be
> going on. Except I don't even find anything remotely like that
> anywhere. I do find some compiler version tests, but most ofd them
> would trigger for all those compiler versions
> 
> Or is there perhaps some other configuration difference?
> 
>              Linus
> 

