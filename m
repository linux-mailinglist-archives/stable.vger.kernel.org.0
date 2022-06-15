Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0FC54BFBE
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbiFOCnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242752AbiFOCnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:43:25 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D7D205F1
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:43:23 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b138so4491693iof.13
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+hzIaxhmwogHOnWV4sh6DA3hA7wytPVtgiohJR2puW4=;
        b=hPvLHrVEDMpEYdgwSivWIkyOg0YM5SIgyqksP2eEs7q6I9f/L0y/4gqxOJksMAJT/1
         rUpLjxAr4U2HN25VizspHdu/R4kpmWoQR3sLV1GgCi604ltv2kYqsVgvhoCXSP+O75pE
         5vckx7ydSvxbqjJN/riO0WIQcZf8XvZHYvJg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+hzIaxhmwogHOnWV4sh6DA3hA7wytPVtgiohJR2puW4=;
        b=H/DnIYvxkAeS6e1T/311/cZxSTyLXf1FsLpnw5NHkfyFO/FfS/I4L33SCy7Wjv5CQl
         3ve2lK6D19pYm7M3WeWRuW9W1uG2ElJ8TfsYZMVgBbFU7S51uo2ntd7N6SLjsLfKr027
         bqjNidSCi2jmPwUQBWbaK3CAgRMI+rSBFkFDmg3+JhiHpUlwIP+XyP3Xf4DBEnOGI2nA
         pHOLG6VQwIlb92oAxuflZLZeGhlL7byVEiUeYGcKZsG8oP9CwZw5O4UmHJnAknFs07YF
         5VctHbuO5gbiuZd2b3+0/EAsqUqKVgoVIN8hiYsQrfoDHVkw7/wWkjjLlGaUKIU6HQXj
         26oA==
X-Gm-Message-State: AOAM531IqGlhHLrOb0npyHlCTDDNvlpU7GwEaiP4F8JxI0f/5azNs43Y
        tVedO0kzcv6deDTOB96VXzDhJA==
X-Google-Smtp-Source: ABdhPJy+FEpp8X3TcCahEYaSD6441ju1NnWAb/zHEwXtiGjYmufD+rZTh/7U9xo8eP8t1a5TELVSiw==
X-Received: by 2002:a05:6638:1686:b0:331:c1ed:9f55 with SMTP id f6-20020a056638168600b00331c1ed9f55mr4326996jat.201.1655261003057;
        Tue, 14 Jun 2022 19:43:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u11-20020a02aa8b000000b0032e1e0ac289sm5622214jai.8.2022.06.14.19.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:43:22 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/16] 4.19.248-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183720.928818645@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e272c61c-e363-8a60-42b0-a49751edf325@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:43:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.248 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
