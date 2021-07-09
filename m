Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBA03C2B69
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 00:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIWeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 18:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIWeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 18:34:10 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AB2C0613E5
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 15:31:26 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i5-20020a9d68c50000b02904b41fa91c97so6634608oto.5
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 15:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=upnsK0auCIcTjX2QtwPLQv5a6TArKtIxfo8S37Wtnfs=;
        b=Qft4v/xwBCfQcddpia9jMHw5kKnmLVllVM3y6HuoDlppu5J2Ni8Fd8PHGnXdfWdTNL
         NhWvJHzGzaZJKL3XioV/TUQ4PHZJIsnexyKu2vP5L1zUffD7lFef+rCAOfXVcmOc2XfX
         K41/iQqEwSMif1obLWxAmgbGfBN8jzZYl+fuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=upnsK0auCIcTjX2QtwPLQv5a6TArKtIxfo8S37Wtnfs=;
        b=XQE4Wymd3Wj2fXipu25OWCvw8e3/eegtfHK8d7c9GQcCdwzUjWar6jiQQg5VNWhYPd
         4t68u87wvkiDZaDAbbRmH4oVTHjpcY+RlNHWXaRELWpjShWXNSG/7buxjnf7ndJAccBm
         2txf1ZrtdGWsNUF25aBE/Gm0YGmO5wN3AgNNZqj0zndS9ncE5JQXvYPWXTgZAJ8De9yI
         9VEVSRLDrS/i7gP6LHRWFneMfJIR09d8ezFY+BUiZvN1pnnTVWCelEAq1hlzNK7LT2vr
         od9yf7C7WQXJqKDsfP8Nxx8uOjfceLmq9oqS5bS6HzUs7+SOSiquSsaTnpfiGkdMVnlj
         1ykQ==
X-Gm-Message-State: AOAM531+YXYyv3zp6fxTy0iEVs5Z14XNx7C0uGqPgXmiV9xSfZMxX1eM
        vXA+WOiKnSvHoAc40rWuaQ8NHg==
X-Google-Smtp-Source: ABdhPJx1FIPZQPmZES91xkjfzCpLwt8JsT5qoan7BcrRjah1PiaY+zBPiZqvGYZJ/JEOj0zXxU/svQ==
X-Received: by 2002:a05:6830:2487:: with SMTP id u7mr27068811ots.48.1625869886226;
        Fri, 09 Jul 2021 15:31:26 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id w15sm1459523oie.21.2021.07.09.15.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 15:31:25 -0700 (PDT)
Date:   Fri, 9 Jul 2021 17:31:23 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/11] 5.12.16-rc1 review
Message-ID: <YOjOOxDbRF34EXke@fedora64.linuxtx.org>
References: <20210709131549.679160341@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:21:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.16 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
