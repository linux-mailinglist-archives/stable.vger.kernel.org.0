Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9671F3C5D9A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhGLNtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhGLNtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:49:24 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE6BC0613DD;
        Mon, 12 Jul 2021 06:46:35 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id e1-20020a9d63c10000b02904b8b87ecc43so4960955otl.4;
        Mon, 12 Jul 2021 06:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DWOP7XRsEhwrchNkjTep1TD0ZTNu/ZXhPr33RlKmhmE=;
        b=LTLmK8T6zZtYSaHZ4BeWx+6QU5I+09Ls+yPKkkxHlafnVBvZ5+bH7afjxc7IYTW3go
         WdezzuZIJ5bUeHGaKU8NJRPYq/c2WiYiVV+G+XwFIpg866vH4gN4YUlcS3rTWnz6Tu89
         yPHIpjdw8/PzKvB2bcHt/57lWi6kUN5rei8xWJuvuBC9sxV3Y3MevWZU8qIhTC978nte
         W7+lQ3qCAwWqHs9pvvqqlS/hmH434MJ3925WLtA0JSL9ewHtWk1U4sr9sUCW71NMPmjf
         z+DaR81gjxm3ouSI2WwXbKxP3BBG3k6m4sxnCmmQX+CnXZIm3lv1UFa7mnCLQU3rKSrb
         Ii9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DWOP7XRsEhwrchNkjTep1TD0ZTNu/ZXhPr33RlKmhmE=;
        b=Ewg4qCgAmvRJMWDieJpG6pwgxvo+pRaJ1AJsFafEynSDRX/MhQgg1sN9W+/0PjLS87
         7rCIRL1q8U9aEPaoOEP9I7YLAmnoIkKeYUEVUj3S0lhNzfZFMJOqub6uzS+eb5bkVB6B
         2pH9c9wi9SLr4mWcHPHvVdG30HcYNzI+uxlK3XbBcslkT4KoBpB1zym+fpkZbtdpDs4x
         vxizQQsHYsxQ6D4FE2xGrXHfTWnmuOPlzCxXPZ0u7+NQ2db67jNEZgC1itX9ga+tcytr
         6jcD+8O01X7EqQFyn8ujMaFBMonL8YW95F2JAq8cW83XJFthqjqhow46Y0ilX8X5YE0t
         DTIg==
X-Gm-Message-State: AOAM533FUEVdg1tzMDAbgsjSd9bbGN2q8LiSdFHIaI0t63kTSZCct2JZ
        Bx/P3xf+YEicjV4qngq6rT+SGotSOpU=
X-Google-Smtp-Source: ABdhPJyIsyOXhkkYJaehQpjJlqBO0MB1qLcYwWLf0Lv8DE4UzEFcdXqTL7I5sciE6vKiQiF9N4DzhA==
X-Received: by 2002:a9d:6d8d:: with SMTP id x13mr3262990otp.192.1626097595017;
        Mon, 12 Jul 2021 06:46:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o20sm2493785ook.40.2021.07.12.06.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 06:46:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210712060843.180606720@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8c443632-f09f-acbb-a23b-7cefdffe633f@roeck-us.net>
Date:   Mon, 12 Jul 2021 06:46:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 593 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 155 fail: 4
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
	powerpc:cell_defconfig
	powerpc:maple_defconfig
Qemu test results:
	total: 455 pass: 431 fail: 24
Failed tests:
	<almost all ppc64 tests>

Error log:
arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
arch/powerpc/kernel/stacktrace.c:248:33: error: implicit declaration of function 'udelay'

Guenter
