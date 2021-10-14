Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7A642E2B2
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 22:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJNU0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhJNU0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 16:26:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B36C061753;
        Thu, 14 Oct 2021 13:24:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w14so4945084pll.2;
        Thu, 14 Oct 2021 13:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=L+ARd9XlVuFI/E4JyRHoX29Eay2EB12upk/R1RN9ND8=;
        b=Uf3D61PPxFuFxxhWgY6PAwstVs85ZCuQTIB2coKBiW2S0IiF4wZ0hD7Fsa6Et6+Rfl
         y2x6Kk2HNks5sYj3kuU6xgl3HXcih1WFr5Gi0iov5IdzU+jna9wc1mgxqMCpKtJUJ93g
         x22sGnXO1M/yjO7lgeKglS0pH8WMLwGqsHDJHSJanxfK97UwDPZ5NMYfh1VTyKRXY0Uo
         A58bvapu9Nnh6j9VRjcEE8zHA8+onMlY0W1p1TSPuVhI4VJZDg6k8e0r3OiJq+DWzRrW
         kdDoMziSORvQF2deHKjxUbHYUaHuqEUWk/r21ux0tnrTV0FN8C0uc203jew+PKZTof5m
         pacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=L+ARd9XlVuFI/E4JyRHoX29Eay2EB12upk/R1RN9ND8=;
        b=UW2PNKhPEbS1RGE+b7kHI21rk4GQDZszzrr0Scya4PTobPeVkZ5CCrEDEshAtpdtHl
         h8jQqAPqwx/10rAu4jcDtpVDj6XN4vgf8UyKe4TuyTIQc44ekgv5IaUqRaeR1Gci//0+
         VJSRLqzBAsCn3w1sRMQi3+7eu+DuEpUuXGZAz47ksszVpVfg1Br5ixtEoMTDamPq26mW
         TiJZ+L6QC6a6N1S4PcvwovBHZbI1o0+Xw1atwDGNEnie8aYxfKVJ/uulxvuyvsdQQDfu
         y19HpzKJ/WFmOZXGfpczwqwKYIV/E5Hro1z5M7xAj7qQ7LBOnsBx7WIWnJYsfqpiPHf8
         9YBA==
X-Gm-Message-State: AOAM532sx38p54PJ9+BH4vVGM3VH1Q9MTryk4JdrnxdFG1LV3CzLKB8Y
        L8tDEmcps5L0SYCw7ZtUlzaptrOn48+6qqRG2eE=
X-Google-Smtp-Source: ABdhPJzJf4zTpepsr+LCFYBZB2BL8k0y5RjVVhPf3p8fqChhvSToTwE7OCYhrv9XTzncdjg5TX44zA==
X-Received: by 2002:a17:90a:fb87:: with SMTP id cp7mr22905798pjb.114.1634243086763;
        Thu, 14 Oct 2021 13:24:46 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x23sm3485682pfq.146.2021.10.14.13.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:24:46 -0700 (PDT)
Message-ID: <6168920e.1c69fb81.3e08b.aab5@mx.google.com>
Date:   Thu, 14 Oct 2021 13:24:46 -0700 (PDT)
X-Google-Original-Date: Thu, 14 Oct 2021 20:24:44 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/30] 5.14.13-rc1 review
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

On Thu, 14 Oct 2021 16:54:05 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.13 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.13-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

