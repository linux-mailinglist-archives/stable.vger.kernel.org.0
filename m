Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ADC41AC1C
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 11:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbhI1JnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 05:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbhI1JnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 05:43:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21EBC061575;
        Tue, 28 Sep 2021 02:41:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q23so18404671pfs.9;
        Tue, 28 Sep 2021 02:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Tyq8kt2cpdoK0UcXewHkf0sM7mnvivLR24pW6FnLMHc=;
        b=IRjggPrB57fPjxGnX3bxlVfXd7ceGoDt1ce3kbaz0F5N/LduNRKGxDbTOO/MKmLyc5
         7ETdGAVag20naqgZhitF0EmgrM/W9a/HpR0WtwfEmPpnVryABCY1Orx56GEXhCOzQt3q
         Mzv0sw68CQPbD8rZ+bME1ZA+fuLv4mUNDsGCoOVkI/djIEmBIEcWFBHSaLD0hH1IGuFe
         K2EIuARB8nNK2amp7WnBrmUtFIycy1Q8Cl4WnSULWaY/KgkXaI80gTax9+z86M/p1Ttd
         J7ndtRaCNWVfY/A23N/kJdUbCq38ELqpe431WIsdWX3psmBSBk7vZB12br/BpLzQqeij
         QE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Tyq8kt2cpdoK0UcXewHkf0sM7mnvivLR24pW6FnLMHc=;
        b=BV6dZvFzib73lZv67At/x39y3rVjnyalnMMeIJpPn75DT3LOe0ny5I0CtXQIFadNPV
         y+WT9fZKinkPpkaVGJzXuDbKAonTDe4MZMn1ERj4NIcgf7n0uuvbfqZ5RIjWq0s9WYqa
         Ukluj2aXV8MrknYCCgm6Bb3YjWbFN9GdGFxQfrv8RBQ6gFMUH1m5bQYT+vtHSqLF8yrL
         ng7aemPwar0q3mW/ze0391PQnpRwLNi34pdLgyA0XW6ELXujn5mPzLssGpaEx23afuog
         gYCtde8evfWXMn/QyNAVMWT1Gzt5/de08IF+WGhiFC2hAkCVnlAuFe7eCF1LR+jSqi2Z
         BqFg==
X-Gm-Message-State: AOAM532r6hO8v78yaAQZv7BLzk1Fjs4WzjO8/LrXQi9qDRGBYx85tHIG
        XM699DbpToE4Ro3u5DTuuxUPw42/GfrKSOqLsmA=
X-Google-Smtp-Source: ABdhPJwlEoUGBsJHSfvJWBEuyX3BK0BG0A9Dfl5vAt2tGEh/e7kLcN+f9mkB3tgaTPG1urdot3wqAg==
X-Received: by 2002:aa7:9731:0:b0:43c:9087:fb40 with SMTP id k17-20020aa79731000000b0043c9087fb40mr4246386pfg.55.1632822091825;
        Tue, 28 Sep 2021 02:41:31 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id l128sm20269795pfd.106.2021.09.28.02.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 02:41:31 -0700 (PDT)
Message-ID: <6152e34b.1c69fb81.456b3.1624@mx.google.com>
Date:   Tue, 28 Sep 2021 02:41:31 -0700 (PDT)
X-Google-Original-Date: Tue, 28 Sep 2021 09:41:29 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210928071739.782455217@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/161] 5.14.9-rc2 review
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

On Tue, 28 Sep 2021 09:19:04 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.9-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

