Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2826337F5FB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhEMKyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhEMKyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:54:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51123C061574;
        Thu, 13 May 2021 03:52:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x8so4190082wrq.9;
        Thu, 13 May 2021 03:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wurg8+6Jn58vcJ4YzvhBvWEPt984bnrYtM62cgWtQ54=;
        b=Liyso4Ddk1TCHKkBPfvE+Tjl+dMTtgM83Hv6ihumX1VaDDJHGkiVxtjQXxkaK+FApp
         xnlzeiPdeI6EWBh3ae6KOO3fx9c1wehK6srYGZw1aoBA6XK8ZPU0qKNcn+m/Aur3ExyX
         h39r8mNQYD3PXTuBektT9Bh1T4WfzNZr5gol2VqG+Zmu1+U7xRDmcpGy1OxIyqWoZohu
         Ql7KY9/M7iJGuQU2Z31or64X/6EqDF346wrJyB42+vezeh0bun4hLaimxc0UvuzQZRn/
         RXdA2H/5kpyPh2byOjtSctsoeme96ihZkLVPuGdodO3gk7x7Xfobbe9ls9Dk7fzJXKeF
         qVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wurg8+6Jn58vcJ4YzvhBvWEPt984bnrYtM62cgWtQ54=;
        b=odX4ukgUAqH/8VD4fx1yqnhdg2ZHUS2ODzbHgsu9caP1dkQnokfxLRLvo46MDw0NEw
         yeunOMVQUkQx1lyeIUt2zW12hAR2jpdMbomniqMnx6OzlpFrVIhmrCQTVN3NrmZG3NCC
         6lxuCODC1Fz/QvAz64szpCf82htSRqP7ziAQ3k0n2/Q2FnVNTG3aTg5wQ295eBgStMqs
         MIsGjeLOCXxtr5HOh9N2Ze5Si7oLRjPxxvTjkRF8FD52Mi7cFrJuQyh9gI+aUlwlwTDK
         hpQCSCyc7EORZM6zvFWQQZ0fY/VLglfYz4uZPTxNOWB3uaZ3uwxS/oOamq1RYt0Sgcwa
         5s+g==
X-Gm-Message-State: AOAM533UvCH4b4O/gkYvNRdLYyPNiUZsm8co/iJcePfBH2+8jvBbShqI
        zkQnAKCuYpVDXnb2bAeJTHo=
X-Google-Smtp-Source: ABdhPJyZE+Mpuh2iBNJGqNUuuRioUx8qSD/muiIeVgDnr1tO4S4DlQy9IjOridIGsJ6QjzD1+bydAQ==
X-Received: by 2002:adf:d084:: with SMTP id y4mr51791133wrh.0.1620903172064;
        Thu, 13 May 2021 03:52:52 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id i14sm8237544wmb.33.2021.05.13.03.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:52:51 -0700 (PDT)
Date:   Thu, 13 May 2021 11:52:49 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <YJ0FASxs09/BxwV7@debian>
References: <20210512144743.039977287@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 12, 2021 at 04:46:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210430): 65 configs -> 1 new failure

malta_qemu_32r6_defconfig fails due to:
[PATCH 5.4 035/244] MIPS: Reinstate platform `__div64_32 handler

arm (gcc version 11.1.1 20210430): 107 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
