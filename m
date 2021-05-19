Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE093884DA
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 04:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhESClM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 22:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbhESClL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 22:41:11 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022A4C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 19:39:52 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id d21so11756191oic.11
        for <stable@vger.kernel.org>; Tue, 18 May 2021 19:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=42kZB8rIxpXtlmy4eCZ87H5Cnt9bvCmXlZWsu3b1z3M=;
        b=NNhd+3lWHQVOpFOjlp2fwFvkZ50amWoTiFTDPNe7GD6yhK96uPN34fhxE4x9eM4yNS
         yAbGEB4zhDJyCWP755DujLOSBmfOC8U0MRudf06cUgiFaqwF5ft6oxDF0eUJoBMVd4aV
         tPECKBVisePO+NLdw9x5Szv3CPSyDKzvIaUjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=42kZB8rIxpXtlmy4eCZ87H5Cnt9bvCmXlZWsu3b1z3M=;
        b=ONktAesG4qR//ZBLrgeWYhfw6BwiJuiwvPU/zN4ULj/HCGjrAO+qZ9jFOAhsA/Yeii
         Di2tdVoc2OQmj4NCBA1noSji4dz+M2hRdlTibTljPUF+MqG/EA0cu7G12+Fq84LPHzvQ
         KRAWZC+0KRjB3HtnQDf7qDzI6la6rVcCLMSlJRouiPr8DWyrJoy6GRnuIVz+hHR26Awk
         FHWDwumEZKYQ7CG+OMZtbQULUbjBk7fzWIO1k8cIHxfnABbQnpc0mZZFQIbKt6tXAo+b
         NL3KO22l9pE5wxCXUa86KFAr4ePYqFkHkrI/vVZDVX9v4Zz1oY1Fb9ltzle9W+nKdcPH
         KoOg==
X-Gm-Message-State: AOAM530sRpEBUQaJ4JkQdhP4mgRFi9+g6igySIO7ZCXIW5KQVyzXxlPH
        PfW64V/tBL+/r/2V5g3VKqSujQ==
X-Google-Smtp-Source: ABdhPJzr4/GMtfxjWDvXAg315JZjId8p+fzR37sPTwSeZhqI58ywGSfe7Mxd5R2wxoqp85XnfRDfSw==
X-Received: by 2002:aca:da89:: with SMTP id r131mr6384423oig.3.1621391989286;
        Tue, 18 May 2021 19:39:49 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id f9sm4262728otq.27.2021.05.18.19.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 19:39:48 -0700 (PDT)
Date:   Tue, 18 May 2021 21:39:47 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc2 review
Message-ID: <YKR6czNAwad1/mB2@fedora64.linuxtx.org>
References: <20210518135831.445321364@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518135831.445321364@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 03:59:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 May 2021 13:57:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
