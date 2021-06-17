Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF963AB1C9
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 12:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbhFQLB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 07:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhFQLB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 07:01:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A559AC061574;
        Thu, 17 Jun 2021 03:59:19 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso3430750wms.1;
        Thu, 17 Jun 2021 03:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6x8CcN9jxreq8OwS1dIiZGQ5hktrk4/e5THJPCD0kvI=;
        b=mmnHMB5zTtVzYXMqi/Dp2XKT3VuxhI8faVhz6ARvQWYgA2ek7zaAOwFogKjAaF1d/S
         tw32ykkVct4FQFNrqfcjkg+VyLbrALrvxf8mLrapTLOiimMU+/pTJiyEK/6i9DmoBZBl
         Fczjja9YYiEAIfSy70X5d7uqxtIpBT7YNkm1fO+7wKHV6yDR3+oHwxUItmNC3o776XAh
         bHGEA40czMzsVO4V4NLlievFZKZahNtIUPWEX2ceA9P6MAuQ09aMTJsT1x3B7jIP34yx
         zbwj5IRIrJw9iIw/NAxOr/qpScyZVCDWNB4kMabDMH23GY1TFJSw8pgkNhgVNCvceLCR
         JNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6x8CcN9jxreq8OwS1dIiZGQ5hktrk4/e5THJPCD0kvI=;
        b=RkEOwmDpnYFLSGCsPiSNWf1A4jtY8Wxo53VahuPKAu4bAU13Omoz2AjN/ZwMQzO2j4
         ZLDpCyBB4SS2m9K4QN4vlL/W3bjztGuXrRNQZ/0kyKD8PbqL5dX6/ECiOrqOWNRVdp4t
         3G1kdJ927GM3FTD30dozepoYquQs++qjsFac3U+Gzs7zHU8U9iBvmmgD7ZA/U+4/K1Ip
         Ft7/zLFhGJNCD/Q96n3LS6PsWS2ACg28uDM/v9zhhBxvElKLr4K7C40xS6PICMT+wNBl
         l/bc8Q4Q0umxLpLUfhL/jT9t93Fg+XF0zWZ8OCYrm8xupi05BHpZBIWUC+rfeVIydTUY
         GtdA==
X-Gm-Message-State: AOAM530BBNx8cRO15qzwDK/WirhEzLWbLpL554i9vPHwAn7J0MWphfCZ
        ti1LBnGGnbdzCMnGA1YU9Aw=
X-Google-Smtp-Source: ABdhPJwSHawMNtLs3IJ+Gf1S4whGlzSu0FA9me30XOuLZDHNifF92wnkdx1prUOtH6iKWutXYTRoJw==
X-Received: by 2002:a1c:4c15:: with SMTP id z21mr4348664wmf.57.1623927558172;
        Thu, 17 Jun 2021 03:59:18 -0700 (PDT)
Received: from debian (host-84-13-31-66.opaltelecom.net. [84.13.31.66])
        by smtp.gmail.com with ESMTPSA id r1sm4612634wmh.32.2021.06.17.03.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 03:59:17 -0700 (PDT)
Date:   Thu, 17 Jun 2021 11:59:15 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/28] 5.4.127-rc1 review
Message-ID: <YMsrA1tndr7gwY+G@debian>
References: <20210616152834.149064097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Jun 16, 2021 at 05:33:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210615): 65 configs -> no failure
arm (gcc version 11.1.1 20210615): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

