Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A803E2F96
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhHFS7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbhHFS7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:59:30 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E0C0613CF;
        Fri,  6 Aug 2021 11:59:14 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id w197so9655533qkb.1;
        Fri, 06 Aug 2021 11:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JM6Fh95jrhfSrO79S2w8KkDE55k0g+qNzP4OJ3KXtsk=;
        b=QUcwmFUzTsYU4mODFUPvsL0DqhKcgYYggP9Sj6EFwyqfwP7PsMpmhKW0lzmhGmpVf6
         qWRMo3STozKZdqjhLN1GAPumMskLnd3dSJ9cu8Fgk3MHr/c0tiH8tIxhvbn5DfgfRGRf
         YytzZREK/9hO9qc6WX4975xEd6/ps2R112ivA2SXITxSk828F3+Kxf7YKI7AsqMYsIeJ
         HvMvPF+EaB1yS9nrcMOHFDQehFjcImoQaTG2phySxmg9MMjGzaV4rlCS8LKeYQsrBwlM
         F+bMtUHZDV3l1M0rhx4vbRLFI6jfDcnLlhctetqCJuVsL5Uu/FsQ/ixUjiEtAb8Ygz0s
         8mgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JM6Fh95jrhfSrO79S2w8KkDE55k0g+qNzP4OJ3KXtsk=;
        b=gQtNjYCG6HT0OgY1DPkHh55T+TB7vUHa/ZMJoom+xrhSTmYLfxDPj1N8KYH+J+4ZTB
         envijFBlq/5GDq9uebMB86yclfY9vnYLMyyxAHJTRIwkOgfYJFWqlcvU0wqnd/tj/G1S
         7YsVzVaBfycbIC99ybWDJcybGoregc8D/VjskP2GbHXwz4ibtxL2fRpjq2iu0hcghbYr
         4eA959UhjSI2YUAsvuSXCAQHN8NoOpFeOsr2/BoD0I5VI7e9+W3xl6fYaijn79eEy987
         Iq1k8NuQrVAwvWrYydTUEyOpQT/270cEMv/FxpkEeJ/FqPC/Z31LvoqvBeX08OUqCV+n
         afSA==
X-Gm-Message-State: AOAM533hv5zPt/2P/JVHhLg/NvT7MUvRQZgnuh80ajaa6/skbZVlVBdR
        d74HuHCqwVyhpo+5v08XaIA=
X-Google-Smtp-Source: ABdhPJyDoftPm8wiJAPZJpqMYqzmDRsNU3e2qXhvF9VkDb6HSEIeCGTq7vKRsuzqxHz1IFIOJEN2pw==
X-Received: by 2002:a05:620a:1505:: with SMTP id i5mr11563998qkk.395.1628276353590;
        Fri, 06 Aug 2021 11:59:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w185sm5156901qkd.30.2021.08.06.11.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:59:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:59:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
Message-ID: <20210806185911.GF2680592@roeck-us.net>
References: <20210806081113.126861800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:16:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 473 pass: 473 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
