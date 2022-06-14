Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066EB54A76C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354645AbiFNDJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353841AbiFNDJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:09:19 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFC92AE24
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:09:19 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z11so5681755ilq.6
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+u7tit5dePdeszJPzkquI25j79UMUL4eAqYRMdwtm/w=;
        b=iew+ylXoZaNuQ03Yo9D3Y4ZJEYt5IK+hyeSA2sGBuHLt6ZFMpUQ1tSBDCemwcZLKnh
         lHDNqASha9GhazSl14oqrQmFwan1ZBiPqatvErQEmhytQF/4c0q9jESGbyh8ugFrGUAE
         9I7ymPk4ZoUXLtOEmGoJjq8yEJoQcTFDus+BI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+u7tit5dePdeszJPzkquI25j79UMUL4eAqYRMdwtm/w=;
        b=P9KVRh9Q1DsP7Z4Tv1JE3EwmXBqyg2Dr6mQjnFoTnSDLf35Nm5b+LhMO4/IouFie2N
         /jSJz3aBGOM/7d7/jiDV/l4FLWjHtCDRXjPw7LGbGsUv7C+AMLLQ1CM2J2+R/IUiD8LL
         rie4xqG/ICyiWLVYYFhTBOGLcuJG6KwQDn6cZeChSUcXv1bc6u7EQ6WibuRX+cN0Hcdk
         EZ/KGznAJVcTxPzKvh0ao2od/vin9AyK/L3L6dpOukpo+2g9ufvimGfcwxA1eL4FUAms
         likq0MJtbE2+cJExMGw8Epn47jTFageyiL3JlQGGcSQPQSCZKS2jt4/9h4mKNpUEvYHz
         8liw==
X-Gm-Message-State: AJIora/sF8Dl0p7MWGULz3lJGcabflMTope+YEDLFT9HHuivcUUFa0j8
        FmQOu05WUqOcRG4w62o2ej1Amg==
X-Google-Smtp-Source: AGRyM1tLHonWKVKVXSQRiyduuEprErsDZUIKBJTsc/UeWqdrsoxZVYGhcuuuFJFJ0svn/lnohFP8tQ==
X-Received: by 2002:a05:6e02:1b8f:b0:2d1:b707:3022 with SMTP id h15-20020a056e021b8f00b002d1b7073022mr1753978ili.71.1655176158496;
        Mon, 13 Jun 2022 20:09:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z13-20020a92d6cd000000b002d7903d71ebsm4748355ilp.78.2022.06.13.20.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 20:09:18 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/167] 4.9.318-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <22e01c53-ef18-9bd7-1a9f-30ab710c7025@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 21:09:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 4:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.318 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.318-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
