Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77F76C3892
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 18:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCURsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 13:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCURsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 13:48:08 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291724A1C2
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:47:44 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 103-20020a9d0870000000b0069f000acf40so6538236oty.1
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 10:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1679420864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oh/NRypT41xqHY7iBI+4eeqSHLuP1WSz+18dRCjF/yk=;
        b=U960HkFExD4cUMhKJoYwJZ5BCAQOcY38BnjdWdlowG0QjMHx6JxQHjftx5kE6lmxpA
         FJBv124lwiBHtOsdYdNc17qHaKO4yRuKR7NndENcLWxMJznndJGGqUnnhexuQ5pKn650
         IJbql1auv/7Q3NgZnakIANEf6AtyXNyTWSRQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oh/NRypT41xqHY7iBI+4eeqSHLuP1WSz+18dRCjF/yk=;
        b=X15vALXYM5oax8dbAxe4aWnDjyZXLHtPSHsVUrpZ6hzYjRm8zEVkgTQj3mSgmrjTSU
         c3htSlA6GAIwmFwKnBkRK0kMHnCIRyMaDNcA34tARsV9IIsiiAw/fugRmkWHfRqHiSDl
         UwKYWLX9XIEVhakJd0mQLI9V4gXnUcSGZFgxDOsReNs70/vTcU+xtZdwxUcw9TGPkJAy
         Oh0Bu/Rtq7L39OUGRof5JievWDxBTOkMNYrV+Ccaib8bBdNVriFTCVbPkMOWmggkOw6j
         8DnN6AU8l7XL11kxWHRFl3C/aidR9QeYIoW4A8BRDngoefJaVprpcaPZIWi+nKR2Y4lq
         fcXw==
X-Gm-Message-State: AO0yUKUDPHPgB9o+YLT2s13GQOZoshQEsOpFIgwxn9nXOYCEn6vQzlnz
        LD0BqJEYqyHQ/8p+a4RORSns5w==
X-Google-Smtp-Source: AK7set/i5TBQzSzoNWAOLP7VH6qXuwvqxtDuxdnWQyD+FOv1VNFNbEhe8knorRi2x/EJgHc1QrIWyw==
X-Received: by 2002:a9d:6a07:0:b0:690:f7da:5390 with SMTP id g7-20020a9d6a07000000b00690f7da5390mr1742353otn.25.1679420863816;
        Tue, 21 Mar 2023 10:47:43 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id g4-20020a9d6c44000000b0069df89fe195sm5319452otq.37.2023.03.21.10.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:47:43 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 21 Mar 2023 12:47:41 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
Message-ID: <ZBntvcBaPgleWaa8@fedora64.linuxtx.org>
References: <20230321080604.493429263@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 09:39:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
