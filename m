Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFC24A2ADE
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351985AbiA2BHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351969AbiA2BHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:07:03 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C62C061714;
        Fri, 28 Jan 2022 17:07:02 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id x193so15734683oix.0;
        Fri, 28 Jan 2022 17:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXnsmr6s29jhjcr2RoI1fV5Ff8XoIKo5+9/raHRhfGI=;
        b=bRBrNZ+ji32eNvAIm4xmH4pGk6ZBM73EFPCN3V/iD1JUUibbLZFXKqJilH/JWytAU0
         ksjXSntRuELIPh/3qMIgu92ignjbz2dcKsBSzCuRy6/Csh7J8113p9DfyzchluhgcMXU
         7Q+xOM/Ik/x1ZuRJ7tt4YQu4lJWwezFLwhnYWIt4h5MgPepc+BYqHTM0+relitXEbE6u
         wqkbdOOsWrLS1EZOnks+enujom0gzgRGLLXmxVa8zRsZAgMAJmMSjp7b7P+SAkga34DF
         Y9W09n5jMxadjwMh6HX21fSh+IjOlzsRnSnGthjqozVY3o+gO/Vkxl3edwFB1aJaMGw0
         N2tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yXnsmr6s29jhjcr2RoI1fV5Ff8XoIKo5+9/raHRhfGI=;
        b=Wy0iSNaUPgOoEAo5PFyPVzwJg9dctHWVtMOCm/p86baH76QmUckMRmzhFVtaqdFPZq
         CZwGc5qNmTEg9TkO7UDdRL4K3jTNaZ/pweaewkqNPRi7v2GZWgj+e7EDBJlY8mQj6nQ+
         5roycvrpbgave5rAZA+kJOBKhglHxF6McBLifSLyRK6sda2mjMP/GTjDfTx+4netlzjK
         nbaCNjuWt/Wetr8rNtAuWn2ST/HSfOAhghDY9T5+azihI8GNGlvnGftUKqMilOqEoDwe
         gJBWBgimLfexD1+VCrfpStKiT/TSFznMkIgBmpSOOrh+T89oq7O3f1wWj6o+Nv9PrKum
         NiLw==
X-Gm-Message-State: AOAM532OyXUlZUuTyo0oQevvX5y2qCqED0dAbyi/ZOMY6vKQRQrnKR7K
        yesen8p4hTSHkIH/U4Skkao=
X-Google-Smtp-Source: ABdhPJzexhrGYYADBtrB81iFvvHVghAwELWXu7TiR+O0AYzvc/Y9cx6sAMD3RZKIeqvk2su5y2/5Qw==
X-Received: by 2002:a54:4e0f:: with SMTP id a15mr80075oiy.1.1643418422116;
        Fri, 28 Jan 2022 17:07:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s11sm8660702otq.69.2022.01.28.17.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:07:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:07:00 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
Message-ID: <20220129010700.GF732042@roeck-us.net>
References: <20220127180259.078563735@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:09:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
