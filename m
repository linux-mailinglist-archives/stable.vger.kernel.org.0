Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC357C3BD
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 07:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiGUFbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 01:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUFbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 01:31:20 -0400
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AF518E3B;
        Wed, 20 Jul 2022 22:31:19 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id r6so804744edd.7;
        Wed, 20 Jul 2022 22:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J1bvvZ9k4n3TJaW7Z7M8+g3r4WQN4cV1OBvraMH0ynU=;
        b=T2hLr37Y9ngRiZKNEHAN+JNLFShxE+KgxkyhmHVS6KXFtPYyGJyiM240dvdOH3EiL8
         2y2Br1Ya+vmno6AplOYZlBXzosqoaGdEDmAyu5KIZvoIlP2hpmcvfG8pjRWxb2smbb+l
         5NUCsmanmzLu6BmHDeDY1wEiXP9Yxy0SDcKQ95lBSxotO7+16RlP746apha3zz27k9Y4
         IyizxYQ9ctjJnZcmeyrKBcjuE98EY9FZ5mqgIZcfuZ59l6TYTIPK5p7GICshn5JkcvON
         z2i5qbekcoQaoz3vv/uU4O1oS6I5+h23JUtVqj346w2ABwtrwAAJvdQ89mXOvUmQytLY
         wj1A==
X-Gm-Message-State: AJIora9rIRUP6KEABN9V6piLM8SRyxHfyt9Y0vQg5nvbmi9rjAxl8Hpi
        xLNxJJ+/DIFPw9LulHsCyaQ=
X-Google-Smtp-Source: AGRyM1vAMLWX8PX9rWXofB4iIJsvpb6nscUZEemSfP5eiTGlA4VQ9skjbhzoFxprIpNk7NX1s2V/FQ==
X-Received: by 2002:a05:6402:795:b0:43a:6cc5:8886 with SMTP id d21-20020a056402079500b0043a6cc58886mr54981089edy.174.1658381477644;
        Wed, 20 Jul 2022 22:31:17 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b006fe9f9d0938sm405786eja.175.2022.07.20.22.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 22:31:16 -0700 (PDT)
Message-ID: <113dfa1e-49a0-2c70-68e0-c2230755143c@kernel.org>
Date:   Thu, 21 Jul 2022 07:31:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US
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
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <Yth67Ubo7PatL0AR@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21. 07. 22, 0:00, Peter Zijlstra wrote:
> On Wed, Jul 20, 2022 at 11:47:02PM +0200, Peter Zijlstra wrote:
>> On Wed, Jul 20, 2022 at 12:57:26PM -0500, Justin Forbes wrote:
>>> On Wed, Jul 20, 2022 at 10:28:33AM -0700, Linus Torvalds wrote:
>>>> [ Adding PeterZ and Jiri to the participants. ]
>>>>
>>>> Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
>>>> Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
>>>> ANNOTATE_UNRET_SAFE use on 32-bit") in that list.
>>>
>>> It should be noted that the build doesn't fail, it just warns.
>>> I am guessing the 32bit failure is what promoted someone to look at
>>> the logs to begin with and notice the warn initially. I just verified
>>> that it exists in our builds of 5.18.13-rc1, but not on mainline builds.
>>> I am gueesing it is because commit 9bb2ec608a20 ("objtool: Update Retpoline
>>> validation") should be followed up with at least commit f43b9876e857c
>>> ("x86/retbleed: Add fine grained Kconfig knobs")
>>
>> Still updateing the stable repro to see what the actual code looks like,
>> but that warning seems to suggest the -mfunction-return=thunk-extern
>> compiler argument went missing.
>>
>> For all the files objtool complains about, does the V=1 build output
>> show that option?
> 
> Ok, I'm now looking at stable-rc/linux-5.18.y which reports itself as:
> 
> VERSION = 5
> PATCHLEVEL = 18
> SUBLEVEL = 13
> EXTRAVERSION = -rc1
> 
> and I'm most terribly confused... it has the objtool patch to validate
> return thunks, *however*, I'm not seeing any actual retbleed mitigations
> *anywhere*.
> 
> How, what, why!?

They were all put aside until all this gets resolved. You can find them 
in the stable-queue tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

in retbleed-5.18/.

regards,
-- 
js
suse labs
