Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88908643B58
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 03:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiLFChV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 21:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLFChU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 21:37:20 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E1B1E3F8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 18:37:20 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id h17so5967162ila.6
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 18:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GNScNH2mC55hyQ2EjG18JxnpDES6/f81YAiBii42X2E=;
        b=XIiCd3s4GqyJ8/exjDeR8qwfTvYjfmbKDx+ZebdaD3krzA6PDMmwSt6p1hb4vauI1g
         im+93YugdWw5s+ELHXzQvSqEx6tr+d6zu4NHGt6cD6/bmmJdkC7LfuNg4d0aCvMUxXuX
         Sv9JT4LyGYCHbiXmacEPz69SmJ6Gu4PYijpCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNScNH2mC55hyQ2EjG18JxnpDES6/f81YAiBii42X2E=;
        b=Zd9FGUXp8tIa2htRxHoHIcsknH2tyhsJSTdczwx3Ao6vh7LXOJrMYShujWecH5Wb3Q
         p4SQpePQMItT7EJhF1+7rvRxgxGCczGm1pfyf2Mvx3iSY8rON7PcPWI65u/4rqtyl+Ld
         wZRAaHl529aMeFmjRu4zK2YQubt5yoOu483n/czqRhhJAIx2cJP3tELne2jYTaGQvR6/
         BEAfGPWrSnsnGt+PHb7wUUTGKNtUQtdruZDVrwkjJFvTVTsjqW7XY+j6HcmNlBhefWAK
         HvNZ8HPiJCMyi2VdL6kZFcwwWau0Vxf4TlWsIc8RdNb/nlo2AX5bMGwn1PMuqiH7F8Ts
         lqCg==
X-Gm-Message-State: ANoB5pkp/cw+mS5x6Soqxs+xfX0YnVSo4y3yr2EFNfoH7fhGWHE1lnJ8
        XS3Ar1mukxMhsXOH2uNo4g7JBA==
X-Google-Smtp-Source: AA0mqf4Mj4RG5pdSvPG83YCVSRmrnug1F8/f4y60frhQ/Rx+pIOfBnfwQHodAbO/YuFr7Cb3Qz2iBw==
X-Received: by 2002:a05:6e02:809:b0:303:ea6:3caa with SMTP id u9-20020a056e02080900b003030ea63caamr18994047ilm.161.1670294239308;
        Mon, 05 Dec 2022 18:37:19 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u15-20020a02b1cf000000b00363a4fcd3a8sm6150367jah.5.2022.12.05.18.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:37:18 -0800 (PST)
Message-ID: <5adeb833-7b72-b100-3608-16f996c447fd@linuxfoundation.org>
Date:   Mon, 5 Dec 2022 19:37:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/92] 5.10.158-rc1 review
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
References: <20221205190803.464934752@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 12:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc1.gz
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
