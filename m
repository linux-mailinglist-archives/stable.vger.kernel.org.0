Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC443B94A
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 20:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhJZSVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 14:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhJZSVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 14:21:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E90CC061745;
        Tue, 26 Oct 2021 11:19:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id g141so300284wmg.4;
        Tue, 26 Oct 2021 11:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=00zHIy6uxCqtdB4Oe239178KEZy1IyyQbtz2j0P7x2g=;
        b=lGqgl2GdjeJ8kbl7XTJZ2wHiJB2pCqQ+kbGl/4B47UJgL2Qs+6BNPzIpvNUrzr4YHr
         FYmJROGSms2KRYx17huGuHcY2X3Qd4UQ7CNOOv7PVovcdEKZq62xauS04xm1ppe/TZI7
         dhkBbVIg66eJ5W/Ubd1jKYCI3NF9zRZgp1acRMR1rAx2AHHHa5l2I01v7wdfVRTzlQxU
         s+UIFxMQk9v19nduWT/hP2ZJqqZXTJA0+pT+bMHsihHgKjR28bdNNLliza3yc7/OEtlS
         s7Jisrv5Bm9IEUwWmI9BhoOoKTMcwUFm23yIUYvvEoTM7BiZQtpOSHBfSOxs8J0RlvNy
         Lbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=00zHIy6uxCqtdB4Oe239178KEZy1IyyQbtz2j0P7x2g=;
        b=XaJIxRpCIPSIRH6GXfO/Wh0uTc2K0TXgaR8sbO9eopMKj0nZSfIDecFUNrZP7ntt6D
         H9ntJNXRarzzmZXKk0rEpQitmLs0h4CtuLrEgjuU0A19cIenxQKxb5dhzC5ygJC/k3mD
         hQnsnmf+NJCrTTe99jjEyMaIZX5flPwhjt9Q/QC5EwiLY+Kz0UileTbUrAGzxSTz3EDo
         /Vn89kQwHYeKVtF0IbIfsA3y7vJbpmKKM4lz73vICedCK3+9GSESysoqFUttNlZV+qdf
         5jKX00MG3fNb74Y+7CqZmQrkte0n5Sl2+Hug2t0RMwcwY+XHJY7yp2vwIVgarHZ7RK7F
         Aj5Q==
X-Gm-Message-State: AOAM533SpQd9raNo/Q40J6BFileLaCTvftCHFNDhUnaXkRvgMpqPZLii
        8Ghg7nE2zFuPsMc/+8x7ugYwJET2Zb8=
X-Google-Smtp-Source: ABdhPJyPaqUEsCnQ6cCn8GpPkerVMYgZINumNxgXppcC9xeNnHSQYwB31Fca3yPOVREMpp7gFiNAeA==
X-Received: by 2002:a1c:9803:: with SMTP id a3mr327887wme.180.1635272339688;
        Tue, 26 Oct 2021 11:18:59 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h14sm1385917wmq.34.2021.10.26.11.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 11:18:59 -0700 (PDT)
Date:   Tue, 26 Oct 2021 19:18:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.214-rc1 review
Message-ID: <YXhGkQqStLJtXo5j@debian>
References: <20211025190926.680827862@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Oct 25, 2021 at 09:14:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.214 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 63 configs -> no failure
arm (gcc version 11.2.1 20211012): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/308


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

