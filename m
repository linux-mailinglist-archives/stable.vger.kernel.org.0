Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05353218AD3
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgGHPJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729815AbgGHPJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:09:57 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F88C08C5CE
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:09:57 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id y9so310721oot.9
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RWj01bK2pV6BNLG1xOO+3qo5uJchifSrRn1MyFV208k=;
        b=JL7Ptq9v8mdFU10Yb7O/YO4CxQYZcvDVSnB+qXTzB4NbiDvIYQ0ewjqUt0qeaYw5nW
         ltt/+5vEYCEg9hkpJudDux2YWtqB85ZRfe6NBuEf3fks9jniYOxoLPG/39GKaTWaNgoA
         URbZJFP9ISJ6I2eGSUq/DSy13hrJZdBbOk68M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RWj01bK2pV6BNLG1xOO+3qo5uJchifSrRn1MyFV208k=;
        b=JLL82ozg8BBIgebLKCnUs5bwprGAc4MQG5PikMyO2tp9++a2epkKrT5eC6obw6k5v/
         wU7054PWxeG2etEuKfpveqxLMYu//gveDdKYrAfWgIjbNHKFEsZPE9HKuo97aWMo0hlR
         EKKqrA+maRV0KqRl6YbXojnAZvNftEXdv/d/mPFjlWll5Qoan1umnUXfVZKuHuMtnWS+
         q7G/z70qq/WvFkOkJiKsVZjP9OJZziG35H4QRdooKexEdmuLHy01s1hPgpn0g4Iq7G+d
         FmkPzKKFHBGLQnPdcpCUZnQInhW26mxyzWfaOcGxCR+0vP1EpyMzJs7+PobjOkfRTm2m
         CYBQ==
X-Gm-Message-State: AOAM533x5y4zcnVAvZ/hYDgTRUMomDOuxY/c5qwbgUc4VMQw+OJgIkKq
        LWf73j7AVNp1iGtI92sgwkRZqQ==
X-Google-Smtp-Source: ABdhPJzeDU0yQw5v+TRW2Xctx5qi7v/jAIXc8qXyGs0qRRPjjtgTkEOTV2OBsQa0qz3NFmOmj3jwrA==
X-Received: by 2002:a4a:9552:: with SMTP id n18mr10303586ooi.1.1594220997010;
        Wed, 08 Jul 2020 08:09:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y1sm5770oto.1.2020.07.08.08.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:09:56 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/27] 4.14.188-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200707145748.944863698@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f11dada6-53ad-0e0c-dfb8-53bad936a253@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 09:09:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.188 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
