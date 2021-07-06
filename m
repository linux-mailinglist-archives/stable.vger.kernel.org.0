Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FE83BDF51
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 00:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhGFWSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 18:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhGFWSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 18:18:38 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787ECC061574
        for <stable@vger.kernel.org>; Tue,  6 Jul 2021 15:15:58 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so329339ota.4
        for <stable@vger.kernel.org>; Tue, 06 Jul 2021 15:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pk6Sq7/DdUaC7GkGc4VzxZTNhY8KMhDPrLUMFvev0s=;
        b=Hq1uiaI75WO3E4BVIgeQ0zAv2baYsrbDYbxxcM98u4EqkBIlHWhGTnZ+gSCXCJWi79
         04GcafYYpPf8L3bqPAxh1FE4biwDDHeVAyrIsh6TLbHWCln3H6xH+P3FiqvIGWmRBhHW
         UPKoYxxGKIMoq4sg6cMlXj8mu7zrHt49uvYa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pk6Sq7/DdUaC7GkGc4VzxZTNhY8KMhDPrLUMFvev0s=;
        b=XwoeBRxZiJlTQQDEzsPPJCiuvxGMOI7V99gMMsAQSQ2R3zwjjLRljRMMbuHfF7nAkd
         HFe/+99G6apcaZQ4sR+HKTRtdJeIDSkD6f46mXfmwmZ7mMW+2AnLSAxeYe0J3kUk3sYR
         SpNymlB3mWa6PZ/FksXcWOKM/1zNdwujLNDQN8Rbl06kU2TRxH6PEw/vtY8WtJAfjnMP
         0ABxJPzZSr+Um0mZnXRGfQbjTKFdGWKZbsKByHFICAWSsldBkyGncaquD1IJJC4J5bJi
         fSYSQ8T6WfjJBrt9iHBj1JWcM3Gt0LcqIp3tpI15SgtyF3YbAPYrj+98pitsNRCjyaaS
         S+yQ==
X-Gm-Message-State: AOAM530XA5YoXDIqLJ9WG+LF4ENsNpEIEHHOCO+Ph/bcE5qZ3WZzDuqf
        Vs0ip76UHWUYmu8HkP02gjb0uw==
X-Google-Smtp-Source: ABdhPJwpJL51bCm1sdJCF2o/TPvKub6NbwooJ4g6637IJu8FcOK8BJDuutsJlvxI5XIA04eHhlUazA==
X-Received: by 2002:a05:6830:1e62:: with SMTP id m2mr16437384otr.290.1625609757652;
        Tue, 06 Jul 2021 15:15:57 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id r186sm3679913oia.6.2021.07.06.15.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 15:15:57 -0700 (PDT)
Date:   Tue, 6 Jul 2021 17:15:55 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.12 0/7] 5.12.15-rc1 review
Message-ID: <YOTWGzxh0XpYLlmT@fedora64.linuxtx.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 06:59:27AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.12.15 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:20 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.14
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
