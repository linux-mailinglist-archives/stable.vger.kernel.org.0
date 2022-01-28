Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF249FB9A
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349111AbiA1OYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349109AbiA1OYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:24:18 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB89C061714;
        Fri, 28 Jan 2022 06:24:18 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso1125162wms.2;
        Fri, 28 Jan 2022 06:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=maJHvbktVEBb7xJacQ1lqleTWcxE1EbrXGVkYr99UvM=;
        b=T5z4S/MCNI/qviacNFzJPaSK74K0DxoVrVdy2ybpvJ6W2vghC1XZlOwoaGifgfTu9w
         2FuwJguzNfcC8VYLSEki2EB6L7T/Uzayljsm717N85LH6jeW7iYtUAWzq5sAiHkMMP+2
         XYowlKgw2qrjNuswkyXPCWMZ28BpK7Nt5RIKFbu0N5AyEb8nrcfsZXKQ3AsqFVJ8V8rR
         Na6em4lGwseYLwhJmKsmN2c5miVCFK9nLoyf5GvN46i64kG6CKPbsBDUBofFYbOP5ab6
         FH9Tv3WRg8s52I4urjAXMavaq1RO8FERxtB1+EmOmcrwkAfhT4cKswVqySFoOZYCW3Aq
         +P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=maJHvbktVEBb7xJacQ1lqleTWcxE1EbrXGVkYr99UvM=;
        b=MQB2ZP1RSyhQDsPVFu+YTH19OayhoIniKcMko40+nyaYIhQkORQJZ1DylywfTsqV7k
         5Q+Z8Rwa6FKdJ1MelAwhPQalDsoDupUAqKzkKING6decRlwsG5QKcb7wanNw3PLhwyEr
         ZUWYyLtq3KujEK//gbjwCd5SI01bx+jehA51WUoHk0OxLJ205N+44Rf3TMPKQ8ixeNtV
         HS3yjbahZHC54JzngkqRafxzP2UEflZAcJ3Dw/W/SntT3e2KnRIN7XTvyJAc5ac0nn50
         NcFRi3LC4V7s7O5EkhEy2Yu5VeIgkrmhx5zapXg3R+s8Bf3aqvVadgojLrIShGh/ZMaw
         9lZA==
X-Gm-Message-State: AOAM533rUWFJxCbeRPkgib+clEklxfstOXXhn2XhQsS3b5BQpYatiKG9
        RpugiFHlbxmIxaB8ohSuF2dc+er0m94=
X-Google-Smtp-Source: ABdhPJyrAAweglttUU3cVtQ742y5T+pFHDzH12KsHeRL2SE97ADX5uXzOwH4lKCMElpjyGqlXqMX4A==
X-Received: by 2002:a1c:9ad0:: with SMTP id c199mr16179664wme.156.1643379857129;
        Fri, 28 Jan 2022 06:24:17 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id t4sm4860844wro.71.2022.01.28.06.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:24:16 -0800 (PST)
Date:   Fri, 28 Jan 2022 14:24:14 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.4 00/11] 5.4.175-rc1 review
Message-ID: <YfP8jnJeBCnOhQTi@debian>
References: <20220127180258.362000607@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Jan 27, 2022 at 07:09:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.175 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/665


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

