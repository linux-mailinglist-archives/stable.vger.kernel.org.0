Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBED64ABF1
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiLMAEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiLMAEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:04:36 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8579B175B0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:04:35 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id d14so4239284ilq.11
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 16:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4RP/Ecj2nDWpVcmR1nLBO6gBmUtk2NUcP+9/dUfOyQM=;
        b=HtyBpSqe+EZt7+aZWbhBFJo9Q4WUMRSya8P7RQISXYsIPa+70t51V/+GXrLzcBRVow
         9bVTJwbsGKEjt5ahoWkDQyIM3pzxTiruGw6349snvgcMJcjWIwUUflFmJqpXWpIt6E12
         s/oQaMi+WMslI0YP0dE6EGQysIOdlaGhFKXqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4RP/Ecj2nDWpVcmR1nLBO6gBmUtk2NUcP+9/dUfOyQM=;
        b=h97t0v+SSOxMmyrM41XIDE2WldWS5pZYiNlkemci5HgEh0GsePiflaOnHNHySvKst5
         15S8vvKaTwQQNpf8sNqb01pYl3JfBGO6FwX/jQRFvTdFDBUqDN+qDvjMqcVQGdD2d4WZ
         P4ViRuPdc6EiMAfSw6Bk09RBAwhhgemm88a6ckxqDuBxkjkQ5Xn2H5MzNMNJ1UGwAbQL
         dQNMQlFCctvH/6fWnEYLCsPGuXkIiSmHg3z9qanqkDKjesGf68Av8WSK9KSEcvcfkt7s
         T12YGAiIwuK2M8M4tiF2CF84sVm6zyujOPqta2Sz2ps3AIC+hI25cbdpByDkpYdwuo8R
         sWLg==
X-Gm-Message-State: ANoB5plGwlORzisMD3Gk/2j8hXDiCPQi4z/7XNP9kEs+ZqU9TUYBt5ky
        uFVcA6u5S2E2m6CUuwW+JxIlTQ==
X-Google-Smtp-Source: AA0mqf6tC52YycsOvnOOmbC/iRb5JZAhdSms4tMO+wgiZ0ucy/7HuwcUo8JWFybuPUgc5FdoTevJPA==
X-Received: by 2002:a92:dc91:0:b0:304:c683:3c8a with SMTP id c17-20020a92dc91000000b00304c6833c8amr235836iln.3.1670889874868;
        Mon, 12 Dec 2022 16:04:34 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y17-20020a92c751000000b00304a715461esm2538021ilp.16.2022.12.12.16.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:04:34 -0800 (PST)
Message-ID: <08a7e3e2-6a34-bc85-9d1f-58cc07b22429@linuxfoundation.org>
Date:   Mon, 12 Dec 2022 17:04:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
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
References: <20221212130913.666185567@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 06:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.269-rc1.gz
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
