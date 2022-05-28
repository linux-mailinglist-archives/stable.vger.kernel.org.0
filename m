Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7557B536D67
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 17:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiE1PBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 11:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiE1PBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 11:01:51 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1912AB3;
        Sat, 28 May 2022 08:01:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 202so6819156pfu.0;
        Sat, 28 May 2022 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kbccSHC0Bz/zz14Ij+BsWRT7sFSsXKkJCnFC8b46qks=;
        b=LUjnCZEQiN21JnyfpU4xbp+rF2vlBVByaGr9AlOxO7gcVgzg28NMpMHmlX4evIofGG
         ebImdh4ZLHySnhjp51OVduv2uGaWVd+sUADb1D+SFiVB456qYXZNpsc63P+MEYjIq/UD
         K7VXs4V5ZvFPdsSPFA6CG/vCKqFMAKYPSZzCShOpIip1dT7DOKe0qIAoMd0+8Gq2SCNu
         p+omw1bTiF0P3CF/DuaGEHTxM2vQJ5J4w0v476f3szPdPMn9na1mb9FAYxeoqnmBbPgy
         rRbTgqBLLuoSEcBviRvBmBCw6rvk5jK8BnpTflEQ91n/u+l8pbR/kOSFtZ07vMjpnBQ2
         VEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kbccSHC0Bz/zz14Ij+BsWRT7sFSsXKkJCnFC8b46qks=;
        b=OtaBQqs+ApJojc1h8AnnhWtv4XMeGvia8JpJ9zoeT35+qZtZqOTLkUSsfAb2/JNN/u
         GuriD1xTxbKURNCX4KPIwYVt/J1Io3tLEK8TKD/fTVOUTPmDYTJONWktic/YapWv9aDE
         pnfkfE58hLfBn6k4lIcAudXVeDLft40fxfSD8sNHkFGKfIAqQCB5cE+cAwTmkrOG6HW5
         ZphbjdNRjbgy2FrXOALU5djCdG5Y40E7DzGo5KepP7Jwz4n6gdOjyN+80Gq6YW/d+OPh
         JJ3WfMk+pynUy0Qap4rGUcd4WvXEZIgma/6UxUGmdZFcS1hjmpo4HwEK8dOkeQVzLkJ0
         D50g==
X-Gm-Message-State: AOAM531g7xcdeUTB7A5x8vFeuN/UQ9eTwQfBhIq4XLJ9mPEw5wX95jge
        SAKHT5ITVOp1wgGrK7IE8ImRncVgS02jlGZA
X-Google-Smtp-Source: ABdhPJzVtWW0xcN+lzzxDcenVYIBbdoyxAyZ6Ex2tBS0uAlmSfufC4YxNJkS9YAjFKTybHmHGPXZRw==
X-Received: by 2002:a63:28c:0:b0:3c1:6f72:7288 with SMTP id 134-20020a63028c000000b003c16f727288mr41049865pgc.564.1653750108736;
        Sat, 28 May 2022 08:01:48 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id b14-20020aa7870e000000b0050dc762812csm5491623pfo.6.2022.05.28.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 08:01:48 -0700 (PDT)
Message-ID: <6292395c.1c69fb81.6860.c34a@mx.google.com>
Date:   Sat, 28 May 2022 08:01:48 -0700 (PDT)
X-Google-Original-Date: Sat, 28 May 2022 15:01:41 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/111] 5.17.12-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 27 May 2022 10:48:32 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.12 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.12-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

