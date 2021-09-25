Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38610418388
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhIYRZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 13:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhIYRZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 13:25:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074FC061570;
        Sat, 25 Sep 2021 10:23:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x8so5900907plv.8;
        Sat, 25 Sep 2021 10:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pSg7UnKYyqt5Li9zfMiDYFFUx5gfTcIT/MD424ai+Ts=;
        b=XngIlMgXoFV4WQHJjCNo2Hvka/iz91fMXtve5axC+QXKH6OZ7ItCs/pFm5M1ZIBnM6
         xFhoK/naKaWC5ONQpYyxv9ZBXJISKASa5S0M9ZPph2aDDLJB2uaA0fc80wJQuxPQ/e2U
         lFUCYSrlbAbv224d07YwK4Mkn7mkHHA0JnjaGSnT8DC4uwiauwDCpKXQac8FL6Wim+fZ
         UQmv7tHv+mzlTitAuz02eC46WynMEzy5swVe+bByEyOlBuQd2+W7apB5LRGAQjk5mvpw
         sS/BROErfywS1cDjtcaqYznYMBxLIo1UHI/57YFqTIjQOCL+J3cs2+hK29bjEp7JQ0rk
         qsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pSg7UnKYyqt5Li9zfMiDYFFUx5gfTcIT/MD424ai+Ts=;
        b=fPGREN+56/SODz0RwViV5InZ1KrMFljOjePgBkhfukoTYnJ9qPcEINRcskFWSUqTxp
         6DgXeSx33ytCa+7c1HcRHAVJIbjHgX0HtTZbvkULcEr9EGCxEbxuT/FZ0NrOH3k6iTvA
         ynbQdKC/ZCjKg3jUlSq6XvUpuq3isaojswzedv+WC83dDwoVNsXLAKpssKAlNUovgOkx
         NrV12/JhnKILIT3sCwwuXbFZ2yAFXkKwGij0QSnZvmMJushPBg7NyhQNxeXRrCYXXGfT
         KdI8xOvgObc7annLgzD/1GsRYvqTNrmy7TDWLrJAqv7b5GFD71tqB9CldMKPh1rR/FTY
         CpMw==
X-Gm-Message-State: AOAM532nFOJ60UdPQEc9ALNrvoqfQJ5NTGfgWv6tS/enU+YeNSqG1xgA
        HH0mfenO//qs8m6X0cm/q8Ilm1JXnuAymn/o8oU=
X-Google-Smtp-Source: ABdhPJwNLyvJc2aFlM++Pop0u8f6K+j1iRQPxz7nSO+dMHJhMGtVazG0ZpzYmLWc7xFLHn7JjjSf2A==
X-Received: by 2002:a17:90a:6289:: with SMTP id d9mr9390059pjj.110.1632590622085;
        Sat, 25 Sep 2021 10:23:42 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id y7sm12502730pfr.33.2021.09.25.10.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 10:23:41 -0700 (PDT)
Message-ID: <614f5b1d.1c69fb81.f1c5d.548c@mx.google.com>
Date:   Sat, 25 Sep 2021 10:23:41 -0700 (PDT)
X-Google-Original-Date: Sat, 25 Sep 2021 17:23:35 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210925120755.238551529@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/98] 5.14.8-rc2 review
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

On Sat, 25 Sep 2021 14:14:18 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.8 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.8-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

