Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4C7387CD3
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 17:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350393AbhERPum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 11:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350359AbhERPud (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 11:50:33 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57641C061756
        for <stable@vger.kernel.org>; Tue, 18 May 2021 08:49:15 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id c3so10180798oic.8
        for <stable@vger.kernel.org>; Tue, 18 May 2021 08:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ar+i+hKYQJKBrVVrwYFr2WXlLUhRfwyYOh3n4BNryGc=;
        b=b5J5fxxYf2Pa3zywWtqYXQ1JR3fU/z9E/8Dfcw+RXKKCbcfRyzsrb3yU+4BJ3JHrUs
         9fcLa8eoWbectK5MrgXNo/Tw0dHXFAXjVYKOUKj9mAfhX9WCb3BeGcGzUOLPS1e5Q/is
         LjzoNJi1ud9tZRokeqBYYt3hwiVTuKJKYMr3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ar+i+hKYQJKBrVVrwYFr2WXlLUhRfwyYOh3n4BNryGc=;
        b=FU2EPXUJ8CqTFMsMhn7xN9ZQ8/WT+8+ly7E+0O7mphC9H1tBV8rRsTNS4np7rt+hK+
         VseDKcb9/7mp2EbBWngMRwd1JeK2PwnD8lWGa/gAfnRpboaGayi8mwyybKGZMIzLa+bc
         ygSPp4I8RqH99hJCllktJ/0ZUOc5B4sS30hLkqojHk4xejaOlnmK9iskD0ioH18X9nLk
         CPID7RZURHzWQ19I40FM1JDNaqryZTrLL3aAWBctZxJT7m4tXmQ8wlbmoBAPxC9l95Uz
         0/V0eOImMZq6LifYFAibi+FD9LnuN5yu0hwzDAb2Nbg/SkaHr3E4Se5T1tQFsJ5Fwmsg
         oing==
X-Gm-Message-State: AOAM530tPFdJw5Vo0FiWbDwLSzEk9rL6xoZH4HloQywY+iWmAkcT6Cgk
        pGfQdSgWFuypRQhDOTVcdCSGbQ==
X-Google-Smtp-Source: ABdhPJwxHCs9d9PowhXDP4QMkM3BAfPF3ZyEKd0VJFq9QknCtIt+cdJNJpFEgirtzpwjfwsM+lhH7Q==
X-Received: by 2002:aca:2818:: with SMTP id 24mr4321292oix.67.1621352954645;
        Tue, 18 May 2021 08:49:14 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id f21sm3751334oou.24.2021.05.18.08.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:49:14 -0700 (PDT)
Date:   Tue, 18 May 2021 10:49:12 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/329] 5.11.22-rc1 review
Message-ID: <YKPh+GejNxyYKTZ5@fedora64.linuxtx.org>
References: <20210517140302.043055203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:58:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
