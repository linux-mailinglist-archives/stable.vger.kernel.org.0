Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E964AA98
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 23:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiLLWrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 17:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiLLWrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 17:47:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5698D58;
        Mon, 12 Dec 2022 14:47:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so1505676pjr.3;
        Mon, 12 Dec 2022 14:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KyDNT2eNBKDwDp3YS++zsmDaZPh+lT+qP+XmfmgfjRU=;
        b=qGwobmmsTzDi+AcZz6YWYAE2B12GSkxeI6CkpycbgEYFQw2TYC8UNccsGr1D26F1aT
         R/0CJH5i07PemNyr4rIKf+aR71eP/JeFy06RtFunSDqRJXkUV3nGJNEvoRb296r5URAB
         akQXHYqG4U7ThdegZO3XF2/Fo13szTy1gv8PZjQER0RGpUdeEKJjxSlBj1CHFuVYJu5F
         yFlFJ3GoC7lx+Y+c75ndJ9vA8p4KGBf7dtXyCFPq4kdB8Q5w/5qqfIl/nd9EFGCEbREz
         EWW+AzgCWYm6nCmIj5i+IoCII9jVQdcJdha2DVxFQtFUjNMVxfkZBX3FzJvNKQvaatFC
         QGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyDNT2eNBKDwDp3YS++zsmDaZPh+lT+qP+XmfmgfjRU=;
        b=ncUbs9xnkdhBoGggqqLgy35SC7S8Bqc4RooUgbPrStJEjAauEibBYRd/WkbTkBZcwS
         yHdDnWMGhwvVTwFjp2RKeGsjILbCZebs/YMtvhVtNbMXeH9WwSANwEQOoSnaPvXkkUdh
         bgTCZpGYqm0B+5kAM4w2vtwyr+1IZSGS+Y2RGcV/0caBe1rGtHkEvif1122fnK2WacmQ
         IQljTA17OlEMLiyY5pWDx0O4P2zYuxd8lWMTvGkbfB4ZhFADzsATrMaVkGwtRvhj1h4x
         +Bk51fyCKgQo1tJdlRDbUlkgmtmvzU62JdvD9VDr2LvsRBuImM9ULYqkd+fyOsU6Viec
         ACiA==
X-Gm-Message-State: ANoB5pnhz2wgVS4pp35JkbYSSCWL7qtig6NlG7cEKHIBqHJB4Vl2Xy68
        fzTP8rkVBlbI0moxbLGa6Ks=
X-Google-Smtp-Source: AA0mqf7eKyi17/emc2cU4C7lquMKZa/sgyh5h0olmxOmcf2hQk2E1P6q9QNA4Bv3KTT44hAQPuvfYA==
X-Received: by 2002:a05:6a21:8cc7:b0:a2:c45f:f0fc with SMTP id ta7-20020a056a218cc700b000a2c45ff0fcmr23054714pzb.27.1670885223213;
        Mon, 12 Dec 2022 14:47:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e9-20020a63ae49000000b0046b1dabf9a8sm1196878pgp.70.2022.12.12.14.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:47:02 -0800 (PST)
Message-ID: <e335bee0-6042-c484-7dbe-4486c14c7ecd@gmail.com>
Date:   Mon, 12 Dec 2022 14:46:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130924.863767275@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

