Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EB640797D
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhIKQMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 12:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbhIKQMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 12:12:15 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5644CC061756
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 09:11:02 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id q11-20020a9d4b0b000000b0051acbdb2869so6837735otf.2
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 09:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JeOY6OGjn/eCHWQcvdDN/uyKi3xPhTxfrZDn+x65Ofk=;
        b=BoG63izfsejWDEZe6Gen5UfqRKLzV4Aw2qs3WKXUv/BkEp154EG+8q/0kfQzcWtwJt
         9CSe/OAdwW+ASnP6eVhvv1Q/8IBR3ozhaCqXWO361LI+4nEsvwjHpyl/LIcaHLu8Rbv7
         7Pqdaea5u3mN6Av9ElSWjHVj99s5L0u9b7rss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JeOY6OGjn/eCHWQcvdDN/uyKi3xPhTxfrZDn+x65Ofk=;
        b=lM1hLzvzdVPKjCWyStXU407nI0pbsIpc1c/g7fu9VkOJT1o933A0YytbPL3DnKfnvN
         MifPxKUIS5DrOgW1qWL+xUzAfKJaGg39TSSHjGKzwDKnAXm8Mfs7f+JXjuNaA9+LyLuy
         exrsh6iu9tlA1XCrQXxXSnIqARU06nXkGGiLeJ+kXjwmup1ODZ4qC8RH7TJx3Z8Il1hW
         wNqyNwoaFP2p9lcSs4zxaLuHYZ2NK1ylVtl+w0GRaSjD3Q97049A3K3GmxsNUXdFNbYA
         N/oSyAAik5rssov9ckmhTBYtUxXlTCjXqv2hGohDSAaOm8a4CxTsuYRHZ9nmD1hBVi2w
         bA6g==
X-Gm-Message-State: AOAM532fRWy79QpqhzD+AoHJONeZDPiRhvoburpgulmkx4dgYzKm392u
        duizHAQrb4e+gYAHvPUjCvEJj0RtlxcJve1c
X-Google-Smtp-Source: ABdhPJxB3tsT5fkryMTD4UstDeapS7GwSkr2t71A+b3BuXojuxVq8A8dU0rAWZRIIO1OkrRVMQWeog==
X-Received: by 2002:a9d:724a:: with SMTP id a10mr2806096otk.323.1631376661498;
        Sat, 11 Sep 2021 09:11:01 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id m24sm482595oie.50.2021.09.11.09.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 09:11:01 -0700 (PDT)
Date:   Sat, 11 Sep 2021 11:10:59 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
Message-ID: <YTzVE7/P6EpmvKVm@fedora64.linuxtx.org>
References: <20210910122916.022815161@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:29:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
