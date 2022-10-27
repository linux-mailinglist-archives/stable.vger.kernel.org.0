Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92AE6101D6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiJ0TjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiJ0TjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:39:21 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086447B28D;
        Thu, 27 Oct 2022 12:39:21 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y67so3589996oiy.1;
        Thu, 27 Oct 2022 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=8jwK9QIbaZv9L9bXEMtfjn0o2VcUm4h8mq9atKinzE0=;
        b=QGfqsRhhriRrYkimz0kwNd3ZYjQZ6qLGHUHQCEFRfLHYCaKm+fbeALdH8ve8Z1qv1m
         KS6IN4xUE8KURKJ8QGRkxSFMmTmKLfZU3YZ2njhtukzrMoPhpV34CKKaZ992vDXWD/Ku
         ybi6Ld7N0nPdBYfUU6oIiFlF6WVWz+l3Mq4wg7LffooJO/LuflbkO7/PSnB2dzqKfDOC
         yGiJd5wuWhPnpLf4Suf5UwT9HpratcbO7j03aXkeLuf55PYlM5I8wdjNgLQP3YHamajB
         1bxCncTxxQGiQhOkYbBhYnI4hrYcjUcvrszhpfMhMh2lzklOr4jYHvS04EC/Qd2rHILF
         zZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8jwK9QIbaZv9L9bXEMtfjn0o2VcUm4h8mq9atKinzE0=;
        b=JRShDXz5HEBNUv6EA4M7w3OCZUVTox9onp/am2KNiZUUUwap155nw4BM62hF1UiMYn
         aaDivxUYyVtGZA5QAIFvSiu1UoJ6/1JLEsa9mrjj5HWI/lqFz2P6QlXA15O8ONd6hWsy
         yKr+wxLxm6BZnt+bEREE3/bkdWaIVoTnvp+719EB8b2PlyAlnhccMWVcbkcx46+kDXQ/
         7ETAQzIDmsTksUUJpfVlC/axVnWBBN7LydjabmbEO4X6Odau+y8euTl0Z+8i5cPa6ATG
         c3PVWNuvdE6AI7D65AF+tlVp4XEotwIXnsfUe8SW7NYoLt28TzflFJ0yPUgQTIp+K13x
         0uPA==
X-Gm-Message-State: ACrzQf2cfVWL8GpOrm2+WRF78mQNOCdiCVrJC1gq9YPxAZdAV4V6w/L2
        ymTkgzvA3P0Lt1bAwhKtF44=
X-Google-Smtp-Source: AMsMyM4FhtTV+6SA8WknxYIyWCoKqeADbRghLK1Px/Fo/Ifb+KL+A1Ub83qByqfetNlub9kv6GTiqg==
X-Received: by 2002:a05:6808:1789:b0:355:231d:54b0 with SMTP id bg9-20020a056808178900b00355231d54b0mr5944376oib.241.1666899560420;
        Thu, 27 Oct 2022 12:39:20 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fq39-20020a0568710b2700b0011d02a3fa63sm1029659oab.14.2022.10.27.12.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 12:39:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ffeb2d7f-cfc6-887a-5751-d58545171526@roeck-us.net>
Date:   Thu, 27 Oct 2022 12:39:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com> <20221027192744.GC11819@duo.ucw.cz>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221027192744.GC11819@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/22 12:27, Pavel Machek wrote:
> On Thu 2022-10-27 21:25:54, Greg Kroah-Hartman wrote:
>> On Thu, Oct 27, 2022 at 11:10:18AM -0700, Guenter Roeck wrote:
>>> On 10/27/22 09:55, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.151 release.
>>>> There are 79 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Building arm64:allmodconfig ... failed
>>> --------------
>>> Error log:
>>> /bin/sh: scripts/pahole-flags.sh: Permission denied
>>>
>>> Indeed:
>>>
>>> $ ls -l scripts/pahole-flags.sh
>>> -rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh
>>>
>>> Compared to upstream:
>>>
>>> -rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh
>>
>> Yeah, this is going to be an odd one.  I have to do this by hand as
>> quilt and git quilt-import doesn't like setting the mode bit.
>>
>> I wonder if I should just make a single-commit release with this file in
>> it, set to the proper permission, to get past this hurdle.  I'll think
>> about it in the morning...
> 
> Alternatively you can modify the caller to do /bin/sh /scripts/... so
> it does not need a +x bit...
> 

That should be done in mainline, though.

Guenter


