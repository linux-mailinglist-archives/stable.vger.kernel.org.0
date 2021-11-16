Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930C44528E7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 05:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhKPEEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 23:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240799AbhKPEEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 23:04:01 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D70C07AF47
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:52:15 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id x9so18530969ilu.6
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 16:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GzOo5+lsZod50PestiKUsRLSwo+BSgSaswB9xMUzGjM=;
        b=bliEN3dBZC+OnBh8XSeqU/6dS+Fmzhm4BUHCFJTG0rQ2diDB2OwAQm8dBL3/8+//ym
         f3yZTNBHhh4qKSXtjWIVN0odqD6R1yDTlN4A26aj6aupy/hFmYmFQZJi865nKm6BwOVt
         sAE7gRVUVRWkhmcbdijaAOl4Fwj4uDGrjoc6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GzOo5+lsZod50PestiKUsRLSwo+BSgSaswB9xMUzGjM=;
        b=S4nSIn4gVUeM4FNN/DNvCHTssZlm33j1hfynBGAx4qtG42yzlYsc4RMN6mCgShWtLb
         l4o/jNhNStdUIT/JC13qO83WdNavn24JveoZahTKIsIEtnov6aKRIKyfEppo9ViZYCVG
         CRnXplmK/GZFt9nYjnh+H6Tmfhdr5SabXGIlbkH13ndS5GXq4N6fCDAUdN8wz1Zo0kM7
         pSyoS5ZAGEqm4T5bm9VyjSgJ0jNKejM1C/d8eA22BlHzPYi4z9ZRgb3mOLtX+Mn+LQwD
         rkp50vMXUHylEPdbTQxRxcli5eM09lvR+wxGWjxx6A+ljkIzRcxuKYFnaRDpU4Mj7THw
         AzHA==
X-Gm-Message-State: AOAM530RSDLokVZb2DHIRvkWKc76cQghGfCcDAZRPzEtOfXs9E9KqcKS
        /qB4mHdFQGccxt4wUqsSZ8k/yA==
X-Google-Smtp-Source: ABdhPJyn5PW+A+XcT8b8UVCVYQJY2FBOD3P7vA+t45hacPh+Wyp2LOjWF9NYfDCgw/pmPwtWoNztwQ==
X-Received: by 2002:a05:6e02:1048:: with SMTP id p8mr1931455ilj.174.1637023934737;
        Mon, 15 Nov 2021 16:52:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w15sm11275791ill.47.2021.11.15.16.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 16:52:14 -0800 (PST)
Subject: Re: [PATCH 5.10 000/575] 5.10.80-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ff63c8cc-bec2-7a4a-4da9-1293c02b65cf@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 17:52:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 9:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 575 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc1.gz
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
