Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A89459EE0F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 23:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiHWVT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 17:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiHWVT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 17:19:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC0A53026;
        Tue, 23 Aug 2022 14:19:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pm13so6226673pjb.5;
        Tue, 23 Aug 2022 14:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=6FcH65dwxjDDW9xxK+2OOSLy68w1K9vVVP0/tjz9RF8=;
        b=IAVOQuapNQPJQ59AIbaoGUkcSZFYF/y5+kot9p+eIripq+MY7xg2Lu8k0RuEodO7aU
         z99I+tsZWI9+3KdjE8rCDvLy9iyJiuzeX5ilrN68VfMkWht89neduS1pCtOw+nRILhYb
         0z/sU7rzDT3F2G2lrocF3CguXbJlITiI56IR2mhWrVqFJz2M/J6SHPofIPKY1lonm5pR
         K4JTInp4pSfNi47VeTuJfMhFo3PtYd8mDKiGc5jmzUqPXqNfHlVOvmCgyPp6noCYmL3V
         Id6VnPsYkngimTQvxgElhJOV5RR0f/YAmplFHXOl7AkakT2roDgWIgShd983PPyL4L2P
         Eekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=6FcH65dwxjDDW9xxK+2OOSLy68w1K9vVVP0/tjz9RF8=;
        b=2dMBMU+nO55uuGESJbB9s0re/VDWz23U8Gth8DV55xggq8xfvTgjmNf7ZG+jmhEFyR
         7+iyPXZRdq1zupWkhC4Xczrdgu7o20nyy61ySj/DDuQJ7JneiOTN9lYhlhqqAOyp6gsF
         RGUculFaucO0jDQ0XcDO4h9/IeI0FAF0WjXU4I1RWjS4g4qVIqNxEd56IVe3jxVXEXuw
         7YwTJvs3NN1FVTc4mFu+IAblfH6wnpQI66SSPKGMFROq/5QnzfsMKpz6J8FBsPTScAff
         M9qTDfiIBak1hpntiKHywJIO21eOqgPpFXO4vp+uVZ87ZZ5KOfmjeKd35zewGtdltQN2
         TmZg==
X-Gm-Message-State: ACgBeo1O0udvcCBfKrcrcsYaHlR4Bh6qgB5tQ+N8GdKe8eXoccbfG/3t
        94ABRuLiKNJloLJQe1AfLDw=
X-Google-Smtp-Source: AA6agR527M4GYWYSvAkg6sy0AkBvZXPetuAXHNyFwaK0gDZoxrwrsHsYzy9A9dit6owqfPuT5G6L2g==
X-Received: by 2002:a17:90b:4f49:b0:1f5:c7c:b565 with SMTP id pj9-20020a17090b4f4900b001f50c7cb565mr5176084pjb.32.1661289564909;
        Tue, 23 Aug 2022 14:19:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b125-20020a62cf83000000b0053653c6b9f9sm7298146pfg.204.2022.08.23.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:19:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 23 Aug 2022 14:19:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/244] 5.15.63-rc1 review
Message-ID: <20220823211923.GB2439282@roeck-us.net>
References: <20220823080059.091088642@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:22:39AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.63 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 485 pass: 485 fail: 0

arch/um/kernel/um_arch.c:440:6: error: redefinition of 'apply_returns'

Guenter
