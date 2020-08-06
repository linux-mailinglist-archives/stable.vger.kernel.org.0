Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADACD23D462
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHFAJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 20:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHFAJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 20:09:48 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11185C061574;
        Wed,  5 Aug 2020 17:09:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so17102787plr.7;
        Wed, 05 Aug 2020 17:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G5p7q0BOMSwMXlCg/AAJgkxy+4ZmlLv8Hy+lqg/sBzg=;
        b=Dgl/nID46lJMI8RL1w0F7zTulRlWJuQzJqYkCHC+iU5SCdg6SiOWRud36U2NJB6+6W
         0Yn/TTlWBaVLf2Si3oquiadLGNXpZ4Q5VJ1iT9dFQEXei31P79v7U9F+pyI+N8c6Ai1e
         EQ3nrb6Z37QZZGgdWEULIiLNdcumkjZshfVqaKJhWCsG8rqiYh22rn3Jmtus20c5QpqK
         DK3BbVnbNYG1vbk6B9Mt5L38pS83l/0UI7vfT8GSZJQNSHhOzw6sZIjfHWrLHb6R/f8b
         iG+FYh3zB9EUelXCHQ7lQA/TqTkiokChef+3cw4BIbu9AAu2ksIRXm6xA6s1pAs9KSx0
         2cjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G5p7q0BOMSwMXlCg/AAJgkxy+4ZmlLv8Hy+lqg/sBzg=;
        b=m7AkEK25gyp2V2IUTWnAJC2yzNRL3FQ91N67On+VPPSyAeREGcXpQrQFJqhVKl2OE7
         RGBsdBRWxNyP1PvQKIhIYPELq2FIR1KRi7B8qW4R70dSU6lb6qrSL073eYEXtpFEH4tB
         8WxSx6qlfnWRRaUJfkRa7Cvi9Af+YfNVoIH9vx61V6kPS1PO+1TsdQb+MVcIxXAnjPOG
         ZfosY9VB2qKx7bQmzOM4fBWFV9judZCMfViBgnDk7dCgOdjKzk1BNGy1JQ8f66OJaXzY
         HuQhJVB0hQWulGUwJmnZUTutMz5DKKDG0NvHYy8PRFMzgUEGb1mycYYrwK6lW2zsvMk1
         St8Q==
X-Gm-Message-State: AOAM530DfJk7eab6/naF0CFkbpvfbMP3/PNNqfPMK0dnBboeK4EQAvvr
        O1VNWVxKo7bxr2a+wUo16a+sDuZN
X-Google-Smtp-Source: ABdhPJxQ29ZwfOrkX9iCCwTUQMKVtTnUbrlJx2B7z5iSg0AWrHqmp/bdtQ0zwF3Oq9mm/8EtVk6hpQ==
X-Received: by 2002:a17:902:b584:: with SMTP id a4mr5284744pls.341.1596672586851;
        Wed, 05 Aug 2020 17:09:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r134sm5038670pfc.1.2020.08.05.17.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 17:09:45 -0700 (PDT)
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
 <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
 <7e1c9df5-d334-461d-56fc-53625c6ca163@roeck-us.net>
 <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <7e5014c6-d535-7815-4a7c-527715a1e41b@roeck-us.net>
Date:   Wed, 5 Aug 2020 17:09:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 12:45 PM, Linus Torvalds wrote:
> On Wed, Aug 5, 2020 at 12:24 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 8/5/20 11:37 AM, Linus Torvalds wrote:
>>>
>>> Because the trivial fix would be something like the appended, which is
>>> the right thing to do anyway.
>>
>> Correct.
> 
> I'll take that as an Ack, and also remove the crazy reverse include
> from archrandom.h that most definitely shouldn't be there.
> 
Thanks, appreciated.

> It's now commit 585524081ecd ("random: random.h should include
> archrandom.h, not the other way around") in my tree, because a grep
> for "archrandom.h" shows that now the only place it exists is
> <linux/random.h> and a few files that cannot possibly affect arm64
> (because they are on x86 and powerpc, neither of which has that insane
> reverse include).
> 

I tried to build arm64 on current mainline, after reverting the dts
patches which cause the build failures there. Builds fine with both
gcc 7.4.0 and 9.3.0. 5.7.14-rc2 builds as well with both old and new
compilers. So hopefully we are fine.

Guenter
