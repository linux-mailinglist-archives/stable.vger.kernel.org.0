Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A09374AC9
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 23:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhEEVui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 17:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEEVui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 17:50:38 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52457C061574;
        Wed,  5 May 2021 14:49:41 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso3097834otm.4;
        Wed, 05 May 2021 14:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wmD7/CI0igsOX28HyIvBqbXYXF4ghwbLUFAW2XyLyC8=;
        b=QKP14rpC5ftJQ8nIuK4+7iw1yexXQmkhFe2BpUr15jfDQleYwZ4Kptsr8Mdu2RWhFc
         qg6YVlwK3xIa/0DCGn9lVxuP95k7I2TDCMluWqZBKS1J8onHHUx67kHqtJK6zJIm3cP4
         Qluk8xxHpvuNSaNSUuLIjDHe9QWwkf0JcdqtD4jPIUsFyMB7Rlx3Vt5Y3uE/nyogVByx
         ZeeYVC4ZlYi+gR/nJiYnIjG4eZCNnY58tuF+mVX2OEwzktjD2yenGAIG9+k9p712asMD
         LwJryu43qf1Rt8Ko6lsEpw2N0ktXPNPjXQVn556h5irV2Inzg//t2u0pWxAGE9u5JwKB
         xdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wmD7/CI0igsOX28HyIvBqbXYXF4ghwbLUFAW2XyLyC8=;
        b=RDDLZj/SFGtOQ/Y3APD3X1VgirCZHRIeCCctR15FpYe80KkhKw7kRjh36V1SLtj1Kg
         hMiJ8Z/BABQ2weXh93KSaC4/A4IfpApr1zu0GpNnsJCwbthWZUOF9hZuyja5/ncUx20G
         1cSuJHUmfhWQVtgAml+k/kXUarfyrdl6R3zZrKKc8sU9z7q81Vk9wnhjx6vB4UR81qhR
         ghb3mhRX6dUqJrtpfUKiuuHfkO559RR14R2Ihxrt4LEd/u7Mpbw1pNTIwYywOKiV5V2t
         cA80b0hIDpodg58deFVgTjldcOy7yAcWkqbZ0sN64tzkDs9fpfxih+1JLhe+E+mOCasG
         3ghA==
X-Gm-Message-State: AOAM530NzWOg+Z9boMLLsHcDy7g6yAtqgbWnbsnkSxTJoJg5y1N+MSGD
        34EVmzBHV8OYL2mMmaQ7Tuo=
X-Google-Smtp-Source: ABdhPJznV0JbxNOL4vcbp3zTSj+RGYKfzyBuq1/VOIUwsqrKd9ypmhIlNALEEW4Bf0Iyf2oWRWCfQw==
X-Received: by 2002:a9d:764b:: with SMTP id o11mr659528otl.149.1620251380770;
        Wed, 05 May 2021 14:49:40 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g26sm175167otr.37.2021.05.05.14.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:49:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 14:49:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
Message-ID: <20210505214938.GA817073@roeck-us.net>
References: <20210505112324.729798712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
>     Linux 5.4.117-rc1
> 
> Ondrej Mosnacek <omosnace@redhat.com>
>     perf/core: Fix unconditional security_locked_down() call
> 
> Miklos Szeredi <mszeredi@redhat.com>
>     ovl: allow upperdir inside lowerdir
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     scsi: ufs: Unlock on a couple error paths
> 
> Mark Pearson <markpearson@lenovo.com>
>     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE

Twice ? Why ?

This gives me a compile error (the second time it is added at the wrong
place).

chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:722:1: error: redefinition of '__mod_of__ak4458_of_match_device_table'
chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \
chromeos-kernel-5_4-5.4.117_rc1-r2159:                     ^
chromeos-kernel-5_4-5.4.117_rc1-r2159: <scratch space>:119:1: note: expanded from here
chromeos-kernel-5_4-5.4.117_rc1-r2159: __mod_of__ak4458_of_match_device_table
chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:711:1: note: previous definition is here
chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \

Oddly enough, I only see the error when I try to merge the
code into ChromeOS, not in my test builds. I guess that has
to do with "-Werror".

Guenter
