Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F049AC38
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbiAYGSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S251780AbiAYEXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 23:23:10 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4C6C036BC8;
        Mon, 24 Jan 2022 18:57:19 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id x3so962467ilm.3;
        Mon, 24 Jan 2022 18:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QPv0H6Gq/32jL7217UDBjUXQqrhpURdnYoTd5Oz4t2U=;
        b=nQfg3Sx5yGHHlzPJzKeLJBw1pU4pJLciq/rHxf7rrCd16hpXH/LVNJ/xVFvkGtWz/t
         ZMS3lTXrssx0wK0h1xGWgRqUttYHjzpVnC/TvErfqOyh5WBbvO32/Co7ZsXPrfg/p5No
         8KGFXH1WrZMJquI5lIAriM1U3WuF6E2RYJXxWYZ8f6VASsL1SpPhXHK6KmVjCVFktVv9
         YrSBsJzesgzWcsMGBD9zqzB/jAWJPpIsQNxiSRwNTa+oLRhIt3YM6omawsZ9Vj91g291
         L5R/nqUZ+SChXpXaJrMkyUbBfcbhBs2kbaJ01UOYXRRfyja5JSFeTvsrNcNQzR96Ytf5
         Xmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QPv0H6Gq/32jL7217UDBjUXQqrhpURdnYoTd5Oz4t2U=;
        b=Mpn1nZBAhqrerf836d3YmjAHIoGKq/ByxNU8Q5IysWbLb9egFfYMooQahewHrUMRJH
         PKG/n2eNWcqcLFziDaXzOt4uNivVPF8c1hZoXuEcAstQiB0SYNCRlrDT6nZPWNkK8cgC
         Bca0EF253zqw2PYeg/oHu6xEdrzfOXFiYDrTZC3hU/xMymgdmh+NhNvinVpbZrcKGbfq
         Pct5Q/SoBOOM8wOvk0NLVYK7+xVxBgs17pJKSitq/IjriGjH46yxb/P8TkGmEdFsHrdk
         mE4TNeRx91AzTypMR5E+c4PXr1Spnb9+migRZ0Qr/z802yrajqCqlS00c6dvs2pX6VaQ
         sGfw==
X-Gm-Message-State: AOAM533GZ3iy0j++nFAsQjYVaSk9LfIF0lyY5QrisTM7G5/H59imE8bl
        uYarDfeRNimhcLJ13WKSrUg=
X-Google-Smtp-Source: ABdhPJwEwitvfeVHdVQCzyZ9JmrhkAoqCe6S8zQzO/RebBN+NLHzp3GMQlUt6JynkrHZA9xdHL8/FQ==
X-Received: by 2002:a05:6e02:68c:: with SMTP id o12mr10272160ils.245.1643079438338;
        Mon, 24 Jan 2022 18:57:18 -0800 (PST)
Received: from [192.168.1.99] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id o14sm8386746ilq.21.2022.01.24.18.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 18:57:18 -0800 (PST)
Message-ID: <89d415a6-7165-b1db-1f04-307f46bd07a4@gmail.com>
Date:   Mon, 24 Jan 2022 19:57:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 5.16 0000/1039] 5.16.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, zanaziz313@gmail.com
References: <20220124184125.121143506@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:29, Greg Kroah-Hartman wrote:
> Hi Greg,
>
> Compiled and booted on my test system Lenovo P50s: Intel Core i7
> No emergency and critical messages in the dmesg
> I am going to be running perf bench sched from now on and I will
> report any regressions
>
> /perf bench sched all
> # Running sched/messaging benchmark...
> # 20 sender and receiver processes per group
> # 10 groups == 400 processes run
>
>       Total time: 0.437 [sec]
>
> # Running sched/pipe benchmark...
> # Executed 1000000 pipe operations between two processes
>
>       Total time: 6.919 [sec]
>
>         6.919489 usecs/op
>           144519 ops/sec
>
> Tested-by: Zan Aziz <zanaziz313@gmail.com>
>
> Thanks
> -Zan
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1039 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg
I am going to be running perf bench sched from now on and I will
report any regressions

/perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

      Total time: 0.437 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

      Total time: 6.919 [sec]

        6.919489 usecs/op
          144519 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks,
-Zan


