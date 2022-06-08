Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367375431EE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbiFHNvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240883AbiFHNvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:51:09 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5F60B81;
        Wed,  8 Jun 2022 06:51:08 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l9-20020a056830268900b006054381dd35so15149508otu.4;
        Wed, 08 Jun 2022 06:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=wHbY50ZTzu8/ZmvcBIt4klKz62u58DeLSPRJmz7e5BU=;
        b=pHRYhZ0lV/NG3MMMx2RE5SbK5r+JpQyMMEwrMqpfyPjIhXhcpI7UfcuhUC1MYAz2xO
         wNqFMFUb+6VxxcHf9m4eUfwZqRimnP6M34t8RTg6toc3BmFP025k3LPHqzihhN8wZqvV
         XEWBOlxygZhbXSeLNJQxxMU0Ey+C5CTy0nOO+yrPqk42TntRIjiqKywtfwU22YkQUBcS
         2F7Jex3ljrpCx5cdUjIylSJJFzCSDOWoyVwVRBglcUPk87OxEaAsBjzqc1AccFSblHTs
         EVoGPZS8KF6OPHmAxBqpfZf6Hln5/NB1MO9LZo6m+O8R9U7lk1Fm/TScY2Icjq2gin3l
         2YKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=wHbY50ZTzu8/ZmvcBIt4klKz62u58DeLSPRJmz7e5BU=;
        b=Onvqvk2Uyx7kZTE5615SlfAjGe1IVBSRMF77WjTf+Xkh5QyqumijVnj7a05wtJYKKZ
         nTJgUWD7yFD93txQrtZlYT2MFV96lWSoowdST2sEcmDHF5FUew/URHynWhGlYMa2/TN6
         u81fmFv6T9Oz8GwYKwbp9AEBzgitz5czkj46fClKTIzJG9OrMA4BjnMfpQsuEKmymlWt
         W+XtRtZndLn6HVGQx9JaLQgJ477PCLXhezU963+3r1n0SBY+VXGLG9trGzG+S873Ksyi
         Nt4meU8LqmSxU/S84rq8SLFXhqDAbi+r3qFj0hRVTUe3L0VNORx7pK+AAa0nwxanF5WH
         TT3w==
X-Gm-Message-State: AOAM533AHrtaL3ZIz8QlsC4LaT9tmSOIkphzWADXIZfzPRfIJvBfJQvp
        T7YMniR+wSP9wkf08wzP/qg=
X-Google-Smtp-Source: ABdhPJyNg71Vl5cWr4WG02/OelvT5mL9X4GgO9FOkzRYxSfVb5GncqTkDx5cf0QzCYEMzlrPrUtjqA==
X-Received: by 2002:a05:6830:3152:b0:60b:830e:2683 with SMTP id c18-20020a056830315200b0060b830e2683mr14613653ots.263.1654696268036;
        Wed, 08 Jun 2022 06:51:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m11-20020a4aedcb000000b00415a9971cfcsm10879646ooh.38.2022.06.08.06.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 06:51:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <078a7fab-2dec-2cde-f530-794156b57d7d@roeck-us.net>
Date:   Wed, 8 Jun 2022 06:51:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
References: <20220607164934.766888869@linuxfoundation.org>
 <YqB1e83SqynwHqQZ@debian>
 <CADVatmNFdgXpD+fJq6Yu-7877WPbPcsg4aD0vppLPj_hCJ9Ngw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
In-Reply-To: <CADVatmNFdgXpD+fJq6Yu-7877WPbPcsg4aD0vppLPj_hCJ9Ngw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/22 04:11, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Jun 8, 2022 at 11:10 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
>>
>> Hi Greg,
>>
>> On Tue, Jun 07, 2022 at 06:54:25PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.46 release.
>>> There are 667 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
>>> Anything received after that time might be too late.
>>
>> Build test (gcc version 11.3.1 20220606):
>> mips: 62 configs -> no failure
>> arm: 99 configs -> no failure
>> arm64: 3 configs -> no failure
>> x86_64: 4 configs -> no failure
>> alpha allmodconfig -> no failure
>> csky allmodconfig -> no failure
>> riscv allmodconfig -> no failure
>> s390 allmodconfig -> no failure
>> xtensa allmodconfig -> no failure
> 
> I did not mention powerpc allmodconfig failed to build as I have just
> started building that arch and I did not have a good build to know if
> its a new failure or not.
> 

It is not new with gcc 11.3 and binutils 2.38. I currently use gcc 11.2.0
combined with binutils 2.36.1 for building powerpc images (binutils 2.37
won't work, at least not with gcc 11.2).

Guenter

> But It failed with the error:
> {standard input}: Assembler messages:
> {standard input}:255: Error: unrecognized opcode: `dssall'
> make[2]: *** [scripts/Makefile.build:288: arch/powerpc/mm/mmu_context.o] Error 1
> 
> and will need - d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to .long")
> 

With this patch applied, at least the affected file builds with gcc 11.3 /
binutils 2.38. I have not tried to build the entire image, though, with that
combination.

Guenter
