Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9960145CACE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 18:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhKXR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhKXR0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:26:17 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3599AC061714;
        Wed, 24 Nov 2021 09:23:08 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k4so2397994plx.8;
        Wed, 24 Nov 2021 09:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QiTyHkUZIqBSjf76CoNzhWCPjkxzgP2ltw+lvERaQfc=;
        b=gIQIUS+DnyMAg+OzAshmIabHz7lFiOr6M+GiRZrrkQYqrb8H16C7+PdvGqB1YhdKkL
         +TtDlO/FBG+dIfh4Vwz9fAyIDbo3XNbfYgJbYxwuzf50KMdZ9fGbTHzK7a+BkP97MyEt
         EDjKSH6IcFKU43uiZTakC0K52JJoVl4cJKuUBseN0VDCyqQpzU7wNx8Cpl8VPzMFSVW5
         Z2AOSsBFYdQ/b1MAYjqL8CDM9EyjSyCoHcIPu+4LGGsL2eWnV2OEk7upnEjMk6iMycqv
         /Z/Zcr23inJI085PmJjas0oy0Dp85HAHL1WyO/3jm18QChxpm37LVRaomxkR5Ey5QUPW
         PYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QiTyHkUZIqBSjf76CoNzhWCPjkxzgP2ltw+lvERaQfc=;
        b=S14cRkE0Vp1by+GYd+gLrD7OYa74udKQz1SXH5E6g+jtm89a7XvdflYaaXHi9atkWo
         je67sKToyYMYuHSvKiSPcibTsUgxC0Ir8EU/Y96AtFqyodcM4TLmYEtemlNHKuBTAA0r
         5z+4ujlZvkaOVqxJJPVi3XhCWjZrcr+0k8ungsVxi48D2htlCiDYEJeb4DOICvsyqG1R
         TNtTYnozGHmypr0Yc6G0f2YYX6RyJ9XMET10jdj5/rUjSflx8fO4Jx7EwXgRsbDA03gf
         yY+XuMQ+GfP69QSTpluOXHhcdBlSfL/mqulz36exIMvyjhVW6InAfWUnAh9q0xbUtvZr
         FvfA==
X-Gm-Message-State: AOAM531Xdl3JHLom6L/UUlh4EM748tVRKEB4ZU2MGYHpqqOV9Z0Fkdcm
        Xfnap+UxfC+IKGdCSvRJzYqPo328YxcDFVm9Ing=
X-Google-Smtp-Source: ABdhPJxVJYth293hHFdkje+2jbyAyaCrgKxePGSUW56lTqHGsa9dLBxsub0uT5q/eaW2ohtUZrU66g==
X-Received: by 2002:a17:903:124a:b0:143:a627:a992 with SMTP id u10-20020a170903124a00b00143a627a992mr20792427plh.32.1637774587212;
        Wed, 24 Nov 2021 09:23:07 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id j15sm327382pfh.35.2021.11.24.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:23:06 -0800 (PST)
Message-ID: <619e74fa.1c69fb81.e4dc8.1144@mx.google.com>
Date:   Wed, 24 Nov 2021 09:23:06 -0800 (PST)
X-Google-Original-Date: Wed, 24 Nov 2021 17:23:05 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/154] 5.10.82-rc1 review
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

On Wed, 24 Nov 2021 12:56:36 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.82-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

