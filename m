Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5554945E179
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhKYUT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350695AbhKYUR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:17:56 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F48FC06174A;
        Thu, 25 Nov 2021 12:11:37 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a18so13965163wrn.6;
        Thu, 25 Nov 2021 12:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hKo9HVgG3YITApnO/pIVYMfF9RSPMJZRTTgQHhBbFfc=;
        b=OvbLX067aXc8SoYOLUDq/EdqJxxaYK48d6peFfqvp2DAcmjzWWYAVV6m5CrS/ZTysv
         /Q4YNlUxv5zqb7w+0Q8X0lH6et6gOOCMn3y64Hrgc48ZrIXrlOaxKeCnLqe1bSev5uhn
         1B7k/vPc8Zo9MqUjhjSlAONiOgRaYn7PG/x+HR6jfMLskfq0RbMb4qq0Yd9YO0HL7qbK
         KrUyiuLN0U9hUujU/qVlumz1VI1ucajErBkorIaBnkDgKHss5Ax3gQrBNLpcJK00p/gP
         qw5lmtesvG6sb8ATjGw6+63j9CrMi5I6+DcU/V19+uTzaR8UXl8HlaOb+/G/NyI5Q1jV
         gCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hKo9HVgG3YITApnO/pIVYMfF9RSPMJZRTTgQHhBbFfc=;
        b=fTEl/49WlEdYYiqclRfQV63t9u/lDDbjksD/rA/+Ox1jqCvtbuEHWdE50lFjUyHnp8
         DRtvE8Ji/hGijL2FRwzDoe+KZ2L40lPUTm8vvFDUniGHqelftu8uFLFBnhni1qJlSvpr
         TDOy924UirJ8GmFIOZ9OcBd5FWbt2KnhvuEIcDa+rE2TaQr6Y8S4vlwDwQQQc7GPgDgq
         iby6ZzGIMtLRttTR9tY7cDKejQyk0XM9Lk+OWAjS3UXGtpuhbc38a/N+JmHepZ8bkQAu
         qgfzwxDnkyDEUiIHQqF7zBvkREzFiP6XJg0avBq69++ncOLAgcMuDgyc8VjHol6AO6Ue
         BnkA==
X-Gm-Message-State: AOAM531bBpS7SvRTwq9Vtbqca6GilGanmR9weuCyMYxjJYMJ2nIqppQc
        ttB83HEizkqXpv5hVWRUYjI=
X-Google-Smtp-Source: ABdhPJzGEfVOp80JtpOVP+efnC/MgaAhJveM96XmiU0B0eS8alBYWxNJrStATW3om/bwMyHyMmyKJQ==
X-Received: by 2002:a5d:64ce:: with SMTP id f14mr7726246wri.165.1637871095752;
        Thu, 25 Nov 2021 12:11:35 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id k8sm3519286wrn.91.2021.11.25.12.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:11:35 -0800 (PST)
Date:   Thu, 25 Nov 2021 20:11:33 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
Message-ID: <YZ/t9a43d81TJLPI@debian>
References: <20211125092028.153766171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 25, 2021 at 10:23:51AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 65 configs -> no new failure
arm (gcc version 11.2.1 20211112): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/429


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
