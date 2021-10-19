Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87E6433FC0
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 22:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhJSU1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 16:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbhJSU1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 16:27:12 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4305CC06161C;
        Tue, 19 Oct 2021 13:24:59 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so3464237ote.8;
        Tue, 19 Oct 2021 13:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5Fp6kBMzM/Rbiwq2AxhBxp4FKxeYZ3Affhz0AYCuGI=;
        b=d9ENM7Ax4judTmAg92T4eqw8BRtJ/VL7cxlF3LzZoCgW3dJRbMZeSh1T9hksAWgebw
         nNWz8UADziol5bPFEZTJoW1k+kUz7nxMEyDCEeYLbTHF/98MX9YgyZQIgrat2UucQYFW
         3B5QMsLl6pyxRwrNJdP3xyB8D1vv5Rahl36+yk09K5jfbT0rH53gSsUJZaTbGxD67xak
         /2VH+v2C4OdYC4tABz4xrbCetDqAj4bgShLvZ00XwfHC18sHuyQLL93lM8wQu15rekzq
         tRYThjD7oDbrEwYUty4h1OpvZLFWoTORHz3tZXCnYbR6vmYSlR3+/k0H8iCq0wbhcjLZ
         ZY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=f5Fp6kBMzM/Rbiwq2AxhBxp4FKxeYZ3Affhz0AYCuGI=;
        b=HR7OoqLrYpEDNkDc/A4Wm499Mk1StO4gH6FSx1v+i1qrNDtyqOcMv+kjcOxap/kjjj
         Tx60KT9pyD+DIaX6xXlz5Mz7aT1gVMpqO0TaAZmDo5FJsqCLLiKZqshyVg7Nd7PCiK+y
         9M6mFEZaF66yPKPB5atCVnWLQLjuDzvWpF7UdxM0fyWRbtAT/rnyr6TG+fXz0WvA2BH4
         UzHD5uiqobgaq/m3w7ICjeVuMyREzD10HukTjTQU5XIJTzNPC2ntox2S5OUMxeIqCTds
         JjmeM10KLU/YExdpUPWJEeYXplnxxf9GXufvnSg4hT1+aua+00dLW/We7cuIBmK8ovIx
         JK5w==
X-Gm-Message-State: AOAM532hfWLaY37h1+EF29si/GfTcn58agZXho5XPcsGN0xkD6IDLVho
        W3eFTqDJRbD6EL0A0zQ0wbE=
X-Google-Smtp-Source: ABdhPJyf02y0UL5SWMf40E7uH/Ur/AQD3rENmcJMNcJ7IFuJWicC+9XyoEWkiUPw2b1ByqcxG0A0+Q==
X-Received: by 2002:a05:6830:1318:: with SMTP id p24mr7542065otq.82.1634675098572;
        Tue, 19 Oct 2021 13:24:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15sm33413oon.35.2021.10.19.13.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 13:24:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Oct 2021 13:24:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/39] 4.14.252-rc1 review
Message-ID: <20211019202456.GA748554@roeck-us.net>
References: <20211018132325.426739023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 03:24:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.252 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
