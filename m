Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A733903C8
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhEYOWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbhEYOWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:22:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E753C061574;
        Tue, 25 May 2021 07:20:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o127so16854456wmo.4;
        Tue, 25 May 2021 07:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1i7F0C/ezD3zN7T6HCqtKC9g3svw9ifgqH735PmnhW0=;
        b=KvYUL5whivdgkX2kz2jpewvM9N36AgUb1Uw8KII53lTJLWs1HrIApStAD7L12p82u0
         te8MmsJ2uPGrbOX6KXS3mITHHqHiQgYZJDX22/Au7RF1QPZEH/8Vo8CBZEJGi8ak7iYm
         r6pX04H6zZL6C/BtZC4jYv1b+J83tmM8NR5BLC7nlqJ98ccjZ3ymNUW4soqsiaydlVKm
         Q+A6x7GSdXM0B+5ER0NcIjIuY92bzm4mY/hY7IfPr8FyAJZETHrd8Fs8Jrr3BK3gHVh+
         8IHqSzXmnhXSjf18i02fhIsZ9M7cgl7ZdmGpEeagVSTsHYna/ZE2/QK0BgqHQuL5rImY
         1N6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1i7F0C/ezD3zN7T6HCqtKC9g3svw9ifgqH735PmnhW0=;
        b=qoJPSuEcUUbAg2TzBZ5R5jwwcZfqfzlNh6m/kSR70dq5LJvWAzNEsdDm4toWlblln1
         XP0bOkEZC0q7uHhmlsKBAFdxiBRTjhIwJtTlWc/MCNJaj0P4KBAS1c6GEsUyPYL5Jaww
         NXlZxzoM6maIUnqJTQKxj/65Y0jZF7wE9/fxd1a0n0bq2bDvatFvh5yiPMTJnpn8c3lY
         LQQ6POQYAY7BAIuUD0TKFL+bSqxLsNmuNfES4PXecB9CAWP0KgBS850iTA1ghA8CEBm3
         oba1DLtW4qDtqR1E4dbbY8SIEGg4zfHZochygOKivlc3wK+pIwnYmrX5xDiHoHTQcc65
         Kisw==
X-Gm-Message-State: AOAM532jcD9Rbzqy7qowtZw0zlq+EAoPbaO9SuxFcaltofhIwRWmwDep
        c1eGEZVlAbDS7IowADDAuT8=
X-Google-Smtp-Source: ABdhPJzDUsU6I7sqQmNqTXp1ko79ZKX/ZZ2lfO+5AauobqKTTZBwefueuoj7pkTeGv4+ufWhwuCbDw==
X-Received: by 2002:a1c:ed10:: with SMTP id l16mr4083458wmh.8.1621952443358;
        Tue, 25 May 2021 07:20:43 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id x10sm16139519wrt.65.2021.05.25.07.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:20:42 -0700 (PDT)
Date:   Tue, 25 May 2021 15:20:41 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.192-rc1 review
Message-ID: <YK0HuR5ZvSS6J6Y0@debian>
References: <20210524152324.382084875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 24, 2021 at 05:25:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.192 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
