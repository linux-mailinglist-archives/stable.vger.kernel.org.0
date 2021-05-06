Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6D2374D17
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEFBxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhEFBxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:53:04 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD7CC061574;
        Wed,  5 May 2021 18:52:07 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso3530784otg.9;
        Wed, 05 May 2021 18:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uPVoWqI0d8mrsmQqBc3M9Jr4PjLHSXjZkH0pJDYcatE=;
        b=pn8I6OsQfi0b3iInJAl/r3pDK1TLjHQ+fWX5U0OH/pmyb1XzWFZwwaJhnQuYahxvEA
         Mh0ksHunduHwBrpg0V4RPMsTo8UHzrOmUUj3GgVbCGez/ufvZwpv4K8IgHtOpxXksKVI
         xzt8Cc6w/pCmRcr71Sgr41WAwRj3rz9fR2vtjCQJobODnE2caEqpp/azOO+XOcCd2FsF
         NGpkMufGAe2YHXNQDBw/+EJgOi2fjnhEMSphX7LNO5acFL7p8Mvf8h6Fj+9Fk/7pBov/
         Aia0Q+7rggHMOnAKN/nCbiybNl9UgyFrWfRev09RBsMDGaCJ/LF1mMF1crSZ8ndbLEab
         IA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=uPVoWqI0d8mrsmQqBc3M9Jr4PjLHSXjZkH0pJDYcatE=;
        b=sLNxpJO02nKy2bUJvkNil/vuG5eyBdQK0r/z6WfEDPGwNoOJ9DnAydY+wDaCcG/GTq
         VagkRwqPTfdOMLLQopfj53/hUbgFmlVlapJQOuPcwEmG50muPkC2vS9ksKXXa2oQHSvT
         blxZs0NZHGgEvAmSi1SBIvR6EtHF2Z9nvwl9/XwRXtq+HnZ7WMNG9f1JfMCgIJMcsy69
         ycHmc1X7kJ4VdSahs0Y0RIMm3e9wSFiJWuh5OagDlVc1PAahPIiFZ6v8soaQxnNpBRSL
         dV96+XKHnHCK+NWmB8fdnIl8xQD2MrWEHLnlZ8cpwDS9WnXXRVZsnTHuinNXVQRqISke
         Celg==
X-Gm-Message-State: AOAM533kUhQaCWPOdBGNoo6rqPmdhynOP9/MXMtlM2XD2sIazzjLlPbz
        mlwlUky9GUfMdc1PTbgTviQ=
X-Google-Smtp-Source: ABdhPJydK4UvVszfRDGVLnafUNtIQWSlLBYSc/9ea5PChWoHa6oxU3ST3i7f7B67kqNrmY6MP0BNUg==
X-Received: by 2002:a9d:7f0c:: with SMTP id j12mr1339735otq.299.1620265926582;
        Wed, 05 May 2021 18:52:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d62sm188847oia.37.2021.05.05.18.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:52:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:52:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/31] 5.11.19-rc1 review
Message-ID: <20210506015204.GE731872@roeck-us.net>
References: <20210505112326.672439569@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:05:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.19 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
[ ... ]
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 
Please remove one of the above. Other than that,

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
