Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1172445C12
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 23:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhKDWVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhKDWVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 18:21:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CE5C061714;
        Thu,  4 Nov 2021 15:19:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g19so1145441pfb.8;
        Thu, 04 Nov 2021 15:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1OF6Tebqj5rCxmJs5d92kJWUGvrWOHbNXxO91VhgA7o=;
        b=ihdsjFs53eHcHcdVe+ZM4S7VdKRPZ0fz2G8gxYviL87OvnxSjhYuFV9NxO3OjCLw6C
         8ymXOPklcmiQekZzh3IrdYiZYn8AexmcBmfJ1+8svTTK506cs+5vbSrhpkp7R8/5r/ht
         a+QqtbrCtX1VzUtWz02Jg0l0r5yetxlJmFfu8ZuBK8aOWO+NoMAp/o8R8OuywTqce7/w
         Kw42s8iy7fwQv5S3ZlRjUZRrDPMDitoBCMN6qLQlgh8RANSZSKKvI9FsqR5zoCgUcgtT
         aApvq+KtJBlemGhZpfrdBGgZoFX5Iaxg3KVvANGAgmcSWBmWO9gLfZs9jnFkG5FRyorI
         t8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1OF6Tebqj5rCxmJs5d92kJWUGvrWOHbNXxO91VhgA7o=;
        b=A7Jx/pxRnBK5gVDmXUAasF1GWMvo+cRPB18yBonbI9J586PzstL4nRYgY/iB5W4pJC
         8M8ih4rkgz/VxxkFwKlQJ+iGPXeBr6fOONLd6QV4t8moPr0xEuNa3E3W7G6qGlymA4GH
         70Xkn423tEu9bkyA24c9CKUSKbV4qgdb3+18tj4Tf4lqDSjjI/X3cBWnZenYpZKlxBoo
         zoVLZEkGNCCe9RfHaG6QiuDErSdMc4rqV0JSU7nbb2ivBBVSIvzGoYSxDhU7VQU8JmNF
         hR8mDeL3UBbwllMUDZf3My7GdkGNWOikvWlhZ+r299eArSjqXIWtcewW6/0+y2gtlAVY
         rfJA==
X-Gm-Message-State: AOAM533xTihnNEplxrw4zAzmLQPaiOvtMeU+kj3jt4hazbS4/p68fCVh
        PyRRIg8u6JVUYHAI4ptLu2WGjL66V40=
X-Google-Smtp-Source: ABdhPJzrMqnThexp5gcomXqaa0bH8H5w3D5lGgpiRwDLsccgFgu+iKW65QSzxLkdQTmep5DZyHhnag==
X-Received: by 2002:a62:e510:0:b0:44c:e06e:80dd with SMTP id n16-20020a62e510000000b0044ce06e80ddmr55651582pff.48.1636064354381;
        Thu, 04 Nov 2021 15:19:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y130sm441627pfg.202.2021.11.04.15.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 15:19:13 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211104141159.551636584@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <29de53eb-fb00-50f7-805e-327a38565ac2@gmail.com>
Date:   Thu, 4 Nov 2021 15:19:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 7:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
