Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A57C4459D7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhKDSkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhKDSkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 14:40:49 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98219C061714;
        Thu,  4 Nov 2021 11:38:10 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r10so9865467ljj.11;
        Thu, 04 Nov 2021 11:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TRIKBdyWwriQiW41/keY6XJjxk8cCTtHBYP4H1tuIjA=;
        b=YoYwR3O+MT14YxJUvcY/4+vEYDFRsMgl7/iEKQyX9pImwvNw734Fhp7qlcjjfb7Hxh
         M/26fVriNaKoTok6vfJbBKuws7wFY7gg4lqrtn/nmqo7wvBYw/pztC4zzvosS1QPSioG
         GykM5M1O2/VTids5Ix5QwCBYeZ3rgOypzgZCK2klegvazalegnFHDyMqpsK2F11+LOXz
         KEK0DbAxclYy5pdGQCSiZ68eFSBHRjfKBCZdwboLiqEksJPL09RstPtTWkuouIgdU48K
         ftu1sLpawNqbHzaEFt6oUJKOEuWTQXX1yAShk00BlVHUjBjPIJCo6sEfnMl3AaDaq/Jg
         Txaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TRIKBdyWwriQiW41/keY6XJjxk8cCTtHBYP4H1tuIjA=;
        b=lBKGaB/qWBieYB4EztdXZzaPTVqjLGKeitNKVKs1O0zlKx+zbLmysuU0nCeuFsT3vQ
         SsCQGTt+8fhv80AigMKKguUM10vJN2LuSltmMPXPRREhLwwav0zVJDV48Zojta7GXi8l
         s6kenitQWX4zCb3ZscXYphAI1FXHHy4XOPYlYPjyIJiIhoMslpuDdQFwK2xLw+p+uhOQ
         IigpcUR6FIyPoPhRoWeqJuOiud58/xB/5GgmieoJMqVF2UzHIHjeZBQUfPKUIGxGFzeG
         nDR2q3r5sX2uMFZ8bUPesGfhee79NJdcBeftbL+TvVcWYZkBy+i8eLppB1ITGLNlYHNg
         GTSg==
X-Gm-Message-State: AOAM531P8Nq1AFaMzPYnOOOBH/Jtz93C405yKhLXPtKP3ApcX5WlQsd3
        nzgxqQyYkGqI3XFrKVH9GrSqQyexoSpDXtn3uE4=
X-Google-Smtp-Source: ABdhPJz5t+etsvoY2Sx5OL+JZrwtgPe8/CieuilIhmPG7CTfxiHRmT7/3fx/WjbKYtFiNR+j/4WmdA==
X-Received: by 2002:a05:651c:8b:: with SMTP id 11mr5136804ljq.343.1636051088666;
        Thu, 04 Nov 2021 11:38:08 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c36sm95572lfv.152.2021.11.04.11.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 11:38:08 -0700 (PDT)
Message-ID: <61842890.1c69fb81.83b5a.084a@mx.google.com>
Date:   Thu, 04 Nov 2021 11:38:08 -0700 (PDT)
X-Google-Original-Date: Thu, 04 Nov 2021 18:38:04 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/16] 5.10.78-rc1 review
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

On Thu,  4 Nov 2021 15:12:39 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.78-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

