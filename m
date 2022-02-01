Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8D14A604E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiBAPlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiBAPlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:41:40 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A62C061714;
        Tue,  1 Feb 2022 07:41:40 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k18so32863771wrg.11;
        Tue, 01 Feb 2022 07:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0AhdHVUvV7S3J7aFjECDI9SHkCrNtJqELFqHcavLM3I=;
        b=NutRTkxBgJ9OGdU0DtSxAlJRwCT9jez3EPcnciqmevbmz3iB2BNaSTxUNS3a7cjuw8
         t8s9MswxuuhlJZcVU3nUQkkT301Esp1HWwEcCUM57mgM4tI9YMoXtPngnYCPPVkDzDua
         h+JaxYjsby1fcHogjgTbKsPHEVNoF+MGVuChSQ3A2TgkGwKZD2pbN+0AYYm8g44cUug+
         tot5A0ZOaU6bDU/VcocPNr6KYD8Sa/kGR/HicGw+PclEBOGWIjCeOyVhPBJHp506pZUz
         mOZGCDRmxRSS0KwNKi7wR+nw4CIm3rD2zkrEC2iWlomvufMelcb5FYIV0ivLfSF4sH1f
         2xxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0AhdHVUvV7S3J7aFjECDI9SHkCrNtJqELFqHcavLM3I=;
        b=jamFe8ezN6pkKBa3pmNk4329TIXsHA/d5xGUjrat3mnC40edT6hribLsMxy8hMh5uE
         Hb42gFR2BSfTtF0ozQqTSMT6qUf15KJT59YVNIcN4OeQdTZV6tWcU+knFv3XelgL/sud
         qVb3zS+iGEyWz2PzVAPp/NoFh28xYWTXNgs66n7ar81bjnu18ScIEckzwxNdr+Jyu3mI
         j5DWM1Bk6FVkdPBVPPXo4ts9zNh64Njul/yMIOpa2Kb5yQkkut+R2XReZvHE/oyWWXbY
         iPGDKnV04CS1ODdY9sITPD6n2HEQL5cU4qJrF7upRG9G+pU/etN0ANCNywwpd8wXDgV8
         al/g==
X-Gm-Message-State: AOAM532oGdOGtXMdV1OGHXZg0YG6SqR7gyTlDtzRDFCdjpXD0dOlExfU
        1dTalHA20Klaj7pea5tl2LM=
X-Google-Smtp-Source: ABdhPJysVIr4meUVxKaU8LXTaDMPqJ8zRZdAc6TKkvulm9rw8gixVFBAuA3Sz7wgIe0LDXntqsi5Dw==
X-Received: by 2002:a5d:6488:: with SMTP id o8mr19442704wri.24.1643730098599;
        Tue, 01 Feb 2022 07:41:38 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id z13sm17322526wrm.90.2022.02.01.07.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:41:38 -0800 (PST)
Date:   Tue, 1 Feb 2022 15:41:36 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
Message-ID: <YflUsMNtezXinYFK@debian>
References: <20220131105220.424085452@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 31, 2022 at 11:55:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/687
[2]. https://openqa.qa.codethink.co.uk/tests/691


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

