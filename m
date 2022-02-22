Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588504BF073
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiBVDmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:42:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiBVDmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:42:16 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C221D0EC;
        Mon, 21 Feb 2022 19:41:52 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 75so15928666pgb.4;
        Mon, 21 Feb 2022 19:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Az5mT3l0EY0TiTD6clJqf4+NEkLcgF/C0A2O8IswqTI=;
        b=RyqNe+RQmMrwqCDVaqKWyVdgOFFm0qW/sMLayysCTUq2g/UAPIJPIAcEhXcoYvmDIT
         AXJqoSqkzpHN3eHJZ2kK/glmlFx9NeKcArk88qiEFQYOXbqrZEH/qnv/lP6ZizyEpK+S
         w6QIWouPRQHqon7dcIh1Ie0m6P/EUdnBUToemTN8gyRVAD9DTQk977D4K+zmOs4uj/WE
         cgl9dQPGM7unL5NkcWouSJG0IFyCKVRGzUnVX1a7U/UDO0o2JdVJ4fAUI97axNA3+8g5
         hYRHagbCAp9g2+Vro2Vzsrom/NiWFXtiqjBao1hCDZhFsBF/Aql9Hk3AfaTnGqHy2NmL
         Ej3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Az5mT3l0EY0TiTD6clJqf4+NEkLcgF/C0A2O8IswqTI=;
        b=Q2FTlmOdYB3UavfUcWILZ/BHArvUqBnJdnvnuOF9O0o67rJjsXR0Ou38q16dbuLPNN
         jsA5q+mEvG2e3daJbMFFTKrWQ5pQQUQFwlgnOvRGj6DyZYWOcNAv9z/rhmfKOgSz1FVb
         rdt6WcvjjxFSvLniCybhil0Vz1xl6qlFmHK82TztAynBnGg/2sa7Asg3mTMN4bYi7dFY
         3+1ozzBKVxpBxfObIW97rgXAhF4LAJh8/Nu2I96ItkPcyz9An5rWNJR/DVwHTXLi/izY
         zDf3gtERpxxUQRW0sVgWGcmZLwMl56qlOuCi1Dp14arsjOXLY+cUr1gmLTsE9SbEPU2F
         iJ1g==
X-Gm-Message-State: AOAM5305QrunjJ+xTnCePw/4osYQHg5gTSpf6E/WiS/kBQRTHsX87hhc
        S9Ok1Rkk1shwI+LcBRMe4Sc=
X-Google-Smtp-Source: ABdhPJwKTWumvhDT+bauMkPh/vzJK7aIQJGWwcf96Z3Lwbp78yNnhY/BfL9Ew73LaBnt1NG9JC9pgw==
X-Received: by 2002:a05:6a00:130b:b0:4e1:7b1e:6c6 with SMTP id j11-20020a056a00130b00b004e17b1e06c6mr23100473pfu.22.1645501312366;
        Mon, 21 Feb 2022 19:41:52 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m14sm14614381pfc.170.2022.02.21.19.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:41:51 -0800 (PST)
Message-ID: <5cc0b0cd-fd70-6fb2-bbde-82729088f0ff@gmail.com>
Date:   Mon, 21 Feb 2022 19:41:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084921.147454846@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/21/2022 12:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.102-rc1.gz
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
