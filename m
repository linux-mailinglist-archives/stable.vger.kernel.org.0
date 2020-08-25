Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF62B251FCC
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHYTWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:22:03 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECF2C061574;
        Tue, 25 Aug 2020 12:22:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so27552pjx.5;
        Tue, 25 Aug 2020 12:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H1K0vP9nnvM8ipz58LmpQfXWuzhTiZiUGcFErIU3e5g=;
        b=acoXreXhdqH9kcY3UeIpin/j1KQvtYKJn/Rvv1bMXnZqM9y3a+gKnArABxh47MqoSL
         /fft5MW2C/GthCzheItacM1L+nusF3xt6l8MDQYfRtckUa1+VazPyb/j3GEO4E0j8wEs
         sCfOTQBLIqxxrCsUApnADSrnjSnlZ7Yu+SwJiNxi66PnTkciyOrNg3be59WE8wBHTu0H
         A0ZT9ybupLI2cyvlUyKCWSVzYhhDI5o7vEEZvbb7VQ47XprCSfU8gWYbQttL9N6bCHQP
         /t5TIZIDadjbCrZTYG2LhFtM+v6j5Q6g6MHhSfhwneFR/24wzCE7wdlYBWwwDF9WWQ7M
         2PMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=H1K0vP9nnvM8ipz58LmpQfXWuzhTiZiUGcFErIU3e5g=;
        b=f4sUUnSPesnm13M222I7E66ZZwdETQRJ9n8Kkjgt5IX2ODT9DpydYhw/gEzqJEvFfZ
         dRQewkKjdqeuOSqKBWE7/5BqBZqEYV3y3KU/B1Lvsy39oS+zth8HYY1/eblsciq6p6KL
         ULTAqpvCThssTCYYHHrqcrG9noam5xEH1FYFDcpmNxN6vF7Fo7q7dV/RQbzof2EEDDIW
         PebqJUoVFLhLGLr1z+FnsyF7RxelDtPaTKWl0OcEsbc9gC5UOPtbgGKTPwc6drXOSQcJ
         H0i72KHi5YtnFDJDhDSrFANH24RJTOXVWAFlGp5D/X1uXzrwszh80hBDUm+2m7tEClP0
         x1RA==
X-Gm-Message-State: AOAM533FFk2YRNBRomVeRHcW7KRF+JESE6+FyW54/1mnzVEZR0k5pU30
        AIw1YVva+sg9AGKLA4GJHBs=
X-Google-Smtp-Source: ABdhPJx+qEUa/ALZZGb26XpqNTQikNdn04BRNGABf8B4aVQZ3mc74BKCies3aE4yAe/IDaXDEoyqsw==
X-Received: by 2002:a17:90b:1a84:: with SMTP id ng4mr2753617pjb.224.1598383322801;
        Tue, 25 Aug 2020 12:22:02 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y13sm522807pfn.214.2020.08.25.12.22.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 12:22:02 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:22:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
Message-ID: <20200825192201.GG36661@roeck-us.net>
References: <20200824164745.715432380@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824164745.715432380@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:48:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.4 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
