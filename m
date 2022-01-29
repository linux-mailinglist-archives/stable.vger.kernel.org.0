Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9678E4A2AE2
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbiA2BKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiA2BKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:10:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD132C061714;
        Fri, 28 Jan 2022 17:10:44 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id j10so6735779pgc.6;
        Fri, 28 Jan 2022 17:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=iskxve2GJoOPlpLkE7JwxkMKKyjsGwBxLICh76iTzgI=;
        b=XND3H8+4u8ndtnrtTz+gj9HTk6MCehfjRf+C1tsECZIpYE7eWgLeIOkEPkdpY+V0+x
         7Cko916Tb2KeWN5Zj1WL6yaW7xF+WaZNmcTirqc13sP5/yH3Y1Hli2w05jnbOEvVcpFw
         meWuDP8p52WZxQ8+GRpxOcJ2Mw68UrpOh7Eg7FmDpCN9aoREKEGRW3BUhADzgZOYEj7V
         ETX9NuQN5AqefpIsUA/5maz6t4lR6Yq8YB66scemaZesWRHfygVJVHzVevORFSVQ5yVG
         Txwa52eDrB+1V9eS81jo/p7DeEWCOmYmnkj4+6zuK6MVPbKAY6+gc21n1ESk9KCsVm4X
         f8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=iskxve2GJoOPlpLkE7JwxkMKKyjsGwBxLICh76iTzgI=;
        b=RwP15OX7E9xMGbgS3ZYLydEAO8HW8IDXr73B+gnabiWIXr7fa6WHtHYm6uHwpzaQLt
         DNj2NJqgU2N++C6dVi12WBae8eU25QJ7L6EyuTG0jVkRG/wxPe+jjso9uNyFPTExyd3P
         1oKHkoEoj6k7yosaBNl+7dol7dQbilwrfFLzq4g3VwdwglaVwnvEh21r/fATFyGgTqH0
         a30HMtILYXXgiIykkhAyFD9vu2xs75PIwVxUkINYHo5iQH5gQq1nhA0xgBsmUjiidPIC
         snF3CMdwHzqJrqykHPFt+ZU0ZfViJXSC7RIsIFWJH58fF54WUHezgrullqkjShus52gA
         Jdfg==
X-Gm-Message-State: AOAM533VHv4iNSeYxfbxbdec22BILv66ST5jbprxSyAKr80luJIhh8iI
        LfcDK6nxeMk3e72LaMedTYXNh7HDSgC4P8GStM8=
X-Google-Smtp-Source: ABdhPJyHSQlLS+PJ9zUKhTpkkq07S29lUCSnNruTy8E3v3GSKZsPrgb6nK8MhfCC3Myj4eRC/2eajA==
X-Received: by 2002:a05:6a00:15c6:: with SMTP id o6mr10366778pfu.9.1643418643656;
        Fri, 28 Jan 2022 17:10:43 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id t9sm3361858pjg.44.2022.01.28.17.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:10:43 -0800 (PST)
Message-ID: <61f49413.1c69fb81.1bcb.a324@mx.google.com>
Date:   Fri, 28 Jan 2022 17:10:43 -0800 (PST)
X-Google-Original-Date: Sat, 29 Jan 2022 01:10:41 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/12] 5.15.18-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:24 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.18-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

