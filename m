Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8540F8D0
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhIQNI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 09:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhIQNI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 09:08:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A10C061574;
        Fri, 17 Sep 2021 06:07:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so9206783pff.3;
        Fri, 17 Sep 2021 06:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SbspggahjkQzya3bg4IikWDV7m1YsRoruFbcX339TLk=;
        b=Wm4KsdpLwSkANI9J4mWsWejLIvXInPqg+vSxHJQ8KAY5glO6FdYkN5VNzBrrujOMci
         0DkYu0qmKru319Eg2tr3BNLYvdICdEB1LbIuk9IdyiLHS61aK6cij2UW2yLjAWhvncUx
         2iONteFL3j+kP3gmxafUmUp00vE7OTAYcTYHOc8Pt5Mo6s05T4Bucx0sHlATLD4XQ1Kh
         1g301wMEsSgwvMl3JMqBKcvtEE5S6BC1bmr1uLrU5D2TJ1tPt4SH6+XZs+kCSKBmwGZ3
         Tn4ZLG/WX4sp3Lx3BU09tCqLhc93vq0UrdoLw/3Jz22UtlXRqC7m/nIQM3VdulL8e4er
         ncwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SbspggahjkQzya3bg4IikWDV7m1YsRoruFbcX339TLk=;
        b=b7X5evEgbux+Bh4/wdwvpPTis+58EWe78t18yNNAD5A+/P1RsCoI9eb/LvyGT2BS44
         hQzCbumjN31kSErbo+F2zMoDEcYJGjwdwVS4TNjVlqcwhjvs+JZbyIOuqcKXWUgUx+oN
         gMQgTPic7H56EHcN1oWvHwADPyuvpj853XqAzvqpnS5wVb1Tp408aagMmESz4Mo4L+By
         z4YSD9bGSEC1UAxIN0Xqit4gDMfaEVGmlFiBwkNXixV/L+m8HWn/YZUDY7ieqzGFNcX0
         8eA+laNyAgYhGBz/5QoFIeiLZ1JFSHWVMYc4J5EOI4ijILL13ZtbcGNPiIxyoNg1fZZb
         DZUw==
X-Gm-Message-State: AOAM532e1PZmjslDFB8I2Fz3PRbZdtjOWhGlhylB4LR2zRH/gaTEw8Yk
        AYGrr5JX7+mEwNa5Dzxc7CnlkooY7hBu117HWuY=
X-Google-Smtp-Source: ABdhPJyYFw6i6pJ0qpoUUQ4RTisx1Rt6LbibTN4CiHya24hKg9E1SPq28mcgUp3/FN+IYQ0bBW+zOw==
X-Received: by 2002:aa7:8014:0:b029:3cd:b6f3:5dd6 with SMTP id j20-20020aa780140000b02903cdb6f35dd6mr10665486pfi.39.1631884054507;
        Fri, 17 Sep 2021 06:07:34 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id c15sm6249446pfl.181.2021.09.17.06.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 06:07:33 -0700 (PDT)
Message-ID: <61449315.1c69fb81.72427.7777@mx.google.com>
Date:   Fri, 17 Sep 2021 06:07:33 -0700 (PDT)
X-Google-Original-Date: Fri, 17 Sep 2021 13:07:28 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/432] 5.14.6-rc1 review
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

On Thu, 16 Sep 2021 17:55:49 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.6 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.6-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

