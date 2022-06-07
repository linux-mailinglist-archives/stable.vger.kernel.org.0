Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF02E5422F8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347526AbiFHBN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835888AbiFGX5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:57:08 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382F144BDF;
        Tue,  7 Jun 2022 16:28:18 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y85so6858612iof.2;
        Tue, 07 Jun 2022 16:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=te17bPQlv3f8pwlehZAVfbTbJYH6mrgXuFHtUBqS2jo=;
        b=HyRkkGxdjb0WMg0vhnNHPdUlU1Acqmjbtwx1qYhshCIVQ7rnsP0EItQU/itNtn4Yfn
         SRg/Z7ekEPumiW7z/R7KMr2zL1V7Yx7kYJ3s1OhP9eGi5eAIISPYZNM0E6U1Dsbj5vox
         Pf4q6nrUb3EfDs/2wTrx1YnNipG6P+b6ZCTIvvMHzYZGGMnYb3xLvnkbLsa5SIuel6bi
         bBIcy3E6zDz3diAOCD8CFJwckC/2ouapSrBG8fVe3Oz2g2ybbQEmEkqyNRDf45c0DP6c
         C6QXifMAl6DpTtVM/15uy+9Zej9kNUPs9yRDavy/Gj26fAx78FBdhzLxPvEB6e6dQpmP
         /aZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=te17bPQlv3f8pwlehZAVfbTbJYH6mrgXuFHtUBqS2jo=;
        b=gFRGUJbr4YO5mjMd21JyQbod0tUVuou4AjfO6dckOaIXYU6mDfJAfg8L6VZoXdv3Xk
         +HPEf9uMkGhE7LQyLeouEGUNAY4E4pT4mhfBmZ2z0wsaKH/5iNgOEV7hfnDMAl8svRG2
         HnSDBhrNSxNUnv7nVKOXmHrtU9Klin7n6js0GmQpzJr6pdUqZZh+CKVKfX0IAd0CqqzO
         NcLtKW14eJnNZE6U4y2otlgVroYGZaKZ1xA1iUtDtlQI400dQY+IsAa2yE0rmsynnnTL
         Ue8EfvdFKoESB4PaeXlX0pqU6+gVmFwBLMLybAU1vgZ0Pka10inuODIEfOHh2OYAGMw/
         /hLg==
X-Gm-Message-State: AOAM532Dzg+2WH/VZncewRofW959ZceS+wC65AbP5+Yi4ypen5Nw5lkf
        VtdYXlOkW+iZD/EzsV8LCOoxYxBArQ7fUdkb+Q4=
X-Google-Smtp-Source: ABdhPJwYZKovJMbWY9dnw7zHN9LCiQVPtg9rmSGHiWGi3j9wW9IPjRxRmdA+a+Zc+cOS7Ituyw1CQg==
X-Received: by 2002:a5d:850f:0:b0:660:92e:5edc with SMTP id q15-20020a5d850f000000b00660092e5edcmr15041205ion.187.1654644497954;
        Tue, 07 Jun 2022 16:28:17 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id b14-20020a05663805ae00b00331d98c9a7fsm935138jar.40.2022.06.07.16.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:28:17 -0700 (PDT)
Message-ID: <629fdf11.1c69fb81.4e241.1bb2@mx.google.com>
Date:   Tue, 07 Jun 2022 16:28:17 -0700 (PDT)
X-Google-Original-Date: Tue, 07 Jun 2022 23:28:15 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/667] 5.15.46-rc1 review
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

On Tue,  7 Jun 2022 18:54:25 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.46 release.
> There are 667 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.46-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

