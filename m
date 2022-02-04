Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F11F4AA3EF
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 00:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377830AbiBDXEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 18:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377840AbiBDXEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 18:04:15 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9FEDF16704
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 15:04:14 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id p4-20020a4a8e84000000b002e598a51d60so6344912ook.2
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 15:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LLH8C4+l8RYV14uDg5g7U9UxpXvd6jKnz+PVszYki/Q=;
        b=HOTT/SkpvPtd0z+OcLUYk16o5WhQyx19AkvBGw3QmYtyeleGYLIdKvMSaHjTIi+jSo
         LjImssMA+BLEKCsg17CVih+75w4mMU/XmBY672S8L5uArytTeRh23pWqKasgB0ogWAGV
         dAuA4N0Cpn8cDE9Y0ZB95Z7G7vYa9j7od1w48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LLH8C4+l8RYV14uDg5g7U9UxpXvd6jKnz+PVszYki/Q=;
        b=BoV173PKWbxXz7m+CI1L1KdNp7jVcc5g9m71lhZDi4Gu3rlaqVhtEkj5mCWSEbgZCL
         gNQ2Gy60fqDDMv/hTSfoC/NCPiZapr46lGAGF6WVVt7oKFcnNJXr0JEtl0T3tFr4Xyjj
         wg+tGHOQ3/TQdXglbv5yxBNqqVBEsCu4sIJluer3mnNhSNLsxx/komC264DtXTrsXHQv
         158y5bOibnlb4vIBS93y6rIor12NpK44UkghfyPIq2bca5fNrbrY+K9TjVj1vjIGlnSd
         PNuqpn+Czk2KM0fMYddnAJfBBLfajdCfZ6xfjTw06Dpmq6g9jAMj0voPCA5pKiWz+JaF
         2bcA==
X-Gm-Message-State: AOAM533AweFcn7jzuK57qpGoTUfc5OQHdqiNc4xAIa9SYoNh4bBTgE9M
        3gETDsyFtQbloDqGA9iiHKsO+g==
X-Google-Smtp-Source: ABdhPJwm7qPZitamobK6zNpLesurkbaT4f3OVe/zY5ltkiL2nHlgmilSGxOX9f++hrWoXbCWTPtDGg==
X-Received: by 2002:a05:6870:1083:: with SMTP id 3mr322467oaq.101.1644015853978;
        Fri, 04 Feb 2022 15:04:13 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id cv13sm1060515oab.7.2022.02.04.15.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 15:04:13 -0800 (PST)
Date:   Fri, 4 Feb 2022 17:04:11 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
Message-ID: <Yf2w6zFSg+U1qyAY@fedora64.linuxtx.org>
References: <20220204091915.247906930@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:22:10AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
