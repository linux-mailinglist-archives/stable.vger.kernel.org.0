Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1A68A2FF
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 20:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjBCT31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 14:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbjBCT3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 14:29:21 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B131C7C4;
        Fri,  3 Feb 2023 11:29:09 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id r28so5041694oiw.3;
        Fri, 03 Feb 2023 11:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=LNv6LLpCvBmjs2M9EoGEVHNv766Oz0fMNWuBCC4P26Q=;
        b=TDWI6UMjunazhVuRrFR8JDYyuj1aEYf1L+zYM8McBROHcw1rk6wgApHll67UZAdzth
         lvmYTYHsMBCcs/6BFDvRk8ojVaJ62v8HrlhKqqpDyvYOMyV4pKVkrhYox5rFnPVaP6b2
         +IL1fzLZA5iCOktDTMim0qifp5OHtSEKgkb1hO2TwOH40eDeWXmyo1XgZKLFN47xsMoy
         a1k5A6+bja0j2lqDu8g3eo4/DXKX/0eeDnHijjgizoe3NHXM6uLTPZfxsogGQ/3BpLkk
         j9jzA6F3T4MCxKsc3cf9ktjuHSToZWT48NC+mjPkVnp408mnl6dCPNYR4GADUQ4WUhMT
         5lBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNv6LLpCvBmjs2M9EoGEVHNv766Oz0fMNWuBCC4P26Q=;
        b=3m8qL8A1iUfybUR+S17+pGlzOHF/K5mfLq2j3A7uJF4EC/99ArdP6wqA3HdCLciaGK
         7gbvvbt7r6PLUm9YjUEnbO7XFn3S7C21m+4xtg2yA83gbbTJdVqc0D2k4Jiimik5b7Ng
         1mmBMQK7hc7n1rDLJpr2ExQElx0j05tIYWrzh9ggYYoMg/fX3iXw3WNYpH15ZughAg9K
         9DUA3UAP2MRIHoT4u98yk3s41zCYJ8i207OsrNN3Kw85AfwRJPZ42EFsVGGzDOJ7hM52
         OBd9yCNebPU1uMiM1cjEIYsROg+Sg+aCB3IH2wwSBpHKrq8oxO2CBwsaHi74kfYZ6J4R
         e8ow==
X-Gm-Message-State: AO0yUKWOHnkt2nhiZ+PU73nJZEbluYjz5t8qr9QCRqv8cVC5hppdDyrH
        UZPFlANN9qTZMqNtrag2Nep8fcXr4GA=
X-Google-Smtp-Source: AK7set87wdANkr75YErqha3aFxTJmv6DDqClUOfw7Rkz37unMSDyEoWqtowQWA3w+cjMD6yWV6oe/A==
X-Received: by 2002:a05:6808:1983:b0:37a:ca27:ae45 with SMTP id bj3-20020a056808198300b0037aca27ae45mr3786035oib.14.1675452530195;
        Fri, 03 Feb 2023 11:28:50 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p205-20020aca42d6000000b0037ad30a2dc3sm1143135oia.23.2023.02.03.11.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:28:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
Date:   Fri, 3 Feb 2023 11:28:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net> <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net> <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Y91bjnIuQRvVqpO7@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 11:07, Eric Biggers wrote:
> On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
>> On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
>>> On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
>>>> On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
>>>>> On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.4.231 release.
>>>>>> There are 134 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>
>>>>> Building ia64:defconfig ... failed
>>>>> --------------
>>>>> Error log:
>>>>> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
>>>>> arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
>>>>> arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
>>>>>
>>>>> Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
>>>>
>>>> Yup, it does!
>>>>
>>>> Eric, any help with this?
>>>>
>>>
>>> Adding "#include <linux/sched/task.h>" to the affected file would probably
>>> be the easy fix. I did a quick check, and it works.
>>>
>>> Note that the same problem is seen in v4.14.y and v4.19.y. Later
>>> kernels don't have the problem.
>>>
>>
>> This problem arises because <linux/mm.h> transitively includes
>> <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
>>
>> Greg, any preference for how to handle this situation?
>>
>> Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
>> are no more affected .c files in the other arch directories) and call it a day?
>>
>> Or should we backport the transitive inclusion (i.e., the #include added by
>> commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
>> <linux/kernel.h> so that it's next to do_exit()?
> 
> One question: do *all* the arches actually get built as part of the testing for
> each stable release?  If so, we can just add the #include to the .c files that
> need it.  If not, then it would be safer to take one of the other approaches.
> 

Yes, I do build all architectures for each stable release.

FWIW, I only noticed that one build failure due to this problem.

Guenter

