Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4412EF693
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbhAHRi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbhAHRi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:38:27 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F8CC061380;
        Fri,  8 Jan 2021 09:37:47 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id d20so10426271otl.3;
        Fri, 08 Jan 2021 09:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+JevOubrvvi5bveTWEzDLnh32DV9ESru+/qyKX5gOSU=;
        b=OmwRgw3B2TWi1JHPhMC079CyenowmNPOwgJvTRoKp2p+pFaLS1qk6jEpFS2gSx5aKU
         tyrKJX2umlxWGZN/t1VzD2mKP7s7aI8tl2zCL4ryq7frUOgSHZLdpncf7hBoIBy1uvlb
         D69xT6UXGp/NTjay23w9HMd4XA0DmlLS2nMda23aF6+VHnQYAL8OKILTZ1Hykbof9wVL
         6KmqrYjMmHXBNqYhA4F8YoI1H5w6klf7zEbWwfanTpsTuQW/ExRz2A0LcWZ+hlsCKRdF
         ldAYwDZPlc0nLxEJuqYiWQGpr4pUrde8vT7UMSO6eiUVAKH5jCGLqi3o3wSBytFxc+Ds
         2AtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+JevOubrvvi5bveTWEzDLnh32DV9ESru+/qyKX5gOSU=;
        b=Muy5dU+67f/tmrYx0ouzOiOU89YcoyCeIlMBCLHER0FXjwnoBdaOYm7Ke3k7IzOm6W
         wkiztC8kfiCOgDEuP+hO1hWGxkJhV1ustRaeNoyCxC2jvbStpTZ2eI5e4ixJKLPToOC7
         6eF8aJQAW6VagEw2FNe/3+S9JumkhHH08thPTUnl2rD7vLOjkz3uidXg/HYxmti2BK3z
         34DYpRF8tKF+47xDI5zDoSIJCzSbFjaU7hOsQZen/hFGaSvLwPGWkKsYy520Ydsk58ef
         5ACfq3iZGoA8IORuqrJ8ix/aWbSiI6z5bUWWwCO54X5FQ7QoqXvn2ZXy+8nLE4Cgs+jN
         5RTA==
X-Gm-Message-State: AOAM5316rWpOxbsQLo3y7Xx1g4kmftEOv5RAXt6qlduCfecVrLt5fogo
        SbnMAMYG4D4im4sXowrQRQs=
X-Google-Smtp-Source: ABdhPJynF5i/8f+qTMBN7NtQQp719bq/WbnKe1T0bCJgWvVSK2dDK1xhVAoNXF6Kl474JzzHGOQkPw==
X-Received: by 2002:a05:6830:210f:: with SMTP id i15mr3301655otc.43.1610127466422;
        Fri, 08 Jan 2021 09:37:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z14sm1837486oot.5.2021.01.08.09.37.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:37:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:37:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
Message-ID: <20210108173743.GA4528@roeck-us.net>
References: <20210107143049.179580814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143049.179580814@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:31:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.250 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
