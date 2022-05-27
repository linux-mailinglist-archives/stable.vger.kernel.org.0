Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EF53663A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344509AbiE0Q7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbiE0Q7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:59:20 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103B122B62;
        Fri, 27 May 2022 09:59:18 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-f2cd424b9cso6419321fac.7;
        Fri, 27 May 2022 09:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=SZg+qjutoG3J1/dsqzOYmd+VngnnX2DTXJc5+dVnkHA=;
        b=D5imPluKhRiMycaOUzEc4sulOuWTi0wErwu1XFaorpY76cN1Qamdwu9pi5eKpCCWvw
         2RnIGZi/iHoyK8F7KE4wZ7tqCYSSpHta4aA15x29XV1ujnNs5cLZtIxcyYu8fwkF3Odz
         Go2hfWJ41Sj2WdAaPjwTJ+cyjepk1X0d4qbmyhlfmGcx332r32KEKjGG223JVMFBaS0n
         wt31FHMjDB1GMifUvVX8XxOg7K3Bmii3jg3F+8Bho5zw35wbfo7Jez96Kn56AzY0kgJa
         CCwUbvDJ8BLar/woN4ci/iN0edw2RN9RsY5DXT+B+q+FGmvBMQvlvvID69/JOr1WDfqT
         +A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=SZg+qjutoG3J1/dsqzOYmd+VngnnX2DTXJc5+dVnkHA=;
        b=vIOvANQ9GiVLX5D6SQ97Rf7c7H/5zMw4BPsyzzeghXanRMtI05k+3sI99ALuLyjRyO
         QPtwLP6Up4bpk19h6ZUS4BDSO9OGL56g/tzGlgTE3AEMi0Bh/ri89dqnoyZ2JTcNsUMl
         uJk/t3WmGS7QyUSxRrAeDqE8XBLPP24br9Xd3Rff5sglUGh3nfCZ4j2vBAbZIIWwN8jt
         LCc2AEBE9/BuUzZ8Q6eN+4tavmtECAcl9dxb3+lIYEo0gUoobTHeNWnSyHy5a2rJv8fu
         STZg9pHn9AXed03uaxI55kppietuANMl42lrZWvCfDBsTQEDXlSZgJK6qIyKMT7mnAjM
         Aehg==
X-Gm-Message-State: AOAM530/ukhsxS4xYxSFrPVE7BoRUb7tVZB9K53py1aGuygvDFr8IBX3
        WEd+8tcFxUPpbjSfghj5WGg=
X-Google-Smtp-Source: ABdhPJw8ZOepzwBcCrrLBGIJM9X6Wu9CjPk6dJ/62yv58i2lpX3Aio/8u5YKudwwdGONRLJPincDXQ==
X-Received: by 2002:a05:6870:538d:b0:de:aa91:898e with SMTP id h13-20020a056870538d00b000deaa91898emr4462061oan.54.1653670758024;
        Fri, 27 May 2022 09:59:18 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w27-20020a9d5a9b000000b0060603221240sm1978304oth.16.2022.05.27.09.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 09:59:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
Date:   Fri, 27 May 2022 09:59:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
Cc:     Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz> <YpD0CVWSiEqiM+8b@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
In-Reply-To: <YpD0CVWSiEqiM+8b@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/22 08:53, Greg Kroah-Hartman wrote:
> On Fri, May 27, 2022 at 04:14:21PM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> This is the start of the stable review cycle for the 5.10.119 release.
>>> There are 163 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Is there some kind of back-story why we are doing massive changes to
>> /dev/random? 5.19-rc1 is not even out, so third of those changes did
>> not get much testing.
> 
> Did you miss the posting on the stable list that described all of this:
> 	https://lore.kernel.org/all/YouECCoUA6eZEwKf@zx2c4.com/
> 

That describes _what_ is done, but not _why_ the patches needed to be
backported to older kernels. Normally I would see those as enhancements,
not as bug fixes. Given that we (ChromeOS) have been hit by rng related
issues before (specifically boot stalls on some hardware), I am quite
concerned about the possible impact of this series for stable releases.

Guenter
