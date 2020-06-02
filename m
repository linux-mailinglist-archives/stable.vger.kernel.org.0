Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9551EB35C
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFBCe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 22:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFBCe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 22:34:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00483C061A0E;
        Mon,  1 Jun 2020 19:34:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p30so4375320pgl.11;
        Mon, 01 Jun 2020 19:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s4UEYuJB3XBli5yd0KidgvrjcjkYTAO/sinQI+U9kL0=;
        b=SVr9E3h+qDW24ehI3GnKXPBVnMq8IOQHh3vUnxsbkgQ/R92qU3yIMfqHv8AE2MTHzU
         tByJKQrO2K+FRFPiMoDi846/wjV1c8gSzrkKa2XoOeV7jCWOi4G9gd5wRSAMaxJHLcT8
         hEJpXMFml7Du5yOYVVwJ9I2arHd0PDnbemrOP/46uDIGztreWe5nZOTO7t5cg0khrhwE
         8tRI3k35w9ISTgsGdVMQeSTLBWsvQXupB2D/t9zCNTYI62XyifwUzqxG+AJ3/FvDkjxx
         g0qvg+5THyCC4OrABeDSCsz3HYPiYkk8tiCka/lDQG+NOuNGfWnao4R99oWJUorNIjT1
         ZEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=s4UEYuJB3XBli5yd0KidgvrjcjkYTAO/sinQI+U9kL0=;
        b=bb6GRCYCtaL3nlGnHmXF8FIArZ+7dExvVJ9mHCtkjRz6FCt9GROouNpO5uoIIfKufd
         g7S1OdVkozVprjGdyBP6lPnm2xJ3k6TcXiWo1i19qE8c+H8wXesoJYsrP6pXcm6CPqba
         y8LQzKU4cDVa3iQled3nOpvncnOznVo9xilL79cOqpsq5p0v1spiikhUhttN6QDHuNqA
         UfFPwyKgsBEjw1Z5o/KfQ37z+pV9v7WklNZsTVyjzpRPK/TgwTjKIZKMjmm5NiBSxEPf
         rYKSYcRmKjJn3yrTWg0W2QbrCAJtUpcPJT4vdUBbrvIeembREDNUPbgJZLgbMtKekIqc
         OMjw==
X-Gm-Message-State: AOAM532ZQtbCuaflTQWe7WJO9GcY63fm1mCZ+ACLILQtxpMC+UvHaysl
        9ed4pVwnaglXkDpalWVRLYSQ9To0
X-Google-Smtp-Source: ABdhPJy1JQHar4xcTo+hi1ELp8K09Nm+ftNlxYIU7PtXLGPkjhqHQu5VLWGu5FDKiAYozqWC7Swlog==
X-Received: by 2002:a63:5105:: with SMTP id f5mr6587737pgb.261.1591065266227;
        Mon, 01 Jun 2020 19:34:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v129sm660001pfv.18.2020.06.01.19.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 19:34:25 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/61] 4.9.226-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200601174010.316778377@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <2b4126ce-487e-91ed-e471-1af5b61b2fef@roeck-us.net>
Date:   Mon, 1 Jun 2020 19:34:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/1/20 10:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.226 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Jun 2020 17:38:19 +0000.
> Anything received after that time might be too late.
> 

Lots of errors along the line of

arch/arm/lib/clear_user.S: Assembler messages:
arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#1'
arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#1'
arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#1'
arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'
arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#1'

Bisect log below.

Guenter

---
# bad: [f7c3cc559c2e60aedae9799208fc8dd85211b971] Linux 4.9.226-rc1
# good: [82dddebfe7da9d2670977ab723da2fdac3eff5b0] Linux 4.9.225
git bisect start 'HEAD' 'v4.9.225'
# bad: [d1560c566028eb1ce2b446ef1ce8e36cb85f58e5] ARM: dts: imx: Correct B850v3 clock assignment
git bisect bad d1560c566028eb1ce2b446ef1ce8e36cb85f58e5
# good: [3a416993574184aefe8abe230bfcfae7464f438e] gfs2: move privileged user check to gfs2_quota_lock_check
git bisect good 3a416993574184aefe8abe230bfcfae7464f438e
# good: [1b96153fc668b0ba6fcc8c05729898773c5bf9cf] Input: xpad - add custom init packet for Xbox One S controllers
git bisect good 1b96153fc668b0ba6fcc8c05729898773c5bf9cf
# bad: [b6eb3d378d94ebcfd35ebc881310b6dc684ca7a6] ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h
git bisect bad b6eb3d378d94ebcfd35ebc881310b6dc684ca7a6
# good: [a4174aaf3c0998c50023fabf48f4107286fe30e6] Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()
git bisect good a4174aaf3c0998c50023fabf48f4107286fe30e6
# bad: [db2e66e6d39b037c9538edc5b85094b70fff97ab] ARM: 8843/1: use unified assembler in headers
git bisect bad db2e66e6d39b037c9538edc5b85094b70fff97ab
# first bad commit: [db2e66e6d39b037c9538edc5b85094b70fff97ab] ARM: 8843/1: use unified assembler in headers
