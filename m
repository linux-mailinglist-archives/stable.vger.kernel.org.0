Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7144735FB
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbhLMUbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhLMUbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:31:48 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B67C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:48 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id d1-20020a4a3c01000000b002c2612c8e1eso4463669ooa.6
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 12:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60FFvlQx8M1cv+xd9QHUP20nqXnsZUgkVALdIiDeSU4=;
        b=WliiZyVQof9aomFhe773ju4Yf0eKYEksu71xyXyzN87pu94KpBqp2nvzNXy5/37Q2x
         OOeU0FIYZgzjYma8NhZe0cXfWM31rQq/SrbzQQ+JJVpv2aBePqdYrzxlYb270QAEtuQC
         2FsfsksR9r1wmLmgV6xE0fXAFciaHR8pepYT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60FFvlQx8M1cv+xd9QHUP20nqXnsZUgkVALdIiDeSU4=;
        b=NyL7i/642Bdi5G86CK6/WU3pFN4vCozZmAV5a9HQFsCoBew+X4F657dgwv6CQWkm6R
         B9hOps9gdXwyno75zplUHiIeCC8SnmbtIJ6BqC7W4I1rPPJ3rdnZSvpYowLI5/5E3hRK
         OITlUtHgNOc57ubqRlGSnoNAwyb776ov8t6Eg98dD1xWf5tetr672tmKcFN4TD/lEbCl
         cQe/x1LYMT1qmtzkoXOdR5W8EOONxw2hx99ZVgNwyEuZ9kWGcYQ8Q5SyUiwH8uO+/fOS
         YZPaCLonhp+g1Kh8G4CzjTBZ+Jv1Ue3524fb/LcUoNnOejowOHP+gAhMVOJfbrEfunn1
         1yxg==
X-Gm-Message-State: AOAM533YNf0fi9yjC9QfxnkXRoE73oKDSEm6ynNQ1K2ogTi5rA6NCWU8
        +PhpZCYsDnGO4czvdtpoXErvqQ==
X-Google-Smtp-Source: ABdhPJxYbJ16guwKhlXoSROxPRg5DZcSs3v5a+pKXTBhDSJI72u9hRaFViR2P5wfSdd4IYq3RIKQkA==
X-Received: by 2002:a4a:d8c7:: with SMTP id c7mr526010oov.58.1639427507459;
        Mon, 13 Dec 2021 12:31:47 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m6sm2325252ooe.24.2021.12.13.12.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:31:47 -0800 (PST)
Subject: Re: [PATCH 4.4 00/37] 4.4.295-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211213092925.380184671@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <127a1f25-cf79-4af7-a5fc-7658d1acbd40@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 13:31:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211213092925.380184671@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 2:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.295 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
