Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254286A0E1B
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 17:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjBWQhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 11:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjBWQho (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 11:37:44 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E77953EFC;
        Thu, 23 Feb 2023 08:37:43 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o3so11053331qvr.1;
        Thu, 23 Feb 2023 08:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PK3I727zzaQ8oJhwBvZZe+bdq34vFA8KkZVT4eU54A4=;
        b=N/OcUDSZrw2hKTDAppnELEEShDNZbuVL/9XrJBldl/IaGqGAFH8Vw6yw59w+pwqAzR
         3yj/vwxS35SC3qtpmaY5s9ifi8Q10PCb2BxebCfwGfueviI1uIkhrCzcnb0bSqqwm/aA
         N4FCa5FikS5OYLsEH6qjy0YJfsI5gBX97n1ngq/+4hxf1T0XKW0q1E2Ym8BlMpry801a
         UHaqX+kq0xGwrgZEDrCcxo0wAbsVa2LbkpasmlbqmTuSDPBIjgr2kAZf9K2dP+8jCOmI
         ejytGNJuEW5h2sskasqLTAHOqSaNAkH7oPYxDQFKI/eZS4iH6kH2kqxf5yAdnIS6KP08
         Ohbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PK3I727zzaQ8oJhwBvZZe+bdq34vFA8KkZVT4eU54A4=;
        b=hL4kQshlFTj0OhaF/w7xtU27J7v2A100qNehR8Qgt8I6uEJhfUF+nCzhbbzLlLR+w+
         n4cY8CoTJE91Q/K5RC+mbu41zHzNa3lTxuSz/MXQ/uW2sSP4++VvfW5seEpz3nrXj3H7
         z0q+vVcSo+EjhhZfDTLoWkXBcs//3nYW32Bx+4DMlRwP8lc+ZiiHZ1COwWsiLFWvIfEb
         Vi3LiejEMCh4ZbY840eNqwfGt2ElLxQbKYwkXAOV2HuIpXLtWs9UbxRsr42SLnyi+T80
         f3JK/a4WAImVwRg1VJkYizPRTuoZ6MO3LGF+mmdT2l5S89c7zsoXKtt4CRpY3Ry+UFE5
         jWmQ==
X-Gm-Message-State: AO0yUKUKE3eXV9LsxhrwBpGmXgtx+0O4uot6fIoZWmh5noCks1bzVt0J
        Ld+ltYqnesbO1dJ745rzNrUU5zS9a/4=
X-Google-Smtp-Source: AK7set8awspWCvk1R/MdOkgOMDPcx7oJsaZKo5FAewRYWHDzLKbq3PHirXykbdolKgSfgxdF0nZJUg==
X-Received: by 2002:a05:6214:f6c:b0:56b:f28e:628a with SMTP id iy12-20020a0562140f6c00b0056bf28e628amr26999370qvb.6.1677170262157;
        Thu, 23 Feb 2023 08:37:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 3-20020a05620a048300b007290be5557bsm6883589qkr.38.2023.02.23.08.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 08:37:41 -0800 (PST)
Message-ID: <b53ad4fc-978a-b883-0d09-2a9306615a66@gmail.com>
Date:   Thu, 23 Feb 2023 08:37:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y/eVSi4ZTcOmPBTv@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 08:33, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2023 at 07:36:39AM -0800, Guenter Roeck wrote:
>> On 2/23/23 06:16, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.96 release.
>>> There are 37 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>>
>> $ git describe
>> v5.15.95-38-gd6f4f9746d40
>> groeck@server:~/src/linux-stable$ !ls
>> ls -l scripts/pahole-version.sh
>> -rw-rw-r-- 1 groeck groeck 269 Feb 23 07:33 scripts/pahole-version.sh
>>
>> This results in:
>>
>> make[1]: Entering directory '/tmp/buildbot-builddir'
>> scripts/pahole-flags.sh: 10: /opt/buildbot/slave/stable-queue-5.15/build/scripts/pahole-version.sh: Permission denied
>> scripts/pahole-flags.sh: 12: [: Illegal number:
>> scripts/pahole-flags.sh: 16: [: Illegal number:
>> scripts/pahole-flags.sh: 20: [: Illegal number:
>>
>> and all builds fail for me.
> 
> This is a fun thing, the patch shows it being set to 0755, so `git am`
> should be doing the right thing here.  Let me dig to see if I can change
> something in my scripts to resolve this...

We have had this happen, last time you explained that quilt did not 
handle the file mode:

https://lore.kernel.org/all/d1a46ccc-cb07-fa51-f722-c48d6c84bf9d@gmail.com/

Anything we can do about this?
-- 
Florian

