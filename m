Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40D13BDF77
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 00:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGFWrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 18:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhGFWrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 18:47:15 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60305C061574
        for <stable@vger.kernel.org>; Tue,  6 Jul 2021 15:44:35 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i13so437431ilu.4
        for <stable@vger.kernel.org>; Tue, 06 Jul 2021 15:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ah8H7xJBllOpFH6dhVLuUDUqST9fWV1SaPDsst0DPE4=;
        b=Jhu0OJ7t9HeDfOpwojeYJ85Zm/K7lbXmzvMDmLn3axcMph7IY8zMWNTpXuLhJ8Hcxg
         lawQmjkx73QhvmCHOvvChSdsCVOd0fN8eNJj0cFODk0PTU3zKt1eG6AWz6NE/37+vT5a
         Hnz3fIXPveYYcmteE97P2C6HssNbLHtY7/tqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ah8H7xJBllOpFH6dhVLuUDUqST9fWV1SaPDsst0DPE4=;
        b=IJJlHO9NwHZ7fvWJU48OoJMf8BlDQywMJfJjJztr+YrwhyKsuFtaD1rGUhdEFxVjAl
         uUKE9ks2iiGlw74B4c2JlLC4Sgo2hMzNASO/4X4Gu8DGgWxd1OZAiT4yRSb2lXPX7RN8
         qKZF+aaQFpyBWcnU15SIDXkv3EK5tBtW+r26MfBSigyFo4aC1o4640XRXZLFVOnk9xUZ
         gux+VYFx4zc89KJM4JdpINE8JpKYc7oJqRCLhm0N8Thl3vdlS7Lt9/U3/mU7P9/2xy9E
         TGJvncuH8y6iS6ADW31uoE2q2z0aKkLvnpBrVH/NA90xVAL5foMkkbtx5RLCbOqAoxo3
         +Riw==
X-Gm-Message-State: AOAM531uvvPYigeZ0EHL1/k/kWe7h2Xz/vonva3bS8n4/AqZV3KQx/ya
        wCkAQv2dyxB31qvJfRro6XjAeA==
X-Google-Smtp-Source: ABdhPJy0G48xTxvkntwpR90zm7b8S85RFeJcErLwAlUftDR39Zh/0soQDY/UtPcsDRVeqZ4lkekZdw==
X-Received: by 2002:a05:6e02:1a2a:: with SMTP id g10mr14245312ile.204.1625611474883;
        Tue, 06 Jul 2021 15:44:34 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i7sm8658237ilb.67.2021.07.06.15.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 15:44:34 -0700 (PDT)
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210705105957.1513284-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <81c00c09-92a2-55de-02c0-6bfc06d60b03@linuxfoundation.org>
Date:   Tue, 6 Jul 2021 16:44:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/21 4:59 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.47
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

