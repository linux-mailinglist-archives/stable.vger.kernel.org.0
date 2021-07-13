Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A403C7319
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhGMP1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 11:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbhGMP1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 11:27:03 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D150DC0613E9
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:24:12 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id e1-20020a9d63c10000b02904b8b87ecc43so8919429otl.4
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 08:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RUS/cKb1oJ0yUUu4RlqSTEODiLdVfyJkNd4mKukf1eU=;
        b=OwV0ajEJZO6MssN/YMLhAkpfVfE2OCRODZGzTDbXYziviObjNSACXQjWtqlSAgVzmC
         9nVdOhm4v267mtk6pfPy7FgZlKyBRj1Vio2/mNzYHuEGok0OwiKGFYv7l9FrYVVWAzd/
         0af3gmlIR1IJG6nXKgAhtbLQyyItSd2nDPIh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RUS/cKb1oJ0yUUu4RlqSTEODiLdVfyJkNd4mKukf1eU=;
        b=SK1k/AIbHRK3UvKXolWidcRtlKrcpxYlbcbYPSBJavcGQo/uC4yA23+fhGSA0ZcewS
         kDc3bk1KDnNWl6laR6Ul30X16bedZ9YU0/9vmJTR2fvyfLtdQzkAQW94nv0zrdoD5/Xg
         6UK724T/3GpwQZ4XwBlRapPtDQqdoY7hZXpj08lSN8CROkzzMRbKZe0mH9PqqojqNqtA
         ctMYEJvDEivtBhBT4z9YLcb5IaKRtTlIpSzA1du1Gh+G1YpsgPyNR59JgxksRVQZ9fOh
         U4qC3XrBBXvV1Q6uaQthwQwi7Jv3NXVKRzR4rMW1pDmsPPA/nJNSvGv49pQBf4p8oMVz
         2HsA==
X-Gm-Message-State: AOAM531VihGi168AmyO5/uThBXC8CkukyNuYViY0JNopN/4dpntiz4J4
        auKSf9KGZIclLvheceVRWUrq7A==
X-Google-Smtp-Source: ABdhPJxQVCRCIXUuLCpEK1kjmhA/FmLWyocZU1syYjHJesNMu6vwZFGJErvJZCMm4/oB8IMOL2kvew==
X-Received: by 2002:a9d:6393:: with SMTP id w19mr2003642otk.218.1626189851275;
        Tue, 13 Jul 2021 08:24:11 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id 186sm3280192ooe.28.2021.07.13.08.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 08:24:10 -0700 (PDT)
Date:   Tue, 13 Jul 2021 10:24:09 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <YO2wGeKSqx4GJ5jm@fedora64.linuxtx.org>
References: <20210712060912.995381202@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 08:00:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
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
