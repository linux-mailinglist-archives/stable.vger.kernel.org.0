Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBC346D100
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhLHKdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 05:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhLHKdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 05:33:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA8BC061746;
        Wed,  8 Dec 2021 02:29:40 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d24so3336428wra.0;
        Wed, 08 Dec 2021 02:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bL2vBouoJl04zZTZ7O+4pHtWybqemOy4SAl+4qOqB84=;
        b=q5RJXRX9Zng7/iO9sJObJ0h6Z08A4WqahCRtoqsZmuBLPi1LuLkx9JpR4sD2S8qSh4
         XeeycQ/EnxGPYbpcA8ZZjOg5CbniYBmDdkzPJ0+KJP8eVmndnrOQOPlZ58YLCZc8gjIc
         qkvh8C//M/OpvhOcoN2UAaB1hjs/dJuMgiqY55zN5d9IYCDwlqco55w/ux0FSy4HwCRm
         x9mScjbIrsdiWhKFeqZDKFU1F3U/b5QxoNvekPosBsanuphGpCzL83dK+UqxSblb7cHP
         pohb7N6PXuGLZ9sR2ko3UKA2ylFieOxf3KXxO+WKFJOO+vbPDK/jh0p5P9xSnootKV0e
         H6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bL2vBouoJl04zZTZ7O+4pHtWybqemOy4SAl+4qOqB84=;
        b=HYWIpglLwbdWuxUgKl+/jeu2v7fuq0gn3v4mx9fram6xHNYfdusV1hSk/pb0qyaGuQ
         0XB0rKSDDy2uQNbra1vPPv60iS+URrdLetp/zXYKCTcxpX02z44vYtkUY8ZWvmJyH7zs
         bz3iKoheEQjpErFtVfS5RQzIgA2mOtWD4213kGw+PBe2b72ccPTYqnpuG8iqyIW0OWlS
         JLkm68VJL3buNHbcH2QmpK6KJ6ti2dPRhL/eg47kVSprvsihgKAA8EwuSxJJkA2yFo6F
         W0nYBULxWnOgz08SnLY22wOAGNC4jGc13m0OefSCivj6xvXl6T26zKEEH6rkg7nRbMjj
         LtcA==
X-Gm-Message-State: AOAM530OzCfEIKN1vxSGQjoPKUN/JMNJTVpusbgO0SBZdvuH09I9u/E4
        SS00r9EnqMXsS83ePTrshw0=
X-Google-Smtp-Source: ABdhPJzQBSuYNR9OS4WylRBEdAmO+/hYf+YNr9ieb/HtK5vwMVl8Qyab+BkJWRywJZ/zkSNxTP69+Q==
X-Received: by 2002:a5d:47c3:: with SMTP id o3mr37083756wrc.348.1638959378945;
        Wed, 08 Dec 2021 02:29:38 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o12sm2561589wmq.12.2021.12.08.02.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 02:29:37 -0800 (PST)
Date:   Wed, 8 Dec 2021 10:29:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/70] 5.4.164-rc1 review
Message-ID: <YbCJD0ikskRH9SWq@debian>
References: <20211206145551.909846023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 06, 2021 at 03:56:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.164 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 65 configs -> no new failure
arm (gcc version 11.2.1 20211112): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/482


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

