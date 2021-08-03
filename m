Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA413DF5C9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbhHCThk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbhHCThj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:37:39 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83366C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 12:37:28 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id h7-20020a4ab4470000b0290263c143bcb2so5461349ooo.7
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 12:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q7pRo9DPVeUF3tjIYAHl3+fADdONGnksYTSiUBXvqnE=;
        b=HAR9IGumq1VajAMj9Utz7V25mZXS9L+BkANw/uKy2O7dLpgwOWM1fwGm3BerRcjEDX
         TsoltynRi7cZAcV9Ujufwrxt83YEodCf+/rvfvMJtLb8Ev1qKCSnYbY59AwnrTGq53Ef
         1Qz4zTURFHYFpB6HXa8H57pPxmrn6AYCMi3nA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q7pRo9DPVeUF3tjIYAHl3+fADdONGnksYTSiUBXvqnE=;
        b=LYZHFrsIr2JwZ90s1wEsJ5f3wiTlF8jugt9MskbPIM1C/YKPkyGJx/3rPqMA1AkL0c
         30HfDDNh6q2qKejYmQkZHYHMW5vRyxJ5sHywiJxSXkpw+A79Aikc1JEwajxDZsXN0jHK
         ODzEHZHU5mpW2C2lVgD46u2UFqrGnVtiHcHVMXIgleg+z7sPjz6BdYnoFSpyGbjb7RCR
         uKwFtHBkcL/X7vQxpn1E3d2JOx6RD/OR7RBYWG4qz2DKmR9UhBRADzq/R9E+ZQ505pIP
         lw0iEU2zVIBvbR2f5Pn7p/3TT4bd2N/tA4y6Yn41VW9/74j/usKVScFQMEgLj5U8aklZ
         305g==
X-Gm-Message-State: AOAM530VFemxxTriWIRxnGQ/b7G4aB2nb2itLxARDCj8vf7dwThg7m8L
        V7jUz1iSdQxb3eauORPCNqhJew==
X-Google-Smtp-Source: ABdhPJwA6gkFS+46VvWrHnZNSuKDc3lH+98nvIYBYybhSUvXlwpH4s4N88e6olmDQ64aLIjRALnQWw==
X-Received: by 2002:a05:6820:161f:: with SMTP id bb31mr15466846oob.44.1628019447798;
        Tue, 03 Aug 2021 12:37:27 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id n4sm308218ooe.10.2021.08.03.12.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:37:27 -0700 (PDT)
Date:   Tue, 3 Aug 2021 14:37:25 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/104] 5.13.8-rc1 review
Message-ID: <YQma9TEnIJA4VfS3@fedora64.linuxtx.org>
References: <20210802134344.028226640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:43:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.8 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

