Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258A4659327
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 00:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiL2X0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 18:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiL2X0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 18:26:50 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7117216585
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:26:48 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id m15so10536239ilq.2
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/xDGNtMWURvljwRiBs8LuLEHcAsVVQHtWigZK+qLiE8=;
        b=AFN26eojPCYRqgY4nrPD0V96+ROKZNOlW2H3Y5HJYtPrDYvaa8TaZW1oMBw9oXoZfN
         40poAMjuNSedgSaEFOr2W4vic7D3GDUh1gnHKgQws8DiMcCtbDN1RYqNHNdn7hHzM1nU
         CWKugpaCFpoXBo/sxQwG/C/lTwIrt8rgeohKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/xDGNtMWURvljwRiBs8LuLEHcAsVVQHtWigZK+qLiE8=;
        b=oxhaS98fgvFN9wNEYWbu9eQU5brqRQIaVSb4C8HRKZ/nDRmPmDa+7M7lOOyiQ5haKU
         OEgKdTfL73Hr+DfQ9vsh/9Wk/w5fm75HwTkYakcBfuBd3E3YMNTYs3j9uM1r/BhbNggY
         uWPrja39OrpHNWFfjqftFfFB74wTuFVAbQE/UwIJ9hketk2bWBR3ILLpyE1GfR1JwKqH
         q6aD95GQtup8f3v3h75C8xxS9eteL615OSpS55Wdr2s3hfpdBhCD120GaJneQcMhpkVZ
         gfV0dP5cNVNLH1DSZ5BrHVVXoX7lXu/vNZu5PFGyX04+/7h06H7WsmNE5WNWg2EAvMpv
         miRA==
X-Gm-Message-State: AFqh2krNQ/hchKLloVj31l3bzACNj3cZbDQhnKShCPE991X+YfD9Zq+x
        oKD8n69nvs+EumuZdF5GW+Dz0A==
X-Google-Smtp-Source: AMrXdXubrhQqtg4cUYcuyLvM+GheoaOSWIKj5qAljwWYyGRxDWBGzdrY1eoFmMCwyS8yUhhNdaIgFQ==
X-Received: by 2002:a05:6e02:13e1:b0:30c:276b:af80 with SMTP id w1-20020a056e0213e100b0030c276baf80mr606833ilj.0.1672356407796;
        Thu, 29 Dec 2022 15:26:47 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o8-20020a056e0214c800b0030c048e60bbsm3459978ilk.34.2022.12.29.15.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:26:47 -0800 (PST)
Message-ID: <38aa4c96-00bf-d5e1-a820-806d7d7faf78@linuxfoundation.org>
Date:   Thu, 29 Dec 2022 16:26:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/22 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
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

