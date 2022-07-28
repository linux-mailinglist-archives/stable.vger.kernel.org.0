Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B55841F2
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiG1OlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiG1Ok4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:40:56 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3C96AA14
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:39:16 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q14so1530623iod.3
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MpQb02OG5tD7IhYTPbMlbV6KQmQpDfBQQiZPoTkmq1k=;
        b=LUs7b5/lDzcdiI/VF38fW19YDMfXbgj92L1iNbF/CXgu6+NelN6zARM+ae54yeqZmH
         ngnbbgR4t0kWp623mJZn+FYCVVa+bJ103svZkNMfhlXf8rpbIen9FB+rGypj8naD21q4
         6WlXxy4oHOTd3Ka4cZLdS8fXIQW/rJ+fnQ/xI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpQb02OG5tD7IhYTPbMlbV6KQmQpDfBQQiZPoTkmq1k=;
        b=uPKTXqV9iV90JKZ06MGaFT0CrdUzeavZadUGbJnamqBOZSNKCI7mugvoZH/5h/TU50
         Q9BsY9AyQ5WQq3IBg55py/WgNXWpwRYDjyaK/XsrikLYLNQLTT22GaT3lQM4HAb1xXph
         +ZDJThCZ/OHyLYtew7jJXQuibIARZAfmVo+LxnQq4cSVlsS5j1PZ/mZEcNsod8kUCW2S
         0e7ISoQgdVTfiYiNRjeBuUU92QIZZfUlr1yMvMQGXpBrFpUJAfc4dxeJLGaffi2cmOw6
         VjGC68jIMhOnxP2rGClwUSOYDpHPkkoEHFp3DttX+NYxUANE2fJ4TEV/AgUO1DsV6nML
         Nzsg==
X-Gm-Message-State: AJIora8YOijaNZ+6nwfQOG7b/NRoY0sIkJSX8qlcky71VUpnUYaorgMr
        0MhtsTIQImoMVyUXt5fm0+4c7Q==
X-Google-Smtp-Source: AGRyM1vtZ8PA+17pAvLU2qnwAlu8fgiaVXnMud2uxRPyRSTsyAQpHNZSdAtF2KdLfaDb7dLlCpbZYg==
X-Received: by 2002:a02:b915:0:b0:341:927a:41e0 with SMTP id v21-20020a02b915000000b00341927a41e0mr11312621jan.174.1659019155651;
        Thu, 28 Jul 2022 07:39:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q11-20020a02cf0b000000b0033f3dd2e7e7sm442746jar.44.2022.07.28.07.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:39:15 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e10cf48d-c385-cdb4-f11b-82100b1132e9@linuxfoundation.org>
Date:   Thu, 28 Jul 2022 08:39:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
