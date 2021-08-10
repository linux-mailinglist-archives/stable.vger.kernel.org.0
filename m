Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF20D3E8632
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 00:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhHJWsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 18:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhHJWsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 18:48:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A061C061765;
        Tue, 10 Aug 2021 15:48:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so6654946pjs.0;
        Tue, 10 Aug 2021 15:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=v+HOSXKCXGzdCgapEot+fGOS6gcgsZ8oF8c9VBXcAr0=;
        b=kb6Sr2KwWdAcF+y+bFzPHXnQzoxM9KTz0Kc7XnnslmrCZupXk+DsdEpYbuuZnMIh5S
         mqNhGCey50y8Lv1Mqxcnv9pg2QCrdAk17XPnfC7vNscM0DiaibEWGYuzcKeV8FRoZVxx
         OaBlME5dYsAuEaNzZ6lSWBpkWgq7ZLANO9QZNWpXtM+KX/nJmWs73eHQW/ECZqQL4inu
         WPhLkd9zLhzGl5/2qQazKSOJ0CJQs2VJuctOk4P9n9ZCO5E7OnXSaa6O1mbAL6AosIxm
         Eqa6HaIDGp0Rlanc/cLYUCHlKtFxPjowlBDuUV8BvBurFJrcHfrgKKQ7+SoriWbEQfao
         oE5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=v+HOSXKCXGzdCgapEot+fGOS6gcgsZ8oF8c9VBXcAr0=;
        b=GaPXO+Y1Zq4r+KJqOfthV+CwRIKS0HTvThpiAvGiE05SLCObL3JTXgzRDInhUd0/Up
         0OFCDSdT6dZyPk75NzsIfhyHAFB4/wDt4XNfIF/iiyzoma5uxAYHKdfXbmpBuOMgdOo2
         1um/L89FWCNJ62f0vSF93Pl1kAk51efzOkUm1AM9bV1iQQ6oqylj0YKushJ06pwBkSUw
         nXtEY89kGJ7eltJbub7owYtvcBOEkBG9YVND9K7R4C5yLL5n/i2giKpZcHBYiJC1oMwg
         tjBKuThhI+z2tiFtRib1QuMdc/7HGKwwjtCtu0j+gleMvRGX4iL3PdFJGrUuqVeOR1eM
         O2Vw==
X-Gm-Message-State: AOAM530ovJY6eYTdC3xdW1TpUrDoYqxCLpWrD0taai9E4aZvwRSsSkNk
        B5Sf6jaBbJ+5L42dsECEZ1GibfIz+PU1IeeYuQY=
X-Google-Smtp-Source: ABdhPJyb0D5D3QjkEekD1Uxj3MGVWjAf2J4DtMEmnDNZ0KjlMWmy4PhLR9RdlNVoCUpiwzEBtFcyDA==
X-Received: by 2002:a65:6441:: with SMTP id s1mr395559pgv.214.1628635689341;
        Tue, 10 Aug 2021 15:48:09 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id d20sm5365829pfu.36.2021.08.10.15.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 15:48:08 -0700 (PDT)
Message-ID: <61130228.1c69fb81.7a46c.0c24@mx.google.com>
Date:   Tue, 10 Aug 2021 15:48:08 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Aug 2021 22:48:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/135] 5.10.58-rc1 review
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

On Tue, 10 Aug 2021 19:28:54 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.58-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

