Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678EA37F398
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 09:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhEMHiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 03:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhEMHiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 03:38:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EF4C061574;
        Thu, 13 May 2021 00:37:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b21so13953862plz.0;
        Thu, 13 May 2021 00:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=6yTFbxHIwd6peJbwP7HMxe6U7ibZ/XoARK8j3+NqR0w=;
        b=NulSibhiF7JvAs92E6W3p0PUHmmJGYATFmdnegbjySKKm66VCmmHY5hzo5W/Uyut8o
         jkBttrgQ5nHb/SAU6qIvj8d9xoiEI7HeSw1aENXYtTPoIaSq3arkKG8JvFYD2a5eX6R1
         GxQvZCAveJkwMnbbE3M+F+LUxVzODmvLsbKDwf9nBBBTYHylEAZtG+WVSvpV3+/Zx7rH
         0YpPysDGS0NV0SAIDN1jjTzdEbYYUKH7pCrnsPk8sH70tTm9piSKs8YpD/Q4bUNCAJz1
         kK0DBXAbDhcoGw1hqN6jjaz1pFg693XYxPhMgIlXyFMpDsbW+IR3SZb7S90Yyp/28WzH
         WytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=6yTFbxHIwd6peJbwP7HMxe6U7ibZ/XoARK8j3+NqR0w=;
        b=Jy+kq39VXwUmiVtpi2Cq6ePIDKhDZNKER4+obKv/FX/eP4HWxrKQSDqLQvKFG9svHo
         gAqzwlNT1waJAGWlrI2ZIDlGJmxBSRSV2IXauyc4UykquSTMXDIon43GA9EUYWHXnBkK
         u6ZNzV9xXy7PFCr7QES1hLaqNcFFLI//nKvQX4CoVjenpCh4XkEMRIMytUh+siuZzyz0
         Kr0hU4qAKL398CsGsAy5uKdFoIYSdWtAcWsgD6y1QnjuvFWl6MjX01J7gF33hnneRE4Q
         oUE34RqrExN1i2rDMUGfhtANiPIWbyzJYPq/vVyGxhKoZCmErXvRIwkFLKH//TIhlfXY
         D03g==
X-Gm-Message-State: AOAM531zVX1hC5e/tMHDw/BUHxHMLj1gcm8YZ4ZDoRDeg6KrdSOwxPYU
        9D2MSleCgojUAi/IHf480rjsAKS16joYq64ciQg=
X-Google-Smtp-Source: ABdhPJzb2c5ZAzTtPUDmgx+Ms6jID9WyetnRzh6Ch4XMR1DWdVU4aj9RqIYK5BpPzMagLyaToj+Xfg==
X-Received: by 2002:a17:902:d386:b029:ee:bf5f:c037 with SMTP id e6-20020a170902d386b02900eebf5fc037mr38844993pld.31.1620891434150;
        Thu, 13 May 2021 00:37:14 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id q184sm1433476pfc.208.2021.05.13.00.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 00:37:13 -0700 (PDT)
Message-ID: <609cd729.1c69fb81.e9822.5bbf@mx.google.com>
Date:   Thu, 13 May 2021 00:37:13 -0700 (PDT)
X-Google-Original-Date: Thu, 13 May 2021 07:37:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/530] 5.10.37-rc1 review
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

On Wed, 12 May 2021 16:41:50 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.37 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.37-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.37-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

