Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B231F2F877C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 22:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAOVSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 16:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAOVSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 16:18:36 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E183C0613C1;
        Fri, 15 Jan 2021 13:17:56 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id s75so11016463oih.1;
        Fri, 15 Jan 2021 13:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XCs9A7eg9RCwMU1NiC1UTXNTV7TLdNiM5/JlZtIKJMY=;
        b=QqAuJZpf/L+zoWUoFqnXKSEqMHfP7b+sayllyBZHil/RVpa7EVHe0V/Ukj585Cf+EQ
         nscWqR7eHLUO01+jkQoaWFw7zUk3ZDvZoRIf5kxv2UQ1iHG0oONO56xs/tSqUnXrdVfd
         ds6TTy7V8ztyKHV9G0FURtqCeFnCNiKXvQiciUqSlSxR6HzZhBqfOaDRgqbvePBt2Gt7
         ayQ7QK152D/Ir1Md+ucp515YN8pUoh/6piKIYh3lnv73RBUmAdZg90dEu5xvcjK2L6wH
         x/u0zLt/kHy/VPYhxbB/PLRhUDghCOovGhOaYJ99w4cc7W1IA20RUVar8AtZPTFmIXqa
         /FNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XCs9A7eg9RCwMU1NiC1UTXNTV7TLdNiM5/JlZtIKJMY=;
        b=Bf+hFbIektGKklpDFBszcrHUnMAqGP0aXb4E4luYLf0dh/RfZbxRhXmtZCeUp+coyi
         GNhrSCuoX+zlE7NOfYuE38G9LpUnHvzrkV/c8qIO0L4Rl2+ZaRnMwQMA/877quwU8vEI
         VdgjUlcfGtGP9p291aeEB1QDm00MCs5jxu3R/gaBRZ+e92/xnlH/wWe58nlxJRtY9oMz
         bMMlqX0GzMCIySJg3/2q5/V6p99hAdQg+ASrhSxHFvlnkRvlJcdWtuTKDjqRgvFkkOId
         bW4NpI8JbnndQ6Rh10G/hzI4uCcqwA+3qs+Xjshn/+Ve24yBF2qgJSU4OF9BxjSOHNcS
         SUow==
X-Gm-Message-State: AOAM530sJalTcW1/cbdj5x11+xyXZcLyL6cKl8c2/dm/HPwsH+1uXIxg
        0kjeAJ8Zg+CLcH/WQY+P1Ek=
X-Google-Smtp-Source: ABdhPJyqsBHN7kozoYU/PDo5rT2OvKhY2OTWSZtsZfUhqky/ComVbBt6Rnz3+wPy7mP3a2xisXTFMA==
X-Received: by 2002:a54:4413:: with SMTP id k19mr7192367oiw.110.1610745475951;
        Fri, 15 Jan 2021 13:17:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w4sm2062302otj.3.2021.01.15.13.17.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Jan 2021 13:17:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Jan 2021 13:17:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/28] 4.14.216-rc1 review
Message-ID: <20210115211753.GB128727@roeck-us.net>
References: <20210115121956.731354372@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:27:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.216 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
