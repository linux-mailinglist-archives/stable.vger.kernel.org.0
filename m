Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849AF45C8C1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhKXPhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 10:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhKXPhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 10:37:09 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15B9C061714
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 07:33:59 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so12090679eds.10
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 07:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bqdy2HwxAM57gqyODn8plZfo9eD0lB3qkfbcuNYfcg8=;
        b=nhcCKtCgns6UCVdGy1m0lnvLkFL64LlxL+wuM971cNyAzyZx5bWFIRxf/xI+2SwLVD
         5fkY3F37gP4s4ZJEeHEmSp4ONH6zbGLC65oDql7egG/JlYAvbijiSSeZHNMNlYBn+LDA
         6hnZo6NQnMm4XMuYsxW2lxrI/x0bzBjbcRaIuj29YUkeMUyZKnRulHTyeYklurS4YWZf
         OVF3j5IWhE1v1KqNmpQ6FRNXsgd6/d/1zaf/fua2Tkhr/XEt2bHJBzHZgrScr7Yvm/gz
         xwe2s2DooJIy9rX2V1N7NnTLPLaVvyHarB4fVQ0pcW030KrkWqE0VAkb6oCSFMUNzomQ
         N9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bqdy2HwxAM57gqyODn8plZfo9eD0lB3qkfbcuNYfcg8=;
        b=CHDF4fkznayiyEdxOXin+x8G7E67vRwrQZFMc6tla4J7pO9DjqntimeMU4V1sGupBd
         8atFXWCgA6t8bDKkhSFc7Pc8wecvRJw1bUpGCU+i48VxruGk+KFatxkW8gPRz8Ju8YPg
         +Cra0CecBaYJo5E/P18bBoleXy4oeqs9nqOAs873yQRnts3qGhAVxJk+M/bKBbuV1zAF
         T5WdzKjitXHWHCGmVJ41ntu1GO4Q4x2h3wwAwsa3KYBozlffLzdtYinb/LuBSqFfZGwh
         F3/11LwrxIUdXP3om4h1/1V6OPf6P9eEoo2Csj9HOxXSfxtpjpblQz4A5M5eHpo3C14R
         dfIw==
X-Gm-Message-State: AOAM532McJ+vBZsZDirdUhFTH2OjymksJzC4JggguGOUXzm/A5Ve6Q8R
        1kAv40uFlI03KG8WGXr5Mdc9wEFKnfNF4FgFo7mZdg==
X-Google-Smtp-Source: ABdhPJyxVvYyfWLjSfk0lklRT3neqnyZWMKWUnhVTAd7lHQohE9ZcH3gUHx7zsl6YW5isIhQ3In/IjXCD0pmCNO0GsM=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr20892553ejq.567.1637768038273;
 Wed, 24 Nov 2021 07:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20211124115718.822024889@linuxfoundation.org>
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 21:03:46 +0530
Message-ID: <CA+G9fYt4wOWx5fEkMdYmT0JO+G5+6KBgdDDS7oS_2ox8X_JF4g@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 at 18:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression found on s390 gcc-11 builds with defconfig

Here it is reported,
https://lore.kernel.org/stable/CA+G9fYv+SjDwfvP=Zgf-gr2RngkrzHO_w6OQzH7wqzU-dOW9+g@mail.gmail.com/

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3455:25: error: implicit declaration of function
'tlb_flush_pmd_range'; did you mean 'tlb_flush_mmu_free'?
[-Werror=implicit-function-declaration]
 3455 |                         tlb_flush_pmd_range(tlb, address &
PUD_MASK, PUD_SIZE);
      |                         ^~~~~~~~~~~~~~~~~~~
      |                         tlb_flush_mmu_free
cc1: some warnings being treated as errors


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
