Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FA858EEA7
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiHJOnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiHJOmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:42:47 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D1C6AA1C
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:42:23 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id p132so17901406oif.9
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=DS6U6GvTmBDChfW+8rl7ucrMk19CxC9ovZCujy3CVBU=;
        b=GsvTQFiB67QEe4TvXkSZJwvwNI/EwnaxKcQZInaGUlmxpZJ/eD+nHmdk+MHd3biIBA
         e8fnDiF5yD4V9O1Cp/Cg+5d+JFH47op6s5zVTxwjiXghJFsjRKqDfS8kgcuX9VjYTETj
         mZq/Q7TUiF7P2pQqUlX6H9aDfZGWPSUflpITw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=DS6U6GvTmBDChfW+8rl7ucrMk19CxC9ovZCujy3CVBU=;
        b=kIk/8r2j7twREUBmQMr9rmcLQrFOlbeDZBBnNNaJWihOuVbFBrbnwRiv9vhVbxyWaH
         WjEchW5eHD4qeFFeIfjqftCL7FNoTttOuIbfa20uFozMgNGKR9cDwFePBPHyxdSqZ4Gj
         cXDahpjXTQRP9Ixdzx1i17JnkwOJKMfFy2z8YTv82jwXuKK2jF5eoUUUXNW74p8FqE7m
         nDyln7Tkd7c3YWTOYpwSEHZT28Z2nouwCdeC3R3/3VvJg5R7+ITa1wM5C3/0IGeKpYd9
         o/bxWN3P/OXjezqHNFxEVnLmLtGz2W8cRoqI10kmxfsu2bsbHTaYaKfUgSX++aGg2VLN
         HYCQ==
X-Gm-Message-State: ACgBeo1jDNU56x1BQQHdF5+xS/RXpG5XXU21LJAgaIXZVkD2VBEVQVmT
        kJGyVzBPpInzjI/CfJ7F7RPklZYP2MFZpQ==
X-Google-Smtp-Source: AA6agR6kw8zt7AhLPLqCw/JHTPc0z+2M7xtEdgRXOyU+fxyBSA3laz4neFxQX7esaeISXzyk1VhiRQ==
X-Received: by 2002:aca:1a05:0:b0:33b:149f:c0e5 with SMTP id a5-20020aca1a05000000b0033b149fc0e5mr1611700oia.125.1660142543091;
        Wed, 10 Aug 2022 07:42:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r26-20020a4aea9a000000b004354a4412edsm678472ooh.29.2022.08.10.07.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:42:22 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220809175512.853274191@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d11c2552-3db6-e82c-e759-d1fe8c17c7dc@linuxfoundation.org>
Date:   Wed, 10 Aug 2022 08:42:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 12:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
