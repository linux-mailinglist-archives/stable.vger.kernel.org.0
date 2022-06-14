Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3F54A758
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiFNDF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiFNDFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:05:34 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4D82B1AA
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:05:30 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id y69so10070057oia.7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o/0wR2vM2bbKC03bV5NcozOvV47IHR4820iRSTaVlh4=;
        b=e+0h4INmlWjUzqgyYGlLl5pHQRQfFRqbaLvk81RWnWt52IDXTl/qCIDnyNOA5U84qr
         aDnPG/Dov5pSXX9XItKhd/o6S4yV5nD0acShAOBhEgY5hDUdDEzgtyEvlxj1MW3RqvKq
         WiM18H3DOAfKMeU3ijFcmRt+VoAGuwZQEzrYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o/0wR2vM2bbKC03bV5NcozOvV47IHR4820iRSTaVlh4=;
        b=uW2Sc52q7oBE7b9d/CQ6Hu4TOznawhpyi+GjA92p8d6x0qqIxlSbSQo3D0Aa5VjwbE
         2HN8j0n7+ouuLsvrJJrKy7Hq2Eb7iBmUoAyllnM6XaTbI5yNJg3kTf7+6enRq6EHVbk+
         MWeR4Nrylw/D1ariUDMyfDWhlyJ6HxJlq7cX3PNuW+eFKVYf4g182wJWP71dVfjHE8mx
         wt1rwgVSTl/xQK6bGl/bZ8qwun4B2zmNewfxRWEIc8c/0fVUffXBFrwJYeJ67Y8IF0Uw
         N2WwzFzpqvY1obciBL0oPGfy93ux/PLJOalfu71mirpXVgDfy9zyXyjmfjeDEFzdYa4K
         WXhA==
X-Gm-Message-State: AOAM53150ruBZhP6Db93S1sFpfGTrA486vXKAaz0aX7VM2J7vXWVE+gi
        ZxmvFv56cAoarnO5tf3YYGSVFg==
X-Google-Smtp-Source: ABdhPJxv+AFfo3HjApsL1IeqWrSraKXBEtOC4kWYG2qBcW/UbLaaYyaqXQrI6419Byznj6wcwlYNIA==
X-Received: by 2002:a05:6808:1710:b0:32e:37f6:cbe1 with SMTP id bc16-20020a056808171000b0032e37f6cbe1mr1032751oib.114.1655175929281;
        Mon, 13 Jun 2022 20:05:29 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f5-20020a056870548500b000f1b1ff7b8bsm4809912oan.51.2022.06.13.20.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 20:05:28 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220613181529.324450680@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3192c16b-05af-5d1f-2b44-449aa336d38f@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 21:05:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 12:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
