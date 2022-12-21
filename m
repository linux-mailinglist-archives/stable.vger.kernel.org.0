Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFB6533C0
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 17:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiLUQEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 11:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiLUQEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 11:04:31 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7413311445
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:04:28 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id y194-20020a4a45cb000000b004a08494e4b6so2465987ooa.7
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 08:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJmsn58xKPbGHiKrj82Ko5wI0bke7L5N3g2n349swQQ=;
        b=VKZh8Z+o5HVhAYyL+Km4C+pZUd+tLLpykKq2K/NWLT0ihGl9RzIOi5JSJAcyYXbrbr
         t5eUzkVG7RqeD9P5pckYLyBQYGRLG36GEjIUPTJJqHneXFr3ZcS4nkHwNvOCqJO44CHj
         sbXsoUOqo6DrXBuRI1E4Kj/ceWeGFfg+MFf/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJmsn58xKPbGHiKrj82Ko5wI0bke7L5N3g2n349swQQ=;
        b=1FvhgRfaQOw8MFfj8gdPGGioagMUX+/Ak3W9vZ0Ru2KdYXSpxYdXN6cmWS8e6q392B
         Y6hHMoGI4vlzDudDo++CDJxA8QPOIpfcX9YHuhGuUmDosEnNz2Ln4DPToY+foW8qHVEl
         RBHWvzVSNutVXFkPZIBzDo/wTb8nXEwnSpEGiZP669g0Dlnu1txVcaALW6TcShMXjU7n
         iBbLw3KKIufxlx4fMvT3KT0GHOPGebUTavCoK6yN7R3mDpF6dmfrFkPrvS0OwjEpzGm0
         2bbHGMz/UJxTg82XqJKd6KaS43PokgYwPYKX8eNESjvlrh4Ve+PHWU46MYkyvZk2p40w
         tM6w==
X-Gm-Message-State: AFqh2kqIHEUhHcfeGEipqhEMl7uMSW7yBXeM0YatjevVLfBKaMnx0GaT
        oOJMMT8OnLE9l/aL0if/kWB0gg==
X-Google-Smtp-Source: AMrXdXvFCPfGpZRQD5dV4PjhY/izAVNd9gTVAqDtT3zxjxX8W42bImEfLYj6CVX1qzV+cfy5caAGYg==
X-Received: by 2002:a4a:43:0:b0:49f:8720:d5b2 with SMTP id 64-20020a4a0043000000b0049f8720d5b2mr1070027ooh.8.1671638667751;
        Wed, 21 Dec 2022 08:04:27 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a11-20020a4ab10b000000b0049fb39100a5sm6205846ooo.37.2022.12.21.08.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 08:04:27 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 21 Dec 2022 10:04:25 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6MuiZJZ/6wLsXpu@fedora64.linuxtx.org>
References: <20221219182944.179389009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
