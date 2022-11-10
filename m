Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCD623923
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKJBqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiKJBqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:46:13 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E7F27B12
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:46:12 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id 63so249915iov.8
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/y3kK/aK9HQTqxA2IkTFj8U2SX9wFU9K+VgUpk9sTA=;
        b=M9QshDp07CPCDTvqjA4I5RTcYiCfsLudF9/OXn1wdyy7NeI9GDcjVDci1j4WxjU6aJ
         n/8Aelt15FUoHCy9QVKRpMIjPbXcqCoKrn70e2sABfc1LGEDEZsEm4y21B1qpR7w66Tv
         ETTMcwCZSJ5VPwMdkyn/jY6DedX/YJIghoDdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/y3kK/aK9HQTqxA2IkTFj8U2SX9wFU9K+VgUpk9sTA=;
        b=BT8TbgZ+R68fCN6Bd/r+r7i3iAYKxQT7iICwV4j6Np4AFo2JXY098G00CWd11drHks
         uzugLG2gN0CJ3CWN2sQFyl/zk1ZjmV8GUnUSA5ZAF70/1gOwJoYssVC701o+5by0squA
         OHaR0oOM5nX8StGRBjg1ThdCYaChpNlLcUtMQL4zs2Cq/3pM/IgSbNtAJPznoA0hhnth
         F7MxMj+6+MPOimv3pSEu2dmeA1uQXTUvNpkygOshiTp/D88U9lbsREr9l/PA6sUWWNLP
         6il0rllwjKivjojFALmiJKVNL4PS6h1A8JmIYlK56EWsqDdLjMVmKgx56gHRXtGF6hue
         u6dw==
X-Gm-Message-State: ANoB5pk1etYsVzAFM3iyw/s7+OnC926PkGsMjurvf50NQoyUQbPFoGao
        Dx49dF50vxgF8cvoyu5aB1fYFw==
X-Google-Smtp-Source: AA0mqf4B2hDgM9ZRoS5qBONm0z+KkOFTYsY83ueuH4QwL0C8LrYW7Ls7BQ2ZBmgUrjh7qL6h8fZ/fQ==
X-Received: by 2002:a6b:3ec2:0:b0:6da:fb85:a84d with SMTP id l185-20020a6b3ec2000000b006dafb85a84dmr9394328ioa.11.1668044772282;
        Wed, 09 Nov 2022 17:46:12 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a24-20020a5d9558000000b006bbf0466587sm5843573ios.49.2022.11.09.17.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:46:11 -0800 (PST)
Message-ID: <988d8fdf-6513-7544-bd4c-b55c28e5dd89@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:46:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/22 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
