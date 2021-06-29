Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DA13B77AB
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhF2SUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhF2SUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:20:49 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DADBC061760;
        Tue, 29 Jun 2021 11:18:22 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v5-20020a0568301bc5b029045c06b14f83so23582051ota.13;
        Tue, 29 Jun 2021 11:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kaLVJ3vsSWdDt4zOlxzNdOMsK05VagVjFIGPvknhz0s=;
        b=cKjKf6L6XxfwZo2d0eFq4O+KvMmcJL+R1s8vSRd99cgzA0S/A1zc2Srt6p6OXv8laW
         lD1kSH0a2YQ7YIl5X0/YFc5MH99773tLzGRdXXLf2M4KmvoT8Bz3aGamO79vo2Y4W8lf
         JuDoKvh8h6ZiQYwjXJjx8OMojJzkz3cDD4y9WKJZX8eVb/V7OE/rz/i8bWBbltAzKiRk
         IiiLeJN2VSZArmnZMUfXyeoDfQtKQ8WFUMI49ZjoZ2gCsAvb6cE/j0Uuf2rc3FtCdua3
         8idKOmZAAIdQP4xYBx2ibLP46Jrld3fJ3TPBGqBTV9MBJPdcjcwJ6JvIILm4GN4NlS8K
         n/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kaLVJ3vsSWdDt4zOlxzNdOMsK05VagVjFIGPvknhz0s=;
        b=H+xiKOM/r59tEoy96Pss1BEKdb0z3IZ7j/FBLl7AEqecVlzIx5mnKPe4hMbrWGuxIz
         lGRK0geAD8J8xfhPwX+zElFVN83qmDzl11B3995YKqsVWaM1daprCOLwzXO0rYcb12ya
         aMjLmZzK1u2GtWlPVFTakQavNsLpYy9qqQwChz7at8MLtqAiyiA0MpP0QRdasHTYkOt5
         rbzNZX6EMooe5Ae0KsD6EBT91loj5xJNwsNE5gjIj97Fzi0PVOmTnbJAOqQg8Gi2VeNJ
         3vanEQQ5po6Hob3veQG1DFo6I+iE8PrDmIPNOEZ6LUWCVMYhtXk386Hj1XbQGZga78mP
         8Pbw==
X-Gm-Message-State: AOAM532EAfwIQGdXoUllCPSNkLOWEMXmJpdib1Xw3NnQawhCGd0urS9c
        Ldn2ZfSWQeoE5VZgmvh2j60=
X-Google-Smtp-Source: ABdhPJxA5Q63ZkUSQnJTp8ot/u5Hh42xkiwBKXPPfn0biZwKbf1RKxwJdtqPdPnjwgDtzG8IU4Xkqg==
X-Received: by 2002:a9d:dc1:: with SMTP id 59mr5506047ots.246.1624990701649;
        Tue, 29 Jun 2021 11:18:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5sm3867930oot.29.2021.06.29.11.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:18:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:18:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
Message-ID: <20210629181818.GA2842065@roeck-us.net>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:41:59AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:42:54 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 153 fail: 7
Failed builds:
	arc:tb10x_defconfig
	arcv2:defconfig
	arcv2:allnoconfig
	arcv2:tinyconfig
	arcv2:axs103_defconfig
	arcv2:nsim_hs_smp_defconfig
	arcv2:vdk_hs38_smp_defconfig
Qemu test results:
	total: 326 pass: 326 fail: 0

Build failures as already reported.

Guenter
