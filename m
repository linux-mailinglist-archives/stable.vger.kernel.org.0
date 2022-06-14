Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD254BCF1
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbiFNVqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 17:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiFNVqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 17:46:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E613F8BF;
        Tue, 14 Jun 2022 14:46:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u37so1302805pfg.3;
        Tue, 14 Jun 2022 14:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1eNdPfvX38pax2FY+qXXzY6vFul3pxSs3QGey2LtONc=;
        b=JT8D/VVDh2+09qUONO0frctb5saZdLIvyZ0loPRYkU5lXeIx7e9TxzZWhcB5kW2tJY
         KFGr15tY4M/N/0XmMH6aDWlbmvi/4CF8OsorSSJjRJMAWTzgXNTdxrWvxLg1yqGNoQ5E
         0QvLUOdFmsPOdApg+6tj3SLNnvgG6ovzlyG8OgyVsA1eHgEtgHfla4AsVhUGDTu50Ouv
         iM0rKmS9Czn+2zNqI7pAUVElRalvZf2cWWcSKRrRo1rmMKWr5nKpeeOkCcpxmexePlO+
         wWRAvbjrFZr1N6JCQ7/mTohD6mePS6eU5nYYFz8YfXVBLK7L1tOPxByvx8IKsSe/mWyy
         ccMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1eNdPfvX38pax2FY+qXXzY6vFul3pxSs3QGey2LtONc=;
        b=sSW2Aa5JfSi36Vm25avYs47z6tExKuHlDWgM2I8wSPuAnCcFnRPvUF6C+j5QH+thgs
         3/v5ptQ3XKqFW+e0H3gea+W7Xv3LaIarsI7FkImhHNEnCjlF1Dj+Uoqq3BpQl/5Zburj
         za/Aim5fvAHB0wiAtuYPAGcS10y62tQXAEXYgnQacN+HMa+3vn1rbdkUU7yfurLw6ytS
         /HF5nQeoFd9vO8ZCQbrR1LVy07DSJsVgChi1fqOnq50s3dMM92/xK5L7L0J1WflMgwYp
         0Gc76D0fEtAYAalIXaIz5mBuOASby0bjkMsiCXCG2MEve+kX0hcWKJEzRgJA4TqFTgS5
         h1UQ==
X-Gm-Message-State: AOAM532VEWtF7v1J3AsRpNB2PiKvz3jG+NdPbSx0M8zP+jgD49rPoBmH
        YqqNqYGGEG+HuOHG++aElrvC72l/SSI=
X-Google-Smtp-Source: ABdhPJzNTPFlWQyFD3KD66VHQTaKvSHsM4tuvUqpTAxq/WOSiEPFJRp3ra5YRin6ZS7tXyslsvIgEw==
X-Received: by 2002:a05:6a00:1513:b0:51c:3ca8:47a4 with SMTP id q19-20020a056a00151300b0051c3ca847a4mr6672048pfu.48.1655243207552;
        Tue, 14 Jun 2022 14:46:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w76-20020a627b4f000000b0051bc5f4df1csm8106616pfc.154.2022.06.14.14.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:46:47 -0700 (PDT)
Message-ID: <8afce56d-6c50-de85-0a98-6a6c46b63270@gmail.com>
Date:   Tue, 14 Jun 2022 14:46:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183719.878453780@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 11:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
