Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A54417A78
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345244AbhIXSHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 14:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344425AbhIXSHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 14:07:03 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F41C061571;
        Fri, 24 Sep 2021 11:05:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w19so9528357pfn.12;
        Fri, 24 Sep 2021 11:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eo3oiEr1UbKis+cGgoNa81IsW/nMPF7geldrmOwwFuY=;
        b=YI4unMm2gqhvJzztvsATr7jGtpmsKo3w9K2/2BUWc6AHio9W9YR2yCSjT+lFoBjzxG
         aXnM0sB6MT6M7xhwGkkfCydrZ/wy2f2MVn7IbY3dzk0lb/+r1BeAfflaWNm5nBiC8ImS
         jN6NOPvGDzNIb4K0xGFMLl+WOn1D6EVVC7acg6ID2L3aaq5OZTkQKkQ8iUCTZGL3mmlT
         18vPrvGvJHs+not7eW7eZRWjiUSgVlGD5xb2KZ1x6C9wGRm57+OMVuIx+hCxfWTAnNEp
         YuFmFlZv83BBsxWPmCZmMgWaShHcyHgktpcrw7fqDwVLI4TQRkHsb27wA9t8EouKAjBi
         +cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eo3oiEr1UbKis+cGgoNa81IsW/nMPF7geldrmOwwFuY=;
        b=2dUapJYZxTup5kDgOWLbHmkZtHKv5b357T/6kE7fhoRZALJkgF/t01ISYYT2VgWFom
         tlL7KadpveBLr/5ntDiEgUbtLIFO/NyoAoA4BHnGOdWzzOYrF59Tab/9IQk8Og71p0Be
         wcoKQ4l8St8Tzl9PK0XaJ75VCZayQ+yZrobWBk+1PGAtJE416QEC+rmvsInEPtzqy2mn
         1w18EeK22q2F4+EUrVJFFNM/qQx4Q7XDPL93Z0y849NNpTdwnaLL5BMao7lbMA8XgFt4
         wLvdfenP2a4flt9u7IsXWiBQqVD0hjM7Uzy7qQsnkMhC5GxOPNuTmfFNd8PB/jkOsGk3
         YhwQ==
X-Gm-Message-State: AOAM533sAWvnrsWZm4+uysipf1FHYmMNV7xHmlCYTImCUMW8DZMLdPfl
        Ovc0nZSuWezr2ELolLGD7AtPiGferkhV/fFReV8=
X-Google-Smtp-Source: ABdhPJwibx9xtDy45Z/SVSQah75LYowCfPsSlY/rg7xk15nK/LHJWCJELegKFGc8+tKwVg/nLTt0Mw==
X-Received: by 2002:a63:9317:: with SMTP id b23mr4832874pge.199.1632506729015;
        Fri, 24 Sep 2021 11:05:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id f16sm9425732pfk.110.2021.09.24.11.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 11:05:28 -0700 (PDT)
Message-ID: <614e1368.1c69fb81.31e4d.d8f8@mx.google.com>
Date:   Fri, 24 Sep 2021 11:05:28 -0700 (PDT)
X-Google-Original-Date: Fri, 24 Sep 2021 18:05:22 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/63] 5.10.69-rc1 review
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

On Fri, 24 Sep 2021 14:44:00 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.69-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

