Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051F81F46F3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgFITUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729117AbgFITUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 15:20:46 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F2EC03E97C
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 12:20:46 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id g5so17552844otg.6
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 12:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M95b7XN4hxzBNl14aeyijOA1TLpQdEQ5Lw81DxthS4g=;
        b=AqVKgw5OmjZwe8FdhvKuAo97EM6BGpfVOHcD/pomOM53XUm2tmiwmsHVn/X4iqwBtd
         mTlOQvqinoKZ4IuWrVUam1GSemrxCt89yxfMe3NKDzxIN2UK2myQ1ffluCvj2ESpxx2E
         lLfYFZvbm9ncZRIDCRdrz7shaFd9AVkLh4E38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M95b7XN4hxzBNl14aeyijOA1TLpQdEQ5Lw81DxthS4g=;
        b=Uaor10qAEX3Ax35PvfSJvDIuAF+YnszpALHB2NjoxrfXrRdK0N0CAF7UC0WaCFlUwi
         0sjIoECbjqd6u1bYWNQi6apyxXF6W7zBWxwe7hPiGN2FPoOhNwbE19+yHfrv8T8wquXg
         gh0pXu6dCHjFxxm9dOeHf+NpQ0HJp9GwC7QdAxFVmmEmK1jRUcVr+vNiMuWMLSl9IFyu
         qz3dawvnobaG2P6dNpawYARXpO9AfCBQmha+86QKrx6nLjssBLUzzdC/f6Wmg0BIvy9P
         OKPRTDgnGAjXzUv5u4+b2VQs+6rU1YvjCCjplz9cPlRZDuyaZWWtA09OHNf1pDQyZ7s8
         0cTA==
X-Gm-Message-State: AOAM530IQwhNpmfXDexctR+zYqiKu7amZ8+awbv0w2i03ZcGjbBe/ws6
        E1QhNie9g2xfIIasBU10u0aIDA==
X-Google-Smtp-Source: ABdhPJyvqpPLkk3Glj/sIR4NsLuwQTZIO1SiVknhZdOrAlpSkLhRN7IBqFlLbTMAadHJ5kX7mFEMeQ==
X-Received: by 2002:a9d:1727:: with SMTP id i39mr22381541ota.367.1591730445387;
        Tue, 09 Jun 2020 12:20:45 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l196sm3368505oih.25.2020.06.09.12.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 12:20:44 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/25] 4.19.128-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200609174048.576094775@linuxfoundation.org>
 <CA+G9fYsxjJpM-bw_VamAH0Beri66aC+-kqZ-RiCWVqm4N=t4gA@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f5429b08-e3d8-f6fb-79bc-3868bf8a2816@linuxfoundation.org>
Date:   Tue, 9 Jun 2020 13:20:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsxjJpM-bw_VamAH0Beri66aC+-kqZ-RiCWVqm4N=t4gA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 1:01 PM, Naresh Kamboju wrote:
> On Tue, 9 Jun 2020 at 23:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.128 release.
>> There are 25 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 11 Jun 2020 17:40:24 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 4.19.128-rc1
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Revert "net/mlx5: Annotate mutex destroy for root ns"
>>
>> Oleg Nesterov <oleg@redhat.com>
>>      uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned
> 
> stable-rc 4.19 build failure for x86_64, i386 and arm.
> 
>   make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86 HOSTCC=gcc
> CC="sccache gcc" O=build
> 75 #
> 76 In file included from ../kernel/events/uprobes.c:25:
> 77 ../kernel/events/uprobes.c: In function ‘__uprobe_register’:
> 78 ../kernel/events/uprobes.c:916:18: error: ‘ref_ctr_offset’
> undeclared (first use in this function); did you mean
> ‘per_cpu_offset’?
> 79  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> 80  | ^~~~~~~~~~~~~~
> 81 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> 82  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> 83  | ^
> 84 ../kernel/events/uprobes.c:916:18: note: each undeclared identifier
> is reported only once for each function it appears in
> 85  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> 86  | ^~~~~~~~~~~~~~
> 87 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> 88  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> 89  | ^
> 90 make[3]: *** [../scripts/Makefile.build:304: kernel/events/uprobes.o] Error 1
> 
> kernel config:
> https://builds.tuxbuild.com/I3PT6_HS4PTt7EFgJUIPxA/kernel.config
> 

I am seeing the same problem on x86_64

CONFIG_UPROBES is enabled in my config.

thanks,
-- Shuah

