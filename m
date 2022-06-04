Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5553D6D8
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 14:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbiFDMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 08:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241052AbiFDMsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 08:48:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAEE13E26;
        Sat,  4 Jun 2022 05:48:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h62-20020a1c2141000000b0039aa4d054e2so7641306wmh.1;
        Sat, 04 Jun 2022 05:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FT4Cd+a8+jP/EJNQPVo+DOM5srAD8mdWD/mrdPcxuWw=;
        b=N40RpNarN4+k4sSIW0/MdCWbXVPlm+gn0+cgl1X6Mz7LS/KhV/i4iiOsj8WxtcfJZh
         o5QMLWy2CitCm2mpHYPdkHwVUgExJcgIlLibaXfrVnv/7DONVzXtmBaCuZSMdvqevud2
         go/DX4ogPs6vf9gtjg65llaIJ/1YhM0CC1T1ntcWhnGA2O9ercjQaSel2gtAmBuc6oQ2
         MBs1vMQmdiiiKEUHP+j3u1jiGKcOd1BQDX72qM5q8zAU+P/63BCIxJdOWYt3ZB2UposL
         G6DVdyPRmZJlbRShpFlgYZNcfq/h2M94jsQjWxigniUjeiCPbQPn4oBWYGERR3n6sxgZ
         AJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FT4Cd+a8+jP/EJNQPVo+DOM5srAD8mdWD/mrdPcxuWw=;
        b=jUEo63AuvimaCn+mrdqVrHdzyZsin7xTi5HPRmQBbvSob9+hPKMquBHXTeeaACYfz3
         c4DTDce0KcnTzlCRzlA45mYL1ZXH0bTQ/8nNgVs6CQZYm1dlwFUr9dmvYSf62nuccB12
         6ED1+fIr+37cpwGPIE/bZaCCJdKGC0vkMl2l8r3tlSdI9gdrL+ODy3GK7sYXTaORZbvt
         iHwruaQSoOzHkdPnXcTja0P5ELLLXH2nXCRAxHgL4dxRvzUnGKd9WNWO/ZYNzVXgdjUf
         RVL9sL5ouRLOpvIgsYDqBTrfbeNTKWObkL/Sma7it0HRoLEBdMBnjVT4X7aXB/eXryZK
         OHUg==
X-Gm-Message-State: AOAM533lhb7+LlKGIZkS4XY6/yQGi4ADWLg8J3G0sVudqOFuDdLZUZvQ
        tahFVFxelMFi7WDDVFYwjU0=
X-Google-Smtp-Source: ABdhPJzXVJcRvW5y1lNkSG5jGEJNzbExZGAM4//1B5UTs4FTmuaJGt39nKaXCWgTOyKEDAjBIrtcUA==
X-Received: by 2002:a05:600c:3c91:b0:39b:6b:d5de with SMTP id bg17-20020a05600c3c9100b0039b006bd5demr31170539wmb.132.1654346909166;
        Sat, 04 Jun 2022 05:48:29 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600c4f0200b0039c46fed88dsm1862639wmq.16.2022.06.04.05.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 05:48:28 -0700 (PDT)
Date:   Sat, 4 Jun 2022 13:48:26 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.17 00/75] 5.17.13-rc1 review
Message-ID: <YptUmswlsSZirDv6@debian>
References: <20220603173821.749019262@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jun 03, 2022 at 07:42:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.13 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220531): 60 configs -> no failure
arm (gcc version 11.3.1 20220531): 99 configs -> no failure
arm64 (gcc version 11.3.1 20220531): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220531): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1263
[2]. https://openqa.qa.codethink.co.uk/tests/1272
[3]. https://openqa.qa.codethink.co.uk/tests/1270

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
