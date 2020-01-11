Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE3813823F
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 17:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgAKQCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 11:02:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43550 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbgAKQCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 11:02:44 -0500
Received: by mail-pf1-f195.google.com with SMTP id x6so2651366pfo.10;
        Sat, 11 Jan 2020 08:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8c+ewCIT71LKxJWBH8PK3kOCTkKpL7iAy1a7HDZYQsk=;
        b=HeyUmnQcv4c6wzzGb2sCjbUD8ROOcxrWOFNpcDk05zueWc5VTdZkrLS2VeSBMyE56X
         6YPvIyHOiJGTp/pDxxdUYWjSkRUxzTZnJxu1NQS6tLo8jPg5Jlqt8WHzN7pTmUNjEsmX
         VirNweX3ZQ+gs+RfutlNDiOyd9hiTnJXwISqDHXvyKvIzJHGwgOSpNsV8bKpbY6qFjzT
         UlYmugGL0JJ2cK/t+S6QiwCwZRUegzL52vmPZ/OkfL84to6k25il5sWwqRCrkeEpGe4z
         0lWjVp3ZIb/Zuv/WdsgjSKi3foqteahNRSdntVtPSAi0DWQDrYR05N/Jc7IHM8CoDb0g
         gshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8c+ewCIT71LKxJWBH8PK3kOCTkKpL7iAy1a7HDZYQsk=;
        b=EoZTvKBNOKSXBbXUyVXU+11SMLh7j2pexXwy/Zub2MS/09S6pmttscGlotT3R6xW55
         KnUsIYP8uP8F+ceZXaUARUXocszTU1I1AL6GmAMFlOiRV8jw3SnJ+CKlooYYvmDZGWn3
         gE6JANGP/b4b07USu4/DPghDtJ4O1DvXoIjyNlSCx847CSAphMBab0Q3LOThd8psKO0G
         tqOjD7VHJKKKw7w7PpGiJJw/Loo631Z4IHB3+TDtgZZEzNaQ7SVHnZw+VZHy7izbz/j7
         IXjMwScXGXZEGkSXkawPe4aDO4+/nC0ALXptyN1abuIHiIT2DKeW+OJimmaTAijE8J3a
         fwzw==
X-Gm-Message-State: APjAAAWSKAgWt6dM/PltkwKyAydKqQHXwY57abiW1C2WYCfGWuuwsrsT
        5ncKZvttcDICmBm8K1sGYSNQ7pkB
X-Google-Smtp-Source: APXvYqyg2nRzCZrXd9bb0ykg1EtmkwWcC5bBf7URZdeX1BnT/Sxo1ciJ1Dfjxv3nDNS77K8zV1Wu+g==
X-Received: by 2002:a63:d543:: with SMTP id v3mr11398550pgi.285.1578758563037;
        Sat, 11 Jan 2020 08:02:43 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z16sm7653799pff.125.2020.01.11.08.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 08:02:42 -0800 (PST)
Subject: Re: [PATCH 4.19 00/84] 4.19.95-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200111094845.328046411@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <23c3a0d1-1655-8cc2-7c96-743a47953795@roeck-us.net>
Date:   Sat, 11 Jan 2020 08:02:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/20 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.95 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Jan 2020 09:46:17 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 154 fail: 2
Failed builds:
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 382 pass: 339 fail: 43
Failed tests:
	<all arm64>

arch/arm64/kvm/hyp/switch.c: In function 'handle_tx2_tvm':
arch/arm64/kvm/hyp/switch.c:438:2: error: implicit declaration of function '__kvm_skip_instr'; did you mean 'kvm_skip_instr'?

Guenter
