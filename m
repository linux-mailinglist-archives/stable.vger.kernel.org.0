Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079EA66D376
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 00:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbjAPX6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 18:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbjAPX5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 18:57:47 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37135244B7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:25 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i70so5002763ioa.12
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4y0chPH8XRCcdBF2hAl+UEtCy8CCBFqYOr4KoVIAIlM=;
        b=SfBunpmYSH2pio7V7AGY4OLtI3BMU0OeuReqnd+dqSv+m52geBOxADryk6lrw5FkNw
         NO7cCvmWv6ZGPHf/dC6l6XWQLMTx8dUYM5htCknkmemQjYUvrj8FwaVDnXy2l5P4XN15
         tUOkltIZM7z6dkZAnDnfIukCSz4DqkcfBb534=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4y0chPH8XRCcdBF2hAl+UEtCy8CCBFqYOr4KoVIAIlM=;
        b=IUbNcMEIpUW6Lvbr1n8qr7PTbpSQV4Qu/k0G0XbDpCVMNbGfHU2qkMSb6yOEtFoj4c
         QBzX4LQvln9GO5xysS20necqtgR0MuFTrM5Pms2MZdfXGoQflu3FAHcVFc1vs2GX4NwW
         ukAu6MVtp2HArggmA4vDj4rMhoYZijveO3ee2ahg9Yb1gwK/t0acgV2TYVEFut0GcZXo
         lbDXbJBlgR7pL72zIRLOTGe4h45oiOVVJ3XILNBllpgWfCbJKzgPsAoLHLTgAeuJPfka
         CVaKswXWv6cMv2th5kxtGcjdT1pGuidN92vikOnIYQjg/q8iEhbDxHyKiHILTznefj5a
         sJCA==
X-Gm-Message-State: AFqh2kr8Tk1awBLymjB366chelPY7XxSHcBi3C2+Y9d55tEMxCugaV6D
        W0OgofWVvt1Efs4LSmHZdG7Axw==
X-Google-Smtp-Source: AMrXdXvyf1g9nsw7GmasQKuYuXvwJox6F7ZgL4FEMbeEbn8Lzozn5Goy89GXORdAto72Z6xYabIrHQ==
X-Received: by 2002:a6b:e90e:0:b0:704:bbb2:f9f9 with SMTP id u14-20020a6be90e000000b00704bbb2f9f9mr115998iof.1.1673913314577;
        Mon, 16 Jan 2023 15:55:14 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o192-20020a0222c9000000b0039e92d559a3sm6516285jao.166.2023.01.16.15.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:55:13 -0800 (PST)
Message-ID: <1a01061b-4ccd-0e2a-9e0c-b2ff03fb0f6f@linuxfoundation.org>
Date:   Mon, 16 Jan 2023 16:55:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
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
References: <20230116154803.321528435@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/16/23 08:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
