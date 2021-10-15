Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491DA42F545
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 16:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhJOOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 10:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbhJOOcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 10:32:50 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B11C061570;
        Fri, 15 Oct 2021 07:30:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r18so26910784wrg.6;
        Fri, 15 Oct 2021 07:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7fVT7stQhu0R8qSUSTnVnpkVgBpLQLK/TJbcFLc3ifQ=;
        b=JGZA+0FKchyq2x32m7mZOe4wbqIBXqozJaGK2NkbwOXyHpcwdC6Tm/idafoO11cf/9
         NfjBIvY1NJhRNJ2zv9WvJx0tVN4b7baj4lLuRz8GbhqPKHKfqJ5ox4bYAENnLMY/0HBL
         a2LpgPs+5ZmpgNhpM9S5vrxOENUKIIXs4hluLp0sR9BdsM9tANHYSD+XP0htvEjNlZ1m
         f7KF+ozRTAI8GjaNJ6btEknU+A+oH19s02Uq0UNwIxp0H/jFLGy0i+xhhQiz4tlZvLVy
         4ENhBVV95gNxMTiGtit5yDBVNDH0/+YNnHWKwBQHU+CwIl/JJcli+TvA4edAHcMsFpW7
         tn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7fVT7stQhu0R8qSUSTnVnpkVgBpLQLK/TJbcFLc3ifQ=;
        b=2QwT6SUDdab3sRsBk9ky8989+tRnjGwgiBGJw+oUqMDVTyuel+MLgN9kV4be2K/Bj1
         uEIexWc/X7uLTTPn7zs/VLN6lTOPUQU1Kx81uhs32vvORdJj1pY4mvcoLiPy/FiTnF7l
         9BB49ewL3wgBI7Ftqu9wAqRA9jkv+cwRV3pjOhncPW2ecme02mnpNkDyIUrqd6vjqP0+
         5JPnoZyQYLD4RXShFtA2YTbCQdxg5r4xtyVz1AZJxUicBiZ8nSwKx3MN6v31BwXHUBLC
         KZyqBDd+tem8Fyg4zsIIpNr8tRLbW6XkjJXhlOX5BCbZ763+/lSzhSxga70dWkidl47c
         cuww==
X-Gm-Message-State: AOAM531ZzoGF5kQunGbE1Ps2hrcmXr6pFx+0zkOI+JSMDAa9YJd4bRDD
        DEc19xR8xcUU+jWc3xpzEvY=
X-Google-Smtp-Source: ABdhPJwRZyxFqQeOEblm8UleIe4+gVt51nAH63aF5YpfAvzPeenGQ0qWffqP5em13d/K97yyKcjnLw==
X-Received: by 2002:adf:f309:: with SMTP id i9mr15045556wro.256.1634308241858;
        Fri, 15 Oct 2021 07:30:41 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l17sm5018319wrx.24.2021.10.15.07.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:30:41 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:30:39 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/22] 5.10.74-rc1 review
Message-ID: <YWmQj2NE6o/TVNfl@debian>
References: <20211014145207.979449962@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 14, 2021 at 04:54:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no new failure
arm (gcc version 11.2.1 20211012): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/268
[2]. https://openqa.qa.codethink.co.uk/tests/269


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

