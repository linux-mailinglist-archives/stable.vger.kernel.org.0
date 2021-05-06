Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D77374D08
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEFBsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEFBsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:48:40 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC7C061761;
        Wed,  5 May 2021 18:47:43 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id b5-20020a9d5d050000b02902a5883b0f4bso3560159oti.2;
        Wed, 05 May 2021 18:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9jGjvMFjZmLLBUke3eCwusr90BsU0KU7fNL5i4sqw9s=;
        b=j1rsCXzmOz0OkVbxJJesBipVzE1AwxQx0FixrR+/VHGE+AyMYOblhl7D7MCUAT2V45
         On325LtJLzR7Dg1fAaR3JurBeBQdJCa50/OuZIFR4BEFKjqXesjR8Fuu2uUgdmawTdfP
         jYGWqdR8R/T+g5d3wPqJBswmmXe7pmKZL+HrUojci+DmFykrmnN4rVGAmgDwGLXlk9ah
         FSFykSKQeeB4ufBXGsyLNSpOWbH2cM2w5ahTF5lnZcgqvdN0+30/cZL1zFTSRQMauiv6
         KqQT60sucXk2XZtY/ChK+6b3rY7UeCSd+DbrS0gK3KDQw/XBshxY1tRdRFUy50YMwiXm
         LDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9jGjvMFjZmLLBUke3eCwusr90BsU0KU7fNL5i4sqw9s=;
        b=oxYwNSL6Hbr3FkE4AAWeH0SDIlBFvNSdW0aVTgt+0XSqRJmlxI1Qw0QSzjmdS4+MxR
         5PPvnO95/KlYjwjlcAF5j/cZke58781KD9aOMTBFmz5HVmQ6uuz0/Kypl+x7koBTuVe0
         j2O9Soi15aUIIrRHDLoAg8XxVWXRkfmdH2e/tm2105QS9aD8dZ/UQFLDPvJgj81MdW9/
         JgiS3Ztwx4RVoZ6OGWCIaSBb7T6ynx9j/e9LtKDjZuwqIT1Zo3vB4u1qpFdzznqwOkK/
         NA9dNOT7fefeeuoqQFyhp0KZG9qbLWtE/mTct+prvS+1Zi8e59uqm2NeDuAAUqL/OOXk
         TDJA==
X-Gm-Message-State: AOAM530GU6T9saaMRDp+2zN1BvUwGAYEPE2zumsw/iEMCXZauhnKJqW/
        DeaeBbtrmkJLgRskSTAWMcw=
X-Google-Smtp-Source: ABdhPJypg72NNJnxd/NmnYs687+f2JdIaPilxent0GpxVliY3lY2VPO1vwWVd3JJO5qLFR9yzKtwpw==
X-Received: by 2002:a05:6830:1449:: with SMTP id w9mr1345631otp.183.1620265663022;
        Wed, 05 May 2021 18:47:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i18sm239596oot.48.2021.05.05.18.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:47:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:47:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
Message-ID: <20210506014741.GB731872@roeck-us.net>
References: <20210505120503.781531508@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:05:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.190-rc1
> 
> Miklos Szeredi <mszeredi@redhat.com>
>     ovl: allow upperdir inside lowerdir
> 
> Mark Pearson <markpearson@lenovo.com>
>     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 
Wait, this also has the double commit. Can you please remove the bad one ?

Thanks,
Guenter
