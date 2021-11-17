Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1735B454795
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhKQNkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbhKQNko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 08:40:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8688FC061570;
        Wed, 17 Nov 2021 05:37:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so2606181pjb.5;
        Wed, 17 Nov 2021 05:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bK+aM+uJiaIWQvTErFPdAKoHKtcLm+V6y4SEevN+qjc=;
        b=ilUYALeVzHJ1L7OKC+Ef+BUaWOeYCq51FcU2QXhpN1kLOKfOQK8WKj0K90wATh/FSJ
         2OV5T/oPJ1Fy944fwEh0KRbUUn5Ti5sIDArhOpphe3PcS7rChEImmQVfe4AjrTsis0tm
         jNm89PYFdMX8gvUmbHMpPKXUsgGFZssXc3mUHQzoJTv2vCRHpbT1piYkQNHkXrAZliqc
         ZhVoOnIsd1mddt3Kgfc4Ny014kpV1wE0+iGhJa0Gd1kslb4WM/tlp1Xw9fK0mv6bzRI+
         6nwJTtrl2fHI5eyAkEzCmFUjxfWGEIAoghRYxJPPIOJN7zioLW8IMg9bMRxXsm+xBoRA
         Ft7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bK+aM+uJiaIWQvTErFPdAKoHKtcLm+V6y4SEevN+qjc=;
        b=qzITZqtdNWLJ1WkIoTSC3OFjbHkNEVh8MCbgaj9JWlWs1EdWbb5/uDs27/5vkvBeY4
         auDfKUgeEYbxnro96nUN5FHTWJ8wG5FBVj1+OOKectT7t7GyKJjGQeqCImQVlCfA6/+c
         VNE+HwlDKj6JW4Og8T6bd+55aLdUNnWAt00JrT2iZDJvd9aNxFF7qpT0iqYPsZ5L7whS
         jDtQQy/Mfx5Ucqr8qAukHoS7y8v0PWBUP06kxyyQUapdm796nj6372itU1XwILZyP/V3
         x/Wx8ii6vArmr8e2+EUl2Y0fcgORzl8eNZJFLsJEioYteqDLkx7gSEhKWZnMXi3O5kb+
         JX1A==
X-Gm-Message-State: AOAM53182FJpoaIk9J4hHCXDLsjSPNsvU5dkXOQWDcW181FRvYw0OfVM
        /fYKManj0txbTkbIHwnE+Om6YPlZaZGf2fInQuk=
X-Google-Smtp-Source: ABdhPJxddzhrW4cGy66T+t3N1izFPfH0C4QFrmBu6y0XsB0gw0puDR65egSDKb1TAzSaJnCgOdDUHw==
X-Received: by 2002:a17:90b:38c9:: with SMTP id nn9mr9280161pjb.192.1637156264333;
        Wed, 17 Nov 2021 05:37:44 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o28sm7623091pgn.85.2021.11.17.05.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:37:43 -0800 (PST)
Message-ID: <619505a7.1c69fb81.8cff6.69b0@mx.google.com>
Date:   Wed, 17 Nov 2021 05:37:43 -0800 (PST)
X-Google-Original-Date: Wed, 17 Nov 2021 13:37:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/923] 5.15.3-rc3 review
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

On Wed, 17 Nov 2021 11:19:15 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.3-rc3 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

