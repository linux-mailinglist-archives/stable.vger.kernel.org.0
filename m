Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E03AA5EE
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhFPVJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 17:09:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC417C061574;
        Wed, 16 Jun 2021 14:07:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so4778461pjz.3;
        Wed, 16 Jun 2021 14:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wHO9uVUaoh+PG3fXblhqsD0OWoXzFpo9Jkft3sFmhtM=;
        b=mUx37g0pQjMBn8Q97z0ehMWawM+0rUBCcVh0ASbkcEG1+Fe6MrdFSKDPNVIWN/V/3N
         /orymC7BNuRGmJYHoCn+YJnpfVDFDGeKO9He2L350lT1kEb8CE54JG1n7b1caRFF8fCW
         Ux1zkXmaTO3ZD9Nnk02ljv2F14qbDMHmuO2qTJkBQHtS+G13DCs/z5HjXmGJeUPXiOZO
         xrdL6T9jE6uvpkaVKSq8BEPmUQUxBPSi44PRfjNU0fqwiNSPd8361z2aoU8Q4BOBj/ch
         WHLMJ3nFyI5rUxoPEht2753IxG81ifCBaojfu7DIVL+ktd43KXGMm4h7DkKQDr40j0b6
         UHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=wHO9uVUaoh+PG3fXblhqsD0OWoXzFpo9Jkft3sFmhtM=;
        b=GTwx56rRpCf/LhUKYQLfS3owXr+o6bOWqFH+V7147xI8M1W5vBm6oEOa6cvw8YoVyf
         Q+1cW1LoLbYLaMMoADzm6t25QcyFMyhFHzTQWYxD6k9AnlwPo5QBTm8moAcDVzvUuRMw
         GPIN/SOHcgEzNGv4e/rMjdPjWyeJUCKlOJ6O1wGzTr0GPfMO36+mbnSUfZh4LNDa5vYP
         mJgIGpX93idFVHCEosjDsp6LNuHT/9QZmJezbcXiafR11Ol52UkZZg+cuWZIsgnPauaT
         cYISI249DQKLS52sJhIq7tMBF7JOa+gaod1u9DFPbV2eySb9w3PSq2rZIjwhTrMa1ZWM
         m1Bw==
X-Gm-Message-State: AOAM531BmBtt2OjKMK3QhyyE8S9eOk6AtBsHe2gMAv7Xve+GJvIEVpcV
        ipLsUkwCemOmnhSCxaCuZH7nZimK+B/4V7dmMiOJyQ==
X-Google-Smtp-Source: ABdhPJwrroCJft5aVUtNmRWujeOurpHqp/FqPOKSd1KIIIsSmFElLFQGKk8DKGe6ekvhq5sfM59iDQ==
X-Received: by 2002:a17:90a:2d8e:: with SMTP id p14mr1747549pjd.131.1623877629981;
        Wed, 16 Jun 2021 14:07:09 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id r10sm3330476pga.48.2021.06.16.14.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:07:09 -0700 (PDT)
Message-ID: <60ca67fd.1c69fb81.25c88.96ba@mx.google.com>
Date:   Wed, 16 Jun 2021 14:07:09 -0700 (PDT)
X-Google-Original-Date: Wed, 16 Jun 2021 21:07:03 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/38] 5.10.45-rc1 review
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

On Wed, 16 Jun 2021 17:33:09 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.45-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

