Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9436055CFED
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243242AbiF1B6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 21:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiF1B6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 21:58:43 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A201E3F4;
        Mon, 27 Jun 2022 18:58:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e63so10768526pgc.5;
        Mon, 27 Jun 2022 18:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FN9V5TfZn6X1lLxQ3VHlh67S2pF3HhJ9IgZd88BkTUw=;
        b=niVQvKnagoaWt4cr8nYGeKFMNk5JIPxEFGb93DCNgyP0XwiU8Um38sUlikEclCLBFi
         Gt8PMWdNsMzHEQLkdLQOaYvfhHBD/t8oGnP1bHCCQT9288gd0RfZpBFUQ6INnW1Y6Knq
         a6cAiLoCm68zvu/e+WfHezI6k1D8X9RkcS2eE0bqudcQIB3YYo5MdaIeZjvhvRLgMQ9G
         noFhi6k8nD0PmR3cTvweR5A8HrT8ZMvHlFRMc7oL2Zz1BWD/9eTRzcte404Dbxrh1d4a
         Lzvrqv/9gJT8F/uCkREluTfan5Iu75nQ7x/xg6w534LKZTC+YMAAB026Noi4CMyY7j7J
         XxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FN9V5TfZn6X1lLxQ3VHlh67S2pF3HhJ9IgZd88BkTUw=;
        b=AgDFtCiVNcBGjSRupmcBt8XQz47HL7JMfseFmDUA4B9TiqxvGHnOF0m4IT49w1yAFq
         DiVzRW7BWUVQp0Z+FRXbYd/2GBdEScEh0OnC5og8WRadb9opLJWtAXI+T7+QBBvUcC3R
         yTkbaah6HcrGQNq3jFHaHC5MGIAf/XLnz/asY0Dw2RM4U39OoGMUaCqYQRvcOZ8saTRJ
         VEtVlyIIx9e0kzynGZvRvkfN5hdho3Fyru7fcBz2Q8cw+88HTExXY4MuZaC5jcUgPvTQ
         Y4yjxJ3jpUmY84D+JYeeW2+ammJMUhyeyz8v3O69nbHJKz+Lv+qhkJu7o3UEG3IhBKxp
         ijvg==
X-Gm-Message-State: AJIora9VNXsds1rJMQ1dV4vh05cUJZG+Kv3qeDPTfOsBtKcSDGz4CeQm
        C+0Y7TgT6fYTKGE+5GZD/B4=
X-Google-Smtp-Source: AGRyM1su20j/hRNhdNZP6kIMW9dHNX0YzcA7HveF67T5vLCR3fogsHVbj0tvUX7+XCkHtvP5TDUyLQ==
X-Received: by 2002:a63:8141:0:b0:40d:28fc:440f with SMTP id t62-20020a638141000000b0040d28fc440fmr15743412pgd.12.1656381521561;
        Mon, 27 Jun 2022 18:58:41 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n17-20020a056a0007d100b0051bada81bc7sm7990276pfu.161.2022.06.27.18.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 18:58:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9d52dde9-1573-caf7-8e85-c181a614de3f@roeck-us.net>
Date:   Mon, 27 Jun 2022 18:58:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220627111938.151743692@linuxfoundation.org>
 <24080846-a369-9333-589c-ad88d775bc04@linaro.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <24080846-a369-9333-589c-ad88d775bc04@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 11:38, Daniel Díaz wrote:
> Hello!
> 
> On 27/06/22 06:20, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.51 release.
>> There are 135 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Results from Linaro's test farm.
> The following new warnings have been found while building ixp4xx_defconfig for Arm combinations with GCC:
> 
>    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the function .init.text:ixp4xx_irq_init()
>    The symbol ixp4xx_irq_init is exported and annotated __init
>    Fix this by removing the __init annotation of ixp4xx_irq_init or drop the export.
> 
>    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_timer_setup+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_timer_setup to the function .init.text:ixp4xx_timer_setup()
>    The symbol ixp4xx_timer_setup is exported and annotated __init
>    Fix this by removing the __init annotation of ixp4xx_timer_setup or drop the export.
> 

This is a side effect of commit 03c1120b3d9c ("modpost: fix section mismatch check
for exported init/exit sections") which exposes the above problems.

Guenter
