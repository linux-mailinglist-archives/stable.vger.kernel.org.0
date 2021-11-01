Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC80441B3B
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 13:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhKAMhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 08:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhKAMhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 08:37:18 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB8C061714;
        Mon,  1 Nov 2021 05:34:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s5so4654301pfg.2;
        Mon, 01 Nov 2021 05:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hq3EgDXMF1+jcTFvY4w2kMpW6vFqDAJq24D6kljsps8=;
        b=KQrmqNzS5azL/yYFHpqCoaJq+yUHlk862t7a7Rg1PuGo5ota7aDMJIkPLbTw1coQOG
         7SNcTGaCzmkqQUMSpKV8dgpgCzll70Q37OJMdNkaOKwZxvsC+FL99Esn9cuiTNr/SFwb
         26gr9PNecmEPzTtbIPBF3Q88afXckTqAnCBEQaf+B0cwoZxIH5RVDsDKm/5DjAPGge27
         q5k1gj1g1XamVIVgNWtxxOKWMGTrBidDa/WJPcv/sIpz5c1wD9MTRpGWZP6JH25K1se7
         a8SIkxmSFAnvbkEbGxpRA/CfaU12vydr8MwKSKAtcbj4GAHqpZoyTp8FuVhGiIZC0ZJ2
         dXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=hq3EgDXMF1+jcTFvY4w2kMpW6vFqDAJq24D6kljsps8=;
        b=D2bcghqDeHANtinf8DQC//lOwyrqzaRAjQ4tK9rZ11brhj0IWtkM792Gk2ki3PwDkn
         fhs4RB9cERqg90HGnLl8VCpCBUbu5/nhhmh/KYYmYL6xEfFc9GpESzF8vc0oTM6+gm2A
         q8ZDaopc8KpOb4c/lcyl7dcvAsLtBFhH3lqGZ5Aq5Gztp22QYfc9ML64an/U1wOhW+Tp
         7/pQ6TJfqWdOGEymMc+G+5s8RZdVLPdKoDEesTb3L9yv/9alq0YstO90z4V+HDcFv8UD
         BjHT22ltmCfZzP/zO2XAFhawcZZnDXT8r3y6ilkvsxRwh9VIoisC1irGuKgGxPCRcyUq
         +uyw==
X-Gm-Message-State: AOAM530SD03b+Uc6UTU9hO1MKhXQJyfWWnGJDVsKRc3dSD8pAOClODLM
        wTOTsi95jAosUvucxd2J9vIdqbiLvDFv0VYYyr0=
X-Google-Smtp-Source: ABdhPJwsxr1o/YdfLPK7zthyE1S6kw9YhQbjZZB1NpAarh0q0X/pcxhpdAhSX7Jx8WU7+3MxIOizCw==
X-Received: by 2002:a05:6a00:b85:b0:481:fc6:f100 with SMTP id g5-20020a056a000b8500b004810fc6f100mr4836156pfj.69.1635770084356;
        Mon, 01 Nov 2021 05:34:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id w5sm17249419pfu.85.2021.11.01.05.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 05:34:43 -0700 (PDT)
Message-ID: <617fdee3.1c69fb81.d1874.e16d@mx.google.com>
Date:   Mon, 01 Nov 2021 05:34:43 -0700 (PDT)
X-Google-Original-Date: Mon, 01 Nov 2021 12:34:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/77] 5.10.77-rc1 review
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

On Mon,  1 Nov 2021 10:16:48 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.77-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

