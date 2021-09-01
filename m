Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0313FE086
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbhIARAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhIARAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 13:00:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5A9C061575;
        Wed,  1 Sep 2021 09:59:44 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so206545pjt.0;
        Wed, 01 Sep 2021 09:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3eAIc85OXj7ZkLmHl9+B9Ku7yQmXnSt5gOjNDfblUHI=;
        b=Ig6GJfzZaED9QPAAqwCKtAB2rjdMadFqQGLLpQBiD7aM932JKkvUj8eZT7TyR4CbtG
         QLRSm9sfrh4XdyWMkrK9pxRFCqMj4RTDkevt0n/1CbClNZTzdoxZ9soPUHQBNPpKWpkF
         PbvnnrNplZdixf2rHPSJcA91j3ACiZ6GKhbRiB3AiXXMTD+9xCdSuhGQk0aXRhBbk/Qm
         oTDt2/+rEGxApPlzRb0dFACVdW/A4T6pc8TKz5mBgJa3kQYGrYxzoevUHNRIPcH/cjsP
         dXVCCfRQl3a1srnuRXda1APud1zlJ9FBhYR7xOcM9/exj6lh/MeP4zz5wAMWp9Q3E7Vb
         Paeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=3eAIc85OXj7ZkLmHl9+B9Ku7yQmXnSt5gOjNDfblUHI=;
        b=dC/iuK7wJBwj3+iKkkuTR2c+cPXA7BORagJpyRgt3fmKIT+sW1aooHEfT0xNj7P2To
         24uq0bad4Y+Ei2CPcgukYqJIfFJ1SclvUzRkq56RoY3lveBPRb5NqX7bVIq/4V0Ep2pV
         71uAHL0zhFyt9WVbnGYFqPg/5OkCZIW1rRLVnpaAEr2o58D4Z6LXb7yDhf9vkyggJ2LF
         25RAQXe6xBfQQ2E5HP6yinJxxWLlOb5v0yM8ol2DZIJiDEvc1CG69oF4h8dNacpgskMR
         SUT5uFQIujCgEJBAN1pfYvCaLIHrpeL1d1svKRU5K2Q3LWOF08qQHUxXONCZdyTTgigK
         HQSA==
X-Gm-Message-State: AOAM533gcBwAJDarDtvBG5yeup3n62mtqLNajhnMSZd2brT348+zOWIT
        YwyMWM1rw5vUC5DH/sr9An/myOk8XAHFicjqIls=
X-Google-Smtp-Source: ABdhPJwEkruDYF+FqYyYbqeejgYNtF8JmXxtia5hla8G28uZ4hTByJ4aamwnx/9aoQzsr/e5Vt81Iw==
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr390960pjo.120.1630515582905;
        Wed, 01 Sep 2021 09:59:42 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c15sm56287pfl.181.2021.09.01.09.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:59:42 -0700 (PDT)
Message-ID: <612fb17e.1c69fb81.e9c57.03c8@mx.google.com>
Date:   Wed, 01 Sep 2021 09:59:42 -0700 (PDT)
X-Google-Original-Date: Wed, 01 Sep 2021 16:59:40 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/103] 5.10.62-rc1 review
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

On Wed,  1 Sep 2021 14:27:10 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.62-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

