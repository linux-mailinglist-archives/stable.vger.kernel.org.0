Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B052271F
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 00:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiEJWqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 18:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiEJWqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 18:46:18 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94A69C2EF
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:46:16 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id bm18-20020a056820189200b0035f7e56a3dfso314988oob.8
        for <stable@vger.kernel.org>; Tue, 10 May 2022 15:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6kRzyDljcmaAdLXR+UhbgSyuPcRA97V1sG9nQjd/jWY=;
        b=d5OxNZWqXM3Xcei7VuFEYNHD80E1TPyE1loC5BTq8mv3LXlwiQ9os2zBpc6Al2uRjJ
         auVlCjDN1ymoH4wUhZ1+/IzEcdo5U+AgKALR065BUA4qI+VOR+neAqzQ4KMbG10YPwG2
         qa2W974X8mwqUQHllEckQhsFRLwno6F2HTH/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6kRzyDljcmaAdLXR+UhbgSyuPcRA97V1sG9nQjd/jWY=;
        b=wbwNZZ3qlhlCCZlwgWMR1T8gnIttNv238d7OuVV1WdUk3zGxYDp1rMU3B2vMwsB7oV
         Daf/RG2MB2dMr/NU4dYJ4T/I6v6h4MUGt7Pn8FALqDV2hvCFx3wmupnAtAROeA0Xmpbo
         /uiQqQMttekFhmCu4SlMcH7kCch0BJAqdVjtkT3jfHZkGw3ia/b2M97xzZdAWbk6z2z0
         k1aKXI67Ifqth0jNQtcsATcyjRqbiJf1ne5AA4ZN3mzstORDAhktGLISprntBFkEoyZ3
         Qz2Ju3lxbz18jDG/aYCnzIfBPF4R03Sz+L2m5HuH++02Pn/gzFFm+j9P9dQvXxd10z5J
         +x8Q==
X-Gm-Message-State: AOAM533EyDqDr4JGuzMn5XEvQB3IvZHLnIPmDYBBZsYqgMYyjDw09E1a
        DoJMrffhkXmFXaCdqC1aO2m8Tw==
X-Google-Smtp-Source: ABdhPJwFVsBkahLsEL3+icVodIbph+1G+z90o+JYhu/o1HrDlPjGVZjlb9u7I1quTAmpOlAl9rpCwg==
X-Received: by 2002:a05:6830:1dcc:b0:606:9d0:c0c4 with SMTP id a12-20020a0568301dcc00b0060609d0c0c4mr8667526otj.164.1652222776003;
        Tue, 10 May 2022 15:46:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u18-20020a056870701200b000e686d13875sm115930oae.15.2022.05.10.15.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 15:46:15 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1c7081ba-7c3b-58d0-c68d-ffc273a1f5f0@linuxfoundation.org>
Date:   Tue, 10 May 2022 16:46:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.242 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.242-rc1.gz
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
