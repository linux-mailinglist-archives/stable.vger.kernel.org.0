Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3ED3C730C
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 17:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhGMPXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 11:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbhGMPXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 11:23:20 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20DC0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:20:29 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id j27-20020a4a751b0000b029025fb3e97502so1880132ooc.12
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OXTxS64td+dRNaJgiQPyWrtNdiO2Nyfn3UIfH5CG+aY=;
        b=KmlZrEqjmHz0HYCUzNqlGeXcHOK+W7Beh7xVg0u8zsVrqyQbtjeL7wsJJRamIHSGOD
         hlDNVT9ybaReEmHh/SlEncdB/qorI5iD+Frj2I0N2yjCnQltT8zeTRUQ5s34P2mmWsAD
         RAEFoptcxgZOAXSHQV0m5EWbTJvJEdFPLB+S8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OXTxS64td+dRNaJgiQPyWrtNdiO2Nyfn3UIfH5CG+aY=;
        b=loCiOFrQA61dl44A8BPcUHBqn4P+z2whJR+8fXvFPiBAuQhIQHrK+3PbYKRdhLCxq4
         NqRYAG6hvPf955BJYLpDkUbQrvik2SRYjr95gLJLEmXxd7pOa4JsjUxuvDIuFwI2vpUR
         cK1e2o/IBdZmUMyn2HAzjxmEdIrNKmV8VWdk86Xkf1+0ABdyTM5S9WyWPBb4ZuffWh7u
         W3RgcT9NQQlXgeIO7EzcI8MrRY6no8bdL2MhshQY7a4Zg8YLxeDxxK0wm5WVR842/OxN
         Dkms20VxRaO/kdIzYSncb0OrMNHvhrxaPe0mmwu3J5vqhh7bgo6PFpBS8yRmfbMolemd
         k9WA==
X-Gm-Message-State: AOAM530tL26OZ5JRGHpuYDFZvkaNR0OXawuz1FKH9fHmNXFbaH1iA0qg
        yLPYVp9dVJZsjYVIigcDQEGkdQ==
X-Google-Smtp-Source: ABdhPJzU7ivJvNTSSeTqRwFO8f5nWRaWa0fPaGzACr5C33EAUlzVAwG9cNOBPt7qm/gR+CdWTgb92w==
X-Received: by 2002:a4a:8544:: with SMTP id l4mr3947801ooh.5.1626189628446;
        Tue, 13 Jul 2021 08:20:28 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id k2sm2252469otr.52.2021.07.13.08.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 08:20:27 -0700 (PDT)
Date:   Tue, 13 Jul 2021 10:20:26 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
Message-ID: <YO2vOogREHCBrQS1@fedora64.linuxtx.org>
References: <20210712060924.797321836@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 08:01:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 minus the offending patch against the Fedora build system
(aarch64, armv7, ppc64le, s390x, x86_64), and boot tested x86_64. No
regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

