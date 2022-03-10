Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457064D5535
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 00:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344597AbiCJXVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 18:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbiCJXVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 18:21:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D015C42BD;
        Thu, 10 Mar 2022 15:20:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 9so6224286pll.6;
        Thu, 10 Mar 2022 15:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HCQXqZnIut9hf3K3yfEt3I/KXtDhV5tdHqwOxZZh8pQ=;
        b=XsZgpiKxfUW2QvJHIgQllPc4w4/AKnbr7LcS30V7YyMqM4vEPhm1YJBqUYyiNobU1o
         BTwsVjO0MFbOd7GGHW/vQRs7HekmXuKswicNn6Uy97YoPDEPpWwFAPc96hzY6xU8tB5h
         8/grZqCslpTIdtylUi7AtIYJfNJms7p5oyA1hxnwvzOSXzRk63X+5ncRFx3QauaqGxTs
         yRvVG/30ZvjCNMk6cmX6h8J8y5cNb72mwQainmsbX6TzfBP80SkNiGmLppowoqefO9jH
         O+U68DUS7Q/jg4XugdYufGHEgbj42oBfuXj5LqttnI+rUFM11E90fI+Gq4b0rRNLov+b
         Zr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCQXqZnIut9hf3K3yfEt3I/KXtDhV5tdHqwOxZZh8pQ=;
        b=boJ24hS3nKWKzvFhqNB4+FpnSnI0jB7o4q/hQAIHe5E++kFmHQ7oHif43maPpGF0XC
         JWQIU8x6u+/l1vvVvpZH0/kEBCZpBV2xYKsvoMnSoVsKT22Uhk/TZ07wtuaV6RZDVsGb
         Ig9q1gs8tiIj/RQ16SULTg+EtJIutbSiBth/iA8EwooinvaZhMouJCZ3qb0u9jr04c9W
         TocYRrBrDz6bcfEVgmdzfGHFjAJJQWGeV0JbEDKT22EkvhHUirCrSXhiHf/3hzuZ8yXv
         OmNTfXLKHuwANy4ZkFHhkM+Rh+iHZYQWAWzxXXHLMRyCGPN89dDY6Gi47bsYX/glCsRt
         R+ZQ==
X-Gm-Message-State: AOAM53017LfbuFGD75x2EX33Zl4sot7gps/9igmiqreeDzH9w8di1Z6a
        lUM52ajodyyfJObNb4lnsmM=
X-Google-Smtp-Source: ABdhPJxLnquDCAkl90Ka/W1F68lhh7GdoT7vm1ojAB3jMFDSElSPja+Bh79MGYAgnAHvQnpXljmpwg==
X-Received: by 2002:a17:90b:1bc5:b0:1bf:1c96:66ac with SMTP id oa5-20020a17090b1bc500b001bf1c9666acmr18307183pjb.167.1646954438703;
        Thu, 10 Mar 2022 15:20:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m8-20020a17090a158800b001bf2cec0377sm12572596pja.3.2022.03.10.15.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 15:20:38 -0800 (PST)
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220310140811.832630727@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3adc4e09-dffb-ff65-455c-ea1ebab3f607@gmail.com>
Date:   Thu, 10 Mar 2022 15:20:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/22 6:09 AM, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
