Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D29168FDB
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 16:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBVPrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 10:47:00 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44454 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbgBVPrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Feb 2020 10:47:00 -0500
Received: by mail-pg1-f196.google.com with SMTP id a14so2220152pgb.11;
        Sat, 22 Feb 2020 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2lwPLEdlD/tmi2l2jsbyyk3Xs3TaLO5BXgpdmx6EkWQ=;
        b=RTwmpbCpxRQmmCciyKB7ZqeCdN2rmCOTffe/tvgqyMV9UPDtW/V1iW96tqxj6Dfp+O
         a7mplCZsu1NfGtPsSy7LCv8+6ypdHekipDdoDg38gCZpRSsBfIXXEBunp7QiAOA5MVob
         m651XcYzrqzN6W/GFwApYQiBwvnOSjfjt/7u58/kAmLsjdTfwu2B/QGPDDJF7Vv7dI+K
         LwprVyM9w2J5lAlNb/f1Y4Qr8ZBZzhx1Oas+OULCS6YKpPHMddlYuun/PkfNOjJFU5/D
         U8lgHPc/kWqA9VUkBZboih1Dun7AoIC4IMcRCCHq5Wv0h61IWJzFF0OvmsczkGYCj4Ql
         wfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2lwPLEdlD/tmi2l2jsbyyk3Xs3TaLO5BXgpdmx6EkWQ=;
        b=NFHbLrAGdBhvirQ1qFQLv9tX43nLHEpnVI/+pZSNJRhLY8XUjHK82dQkxlbjCj9Cz1
         uEUlvHxsiogBRccz4eUXg1N4HGgRP5RNAkzS3RyErVcDccQxCMRFrkKtUr++j3AVQmZe
         fKt+L1dy/HiID2dJXqAMX8LfXfgMTULpMedzK6s9l+j+iF9h5WqeIiyxzxUl/Dpkn2xt
         QQ8X7cAA+QnwaVfFy3UFNqe2pe4NtTAw+/QMEt6Pa6zvdvOidEm58wS2/cFd1dqQL+Z1
         qrnPh76+B6NDyMCn56gFaV85aQWKlU1AUyg24rHQjXr3OlV5T04MRJlPy7IgPeVL+q10
         d89A==
X-Gm-Message-State: APjAAAX2htdHAD0hPkeGjV7tTpceQkRajZCoFvJqJ1P9Bw9aabFotBXa
        goXWrMb05ltpw8XS4Ic6YgoB8F9t
X-Google-Smtp-Source: APXvYqxBM+oZjtWmczrhNgdGoYCIwP8S5TXnNCRHEnhvg1Rm9Z9GjqrqCLjyfwNFTsfJrmF7LgcwDw==
X-Received: by 2002:a62:33c6:: with SMTP id z189mr43504686pfz.246.1582386419080;
        Sat, 22 Feb 2020 07:46:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm6487486pgj.45.2020.02.22.07.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 07:46:58 -0800 (PST)
Subject: Re: [PATCH 4.19 000/191] 4.19.106-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072250.732482588@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <73554d3c-ff50-d8c7-3694-e67b8a76d904@roeck-us.net>
Date:   Sat, 22 Feb 2020 07:46:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.106 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

I didn't send final summaries this time around because all release candidates
are broken. I expected to get updated images last night, but that didn't
happen. FTR, the test results for v4.19.105-192-g27ac98449017 are:

Build results:
	total: 156 pass: 155 fail: 1
Failed builds:
	x86_64:allnoconfig
Qemu test results:
	total: 403 pass: 403 fail: 0

with:

Building x86_64:allnoconfig ... failed
--------------
Error log:
arch/x86/kernel/unwind_orc.c: In function 'unwind_init':
arch/x86/kernel/unwind_orc.c:267:56: error: 'orc_sort_cmp' undeclared (first use in this function)
   267 |  sort(__start_orc_unwind_ip, num_entries, sizeof(int), orc_sort_cmp,
       |                                                        ^~~~~~~~~~~~
arch/x86/kernel/unwind_orc.c:267:56: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/kernel/unwind_orc.c:268:7: error: 'orc_sort_swap' undeclared (first use in this function)
   268 |       orc_sort_swap);
       |       ^~~~~~~~~~~~~

I don't plan to send final summaries for the other release candidates;
all failures have already been reported.

Guenter
