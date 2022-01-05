Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869BD485807
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbiAESPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 13:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242792AbiAESPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 13:15:17 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7C0C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 10:15:16 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id l15so208597pls.7
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 10:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1dZCF8W0sgi/NYKKPCum4a1GBwgmZojpRmdK8UlCwHA=;
        b=bZCgK7ZVnOlRZoVul9+2QVUo9qPPMqnGMGH/KK4UUOLFgA43P1f9BKM1oIz3WYMacs
         /llFgaZhbx0nOx/tDjXQlDEfTDYXV1OTy+dTxUXyAzgfPReyJNdR6T4KJ5MB1IsOkvhd
         VkvMY/5bMKxd8D6unFyYpb9QeZ2wX7dSHL8Day1lkgndAYqbu5GoVJHz/R7s/o/HDA8a
         FyE+ttd88g1q3oXrQBEiP8IzJo7hsAUVVLJj6sqfu5kaIQMW+wjI/x4UUiIwJxgYoKI3
         Oym89ryDTYQioz4mewrbqmijurGNaDYj0tSOUkbfJTu78Vyhzjy7H517M5iYeJbPosHr
         16Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1dZCF8W0sgi/NYKKPCum4a1GBwgmZojpRmdK8UlCwHA=;
        b=muAAD9VIXyPUOBRGuodarDIh8+VFSqWW/3tUjaIGCT1lxRCuXSdXsAl0PaZOJdRxaY
         7RAP+A0/LXsmj0CB1YAcnzH6ZCtZkxGh/zWZHLi5jaSFY7gXnOAkvq6hHR58GCmrIzAm
         tWBx6n+YRsS30GtA77+jwDx7Bm40LxJDtBZVrJgLeFVyFLp14LWZfEmzI3o39qKMyDVJ
         o38PzM09iTDHWt8WL231EqIWA9JxbOg/7t/x+u0D3xbvZMmF03dQfbvPNv/963fDfvj7
         0MKReveePEn4UhUfZbiFnlSXFinl4wXxBoZZHsjHK6WBW4spUmD2v0haPEm4X1EsvCqi
         Kz9A==
X-Gm-Message-State: AOAM532Qn94b2GYwD90iWXGm+PSmFsJTF/6zSdlt/Oue3fy/cPc7lt+C
        Vm0PO16OLNhsFcQVS6gRnnv5Uw==
X-Google-Smtp-Source: ABdhPJwzMlHdd6/779thMkHF1YznalbdxyhAOWTirI//SUlpuAVIEAddDmIGcjOXV0Ng/1/iA1JS3w==
X-Received: by 2002:a17:90b:3808:: with SMTP id mq8mr5490839pjb.85.1641406516439;
        Wed, 05 Jan 2022 10:15:16 -0800 (PST)
Received: from [192.168.1.32] ([122.164.22.119])
        by smtp.gmail.com with ESMTPSA id k18sm45105753pfu.76.2022.01.05.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 10:15:15 -0800 (PST)
Message-ID: <b57a54adb349f21888db2efec2e6a6a342044d7e.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Date:   Wed, 05 Jan 2022 23:45:11 +0530
In-Reply-To: <YdWxh/OR0dQDeS9E@kroah.com>
References: <20220104073845.629257314@linuxfoundation.org>
         <54461ffb9ebe34e673e6730f3e9cc94218ad2f49.camel@rajagiritech.edu.in>
         <YdWxh/OR0dQDeS9E@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-01-05 at 15:56 +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 05, 2022 at 06:32:43PM +0530, Jeffrin Jose T wrote:
> > On Tue, 2022-01-04 at 08:41 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.13
> > > release.
> > > There are 72 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >         
> > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linu
> > > x-
> > > stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> >  hello,
> > 
> > There was a compilation error....
> > 
> > -----------x--------------x------------------x--
> > MODPOST vmlinux.symvers
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> > BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
> > Failed to generate BTF for vmlinux
> > Try to disable CONFIG_DEBUG_INFO_BTF
> > make: *** [Makefile:1183: vmlinux] Error 1
> 
> Is this a regression?  If so, what commit caused this?
> 
> > i did CONFIG_DEBUG_INFO_BTF=n  in .config and then compilation was
> > success.
> 
> Or you can install pahole, right?  That's a requirement for that
> build
> option I think.
> 
i installed pahole  which is in package "dwarves"  in debian after  
reading yours and shuah's  message

i agree with shuah's  answer. 
thanks shuah

-- 
software engineer
rajagiri school of engineering and technology - autonomous
