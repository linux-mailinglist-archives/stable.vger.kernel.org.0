Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0958248A354
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbiAJXAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbiAJW77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 17:59:59 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB40C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:59:59 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id o20so6363099ill.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TtsBcu1+23xAPrfxZSBmpKKMh0jS1ZBP4An2ckv156M=;
        b=aaCinCtn5hVrVKLRG3gM4GoypthOeFEoro+0NpYjYBary88MSrCsu509fXxN+KKHCT
         1/5inDJXe5n6N5HrgTY32mify7d9ReKdyEksccT4SDuy/DL8a9Z1+/GfdMxoYzy1ujfY
         rBJSWNFvlnMpBWpsD2cdEu5Ue7cTdJZHId6uQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TtsBcu1+23xAPrfxZSBmpKKMh0jS1ZBP4An2ckv156M=;
        b=wzwyBRXSvs5d5mCtTQfM3Ddni8gmmF7fD7cprQYJaQAQb2LSUueM55ausNCCnB2URK
         Zf7hhC6NTlrjNOIH7piU5Maw2cUgOXbN/yITBvp7F8eIi5yKzy74S+vare6gpA8DY77e
         xDsujnA0gP6qQyE6UDeynu7Upo9QmbTZ98E2OiajJ1n6vDpAfL7/AZMS+ZwZK/UlWi+Y
         DSof5M7ykhlWh5pTFsklvqLtq+vm3nrIW8tL3P6gVb36UA7jAG+rx8SbZknZq4zK1oAX
         NML5kCeJi50+2nB5ltqA1I6lmomc+Rq1RhZL56YbAAPor9jU8vWGihcaezDGtjtIQJ86
         6Uhg==
X-Gm-Message-State: AOAM532pOYUySlbo/Rsyx/wPFtmC29fggn0dmsDL54yfehtMOyiUpUo+
        rpRYPIedIPSC2cWCLwcLmhQ3mIQDKOvt0A==
X-Google-Smtp-Source: ABdhPJwvdjwccRn077WKXk2omKfxxijmg++DGuGGAUH0vIuZAeEcT1Y63WRYuVzFNDFbeDLNOj2MjA==
X-Received: by 2002:a05:6e02:b21:: with SMTP id e1mr1117192ilu.254.1641855598599;
        Mon, 10 Jan 2022 14:59:58 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t2sm4925236iob.1.2022.01.10.14.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 14:59:58 -0800 (PST)
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <46ebcbcf-016b-211a-a7c4-79b960ec0238@linuxfoundation.org>
Date:   Mon, 10 Jan 2022 15:59:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/22 12:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.225-rc1.gz
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
