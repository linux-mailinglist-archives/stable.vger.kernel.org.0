Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1145C7B1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352958AbhKXOo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354007AbhKXOoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 09:44:20 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304AEC21BD0D;
        Wed, 24 Nov 2021 06:08:04 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m6so5589944oim.2;
        Wed, 24 Nov 2021 06:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g+6ibQ3EaXQQzSm7rA5gfpkAwDGuRnXHDi/ulXfnbXM=;
        b=CBzYZ2jn+kpU1videC8+YpsPMswkw7TCdm8nYVN8sTkNbKp4QWEnNrQwXjR1x6vGg/
         sGFuRCOlRFFDPbrYh6eYxaBhCZiQGOcWA7Q9KLSGoEAuwGp6ZuIW8aJLD2tEqSlcGP9z
         qr3hE1eMZJjWWhdw72tjZdD4d/0Oti4P1ouipckvMAWX8mIwtI1d0Z1yAhmVS5ZLGpEs
         6+SiLNBNK5bT1hvEfPvlbyJ3JNwI6TWziMTMMYkqQkIOsTqyY+kPLp/YGlGhLYThoI85
         MPok2g7r8fbEKUSwqYzlWh8rw76AyzEGNIKwyhWdRUUP207UVVhIxm6OkDGazDfMWR5T
         o/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g+6ibQ3EaXQQzSm7rA5gfpkAwDGuRnXHDi/ulXfnbXM=;
        b=b+TNhvXaOuXRidDhN0OhSFb7mMrjuuhathE768vvF3rMyZc1Us7QYeL+ZlMeANAJRo
         xW9P5O7cIWyJOezSFXlOHwIm/zS3G46+d5QGckJihdOLbv007BzLb1CCjhDvgEgzp5vw
         IKunblmqnoWOOQTmFq0L6xRA/+TdV4bmWKv/RNqM/8fkI//5r/gAqwkR9JvS6CgqvnJw
         ReHkZm/aE2UgE2sk9DQwT50Gvql9F7CmJAhphznOXhVvjd5HCJm3xW2aIgr6Y+RmoEg7
         fkJDODiysFYX/GejwijhmQxkUxfjO+I7jplhhn3WUmx7chviV+O7YRrZK0i0MSa9qMYH
         CqxQ==
X-Gm-Message-State: AOAM532/k0PqqCdN8KW5XyA7FlqVDecaG/xFbzfgfWbtEoN2sy1TpmH9
        E2NnZ7tzn3erlN8jgocTatDn2TSw2uc=
X-Google-Smtp-Source: ABdhPJyoN1R7sv2xELf1KgWhrrC87xcgArIaiZhvB5iX/8UGXm/lvUIJZq5K13TmO5fNhnij3j5R9w==
X-Received: by 2002:a05:6808:198f:: with SMTP id bj15mr6127994oib.69.1637762883257;
        Wed, 24 Nov 2021 06:08:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm3034400oic.35.2021.11.24.06.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 06:08:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211124115703.941380739@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <35c2bacd-e1f3-11c8-f9e0-b694eb455880@roeck-us.net>
Date:   Wed, 24 Nov 2021 06:08:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/21 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

c6x, microblaze builds:

In file included from arch/c6x/include/asm/tlb.h:6,
                  from mm/oom_kill.c:42:
include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
include/asm-generic/tlb.h:208:47: error: 'PMD_SIZE' undeclared

There are probably going to be more failures; builds are not complete yet.

Guenter
