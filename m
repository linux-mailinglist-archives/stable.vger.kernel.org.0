Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A1422941
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhJEN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbhJEN46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:56:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52115C061363;
        Tue,  5 Oct 2021 06:52:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c4so2368020pls.6;
        Tue, 05 Oct 2021 06:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ttF20ZQMH/I7QUGeRTqvhuZC7wx0+7a27rbwpvUyxpY=;
        b=Agc76WUyNprgii8j1m9XD5A4PkHG42haFN92iEGjSYvC4fgpS4pp73CMPd3Zw617Ye
         HyMg9Zmaw5bIX3yWSj1Zamcw4z9cIny5pRv960sDfHPKBImNDnnNflO12T7GcRc3Dp8+
         taMFMHTaJcgF0rdpzRAShQdsKM+w2NKeOoB2hr4TLdvebTGF4olnqxgHaovbI14LoooZ
         Z6rk+hVjQ0jRYrqHB7Ii5CuqmyWgFppFo+b97kwkIKOessRUsH1WCCGCTzD23QIe5VZ6
         twTJLFxq2iD93mNzPdMUauiBOJKRrL3p56txmmznvLgfb1SEaNu797+Eziu7zO5V/w5x
         ML0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ttF20ZQMH/I7QUGeRTqvhuZC7wx0+7a27rbwpvUyxpY=;
        b=2RgQhJzhagCLup2vpPp1uwTiuXq8NlHCHbO2hwD7f8eIpy+5yZBqctT4wkZUNZ997j
         kZKqppT1RTEiaGI3hlP4GLmafH2uebjzkYR9k2OcVEQpTluMTR9uAmBf0nORc7dcISIc
         s6PUQYljqi+51lICixG2M5JMfJpRcLT4kcKEl4gOWfH5Ev47Wg0Bn79WA/v0LhKtAOZ8
         djVN4tLMdA/sZmEKyj/8EGDfp9xF7sCsQswVSfgMe3LAGDqjGKk/DUW1sS1btAMPJoBQ
         Pd8yiFYXxC4Ux8aeZcFrdqk3RSxtvzBRVez1VApLpElRpeD0pMRu6qTFp8KzBXrqgDab
         NkWQ==
X-Gm-Message-State: AOAM5312PNij6cf6sgrD8lkd1CLLD04XbmnAX+SSbLaqb86Huk5CwzW6
        yF2Wxzuz7yOUJapSh3olYBOcv1dPFQLAs4lTmrc=
X-Google-Smtp-Source: ABdhPJzIr09q3RLw9xK6zAO6Dab5Qci5j/gKSWCu8S7jv9D0F/fpyfvXSvu2fpk5qDbwV+bwbV87xQ==
X-Received: by 2002:a17:902:6846:b0:13e:9479:b315 with SMTP id f6-20020a170902684600b0013e9479b315mr5407474pln.8.1633441924083;
        Tue, 05 Oct 2021 06:52:04 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k14sm2518687pji.45.2021.10.05.06.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:52:03 -0700 (PDT)
Message-ID: <615c5883.1c69fb81.75065.7b1d@mx.google.com>
Date:   Tue, 05 Oct 2021 06:52:03 -0700 (PDT)
X-Google-Original-Date: Tue, 05 Oct 2021 13:52:02 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211005083311.830861640@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/173] 5.14.10-rc2 review
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

On Tue,  5 Oct 2021 10:38:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.10-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

