Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3153B69E2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 22:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhF1Uvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 16:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbhF1Uvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 16:51:47 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AC0C061574;
        Mon, 28 Jun 2021 13:49:20 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ce18-20020a17090aff12b0290170a3e3eb07so927098pjb.1;
        Mon, 28 Jun 2021 13:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=lqkOOcUqPzL8L0z0rLXWxFuKtRqr5QR5M4tO5Zdecc8=;
        b=ShON8Uho6/mw70Lyr9Bs8I0FP9epOG2d5N2CHSGElBOEjUMDXe9X8bAd2hhPzdMXxc
         xve/1EisshGFCKt95iuLdDrQWD0ODnjmwpxqNx27phJFLltBzd7ljeswakQtrxjdbxCw
         fxNuY8O/cJ/9P07Iltrp7sjct25lkYlSNOPRofyu76Kx/fe23Eni5vTnTZQNC1BUBVBg
         46a6/vzp0F0qPbmJX8m1TYFkG6zO4NH88mErFb1nUYBJ+fiLsSzuZcwKHt23luKt3tZU
         LU9gOY7iBMpO01c2v0gqekJ2FzClH/pDqmwkBUBgPsrmQ2rV/anZE2gVUl0Dy9IZghQO
         fWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=lqkOOcUqPzL8L0z0rLXWxFuKtRqr5QR5M4tO5Zdecc8=;
        b=NQ8e+otzJrVleNXRxOtKC18O0xVpUl14aEQVlJz+fRKvVYwF+yZdO3m2tVKbp9hy+y
         qRKhYzkuU6aqstk+s5zxUD7s/Z7TYkr2XoBqKse5QiDkmK/zJgyMahX25+sfdME/KKqo
         K5+HlQY6GCB/F+eHqhzqAVCMJ07M7/Lfkp1AhHSVcQpGfDOuYo50z32kO/g+Wd2p78y5
         um5Vqowp9K9RJQzIMRlQ+1g5lVtr1ZrYwr5FZnAsjL51qUXiTzD9VkLFYCNlTHJxOld4
         DnrvAlBFKjcLKeJ3esFzwFHMrMGzhasGdQLxfkKuWRWLiFWLtnsp+bHJXbs8ygYq40o0
         BAwg==
X-Gm-Message-State: AOAM5304ejbLijwfqdRGmz7B/FROBSb1ugbh+ZKwoJzL9MKcn0HCC5IR
        3jT79jfDz3KWTDF39NMyfeq8Nv3rQZvKRfzOL80=
X-Google-Smtp-Source: ABdhPJzM9/o0w5MFhzryl20O+V4Q2OjcEkCV0Z+8utm9EbnlbirhabLo8/L11Rjb7/O6CVhFYEKbHw==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr24804705plp.20.1624913359480;
        Mon, 28 Jun 2021 13:49:19 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id b10sm14212177pfi.122.2021.06.28.13.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 13:49:18 -0700 (PDT)
Message-ID: <60da35ce.1c69fb81.d29ec.b013@mx.google.com>
Date:   Mon, 28 Jun 2021 13:49:18 -0700 (PDT)
X-Google-Original-Date: Mon, 28 Jun 2021 20:49:12 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
Subject: RE: [PATCH 5.10 000/101] 5.10.47-rc1 review
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 10:24:26 -0400, Sasha Levin <sashal@kernel.org> wrote:
> 
> This is the start of the stable review cycle for the 5.10.47 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.46
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

5.10.47-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

