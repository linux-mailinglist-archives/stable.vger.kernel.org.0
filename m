Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88153DC392
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 07:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhGaFgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 01:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbhGaFgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 01:36:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D83C06175F;
        Fri, 30 Jul 2021 22:36:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so17378067pji.5;
        Fri, 30 Jul 2021 22:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OA933n3uTuUYOxu3WCa3yr58k18VKPd0XcFtuOaa1Yk=;
        b=S/8H2ZFyOTIADocxAe7N+TaSUQcOGB+DsOmD/JNhaLx3wVHPkeGC9pa6Z+v7JFfGjt
         xJhsFRc9uF+dxZSLLJdVIQ0jsXo0ReLI03P6Td9aL7aXEFTz3+H4tMrG+bL5LbueWJN5
         ESkME/KtLbP4qRJnZooeegGxVxQLjHSXIoiEXkYWwFiPSpiwCUwoXPrvDBstRjFzFOm2
         yFV+KPtRazBilIqzKAzerrN5v8LeDnNHpHOLW6EJixPqCZaBr7ftI4800evVAznf96ha
         4ws/9VEJUqlnt0DHKSo7jzpcTDPT9EjMfHbzKZeO2736fdOPimxHMB0i0mdxZ2Zo8a0Z
         JLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OA933n3uTuUYOxu3WCa3yr58k18VKPd0XcFtuOaa1Yk=;
        b=gxTJn8I+DMdH4ODBnrxPl9N9qkOz99bC/R5fcuGjFANn04fUmzeKB3wBRM65gyyium
         tEpROec+lcq/2CstB+QNqpbfTvVznkuTqEnR5xlAB0GGHD/wTGSxK6hBOAszl+omKZkw
         Tr7TG7abGAgEKBbeRAwc6DAc5Ami0eh5KHcry6OzSNbleJYpXEaLlsGndQu16AhFMpS+
         X+mPVvdop31bJ2/IZ1z0hG/KWVBso17MB2832SioNikXkC/QH1+L2xfWsPCK3LLnHuoV
         Fc6PSmN/IUcOa7WKd9uNzr+KTBJDceTJW7VtcIwJY8EmP6fiMyRR/pUafacwatO01zgk
         1ZVg==
X-Gm-Message-State: AOAM532ZSr4G0x9I0uKZx9I290j1ZXEOGWEI9z46brt6dyxDczmSd36l
        MISVscqKIPADQaaEuk+rPfBctuuSh2IPdvtpI9M=
X-Google-Smtp-Source: ABdhPJyldW/xDn9pkKRdqTXkCvXTPVONxJ7QQbiZPkkKryELilBdJCwPpv7/sUkxqtC7idOi0LgajA==
X-Received: by 2002:a63:6f8c:: with SMTP id k134mr2566072pgc.35.1627709766489;
        Fri, 30 Jul 2021 22:36:06 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id t8sm5032195pgh.18.2021.07.30.22.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 22:36:06 -0700 (PDT)
Message-ID: <6104e146.1c69fb81.feef9.ea9f@mx.google.com>
Date:   Fri, 30 Jul 2021 22:36:06 -0700 (PDT)
X-Google-Original-Date: Sat, 31 Jul 2021 05:35:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
Subject: RE: [PATCH 5.13 00/22] 5.13.7-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Jul 2021 15:54:31 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.7 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.7-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

