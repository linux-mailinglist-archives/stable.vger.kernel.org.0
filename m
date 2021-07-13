Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC83C6F1F
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhGMLJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 07:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhGMLJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 07:09:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59792C0613DD;
        Tue, 13 Jul 2021 04:06:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id p8so29925132wrr.1;
        Tue, 13 Jul 2021 04:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dw6lkmr1adgEO4fWE9M60Uv0CtnlK8zie8DhmKgSQJc=;
        b=eS5w/M7OXRH/7Fs5b98t1/MMZJGxSrFU2Sg4ft5X8fluP/kWCGHwq1AAGk5DJh2qqT
         TDTgi59pPFBjCfLwr54RAz24lJfKu4R34mKLiFRVJKZh/DbJdEcJJEhBwHmOmoViqdnU
         vff2exXO6WUkyRHePB7IwYd4/Rno/eGenyhaHNhU5p00aUi2jk/ERdexVXDhHA8avU3u
         Rq5NIpT/7HgPhTLMx8h9hgUYC0GX1H0f4hvSE6ml8mctySY/OfXeWq03ivrsSxXNksfl
         Vu98Okw8u/70WTXCkZOdzgpsH0b3LBtkRZL2mzbWJV6ixtrsF5ZzrlljTOSiElOKDOfG
         7Nyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dw6lkmr1adgEO4fWE9M60Uv0CtnlK8zie8DhmKgSQJc=;
        b=c6RyyfZYNjuOYL7zFyUKfIFi4HNTlRySDrmMfYHZVVo4F0smJCZrI7auyUxJNM/RsK
         4JJLM3QAk7aUIEIboqzi6KR6WWOAuMFYvZ721kB8+8jU1GXoyB90U4uFuUIxHcSRWwon
         HEgjIpYjq26ptiNKunRfSwXgCYeODleM/Q6kQBh+mzC1+2na0hnkxhuI+3/YVFlKBH/y
         8Zpm3wqq8VUHbDB73ZGDv+sTBu5jELM402W2LQ5CAZf44ugktGDEWT4eW629wsAtXqbD
         rzl9wm9AUuNdmj8KbAo3jPvTO5V3DeRtLju/OIqn0fke7tttJcjEoLlP5yg8CbmQ7CN4
         Ufiw==
X-Gm-Message-State: AOAM532RAwY5jnKPxhnCWB0A9E8Q85GCur++0oa4ng14C+CwDAnfEAXj
        AWZmkVAl37cEVIUXcnD5qBw=
X-Google-Smtp-Source: ABdhPJzbTN73Ez/+vNM5fN4OAKfb8Lsh89OilGH8UG5oRkFycM5EOFPV/2Hh6EPM4Qvs7Lf/tWktvA==
X-Received: by 2002:adf:a1c2:: with SMTP id v2mr4890635wrv.155.1626174393945;
        Tue, 13 Jul 2021 04:06:33 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id o11sm14660881wmq.1.2021.07.13.04.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 04:06:33 -0700 (PDT)
Date:   Tue, 13 Jul 2021 12:06:31 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/598] 5.10.50-rc2 review
Message-ID: <YO1zt7SY+rzDFMDs@debian>
References: <20210712184832.376480168@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jul 12, 2021 at 08:49:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
