Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F4E3FF59D
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346729AbhIBVcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345890AbhIBVcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:32:35 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C78AC061757
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 14:31:36 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id w144so3854109oie.13
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 14:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rc7U7oANFcXg5hGEDkjPvORFIQ7OCYwYWB6mwWTbGbs=;
        b=M4B9RpCQEac5hi63UmX5b33SchKFeP9/F67P4mfdzvDojWIu3Qz6WXxLYwP4T5XGVp
         F73kBAS83xgrFjD1tgFXstmuUzQEuHaodZKLRP7yhKiFkQGr89jQFgo1p8fIFiyDRa4Y
         OOYkBNLZkOCnEIB+MnxuSdiJ92R5igK9EQYRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rc7U7oANFcXg5hGEDkjPvORFIQ7OCYwYWB6mwWTbGbs=;
        b=Fo9deT7BSRz8Juu2pf2gzEkvU17bnzUabHsjI8Qvk9La1MZiAwPVb2rs51rtYVFxlQ
         2JRF1COgQJd7YCFIkjD5X6a4dW09n36GGOZzawJnzU4RST24Tt6AD/0BbhKYlyyyJ9+T
         mKlLPrSHOOdPqaWiZbayB2eHPUJwFEt96mmbwRlyp6muOkx4qLn8YR4jRImul/6t+Uah
         u2fM7Jih9hcmfM+YMQFdSns5gIKcppqF+cuHj/HxdylSe+vlYLiLyM+9aNzB8lov4bpe
         B9CnwmKKmj90VY7aHY+lP4x9ZmHTXLYygXi3jNb3r97MYBxNiUj63rYstpwfrEO5UuMu
         VIcg==
X-Gm-Message-State: AOAM531rHb4CLhqSW/tMOwd8mtbPM7ba9m0c3HvRNClvmPZ/UneCxGiH
        YC7wKwsKSFX9hTPixEzdxNN43g==
X-Google-Smtp-Source: ABdhPJxDZYaWMFolfko9P2jlcT4J7L/7wh9LaX11B+bzCFX778dlPirw5nwkJxsjeGc9WTkRDlDU9Q==
X-Received: by 2002:a05:6808:cf:: with SMTP id t15mr3925022oic.108.1630618295763;
        Thu, 02 Sep 2021 14:31:35 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id s198sm602717oie.47.2021.09.02.14.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:31:35 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:31:33 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/113] 5.13.14-rc1 review
Message-ID: <YTFCtSDTwYGvqzRF@fedora64.linuxtx.org>
References: <20210901122301.984263453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:27:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.14-rc1.gz
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
