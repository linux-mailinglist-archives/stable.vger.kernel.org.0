Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B33561042D
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJ0VOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiJ0VNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:13:47 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9525B4C00A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 14:13:22 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-13be3ef361dso3942406fac.12
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 14:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zB1AivzTtphajm2G2kz8RRsMJzIbfs85BmIuGSD/wO4=;
        b=Cs7EMiWvFfqIHlpwJIWb8dnfR+OPKolPehJFBdEPI37HKANFjQg4Vh8VgrNrxt3sCk
         oFFs0Sl8MK83e2Omspild2lKSBgMRVmT8UN0H0AO9hSessdQFR8VsiRatoJ7zsA5h9eh
         BAVd6Gson13f26Dc669Hp3Ks9LhvMtHBpTxDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zB1AivzTtphajm2G2kz8RRsMJzIbfs85BmIuGSD/wO4=;
        b=zydcjOki3XS+UYLaO7zuI8HBzx81BIgGHdnlhWEqsuUxC7aftf1HqJfBQj70TAMvMf
         Tktxw56w7lr5GBy8F+yNLKbf9hQji+wImER/octCxzO56mkt+XdZqXdmNd65taja5RyQ
         /lRrXztqyhlv4yH/8L2MiyDgVsLZuYNraZtnJada2x73V1rRlAlAOXEah62m1eyB9fbM
         WCgi/R4wAZo1i+IfccIealijWBesrtZ4+6u2E+wSI6Z33CwCW5MXcMxqPeqnQ5STA9yy
         fQv20dI5ArhWxf5bESh11Fdt0Id5k8s+Le285z1eQd/ealeJzEoxOh13LwR0IDYN2/bW
         srlQ==
X-Gm-Message-State: ACrzQf3GLJLn56MrymLFbVRNCKdgFv/OpkW+5HKSiXk1P67LPdM7AWaa
        Qu1ufevqluGEjbo28XW/hqjKxg==
X-Google-Smtp-Source: AMsMyM7Eh2UuyqOlvlVZblNkItAMD7RsWn4BGRCJD8ET8t+7dRjsDLusY6Du1gJRq/5ltsz9b9gJpw==
X-Received: by 2002:a05:6871:6a4:b0:13b:a056:f97f with SMTP id l36-20020a05687106a400b0013ba056f97fmr6383939oao.38.1666905201958;
        Thu, 27 Oct 2022 14:13:21 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id y4-20020a544d84000000b0035485b54caesm824888oix.28.2022.10.27.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:13:13 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 27 Oct 2022 16:13:11 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <Y1r0Z3vdXuOcAjX9@fedora64.linuxtx.org>
References: <20221027165057.208202132@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.6-rc1.gz
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
