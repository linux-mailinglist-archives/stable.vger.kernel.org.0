Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD5A394265
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 14:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhE1MQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 08:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbhE1MQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 08:16:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07F4C061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 05:15:12 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 69so1546928plc.5
        for <stable@vger.kernel.org>; Fri, 28 May 2021 05:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7A2wb+GJtAcwJVhvUxTTGI+RPfXeOHTxXrDmiJRyIfg=;
        b=bI09wOqTzyiKSNYGvKhJkhj8N97H/RJzy42xrvR/np/CCEYHvflOOHDI0IMEyTQ2Ee
         RMQstwlyHsmvu4/OEksu8xUeJqgposcWOcb+QpwLZsOM6QTgSGiXgsGkO2bxJj2AMypi
         5URoUQlX+kykRQbKyW3tRGxqQOQZgASW+O8cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7A2wb+GJtAcwJVhvUxTTGI+RPfXeOHTxXrDmiJRyIfg=;
        b=MEDzVU5SFLQtxAQ86MuRrc6lWbt8Rx3unnZP1Sv6m8ZhkWVQD39CR3f5nDB2N5x5Ad
         l2fzk8uYOBw9y1li3dzyX5DSyoZKIPtpk5SCwfKjCdcSmwfZJEU9lMydqh4yvbIoycMG
         Kdav3ClEJ5EuU0WfPG5YfcaJq8XGYlDUyYygy8Lez0l9ox8aSkbZZctEXB2PgeIbz+gA
         X4oJSE3ejfGlULnBl2CdSMDls591G8a/ES5TxT8tVE2h7j5CcNG2KpbBUrwYi5RvIIlb
         U4tJqhGdR0NyTV8kEQVnjhLOcopLK2MB9osxtJDZ4+tA9JGDynGM1tQtSq+sE+ApF6B6
         XXBw==
X-Gm-Message-State: AOAM533UpNVvQ16xyw8XeVYsez+/DasjQmqa6YJQ0c+tZ7YuGTKsGGaW
        F1+BZPo7l9mqg5lWu8jmCZtFPQ==
X-Google-Smtp-Source: ABdhPJyotZBvrP2UQ1Quch2hWrs+3Djniga8slIktR33JXVxc8MQ/Rygxugq6o0pxqh39/MqCxwlTQ==
X-Received: by 2002:a17:90a:6c97:: with SMTP id y23mr4209606pjj.174.1622204112187;
        Fri, 28 May 2021 05:15:12 -0700 (PDT)
Received: from c120b2e857b3 ([124.170.34.40])
        by smtp.gmail.com with ESMTPSA id x19sm4417395pfp.153.2021.05.28.05.15.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 May 2021 05:15:11 -0700 (PDT)
Date:   Fri, 28 May 2021 12:15:04 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 0/7] 5.12.8-rc1 review
Message-ID: <20210528121500.GA23@c120b2e857b3>
References: <20210527151139.241267495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 05:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested ok on:
- Tiger Lake x86_64
- Radxa ROCK Pi N10 (rk3399pro)

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
