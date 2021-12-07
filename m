Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B846B2E2
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 07:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhLGG3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 01:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbhLGG3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 01:29:37 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C959C061746;
        Mon,  6 Dec 2021 22:26:08 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 133so12802172pgc.12;
        Mon, 06 Dec 2021 22:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=o0m56NLmcmWPOff6hp+BjYLZvUDHc7oRux1lK9/M35U=;
        b=XnS7RRKBhoDK65BGl1iVc+IsVNck13y++E8PPKTH23Lgd+oRzZBZUuNQWUbQAEHOq6
         ceM79B5uzCVekLwGgB104KjGjo4xpm+AuSpLkDrvxFI9VObwqdvW1s7F9p4eXrhW77fi
         qVMm6QfjNwaX9YBj73smvVSSbHZPRR8gqiQyQfgghukPVVHvzhTDJ1j6zLL6m5wmTgn8
         uA3Bp1guBe0csEDbOQPqyNcE0WE5oO1GcFr/Bh0b7lnkZXm7dfYULVRPCK/pGAGtR2XI
         u1KEfzAUjX04WaFe3xc6JPBI4ic1WHc/4tx5fLTXwya51Wpm9YLgYDq3gvN+rM4ExXAD
         aI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=o0m56NLmcmWPOff6hp+BjYLZvUDHc7oRux1lK9/M35U=;
        b=TD5dLrvowkOFJiAEpH0cQ4a2wU1lAsks+UPW8JQ8RvXaNwvbXmRU4JmidXpXRR5doT
         D0UKnows+rkyNyqhikjbdJlMBXSS9dd0NeKoek9OtRVjcUoXPqQlGIBkzVzeAD2/pSNb
         smtsvkCZIO7kDnn/58MPJNapSDUR0mvMH9DP+bXz5IyCAAJFDhVfIUmHfq7f0UaFXkBM
         JbGA6ysD2VdzrDoiXgq5J2LPHstKScEsAC96lqrJNbha/rVLFRgT68Bu3onkIH7v4eP2
         RqWkuzrhN9+jL5MOXXf3acb70X3LYcEqeJgtvwT7uP474ZvoIIBG3iBG1ljvf+/a2IaA
         N1tQ==
X-Gm-Message-State: AOAM5337TgdhVHrC1VjB4AHREO/G7D0H4Ak+b1cI5azf/m8ed18UtJKz
        u4/6bIXxTCfpzYpn5P6aY4Ypmes66UZGaCSjaTs=
X-Google-Smtp-Source: ABdhPJzaYZpoqyXkq45KC1R694yzvyYDMfL2QTbz5ochNJYloW5TEG+YWMlAJQ2uPLdhi0aj92nR1g==
X-Received: by 2002:a05:6a00:2311:b0:431:c19f:2a93 with SMTP id h17-20020a056a00231100b00431c19f2a93mr41897638pfh.11.1638858367104;
        Mon, 06 Dec 2021 22:26:07 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id m15sm9319541pgd.44.2021.12.06.22.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 22:26:06 -0800 (PST)
Message-ID: <61aefe7e.1c69fb81.9d1c8.b27d@mx.google.com>
Date:   Mon, 06 Dec 2021 22:26:06 -0800 (PST)
X-Google-Original-Date: Tue, 07 Dec 2021 06:26:00 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/130] 5.10.84-rc1 review
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

On Mon,  6 Dec 2021 15:55:17 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.84 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.84-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

