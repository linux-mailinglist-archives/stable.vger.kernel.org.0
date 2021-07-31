Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303A03DC49A
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGaHvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhGaHvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 03:51:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA0DC06175F;
        Sat, 31 Jul 2021 00:51:32 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k1so13774628plt.12;
        Sat, 31 Jul 2021 00:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ICg7XziMcUYzjn1qRXDJ14WuqLuOzl3YM5j40dQBDlw=;
        b=EIHM+GAcsV8TM1RJ4o8DVuPQuYkFo00AhWxIxFLIhy0a1c3z54nkn3msX5ZsbMBQTR
         s+YndkkL74kzROEichM9TWYRRpKso6+JrsfT3+al573f7ethxmVm4DUzK2MgCG1fdlRP
         tbwfDDDWJALiNnTwF1baqRYDKMI7pzRfr1wXmXaXp3ytF6IhN/CyRpnho8XIkmEkpubF
         xDv0V/YK1UAZlclAFI7mtlvgVSaYQvAsv2UUR0I7H2WdwKj3A+oul3+N4K1qZWUSmtpj
         fNaRkFe94uySYsC573z1tPC3qEBObPWwypqEuTHN5BywMhOPwb1pLDXCc/Vkmltyl9/L
         rwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ICg7XziMcUYzjn1qRXDJ14WuqLuOzl3YM5j40dQBDlw=;
        b=bRYsQJBtGC6LlnqxIGVXiaVAYi7y1lv3CukJLB6bDm5f6RPt9wvCxPxR4jp1BSehDb
         TkeZ5YTzhip5xozoMs9wQ050uHDAZ7a0Cg3kfEa2LQIQZQgjMRQXDi+BazSIesMVua7a
         LqnOqa6nprWBqLVFB0VYKZ04Y1m+WwPZ/nXetn/uTWidJU1LeGxabp85RIXnPn2zL3TQ
         Nim6wsaMjwVv4/PgjkK0mmU5nQUul6yJ1MPLcWUncLQEjafyouw+qBqZeFo9c20h4rTS
         TTsM4Gk4rxFrgOTWE+q9/lnnMZLpjvmIQinn2Cywq+7SwzNoFmOeCtOgzGZL82IT7TKk
         NXcw==
X-Gm-Message-State: AOAM533uOXTXDW2DF9F642q4wJ0Mck3hsui/ZgLgTQPAhIhhj3obRkpj
        G5bN7o3VxnYTNV/HiQxhgYjpNnMYDFlvO1hB2jo=
X-Google-Smtp-Source: ABdhPJxXfaac4MuBtORdnHVamlNwhdM1sCUXS352jdFyt4BpSCVEgMsfqKgorkAweS+wI9nC7Gr6VA==
X-Received: by 2002:a17:90a:5588:: with SMTP id c8mr7306990pji.36.1627717891203;
        Sat, 31 Jul 2021 00:51:31 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id i25sm4714400pfo.20.2021.07.31.00.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 00:51:30 -0700 (PDT)
Message-ID: <61050102.1c69fb81.d0073.d7ea@mx.google.com>
Date:   Sat, 31 Jul 2021 00:51:30 -0700 (PDT)
X-Google-Original-Date: Sat, 31 Jul 2021 07:51:24 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/24] 5.10.55-rc1 review
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

On Thu, 29 Jul 2021 15:54:20 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.55-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

