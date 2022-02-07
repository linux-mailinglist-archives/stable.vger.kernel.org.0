Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D955D4ACB3B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbiBGVZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbiBGVZr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:25:47 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F57FC061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:25:47 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id f13so37153ilq.5
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 13:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MK45iSDYQKIefqgsXB7WneAkerASZCAD7gJ7W5/eKew=;
        b=MypfAe8p6YW5KyjOJiokX3QkGHH5R0kK/gu8sKnYeuAsrwpKAtrS3izg/GjOszk5W1
         14VG2NtJwzYjafZQpQ57AK4Xd5XA4fuj1a9Agiy6GzNkbdQ8eR6qyop1HeqRsDl8hZaM
         KY7wQVMkPbIYry/7WbYMFvctzSIm9hqOvMuPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MK45iSDYQKIefqgsXB7WneAkerASZCAD7gJ7W5/eKew=;
        b=vXoLZKVk6vRXWlCbpuos/jrT/BYcKmPsKPpQ6MyYSLao1X5YfSXsTVhC2NywklYJgx
         IJBuoiVc/sweNENJWwdnDGu/PPSGpTuRlVTZUvoN4Pq44aZzAGWVHJ7h2WknTbBosufb
         c/O4iQ2XL8h+ZOuCGwbqBCUecZ4BHsDyoJtAbF+bzOPfbql3f6ED2g+Wc7cc3ADQ+mRV
         ol19Tt7hVoWQicD8Oa1VqQFeatKGzzXMKbsd/vrdHiuTX4zM3IyxV0CWTRrx93ATCB3r
         O7VH8hGeLoUoJLd449rS87QSe0fOzPQNtF5Nodi4ropn1paLSJ83l/XagTPJsrAwkSDd
         ijqQ==
X-Gm-Message-State: AOAM533M+vofP1FerRL30nk0KoAyshfmU+Qw99jiMTlWjrKuX9AX8ph4
        1hMn1jeP1rpbcEPUEErk7rFlaQ==
X-Google-Smtp-Source: ABdhPJxYWC3c+Mgoc3aVRI92DCG7pY1xOCrSyMnsj6ZxmFHKP6/XasKrPNAc9N8/BBE5zHCbjh7shg==
X-Received: by 2002:a05:6e02:180f:: with SMTP id a15mr702670ilv.8.1644269146466;
        Mon, 07 Feb 2022 13:25:46 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l16sm3031468ilc.54.2022.02.07.13.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 13:25:46 -0800 (PST)
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <25120933-4491-b39a-6f9d-42bdb3343e11@linuxfoundation.org>
Date:   Mon, 7 Feb 2022 14:25:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 4:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
