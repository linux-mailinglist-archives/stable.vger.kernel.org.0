Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99D4446399
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 13:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhKEMr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 08:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbhKEMrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 08:47:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E124C0797BF;
        Fri,  5 Nov 2021 05:44:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d3so13525380wrh.8;
        Fri, 05 Nov 2021 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ov+BxwdT8/vOIeXNO77zZ4Lufx6Fc2gc3wx/Nct0Kag=;
        b=J26V9bbRRcTUYgarq4RdcrRI9x2Nw9locPH1W7NNrEOZTNj/CWO4VfspMbv6pQ2zUI
         ErSOu6zkifsEWfGAQXGkCZHb7TVrpGmDuPfs5dv6qKwEz0z/8iPlA+XaF9cZaYJTfbnM
         AJosl+dzA5ZYsPy+MFm68UzinkpGkYRVwsJZTG18QRbekB49/W4EXE8s+tQ/lF6wuhIb
         HneEs5pgk3lnrKXDgr2jGFwGsV0mS8OSHARhzI1YEBZ/IO+bN6Gcm6kWhAL8dL4vDeXr
         MqfuGGOvI7orub5zg5wgb1ID0kY9bLJ5Uhv+jEblr3zjJDXsBftuLxHYQIPwua2AAZqP
         Kurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ov+BxwdT8/vOIeXNO77zZ4Lufx6Fc2gc3wx/Nct0Kag=;
        b=5UBAFFtkc95StkJiaGxvT5htZSbQ5ielighlb5Mprn0Fyu7SSM1S3J2sNYgUeLUmr/
         5TmxNrhL7pVtcFhBNt9XFlTtnUr1gjJu2DvTdM27hCp7lwkfd3TQZc73KrRaZWo1rUIf
         KRHlT8r8pXAuFywg4g2ml2UcEcMn+baSUdbSFrjKyu+TwK2T0e++4zVDWDG6hXrrKqWX
         3MDPxifPpm9Pntr+/kCuiAEN8n+f51LTrTkwE/cblLYlMC1pO7sKP4m+w+lDMpF7m5fz
         Q/NypHHYPXdwPUkIniAWbuHyIMaMhl64VubCLBoL7rYW3BzCk2Ol97P0jdVUp0CutFMu
         k55g==
X-Gm-Message-State: AOAM533eIHzQG/LHNj/ijywVvNho+qafiNf5hnsZXgPHs3oRwiIjVy6H
        5FPPNEhZnRK8xieDIJLlApA=
X-Google-Smtp-Source: ABdhPJy7hkqcqbzK5+Vw3XEZDDrflH3TJF8y0q4tCzmqacZZ84AyxASYS4Hv9+vyJzS/L6h+innhRg==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr30879808wrm.280.1636116270879;
        Fri, 05 Nov 2021 05:44:30 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id 6sm7696258wma.48.2021.11.05.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:44:30 -0700 (PDT)
Date:   Fri, 5 Nov 2021 12:44:28 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
Message-ID: <YYUnLMlbjfp0PvY7@debian>
References: <20211104170112.899181800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 04, 2021 at 06:01:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211104): 63 configs -> no new failure
arm (gcc version 11.2.1 20211104): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/344
[2]. https://openqa.qa.codethink.co.uk/tests/341


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
