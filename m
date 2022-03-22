Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C344E3EC8
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 13:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiCVMxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 08:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiCVMwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 08:52:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3CEE0A0;
        Tue, 22 Mar 2022 05:51:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so1593331wmb.3;
        Tue, 22 Mar 2022 05:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mXOxA9dhcIU//9wO/6nBjT/9sW2++WcqVWWbkteTpF4=;
        b=PTySm2pBbOPDqt0o/EghML1Ko3W3Oq8TYmxfH96BRHcbBlAYa1gk2iKgmNWFuf5TOA
         LKj9YixfjUbhwGsq2pUA11pEUQjEkkkdDGvgTGgoSgvrPMCoUkwr85W6JcvmrLhdg70F
         2Bf5xT7BL9oc4st+1TR6CWRcbt9lFVP6M4+roOlmseucUm9p7Cs6Nr882de2Aik1JVNB
         TODp5hz0f+5z4CTBazjn+7bo4HW6FViGcZTsZHB4IEW1ceAVhEh8WFoF/Be1bYe7Wrfc
         vpj3Ctpc5YlyLwvfbEISDwc0eKMjVCl//+nv8XSbe0Fn7gg6nmdWihIeV7IMLMAjol6s
         7tWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mXOxA9dhcIU//9wO/6nBjT/9sW2++WcqVWWbkteTpF4=;
        b=1504JmAT3IdwLizOdcR2kJps2T/uAsaD4OtrDiDwOSzAmmWvdHJ+vwPT+ASonUDGZy
         vpej4JKuSc9PgqXKN1KsJMRT+T0Mw3F7fXZEZ6ZCl05EFzdWoiXXy5tct+ysGK09M5O3
         mPn8/4n0itQoqiySigY0iqMLmE3NK/K2hta/ejr3vW+BOZPGigT3r8iMplB+yaFSsCK5
         AncF0XDAfyPAOyUellGWvPg9YSRYYJCfrXqz7KOX9y+tyY72iKgDXCbskaDh1MWhpX31
         UAROD9vpSQtAkwhd4g2JRSpy1CsgGzxBGyC65snI6KSPxDUVRWLMFjs2xJHHTMEG3gWi
         HNmA==
X-Gm-Message-State: AOAM533T5oCj7zAe3IoXCaEvdq9pPn7PeMGo/UL14P+2sOuhMQdSDPzj
        vK4slHZOvPLXb4Qt60CiDl4=
X-Google-Smtp-Source: ABdhPJwW9rM/NDaXccIOO7vosxrwb2DZ7l4ISio/yDraGKTPkt4Ifkr0hwqP2Am0DI8vcJncUsZNfQ==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr3698832wmq.70.1647953475899;
        Tue, 22 Mar 2022 05:51:15 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b00380deeaae72sm2050190wmb.1.2022.03.22.05.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:51:15 -0700 (PDT)
Date:   Tue, 22 Mar 2022 12:51:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
Message-ID: <YjnGQds3PBWpif7l@debian>
References: <20220321133219.643490199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
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

On Mon, Mar 21, 2022 at 02:52:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 63 configs -> no new failure
arm (gcc version 11.2.1 20220314): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/924
[2]. https://openqa.qa.codethink.co.uk/tests/928


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

