Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC286417C2B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348359AbhIXUME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 16:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344434AbhIXUMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 16:12:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA1FC061571;
        Fri, 24 Sep 2021 13:10:30 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a591700b001976d2db364so8362906pji.2;
        Fri, 24 Sep 2021 13:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pY53J6SXWT5V6xE2we80W3IIiuZtCduCwpjLlsn7WK8=;
        b=T1QyNAp5c870WWLwKxhxAT4pZNAS4aD6Tbr8FBa5EBp/cwLdk+ijjzLiZG5kWRVdzp
         e80MaEkQ7bshtW5pBgzdATCl4cL6vlfYz7PzgxgRr4+1iL8hakFt9yFARK+tXDovD8Dl
         GlRxiWS/2UeUmS2VUgmZYcvoen6MUjJ1wtZGRxO0AT/09XIeFDmID05gzvxR22t5UVqx
         Xx9mNnrFXxZNL2PvnuBKBaUazxtKUIQPEr3BqccQcIwKPNdFZpV7sNELLaa0q1Z6VqNJ
         PucnSgri+4EyVMgEsuPci36jo7vqkyVB1BayK79BkEMwKgeIwrApGIAGqPigwwPskBTx
         AVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pY53J6SXWT5V6xE2we80W3IIiuZtCduCwpjLlsn7WK8=;
        b=cfOO0QLK3hGO5VsXpFwWbsZ+EehT3j5adPUf2NAaosBqhSE9BcSuCXdS4Fi5tBvAAa
         wVzbXLPG+uMJXjE0bTHc9VFrkyhYRI2InVkjsplr+ZQNEGu8NfG2Lavnjp/2wPvLXvts
         vtdyqi1atABqyuokH5sO7w5q8yP7VHGtgFYGwrqTjF84462DstF6dzhY3EbcTWqsLNXA
         gkoMMAeW4J8bhCxJS/aAo7WuVvaF7JeqjfSEs9zGmPJI6c2x7h1xhQpVzgB/ZTkHA8aR
         yYdfIS9gs8wPfHR6DJD6K42axWvOidQsUdGmbq8h3U7eE9dd2IceA0pxJkdsTCFQHwbt
         Bokw==
X-Gm-Message-State: AOAM5320lZCJcxlGajUY1oCJGLjPgWkXXiBANUp6F6+Ib9rgMbjGSbGD
        JqQ3jIdu1uI7nrkcRG1KVciVfIFSg7XfZizJ4fE=
X-Google-Smtp-Source: ABdhPJyas6ik1zrMNRQ6SZtznibyfClgIPaszD/fnpGC3dLcNzkOBtDYeorYojYQYJB8yszCGPpKdg==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr4340333pjb.222.1632514228966;
        Fri, 24 Sep 2021 13:10:28 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h6sm9794995pfr.121.2021.09.24.13.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 13:10:28 -0700 (PDT)
Message-ID: <614e30b4.1c69fb81.45515.dd45@mx.google.com>
Date:   Fri, 24 Sep 2021 13:10:28 -0700 (PDT)
X-Google-Original-Date: Fri, 24 Sep 2021 20:10:25 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/100] 5.14.8-rc1 review
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

On Fri, 24 Sep 2021 14:43:09 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.8-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

