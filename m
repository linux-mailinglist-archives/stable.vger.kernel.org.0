Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA4383CE0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhEQTGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhEQTGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:06:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1209C061573;
        Mon, 17 May 2021 12:04:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e19so5632252pfv.3;
        Mon, 17 May 2021 12:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=23T/zPHDGLwUftH2FzR+BfSGY+JTl3qxWkHUqyK7pLo=;
        b=qDGD/GD3q00UtWyVlnUYNm2oON20zZdEN774Z4wC1I6vZryqiYhv3e3ZrcBQG2UNCa
         Qn1sVvrNtxaGmN+Oyej7evSWIS4yky2zxmy24z93OopamUGn8Z/TLJ3Izal0EqmpSRCY
         1cDAbElPJJ2aEwoFHY73p5mCT5tgLbfo+Dho917yKxjBjtY+ZPrO5b/ovuNHyGNwaI9/
         Znn2d4I9GjRMCtsbzD4btQuDdt/43LwzFdozEaquvyH+c8N6x0dNzmnxddhcCYOn9USr
         Vc9DQI3vfImSA75XBxCW9DmRldJ0vn8bbgI+m0TVPqVA/59iP9TMsM4GQILJN3jWRCC6
         kPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=23T/zPHDGLwUftH2FzR+BfSGY+JTl3qxWkHUqyK7pLo=;
        b=fUDt/XfH9DB73JnC6MMhJcZuf3vI8PE9bsYjTJX5Kr1DQz2ybDbd22Ah+2126fOWhe
         lgfUbXvJsvloUT9auh6AFj7HPBONem8LFG8GnxB5v0G4MRH/xrXJdtlY0uzm0CjpZN1c
         ZZ3i0CRV8vesnCVioH7LPqGZxmOQt7da68enpKzX38IDpB9ABozeZj3FUSc5BEwJw+Dg
         LFq5hjXPYLtV2acud7+wFMY2iSsVWhC/eTQ4TxJeNcPdZ5a+gmVT0o3s5uqC0qQoG6Wa
         RnBUsqP6Uxg4n3bKDDo7qzWG7Ei1VZXvNqusWHrUOQr8c76wVTnHBXgLba3Yvt0MMq/W
         8e+A==
X-Gm-Message-State: AOAM5329P3WeCqgBlWJKWe6B7ghUYcnLusarGw2neB5wedxmtSThBkgU
        ibouk1UE5N6y0FBmrN1kydifnL4MnQlRdjyqqys=
X-Google-Smtp-Source: ABdhPJzJqIkOonjQgB0QYY0DVRIxYp4Kbl/vKfNniAtRP/VwHg6H+bijd9831VBjO3IhDr+iGFMSNQ==
X-Received: by 2002:a62:1b97:0:b029:24e:44e9:a8c1 with SMTP id b145-20020a621b970000b029024e44e9a8c1mr1043603pfb.19.1621278295829;
        Mon, 17 May 2021 12:04:55 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id c24sm10356859pfi.32.2021.05.17.12.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:04:54 -0700 (PDT)
Message-ID: <60a2be56.1c69fb81.782df.331b@mx.google.com>
Date:   Mon, 17 May 2021 12:04:54 -0700 (PDT)
X-Google-Original-Date: Mon, 17 May 2021 19:04:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
Subject: RE: [PATCH 5.11 000/329] 5.11.22-rc1 review
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

On Mon, 17 May 2021 15:58:31 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.22-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

