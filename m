Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BF75F3588
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 20:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJCSXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 14:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJCSXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 14:23:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3009238461;
        Mon,  3 Oct 2022 11:23:41 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id e20so6707608qts.1;
        Mon, 03 Oct 2022 11:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=usm4DjITe8TP7+rW/IXbh/R0vulQCMr9gWX3n+o4xWU=;
        b=i9mVeqMQmXoGnTG5VLYJqt9UXDU6AS1TdonO07PkbXHovxewS1tVF2z0BdglqqVLs5
         QxcL4gIaBTifOH4vABLiOc8UM94U2XDv2oMtI1QDT+l/58ECBxepEFSuS1c1iBthy5TB
         zLHIJzKmZLzINVR/AWsLru+W4IvQ0ynp4X6MXhUYWR58Tx3B57TGALKD5+PxZ3fzFYRU
         sdIp9LJhHySvqq++PQ+RNomeGgTM5jt3eAHEO4pZXf9HgSM0uGo/1rqr+xumj29eLvjl
         9Kds9ZbUUjRweXRnzkWsGb3dBA75a5K7EtdcJSgvKC/dJnad8P/umx1jSyQ523EcXKve
         R5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=usm4DjITe8TP7+rW/IXbh/R0vulQCMr9gWX3n+o4xWU=;
        b=NoP8732/67LErpwScROd9OPRGPBy2bWHSJa/vR4+SE7pUd680tK3hdW4AtPEfqw6ll
         P4Kiq/z7H4uZ7LNZomxSkfO5YMYBoRa1eg4O7707VPDD6hFCN1eeB0v9EZFs9g0s4KSL
         8Q87h1KqeASm8HbNX/jPyFh62P7S3iMCW0HYUjErnRFUT/RDferHDIjpusEveChMLbdE
         n18qxZBOJRiky4BE+ISuBNlaFyarzlRunrt/uizcXfCWh+XFi8DSph4QhLsipLYp0IFg
         O2bTumn6reHdLz++PVTjJXkVDZYoI3Sqr5Sb3ms4Uzf4qL6eJlZAwdqpqkIKeZeHNuQ5
         Sr+w==
X-Gm-Message-State: ACrzQf0/GgWRcmmLjUlV/zSp24piy/m7FmHXgFGE74oH1SEkSSSfqZt/
        08/fTMkT/Pr22qjm8fForJY=
X-Google-Smtp-Source: AMsMyM5/68hSv9ucwzsreJ7Uz62g0CRaiww4MZIz6oAW8taTAZH5FMdfdFj8RoVnexrr4oa41WBabA==
X-Received: by 2002:a05:622a:190f:b0:35c:c1ef:d2d0 with SMTP id w15-20020a05622a190f00b0035cc1efd2d0mr17408578qtc.469.1664821420259;
        Mon, 03 Oct 2022 11:23:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5-20020a05622a17c500b0035d0655b079sm9627328qtk.30.2022.10.03.11.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 11:23:39 -0700 (PDT)
Message-ID: <2f47064d-84b5-797b-cb9c-6f938a1b1653@gmail.com>
Date:   Mon, 3 Oct 2022 11:23:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221003070721.971297651@linuxfoundation.org>
 <e7934bdb-fb0a-76cd-0fd2-f9b8da03170d@roeck-us.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <e7934bdb-fb0a-76cd-0fd2-f9b8da03170d@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 07:26, Guenter Roeck wrote:
> On 10/3/22 00:10, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.72 release.
>> There are 83 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
>> Anything received after that time might be too late.
>>
> 
> perf fails to build.

Same here.
-- 
Florian
