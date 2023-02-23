Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C2B6A0EBD
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjBWRbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjBWRbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:31:05 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3526F39286;
        Thu, 23 Feb 2023 09:31:04 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id b12so2932310ils.8;
        Thu, 23 Feb 2023 09:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=4+n5maBm19ijOUWMlLkRAAT2cHaeu2CizSqx/+2ysvQ=;
        b=mYEW8MOtUe2vgI43aBQRNSI0XiKiGPLn+NI1lVY2wuTH5rDT00ejDKts6v7GUFFlxK
         bdx+wtGnd40oKfiN6+9SxleClAgQlsEsHMh35/2g6rj/q/ukPHoOeAmCB0+RACvxX8hJ
         O3X8GwOKtolTSB4t63ERs4wyAFJzH7alk6p+XYvd+ytLmZw/Thv28PPSs4FKB9mPjN3f
         kVgT2cgpa4J0r9dAj+1okvUFc43ti0/aHMjT4N1t6CsgvvdwNNHcjzcLO0R8G+seon3J
         sH6xczvVs3HVAuIfomSHoW5PW1LDfPutcTcnyzJlvxiN+MX24sDlDQHE1E8TQi5CDJAe
         TCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+n5maBm19ijOUWMlLkRAAT2cHaeu2CizSqx/+2ysvQ=;
        b=qMRHKbcjQBJ0rRFEvGRy36UIy+AXK5GcqpWpiAq4tjgfFhRYY/SZYo7HmdfOOqnI+5
         ATQTj/IzmpkjircvvLSa5V/QKnOW6S3ESA8vffMc8qeqtviVtceQLV9B7XeBYI8y0Qoq
         yo4VoZIfQ7fHX9kCNoekhDREjnzv39HqYE/JWc1X/QbAuXwN0JubOSgUMM01vAWCvfBt
         HR98rAKWdugwdC6WOsjid/nw2ndypxBmSrmwiSWJBvdtqntgAF7xA2Z12kwmvAvbUCdK
         c3PFg6SCV3jnQfLI39weq0U8tefGFFLUKtxG0mJjL0wgOsuDhRHVC5jmVeUo/GgTWNoA
         17xQ==
X-Gm-Message-State: AO0yUKVs/JtsNOUrEQJQGQG9Lfxgl3OZqTFSzZVlypb7dteU7QFQxIf8
        BbErq2lA6JB1NwzHjA5scME=
X-Google-Smtp-Source: AK7set/Aq8T7UiZIBQo/J34rkNRvZlstU1hzYah+NudNHk3QZrLEGEVCG1YBdhcITS2hmxt3idILzQ==
X-Received: by 2002:a05:6e02:1d1c:b0:313:cb9e:8026 with SMTP id i28-20020a056e021d1c00b00313cb9e8026mr11584453ila.11.1677173463505;
        Thu, 23 Feb 2023 09:31:03 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l11-20020a02a88b000000b003ba4aea63d1sm2171417jam.117.2023.02.23.09.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:31:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
Date:   Thu, 23 Feb 2023 09:30:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Y/eVSi4ZTcOmPBTv@kroah.com>
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
> 

This isn't the first time this happens. I seem to recall that you mentioned
some time ago that whatever you use to apply patches (quilt ?) doesn't
handle executable permission bits correctly.

Guenter

