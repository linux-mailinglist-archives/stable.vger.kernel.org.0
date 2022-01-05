Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA71D4855A8
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 16:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbiAEPRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 10:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241254AbiAEPRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 10:17:48 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B45C061212
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 07:17:48 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id x15so31205691ilc.5
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 07:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QaOzKmh/45r78gZKU4j1aKbGW0eNXE2J7cm64/2dxCk=;
        b=K5RNtelQspgwCLSZiD4EbOVrNMX5nQK1yUidJKPMcSRrM6B9HjQv76qhptfUsurjyQ
         9rnU+FDMGGp4uKnXQ47hS/kAfQCMRrjGwaeNe+3InQBK53orKK8EuN6COcJ8QK3HHDBL
         0CNUcMOEnBqLVMImvZ8PRRWK0oYYdNtOCla2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QaOzKmh/45r78gZKU4j1aKbGW0eNXE2J7cm64/2dxCk=;
        b=cJK67QofNna3D9gpi2vMjIV4/zUFoPBjdcX58SywAdDSWyyTewuFh+IavQFX39aHa/
         rxafOFciUztWwwQuLmI5CsfFHLksJd6RLCaLBeQhSKCD5kylQSzaHnZU2aUw24/9lPW/
         bh+nh2s0dac8kp4f3sOTDwcPGmU9G1Gd/R64a2jGDrJ2bEiQZRLeJzNGf5O1092dwJ7D
         UuS0Ne6uVpzfkvR4DUaZDm3sO1TGs1tlu/5ZsDTnD14f/oo6ie8wtxfkfVAs3hvfHYUW
         OepHV1GI+QWyuonF5Q9zVlPII06eE9BOBK+msyekSpLmZ5uLdxWOWuJw1l/ELNviY9nL
         rwBQ==
X-Gm-Message-State: AOAM5326D+nZVV8f86MjvBbo2Co4nzr2cSAtRwK/KAFjm/GwydKbaCiy
        kVS1frPf9h4Ytj1+o8fmusaauA==
X-Google-Smtp-Source: ABdhPJxvefzoIF7Q/OwzbSZ1Hp0o/UnKPfkzM1v9TBRTzXmEXtYvV5LElJNYL5VFD84/w5Tsod2sJQ==
X-Received: by 2002:a05:6e02:148a:: with SMTP id n10mr21526451ilk.142.1641395867321;
        Wed, 05 Jan 2022 07:17:47 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g1sm27236084ila.26.2022.01.05.07.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 07:17:47 -0800 (PST)
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220104073845.629257314@linuxfoundation.org>
 <54461ffb9ebe34e673e6730f3e9cc94218ad2f49.camel@rajagiritech.edu.in>
 <YdWxh/OR0dQDeS9E@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b7a7543d-2e18-93fb-7a7d-791a8030d347@linuxfoundation.org>
Date:   Wed, 5 Jan 2022 08:17:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YdWxh/OR0dQDeS9E@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/22 7:56 AM, Greg Kroah-Hartman wrote:
> On Wed, Jan 05, 2022 at 06:32:43PM +0530, Jeffrin Jose T wrote:
>> On Tue, 2022-01-04 at 08:41 +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.13 release.
>>> There are 72 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          
>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
>>> stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>   hello,
>>
>> There was a compilation error....
>>
>> -----------x--------------x------------------x--
>> MODPOST vmlinux.symvers
>>    MODINFO modules.builtin.modinfo
>>    GEN     modules.builtin
>> BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
>> Failed to generate BTF for vmlinux
>> Try to disable CONFIG_DEBUG_INFO_BTF
>> make: *** [Makefile:1183: vmlinux] Error 1
> 
> Is this a regression?  If so, what commit caused this?
> 
>> i did CONFIG_DEBUG_INFO_BTF=n  in .config and then compilation was
>> success.
> 
> Or you can install pahole, right?  That's a requirement for that build
> option I think.
> 

Looks like some distros enabled this option - either disable the
option or install pahole. Not a regression.

Keep in mind that CONFIG_DEBUG_INFO_BTF is a dependency to build
bpf tests. bpf build pulls kernel defines from BTF to generate a
header file. Not desirable to generate header that conflicts with
standard libgcc defines which is not relevant to this conversation.

thanks,
-- Shuah
