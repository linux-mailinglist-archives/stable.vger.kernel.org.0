Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F856C2580
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCTXPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjCTXPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:15:54 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6737244BB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:15:52 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id t129so6201813iof.12
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679354152; x=1681946152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtAxNqWOHwLE7yS51A5Odfdi6tRaNsIBNbTA+Awvbiw=;
        b=gmXoMlyrRZWnoT4iQk9DZz5ZraHN2NdE7axHAxJSesQXGmlw3Cr6Lz2F0muj2gdh1U
         lM80APvBr+nT13x4E6cInaKAjMDeu2N411zee2x5VwoRj3D/Lo9dM332gAzMK6yZPgg1
         REwbsI/vMYVrSQuQdgjfz2PO3hyaqzwoMKulA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354152; x=1681946152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtAxNqWOHwLE7yS51A5Odfdi6tRaNsIBNbTA+Awvbiw=;
        b=OOBlAUpR7G2JTyI1I2LLsRJ48S5xAJa3ce06xikNYZcwCuL1ORi19OoW9vOswl2pFQ
         ky7uqp9sJ7YGRgCUozyM6ozaKIF6mgengFiuKdltB3QYAH6ClHCzeGkC+Dch+Zh55Klq
         b44fiy0YWy6A7XwU8kgqTCv2ClaThe6MvINtWetipo1/dm/ClqCbE8hEqu/lTFH+hU16
         akTIWFEA7BzNEm0F1pqMAocCJlz/DRMhZxJrdwqH/KooLTRJirXoNff9pMGDl8ldfSwr
         uevr4nkls4FttOICbkxaRLP3ZgCTqXE3+o/fS1yCUN3E8JFyg9SfE/XejCZKpcFoo1bK
         vsWA==
X-Gm-Message-State: AO0yUKWqdXSGtT5pSrh2xIkcKIhmBhPOvayBTkFKXMh3k2YFNdMzk7Xy
        fRPY3dttAa8ysFRJf12/uvClog==
X-Google-Smtp-Source: AK7set/zjBPDnMBvyuINBNDZgvU8wFXwpesmr0R+3/eILHVMsS7RDiWwUqJuAFgRxcQ/8IIUfS4l/g==
X-Received: by 2002:a05:6602:2a42:b0:719:6a2:99d8 with SMTP id k2-20020a0566022a4200b0071906a299d8mr1130485iov.0.1679354152132;
        Mon, 20 Mar 2023 16:15:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c22-20020a5ea916000000b0074c80aa17f0sm3276618iod.0.2023.03.20.16.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:15:51 -0700 (PDT)
Message-ID: <e3ea7b81-73e8-9ca5-4588-d7aaf9f2dbc1@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:15:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
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
References: <20230320145424.191578432@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
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

On 3/20/23 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.279-rc1.gz
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
