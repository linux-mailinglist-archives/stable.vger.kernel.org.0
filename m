Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7D57C427
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 08:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiGUGH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 02:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiGUGH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 02:07:57 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C707B1C8;
        Wed, 20 Jul 2022 23:07:54 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id b11so1300422eju.10;
        Wed, 20 Jul 2022 23:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YNme8fv36q78te0X+x31j3sefCz1PEJZIg9UxmBy0jw=;
        b=S4o6+MkL8N8taPN1VxX9BCSa3c700YzxdgFY0FxMMuOYy1dTvi5fZ93hrUdMRPQRs3
         ozwr/2QXd2ZzIdPUKUlOS3l94YNBu+n7c3KtA/gdgTx7omUE0TF+CR8lVJnMr70ET3Lq
         8EX5nSawJozGd9N+0mASoEDwClKlCyEb81/VqBxFN0GIUQt0qW/WK0DIHYCZ+RCiqd+O
         D5KAvJlhDD15eBlJyOA98t7JfO65pCtDycK8J4on7EZcd9ES1VarZP5sTNQEoVG7yKv3
         MHySxvxorw5hRgPn6DbtXjd/ZdDzlLotiJOtgGLOeO/tYPZJE4sJMwhJZXWFZPcMijIJ
         WjGw==
X-Gm-Message-State: AJIora/cdtGxZQJu/UtxKn69ANzjST7zGwrsD+v2cmNcgVsIoA/O3ERg
        mfw8eBsASygLFw1xPmtkAmU=
X-Google-Smtp-Source: AGRyM1ufjNHVUT+b1CWpnqDp9nytEjuu/Vafzm2PqzhXbdoN2LZnVGjExUfDwkix3sjt4yhviBzIGQ==
X-Received: by 2002:a17:907:2d0e:b0:72b:4af7:7ccd with SMTP id gs14-20020a1709072d0e00b0072b4af77ccdmr38356818ejc.209.1658383673290;
        Wed, 20 Jul 2022 23:07:53 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id y10-20020a056402358a00b0043a8f5ad272sm453644edc.49.2022.07.20.23.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 23:07:52 -0700 (PDT)
Message-ID: <4935d164-c99c-5e0d-f390-c86df1971166@kernel.org>
Date:   Thu, 21 Jul 2022 08:07:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        Justin Forbes <jforbes@fedoraproject.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <YthCBl4SORA2BfDv@fedora64.linuxtx.org>
 <Yth31qsO1nDN4WLB@worktop.programming.kicks-ass.net>
 <Yth67Ubo7PatL0AR@worktop.programming.kicks-ass.net>
 <113dfa1e-49a0-2c70-68e0-c2230755143c@kernel.org>
In-Reply-To: <113dfa1e-49a0-2c70-68e0-c2230755143c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 07. 22, 7:31, Jiri Slaby wrote:
> On 21. 07. 22, 0:00, Peter Zijlstra wrote:
>> On Wed, Jul 20, 2022 at 11:47:02PM +0200, Peter Zijlstra wrote:
>>> On Wed, Jul 20, 2022 at 12:57:26PM -0500, Justin Forbes wrote:
>>>> On Wed, Jul 20, 2022 at 10:28:33AM -0700, Linus Torvalds wrote:
>>>>> [ Adding PeterZ and Jiri to the participants. ]
>>>>>
>>>>> Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
>>>>> Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
>>>>> ANNOTATE_UNRET_SAFE use on 32-bit") in that list.
>>>>
>>>> It should be noted that the build doesn't fail, it just warns.
>>>> I am guessing the 32bit failure is what promoted someone to look at
>>>> the logs to begin with and notice the warn initially. I just verified
>>>> that it exists in our builds of 5.18.13-rc1, but not on mainline 
>>>> builds.
>>>> I am gueesing it is because commit 9bb2ec608a20 ("objtool: Update 
>>>> Retpoline
>>>> validation") should be followed up with at least commit f43b9876e857c
>>>> ("x86/retbleed: Add fine grained Kconfig knobs")
>>>
>>> Still updateing the stable repro to see what the actual code looks like,
>>> but that warning seems to suggest the -mfunction-return=thunk-extern
>>> compiler argument went missing.
>>>
>>> For all the files objtool complains about, does the V=1 build output
>>> show that option?
>>
>> Ok, I'm now looking at stable-rc/linux-5.18.y which reports itself as:
>>
>> VERSION = 5
>> PATCHLEVEL = 18
>> SUBLEVEL = 13
>> EXTRAVERSION = -rc1
>>
>> and I'm most terribly confused... it has the objtool patch to validate
>> return thunks, *however*, I'm not seeing any actual retbleed mitigations
>> *anywhere*.
>>
>> How, what, why!?
> 
> They were all put aside until all this gets resolved. You can find them 
> in the stable-queue tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> 
> in retbleed-5.18/.

Ah, apparently not all, as you noted above. But this is obviously a mistake:
https://lore.kernel.org/all/YthbbBY4JumsBcHU@kroah.com/

> regards,-- 
-- 
js
suse labs
