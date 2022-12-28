Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F7665855A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiL1RqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiL1RqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:46:03 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB30D295
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:46:02 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id m7-20020a9d73c7000000b00683e2f36c18so5196541otk.0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hktmi1mDWEQ8qwdg9mZzks2OK4SXe1q5Hw3gXYtRiT0=;
        b=efYaS8Fb6JfjjHYihQk5LcbjU38l8jbbQiDioE6MlxNVntrWk2F9tskuUcNzcAZJ8F
         GRX7cgEVBnjRmzFE8vJMdXx4+3Q0zG1GjArOxpwb2M52ewTUAX5xsKbGZWOJw2MqXr+j
         15HQ8Q06QRJXrt0Qquj0whAGUf3zETIk9nwdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hktmi1mDWEQ8qwdg9mZzks2OK4SXe1q5Hw3gXYtRiT0=;
        b=pnq86pR7O4sNKx/l8QLi8DN2/ctnmwa6BP18DPnF+ZZ4LsujTS+2AwXCGKlZqNu/xe
         bBbOu8F+b8B1lVtDsujCz9PS5jwudthKzCQE2YJVSy0liQ/uxim5H2ZCeSe9Ebgy9cEo
         Wjb8VBBGshtEBqt7vthcy5+b+W+U3nBhJ4UjQKe/MT6v7NW5IkSynV6gzk4KFgTkUFXP
         kxrF9nTTyHRJPcF6Ycrzm/TNmBsx3r5peF2KkvWHgv87rDYEMcDtzR/9HllOXie6kFT7
         1j991zkBGiljY4BWL8oX/yGhJXrXVNBc0gB2P5K1eeLdznbFQIOaVx0e0qKLM5NS21sO
         wWOQ==
X-Gm-Message-State: AFqh2koIZxgrYxY2R4pm/ckSKcnYEl3nP9EKxs5LXsGD4QQERjBuSr1G
        zdH9hLJOWD6ogrt7GEXtZmJ0aQ==
X-Google-Smtp-Source: AMrXdXvG33jK51PPCn7jtwiS4DBfA8WEOTNGAGMmunkhu3PBsPJwaoWBVocUK52y7GkmHIMBx1l1jg==
X-Received: by 2002:a05:6830:562:b0:670:8270:1292 with SMTP id f2-20020a056830056200b0067082701292mr20257024otc.4.1672249562148;
        Wed, 28 Dec 2022 09:46:02 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e26-20020a9d6e1a000000b0066b9a6bf3bcsm8016802otr.12.2022.12.28.09.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 09:46:01 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 28 Dec 2022 11:46:00 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y6yA2Pc+9xBjChlQ@fedora64.linuxtx.org>
References: <20221228144330.180012208@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
