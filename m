Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8355B8520
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiINJgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiINJgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:36:10 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A018379;
        Wed, 14 Sep 2022 02:34:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id z14-20020a05600c0a0e00b003b486df42a3so6008067wmp.2;
        Wed, 14 Sep 2022 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kmvJ2i5qNx+TtqBPYiaV+mzGvISiYnETNZ0WDnJbQTQ=;
        b=g8/GnPdYkET5fl8L6iBsXvIwzIP5u5WeNVHr2852lJ4pOzBqRX8stn+TAbI01kBaUw
         OdIanaUJNWNOnybBsJUEJFxnBs1ZchwqJ0TQ27puZS/HizfU6MWuCLLrOiC1OHNGSNSH
         KVIUjC0wEo2/rKZOiwf/yVboDzVPMy1MATzK3WYfb9QN6SUpQz1MfDLs3vWi9nAAAWR8
         KKj6mJbb68G4Fpl5VEnJ32siJVfCAFMwqOtddNEmuZ7TmBL71w/sEHQptsoE9WlHh2jt
         j9S+ljXeV8iiFIsRx+CI1qLrnw6TwCBfbzKfPjYD/R99Atrw7gPLttyRrpvx2JZCXkJD
         BLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kmvJ2i5qNx+TtqBPYiaV+mzGvISiYnETNZ0WDnJbQTQ=;
        b=Du9MgCbEuKelo7XdS/Cb/azteO90nNLD6VlFYKql0XpIFfag8/rvRFQrelm371OXdb
         f6eh2nxwioDjZdrLf2T5hCEAjezyU05W3gbf/AhqY/ahAbybCheIpLa52phY6mUvp/g7
         2V9A1b0iU338gQgGQBtvSEkYinhoLHh32fIn45K6ps9e8soz7050EU6LKbyBBKJJaMoX
         3XaHIhg14jBt59QEtX2z2Do6KdVlFgGTgn3bES5XMrjt22WJS50t0u+gKm2ERXz8zYJY
         33BFXZV1Wo9ojpuOz8hjJAw58xCRzH3CAzTh877fgEfmK6b04YIPO1sPMLER9rmbn2fm
         kj3Q==
X-Gm-Message-State: ACgBeo2EzFua0Wo5NDkQ7b0AnR+6iiHt/9VT9A1S9qdUBG7vGJnHG4sp
        fs468aw/Smh1LNlD015QdIo=
X-Google-Smtp-Source: AA6agR6Ty/E0e8juaS33fD0vAQVyjXZj+utYZYlLoFxANfnSTAz+dpUDQjAxylRbo764s9BDa5TJ2g==
X-Received: by 2002:a7b:c4cc:0:b0:3b4:757b:492f with SMTP id g12-20020a7bc4cc000000b003b4757b492fmr2432394wmk.74.1663148039061;
        Wed, 14 Sep 2022 02:33:59 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c4fd300b003b3180551c8sm17296841wmq.40.2022.09.14.02.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:33:58 -0700 (PDT)
Date:   Wed, 14 Sep 2022 10:33:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/79] 4.19.257-rc1 review
Message-ID: <YyGgBMpc93Y+dtB0@debian>
References: <20220913140348.835121645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Sep 13, 2022 at 04:06:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1816


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
