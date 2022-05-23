Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A072F531EEC
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 00:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiEWW42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 18:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiEWW4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 18:56:04 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05474D71
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:55:59 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id a17so2627598ilp.11
        for <stable@vger.kernel.org>; Mon, 23 May 2022 15:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U9M4N4R4YmEK5KMBkskCB/oRWCV30tvdMAstZxSuIAQ=;
        b=hkKAhBd46OIGNX1hw8tLYF3Z0uiZ37sXkakDy0KuvtGjGNFhaD3W1cdcshGQJxnv+y
         0YGGOU6txAneyCwKfbA9S9gZDeaXk3tFKcjF4KWjn67agPD/X6LYRRByhX272y02dGQI
         pXDc6796pVhmYzcSSvdfF4Jj+tMl9wlxEl7Tk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U9M4N4R4YmEK5KMBkskCB/oRWCV30tvdMAstZxSuIAQ=;
        b=4kOkHIbSXlb7ae36MudREwXOJUUhu0+Yz6y+hz/ZmPKy9Fb+F4V1ZZ8jXfY7ju/RWt
         bf3u2b009VdsW0Vy+huOkvB4lZdYwIat2isshsaobS+GRhlCghwlVyMc0k+Wlqb7hV3B
         9BoVgta2Rgan469zkEKMSPQFvetd4RUUPZftLDxiPZmnbKOGnPdZFa8UsUEi0uDSU8li
         YReNp1CZ5HKlGkAYGoQ9UEUWwDmRqFz8cyX3OcdVi18Oe9r1016MXnyKjk1oYaalSJ5A
         XLIPzVqUskgrgLK8bA7xtyFgcXs/cE0UqEUqU5wokfKqt6M9UbZwF5HjiwyVFVdHDOv2
         NmRg==
X-Gm-Message-State: AOAM533szxR01S/hNA74Wl4HuTeGMDXsDhBAAJruH+b9GoHYj71poZ8F
        rvp1NNmyG07cD84OYF2ghV3JEQ==
X-Google-Smtp-Source: ABdhPJwNE270ms+Sf0ebCfFq/Y8Hj9u92ywJ9OPIMT/NBdiwa0ZMuV8/m5P0bf+KTGFFyMapZ02mCQ==
X-Received: by 2002:a92:ca07:0:b0:2cf:95c4:9e9d with SMTP id j7-20020a92ca07000000b002cf95c49e9dmr12617339ils.99.1653346558375;
        Mon, 23 May 2022 15:55:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p36-20020a056638192400b0032e30badd18sm3036862jal.178.2022.05.23.15.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 15:55:57 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3e120f45-2ec4-bf02-cf92-2d720143994f@linuxfoundation.org>
Date:   Mon, 23 May 2022 16:55:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 11:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.10-rc1.gz
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

