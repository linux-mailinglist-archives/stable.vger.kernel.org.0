Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9DC4AA128
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiBDUb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBDUb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:31:26 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD7C061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:31:25 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id s1so5832208ilj.7
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SanA4GDlR5Whk9jeOemHhPXOtbgJqCuYxNeXmNMLmIk=;
        b=gwGXARR/f65fB6eH+zy/p6Rw04Oiis4iW1ZLHRazL3p2OGWzxzqbW2vulN2rjrnEOr
         bp/Yq4akKrmP+M7IBlTrD44jUt634BnrzYiKiZHbvG3xXLSDlfzwZyDWJmY9vOLOnUnN
         3QoJQEeSDXWTfHSlsH0wVbP3KMeVJfHwp+MY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SanA4GDlR5Whk9jeOemHhPXOtbgJqCuYxNeXmNMLmIk=;
        b=2acvE+BVsYGSezwblHrh0ge4VOOLV/pIPHGHYjPKLSVLWZoGoMtdjX3k6wJDpgY5Hj
         hn8G2/ALbcW12oDTdFxVztIkaj2NtSop+ANB1dkYi5M6BAZN8ibSfDZt4OrqQM1a3TBi
         sQddx11x0Fs8ZjoWlIEqCg7m9uFLXsAE8BhKvDk2GjolJ3XQjgluVtEDJSETx9X4CtDv
         1Hus/eQsUjvyo+7ty1/PK+BqkZlrCq2dxfTHSznYvYMO4b+rSoN3d05AnvYQRObuMxoB
         ovwwXk7xwTIli9DmrWZyip1zfNFkK+FLGTtPZ8NiHw1QTli37+kRU9aO8KNHbaummhMN
         aqQw==
X-Gm-Message-State: AOAM533LdM9NEuGKNjOacfLZ6xMMOvPKwKMo0w11MhCkle/jqhU6DLvH
        bpQOd2Na6m5h6vvcSClMNrK0oQ==
X-Google-Smtp-Source: ABdhPJxocdbnXNFSQPT82Tj0XjLVWDbFQnAc2xLHYwotYn9BF6gNYKZot5zheC2jhIfgdk+RCLo+Ww==
X-Received: by 2002:a05:6e02:1b85:: with SMTP id h5mr459411ili.107.1644006685175;
        Fri, 04 Feb 2022 12:31:25 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id a2sm1525695ilj.35.2022.02.04.12.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 12:31:24 -0800 (PST)
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <70964af1-5f57-95f5-d1c5-9a9cf5b1b85d@linuxfoundation.org>
Date:   Fri, 4 Feb 2022 13:31:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/22 2:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
