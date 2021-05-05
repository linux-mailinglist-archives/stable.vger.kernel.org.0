Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220B373E69
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 17:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhEEPXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEEPXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 11:23:34 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7EAC061574;
        Wed,  5 May 2021 08:22:37 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k25so1987520iob.6;
        Wed, 05 May 2021 08:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=GvGjpD90B2dlGyrkqPDfUen+ArnkTHqSjG6plck5ZEs=;
        b=goa58lhFKSvSK/PUjbNJHXtCjRW7vdvpIJg32/t4u6ci7Z8zFVyVvZJ4HQKYc71c7/
         68FAYmQgYxIjtBtPk63ke1tg4bDnaAaVUGjtmn0FFM5p62rBosOVZOz48eKZFNqVqzbR
         glDFnHR1LFid3OleOL4wrE6Epqo7sdci4mxjBSVJGgG4+rfgOFqaVF4HOMCzBaiqUhk8
         pHWl4It1Af05+1bNHiMz6VD6I3USl6/6QjGdtqfRX8Xklnudklh4aSYv1Mo/4uW/flNW
         wH1Cvat637Fbvx5EYnyKkFvZqLYG0TJoMuGR7PEZdM4zw9K8+/06s1IyXtzhltN5LxNH
         364g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=GvGjpD90B2dlGyrkqPDfUen+ArnkTHqSjG6plck5ZEs=;
        b=YF/E0N3QMPLxN515dTm8xM08wezJipIqUER736/YrhNVt1OAen+VoCZSfNSsmc0XfW
         /eopJJtju5GQOhaiK6dMbNrKo/t+S+P29Q5TE4Ekg6JgLLzixW2+Pm6e/DIhER+3cbW6
         4QqMKXMiQ85IM7qvdRQrIEONE2dBfmQPfV7uX7iqQeAuVnbC/vMfwoPDnfQ6dHiDV/E/
         oeQ1cdtOALCzNjHkirF9l9GpNk83mr7Cxmr9aCsZ6oyGKHd5P9/krkzo2NqVRwuQZ9z6
         eNGdDNtu7EcAE3B+r3vW0e051uhl9Fq/cFA+ddeokwcZOua8FNT25AtXVuXvYWvECXwy
         H3Hg==
X-Gm-Message-State: AOAM5328LVx7Vl3gK9ibESfO0LYmCxxUJEWEtv0Q1mQlAgf90GqIXoia
        CQMq3yuiMO12cdJBSv42oY0eHnIm/ifKhgpb4T0=
X-Google-Smtp-Source: ABdhPJzekqf2aGEMlYuuglDhl1pX1W4Fc1MReTwZfsgmisBqL+CtcTzVcFrbnhNHVGvL3/ZizyHYpg==
X-Received: by 2002:a05:6602:2003:: with SMTP id y3mr15414458iod.62.1620228156411;
        Wed, 05 May 2021 08:22:36 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h14sm3739993ils.13.2021.05.05.08.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 08:22:35 -0700 (PDT)
Message-ID: <6092b83b.1c69fb81.fd46d.d4fd@mx.google.com>
Date:   Wed, 05 May 2021 08:22:35 -0700 (PDT)
X-Google-Original-Date: Wed, 05 May 2021 15:22:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
Subject: RE: [PATCH 5.11 00/31] 5.11.19-rc1 review
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

On Wed,  5 May 2021 14:05:49 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.19 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.19-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

