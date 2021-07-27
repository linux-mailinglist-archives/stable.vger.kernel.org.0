Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2C3D7055
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 09:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhG0HXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 03:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbhG0HXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 03:23:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAF2C061757;
        Tue, 27 Jul 2021 00:23:44 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c16so9180314plh.7;
        Tue, 27 Jul 2021 00:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9w71++M5kKYs9KCIY7gapu0EtzicH4HuDVc/XBaSAUc=;
        b=sKTP08atmxQ3WzYN9MpFfx6U9c5URzH8m4WqeW8X5VEKTYziL0jE3kIHPEfSiT0Kp2
         aVyGW08FFxVc8kX1d8m1NeCVn806XSnumq9/vFjZdRH3enVlwcSmNAgV5J2A5UGb7wvC
         dfyachDkHQwzFjFuYpQz8elYvQYNFI75j++PupSV+N72hssMfaB3j9Rqx2nnihNeGBXx
         G/3hXVHYwnwwx62lviAFhjyC+ZeWhZ7tIWmNcAVU6xBP7VdPVIGS3NUjc9UQe9Kjc9U9
         FeCoCuD/8A2rVjFRaCtKYc8dOiJPfLSu/6/IYWg2c4FnMWK6pNSp20iQLKmP6sMpQOy0
         J4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9w71++M5kKYs9KCIY7gapu0EtzicH4HuDVc/XBaSAUc=;
        b=gJWK8+gC4LoewYMukHu+r5+TxABujZthq4K2wzGtZopnO+pkOK9QhO+1Tfyz160mCF
         LKURvAcqKJj+lHrZqg/TNp+TaCixHhHIphfa3iKE1ENpBivVVmCErrIqiNoVEf6AnScQ
         GQpCmxVFe6YzgrQvTw7x/XvtOVCZKOabZiJMXZudcw2hhGmQ2VpcQwV/xvrAVq3/u4db
         dxmEnsl8EopFktyQlp7jiR5UhcFNDuJkPz9OfBjfC36ih2j2hN3Rp0uNLWYf5jVJ7cE1
         QFQJbsdLUnbR4D24PtyjEy6sorKSU1XnXotqnMvrajwIjd78xyi3Vbfe82o6S/3GgJzX
         IDBQ==
X-Gm-Message-State: AOAM530xzwtnyxZNSmJGrgh4Sw5x5JLsNudpuEZC13gb1PIWm5UKMwbt
        J+0/SsnOy1LgvIMsJmB2DPtC6Wggo4+U/lZ6FuM=
X-Google-Smtp-Source: ABdhPJy7kkD1ziygiE41AI2rBmy23xguOkEEKUVMNQHI5i4NTg5lYcTMpZk8YQhShSdiBxOQN07s/w==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr21946767pfh.17.1627370624052;
        Tue, 27 Jul 2021 00:23:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id h18sm1526689pjv.21.2021.07.27.00.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 00:23:43 -0700 (PDT)
Message-ID: <60ffb47f.1c69fb81.ffe87.4e5d@mx.google.com>
Date:   Tue, 27 Jul 2021 00:23:43 -0700 (PDT)
X-Google-Original-Date: Tue, 27 Jul 2021 07:23:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210726165240.137482144@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/168] 5.10.54-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Jul 2021 07:06:01 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.54-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

