Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5C3E8D71
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 11:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhHKJqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 05:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbhHKJqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 05:46:21 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCD1C061765;
        Wed, 11 Aug 2021 02:45:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so3956484wms.2;
        Wed, 11 Aug 2021 02:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hX0QC6ADmJgwmbuQbtv5ah8ttBQN8g/jsVWTYEdT7BM=;
        b=Jg7ZiRHgtkqfCa1f+COa3hTMW5HGOHK6Hsnt8V5gvRE7L52loyU3dNO2s1qzbXyZQP
         wZ5ymZYOinBjh9rsQhzl852tMp5/g2X0qrAp8McMlLBVu+TszY6aXH4+q0CEDhJ9gj0k
         ahc7hRq5SHq/uaTyqriE18jXW61DZMAfDbbuaWPdi9kbbIsUX9klRw+zEtiQ6R+4utk6
         0r12nd6Yj77GQPs/3jGrLlaIpUTxbf5+VA63ez8JOz+u/k8uKCEWNy3pl8pNnV13UH2C
         fbM45EtPHKl3lBoqI5coyjHIt0pL5InLaSOggSXY4kKDY0mc3AWk132b2fidRvJccua7
         w38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hX0QC6ADmJgwmbuQbtv5ah8ttBQN8g/jsVWTYEdT7BM=;
        b=gf8rZuwZ+W2xOOwDG2EKoXxF93HuiXFRnJ2+nwBfBdl1YLpug5cNb36vL7Iz+PAeeF
         MDFJwodqsN3EdmYj1asFPy4CpN5TO/qmDvWva85ASBzIg4GQM8J/1m87HoBUNVJtvkeO
         7/MkapeMrbMRKBP5yjFSlZiMGEoHmiq/xTPD3v2U5aUThW/W5ZGCDYNCBHoQEeZ6C5MP
         L2D2bPse9zCD8G2ZXbDxcYAQFQ2hm+VrnPfW/ftvcK0zxpeQ9anifsyavrf1elVM47b/
         hppJeKLOwM1VQ8wnHGFdZkQ5NCaBUQmfu/4y9020vuvGkK/B61k0lyTAr5DBW7VO2ZDW
         Sk3g==
X-Gm-Message-State: AOAM531AV6q8p5UbhBxKUzKs17h3g+jRZE6QjK0ccHbdjI+wVGK7c8Wb
        S7peO8nY6MQ6TAPQivgRji4=
X-Google-Smtp-Source: ABdhPJyhqBSFq6dY9qZIn3Q3kR8zRI975pXyBOfDHwZTOJwJ3OKarvZwiuu1i5StWgxqaVWzBGjsPA==
X-Received: by 2002:a05:600c:154b:: with SMTP id f11mr8992188wmg.116.1628675156520;
        Wed, 11 Aug 2021 02:45:56 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id i14sm20696100wmq.40.2021.08.11.02.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:45:56 -0700 (PDT)
Date:   Wed, 11 Aug 2021 10:45:54 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
Message-ID: <YROcUma6anxbHTjh@debian>
References: <20210810172955.660225700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 10, 2021 at 07:28:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/20
[2]. https://openqa.qa.codethink.co.uk/tests/23


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

