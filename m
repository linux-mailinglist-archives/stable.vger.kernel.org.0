Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A514D9C9F
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbiCONvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348820AbiCONu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:50:57 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B253136D;
        Tue, 15 Mar 2022 06:49:45 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id b5so13321507ilj.9;
        Tue, 15 Mar 2022 06:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=GxhzMMCRxWyv25ftHfQam+a9DFEwcb//2QAxW1fgZ20=;
        b=okbP8FUeE+Uf0s1bOeO+nY7pBYjFoilHSVwjTJVqAzNefcyDe7OyA4eveKnCj8Rbup
         IjhOfcVim3fkXbWditJdJ9oeKSW6A/G/Bz2uIe9Y4Gio5YyAyEtrbt6MO03TXwgamjNK
         IIUY0Uo9avKXwFqjZ44133zM/YLhuK7ZJv9iY2lvWt/xrlZKNBQKO3662WXzZh4oZE1k
         opEj5yoUr3PL+5K1eUwwF/5fn6TXI+lcT3fnvFbRNTSKznpBrsKLLKSSVajmE+GR3zLv
         oFxZ7eC6MMjBcok5aTQQyaP6IzvyjKKQPr4NksC0vlfkt/ySS0KefFSAx1edK1/pAUJ9
         SgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=GxhzMMCRxWyv25ftHfQam+a9DFEwcb//2QAxW1fgZ20=;
        b=wrs8dhcjlGpwPsrT0i7WecjwSzAWdfVIG/XFtRj2Xw53ymagw6aWHbz9SoOc3LgEjc
         9M40p/jTPwppDC+DXmMrTzqxGi/IXZVY2ayQvl10xdNJHUgBx0AmJX9fClO4aRg0ePCf
         /YE2Zcl4VFgLftHvcqpI0jRLQG/mSl6xP3DDzpeVM+RbzeBnXwf1GzUT7SayjGlB9Jxq
         1NdRGPJ5HoocR2Ah5xCeVQQ2FBeLxtV8JQvTmavGcpa2aq72EtAYKPuwMTkPUfPibZbW
         nDT+PNuHf6lJyyWI4xYHBTZP6hMwV3u2QVRBxPGub1NI6tj1/r1QXZ7z1VnSz5sFcrWK
         3nIA==
X-Gm-Message-State: AOAM533FMdx7OJdtF8xx5796WFtelG4hJcRERYB+Dde6j//a+axMc03m
        2hKvEGBFbImFYgyFxq3qVpQh/liAjhT1L1zzwX6X+A==
X-Google-Smtp-Source: ABdhPJyR08WmRAm4o3b1HF2TWQyeADX5eTi3c+So0rVTxfSKnFwFQCFiUZOW6QX5+u79X2w7uCmobQ==
X-Received: by 2002:a05:6e02:216f:b0:2c7:7a3f:2a94 with SMTP id s15-20020a056e02216f00b002c77a3f2a94mr16039753ilv.267.1647352184335;
        Tue, 15 Mar 2022 06:49:44 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id i3-20020a056602134300b0064620a85b6dsm10360674iov.12.2022.03.15.06.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 06:49:43 -0700 (PDT)
Message-ID: <62309977.1c69fb81.71db4.bed2@mx.google.com>
Date:   Tue, 15 Mar 2022 06:49:43 -0700 (PDT)
X-Google-Original-Date: Tue, 15 Mar 2022 13:49:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/110] 5.15.29-rc1 review
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

On Mon, 14 Mar 2022 12:53:02 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.29-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

