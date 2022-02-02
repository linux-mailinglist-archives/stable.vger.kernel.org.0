Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348954A69F0
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 03:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbiBBCem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 21:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiBBCem (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 21:34:42 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39331C061714;
        Tue,  1 Feb 2022 18:34:42 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id y17so15922620ilm.1;
        Tue, 01 Feb 2022 18:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QIYUzk06jhJsIFqt1jC+AKnwuPSsXKuhreuTZhRBfgY=;
        b=eiK1djeSqkgN1jM4CTkkoBKF03ioGa8Kc0wYwLOvOFbLD5dc0ZyNth0GokLzpeNjiK
         e2AVDGZM7gCwRuZ+ShEBYVAu+OY91ik+S5F93wDGdo5cXX9Xnxu54QtmqWdOVkh5wmFb
         HPKSHdTNFpBsqsTyGjGLHh/tFGcz5Iz5ADMNbJuvFs1NzOC2S/UViVzrlXa11QPtsTQE
         yOzYdpdSCmLWV0hhExf5/L/7LZzawFzTD7JjIdXP5Q8tJHz94AHMgmGCk6mY210m/MS8
         LNRN5XqjuAZVes/BLnQ88ROP+Jvnmw9UtDE1zJvDHJtdk7Idk2ICL7RAfFDi0PuLn35a
         QwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=QIYUzk06jhJsIFqt1jC+AKnwuPSsXKuhreuTZhRBfgY=;
        b=037v7w8L+qhhP5DRv3I74QGaYZcdI4rel4NniapamNr3nueowAbOh1cOgZoR7Sb8NL
         R+GFxxN1WDdnXRT2iEcMLlI4DrSs7QsjAAfl+L7l6TsCD+nw0ITSLJOKoIwZPSZWj64r
         kYfb5h9fC7BnkfSO8WdqCAMpy5kCexaT2uo8l16QjG5hkmXxbc5MA46KRiZ9sizyzpOO
         6MU4UWPgp9CavD9bHutnV/C5Sj7FuX4liNelj7fjU3JIMlu3eUz32EUJuLCABymPj4w5
         IHL1hwQnvFgkBRCLa2vrBamoNOJsxsxnHGKUBrN7pFMn68pzffVtSWK/kO/GTyfPUxiA
         /NeA==
X-Gm-Message-State: AOAM531AT24U4Dx0jFz40glQ0MYmmyIwu0zi1WJj8I9mkyJWsuKafWom
        VmKI8a4iJyMm7UDPnjAIJMH9HUpZXrWxUM9BjDA=
X-Google-Smtp-Source: ABdhPJzU0BTGTfcGTQewSM5sz+mKynFQQ9gbyJklNUgT7V3nGF5DM2MSaWoRQrr37HZBD+8onyGr0A==
X-Received: by 2002:a05:6e02:17c6:: with SMTP id z6mr4650383ilu.93.1643769281173;
        Tue, 01 Feb 2022 18:34:41 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id g5sm22067450ila.59.2022.02.01.18.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 18:34:40 -0800 (PST)
Message-ID: <61f9edc0.1c69fb81.66df.06d9@mx.google.com>
Date:   Tue, 01 Feb 2022 18:34:40 -0800 (PST)
X-Google-Original-Date: Wed, 02 Feb 2022 02:34:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/100] 5.10.96-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:55:21 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.96-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

