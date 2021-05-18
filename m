Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55646387616
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhERKIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 06:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347756AbhERKId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 06:08:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD59C061756;
        Tue, 18 May 2021 03:07:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x8so9526399wrq.9;
        Tue, 18 May 2021 03:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eBi8F14785uXQWNmA/g7DYUV0B/mXEuxDd9UNl+DXWw=;
        b=abZb+EYL3lF7+knDgi+MniVFEO9rejeB6HgSSjINLdVflb7bHziQ65GIaXVS0cxGo8
         j1sbbjfPNfwUkM2p/jLcweQ9GOHTCLE9vq5xQX8gAMUkS4gM1PsmFxqHG48ztFX+hGQR
         YPCbtY0BaELX+FRvDeUPbGa2v3ru/IUEwZSArvzLIXjQ2MmPWoZ9m8qfjiUUI0fo5QXZ
         tJ/1vzQhDJEInGR7XY8w25074JU9roBQ5OE3im3ha4i8kNgPFIGnQGjXJSXJk4n7OfIr
         gpoe8YFXrKvN0L/AFC8ftu033Z+a5MmRi4CkZE/Y34Qm7cTvO3vEi9u53+aAjzE65g0g
         dPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eBi8F14785uXQWNmA/g7DYUV0B/mXEuxDd9UNl+DXWw=;
        b=bZvuVYqD8vtlMYs3pXixYwlgNM99xURHRbXF9y+WpyXqJP/Eh0dPormu2nQ32ieRYI
         qiqoIadDCw/LhZx4Q1LqRB8+/SIYsR59WttDgYcBGmlUgWaldSoQjLykR7gFFS7c98uY
         dJbEvoqfk6tG4M7i0b8dtMQW3HBsgrEttUh+Lavl+G5AWJt/dMfmatrhlQHfS4QRkiBj
         6hdaaGOBVK9XVt0I1LM1khENXUKun+u7jZpdNlckMeVDnlK+chCexcP4UkbeCF3it+RJ
         wAA8J+vrsZyeV9ps3IuM4ZbWcl/NBwLfqprHbcFvlHb4uK3gv+K6RoYoI5Tv6Z0Tt/FA
         WpXw==
X-Gm-Message-State: AOAM533tqEmzgPgR7LIJiZG+hvnhH4ema/jWpGeuWDvrYzdwI+Xz7V7h
        5VJlOjNjgkXNgxPNVQqTSmA=
X-Google-Smtp-Source: ABdhPJwpuKFLMlDkELRv/wsWr3gla2+IboHOiG2hD5J0WVazcac9MxXJoytDwwwMLUxk8XOk1dGLDA==
X-Received: by 2002:adf:e684:: with SMTP id r4mr5729340wrm.378.1621332433067;
        Tue, 18 May 2021 03:07:13 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id u16sm2509921wmj.27.2021.05.18.03.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 03:07:12 -0700 (PDT)
Date:   Tue, 18 May 2021 11:07:10 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
Message-ID: <YKORzubQmqAZCHRe@debian>
References: <20210517140305.140529752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 17, 2021 at 03:58:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 63 configs -> no failure
arm (gcc version 11.1.1 20210430): 105 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
