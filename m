Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94C23797B8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 21:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhEJTat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 15:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhEJTat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 15:30:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4541CC061574;
        Mon, 10 May 2021 12:29:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10955506pjv.1;
        Mon, 10 May 2021 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TimIegD9bo/1/rxa4xiNPvMI0cG64gd1Y2PHAJLQe2M=;
        b=XAS7/bsHM8uNuJQ/d/vZ3J4IRzxcFtOpCxyMcNEyznxgSUfhusASZXL/tS8yX6Lirv
         Bn6j0qMobSfAeEWLgaU6AtIbxDKbNClLmxDO9J45yXFfVSDy2ndQN+vGspFL4kxeG1vu
         Rx1DXmxL/Yz8ispj9PgHJ3FCE/Cv4LDBlGO+wxriymdffnlF2s3Fvjb51L71B+WvYywb
         We5Pz2JyxSLYnqkyWL3JDNXk7CWuVYDY3nr0Gkx73icGqBIRgdozZH29bg+9AAD/66M4
         HMSpCiHvtwubknZuDjEC0y15tkWH6+NpsCCGrQCNpLDDr4OllcI9+cE9XnaQlXv10hEp
         8LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TimIegD9bo/1/rxa4xiNPvMI0cG64gd1Y2PHAJLQe2M=;
        b=eNTsMKHWbqxS3aTv9eftDwEESvJWrYjWRjhUA+5gNRwnFALGs9B3xutzxup6VFFeq2
         H5g4ctEC7X8z92ZVvZKM95ak9n1O9MPP8Lg+niry2Q+yTArLZjTEEEi4QNIt4zIUownS
         QwyBveRFRAC2RLcAzhvBsuLXuXEvY8LhJUBnMrr/6nZeET8VwiO/egccdmQ+TE3s/8J5
         gpJGCDIdD6SvYxmTGFOFlhJ9LFqgUu3nFMaElbstiDEEXxkKKBDlDilc4auimUIAugIP
         0raT+XuNUuL0Hk+ebbLcdgnc+RxiIiazDvApny7Cuop4KskiQJM+Xo5Q0CsEMuSNBKZ/
         USmw==
X-Gm-Message-State: AOAM531mZ9dLv4QvamoKcCDNa+AFoZemxQzLHL8NGpALZANyzSJoBS9h
        zSwRqOT6RXiFFdxNkosPh2mdNMA2RNQE/LabEJW1Vg==
X-Google-Smtp-Source: ABdhPJzAbQ85iL81S5UD9jZOXC6O7KJB5FQqt68QyEka1MCJs3FOwZIU5/c/7nMQGMC+Z6T/lXgFWA==
X-Received: by 2002:a17:902:44:b029:ee:9107:4242 with SMTP id 62-20020a1709020044b02900ee91074242mr26320026pla.18.1620674983413;
        Mon, 10 May 2021 12:29:43 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id y23sm11432527pfb.83.2021.05.10.12.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 12:29:43 -0700 (PDT)
Message-ID: <609989a7.1c69fb81.36799.2c5e@mx.google.com>
Date:   Mon, 10 May 2021 12:29:43 -0700 (PDT)
X-Google-Original-Date: Mon, 10 May 2021 19:29:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/384] 5.12.3-rc1 review
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

On Mon, 10 May 2021 12:16:29 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.3-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

