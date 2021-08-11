Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546A03E98DA
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 21:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhHKTgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 15:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhHKTgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 15:36:06 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C42C0613D5
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id n1-20020a9d1e810000b0290514da4485e4so1947042otn.4
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 12:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dLJ13OLJiK5cgt9GvddVZ9YZVCILSTnKVEEsy5eH4yA=;
        b=SIK9umf9LWQKuQwQIwUp5Uw2b8cDuZt/16JnB6hAOWrJ41FkgMu7/B9G72pL+uKEiA
         vxv21MKCZqS2wgIIz+6yAZ83WcDvMMKi93T3KHi6jCI/C0uwXnVZLsxCE2I+2Czi0LUp
         mJ11cypT7C1T5vU4FIL676QMceDBwacVpBczY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dLJ13OLJiK5cgt9GvddVZ9YZVCILSTnKVEEsy5eH4yA=;
        b=CuHd6fgXc+oS0c4l1DpjRDT1e2jsBsCoBJQdUBl4O3lgI5M7em/hnG0DUwWmDVhgsb
         YAxXAQnHeXDoQghBDYW2+Ae/wuwyNheP1gw5SZhW1vGnzgwmO0mcsQ3+7+cHZpXD8IzS
         h78mPgiJoBTKzntR6LBK4/QcXoL0uuDAIeetVLOx4nX2amKH3loYxzrJ4IX69gvzZuuk
         BSApdh0BtjwWHCJv08hA5CTcnGBx7HH+JWIS09wRP3dzkeZfXH9SL81oBVsSTtuK2qgX
         l/f9yPbpppi160gFaiLMrEu4d/QKMzjywSnHWc4PgvifczaFfM9pFVGfXSZzb7DVlIJo
         8Djg==
X-Gm-Message-State: AOAM532Cgwt269MEPh0Ag7MiuBh9peEpjyeltLcDBUIuhP6LIGyrZu+D
        7Hiz4wNbQI/0bo0hSnM/TVPrC6CByk7NSqwh
X-Google-Smtp-Source: ABdhPJzMwUDOct7uNA0wcu787Towp66h7lpQvJaWChQj/Oxy9S04eZpkagkaFX9WP/pCtnZ+I7NvJw==
X-Received: by 2002:a05:6830:4d7:: with SMTP id s23mr449111otd.31.1628710541454;
        Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id p2sm42121oip.35.2021.08.11.12.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:35:41 -0700 (PDT)
Date:   Wed, 11 Aug 2021 14:35:39 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/175] 5.13.10-rc1 review
Message-ID: <YRQmiy5xJUekIbB3@fedora64.linuxtx.org>
References: <20210810173000.928681411@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 10, 2021 at 07:28:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.10-rc1.gz
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

