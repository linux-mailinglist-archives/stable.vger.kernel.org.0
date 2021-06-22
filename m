Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53F3B10DE
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 01:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWABV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 20:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFWABU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 20:01:20 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C9EC061756
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 16:59:03 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so219310ota.4
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BhbBwc//KduXdZRjlGjn3H8K+2RWn0DDN821jLw2+yo=;
        b=S84QglCpigVfDiOcQKNrdjgnYejdvh4B66yyn1lOBemGiQXgSuOf+rx+JyWiihJY0M
         zt2IwmZc08VQIAZ9hyjXC6OjB1Ljq7JsmH4DzzVCvLle9Vla6Gh5Fl0UiOMmirWgsWVl
         m+1Cs+IKhpQ4l9saUyPsdAJsaJx6obufkV3Us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhbBwc//KduXdZRjlGjn3H8K+2RWn0DDN821jLw2+yo=;
        b=l7xgwudNggIpPFDwdK1e4CnDiqb3Mq9R3Pt4o9cKByhHPaLPM1NThVJ2sd/tMlcyvZ
         +tgGDWSns6iRvX0QSDVrc7ggD07YtRpaQkh5bsa5tdOOtfCmE12JW97bBNJXmZDGpXI1
         3lfeCdHTtCJCdleU75cE/8/FJ2ZXFqYzzXwb5nzIxTQaCVBt+k3sF3ydryHqaPpgLBQF
         CbMFIuacLL/3LiLlMxY3VZ0LvoqGJDDnWfUmqeH5bTIG2J0lbGbVMGK5XbaJTwGfXE+C
         fQ8bPMZPMRNufJ0cNEl3YFaePlBlpOI0ARhIIuIyFV1Wd/RZBgo1QFLl4o4MOUWbEcHl
         Gw8Q==
X-Gm-Message-State: AOAM53023qstZXrjdkf3kAWB2SahZGZpCRfry7CEZfxuhlvgnyGaqihi
        32nEQ2N0Mv9qGKDsYIKFGvEJDugGraCn5w==
X-Google-Smtp-Source: ABdhPJy+PipDCUJZD8cIo8IcN+L4nKBbDX2YLhWl5ZyTYKUcXzKcR4NaFA3Xb/kfDsjHbAc8iQ7s8A==
X-Received: by 2002:a9d:354:: with SMTP id 78mr5247856otv.297.1624406342736;
        Tue, 22 Jun 2021 16:59:02 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c1sm207317oto.34.2021.06.22.16.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 16:59:02 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <620a40dc-9f6b-e3b0-664b-be53158dfe41@linuxfoundation.org>
Date:   Tue, 22 Jun 2021 17:59:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 10:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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


